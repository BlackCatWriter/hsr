package com.ndtl.yyky.modules.cms.web.statics;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.cms.web.model.Achieve;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Reward.RewardType;
import com.ndtl.yyky.modules.oa.service.BookService;
import com.ndtl.yyky.modules.oa.service.PatentService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.RewardService;
import com.ndtl.yyky.modules.oa.service.ThesisService;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 栏目Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/achieve")
public class AchieveController extends BaseController {

	@Autowired
	private ThesisService thesisService;

	@Autowired
	private ProjectService projectService;
	@Autowired
	private BookService bookService;
	@Autowired
	private PatentService patentService;
	@Autowired
	private RewardService rewardService;
	@Autowired
	private SystemService systemService;

	@Autowired
	private OfficeService officeService;

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Achieve achieve, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		if (!StringUtils.isEmpty(achieve.getSearchYear())
				&& achieve.getWeightBelong() != null
				&& achieve.getWeightBelong() != 0) {
			setUserListInForm(achieve);
			achieve.setThesisList(thesisService.findForAchieve(
					achieve.getWeightBelong(), achieve.getSearchYear()));
			achieve.setProjectList(projectService.findForAchieve(
					achieve.getWeightBelong(), achieve.getSearchYear()));
			achieve.setBookList(bookService.findForAchieve(
					achieve.getWeightBelong(), achieve.getSearchYear()));
			achieve.setPatentList(patentService.findForAchieve(
					achieve.getWeightBelong(), achieve.getSearchYear()));
			List<Reward> res = rewardService.findForAchieve(
					achieve.getWeightBelong(), achieve.getSearchYear());
			List<Reward> tecPro = Lists.newArrayList();
			List<Reward> newTec = Lists.newArrayList();
			List<Reward> tecAdv = Lists.newArrayList();
			for (Reward re : res) {
				if (re.getType().equals(RewardType.tecProgress.name())) {
					tecPro.add(re);
				} else if (re.getType().equals(RewardType.newTec.name())) {
					newTec.add(re);
				} else if (re.getType().equals(RewardType.tecAdv.name())) {
					tecAdv.add(re);
				}
			}
			achieve.setNewTecRewardList(newTec);
			achieve.setTecAdvrewardList(tecAdv);
			achieve.setRewardList(tecPro);
		}
		if (!UserUtils.isManager()) {
			achieve.setWeightBelong(UserUtils.getUser().getId());
			achieve.setWeightBelongDisplayName(UserUtils.getUser().getName());
		}
		model.addAttribute("achieve", achieve);
		model.addAllAttributes(paramMap);
		return "modules/cms/achieveList";
	}

	private void setUserListInForm(Achieve achieve) {
		User user = systemService.findUserById(achieve.getWeightBelong());
		String strWeightBelong = UserUtils.getUserDisplayName(achieve
				.getWeightBelong());
		achieve.setWeightBelongUser(user);
		achieve.setWeightBelongDisplayName(strWeightBelong);
	}

	// @RequestMapping(value = "export", method = RequestMethod.POST)
	// public String exportFile(Thesis achieve, HttpServletRequest request,
	// HttpServletResponse response, RedirectAttributes redirectAttributes) {
	// // try {
	// // String fileName = "绩效数据" + DateUtils.getDate("yyyyMMddHHmmss")
	// // + ".xlsx";
	// // Page<Thesis> page = achieveService.find(new Page<Thesis>(
	// // request, response, -1), achieve);
	// // setUserListInPage(page);
	// // new ExportExcel("绩效数据", Thesis.class).setDataList(page.getList())
	// // .write(response, fileName).dispose();
	// // return null;
	// // } catch (Exception e) {
	// // addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
	// // }
	// return "redirect:" + Global.getAdminPath() + "/cms/achieve/?repage";
	// }

}
