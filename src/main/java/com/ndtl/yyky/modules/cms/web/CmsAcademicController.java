package com.ndtl.yyky.modules.cms.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

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
import com.ndtl.yyky.common.persistence.BaseEntity;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.utils.excel.ImportExcel;
import com.ndtl.yyky.common.utils.excel.fieldtype.OfficeType;
import com.ndtl.yyky.modules.oa.entity.Academic;
import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.service.AcademicService;
import com.ndtl.yyky.modules.oa.service.AcademiccostService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.SystemService;

/**
 * 学术活动Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/academic")
public class CmsAcademicController extends BaseOAController {

	@Autowired
	private AcademicService academicService;

	@Autowired
	protected AcademiccostService academiccostService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("academic")
	public Academic get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Academic) academicService.findOne(id);
		} else {
			return new Academic();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Academic academic, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		academic.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, academic, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Academic academic,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Academic> page = academicService.findForCMS(new Page<Academic>(
				request, response), academic, true, paramMap);
		setUserListInPage(page);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/academicList";
	}

	private void setUserListInPage(Page<Academic> page) {

		for (int i = 0; i < page.getList().size(); i++) {
			Academic academic = page.getList().get(i);
			List<Academiccost> academiccosts = academiccostService
					.finishedCost(academic.getCreateBy().getId());
			academic.setApplyuser(academic.getCreateBy().getName());
			academic.setWorktitle(academic.getCreateBy().getJobTitle());
			for (Academiccost cost : academiccosts) {
				if (cost.getAcademic() != null
						&& academic.getId() == cost.getAcademic().getId()) {
					academic.setAcademiccost(cost);
				}
			}
		}
	}

	@RequestMapping(value = "form")
	public String form(Academic academic, Model model) {
		academic.setApplyuser(academic.getCreateBy().getName());
		academic.setWorktitle(academic.getCreateBy().getJobTitle());
		model.addAttribute("academic", academic);
		return "modules/cms/academicForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Academic academic, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "学术活动数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Academic> page = academicService.find(new Page<Academic>(
					request, response, -1), academic);
			setUserListInPage(page);
			new ExportExcel("学术活动数据", Academic.class)
					.setDataList(page.getList()).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/academic/?repage";
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Academic> list = ei.getDataList(Academic.class);
			for (Academic academic : list) {
				try {
					convertOffice(academic);
					BeanValidators.validateWithException(validator, academic);
					academic.setDelFlag(Academic.DEL_FLAG_AUDIT);
					academicService.save(academic);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>学术活动 " + academic.getAcademicName()
							+ " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>学术活动 " + academic.getAcademicName()
							+ " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条学术活动，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条学术活动"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入学术活动失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/academic/?repage";
	}

	protected void convertOffice(Academic entity) {
		entity.setOffice(OfficeType.getValue(entity.getOfficeName()));
	}

	@ResponseBody
	@RequestMapping(value = "checkAcademicName")
	public String checkAcademicName(String oldAcademicName, String academicName) {
		if (academicName != null && academicName.equals(oldAcademicName)) {
			return "true";
		} else if (academicName != null
				&& academicService.getByAcademicName(academicName) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "学术活动数据导入模板.xlsx";
			new ExportExcel("学术活动数据", Academic.class, 2).write(response,
					fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/academic/?repage";
	}

	@Override
	public BaseOAService getService() {
		return academicService;
	}
}
