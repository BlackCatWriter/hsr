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
import com.ndtl.yyky.modules.oa.entity.Academic;
import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.service.AcademicService;
import com.ndtl.yyky.modules.oa.service.AcademiccostService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 学术活动Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/academic")
public class AcademicController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected AcademicService academicService;
	
	@Autowired
	protected AcademiccostService academiccostService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	/**
	 * 进入申请页
	 * 
	 * @param academic
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "form", "" })
	public String form(Academic academic, Model model) {
		academic.setApplyuser(UserUtils.getUser().getName());
		academic.setWorktitle(UserUtils.getUser().getJobTitle());
		model.addAttribute("academic", academic);
		return "modules/oa/academicForm";
	}
	
	/**
	 * 进入edit页面
	 * 
	 * @param academic
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Academic academic, Model model) {
		academic.setApplyuser(UserUtils.getUser().getName());
		academic.setWorktitle(UserUtils.getUser().getJobTitle());
		model.addAttribute("academic", academic);
		return "modules/oa/academicEditForm";
	}
	
	/**
	 * 创建
	 * 
	 * @param academic
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Academic academic) {
			academicService.editAcademic(academic);
			return "redirect:" + Global.getAdminPath() + "/oa/academic/form";
	}
	
	@ModelAttribute("academic")
	public Academic get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Academic) academicService.findOne(id);
		} else {
			return new Academic();
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
		Academic academic = (Academic) academicService.findOne(new Long(id));
		Map<String, Object> variables = taskService.getVariables(taskId);
		academic.setVariables(variables);
		academic.setApplyuser(UserUtils.getUser().getName());
		academic.setWorktitle(UserUtils.getUser().getJobTitle());
		model.addAttribute("academic", academic);
		model.addAttribute("taskId", taskId);
		model.addAttribute("academicId", id);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/academicForm";
	}

	/**
	 * 创建
	 * 
	 * @param academic
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Academic academic, String academicname,
			RedirectAttributes redirectAttributes) {
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = academicService.save(academic,
					variables, ProcessDefinitionKey.Academic);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动请假流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/academic/form";
	}

	/**
	 * 进入任务列表页
	 * 
	 * @param academic
	 */
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/academicTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		List<Academic> results = academicService.findTodoTasks(userId,
				ProcessDefinitionKey.Academic);
		List<Academic> costresults = academiccostService.findAcademicTodoTasks(userId,
				ProcessDefinitionKey.Academiccost);
//		, academicService.findFinishedAcademicByUser(UserUtils.getUser().getId())
		mav.addObject("academic", results);
		mav.addObject("costresults", costresults);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" })
	public String list(Academic academic, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Academic> page = academicService.find(new Page<Academic>(request,
				response), academic);
		model.addAttribute("page", page);
		return "modules/oa/academicList";
	}

	// /**
	// * 读取所有流程
	// *
	// * @return
	// */
	// @RequestMapping(value = { "selflist" })
	// public String selfList(Academic academic, HttpServletRequest request,
	// HttpServletResponse response, Model model) {
	// Page<Academic> page = academicService.findForSelf(new
	// Page<Academic>(request,
	// response), academic);
	// model.addAttribute("page", page);
	// return "modules/oa/academicList";
	// }

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getAcademic(@PathVariable("id") Long id) {
		Academic academic = (Academic) academicService.findOne(id);
		// if (academic.getVariables().get("officeName") != null) {
		// Long officeID = Long.valueOf(academic.getVariables()
		// .get("officeName").toString());
		// Office office = officeService.get(officeID);
		// academic.setOfficeName(office.getName());
		// academic.setOffice(office);
		// academicService.saveAcademic(academic);
		// } else {
		// academic.setOfficeName(academic.getOffice().getName());
		// }
		return JsonMapper.getInstance().toJson(academic);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getAcademicWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Academic academic = (Academic) academicService.findOne(id);
		Map<String, Object> variables = taskService.getVariables(taskId);
		academic.setVariables(variables);
		// academic.setOfficeName(academic.getOffice().getName());
		return JsonMapper.getInstance().toJson(academic);
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
			academicService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete thesisId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

	// ajax methods
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkTitle(String oldName, String name) {
		if (name != null && name.equals(oldName)) {
			return "true";
		} else if (name != null
				&& academicService.getByAcademicName(name) == null) {
			return "true";
		}
		return "false";
	}

	@Override
	public BaseOAService getService() {
		// TODO Auto-generated method stub
		return academicService;
	}
	
	private boolean containsId(List<Academic> academics, Long id) {
		for (Academic academic : academics) {
			if (academic.getId().equals(id)) {
				return true;
			}
		}
		return false;
	}
	

	
	/**
	 * 进入经费
	 * 
	 * @param academic
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "cost"})
	public String cost(Academiccost academiccost, Model model, Long id) {
		List<Academiccost> academiccosts=academiccostService.finishedCost(UserUtils.getUser().getId());
		List<Academic> academicList = academicService.findAcademicWithoutCost(UserUtils.getUser().getId(),academiccosts);
		if (id != null && containsId(academicList, id)) {
			model.addAttribute("selectedId", id);
			Academic academic = (Academic) academicService.findOne(id);
			copyAttribute(academic,academiccost);
			academiccost.setAcademic(academic);
		}
		model.addAttribute("academiccost", academiccost);
		model.addAttribute("academicList", academicList);
		return "modules/oa/academicCost";
	}
	
	private void copyAttribute(Academic academic,Academiccost academiccost ){
		academiccost.setOffice(academic.getOffice());
		academiccost.setAcademicName(academic.getAcademicName());
		academiccost.setLevel(academic.getLevel());
		academiccost.setExerciseRole(academic.getExerciseRole());
		academiccost.setPlace(academic.getPlace());
		academiccost.setStartDate(academic.getStartDate());
		academiccost.setEndDate(academic.getEndDate());
		academiccost.setHostUnit(academic.getHostUnit());
		academiccost.setUser(academic.getCreateBy());
	}


	
	/**
	 * 进入经费重新申请
	 * 
	 * @param id
	 * @param taskId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "costModify/{id}/{taskId}" })
	public String costformModify(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId, Model model) {
		Academiccost academiccost=(Academiccost)academiccostService.findOne(id);
		List<Academiccost> academiccosts=academiccostService.finishedCost(UserUtils.getUser().getId());
		List<Academic> academicList = academicService.findAcademicWithoutCost(UserUtils.getUser().getId(),academiccosts);
		if (id != null && containsId(academicList, id)) {
			model.addAttribute("selectedId", id);
			Academic academic = academiccost.getAcademic();
			copyAttribute(academic,academiccost);
		}
		Map<String, Object> variables = taskService.getVariables(taskId);
		academiccost.setVariables(variables);
		model.addAttribute("academiccost", academiccost);
		model.addAttribute("academicList", academicList);

		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/academicCost";
	}
	
	
	@RequestMapping(value = "savecost", method = RequestMethod.POST)
	public String saveCost(Academiccost academiccost,RedirectAttributes redirectAttributes) {
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = academiccostService.save(academiccost,
					variables, ProcessDefinitionKey.Academiccost);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/academic/form";
	}
	
	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detailcost/{id}")
	@ResponseBody
	public String getAcademiccost(@PathVariable("id") Long id) {
		Academiccost academiccost = (Academiccost) academiccostService.findOne(id);
		return JsonMapper.getInstance().toJson(academiccost);
	}
	
	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detailcost-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getAcademiccostWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Academiccost academiccost = (Academiccost) academiccostService.findOne(id);
		Map<String, Object> variables = taskService.getVariables(taskId);
		academiccost.setVariables(variables);
		// academic.setOfficeName(academic.getOffice().getName());
		return JsonMapper.getInstance().toJson(academiccost);
	}
	
	/**
	 * 完成任务
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "completecost/{id}", method = { RequestMethod.POST,
			RequestMethod.GET })
	@ResponseBody
	public String completeCost(@PathVariable("id") Long id, Variable var) {
		try {
			Map<String, Object> variables = var.getVariableMap();
			academiccostService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete thesisId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}
}
