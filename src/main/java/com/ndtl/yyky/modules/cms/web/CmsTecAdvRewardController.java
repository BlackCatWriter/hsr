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
import com.ndtl.yyky.modules.cms.web.model.RewardConverter;
import com.ndtl.yyky.modules.cms.web.model.TecAdvRewardExportModel;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Reward.RewardType;
import com.ndtl.yyky.modules.oa.service.RewardService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 奖励Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/tecAdvReward")
public class CmsTecAdvRewardController extends BaseOAController {

	private static final String rewardType = RewardType.tecAdv.name();
	@Autowired
	private RewardService rewardService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("reward")
	public Reward get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Reward) rewardService.findOne(id);
		} else {
			return new Reward();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Reward reward, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		reward.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, reward, request, response, model);
	}

	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Reward reward,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Reward> page = rewardService.findForCMS(new Page<Reward>(request,
				response), reward, paramMap, rewardType);
		setUserListInPage(page);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/tecAdvRewardList";
	}

	private void setUserListInPage(Page<Reward> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Reward reward = page.getList().get(i);
			setUserListInForm(reward);
		}
	}

	private void setUserListInForm(Reward reward) {
		String strAuthor1 = UserUtils.getDisplayNameForUserList(reward
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(reward
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(reward
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(reward
				.getWeightBelong());
		reward.setAuthor1DisplayName(strAuthor1);
		reward.setAuthor2DisplayName(strAuthor2);
		reward.setAuthor3DisplayName(strAuthor3);
		reward.setWeightBelongDisplayName(strWeightBelong);
	}

	@RequestMapping(value = "form")
	public String form(Reward reward, Model model) {
		setUserListInForm(reward);
		model.addAttribute("reward", reward);
		return "modules/cms/tecAdvRewardForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(@RequestParam Map<String, Object> paramMap,
			Reward reward, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "院重大实用领先技术奖数据"
					+ DateUtils.getDate("yyyyMMddHHmmss") + ".xlsx";
			Page<Reward> page = rewardService.findForCMS(new Page<Reward>(
					request, response, -1), reward, paramMap, RewardType.tecAdv
					.name());
			new ExportExcel("院重大实用领先技术奖数据", TecAdvRewardExportModel.class)
					.setDataList(page.getList()).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()
				+ "/cms/tecAdvReward/?repage";
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath()
					+ "/cms/tecAdvReward/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<TecAdvRewardExportModel> list = ei
					.getDataList(TecAdvRewardExportModel.class);
			for (TecAdvRewardExportModel model : list) {
				try {
					Reward reward = RewardConverter.convertReward(model);
					BeanValidators.validateWithException(validator, reward);
					rewardService.saveReward(reward);
					successNum++;
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>奖励 " + model.getRewardName()
							+ " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>奖励 " + model.getRewardName()
							+ " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条奖励，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条奖励"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入奖励失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()
				+ "/cms/tecAdvReward/?repage";
	}

	@ResponseBody
	@RequestMapping(value = "checkRewardName")
	public String checkRewardName(String oldRewardName, String rewardName) {
		if (rewardName != null && rewardName.equals(oldRewardName)) {
			return "true";
		} else if (rewardName != null
				&& rewardService.getRewardByRewardName(rewardName) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "奖励数据导入模板.xlsx";
			new ExportExcel("奖励数据", TecAdvRewardExportModel.class, 2).write(
					response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()
				+ "/cms/tecAdvReward/?repage";
	}

	@Override
	public BaseOAService getService() {
		return rewardService;
	}
}
