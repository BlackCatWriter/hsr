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
import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.entity.Advstudy;
import com.ndtl.yyky.modules.oa.service.AcademiccostService;
import com.ndtl.yyky.modules.oa.service.AdvstudyService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 进修学习Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/advstudy")
public class AdvstudyController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected AdvstudyService advstudyService;	
	
	@Autowired
	protected AcademiccostService academiccostService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	/**
	 * 进入申请页
	 * 
	 * @param advstudy
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "form", "" })
	public String form(Advstudy advstudy, Model model) {
		advstudy.setApplyuser(UserUtils.getUser().getName());
		advstudy.setWorktitle(UserUtils.getUser().getJobTitle());
		model.addAttribute("advstudy", advstudy);
		return "modules/oa/advstudyForm";
	}
	
	/**
	 * 进入edit页面
	 * 
	 * @param advstudy
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Advstudy advstudy, Model model) {
		advstudy.setApplyuser(UserUtils.getUser().getName());
		advstudy.setWorktitle(UserUtils.getUser().getJobTitle());
		model.addAttribute("advstudy", advstudy);
		return "modules/oa/advstudyEditForm";
	}
	
	/**
	 * 创建
	 * 
	 * @param advstudy
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Advstudy advstudy) {
			advstudyService.editAdvstudy(advstudy);
			return "redirect:" + Global.getAdminPath() + "/oa/advstudy/form";
	}
	
	@ModelAttribute("advstudy")
	public Advstudy get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Advstudy) advstudyService.findOne(id);
		} else {
			return new Advstudy();
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
		Advstudy advstudy = (Advstudy) advstudyService.findOne(new Long(id));
		Map<String, Object> variables = taskService.getVariables(taskId);
		advstudy.setVariables(variables);
		advstudy.setApplyuser(UserUtils.getUser().getName());
		advstudy.setWorktitle(UserUtils.getUser().getJobTitle());
		model.addAttribute("advstudy", advstudy);
		model.addAttribute("taskId", taskId);
		model.addAttribute("advstudyId", id);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/advstudyForm";
	}

	/**
	 * 创建
	 * 
	 * @param advstudy
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Advstudy advstudy, String advstudyname,
			RedirectAttributes redirectAttributes) {
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = advstudyService.save(advstudy,
					variables, ProcessDefinitionKey.Advstudy);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动请假流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/advstudy/form";
	}

	/**
	 * 进入任务列表页
	 * 
	 * @param advstudy
	 */
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/advstudyTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		List<Advstudy> results = advstudyService.findTodoTasks(userId,
				ProcessDefinitionKey.Advstudy);
		List<Advstudy> costresults = academiccostService.findAdvstudyTodoTasks(userId,
				ProcessDefinitionKey.Academiccost);
//		List<Advstudy> costresults = academiccostService.findAdvstudyTodoTasks(userId,
//				ProcessDefinitionKey.Academiccost, advstudyService.findFinishedAcademicByUser(UserUtils.getUser().getId()));
		mav.addObject("advstudy", results);
		mav.addObject("costresults", costresults);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" })
	public String list(Advstudy advstudy, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Advstudy> page = advstudyService.find(new Page<Advstudy>(request,
				response), advstudy);
		model.addAttribute("page", page);
		return "modules/oa/advstudyList";
	}

	// /**
	// * 读取所有流程
	// *
	// * @return
	// */
	// @RequestMapping(value = { "selflist" })
	// public String selfList(Advstudy advstudy, HttpServletRequest request,
	// HttpServletResponse response, Model model) {
	// Page<Advstudy> page = advstudyService.findForSelf(new
	// Page<Advstudy>(request,
	// response), advstudy);
	// model.addAttribute("page", page);
	// return "modules/oa/advstudyList";
	// }

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getAdvstudy(@PathVariable("id") Long id) {
		Advstudy advstudy = (Advstudy) advstudyService.findOne(id);
		// if (advstudy.getVariables().get("officeName") != null) {
		// Long officeID = Long.valueOf(advstudy.getVariables()
		// .get("officeName").toString());
		// Office office = officeService.get(officeID);
		// advstudy.setOfficeName(office.getName());
		// advstudy.setOffice(office);
		// advstudyService.saveAdvstudy(advstudy);
		// } else {
//		advstudy.setOfficeName(advstudy.getOffice().getName());
		// }
		return JsonMapper.getInstance().toJson(advstudy);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getAdvstudyWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Advstudy advstudy = (Advstudy) advstudyService.findOne(id);
		Map<String, Object> variables = taskService.getVariables(taskId);
		advstudy.setVariables(variables);
		// advstudy.setOfficeName(advstudy.getOffice().getName());
		return JsonMapper.getInstance().toJson(advstudy);
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
			advstudyService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete thesisId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

//	// ajax methods
//	@ResponseBody
//	@RequestMapping(value = "checkName")
//	public String checkTitle(String oldName, String name) {
//		if (name != null && name.equals(oldName)) {
//			return "true";
//		} else if (name != null
//				&& advstudyService.getByAdvstudyName(name) == null) {
//			return "true";
//		}
//		return "false";
//	}

	@Override
	public BaseOAService getService() {
		// TODO Auto-generated method stub
		return advstudyService;
	}


	private boolean containsId(List<Advstudy> advstudys, Long id) {
		for (Advstudy advstudy : advstudys) {
			if (advstudy.getId().equals(id)) {
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
		List<Advstudy> advstudyList = advstudyService.findAdvstudyWithoutCost(UserUtils.getUser().getId(),academiccosts);
		if (id != null && containsId(advstudyList, id)) {
			model.addAttribute("selectedId", id);
			Advstudy advstudy = (Advstudy) advstudyService.findOne(id);
			copyAttribute(advstudy,academiccost);
			academiccost.setAdvstudy(advstudy);
		}
		model.addAttribute("academiccost", academiccost);
		model.addAttribute("advstudyList", advstudyList);
		return "modules/oa/advstudyCost";
	}
	
	private void copyAttribute(Advstudy advstudy,Academiccost academiccost ){
		academiccost.setOffice(advstudy.getOffice());
		academiccost.setAdvstudyDirection(advstudy.getAdvstudyDirection());
		academiccost.setStartDate(advstudy.getStartDate());
		academiccost.setEndDate(advstudy.getEndDate());
		academiccost.setHostUnit(advstudy.getHostUnit());
		academiccost.setUser(advstudy.getCreateBy());
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
		List<Advstudy> advstudyList = advstudyService.findAdvstudyWithoutCost(UserUtils.getUser().getId(),academiccosts);
		if (id != null && containsId(advstudyList, id)) {
			model.addAttribute("selectedId", id);
			Advstudy advstudy = academiccost.getAdvstudy();
			copyAttribute(advstudy,academiccost);
		}

		Map<String, Object> variables = taskService.getVariables(taskId);
		academiccost.setVariables(variables);
		model.addAttribute("academiccost", academiccost);
		model.addAttribute("advstudyList", advstudyList);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/advstudyCost";
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
		return "redirect:" + Global.getAdminPath() + "/oa/advstudy/form";
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
