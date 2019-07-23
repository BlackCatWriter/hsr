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
import com.ndtl.yyky.modules.oa.entity.Acad;
import com.ndtl.yyky.modules.oa.service.AcadService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.utils.DictUtils;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 学会Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/acad")
public class AcadController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected AcadService acadService;

	@Autowired
	protected OfficeService officeService;

	@Autowired
	protected TaskService taskService;

	/**
	 * 进入申请页
	 * 
	 * @param acad
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "form", "" })
	public String form(Acad acad, Model model) {
		acad.setApplyuser(UserUtils.getUser().getName());
		acad.setWorktitle(UserUtils.getUser().getJobTitle());
		String education=DictUtils.getDictLabel(UserUtils.getUser().getDegree(), "degree", "");
		acad.setEducation(education);
		model.addAttribute("acad", acad);
		return "modules/oa/acadForm";
	}
	
	/**
	 * 进入edit页面
	 * 
	 * @param acad
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "editform" })
	public String editform(Acad acad, Model model) {
		acad.setApplyuser(UserUtils.getUser().getName());
		acad.setWorktitle(UserUtils.getUser().getJobTitle());
		String education=DictUtils.getDictLabel(UserUtils.getUser().getDegree(), "degree", "");
		acad.setEducation(education);
		model.addAttribute("acad", acad);
		return "modules/oa/acadEditForm";
	}
	
	/**
	 * 创建
	 * 
	 * @param acad
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "edit", method = RequestMethod.POST)
	public String edit(Acad acad) {
			acadService.editAcad(acad);
			return "redirect:" + Global.getAdminPath() + "/oa/acad/form";
	}
	
	@ModelAttribute("acad")
	public Acad get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Acad) acadService.findOne(id);
		} else {
			return new Acad();
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
		Acad acad = (Acad) acadService.findOne(new Long(id));
		Map<String, Object> variables = taskService.getVariables(taskId);
		acad.setVariables(variables);
		acad.setApplyuser(acad.getUser().getName());
		acad.setWorktitle(acad.getUser().getJobTitle());
		String education=DictUtils.getDictLabel(acad.getUser().getDegree(), "degree", "");
		acad.setEducation(education);
		model.addAttribute("acad", acad);
		model.addAttribute("taskId", taskId);
		model.addAttribute("acadId", id);
		model.addAttribute(
				"kjDeptBackReason",
				variables.get("kjDeptBackReason") == null ? "" : variables
						.get("kjDeptBackReason"));
		return "modules/oa/acadForm";
	}
	
	/**
	 * 进入延期页面
	 * 
	 * @param id
	 * @param taskId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "putoff" })
	public String putOff(Acad acad,Model model, Long id) {
		acad = (Acad) acadService.findOne(new Long(id));
		acad.setApplyuser(acad.getUser().getName());
		acad.setWorktitle(acad.getUser().getJobTitle());
		String education=DictUtils.getDictLabel(acad.getUser().getDegree(), "degree", "");
		acad.setEducation(education);
		model.addAttribute("acad", acad);
		return "modules/oa/acadPutoff";
	}
	
	/**
	 * 结束任职
	 * 
	 * @param id
	 * @param taskId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "setfinished" })
	public String setIsFinished(Acad acad,Model model, Long id, HttpServletRequest request,
			HttpServletResponse response) {
		acad = (Acad) acadService.findOne(id);
		acad.setIsFinished(Acad.YES);
		acadService.saveAcad(acad);
		Page<Acad> page = acadService.find(new Page<Acad>(request,
				response), acad);
		model.addAttribute("page", page);
		return "modules/oa/acadList";
	}

	/**
	 * 创建
	 * 
	 * @param acad
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Acad acad, String acadname,
			RedirectAttributes redirectAttributes) {
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = acadService.save(acad,
					variables, ProcessDefinitionKey.Acad);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动请假流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/acad/form";
	}
	
	/**
	 * 创建
	 * 
	 * @param acad
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(Acad acad, RedirectAttributes redirectAttributes) {
			acadService.updateEndDate(acad.getId(),acad.getEndDate());
		return "redirect:" + Global.getAdminPath() + "/oa/acad/form";
	}

	/**
	 * 进入任务列表页
	 * 
	 * @param acad
	 */
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/acadTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		List<Acad> results = acadService.findTodoTasks(userId,
				ProcessDefinitionKey.Acad);
		for (Acad item : results) {
			item.setApplyuser(item.getUser().getName());
			item.setWorktitle(item.getUser().getJobTitle());
			String education=DictUtils.getDictLabel(item.getUser().getDegree(), "degree", "");
			item.setEducation(education);
		}
		mav.addObject("acad", results);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" })
	public String list(Acad acad, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Acad> page = acadService.find(new Page<Acad>(request,
				response), acad);
		model.addAttribute("page", page);
		return "modules/oa/acadList";
	}

//	 /**
//	 * 读取所有流程
//	 *
//	 * @return
//	 */
//	 @RequestMapping(value = { "selflist" })
//	 public String selfList(Acad acad, HttpServletRequest request,
//	 HttpServletResponse response, Model model) {
//	 Page<Acad> page = acadService.findForSelf(new Page<Acad>(request, response), acad);
//	 model.addAttribute("page", page);
//	 return "modules/oa/acadList";
//	 }

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getAcad(@PathVariable("id") Long id) {
		Acad acad = (Acad) acadService.findOne(id);
		// if (acad.getVariables().get("officeName") != null) {
		// Long officeID = Long.valueOf(acad.getVariables()
		// .get("officeName").toString());
		// Office office = officeService.get(officeID);
		// acad.setOfficeName(office.getName());
		// acad.setOffice(office);
		// acadService.saveAcad(acad);
		// } else {
		// acad.setOfficeName(acad.getOffice().getName());
		// }
		return JsonMapper.getInstance().toJson(acad);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getAcadWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Acad acad = (Acad) acadService.findOne(id);
		Map<String, Object> variables = taskService.getVariables(taskId);
		acad.setVariables(variables);
		return JsonMapper.getInstance().toJson(acad);
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
			acadService.complete(id, variables);
			return "success";
		} catch (Exception e) {
			logger.error("error on complete thesisId {}, variables={}",
					new Object[] { id, var.getVariableMap(), e });
			return "error";
		}
	}

	@Override
	public BaseOAService getService() {
		// TODO Auto-generated method stub
		return acadService;
	}

}
