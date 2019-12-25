package com.ndtl.yyky.modules.oa.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.ThesisService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 论文登记Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/thesis")
public class ThesisController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected ThesisService thesisService;

	@Autowired
	protected ProjectService projectService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	/**
	 * 进入申请页
	 * 
	 * @param thesis
	 * @param model
	 * @return
	 */
	@RequiresPermissions("oa:thesis:view")
	@RequestMapping(value = { "form", "" })
	public String form(Thesis thesis, Model model) {
		thesis.setOffice(UserUtils.getUser().getOffice());
		thesis.setOfficeName(UserUtils.getUser().getOffice().getName());
		model.addAttribute("thesis", thesis);
		List<Project> projectList = projectService.findOwnedApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/thesisForm";
	}
	
	/**
	 * 进入edit页面
	 * 
	 * @param thesis
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Thesis thesis, Model model) {
		setUserListInTask(thesis);
		model.addAttribute("thesis", thesis);
		List<Project> projectList = projectService.findOwnedApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/thesisEditForm";
	}
	
	/**
	 * 创建
	 * 
	 * @param thesis
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Thesis thesis) {
			thesisService.editThesis(thesis);
			return "redirect:" + Global.getAdminPath() + "/oa/thesis/form";
	}
	
	@ModelAttribute("thesis")
	public Thesis get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Thesis) thesisService.findOne(id);
		} else {
			return new Thesis();
		}
	}

	/**
	 * 进入重新申请
	 * 
	 * @param id
	 * @param taskId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "formModify/{id}/{taskId}" })
	public String formModify(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		Thesis thesis = (Thesis) thesisService.findOne(new Long(id));
		Map<String, Object> variables = taskService.getVariables(taskId);
		thesis.setVariables(variables);
		setUserListInTask(thesis);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		model.addAttribute("thesis", thesis);
		model.addAttribute("taskId", taskId);
		model.addAttribute("thesisId", id);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/thesisForm";
	}

	/**
	 * 创建
	 * 
	 * @param thesis
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("oa:thesis:edit")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Thesis thesis, RedirectAttributes redirectAttributes) {
		if(thesis.getProject()!=null&&thesis.getProject().getId()==null){
			thesis.setProject(null);
		}
		try {
			if(Global.getProcessEable()){
				thesis.setDelFlag("2");
				thesisService.save(thesis);
			}else {
				Map<String, Object> variables = new HashMap<String, Object>();
				ProcessInstance processInstance = thesisService.save(thesis,
						variables, ProcessDefinitionKey.Thesis);
				addMessage(redirectAttributes,
						"流程已启动，流程ID：" + processInstance.getId());
			}
		} catch (Exception e) {
			logger.error("启动流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/thesis/form";
	}

	/**
	 * 进入任务列表页
	 * 
	 * @param thesis
	 */
	@RequiresPermissions("oa:thesis:view")
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/thesisTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		List<Thesis> results = thesisService.findTodoTasks(userId,
				ProcessDefinitionKey.Thesis);
		mav.addObject("thesis", results);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequiresPermissions("oa:thesis:view")
	@RequestMapping(value = { "list" })
	public String list(Thesis thesis, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Thesis> page = thesisService.find(new Page<Thesis>(request,
				response), thesis);
		model.addAttribute("page", page);
		return "modules/oa/thesisList";
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "selflist" })
	public String selfList(Thesis thesis, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Thesis> page = thesisService.findForSelf(new Page<Thesis>(request,
				response), thesis);
		model.addAttribute("page", page);
		return "modules/oa/thesisList";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getThesis(@PathVariable("id") Long id) {
		Thesis thesis = (Thesis) thesisService.findOne(id);
		setUserListInTask(thesis);
		if (thesis.getVariables().get("officeName") != null) {
			Long officeID = Long.valueOf(thesis.getVariables()
					.get("officeName").toString());
			Office office = officeService.get(officeID);
			thesis.setOfficeName(office.getName());
			thesis.setOffice(office);
			thesisService.saveThesis(thesis);
		} else {
			thesis.setOfficeName(thesis.getOffice().getName());
		}
		return JsonMapper.getInstance().toJson(thesis);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getThesisWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Thesis thesis = (Thesis) thesisService.findOne(id);
		setUserListInTask(thesis);
		Map<String, Object> variables = taskService.getVariables(taskId);
		thesis.setVariables(variables);
		thesis.setOfficeName(thesis.getOffice().getName());
		return JsonMapper.getInstance().toJson(thesis);
	}

	/**
	 * 完成任务
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "complete/{id}", method = { RequestMethod.POST,
			RequestMethod.GET })
	@ResponseBody
	public String complete(@PathVariable("id") Long id, Variable var) {
		try {
			Map<String, Object> variables = var.getVariableMap();
			thesisService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete thesisId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

	// ajax methods
	@ResponseBody
	@RequestMapping(value = "checkTitle")
	public String checkTitle(String oldTitle, String title) {
		if (title != null && title.equals(oldTitle)) {
			return "true";
		} else if (title != null
				&& thesisService.getThesisByThesisName(title) == null) {
			return "true";
		}
		return "false";
	}

	@Override
	public BaseOAService getService() {
		return thesisService;
	}

	private void setUserListInTask(Thesis thesis) {
		String strCo_author = UserUtils.getDisplayNameForUserList(thesis
				.getCo_author());
		String strAuthor1 = UserUtils.getDisplayNameForUserList(thesis
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(thesis
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(thesis
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(thesis
				.getWeightBelong());
		thesis.setCo_authorDisplayName(strCo_author);
		thesis.setAuthor1DisplayName(strAuthor1);
		thesis.setAuthor2DisplayName(strAuthor2);
		thesis.setAuthor3DisplayName(strAuthor3);
		thesis.setWeightBelongDisplayName(strWeightBelong);
	}
}
