package com.ndtl.yyky.modules.cms.web.statics;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.cms.web.model.DeptPerformanceModel;
import com.ndtl.yyky.modules.cms.web.model.Performance;
import com.ndtl.yyky.modules.cms.web.model.UserPerformanceModel;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.oa.entity.Reward.RewardType;
import com.ndtl.yyky.modules.oa.service.BookService;
import com.ndtl.yyky.modules.oa.service.PatentService;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.RewardService;
import com.ndtl.yyky.modules.oa.service.ThesisService;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 栏目Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/performance")
public class PerformanceController extends BaseController {

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
			Performance performance, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		if (!StringUtils.isEmpty(performance.getSearchYear())
				&& performance.getWeightBelong() != null
				&& performance.getWeightBelong() != 0) {
			setUserListInForm(performance);
			performance
					.setThesisList(thesisService.findForWeightBelong(
							performance.getWeightBelong(),
							performance.getSearchYear()));
			performance
					.setProjectList(projectService.findForWeightBelong(
							performance.getWeightBelong(),
							performance.getSearchYear()));
			performance
					.setBookList(bookService.findForWeightBelong(
							performance.getWeightBelong(),
							performance.getSearchYear()));
			performance
					.setPatentList(patentService.findForWeightBelong(
							performance.getWeightBelong(),
							performance.getSearchYear()));
			List<Reward> res = rewardService.findForWeightBelong(
					performance.getWeightBelong(), performance.getSearchYear());
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
			performance.setNewTecRewardList(newTec);
			performance.setTecAdvrewardList(tecAdv);
			performance.setRewardList(tecPro);
		}
		if (!UserUtils.isManager()) {
			performance.setWeightBelong(UserUtils.getUser().getId());
			performance.setWeightBelongDisplayName(UserUtils.getUser()
					.getName());
		}
		model.addAttribute("performance", performance);
		model.addAllAttributes(paramMap);
		return "modules/cms/performanceList";
	}

	@RequestMapping(value = { "dept" })
	public String deptList(@RequestParam Map<String, Object> paramMap,
			Performance performance, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		if (!StringUtils.isEmpty(performance.getSearchYear())
				&& performance.getOffice().getId() != null
				&& performance.getOffice().getId() != 0L) {
			List<UserPerformanceModel> ums = initPerformanceForDept(performance);
			performance.setUserPerformance(ums);
		}
		if (!UserUtils.isHosLeader() && !UserUtils.isKJDept()
				&& UserUtils.isDeptLeader()) {
			performance.setOffice(UserUtils.getUser().getOffice());
		}
		model.addAttribute("performance", performance);
		model.addAllAttributes(paramMap);
		return "modules/cms/performanceDeptList";
	}

	private List<UserPerformanceModel> initPerformanceForDept(
			Performance performance) {
		Office dept = officeService.get(performance.getOffice().getId());
		performance.setOffice(dept);
		List<Thesis> thesisList = thesisService.findForDept(performance
				.getOffice().getId(), performance.getSearchYear());
		List<Project> projectList = projectService.findForDept(performance
				.getOffice().getId(), performance.getSearchYear());
		List<Patent> patentList = patentService.findForDept(performance
				.getOffice().getId(), performance.getSearchYear());
		List<Book> bookList = bookService.findForDept(performance.getOffice()
				.getId(), performance.getSearchYear());
		List<Reward> rewardList = rewardService.findForDept(performance
				.getOffice().getId(), performance.getSearchYear());
		List<UserPerformanceModel> ums = getUserModel(thesisList, projectList,
				patentList, bookList, rewardList, dept.getName());
		return ums;
	}

	@RequestMapping(value = "deptExport", method = RequestMethod.POST)
	public String deptExport(@RequestParam Map<String, Object> paramMap,
			Performance performance, HttpServletRequest request,
			HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		try {
			List<UserPerformanceModel> ums = initPerformanceForDept(performance);
			String fileName = "绩效数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			new ExportExcel("绩效数据", UserPerformanceModel.class)
					.setDataList(ums).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()
				+ "/cms/performance/dept/?repage";
	}

	@RequestMapping(value = { "total" })
	public String totalList(@RequestParam Map<String, Object> paramMap,
			Performance performance, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		if (!StringUtils.isEmpty(performance.getSearchYear())) {
			List<DeptPerformanceModel> models = initTotalPerformance(performance);
			performance.setDeptModels(models);
		}
		model.addAttribute("performance", performance);
		model.addAllAttributes(paramMap);
		return "modules/cms/performanceTotalList";
	}

	@RequestMapping(value = "totalExport", method = RequestMethod.POST)
	public String totalExport(@RequestParam Map<String, Object> paramMap,
			Performance performance, HttpServletRequest request,
			HttpServletResponse response, Model model,
			RedirectAttributes redirectAttributes) {
		try {
			List<DeptPerformanceModel> ums = initTotalPerformance(performance);
			String fileName = "全院绩效数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			new ExportExcel("全院绩效数据", DeptPerformanceModel.class)
					.setDataList(ums).write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath()
				+ "/cms/performance/total/?repage";
	}

	private List<DeptPerformanceModel> initTotalPerformance(
			Performance performance) {
		List<Office> offices = officeService.findAll();
		List<DeptPerformanceModel> models = Lists.newArrayList();
		for (Office o : offices) {
			List<Thesis> thesisList = thesisService.findForDept(o.getId(),
					performance.getSearchYear());
			List<Project> projectList = projectService.findForDept(o.getId(),
					performance.getSearchYear());
			List<Patent> patentList = patentService.findForDept(o.getId(),
					performance.getSearchYear());
			List<Book> bookList = bookService.findForDept(o.getId(),
					performance.getSearchYear());
			List<Reward> rewardList = rewardService.findForDept(o.getId(),
					performance.getSearchYear());
			if((thesisList!=null&&thesisList.size()>0)||(projectList!=null&&projectList.size()>0)||(patentList!=null&&patentList.size()>0)
					||(bookList!=null&&bookList.size()>0)||(rewardList!=null&&rewardList.size()>0)){
				DeptPerformanceModel deptModel = getDeptModel(thesisList,
						projectList, patentList, bookList, rewardList);
				deptModel.setOffice(o);
				models.add(deptModel);
			}
		}
		return models;
	}

	private List<UserPerformanceModel> getUserModel(List<Thesis> thesisList,
			List<Project> projectList, List<Patent> patentList,
			List<Book> bookList, List<Reward> rewardList, String officeName) {
		Set<Long> result = new HashSet<Long>();
		List<UserPerformanceModel> userModels = Lists.newArrayList();
		for (Thesis entity : thesisList) {
			if (result.contains(entity.getWeightBelong())) {
				UserPerformanceModel uModel = getModelByUserId(
						entity.getWeightBelong(), userModels);
				if (uModel == null) {
					continue;
				} else {
					uModel = addThesisToModel(entity, uModel);
				}
			} else {
				result.add(entity.getWeightBelong());
				UserPerformanceModel uModel = new UserPerformanceModel();
				uModel.setOfficeName(officeName);
				uModel.setUser(systemService.getUser(entity.getWeightBelong()));
				uModel = addThesisToModel(entity, uModel);
				userModels.add(uModel);
			}
		}
		for (Project entity : projectList) {
			if (result.contains(entity.getWeightBelong())) {
				UserPerformanceModel uModel = getModelByUserId(
						entity.getWeightBelong(), userModels);
				if (uModel == null) {
					continue;
				} else {
					uModel = addProjectToModel(entity, uModel);
				}
			} else {
				result.add(entity.getWeightBelong());
				UserPerformanceModel uModel = new UserPerformanceModel();
				uModel.setUser(systemService.getUser(entity.getWeightBelong()));
				uModel = addProjectToModel(entity, uModel);
				userModels.add(uModel);
			}
		}

		for (Reward entity : rewardList) {
			if (result.contains(entity.getWeightBelong())) {
				UserPerformanceModel uModel = getModelByUserId(
						entity.getWeightBelong(), userModels);
				if (uModel == null) {
					continue;
				} else {
					uModel = addRewardToModel(entity, uModel);
				}
			} else {
				result.add(entity.getWeightBelong());
				UserPerformanceModel uModel = new UserPerformanceModel();
				uModel.setUser(systemService.getUser(entity.getWeightBelong()));
				uModel = addRewardToModel(entity, uModel);
				userModels.add(uModel);
			}
		}

		for (Book entity : bookList) {
			if (result.contains(entity.getWeightBelong())) {
				UserPerformanceModel uModel = getModelByUserId(
						entity.getWeightBelong(), userModels);
				if (uModel == null) {
					continue;
				} else {
					uModel = addBookToModel(entity, uModel);
				}
			} else {
				result.add(entity.getWeightBelong());
				UserPerformanceModel uModel = new UserPerformanceModel();
				uModel.setUser(systemService.getUser(entity.getWeightBelong()));
				uModel = addBookToModel(entity, uModel);
				userModels.add(uModel);
			}
		}
		for (Patent entity : patentList) {
			if (result.contains(entity.getWeightBelong())) {
				UserPerformanceModel uModel = getModelByUserId(
						entity.getWeightBelong(), userModels);
				if (uModel == null) {
					continue;
				} else {
					uModel = addPatentToModel(entity, uModel);
				}
			} else {
				result.add(entity.getWeightBelong());
				UserPerformanceModel uModel = new UserPerformanceModel();
				uModel.setUser(systemService.getUser(entity.getWeightBelong()));
				uModel = addPatentToModel(entity, uModel);
				userModels.add(uModel);
			}
		}
		return userModels;
	}

	private DeptPerformanceModel getDeptModel(List<Thesis> thesisList,
			List<Project> projectList, List<Patent> patentList,
			List<Book> bookList, List<Reward> rewardList) {
		DeptPerformanceModel uModel = new DeptPerformanceModel();
		for (Thesis entity : thesisList) {
			uModel = (DeptPerformanceModel) addThesisToModel(entity, uModel);
		}
		for (Project entity : projectList) {
			uModel = (DeptPerformanceModel) addProjectToModel(entity, uModel);
		}
		for (Reward entity : rewardList) {
			uModel = (DeptPerformanceModel) addRewardToModel(entity, uModel);
		}
		for (Book entity : bookList) {
			uModel = (DeptPerformanceModel) addBookToModel(entity, uModel);
		}
		for (Patent entity : patentList) {
			uModel = (DeptPerformanceModel) addPatentToModel(entity, uModel);
		}
		return uModel;
	}

	private UserPerformanceModel getModelByUserId(Long id,
			List<UserPerformanceModel> userModels) {
		for (UserPerformanceModel m : userModels) {
			if (m.getUser().getId().equals(id)) {
				return m;
			}
		}
		return null;
	}

	private UserPerformanceModel addThesisToModel(Thesis entity,
			UserPerformanceModel model) {
		if (entity.getLevel().equals("1")) {
			int count = model.getSciCount();
			count++;
			model.setSciCount(count);
			int weight = model.getSciWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setSciWeight(weight);
		} else if (entity.getLevel().equals("2")) {
			int count = model.getChineseCount();
			count++;
			model.setChineseCount(count);
			int weight = model.getChineseWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setChineseWeight(weight);
		} else {
			int count = model.getOtherCount();
			count++;
			model.setOtherCount(count);
			int weight = model.getOtherWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setOtherWeight(weight);
		}
		return model;
	}

	private UserPerformanceModel addRewardToModel(Reward entity,
			UserPerformanceModel model) {
		if (entity.getType().equals(RewardType.newTec.name())) {
			int count = model.getNewTecCount();
			count++;
			model.setNewTecCount(count);
			int weight = model.getNewTecWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setNewTecWeight(weight);
		} else if (entity.getType().equals(RewardType.tecAdv.name())) {
			int count = model.getTecAdvCount();
			count++;
			model.setTecAdvCount(count);
			int weight = model.getTecAdvWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setTecAdvWeight(weight);
		} else {
			int count = model.getTecProCount();
			count++;
			model.setTecProCount(count);
			int weight = model.getTecProWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setTecProWeight(weight);
		}
		return model;
	}

	private UserPerformanceModel addBookToModel(Book entity,
			UserPerformanceModel model) {
		int count = model.getBookCount();
		count++;
		model.setBookCount(count);
		int weight = model.getBookWeight();
		if (StringUtils.isNotEmpty(entity.getWeight())) {
			weight += Integer.valueOf(entity.getWeight());
		}
		model.setBookWeight(weight);
		return model;
	}

	private UserPerformanceModel addPatentToModel(Patent entity,
			UserPerformanceModel model) {
		int count = model.getPatentCount();
		count++;
		model.setPatentCount(count);
		int weight = model.getPatentWeight();
		if (StringUtils.isNotEmpty(entity.getWeight())) {
			weight += Integer.valueOf(entity.getWeight());
		}
		model.setPatentWeight(weight);
		return model;
	}

	private UserPerformanceModel addProjectToModel(Project entity,
			UserPerformanceModel model) {
		if (entity.getLevel().equals("国家")) {
			int count = model.getCountryCount();
			count++;
			model.setCountryCount(count);
			int weight = model.getCountryWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setCountryWeight(weight);
		} else if (entity.getLevel().equals("省级")) {
			int count = model.getProvinceCount();
			count++;
			model.setProvinceCount(count);
			int weight = model.getProvinceWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setProvinceWeight(weight);
		} else {
			int count = model.getOtherProjectCount();
			count++;
			model.setOtherProjectCount(count);
			int weight = model.getOtherProjectWeight();
			if (StringUtils.isNotEmpty(entity.getWeight())) {
				weight += Integer.valueOf(entity.getWeight());
			}
			model.setOtherProjectWeight(weight);
		}
		return model;
	}

	private void setUserListInForm(Performance performance) {
		User user = systemService.findUserById(performance.getWeightBelong());
		String strWeightBelong = UserUtils.getUserDisplayName(performance
				.getWeightBelong());
		performance.setWeightBelongUser(user);
		performance.setWeightBelongDisplayName(strWeightBelong);
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(Thesis performance, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		// try {
		// String fileName = "绩效数据" + DateUtils.getDate("yyyyMMddHHmmss")
		// + ".xlsx";
		// Page<Thesis> page = performanceService.find(new Page<Thesis>(
		// request, response, -1), performance);
		// setUserListInPage(page);
		// new ExportExcel("绩效数据", Thesis.class).setDataList(page.getList())
		// .write(response, fileName).dispose();
		// return null;
		// } catch (Exception e) {
		// addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		// }
		return "redirect:" + Global.getAdminPath() + "/cms/performance/?repage";
	}

	// private Thesis convertName(Thesis performance) {
	// performance.setAuthor1(extractIdsFromName(performance.getAuthor1()));
	// performance.setAuthor2(extractIdsFromName(performance.getAuthor2()));
	// performance.setAuthor3(extractIdsFromName(performance.getAuthor3()));
	// performance
	// .setCo_author(extractIdsFromName(performance.getCo_author()));
	// performance.setWeightBelong(Long.valueOf(extractIdsFromName(performance
	// .getWeightBelong().toString())));
	// return performance;
	// }
	//
	// private String extractIdsFromName(String name) {
	// String id = "";
	// if (name != null && name.trim().length() != 0) {
	// Pattern pattern = Pattern.compile("(?<=\\()[^\\)]+");
	// Matcher matcher = pattern.matcher(name);
	// while (matcher.find()) {
	// String userNo = matcher.group();
	// User user = systemService.findUserByNO(userNo);
	// if (user != null) {
	// id += user.getId();
	// id += ",";
	// }
	// }
	// if (id.endsWith(",")) {
	// id.substring(0, id.lastIndexOf(","));
	// }
	// }
	// return id;
	// }

}
