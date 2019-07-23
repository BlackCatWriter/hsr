package com.ndtl.yyky.modules.cms.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ndtl.yyky.common.beanvalidator.BeanValidators;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.utils.excel.ImportExcel;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.service.ExpenseService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.SystemService;

/**
 * 栏目Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/expense")
public class CmsExpenseController extends BaseOAController {

	@Autowired
	private ExpenseService expenseService;

	@Autowired
	private ProjectService projectService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("expense")
	public Expense get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Expense) expenseService.findOne(id);
		} else {
			return new Expense();
		}
	}

	@RequiresPermissions("cms:expense:view")
	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Expense expense, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		return search(paramMap, expense, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Expense expense,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Expense> page = expenseService.findForCMS(new Page<Expense>(
				request, response), expense, paramMap);
		List<Project> projectList = projectService.findApprovalProjectsByRole();
		model.addAttribute("projectList", projectList);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/expenseList";
	}

	@RequiresPermissions("cms:expense:view")
	@RequestMapping(value = "form")
	public String form(Expense expense, Model model) {
		model.addAttribute("expense", expense);
		return "modules/cms/expenseForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Map<String, Object> paramMap, Expense expense,
			HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "经费数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Expense> page = expenseService.findForCMS(new Page<Expense>(
					request, response, -1), expense, paramMap);
			new ExportExcel("经费数据", Expense.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/expense/?repage";
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/expense/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Expense> list = ei.getDataList(Expense.class);
			for (Expense expense : list) {
				BeanValidators.validateWithException(validator, expense);
				expenseService.saveExpense(expense);
				successNum++;
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条经费信息，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条经费信息"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入经费失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/expense/?repage";
	}

	@ResponseBody
	@RequestMapping(value = "checkExpenseName")
	public String checkExpenseName(String oldExpenseName, String expenseName) {
		if (expenseName != null && expenseName.equals(oldExpenseName)) {
			return "true";
		} else if (expenseName != null
				&& expenseService.getExpenseByExpenseName(expenseName) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "经费数据导入模板.xlsx";
			new ExportExcel("经费数据", Expense.class, 2).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/expense/?repage";
	}

	@Override
	public BaseOAService getService() {
		return expenseService;
	}

}
