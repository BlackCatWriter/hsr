package com.ndtl.yyky.modules.oa.web;

import java.util.HashMap;
import java.util.LinkedList;
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

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.RewardToUser;
import com.ndtl.yyky.modules.oa.entity.Reward.RewardType;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.RewardService;
import com.ndtl.yyky.modules.oa.service.RewardToUserService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.FileMeta;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.oa.web.model.RewardModel;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

@Controller
@RequestMapping(value = "${adminPath}/oa/tecAdvReward")
public class TecAdvRewardController extends BaseOAController {

	private static final String rewardType = RewardType.tecAdv.name();

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected RewardService rewardService;

	@Autowired
	protected ProjectService projectService;

	@Autowired
	protected RewardToUserService rewardToUserService;

	@Autowired
	protected SystemService systemService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected RuntimeService runtimeService;

	@Autowired
	protected TaskService taskService;

	LinkedList<FileMeta> files = new LinkedList<FileMeta>();
	FileMeta fileMeta = null;

	@RequestMapping(value = { "form", "" })
	public String form(Reward reward, Model model) {
		reward.setOffice(UserUtils.getUser().getOffice());
		reward.setOfficeName(UserUtils.getUser().getOffice().getName());
		model.addAttribute("reward", reward);
		model.addAttribute("form", true);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/tecAdvRewardForm";
	}

	
	/**
	 * 进入edit页面
	 * 
	 * @param reward
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Reward reward, Model model) {
		setUserListInTask(reward);
		model.addAttribute("reward", reward);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/tecAdvRewardEditForm";
	}
	
	@ModelAttribute("reward")
	public Reward get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Reward) rewardService.findOne(id);
		} else {
			return new Reward();
		}
	}
	
	/**
	 * 编辑
	 * 
	 * @param reward
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Reward reward) {
			rewardService.editReward(reward);
			return "redirect:" + Global.getAdminPath() + "/oa/tecAdvReward/form";
	}
	
	@RequestMapping(value = { "formModify/{id}/{taskId}" })
	public String formModify(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		initFormPage(id, taskId, model, "modify");
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/tecAdvRewardForm";
	}

	@RequestMapping(value = { "formAudit/{id}/{taskId}" })
	public String formAudit(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		initFormPage(id, taskId, model, "audit");
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/tecAdvRewardForm";
	}

	@RequestMapping(value = { "forAudit/{id}" })
	public String forAudit(@PathVariable("id") Long id, Model model) {
		initFormPage(id, "", model, "forAudit");
		RewardToUser result = getRewardToUserForCurrentUser(id);
		if (result != null) {
			model.addAttribute("rewardToUser", result);
		}
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/oa/tecAdvRewardForm";
	}

	@RequestMapping(value = "saveRewardToUser", method = RequestMethod.POST)
	public String saveRewardToUser(RewardToUser rewardToUser,
			RedirectAttributes redirectAttributes, Model model) {
		Long rewardId = rewardToUser.getReward().getId();
		rewardToUserService.save(rewardToUser);
		addMessage(redirectAttributes, "保存成功！");
		return "redirect:" + Global.getAdminPath()
				+ "/oa/tecAdvReward/forAudit/" + rewardId;
	}

	@RequestMapping(value = "submitRewardToUser", method = RequestMethod.POST)
	public String submitRewardToUser(RewardToUser rewardToUser,
			RedirectAttributes redirectAttributes) {
		rewardToUser.setFinished(true);
		rewardToUserService.save(rewardToUser);
		addMessage(redirectAttributes, "提交成功！");
		return "redirect:" + Global.getAdminPath() + "/oa/tecAdvReward/task";
	}

	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Reward reward, RedirectAttributes redirectAttributes) {

		if(reward.getProject()!=null&&reward.getProject().getId()==null){
			reward.setProject(null);
		}
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			reward.setType(rewardType);
			ProcessInstance processInstance = rewardService.save(reward,
					variables, ProcessDefinitionKey.Reward);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动奖励申请流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/tecAdvReward/form";
	}

	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/tecAdvRewardTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		@SuppressWarnings("unchecked")
		List<Reward> results = (List<Reward>) rewardService.findTodoTasks(
				userId, ProcessDefinitionKey.Reward, rewardType);
		RewardModel rewardModel = new RewardModel();
		for (Reward reward : results) {
			if (reward.getTask().getTaskDefinitionKey().equals("kjDeptAudit")
					|| reward.getTask().getTaskDefinitionKey()
					.equals("deptLeaderAudit")
			|| reward.getTask().getTaskDefinitionKey()
							.equals("modifyApply")) {
				rewardModel.getKjkAuditRewards().add(reward);
			} else if (reward.getTask().getTaskDefinitionKey()
					.equals("hosAudit")) {
				rewardModel.getHosAuditRewards().add(reward);
			} else if (reward.getTask().getTaskDefinitionKey()
					.equals("lxAudit")) {
				rewardModel.getLxAuditRewards().add(reward);
			}
		}
		List<RewardToUser> assignedRewards = rewardToUserService
				.findByUserId(Long.valueOf(userId));
		for (RewardToUser rtu : assignedRewards) {
			rewardModel.getAssignedReward().add(rtu.getReward());
		}
		mav.addObject("rewardModel", rewardModel);
		return mav;
	}

	@RequestMapping(value = { "editStatus" })
	public String editStatus(RewardModel model,
			RedirectAttributes redirectAttributes) {
		String status = model.getRewardStatus();
		for (Long p : model.getLxRewardIds()) {
			Reward reward = (Reward) rewardService.findOne(p);
			reward.setProcessStatus(status);
			rewardService.save(reward);
		}
		rewardService.refresh();
		return "redirect:" + Global.getAdminPath() + "/oa/tecAdvReward/task";
	}

	@RequestMapping(value = { "assign" })
	public String assign(RewardModel model,
			RedirectAttributes redirectAttributes) {
		List<User> users = Lists.newArrayList();
		List<Reward> rewards = Lists.newArrayList();
		String userIds = model.getUsers();
		if (StringUtils.isNotEmpty(userIds)) {
			for (String id : userIds.split(",")) {
				if (id.matches("\\d*")) {
					User user = systemService.findUserById(Long.valueOf(id));
					users.add(user);
				}
			}
			for (Long p : model.getHosRewardIds()) {
				Reward reward = (Reward) rewardService.findOne(p);
				rewards.add(reward);
			}

			List<RewardToUser> rtus = Lists.newArrayList();
			for (User user : users) {
				for (Reward reward : rewards) {
					if (!exists(user, reward)) {
						RewardToUser ptu = new RewardToUser();
						ptu.setUser(user);
						ptu.setReward(reward);
						rtus.add(ptu);
					}
				}
			}
			rewardToUserService.save(rtus);
		}
		rewardService.refresh();
		systemService.refresh();
		return "redirect:" + Global.getAdminPath() + "/oa/tecAdvReward/task";
	}

	private boolean exists(User u, Reward p) {
		for (RewardToUser ptu : p.getRewardToUser()) {
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
	@RequestMapping(value = { "list" })
	public String list(Reward reward, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Reward> page = rewardService.find(new Page<Reward>(request,
				response), reward, rewardType);
		model.addAttribute("page", page);
		return "modules/oa/tecAdvRewardList";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getReward(@PathVariable("id") Long id) {
		Reward reward = (Reward) rewardService.findOne(id);
		setUserListInTask(reward);
		reward.setOfficeName(reward.getOffice().getName());
		return JsonMapper.getInstance().toJson(reward);
	}

	@RequestMapping(value = "detailPTU/{id}")
	@ResponseBody
	public String getRewardToUser(@PathVariable("id") Long id) {
		RewardToUser rewardToUser = (RewardToUser) rewardToUserService
				.findOne(id);
		return JsonMapper.getInstance().toJson(rewardToUser);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getRewardWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Reward reward = (Reward) rewardService.findOne(id);
		setUserListInTask(reward);
		Map<String, Object> variables = taskService.getVariables(taskId);
		reward.setVariables(variables);
		return JsonMapper.getInstance().toJson(reward);
	}

	@RequestMapping(value = "complete/{id}", method = { RequestMethod.POST,
			RequestMethod.GET })
	@ResponseBody
	public String complete(@PathVariable("id") Long id, Variable var) {
		try {
			Map<String, Object> variables = var.getVariableMap();
			rewardService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete rewardId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

	@Override
	public BaseOAService getService() {
		return rewardService;
	}

	private boolean isAssigned(Reward reward) {
		for (RewardToUser ptu : reward.getRewardToUser()) {
			if (ptu.getUser().getId().equals(UserUtils.getUser().getId())
					&& !ptu.getFinished()) {
				return true;
			}
		}
		return false;
	}

	private RewardToUser getRewardToUserForCurrentUser(Long rewardId) {
		Reward reward = (Reward) rewardService.findOne(rewardId);
		for (RewardToUser ptu : reward.getRewardToUser()) {
			if (ptu.getUser().getId().equals(UserUtils.getUser().getId())) {
				return ptu;
			}
		}
		return null;
	}

	private void initFormPage(Long id, String taskId, Model model, String type) {
		Reward reward = (Reward) rewardService.findOne(new Long(id));
		if (StringUtils.isNotEmpty(taskId)) {
			Map<String, Object> variables = taskService.getVariables(taskId);
			reward.setVariables(variables);
			model.addAttribute("taskId", taskId);
			model.addAttribute("rewardId", id);
			model.addAttribute(
					"kjDeptBackReason",
					variables.get("kjDeptBackReason") == null ? "" : variables
							.get("kjDeptBackReason"));
		}
		setUserListInTask(reward);
		model.addAttribute("reward", reward);
		model.addAttribute(type, true);
	}

	private void setUserListInTask(Reward reward) {
		reward.setAuthor1DisplayName(UserUtils.getDisplayNameForUserList(reward
				.getAuthor1()));
		reward.setAuthor2DisplayName(UserUtils.getDisplayNameForUserList(reward
				.getAuthor2()));
		reward.setAuthor3DisplayName(UserUtils.getDisplayNameForUserList(reward
				.getAuthor3()));
		reward.setWeightBelongDisplayName(UserUtils.getUserDisplayName(reward
				.getWeightBelong()));
	}

}
