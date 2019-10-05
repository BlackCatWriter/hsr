package com.ndtl.yyky.modules.oa.web;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.cms.entity.ExpenseRatio;
import com.ndtl.yyky.modules.cms.service.ExpensePlanService;
import com.ndtl.yyky.modules.cms.service.ExpenseRatioService;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.service.ExpenseService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.oa.web.model.ExpenseModel;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 经费Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/oa/expense")
public class ExpenseController extends BaseOAController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected ExpenseService expenseService;

	@Autowired
	protected ExpenseRatioService expenseRatioService;

	@Autowired
	protected ProjectService projectService;

	@Autowired
	protected TaskService taskService;

	@Autowired
	protected ExpensePlanService expensePlanService;

	@RequiresPermissions("oa:expense:view")
	@RequestMapping(value = "form")
	public String form(Expense expense, Model model, Long id) {
		List<Project> projectList = projectService.findOwnedApprovalProjects();

		if (id != null && containsId(projectList, id)) {
			model.addAttribute("selectedId", id);
			ExpenseModel expenseModel = initExpenseModel(id);
			model.addAttribute("expenseModel", expenseModel);
		}
		model.addAttribute("projectList", projectList);
		model.addAttribute("expense", expense);

		List<ExpensePlan> planList = expensePlanService.findPlanListByProjectId(id);
		for(ExpensePlan item : planList){
			initExpensePlan(item);
			item.setExpense_name(item.getDicExpenseType());
		}

		List<ExpenseRatio> ratioList = expenseRatioService.findRatioListByProjectId(id);
		for(ExpenseRatio item : ratioList){
			initExpenseRatio(item);
			item.setExpense_name(item.getDicExpenseType());
		}
		model.addAttribute("planList",planList);
		model.addAttribute("ratioList",ratioList);
		return "modules/oa/expenseForm";
	}

	@RequestMapping(value = "audit/{expenseId}/{taskId}")
	public String audit(Model model, @PathVariable("expenseId") Long expenseId,
			@PathVariable("taskId") Long taskId) {
		Expense expense = (Expense) expenseService.findById(expenseId);
		ExpenseModel expenseModel = initExpenseModel(expense);
		model.addAttribute("selectedId", expenseId);
		model.addAttribute("expenseModel", expenseModel);
		model.addAttribute("expense", expense);
		return "modules/oa/expenseAudit";
	}

	@RequestMapping(value = { "projectlist", "" })
	public String list(Project project, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Project> page = projectService.find(new Page<Project>(request,
				response), project, true);
		model.addAttribute("page", page);
		return "modules/oa/projectMgmtList";
	}

	@RequestMapping(value = "close")
	public String close(Long id, RedirectAttributes redirectAttributes) {
		Project project = projectService.close(id);
		addMessage(redirectAttributes, "项目" + project.getProjectName() + "已关闭！");
		return "redirect:" + Global.getAdminPath() + "/oa/expense/projectlist";
	}

	@RequestMapping(value = "editProject")
	public String editProject(Long id, RedirectAttributes redirectAttributes) {
		Project project = (Project) projectService.findOne(id);
		addMessage(redirectAttributes, "项目" + project.getProjectName() + "已关闭！");
		return "redirect:" + Global.getAdminPath() + "/oa/expense/projectlist";
	}

	/**
	 * 启动请假流程
	 * 
	 * @param expense
	 */
	@RequiresPermissions("oa:expense:edit")
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Expense expense, RedirectAttributes redirectAttributes) {
		try {
			Map<String, Object> variables = new HashMap<String, Object>();
			ProcessInstance processInstance = expenseService.save(expense,
					variables, ProcessDefinitionKey.Expense);
			addMessage(redirectAttributes,
					"流程已启动，流程ID：" + processInstance.getId());
		} catch (Exception e) {
			logger.error("启动流程失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/expense/form";
	}

	/**
	 * 任务列表
	 * 
	 * @param session
	 */
	@RequiresPermissions("oa:expense:view")
	@RequestMapping(value = { "task" })
	public ModelAndView taskList(HttpSession session) {
		ModelAndView mav = new ModelAndView("modules/oa/expenseTask");
		String userId = ObjectUtils.toString(UserUtils.getUser().getId());
		@SuppressWarnings("unchecked")
		List<Expense> results = (List<Expense>) expenseService.findTodoTasks(
				userId, ProcessDefinitionKey.Expense);
		mav.addObject("expenses", results);
		return mav;
	}

	/**
	 * 读取所有流程
	 * 
	 * @return
	 */
	@RequestMapping(value = { "list" })
	public String list(Expense expense, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Expense> page = expenseService.find(new Page<Expense>(request,
				response), expense);
		List<Project> projectList = projectService.findApprovalProjectsByRole();
		model.addAttribute("projectList", projectList);
		model.addAttribute("page", page);
		return "modules/oa/expenseList";
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail/{id}")
	@ResponseBody
	public String getExpense(@PathVariable("id") Long id) {
		Expense expense = (Expense) expenseService.findOne(id);
		return JsonMapper.getInstance().toJson(expense);
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detailModel/{id}")
	@ResponseBody
	public String getExpenseModel(@PathVariable("id") Long id) {
		Expense expense = (Expense) expenseService.findOne(id);
		ExpenseModel model = initExpenseModel(expense.getProject().getId());
		if (model.getUsedFee() + expense.getAmount() > model.getTotalFee()) {
			model.setExceed(true);
		} else {
			model.setExceed(false);
		}
		model.setExpense(expense);
		return JsonMapper.getInstance().toJson(model);
	}

	@SuppressWarnings({ "deprecation", "unused" })
	private Double getApplyFee(List<Expense> list) {
		Double applyFee = 0D;
		for (Expense expense : list) {
			if (expense.getHistoricProcessInstance().getEndActivityId() == null) {
				Double exFee = expense.getAmount();
				applyFee += exFee;
			}
		}
		return applyFee;
	}

	/**
	 * 读取详细数据
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "detail-with-vars/{id}/{taskId}")
	@ResponseBody
	public String getExpenseWithVars(@PathVariable("id") Long id,
			@PathVariable("taskId") String taskId) {
		Expense expense = (Expense) expenseService.findOne(id);
		Map<String, Object> variables = taskService.getVariables(taskId);
		expense.setVariables(variables);
		return JsonMapper.getInstance().toJson(expense);
	}

	@Override
	public BaseOAService getService() {
		return expenseService;
	}

	private Double getUsedFee(List<Expense> list) {
		Double usedFee = 0D;
		for (Expense expense : list) {
			if (expense.getIsUsed()) {
				Double exFee = expense.getAmount();
				usedFee += exFee;
			}
		}
		return usedFee;
	}

	/**
	 * 按比例剩余
	 * @param list
	 * @return
	 */
	private Double getUsedFee(List<Expense> list,String type) {
		Double usedFee = 0D;
		for (Expense expense : list) {
			if (expense.getIsUsed() && expense.getExpenseType().equals(type)) {
				Double exFee = expense.getAmount();
				usedFee += exFee;
			}
		}
		return usedFee;
	}

	private boolean containsId(List<Project> projects, Long id) {
		for (Project project : projects) {
			if (project.getId().equals(id)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 初始话经费比例
	 * @param ratio
	 */
	private void initExpenseRatio(ExpenseRatio ratio){
		if(ratio.getRatio() != null){
			List<Expense> expenseList = expenseService.getAllExpense(ratio.getProject().getId());
			Project project = projectService.findOne(ratio.getProject().getId());

			ratio.setSd_fee((Double.valueOf(project.getPt_fee())
					+ Double.valueOf(project.getSd_fee()))*ratio.getRatio()/100);
			ratio.setSy_fee(getUsedFee(expenseList,ratio.getExpense_type()));
			ratio.setRe_fee(ratio.getSd_fee() - ratio.getSy_fee());
		}
	}

	/**
	 * 初始话计划比例
	 * @param plan
	 */
	private void initExpensePlan(ExpensePlan plan){
		if(plan.getRatio() != null){
			List<Expense> expenseList = expenseService.getAllExpense(plan.getProject().getId());
			Project project = projectService.findOne(plan.getProject().getId());

			plan.setSd_fee((Double.valueOf(project.getPt_fee())
					+ Double.valueOf(project.getSd_fee()))*plan.getRatio()/100);
			plan.setSy_fee(getUsedFee(expenseList,plan.getExpense_type()));
			plan.setRe_fee(plan.getSd_fee() - plan.getSy_fee());
		}
	}

	private ExpenseModel initExpenseModel(Long projectId) {
		List<Expense> expenseList = expenseService.getAllExpense(projectId);
		Project project = (Project) projectService.findOne(projectId);
		ExpenseModel model = new ExpenseModel();
		model.setPtFee(Double.valueOf(project.getPt_fee()));
		model.setSdFee(Double.valueOf(project.getSd_fee()));
		model.setTotalFee(Double.valueOf(project.getPt_fee())
				+ Double.valueOf(project.getSd_fee()));
		model.setWholeFee(Double.valueOf(project.getPt_fee())
				+ Double.valueOf(project.getXb_fee()));
		model.setUsedFee(getUsedFee(expenseList));
		model.setRemaindFee(model.getTotalFee() - model.getUsedFee());
		model.setExpenseList(expenseList);
		model.setProject(project);
		return model;
	}

	private ExpenseModel initExpenseModel(Expense expense) {
		Project project = expense.getProject();
		List<Expense> expenseList = expenseService.getAllExpense(project
				.getId());
		ExpenseModel model = new ExpenseModel();
		model.setPtFee(Double.valueOf(project.getPt_fee()));
		model.setSdFee(Double.valueOf(project.getSd_fee()));
		model.setTotalFee(Double.valueOf(project.getPt_fee())
				+ Double.valueOf(project.getSd_fee()));
		model.setWholeFee(Double.valueOf(project.getPt_fee())
				+ Double.valueOf(project.getXb_fee()));
		model.setUsedFee(getUsedFee(expenseList));
		model.setRemaindFee(model.getTotalFee() - model.getUsedFee());
		model.setExpenseList(expenseList);
		model.setProject(project);
		return model;
	}
	
    /**
     * 完成任务
     * 
     * @param taskId
     * @return
     */
    @RequestMapping(value = "complete/{id}", method = { RequestMethod.POST, RequestMethod.GET })
    @ResponseBody
    public String completeExpense(@PathVariable("id") String taskId,Variable var) {
        try {
        	Map<String, Object> variables = var.getVariableMap();
        	Boolean deptLeaderPass=(Boolean) variables.get("deptLeaderPass");
        	String projectId=(String) variables.get("projectId");
        	String amount=(String) variables.get("amount");
        	String expenseId=(String) variables.get("expenseId");
        	if(deptLeaderPass&&StringUtils.isNotEmpty(expenseId)){
        		expenseService.completeById(Long.valueOf(expenseId));
        	}
    		if(deptLeaderPass&&StringUtils.isNotEmpty(projectId)&&StringUtils.isNotEmpty(amount)){
                projectService.updateSyfee(Long.valueOf(projectId),amount);
    		}
            taskService.complete(taskId, variables);
            return "success";
        } catch (Exception e) {
            logger.error("error on complete task {}, variables={}", new Object[] { taskId, var.getVariableMap(), e });
            return "error";
        }
    }
}
