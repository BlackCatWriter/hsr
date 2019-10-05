package com.ndtl.yyky.modules.cms.web;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.StringUtils;
import com.ndtl.yyky.common.utils.excel.ColumnTitleMap;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.cms.entity.Account;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.cms.entity.ExpenseRatio;
import com.ndtl.yyky.modules.cms.service.AccountService;
import com.ndtl.yyky.modules.cms.service.ExpensePlanService;
import com.ndtl.yyky.modules.cms.service.ExpenseRatioService;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.service.ExpenseService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.sys.entity.Menu;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 经费Controller
 * 
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/account")
public class AccountController extends BaseController {

	private Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	protected AccountService accountService;

	@Autowired
	protected ProjectService projectService;

	@Autowired
	private ExpenseService expenseService;

	@Autowired
	protected ExpenseRatioService expenseRatioService;

	@Autowired
	protected ExpensePlanService expensePlanService;

	@RequestMapping(value = { "form", "" })
	public String form(Account account, Model model, Long id) {
		model.addAttribute("account",account);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		return "modules/cms/accountForm";
	}

	/**
	 * 创建
	 *
	 * @param account
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "save", method = RequestMethod.POST)
	public String save(Account account, RedirectAttributes redirectAttributes) {

		try {
			accountService.save(account);

			// 更新项目经费信息
			projectService.updateProjectfee(account.getProject().getId(),
					account.getXb_fee(),account.getPt_fee(),account.getSd_fee());
			addMessage(redirectAttributes,
					"费用填报成功" );
		} catch (Exception e) {
			logger.error("费用填报失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/form";
	}

	/**
	 * 经费比例配置
	 *
	 * @param ratio
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "expenseRatioForm"})
	public String expenseRatioFrom(ExpenseRatio ratio,Model model,HttpServletRequest request,
								   HttpServletResponse response) {
		model.addAttribute("ratio",ratio);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);

		Page<ExpenseRatio> page = expenseRatioService.find(new Page<ExpenseRatio>(request, response));
		for(ExpenseRatio item : page.getList()){
			item.setExpense_name(item.getDicExpenseType());
		}
		model.addAttribute("ratioList", page);

		return "modules/cms/expenseRatioForm";
	}

	/**
	 * 保存经费比例填报
	 *
	 * @param expenseTypes
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "ratioSave", method = RequestMethod.POST)
	public String ratioSave(String project_id,String[] expenseTypes, Integer[] ratios, RedirectAttributes redirectAttributes) {
		try {
			int len = expenseTypes.length;
			ExpenseRatio[] item = new ExpenseRatio[len];
			for (int i = 0; i < len; i++) {
				item[i] = expenseRatioService.findRatioByType(Long.valueOf(project_id),expenseTypes[i]);
				if(item[i] == null){
					item[i] = new ExpenseRatio();
				}

				Project project = item[i].getProject();
				if(project == null){
					project = new Project();
				}
				project.setId(Long.valueOf(project_id));
				item[i].setProject(project);

				if(StringUtils.isNotEmpty(expenseTypes[i])){
					item[i].setExpense_type(expenseTypes[i]);
				}

				if(StringUtils.isNotEmpty(String.valueOf(ratios[i]))){
					item[i].setRatio(ratios[i]);
				}
				expenseRatioService.save(item[i]);
			}
			addMessage(redirectAttributes,
					"经费预算配置成功" );
		} catch (Exception e) {
			logger.error("经费预算配置失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/expenseRatioForm";
	}

	/**
	 * 保存规划比例配置
	 *
	 * @param expenseTypes
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "saveExpensePlan", method = RequestMethod.POST)
	public String saveExpensePlan(String project_id,String[] expenseTypes, Integer[] ratios, RedirectAttributes redirectAttributes) {
		try {
			int len = expenseTypes.length;
			ExpensePlan[] item = new ExpensePlan[len];
			for (int i = 0; i < len; i++) {
				item[i] = expensePlanService.findPlanByType(Long.valueOf(project_id),expenseTypes[i]);
				if(item[i] == null){
					item[i] = new ExpensePlan();
				}

				Project project = item[i].getProject();
				if(project == null){
					project = new Project();
				}
				project.setId(Long.valueOf(project_id));
				item[i].setProject(project);

				if(com.ndtl.yyky.common.utils.StringUtils.isNotEmpty(expenseTypes[i])){
					item[i].setExpense_type(expenseTypes[i]);
				}

				if(com.ndtl.yyky.common.utils.StringUtils.isNotEmpty(String.valueOf(ratios[i]))){
					item[i].setRatio(ratios[i]);
				}
				expensePlanService.save(item[i]);
			}
			addMessage(redirectAttributes,
					"经费预算配置成功" );
		} catch (Exception e) {
			logger.error("经费预算配置失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/oa/expense/form";
	}

	@RequestMapping(value = { "list" })
	public String list(@RequestParam Map<String, Object> paramMap,
					   Account account, HttpServletRequest request,
					   HttpServletResponse response, Model model) {
		return search(paramMap, account, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Account account,
						 HttpServletRequest request, HttpServletResponse response,
						 Model model) {
		Page<Account> page = accountService.findForCMS(new Page<Account>(
				request, response), account, paramMap);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/accountList";
	}

	@RequestMapping(value = { "detailSearch" })
	public String detailSearch(Map<String, Object> paramMap, Expense expense,
						 HttpServletRequest request, HttpServletResponse response,
						 Model model) {
		Page<Expense> page = expenseService.findForCMS(new Page<Expense>(
				request, response), expense, paramMap);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/expenseDetailList";
	}

	/**
	 * 项目经费年度结算
	 * @param paramMap
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "projectAccountByYear")
	public String projectAccountByYear(@RequestParam Map<String, Object> paramMap,Account account,
									   HttpServletRequest request, HttpServletResponse response,
									   Model model) {
		Page<Map> page = accountService.projectAccountByYear(new Page<Map>(
				request, response),paramMap);
		List<Project> projectList = projectService.findApprovalProjects();
		model.addAttribute("projectList", projectList);
		model.addAttribute("page", page);
		model.addAttribute("paramMap", paramMap);
		return "modules/cms/projectAmountList";
	}

	/**
	 * 其它经费报销明细
	 * @param paramMap
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "otherAccountDetail")
	public String otherAccountDetail(@RequestParam Map<String, Object> paramMap,
									 HttpServletRequest request, HttpServletResponse response,
									 Model model) {
		Page<Map> page = accountService.otherAccountDetail(new Page<Map>(
				request, response),paramMap);
		model.addAttribute("page", page);
		model.addAttribute("paramMap", paramMap);
		return "modules/cms/otherAmountList";
	}

	/**
	 * 专家评审明细
	 * @param paramMap
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "expertReviewDetail")
	public String expertReviewDetail(@RequestParam Map<String, Object> paramMap,
									 HttpServletRequest request, HttpServletResponse response,
									 Model model) {
		Page<Map> page = accountService.expertReviewDetail(new Page<Map>(
				request, response),paramMap);
		model.addAttribute("page", page);
		model.addAttribute("paramMap", paramMap);
		return "modules/cms/expertReviewList";
	}

	/**
	 * 各科奖励明细
	 * @param paramMap
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "subjectRewardDetail")
	public String subjectRewardDetail(@RequestParam Map<String, Object> paramMap,
									 HttpServletRequest request, HttpServletResponse response,
									 Model model) {
		Page<Map> page = accountService.subjectRewardDetail(new Page<Map>(request, response),paramMap);
		model.addAttribute("page", page);
		model.addAttribute("paramMap", paramMap);
		return "modules/cms/subjectRewardList";
	}


	@RequestMapping(value = "exportExpenseDetail", method = RequestMethod.POST)
	public String exportExpenseDetail(Map<String, Object> paramMap, Expense expense,
									HttpServletRequest request, HttpServletResponse response,
									RedirectAttributes redirectAttributes) {
		try {
			String fileName = "经费支出明细" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Expense> page = expenseService.findForCMS(new Page<Expense>(
					request, response, -1), expense, paramMap);

			new ExportExcel("经费支出明细", Expense.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/?repage";
	}

	@RequestMapping(value = "exportAccountYear", method = RequestMethod.POST)
	public String exportAccountYear(Map<String, Object> paramMap, Expense expense,
							 HttpServletRequest request, HttpServletResponse response,
							 RedirectAttributes redirectAttributes) {
		try {
			String fileName = "经费年度统计" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Map> page = accountService.projectAccountByYear(new Page<Map>(
					request, response, -1),paramMap);

			Map<String, String> titleMap = new ColumnTitleMap("projectYearAccount").getColumnTitleMap();

			ExportExcel excel = new ExportExcel("经费年度统计",new ArrayList<String>(titleMap.values()));
			excel.setDataListMap(page.getList(),new ArrayList<String>(titleMap.keySet()))
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/?repage";
	}

	@RequestMapping(value = "exportOtherAccountDetail", method = RequestMethod.POST)
	public String exportOtherAccountDetail(Map<String, Object> paramMap, Expense expense,
									HttpServletRequest request, HttpServletResponse response,
									RedirectAttributes redirectAttributes) {
		try {
			String fileName = "其它经费报销明细" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Map> page = accountService.otherAccountDetail(new Page<Map>(
					request, response, -1),paramMap);

			Map<String, String> titleMap = new ColumnTitleMap("otherAccountDetail").getColumnTitleMap();

			ExportExcel excel = new ExportExcel("其它经费报销明细",new ArrayList<String>(titleMap.values()));
			excel.setDataListMap(page.getList(),new ArrayList<String>(titleMap.keySet()))
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/?repage";
	}

	@RequestMapping(value = "exportExpertReviewDetail", method = RequestMethod.POST)
	public String exportExpertReviewDetail(Map<String, Object> paramMap,HttpServletRequest request, HttpServletResponse response,
									RedirectAttributes redirectAttributes) {
		try {
			String fileName = "专家评审明细" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Map> page = accountService.expertReviewDetail(new Page<Map>(
					request, response, -1),paramMap);

			Map<String, String> titleMap = new ColumnTitleMap("expertReviewDetail").getColumnTitleMap();

			ExportExcel excel = new ExportExcel("专家评审明细",new ArrayList<String>(titleMap.values()));
			excel.setDataListMap(page.getList(),new ArrayList<String>(titleMap.keySet()))
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/?repage";
	}

	@RequestMapping(value = "exportSubjectRewardDetail", method = RequestMethod.POST)
	public String exportSubjectRewardDetail(Map<String, Object> paramMap,HttpServletRequest request, HttpServletResponse response,
									RedirectAttributes redirectAttributes) {
		try {
			String fileName = "各科奖励明细" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Map> page = accountService.subjectRewardDetail(new Page<Map>(
					request, response, -1),paramMap);

			Map<String, String> titleMap = new ColumnTitleMap("subjectRewardDetail").getColumnTitleMap();

			ExportExcel excel = new ExportExcel("各科奖励明细",new ArrayList<String>(titleMap.values()));
			excel.setDataListMap(page.getList(),new ArrayList<String>(titleMap.keySet()))
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/?repage";
	}
}
