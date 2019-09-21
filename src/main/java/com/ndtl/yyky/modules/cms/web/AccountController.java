package com.ndtl.yyky.modules.cms.web;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.cms.entity.Account;
import com.ndtl.yyky.modules.cms.service.AccountService;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.service.ExpenseService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
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
			addMessage(redirectAttributes,
					"费用填报成功" );
		} catch (Exception e) {
			logger.error("费用填报失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/form";
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
		Page<List<Map<String, Object>>> page = accountService.projectAccountByYear(new Page<List<Map<String, Object>>>(
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
		Page<List<Map<String, Object>>> page = accountService.otherAccountDetail(new Page<List<Map<String, Object>>>(
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
		Page<List<Map<String, Object>>> page = accountService.expertReviewDetail(new Page<List<Map<String, Object>>>(
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
		Page<List<Map<String, Object>>> page = accountService.subjectRewardDetail(new Page<List<Map<String, Object>>>(
				request, response),paramMap);
		model.addAttribute("page", page);
		model.addAttribute("paramMap", paramMap);
		return "modules/cms/subjectRewardList";
	}
}
