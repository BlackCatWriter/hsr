package com.ndtl.yyky.modules.cms.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ndtl.yyky.common.beanvalidator.BeanValidators;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.persistence.BaseEntity;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.utils.excel.ImportExcel;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.ThesisService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 栏目Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/thesis")
public class CmsThesisController extends BaseOAController {

	@Autowired
	private ThesisService thesisService;
	
	@Autowired
	private ProjectService projectService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("thesis")
	public Thesis get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Thesis) thesisService.findOne(id);
		} else {
			return new Thesis();
		}
	}

	@RequiresPermissions("cms:thesis:view")
	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Thesis thesis, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		thesis.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, thesis, request, response, model);
	}
	
	@RequestMapping(value = { "list/{id}" })
	public String listByProject(@PathVariable("id") Long id,HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Thesis thesis= new Thesis();
		thesis.setProject(projectService.findOne(id));
		return search(null, thesis, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Thesis thesis,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Thesis> page = thesisService.findForCMS(new Page<Thesis>(request,
				response), thesis);
		setUserListInPage(page);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/thesisList";
	}

	private void setUserListInPage(Page<Thesis> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Thesis thesis = page.getList().get(i);
			setUserListInForm(thesis);
		}
	}

	private void setUserListInForm(Thesis thesis) {
		String strCo_author = UserUtils.getDisplayNameForUserList(thesis
				.getCo_author());
		String strAuthor1 = UserUtils.getDisplayNameForUserList(thesis
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(thesis
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(thesis
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(thesis
				.getWeightBelong());
		thesis.setCo_authorDisplayName(strCo_author);
		thesis.setAuthor1DisplayName(strAuthor1);
		thesis.setAuthor2DisplayName(strAuthor2);
		thesis.setAuthor3DisplayName(strAuthor3);
		thesis.setWeightBelongDisplayName(strWeightBelong);
	}

	@RequestMapping(value = "form")
	public String form(Thesis thesis, Model model) {
		setUserListInForm(thesis);
		model.addAttribute("thesis", thesis);
		return "modules/cms/thesisForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Thesis thesis, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "论文数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Thesis> page = thesisService.findForCMS(new Page<Thesis>(
					request, response, -1), thesis);
			new ExportExcel("论文数据", Thesis.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/thesis/?repage";
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/thesis/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Thesis> list = ei.getDataList(Thesis.class);
			for (Thesis thesis : list) {
				try {
					convertOffice(thesis);
					BeanValidators.validateWithException(validator, thesis);
					thesis.setDelFlag(Thesis.DEL_FLAG_AUDIT);
					thesisService.saveThesis(thesis);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureMsg
							.append("<br/>论文 " + thesis.getTitle() + " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>论文 " + thesis.getTitle() + " 导入失败："
							+ ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条论文，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条论文"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入论文失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/thesis/?repage";
	}

	@ResponseBody
	@RequestMapping(value = "checkThesisName")
	public String checkThesisName(String oldThesisName, String thesisName) {
		if (thesisName != null && thesisName.equals(oldThesisName)) {
			return "true";
		} else if (thesisName != null
				&& thesisService.getThesisByThesisName(thesisName) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "论文数据导入模板.xlsx";
			new ExportExcel("论文数据", Thesis.class, 2).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/thesis/?repage";
	}

	@Override
	public BaseOAService getService() {
		return thesisService;
	}

}
