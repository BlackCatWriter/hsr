package com.ndtl.yyky.modules.oa.web;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.ProjectToUser;
import com.ndtl.yyky.modules.oa.entity.enums.ProjectStatus;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.ProjectToUserService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.FileMeta;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.oa.web.model.ProjectModel;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 项目登记Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/project")
public class ProjectController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected ProjectService projectService;

	@Autowired
	protected ProjectToUserService projectToUserService;

	@Autowired
	protected SystemService systemService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected RuntimeService runtimeService;

	@Autowired
	protected TaskService taskService;

	String files = null;
	FileMeta fileMeta = null;

	@RequiresPermissions("oa:project:view")
	@RequestMapping(value = { "form" })
	public String form(Project project, Model model) {
		project.setOffice(UserUtils.getUser().getOffice());
		project.setOfficeName(UserUtils.getUser().getOffice().getName());
		model.addAttribute("project", project);
		model.addAttribute("form", true);
		return "modules/oa/projectForm";
	}

	/**
	 * 进入edit页面
	 * 
	 * @param project
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Project project, Model model) {
		setUserListInTask(project);
		model.addAttribute("project", project);
		model.addAttribute("form", true);
		return "modules/oa/projectEditForm";
	}

	/**
	 * 创建
	 * 
	 * @param project
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Project project) {
		projectService.editProject(project);
		return "redirect:" + Global.getAdminPath() + "/oa/project/form";
	}

	@ModelAttribute("project")
	public Project get(@RequestParam(required = false) Long id) {
		if (id != null) {
			try {
				return (Project) projectService.findOne(id);
			} catch (Exception e) {
				logger.error("获取项目异常：", e);
			}
		}
		return new Project();
	}

	@RequestMapping(value = { "formModify/{id}/{taskId}" })
	public String formModify(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		initFormPage(id, taskId, model, "modify");
		return "modules/oa/projectForm";
	}

	@RequestMapping(value = { "formAudit/{id}/{taskId}" })
	public String formAudit(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		initFormPage(id, taskId, model, "audit");
		return "modules/oa/projectForm";
	}

	@RequestMapping(value = { "forAudit/{id}" })
	public String forAudit(@PathVariable("id") Long id, Model model) {
		initFormPage(id, "", model, "forAudit");
		ProjectToUser result = getProjectToUserForCurrentUser(id);
		if (result != null) {
			model.addAttribute("projectToUser", result);
		}
		return "modules/oa/projectForm";
	}

	@RequestMapping(value = "saveProjectToUser", method = RequestMethod.POST)
	public String saveProjectToUser(ProjectToUser projectToUser,
			RedirectAttributes redirectAttributes, Model model) {
		Long projectId = projectToUser.getProject().getId();
		projectToUserService.save(projectToUser);
		addMessage(redirectAttributes, "保存成功！");
		return "redirect:" + Global.getAdminPath() + "/oa/project/forAudit/"
				+ projectId;
	}

	@RequestMapping(value = "submitProjectToUser", method = RequestMethod.POST)
	public String submitProjectToUser(ProjectToUser projectToUser,
			RedirectAttributes redirectAttributes) {
		projectToUser.setFinished(true);
		projectToUserService.save(projectToUser);
		addMessage(redirectAttributes, "提交成功！");
		return "redirect:" + Global.getAdminPath() + "/oa/project/task";
	}

	@RequiresPermissions("oa:project:edit")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Project project, RedirectAttributes redirectAttributes) {
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			project.setStatus(ProjectStatus.CREATE);
			ProcessInstance processInstance = projectService.save(project,
					variables, ProcessDefinitionKey.Project);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动项目申请流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/project/form";
	}

	@RequiresPermissions("oa:project:view")
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/projectTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		@SuppressWarnings("unchecked")
		List<Project> results = (List<Project>) projectService.findTodoTasks(
				userId, ProcessDefinitionKey.Project);
		ProjectModel projectModel = new ProjectModel();
		for (Project project : results) {
			if (project.getTask().getTaskDefinitionKey().equals("kjDeptAudit")
					|| project.getTask().getTaskDefinitionKey()
							.equals("deptLeaderAudit")
					|| project.getTask().getTaskDefinitionKey()
							.equals("modifyApply")) {
				projectModel.getKjkAuditProjects().add(project);
			} else if (project.getTask().getTaskDefinitionKey()
					.equals("hosAudit")) {
				projectModel.getHosAuditProjects().add(project);
			} else if (project.getTask().getTaskDefinitionKey()
					.equals("lxAudit")) {
				projectModel.getLxAuditProjects().add(project);
			}
		}
		List<ProjectToUser> assignedProjects = projectToUserService
				.findByUserId(Long.valueOf(userId));
		for (ProjectToUser ptu : assignedProjects) {
			projectModel.getAssignedProject().add(ptu.getProject());
		}
		mav.addObject("projectModel", projectModel);
		return mav;
	}

	@RequestMapping(value = { "editStatus" })
	public String editStatus(ProjectModel model,
			RedirectAttributes redirectAttributes) {
		String status = model.getProjectStatus();
		for (Long p : model.getLxProjectIds()) {
			Project project = (Project) projectService.findOne(p);
			project.setProcessStatus(status);
			projectService.save(project);
		}
		projectService.refresh();
		return "redirect:" + Global.getAdminPath() + "/oa/project/task";
	}

	@RequestMapping(value = { "assign" })
	public String assign(ProjectModel model,
			RedirectAttributes redirectAttributes) {
		List<User> users = Lists.newArrayList();
		List<Project> projects = Lists.newArrayList();
		String userIds = model.getUsers();
		for (String id : userIds.split(",")) {
			if (id.matches("\\d*")) {
				User user = systemService.findUserById(Long.valueOf(id));
				users.add(user);
			}
		}
		for (Long p : model.getHosProjectIds()) {
			Project project = (Project) projectService.findOne(p);
			projects.add(project);
		}

		List<ProjectToUser> rtus = Lists.newArrayList();
		for (User user : users) {
			for (Project project : projects) {
				if (!exists(user, project)) {
					ProjectToUser ptu = new ProjectToUser();
					ptu.setUser(user);
					ptu.setProject(project);
					rtus.add(ptu);
				}
			}
		}
		projectToUserService.save(rtus);
		projectService.refresh();
		systemService.refresh();
		return "redirect:" + Global.getAdminPath() + "/oa/project/task";
	}

	private boolean exists(User u, Project p) {
		for (ProjectToUser ptu : p.getProjectToUser()) {
			if (ptu.getUser().getId().equals(u.getId())) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" , "" })
	public String list(Project project, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Project> page = projectService.find(new Page<Project>(request,
				response), project);
		model.addAttribute("page", page);
		return "modules/oa/projectList";
	}

	@RequestMapping(value = { "projectMgmt/{id}/{type}" })
	public String projectMgmt(@PathVariable("id") Long id,
			@PathVariable("type") String type, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Project project = projectService.findOne(id);
		model.addAttribute("project", project);
		model.addAttribute("type", type);
		return "modules/oa/projectMgmtForm";
	}

	@RequestMapping(value = "saveForFile", method = RequestMethod.POST)
	public String saveForFile(Project project, String type,
			RedirectAttributes redirectAttributes) {
		try {
			Project p = projectService.findOne(project.getId());
			if (type.equals("midTemplete")) {
				p.setMidTermFileTemplete(project.getMidTermFileTemplete());
				p.setNotice("1");
			}
			if (type.equals("mid")) {
				p.setMidTermFile(project.getMidTermFile());
				p.setNotice("2");
			}
			if (type.equals("endTemplete")) {
				p.setEndFileTemplete(project.getEndFileTemplete());
				p.setNotice("3");
			}
			if (type.equals("end")) {
				p.setEndFile(project.getEndFile());
				p.setNotice("4");
			}
			projectService.save(p);
			projectService.refresh();
			addMessage(redirectAttributes, "附件保存成功");
		} catch (Exception e) {
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/expense";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getProject(@PathVariable("id") Long id) {
		Project project = (Project) projectService.findOne(id);
		setUserListInTask(project);
		project.setOfficeName(project.getOffice().getName());
		return JsonMapper.getInstance().toJson(project);
	}

	@RequestMapping(value = "detailPTU/{id}")
	@ResponseBody
	public String getProjectToUser(@PathVariable("id") Long id) {
		ProjectToUser projectToUser = (ProjectToUser) projectToUserService
				.findOne(id);
		return JsonMapper.getInstance().toJson(projectToUser);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getProjectWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Project project = (Project) projectService.findOne(id);
		setUserListInTask(project);
		Map<String, Object> variables = taskService.getVariables(taskId);
		project.setVariables(variables);
		return JsonMapper.getInstance().toJson(project);
	}

	@RequestMapping(value = "complete/{id}", method = { RequestMethod.POST,
			RequestMethod.GET })
	@ResponseBody
	public String complete(@PathVariable("id") Long id, Variable var) {
		try {
			Map<String, Object> variables = var.getVariableMap();
			projectService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete projectId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

	@Override
	public BaseOAService getService() {
		return projectService;
	}

	private boolean isAssigned(Project project) {
		for (ProjectToUser ptu : project.getProjectToUser()) {
			if (ptu.getUser().getId().equals(UserUtils.getUser().getId())
					&& !ptu.getFinished()) {
				return true;
			}
		}
		return false;
	}

	private ProjectToUser getProjectToUserForCurrentUser(Long projectId) {
		Project project = (Project) projectService.findOne(projectId);
		for (ProjectToUser ptu : project.getProjectToUser()) {
			if (ptu.getUser().getId().equals(UserUtils.getUser().getId())) {
				return ptu;
			}
		}
		return null;
	}

	private void initFormPage(Long id, String taskId, Model model, String type) {
		Project project = (Project) projectService.findOne(new Long(id));
		if (StringUtils.isNotEmpty(taskId)) {
			Map<String, Object> variables = taskService.getVariables(taskId);
			project.setVariables(variables);
			model.addAttribute("taskId", taskId);
			model.addAttribute("projectId", id);
			model.addAttribute(
					"kjDeptBackReason",
					variables.get("kjDeptBackReason") == null ? "" : variables
							.get("kjDeptBackReason"));
		}
		setUserListInTask(project);
		model.addAttribute("project", project);
		model.addAttribute(type, true);
	}

	private void setUserListInTask(Project project) {
		project.setAuthor1DisplayName(UserUtils
				.getDisplayNameForUserList(project.getAuthor1()));
		project.setAuthor2DisplayName(UserUtils
				.getDisplayNameForUserList(project.getAuthor2()));
		project.setAuthor3DisplayName(UserUtils
				.getDisplayNameForUserList(project.getAuthor3()));
		project.setWeightBelongDisplayName(UserUtils.getUserDisplayName(project
				.getWeightBelong()));
	}

	@RequestMapping(value = "uploadMid")
	@ResponseBody
	public String uploadMid(MultipartHttpServletRequest request) {
		return uploadFileForProject(request, 3l, true);
	}

	@RequestMapping(value = "uploadEnd/{id}")
	@ResponseBody
	public String uploadEnd(MultipartHttpServletRequest request,
			@PathVariable("id") Long id) {
		return uploadFileForProject(request, id, false);
	}

	@RequestMapping(value = "uploadMidFile/{id}", method = {
			RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public String uploadMidFile(@PathVariable("id") Long id, Variable var) {
		try {
			Map<String, Object> variables = var.getVariableMap();
			String fileName = (String) variables.get("fileName");
			uploadFileForProject(fileName, id, true);
			return "success";
		} catch (Exception e) {
			return "error";
		}
	}

	@RequestMapping(value = "uploadEndFile/{id}", method = {
			RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public String uploadEndFile(@PathVariable("id") Long id, Variable var) {
		try {
			Map<String, Object> variables = var.getVariableMap();
			String fileName = (String) variables.get("fileName");
			uploadFileForProject(fileName, id, false);
			return "success";
		} catch (Exception e) {
			return "error";
		}
	}

	private String uploadFileForProject(String fileName, Long id, Boolean isMid) {
		Project project = (Project) projectService.findById(id);
		if (isMid) {
			project.setMidTermFile(fileName);
		} else {
			project.setEndFile(fileName);
		}
		projectService.save(project);
		projectService.refresh();
		return "redirect:" + Global.getAdminPath() + "/oa/expense";
	}

	private String uploadFileForProject(MultipartHttpServletRequest request,
			Long id, Boolean isMid) {
		files = super.uploadFile(request, "project");
		Project project = (Project) projectService.findById(id);
		Iterator<String> itr = request.getFileNames();
		String fileName = itr.next();
		if (isMid) {
			project.setMidTermFile(fileName);
		} else {
			project.setEndFile(fileName);
		}
		projectService.save(project);
		projectService.refresh();
		return "redirect:" + Global.getAdminPath() + "/oa/expense";
	}
}
