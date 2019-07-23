package com.ndtl.yyky.modules.oa.web;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresUser;
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

import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.entity.Achievement;
import com.ndtl.yyky.modules.oa.service.AchievementService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.FileMeta;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 论文登记Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/achievement")
public class AchievementController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected AchievementService achievementService;

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

	@RequiresPermissions("oa:achievement:view")
	@RequestMapping(value = { "form", "" })
	public String form(Achievement achievement, Model model) {
		model.addAttribute("achievement", achievement);
		return "modules/oa/achievementForm";
	}
	
	@ModelAttribute("achievement")
	public Achievement get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Achievement) achievementService.findOne(id);
		} else {
			return new Achievement();
		}
	}


	@RequestMapping(value = { "formModify/{id}/{taskId}" })
	public String formModify(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		Achievement achievement = (Achievement) achievementService.findOne(id);
		Map<String, Object> variables = taskService.getVariables(taskId);
		achievement.setVariables(variables);
		setUserListInTask(achievement);
		model.addAttribute("achievement", achievement);
		model.addAttribute("taskId", taskId);
		model.addAttribute("achievementId", id);
		return "modules/oa/achievementForm";
	}

	/**
	 * 启动论文登记流程
	 * 
	 * @param achievement
	 */
	@RequiresPermissions("oa:achievement:edit")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Achievement achievement,
			RedirectAttributes redirectAttributes) {
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = achievementService.save(
					achievement, variables, ProcessDefinitionKey.Achievement);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动请假流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/achievement/form";
	}

	/**
	 * 任务列表
	 * 
	 * @param achievement
	 */
	@RequiresPermissions("oa:achievement:view")
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/achievementTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		@SuppressWarnings("unchecked")
		List<Achievement> results = (List<Achievement>) achievementService
				.findTodoTasks(userId, ProcessDefinitionKey.Achievement);
		mav.addObject("achievement", results);
		return mav;
	}

	private void setUserListInTask(Achievement achievement) {
		String strAuthor1 = UserUtils.getDisplayNameForUserList(achievement
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(achievement
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(achievement
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(achievement
				.getWeightBelong());
		achievement.setAuthor1DisplayName(strAuthor1);
		achievement.setAuthor2DisplayName(strAuthor2);
		achievement.setAuthor3DisplayName(strAuthor3);
		achievement.setWeightBelongDisplayName(strWeightBelong);
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequiresPermissions("oa:achievement:view")
	@RequestMapping(value = { "list" })
	public String list(Achievement achievement, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Achievement> page = achievementService.find(new Page<Achievement>(
				request, response), achievement);
		model.addAttribute("page", page);
		return "modules/oa/achievementList";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getAchievement(@PathVariable("id") Long id) {
		Achievement achievement = (Achievement) achievementService.findOne(id);
		setUserListInTask(achievement);
		achievement.setOfficeName(achievement.getOffice().getName());
		return JsonMapper.getInstance().toJson(achievement);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getAchievementWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Achievement achievement = (Achievement) achievementService.findOne(id);
		setUserListInTask(achievement);
		Map<String, Object> variables = taskService.getVariables(taskId);
		achievement.setVariables(variables);
		return JsonMapper.getInstance().toJson(achievement);
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
			achievementService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete achievementId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

	@Override
	public BaseOAService getService() {
		return achievementService;
	}

	@RequiresUser
	@ResponseBody
	@RequestMapping(value = "treeData")
	public Set<Map<String, Object>> treeData(
			@RequestParam(required = false) Long extId,
			RedirectAttributes redirectAttributes, HttpServletResponse response) {
		response.setContentType("application/json; charset=UTF-8");
		Set<Map<String, Object>> mapList = Sets.newHashSet();
		List<User> list = officeService.findListWithUsers();
		for (int i = 0; i < list.size(); i++) {
			User e = list.get(i);
			if (e.getId() == 1) {
				continue;
			}
			if (extId == null
					|| (extId != null && !extId.equals(e.getOffice().getId()) && e
							.getOffice().getParentIds()
							.indexOf("," + extId + ",") == -1)) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getOffice().getId());
				map.put("pId", e.getOffice().getParent() != null ? e
						.getOffice().getParent().getId() : 0);
				map.put("name", e.getOffice().getName());
				mapList.add(map);
			}
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", "_" + e.getId());
			map.put("pId", e.getOffice().getId());
			map.put("name", e.getName() + "(" + e.getNo() + ")");
			mapList.add(map);
		}
		return mapList;
	}
}
