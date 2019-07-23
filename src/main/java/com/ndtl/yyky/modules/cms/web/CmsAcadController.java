package com.ndtl.yyky.modules.cms.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.ndtl.yyky.modules.oa.entity.Acad;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.service.AcadService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.DictUtils;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 学会登记Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/acad")
public class CmsAcadController extends BaseOAController {

	@Autowired
	private AcadService acadService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("acad")
	public Acad get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Acad) acadService.findOne(id);
		} else {
			return new Acad();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Acad acad, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		acad.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, acad, request, response, model);
	}
	
	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Acad acad,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Acad> page = acadService.findForCMS(new Page<Acad>(request,
				response), acad, true, paramMap);
		setUserListInPage(page);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/acadList";
	}

	private void setUserListInPage(Page<Acad> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Acad acad = page.getList().get(i);
			acad.setApplyuser(acad.getUser().getName());
			acad.setWorktitle(acad.getUser().getJobTitle());
			String education=DictUtils.getDictLabel(acad.getUser().getDegree(), "degree", "");
			acad.setEducation(education);
		}
	}

	@RequestMapping(value = "form")
	public String form(Acad acad, Model model) {
		acad.setApplyuser(acad.getUser().getName());
		acad.setWorktitle(acad.getUser().getJobTitle());
		String education=DictUtils.getDictLabel(acad.getUser().getDegree(), "degree", "");
		acad.setEducation(education);
		model.addAttribute("acad", acad);
		return "modules/cms/acadForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Acad acad, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "奖励数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Acad> page = acadService.find(new Page<Acad>(request,
					response, -1), acad);
			setUserListInPage(page);
			new ExportExcel("奖励数据", Acad.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()
				+ "/cms/acad/?repage";
	}

//	@RequestMapping(value = "import", method = RequestMethod.POST)
//	public String importFile(MultipartFile file,
//			RedirectAttributes redirectAttributes) {
//		if (Global.isDemoMode()) {
//			addMessage(redirectAttributes, "演示模式，不允许操作！");
//			return "redirect:" + Global.getAdminPath()
//					+ "/cms/tecAdvReward/?repage";
//		}
//		try {
//			int successNum = 0;
//			int failureNum = 0;
//			StringBuilder failureMsg = new StringBuilder();
//			ImportExcel ei = new ImportExcel(file, 1, 0);
//			List<Reward> list = ei.getDataList(Reward.class);
//			for (Reward reward : list) {
//				try {
//					if ("true".equals(checkRewardName("",
//							reward.getRewardName()))) {
//						BeanValidators.validateWithException(validator, reward);
//						reward = convertName(reward);
//						acadService.saveReward(reward);
//						successNum++;
//					} else {
//						failureMsg.append("<br/>奖励 " + reward.getRewardName()
//								+ " 已存在; ");
//						failureNum++;
//					}
//				} catch (ConstraintViolationException ex) {
//					failureMsg.append("<br/>奖励 " + reward.getRewardName()
//							+ " 导入失败：");
//					List<String> messageList = BeanValidators
//							.extractPropertyAndMessageAsList(ex, ": ");
//					for (String message : messageList) {
//						failureMsg.append(message + "; ");
//						failureNum++;
//					}
//				} catch (Exception ex) {
//					failureMsg.append("<br/>奖励 " + reward.getRewardName()
//							+ " 导入失败：" + ex.getMessage());
//				}
//			}
//			if (failureNum > 0) {
//				failureMsg.insert(0, "，失败 " + failureNum + " 条奖励，导入信息如下：");
//			}
//			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条奖励"
//					+ failureMsg);
//		} catch (Exception e) {
//			addMessage(redirectAttributes, "导入奖励失败！失败信息：" + e.getMessage());
//		}
//		return "redirect:" + Global.getAdminPath()
//				+ "/cms/tecAdvReward/?repage";
//	}

//	private Acad convertName(Acad acad) {
//		acad.setAuthor1(extractIdsFromName(acad.getAuthor1()));
//		acad.setAuthor2(extractIdsFromName(acad.getAuthor2()));
//		acad.setAuthor3(extractIdsFromName(acad.getAuthor3()));
//		acad.setWeightBelong(Long.valueOf(extractIdsFromName(acad
//				.getWeightBelong().toString())));
//		return acad;
//	}

//	private String extractIdsFromName(String name) {
//		String id = "";
//		if (name != null && name.trim().length() != 0) {
//			Pattern pattern = Pattern.compile("(?<=\\()[^\\)]+");
//			Matcher matcher = pattern.matcher(name);
//			while (matcher.find()) {
//				String userNo = matcher.group();
//				User user = systemService.findUserByNO(userNo);
//				if (user != null) {
//					id += user.getId();
//					id += ",";
//				}
//			}
//			if (id.endsWith(",")) {
//				id.substring(0, id.lastIndexOf(","));
//			}
//		}
//		return id;
//	}

	@ResponseBody
	@RequestMapping(value = "checkAcadName")
	public String checkAcadName(String oldAcadName, String acadName) {
		if (acadName != null && acadName.equals(oldAcadName)) {
			return "true";
		} else if (acadName != null
				&& acadService.getByAcadName(acadName) == null) {
			return "true";
		}
		return "false";
	}

//	@RequestMapping(value = "import/template")
//	public String importFileTemplate(HttpServletResponse response,
//			RedirectAttributes redirectAttributes) {
//		try {
//			String fileName = "奖励数据导入模板.xlsx";
//			new ExportExcel("奖励数据", Reward.class, 2).write(response, fileName)
//					.dispose();
//			return null;
//		} catch (Exception e) {
//			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
//		}
//		return "redirect:" + Global.getAdminPath()
//				+ "/cms/tecAdvReward/?repage";
//	}

	@Override
	public BaseOAService getService() {
		return acadService;
	}
}
