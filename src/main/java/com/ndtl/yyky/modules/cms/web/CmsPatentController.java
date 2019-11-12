package com.ndtl.yyky.modules.cms.web;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.ndtl.yyky.modules.oa.entity.Project;
import org.apache.commons.lang3.StringUtils;
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
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.oa.service.PatentService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 栏目Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/patent")
public class CmsPatentController extends BaseOAController {

	@Autowired
	private PatentService patentService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("patent")
	public Patent get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Patent) patentService.findOne(id);
		} else {
			return new Patent();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Patent patent, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		patent.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, patent, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(@RequestParam Map<String, Object> paramMap, Patent patent,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Patent> page = patentService.findForCMS(new Page<Patent>(request,
				response), patent, paramMap);
		setUserListInPage(page);
		filterUserAgeInPage(page,paramMap);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/patentList";
	}

	private void setUserListInPage(Page<Patent> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Patent patent = page.getList().get(i);
			setUserListInForm(patent);
		}
	}
	private void filterUserAgeInPage(Page<Patent> page, Map map) {
		if(StringUtils.isNotEmpty((String)map.get("age"))){
            int age = Integer.valueOf((String)map.get("age"));
            for (int i = 0; i < page.getList().size(); i++) {
                Patent project = page.getList().get(i);
                Integer targetAge = UserUtils.getUserAgeByUserId(project.getAuthor1());
                if(targetAge == null || targetAge != age){
                    page.getList().remove(i);
                    i--;
                }
            }
		}
	}

	private void setUserListInForm(Patent patent) {
		String strOtherAuthor = UserUtils.getDisplayNameForUserList(patent
				.getOtherAuthor());
		String strAuthor1 = UserUtils.getDisplayNameForUserList(patent
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(patent
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(patent
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(patent
				.getWeightBelong());
		patent.setOtherAuthorDisplayName(strOtherAuthor);
		patent.setAuthor1DisplayName(strAuthor1);
		patent.setAuthor2DisplayName(strAuthor2);
		patent.setAuthor3DisplayName(strAuthor3);
		patent.setWeightBelongDisplayName(strWeightBelong);
	}

	@RequestMapping(value = "form")
	public String form(Patent patent, Model model) {
		setUserListInForm(patent);
		model.addAttribute("patent", patent);
		return "modules/cms/patentForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Map<String, Object> paramMap, Patent patent,
			HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "专利数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Patent> page = patentService.findForCMS(new Page<Patent>(
					request, response, -1), patent, paramMap);
			new ExportExcel("专利数据", Patent.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/patent/?repage";
	}

	private Patent convertName(Patent patent) {
		patent.setAuthor1(extractIdsFromName(patent.getAuthor1()));
		patent.setAuthor2(extractIdsFromName(patent.getAuthor2()));
		patent.setAuthor3(extractIdsFromName(patent.getAuthor3()));
		patent.setOtherAuthor(extractIdsFromName(patent.getOtherAuthor()));
		patent.setWeightBelong(Long.valueOf(extractIdsFromName(patent
				.getWeightBelong().toString())));
		return patent;
	}

	private String extractIdsFromName(String name) {
		String id = "";
		if (name != null && name.trim().length() != 0) {
			Pattern pattern = Pattern.compile("(?<=\\()[^\\)]+");
			Matcher matcher = pattern.matcher(name);
			while (matcher.find()) {
				String userNo = matcher.group();
				User user = systemService.findUserByNO(userNo);
				if (user != null) {
					id += user.getId();
					id += ",";
				}
			}
			if (id.endsWith(",")) {
				id.substring(0, id.lastIndexOf(","));
			}
		}
		return id;
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/patent/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Patent> list = ei.getDataList(Patent.class);
			for (Patent patent : list) {
				try {
					convertOffice(patent);
					BeanValidators.validateWithException(validator, patent);
					patent.setDelFlag(Patent.DEL_FLAG_AUDIT);
					patentService.savePatent(patent);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureMsg
							.append("<br/>专利 " + patent.getTitle() + " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>专利 " + patent.getTitle() + " 导入失败："
							+ ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条专利，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条专利"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入专利失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/patent/?repage";
	}

	@ResponseBody
	@RequestMapping(value = "checkPatentName")
	public String checkPatentName(String oldPatentName, String patentName) {
		if (patentName != null && patentName.equals(oldPatentName)) {
			return "true";
		} else if (patentName != null
				&& patentService.getPatentByPatentName(patentName) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "专利数据导入模板.xlsx";
			new ExportExcel("专利数据", Patent.class, 2).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/patent/?repage";
	}

	@Override
	public BaseOAService getService() {
		return patentService;
	}

}
