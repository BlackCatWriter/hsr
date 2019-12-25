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
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.service.PatentService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
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
@RequestMapping(value = "${adminPath}/oa/patent")
public class PatentController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected PatentService patentService;

	@Autowired
	protected ProjectService projectService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	/**
	 * 进入申请页
	 * 
	 * @param patent
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "form", "" })
	public String form(Patent patent, Model model) {
		patent.setOffice(UserUtils.getUser().getOffice());
		patent.setOfficeName(UserUtils.getUser().getOffice().getName());
		model.addAttribute("patent", patent);
		List<Project> projectList = projectService.findOwnedApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/patentForm";
	}
	
	/**
	 * 进入edit页面
	 * 
	 * @param patent
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Patent patent, Model model) {
		setUserListInTask(patent);
		model.addAttribute("patent", patent);
		List<Project> projectList = projectService.findOwnedApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/patentEditForm";
	}
	
	/**
	 * 创建
	 * 
	 * @param patent
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Patent patent) {
			patentService.editPatent(patent);
			return "redirect:" + Global.getAdminPath() + "/oa/patent/form";
	}
	
	@ModelAttribute("patent")
	public Patent get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Patent) patentService.findOne(id);
		} else {
			return new Patent();
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
		Patent patent = (Patent) patentService.findOne(new Long(id));
		Map<String, Object> variables = taskService.getVariables(taskId);
		patent.setVariables(variables);
		setUserListInTask(patent);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		model.addAttribute("patent", patent);
		model.addAttribute("taskId", taskId);
		model.addAttribute("patentId", id);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/patentForm";
	}

	/**
	 * 创建
	 * 
	 * @param patent
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Patent patent, RedirectAttributes redirectAttributes) {

		if(patent.getProject()!=null&&patent.getProject().getId()==null){
			patent.setProject(null);
		}

		try {
			if(Global.getProcessEable()){
				patent.setDelFlag("2");
				patentService.save(patent);
			}else{
				Map<String, Object> variables = new HashMap<String, Object>();
				ProcessInstance processInstance = patentService.save(patent,
						variables, ProcessDefinitionKey.Patent);
				addMessage(redirectAttributes,
						"流程已启动，流程ID：" + processInstance.getId());
			}
		} catch (Exception e) {
			logger.error("启动流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/patent/form";
	}

	/**
	 * 进入任务列表页
	 * 
	 * @param patent
	 */
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/patentTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		List<Patent> results = patentService.findTodoTasks(userId,
				ProcessDefinitionKey.Patent);
		mav.addObject("patent", results);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" })
	public String list(Patent patent, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Patent> page = patentService.find(new Page<Patent>(request,
				response), patent);
		model.addAttribute("page", page);
		return "modules/oa/patentList";
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "selflist" })
	public String selfList(Patent patent, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Patent> page = patentService.findForSelf(new Page<Patent>(request,
				response), patent);
		model.addAttribute("page", page);
		return "modules/oa/patentList";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getPatent(@PathVariable("id") Long id) {
		Patent patent = (Patent) patentService.findOne(id);
		setUserListInTask(patent);
		if (patent.getVariables().get("officeName") != null) {
			Long officeID = Long.valueOf(patent.getVariables()
					.get("officeName").toString());
			Office office = officeService.get(officeID);
			patent.setOfficeName(office.getName());
			patent.setOffice(office);
			patentService.savePatent(patent);
		} else {
			patent.setOfficeName(patent.getOffice().getName());
		}
		return JsonMapper.getInstance().toJson(patent);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getPatentWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Patent patent = (Patent) patentService.findOne(id);
		setUserListInTask(patent);
		Map<String, Object> variables = taskService.getVariables(taskId);
		patent.setVariables(variables);
		patent.setOfficeName(patent.getOffice().getName());
		return JsonMapper.getInstance().toJson(patent);
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
			patentService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete patentId {}, variables={}",
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
				&& patentService.getPatentByPatentName(title) == null) {
			return "true";
		}
		return "false";
	}

	@Override
	public BaseOAService getService() {
		return patentService;
	}

	private void setUserListInTask(Patent patent) {
		String strOtherAuthor = UserUtils.getDisplayNameForUserList(patent
				.getOtherAuthor());
		String strCo_author = UserUtils.getDisplayNameForUserList(patent
				.getOtherAuthor());
		String strAuthor1 = UserUtils.getDisplayNameForUserList(patent
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(patent
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(patent
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(patent
				.getWeightBelong());
		patent.setOtherAuthorDisplayName(strOtherAuthor);
		patent.setCo_authorDisplayName(strCo_author);
		patent.setAuthor1DisplayName(strAuthor1);
		patent.setAuthor2DisplayName(strAuthor2);
		patent.setAuthor3DisplayName(strAuthor3);
		patent.setWeightBelongDisplayName(strWeightBelong);
	}
}
