package com.ndtl.yyky.modules.oa.web;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.ProjectData;
import com.ndtl.yyky.modules.oa.service.BookService;
import com.ndtl.yyky.modules.oa.service.ProjectDataService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 论文登记Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/projectData")
public class ProjectDataController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected ProjectDataService projectDataService;

	@Autowired
	protected BookService bookService;

	@Autowired
	protected ProjectService projectService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	/**
	 * 浏览
	 * 
	 * @param projectData
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "check"})
	public String form(ProjectData projectData, Model model) {
		projectData = projectDataService.findByDataId(projectData.getId());
		model.addAttribute("projectData", projectData);
		return "modules/oa/projectContractForm";
	}
	
	/**
	 * 进入edit页面
	 * 
	 * @param projectData
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(ProjectData projectData, Model model) {
		projectData = projectDataService.findByDataId(projectData.getId());
		model.addAttribute("projectData", projectData);
		return "modules/oa/projectContractEditFrom";
	}

	
	@ModelAttribute("projectData")
	public ProjectData get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (ProjectData) projectDataService.findOne(id);
		} else {
			return new ProjectData();
		}
	}

	/**
	 * 创建
	 * 
	 * @param projectData
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(ProjectData projectData, RedirectAttributes redirectAttributes) {
		if(projectData.getProject()!=null&&projectData.getProject().getId()==null){
			projectData.setProject(null);
		}
		if (projectData.getContentContract() != null) {
			projectData.setContentContract(
					StringEscapeUtils.unescapeHtml4(projectData.getContentContract()));
		}
		if (projectData.getContentProgress() != null) {
			projectData.setContentProgress(
					StringEscapeUtils.unescapeHtml4(projectData.getContentProgress()));
		}
		if (projectData.getContentSummary() != null) {
			projectData.setContentSummary(
					StringEscapeUtils.unescapeHtml4(projectData.getContentSummary()));
		}
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = projectDataService.save(projectData, variables,
						ProcessDefinitionKey.ProjectData);
			addMessage(redirectAttributes,
						"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/projectData/list";
	}

	/**
	 * 进入任务列表页
	 * 
	 * @param session
	 */
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/projectDataTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		List<ProjectData> results = projectDataService.findTodoTasks(userId,
				ProcessDefinitionKey.ProjectData);
		mav.addObject("projectData", results);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" , "" })
	public String list(ProjectData projectData, HttpServletRequest request,
					   HttpServletResponse response, Model model) {

		Page<ProjectData> page = projectDataService.find(new Page<ProjectData>(request,
				response), projectData, true);

		model.addAttribute("page", page);
		return "modules/oa/projectContractList";
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
		ProjectData projectData = (ProjectData) projectDataService.findOne(new Long(id));
		Map<String, Object> variables = taskService.getVariables(taskId);
		projectData.setVariables(variables);
		model.addAttribute("projectData", projectData);
		model.addAttribute("taskId", taskId);
		model.addAttribute("projectDataId", id);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/projectContractEditFrom";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getProjectData(@PathVariable("id") Long id) {
		ProjectData projectData = (ProjectData) projectDataService.findOne(id);
		if (projectData.getVariables().get("officeName") != null) {
			Long officeID = Long.valueOf(projectData.getVariables().get("officeName")
					.toString());
			Office office = officeService.get(officeID);
			projectData.setOfficeName(office.getName());
			projectData.setOffice(office);
			projectDataService.saveProjectData(projectData);
		} else {
			projectData.setOfficeName(projectData.getOffice().getName());
		}
		return JsonMapper.getInstance().toJson(projectData);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getBookWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		ProjectData projectData = (ProjectData) projectDataService.findOne(id);
		Map<String, Object> variables = taskService.getVariables(taskId);
		projectData.setVariables(variables);
		projectData.setOfficeName(projectData.getOffice().getName());
		return JsonMapper.getInstance().toJson(projectData);
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
			projectDataService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete projectDataId {}, variables={}",
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
				&& bookService.getBookByBookName(title) == null) {
			return "true";
		}
		return "false";
	}

	@Override
	public BaseOAService getService() {
		return projectDataService;
	}

}
