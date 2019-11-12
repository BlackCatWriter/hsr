package com.ndtl.yyky.modules.cms.web;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
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
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.utils.excel.ImportExcel;
import com.ndtl.yyky.modules.oa.entity.Achievement;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.oa.entity.enums.ProjectStatus;
import com.ndtl.yyky.modules.oa.service.ProjectService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 项目Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/project")
public class CmsProjectController extends BaseOAController {

	@Autowired
	private ProjectService projectService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("project")
	public Project get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Project) projectService.findOne(id);
		} else {
			return new Project();
		}
	}

	@RequiresPermissions("cms:project:view")
	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Project project, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Project> page = projectService.findForRelatedCMS(new Page<Project>(
				request, response), project, paramMap);
		setUserListInPage(page);
		filterUserAgeInPage(page,paramMap);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/projectList";
	}

	@RequestMapping(value = { "listForProject"})
	public String listForProject(@RequestParam Map<String, Object> paramMap,
					   Project project, HttpServletRequest request,
					   HttpServletResponse response, Model model) {
		Page<Project> page = projectService.findForRelatedCMS(new Page<Project>(
				request, response), project, paramMap);
		setUserListInPage(page);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/projectListStatis";
	}

	@RequestMapping(value = { "picForProject"})
	public String picForProject() {
		return "modules/cms/projectPicStatis";
	}

	@RequestMapping(value = "drawEcharts")
	@ResponseBody
	public JSONObject drawEcharts(HttpServletRequest request, Project pro,HttpServletResponse response) {

		JSONObject json = new JSONObject();
		Map<String,List<Project>> groupLevelMap = Maps.newHashMap();
		Map<String,List<Project>> groupOfficelMap = Maps.newHashMap();
		Map<String,Integer> bookMap = Maps.newHashMap();
		JSONArray levelArray = new JSONArray();
		JSONArray officeArray = new JSONArray();
		JSONArray bookArray = new JSONArray();

		// 经费柱状统计
		JSONArray projectNoArray = new JSONArray();
		JSONArray totleFeeArray = new JSONArray();
		JSONArray syFeeArray = new JSONArray();
		JSONArray reFeeArray = new JSONArray();


		String[][] type = {{"论文","科技进步奖","著作","专利"},{"thesis","reward","book","patent"}};

		Page<Project> page = projectService.findForRelatedCMS(new Page<Project>(
				request, response), pro,new HashMap<String, Object>());
		List<Project> pojectList = page.getList();

		int thesis = 0;
		int reward = 0;
		int book = 0;
		int patent = 0;

		for(Project project : pojectList){
			projectNoArray.add(project.getProjectName());
			totleFeeArray.add(Double.valueOf(project.getSd_fee())+Double.valueOf(project.getPt_fee()));
			syFeeArray.add(Double.valueOf(project.getSy_fee()));
			reFeeArray.add(Double.valueOf(project.getSd_fee())+Double.valueOf(project.getPt_fee())-Double.valueOf(project.getSy_fee()));

			String level = project.getLevel();
			if (groupLevelMap.containsKey(level)) {
				groupLevelMap.get(level).add(project);
			} else {
				groupLevelMap.put(level, Lists.newArrayList(project));
			}

			String office = project.getOffice().getName();
			if (groupOfficelMap.containsKey(office)) {
				groupOfficelMap.get(office).add(project);
			} else {
				groupOfficelMap.put(office, Lists.newArrayList(project));
			}

			if(project.getThesis() != null && project.getThesis().size()>0){
				thesis += project.getThesis().size();
				bookMap.put("thesis",thesis);
			}
			if(project.getReward() != null && project.getReward().size()>0){
				reward += project.getReward().size();
				bookMap.put("reward",reward);
			}
			if(project.getBook() != null && project.getBook().size()>0){
				book += project.getBook().size();
				bookMap.put("book",book);
			}
			if(project.getPatent() != null && project.getPatent().size()>0){
				patent += project.getPatent().size();
				bookMap.put("patent",patent);
			}
		}

		for(int i = 0 ; i<type[0].length; i++){
			JSONObject item = new JSONObject();
			item.put("name",type[0][i]);
			item.put("value",bookMap.get(type[1][i]));
			bookArray.add(item);
			json.put("bookArray",bookArray);
		}

		for( String key : groupLevelMap.keySet()){
			JSONObject item = new JSONObject();
			item.put("name",key);
			item.put("value",groupLevelMap.get(key).size());
			levelArray.add(item);
			json.put("levelArray",levelArray);
		}
		for( String key : groupOfficelMap.keySet()){
			JSONObject item = new JSONObject();
			item.put("name",key);
			item.put("value",groupOfficelMap.get(key).size());
			officeArray.add(item);
			json.put("officeArray",officeArray);
		}
		json.put("projectNoArray",projectNoArray);
		json.put("totleFeeArray",totleFeeArray);
		json.put("syFeeArray",syFeeArray);
		json.put("reFeeArray",reFeeArray);
		System.out.println(json);
		return json;
	}

	private void setUserListInPage(Page<Project> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Project project = page.getList().get(i);
			setUserListInForm(project);
		}
	}

	private void filterUserAgeInPage(Page<Project> page,Map map) {
		if(StringUtils.isNotEmpty((String)map.get("age"))){
			int age = Integer.valueOf((String)map.get("age"));
			/*for (int i = 0; i < page.getList().size(); i++) {
				Project project = page.getList().get(i);
				if(UserUtils.getUserAgeByUserId(project.getAuthor1()) != age){
					page.getList().remove(i);
				}
			}*/
			Iterator<Project> itr = page.getList().iterator();
			while(itr.hasNext()) {
				if(UserUtils.getUserAgeByUserId(itr.next().getAuthor1()) != age){
					itr.remove();
				}
			}
		}
	}

	@RequestMapping(value = "projectRealatedForm")
	public String projectRealatedForm(@RequestParam(required = false) Long id,
			RedirectAttributes redirectAttributes, Model model) {
		List<Thesis> thesisList = projectService.findThesisForProject(id);
		model.addAttribute("thesisList", thesisList);
		List<Achievement> achievementList = projectService
				.findAchievementForProject(id);
		model.addAttribute("achievementList", achievementList);
		List<Expense> expenseList = projectService.findExpenseForProject(id);
		model.addAttribute("expenseList", expenseList);
		return "modules/cms/projectRelatedForm";
	}

	private void setUserListInForm(Project project) {
		String strAuthor1 = UserUtils.getDisplayNameForUserList(project
				.getAuthor1());
		String strAuthor2 = UserUtils.getDisplayNameForUserList(project
				.getAuthor2());
		String strAuthor3 = UserUtils.getDisplayNameForUserList(project
				.getAuthor3());
		String strWeightBelong = UserUtils.getUserDisplayName(project
				.getWeightBelong());
		project.setAuthor1DisplayName(strAuthor1);
		project.setAuthor2DisplayName(strAuthor2);
		project.setAuthor3DisplayName(strAuthor3);
		project.setWeightBelongDisplayName(strWeightBelong);
		projectService.copyRelatedAttribute(project);
	}


	@RequestMapping(value = "form")
	public String form(Project project, Model model) {
		setUserListInForm(project);
		model.addAttribute("project", project);
		return "modules/cms/projectForm";
	}

	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(@RequestParam Map<String, Object> paramMap,
			Project project, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "项目数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<Project> page = projectService.findForCMS(new Page<Project>(
					request, response, -1), project, paramMap);
			setUserListInPage(page);
			new ExportExcel("项目数据", Project.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/project/?repage";
	}

	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/project/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Project> list = ei.getDataList(Project.class);
			for (Project project : list) {
				try {
					if ("true".equals(checkProjectName("",
							project.getProjectName()))) {
						convertOffice(project);
						BeanValidators
								.validateWithException(validator, project);
						project.setStatus(ProjectStatus.CLOSE);
						project.setDelFlag(Project.DEL_FLAG_AUDIT);
						projectService.saveProject(project);
						successNum++;
					} else {
						failureMsg.append("<br/>项目 " + project.getProjectName()
								+ " 已存在; ");
						failureNum++;
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>项目 " + project.getProjectName()
							+ " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>项目 " + project.getProjectName()
							+ " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条项目，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条项目"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入项目失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/project/?repage";
	}

	@RequestMapping(value = "importProjectList", method = RequestMethod.POST)
	public String importProjectList(MultipartFile file,
							 RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/project/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<Project> list = ei.getDataList(Project.class);
			for (Project project : list) {
				try {
					if ("true".equals(checkProjectName("",
							project.getProjectName()))) {
						convertOffice(project);
						BeanValidators
								.validateWithException(validator, project);
						project.setStatus(ProjectStatus.CLOSE);
						project.setDelFlag(Project.DEL_FLAG_AUDIT);
						projectService.saveProject(project);
						successNum++;
					} else {
						failureMsg.append("<br/>项目 " + project.getProjectName()
								+ " 已存在; ");
						failureNum++;
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>项目 " + project.getProjectName()
							+ " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>项目 " + project.getProjectName()
							+ " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条项目，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条项目"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入项目失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/oa/expense/projectlist";
	}

	private Project convertName(Project project) {
		project.setAuthor1(extractIdsFromName(project.getAuthor1()));
		project.setAuthor2(extractIdsFromName(project.getAuthor2()));
		project.setAuthor3(extractIdsFromName(project.getAuthor3()));
		project.setWeightBelong(Long.valueOf(extractIdsFromName(project
				.getWeightBelong().toString())));
		return project;
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
	@RequestMapping(value = "checkProjectName")
	public String checkProjectName(String oldProjectName, String projectName) {
		if (projectName != null && projectName.equals(oldProjectName)) {
			return "true";
		} else if (projectName != null
				&& projectService.getProjectByProjectName(projectName) == null) {
			return "true";
		}
		return "false";
	}

	@RequestMapping(value = "getMid/{id}", method = RequestMethod.GET)
	public void getMidFile(HttpServletResponse response, @PathVariable Long id,
			RedirectAttributes redirectAttributes) {
		Project entity = projectService.findOne(id);
		String fileName = entity.getMidTermFile();
		this.getFile(response, id, redirectAttributes, fileName, "project");
	}

	@RequestMapping(value = "getMidTemplete/{id}", method = RequestMethod.GET)
	public void getMidTemplete(HttpServletResponse response,
			@PathVariable Long id, RedirectAttributes redirectAttributes) {
		Project entity = projectService.findOne(id);
		String fileName = entity.getMidTermFileTemplete();
		this.getFile(response, id, redirectAttributes, fileName, "project");
	}

	@RequestMapping(value = "getEndTemplete/{id}", method = RequestMethod.GET)
	public void getEndTemplete(HttpServletResponse response,
			@PathVariable Long id, RedirectAttributes redirectAttributes) {
		Project entity = projectService.findOne(id);
		String fileName = entity.getEndFileTemplete();
		this.getFile(response, id, redirectAttributes, fileName, "project");
	}

	@RequestMapping(value = "getEnd/{id}", method = RequestMethod.GET)
	public void getEndFile(HttpServletResponse response, @PathVariable Long id,
			RedirectAttributes redirectAttributes) {
		Project entity = projectService.findOne(id);
		String fileName = entity.getEndFile();
		this.getFile(response, id, redirectAttributes, fileName, "project");
	}

	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "项目数据导入模板.xlsx";
			new ExportExcel("项目数据", Project.class, 2).write(response, fileName)
					.dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/project/?repage";
	}

	@Override
	public BaseOAService getService() {
		return projectService;
	}
}
