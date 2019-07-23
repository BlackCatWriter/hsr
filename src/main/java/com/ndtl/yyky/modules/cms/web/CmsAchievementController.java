package com.ndtl.yyky.modules.cms.web;

import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

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
import com.ndtl.yyky.common.persistence.BaseEntity;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.utils.excel.ImportExcel;
import com.ndtl.yyky.modules.oa.entity.Achievement;
import com.ndtl.yyky.modules.oa.service.AchievementService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 成果Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/achievement")
public class CmsAchievementController extends BaseOAController {

	@Autowired
	private AchievementService achievementService;

	@Autowired
	protected SystemService systemService;

	@Override
	public BaseOAService getService() {
		return null;
	}

	@ModelAttribute("achievement")
	public Achievement get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Achievement) achievementService.findOne(id);
		} else {
			return new Achievement();
		}
	}

	@RequiresPermissions("cms:achievement:view")
	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Achievement achievement, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		achievement.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, achievement, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Achievement achievement,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Achievement> page = achievementService.findForCMS(
				new Page<Achievement>(request, response), achievement, true,
				paramMap);
		setUserListInPage(page);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/achievementList";
	}

	private void setUserListInPage(Page<Achievement> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Achievement achievement = page.getList().get(i);
			setUserListInForm(achievement);
		}
	}

	@RequiresPermissions("cms:achievement:view")
	@RequestMapping(value = "form")
	public String form(Achievement achievement, Model model) {
		setUserListInForm(achievement);
		model.addAttribute("achievement", achievement);
		return "modules/cms/achievementForm";
	}

	private void setUserListInForm(Achievement achievement) {
		String strAuthor1 = UserUtils.getDisplayNameForUserList(achievement
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(achievement
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(achievement
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(achievement
				.getWeightBelong());
		achievement.setAuthor1DisplayName(strAuthor1);
		achievement.setAuthor2DisplayName(strAuthor2);
		achievement.setAuthor3DisplayName(strAuthor3);
		achievement.setWeightBelongDisplayName(strWeightBelong);
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Achievement achievement,
			HttpServletRequest request, HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "科研成果数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Achievement> page = achievementService.find(
					new Page<Achievement>(request, response, -1), achievement);
			setUserListInPage(page);
			new ExportExcel("科研成果数据", Achievement.class)
					.setDataList(page.getList()).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/achievement/?repage";
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath()
					+ "/cms/achievement/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Achievement> list = ei.getDataList(Achievement.class);
			for (Achievement achievement : list) {
				try {
					if ("true".equals(checkProjectNo("", achievement
							.getProject().getProjectNo()))) {
						BeanValidators.validateWithException(validator,
								achievement);
						achievement = convertName(achievement);
						achievement.setDelFlag(Achievement.DEL_FLAG_AUDIT);
						achievementService.saveAchievement(achievement);
						successNum++;
					} else {
						failureMsg.append("<br/>科研成果 "
								+ achievement.getProject().getProjectNo()
								+ " 已存在; ");
						failureNum++;
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>科研成果 "
							+ achievement.getProject().getProjectNo()
							+ " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>科研成果 "
							+ achievement.getProject().getProjectNo()
							+ " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条科研成果，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条科研成果"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入科研成果失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/achievement/?repage";
	}

	private Achievement convertName(Achievement achievement) {
		achievement.setAuthor1(extractIdsFromName(achievement.getAuthor1()));
		achievement.setAuthor2(extractIdsFromName(achievement.getAuthor2()));
		achievement.setAuthor3(extractIdsFromName(achievement.getAuthor3()));
		achievement.setWeightBelong(Long.valueOf(extractIdsFromName(achievement
				.getWeightBelong().toString())));
		return achievement;
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

	@ResponseBody
	@RequestMapping(value = "checkProjectNo")
	public String checkProjectNo(String oldProjectNo, String projectNo) {
		if (projectNo != null && projectNo.equals(oldProjectNo)) {
			return "true";
		} else if (projectNo != null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "科研成果数据导入模板.xlsx";
			new ExportExcel("科研成果数据", Achievement.class, 2).write(response,
					fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/achievement/?repage";
	}

}
