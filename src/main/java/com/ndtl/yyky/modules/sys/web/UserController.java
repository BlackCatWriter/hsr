package com.ndtl.yyky.modules.sys.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.alibaba.fastjson.JSONObject;
import com.ndtl.yyky.common.utils.excel.ColumnTitleMap;
import com.ndtl.yyky.modules.cms.entity.Account;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.entity.*;
import com.ndtl.yyky.modules.sys.service.UserEducationService;
import com.ndtl.yyky.modules.sys.service.UserWorkService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresUser;
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

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.beanvalidator.BeanValidators;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.JString;
import com.ndtl.yyky.common.utils.StringUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.common.utils.excel.ImportExcel;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.oa.utils.workflow.Variable;
import com.ndtl.yyky.modules.oa.web.model.UserSelectModel;
import com.ndtl.yyky.modules.sys.service.OfficeService;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 用户Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/user")
public class UserController extends BaseOAController {

	@Autowired
	private SystemService systemService;

	@Autowired
	private OfficeService officeService;

	@Autowired
	private UserEducationService userEducationService;

	@Autowired
	private UserWorkService userWorkService;

	@ModelAttribute
	public User get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return systemService.getUser(id);
		} else {
			return new User();
		}
	}
	/**
	 * 创建
	 *
	 * @param userEducation
	 * @param redirectAttributes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveEducation", method = RequestMethod.POST)
	public JSONObject saveEducation(UserEducation userEducation, RedirectAttributes redirectAttributes) {
		JSONObject json = new JSONObject();
		try {
			userEducation.setUser(UserUtils.getUser());
			userEducationService.save(userEducation);

			json.put("result","success");
		} catch (Exception e) {
			logger.error("填报失败：", e);
			json.put("result","fail");
		}
		return json;
	}

	@RequestMapping(value = "deleteEducation")
	public String deleteEducation(Long id, RedirectAttributes redirectAttributes) {

		try {
			userEducationService.delete(id);

			addMessage(redirectAttributes,
					"删除成功" );
		} catch (Exception e) {
			logger.error("删除失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/sys/user/info";
	}
	/**
	 * 创建
	 *
	 * @param userWork
	 * @param redirectAttributes
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "saveWork", method = RequestMethod.POST)
	public JSONObject saveWork(UserWork userWork,Office office,Long officeId,
						   RedirectAttributes redirectAttributes) {
		JSONObject json = new JSONObject();
		try {
			office.setId(officeId);
			userWork.setUser(UserUtils.getUser());
			userWork.setOffice(office);
			userWorkService.save(userWork);

			json.put("result","success");
		} catch (Exception e) {
			logger.error("填报失败：", e);
			json.put("result","fail");
		}
		return json;
	}

	@RequestMapping(value = "deleteWork")
	public String deleteWork(Long id, RedirectAttributes redirectAttributes) {

		try {
			userWorkService.delete(id);

			addMessage(redirectAttributes,
					"删除成功" );
		} catch (Exception e) {
			logger.error("删除失败：", e);
			addMessage(redirectAttributes, "系统内部错误！");
		}
		return "redirect:" + Global.getAdminPath() + "/sys/user/info";
	}


	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = { "list", "" })
	public String list(User user, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<User> page = systemService.findUser(new Page<User>(request,
				response), user);
		model.addAttribute("page", page);
		return "modules/sys/userList";
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "form")
	public String form(User user, Model model) {
		if (user.getCompany() == null || user.getCompany().getId() == null) {
			user.setCompany(UserUtils.getUser().getCompany());
		}
		if (user.getOffice() == null || user.getOffice().getId() == null) {
			user.setOffice(UserUtils.getUser().getOffice());
		}
		model.addAttribute("user", user);
		model.addAttribute("allRoles", systemService.findAllRole());
		return "modules/sys/userForm";
	}

	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "save")
	public String save(User user, String oldLoginName, String newPassword,
			HttpServletRequest request, Model model,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
		}
		// 修正引用赋值问题，不知道为何，Company和Office引用的一个实例地址，修改了一个，另外一个跟着修改。
		user.setCompany(new Office(StringUtils.toLong(request
				.getParameter("company.id"))));
		user.setOffice(new Office(StringUtils.toLong(request
				.getParameter("office.id"))));
		// 如果新密码为空，则不更换密码
		if (StringUtils.isNotBlank(newPassword)) {
			user.setPassword(SystemService.entryptPassword(newPassword));
		}
		if (!beanValidator(model, user)) {
			return form(user, model);
		}
		if (!"true".equals(checkLoginName(oldLoginName, user.getLoginName()))) {
			addMessage(model, "保存用户'" + user.getLoginName() + "'失败，登录名已存在");
			return form(user, model);
		}
		// 角色数据有效性验证，过滤不在授权内的角色
		List<Role> roleList = Lists.newArrayList();
		List<Long> roleIdList = user.getRoleIdList();
		for (Role r : systemService.findAllRole()) {
			if (roleIdList.contains(r.getId())) {
				roleList.add(r);
			}
		}
		user.setRoleList(roleList);
		// 保存用户信息
		systemService.saveUser(user);
		// 清除当前用户缓存
		if (user.getLoginName().equals(UserUtils.getUser().getLoginName())) {
			UserUtils.getCacheMap().clear();
		}
		addMessage(redirectAttributes, "保存用户'" + user.getLoginName() + "'成功");
		return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
	}

	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "delete")
	public String delete(Long id, RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
		}
		if (UserUtils.getUser().getId().equals(id)) {
			addMessage(redirectAttributes, "删除用户失败, 不允许删除当前用户");
		} else if (User.isAdmin(id)) {
			addMessage(redirectAttributes, "删除用户失败, 不允许删除超级管理员用户");
		} else {
			systemService.deleteUser(id);
			addMessage(redirectAttributes, "删除用户成功");
		}
		return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "export", method = RequestMethod.POST)
	public String exportFile(User user, HttpServletRequest request,
			HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
			String fileName = "用户数据" + DateUtils.getDate("yyyyMMddHHmmss")
					+ ".xlsx";
			Page<User> page = systemService.findUser(new Page<User>(request,
					response, -1), user);
			new ExportExcel("用户数据", User.class).setDataList(page.getList())
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出用户失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
	}

	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "import", method = RequestMethod.POST)
	public String importFile(MultipartFile file,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
		}
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<User> list = ei.getDataList(User.class);
			for (User user : list) {
				try {
					if ("true".equals(checkLoginName("", user.getLoginName()))) {
						user.setPassword(SystemService
								.entryptPassword("123456"));
						BeanValidators.validateWithException(validator, user);
						systemService.saveUser(user);
						successNum++;
					} else {
						failureMsg.append("<br/>登录名 " + user.getLoginName()
								+ " 已存在; ");
						failureNum++;
					}
				} catch (ConstraintViolationException ex) {
					failureMsg.append("<br/>登录名 " + user.getLoginName()
							+ " 导入失败：");
					List<String> messageList = BeanValidators
							.extractPropertyAndMessageAsList(ex, ": ");
					for (String message : messageList) {
						failureMsg.append(message + "; ");
						failureNum++;
					}
				} catch (Exception ex) {
					failureMsg.append("<br/>登录名 " + user.getLoginName()
							+ " 导入失败：" + ex.getMessage());
				}
			}
			if (failureNum > 0) {
				failureMsg.insert(0, "，失败 " + failureNum + " 条用户，导入信息如下：");
			}
			addMessage(redirectAttributes, "已成功导入 " + successNum + " 条用户"
					+ failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入用户失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
	}

	@RequiresPermissions("sys:user:view")
	@RequestMapping(value = "import/template")
	public String importFileTemplate(HttpServletResponse response,
			RedirectAttributes redirectAttributes) {
		try {
			String fileName = "用户数据导入模板.xlsx";
			List<User> list = Lists.newArrayList();
			list.add(UserUtils.getUser());
			new ExportExcel("用户数据", User.class, 2).setDataList(list)
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/sys/user/?repage";
	}

	@ResponseBody
	@RequiresPermissions("sys:user:edit")
	@RequestMapping(value = "checkLoginName")
	public String checkLoginName(String oldLoginName, String loginName) {
		if (loginName != null && loginName.equals(oldLoginName)) {
			return "true";
		} else if (loginName != null
				&& systemService.getUserByLoginName(loginName) == null) {
			return "true";
		}
		return "false";
	}

	@RequiresUser
	@RequestMapping(value = "info")
	public String info(User user, Model model) {
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getName())) {

			if (Global.isDemoMode()) {
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userInfo";
			}
			currentUser = UserUtils.getUser(true);
			currentUser.setEmail(user.getEmail());
			currentUser.setPhone(user.getPhone());
			currentUser.setMobile(user.getMobile());
			currentUser.setRemarks(user.getRemarks());
			if (StringUtils.isNotEmpty(user.getBirthday())) {
				currentUser.setBirthday(user.getBirthday());
			}
			currentUser.setPrefression(user.getPrefression());
			currentUser.setTitle(user.getTitle());
			currentUser.setSex(user.getSex());
			currentUser.setDegree(user.getDegree());
			currentUser.setEducationalBackground(user
					.getEducationalBackground());
			Office office = officeService.get(user.getOffice().getId());
			currentUser.setOffice(office);
			systemService.saveUser(currentUser);
			model.addAttribute("message", "保存用户信息成功");
		}
		currentUser.setUedList(userEducationService.findPlanListByUserId(currentUser.getId()));
		currentUser.setWorkList(userWorkService.findPlanListByUserId(currentUser.getId()));
		model.addAttribute("user", currentUser);
		return "modules/sys/userInfo";
	}

	@RequestMapping(value = "infoSave")
	public String infoSave(User user, Model model,
						   HttpServletRequest request, MultipartFile file) {
		Map<String,String> filePath = getFilePathByWeb("head",
				String.valueOf(UserUtils.getUser().getId()),request);
		try {
			saveFileFromInputStream(
					file.getInputStream(),
					filePath.get("servletPath"),
					file.getOriginalFilename());

		} catch (IOException e) {
			e.printStackTrace();
		}
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getName())) {

			if (Global.isDemoMode()) {
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userInfo";
			}
			currentUser = UserUtils.getUser(true);
			currentUser.setEmail(user.getEmail());
			currentUser.setPhone(user.getPhone());
			currentUser.setMobile(user.getMobile());
			currentUser.setRemarks(user.getRemarks());
			if (StringUtils.isNotEmpty(user.getBirthday())) {
				currentUser.setBirthday(user.getBirthday());
			}
			currentUser.setNation(user.getNation());
			currentUser.setParty(user.getParty());
			currentUser.setNativePlace(user.getNativePlace());
			currentUser.setIdCard(user.getIdCard());
			currentUser.setContactAddress(user.getContactAddress());
			currentUser.setPost(user.getPost());
			currentUser.setHeadImg(filePath.get("relativePath")+"/"+file.getOriginalFilename());
			currentUser.setPrefression(user.getPrefression());
			currentUser.setTitle(user.getTitle());
			currentUser.setSex(user.getSex());
			currentUser.setDegree(user.getDegree());
			currentUser.setEducationalBackground(user
					.getEducationalBackground());
			Office office = officeService.get(user.getOffice().getId());
			currentUser.setOffice(office);
			systemService.saveUser(currentUser);
			model.addAttribute("message", "保存用户信息成功");
		}
		currentUser.setUedList(userEducationService.findPlanListByUserId(currentUser.getId()));
		currentUser.setWorkList(userWorkService.findPlanListByUserId(currentUser.getId()));
		model.addAttribute("user", currentUser);
		return "modules/sys/userInfo";
	}


	/*@RequestMapping(value = "exportUserDetail", method = RequestMethod.POST)
	public String exportUserDetail(Map<String, Object> paramMap,HttpServletRequest request, HttpServletResponse response,
											RedirectAttributes redirectAttributes) {

		User currentUser = UserUtils.getUser();
		currentUser.setUedList(userEducationService.findPlanListByUserId(currentUser.getId()));
		currentUser.setWorkList(userWorkService.findPlanListByUserId(currentUser.getId()));
		try {
			String fileName = "个人档案" + DateUtils.getDate("yyyyMMddHHmmss")+ ".xlsx";

			Map<String, String> titleMap = new ColumnTitleMap("subjectRewardDetail").getColumnTitleMap();

			ExportExcel excel = new ExportExcel("各科奖励明细",new ArrayList<String>(titleMap.values()));
			excel.setDataListMap(page.getList(),new ArrayList<String>(titleMap.keySet()))
					.write(response, fileName).dispose();
			return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出数据失败！失败信息：" + e.getMessage());
		}
		return "redirect:" + Global.getAdminPath() + "/cms/account/?repage";
	}*/

	@RequiresUser
	@RequestMapping(value = "task")
	public String task(User user, Model model) {
		return "modules/sys/userTasks";
	}

	@RequiresUser
	@RequestMapping(value = "initPwd")
	public String initPwd(Model model) {
		User user = UserUtils.getUser();
		user = systemService.findUserById(user.getId());
		model.addAttribute("user", user);
		if (!user.isInitPsw()) {
			return "modules/sys/initPwd";
		}
		if (!user.isInitInfo()) {
			return "modules/sys/initInfo";
		}
		return "modules/sys/initPwd";
	}

	@RequiresUser
	@RequestMapping(value = "changePwd")
	public String changePwd(String oldPassword, String newPassword, Model model) {
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword)
				&& StringUtils.isNotBlank(newPassword)) {
			if (SystemService.validatePassword(oldPassword, user.getPassword())) {
				systemService.updatePasswordById(user.getId(),
						user.getLoginName(), newPassword);
				user = systemService.findUserById(user.getId());
				if (!user.isInitPsw()) {
					user.setInitPsw(true);
				}
				systemService.saveUser(user);
				systemService.refresh();
				model.addAttribute("message", "修改密码成功");
			} else {
				model.addAttribute("message", "修改密码失败，旧密码错误");
				model.addAttribute("user", user);
				return "modules/sys/initPwd";
			}
		}
		model.addAttribute("user", user);
		if (!user.isInitInfo()) {
			return "modules/sys/initInfo";
		}
		return "modules/sys/initPwd";
	}

	@RequiresUser
	@RequestMapping(value = "initInfo")
	public String initInfo(Model model) {
		User user = UserUtils.getUser();
		user = systemService.findUserById(user.getId());
		model.addAttribute("user", user);
		if (!user.isInitInfo()) {
			return "modules/sys/initInfo";
		}
		if (!user.isInitPsw()) {
			return "modules/sys/initPwd";
		}
		return "modules/sys/initInfo";
	}

	@RequiresUser
	@RequestMapping(value = "changeInfo")
	public String changeInfo(User user, Model model) {
		User currentUser = UserUtils.getUser();
		if (StringUtils.isNotBlank(user.getName())) {
			currentUser = UserUtils.getUser(true);
			currentUser.setEmail(user.getEmail());
			currentUser.setPhone(user.getPhone());
			currentUser.setMobile(user.getMobile());
			currentUser.setRemarks(user.getRemarks());
			if (StringUtils.isNotEmpty(user.getBirthday())) {
				currentUser.setBirthday(user.getBirthday());
			}
			currentUser.setPrefression(user.getPrefression());
			currentUser.setTitle(user.getTitle());
			currentUser.setSex(user.getSex());
			currentUser.setDegree(user.getDegree());
			currentUser.setEducationalBackground(user
					.getEducationalBackground());
			Office office = officeService.get(user.getOffice().getId());
			currentUser.setOffice(office);
			if (!currentUser.isInitInfo()) {
				currentUser.setInitInfo(true);
			}
			systemService.saveUser(currentUser);
			systemService.refresh();
			model.addAttribute("message", "保存用户信息成功");
		}
		model.addAttribute("user", currentUser);
		if (!currentUser.isInitPsw()) {
			return "modules/sys/initPwd";
		}
		return "redirect:" + Global.getAdminPath();
	}

	@RequiresUser
	@RequestMapping(value = "modifyPwd")
	public String modifyPwd(String oldPassword, String newPassword, Model model) {
		User user = UserUtils.getUser();
		if (StringUtils.isNotBlank(oldPassword)
				&& StringUtils.isNotBlank(newPassword)) {
			if (Global.isDemoMode()) {
				model.addAttribute("message", "演示模式，不允许操作！");
				return "modules/sys/userModifyPwd";
			}
			if (SystemService.validatePassword(oldPassword, user.getPassword())) {
				systemService.updatePasswordById(user.getId(),
						user.getLoginName(), newPassword);
				user = systemService.findUserById(user.getId());
				systemService.saveUser(user);
				model.addAttribute("message", "修改密码成功");
			} else {
				model.addAttribute("message", "修改密码失败，旧密码错误");
			}
		}
		model.addAttribute("user", user);
		return "modules/sys/userModifyPwd";
	}

	@ResponseBody
	@RequestMapping(value = "userList")
	public String users(@RequestParam(required = false) String q,
			HttpServletResponse response) {
		response.setContentType("application/json; charset=UTF-8");
		List<UserSelectModel> possibleUsers = new ArrayList<UserSelectModel>();
		List<User> users = UserUtils.getUserList();
		String jsResult = "";
		for (User user : users) {
			if (isPossibleName(user, q)) {
				jsResult += user.getName() + "(" + user.getNo() + ")--"
						+ user.getOffice().getName() + "|";
				jsResult += user.getId() + "\n";
				UserSelectModel model = new UserSelectModel(user);
				possibleUsers.add(model);
			}
		}
		String json = JsonMapper.getInstance().toJson(possibleUsers);
		json = json.replaceAll("\\[", "");
		json = json.replaceAll("\\]", "");
		json = json.replaceAll("},", "},\n");
		return jsResult;
	}

	@ResponseBody
	@RequestMapping(value = "users")
	public List<UserSelectModel> users(Variable var,
			HttpServletResponse response) {
		response.setContentType("application/json; charset=UTF-8");
		List<UserSelectModel> possibleUsers = new ArrayList<UserSelectModel>();
		List<User> users = UserUtils.getUserList();
		String value = var.getValues();
		List<Long> idList = Lists.newArrayList();
		if (value.indexOf("@") != -1) {
			String[] ids = value.substring(value.indexOf("@") + 1).split(",");
			for (String id : ids) {
				if (StringUtils.isNotEmpty(id)) {
					idList.add(Long.valueOf(id));
				}
			}
			value = value.substring(0, value.indexOf("@"));
		}
		for (User user : users) {
			if (isPossibleName(user, value)) {
				if (!idList.contains(user.getId())) {
					UserSelectModel model = new UserSelectModel(user);
					possibleUsers.add(model);
				}
			}
		}
		return possibleUsers;
	}

	@ResponseBody
	@RequestMapping(value = "usersWithRole")
	public List<UserSelectModel> usersWithRole(Variable var,
			HttpServletResponse response) {
		response.setContentType("application/json; charset=UTF-8");
		List<UserSelectModel> possibleUsers = new ArrayList<UserSelectModel>();
		List<User> users = UserUtils.getUserList();
		String value = var.getValues();
		List<Long> idList = Lists.newArrayList();
		if (value.indexOf("@") != -1) {
			String[] ids = value.substring(value.indexOf("@") + 1).split(",");
			for (String id : ids) {
				if (StringUtils.isNotEmpty(id)) {
					idList.add(Long.valueOf(id));
				}
			}
			value = value.substring(0, value.indexOf("@"));
		}
		for (User user : users) {
			if (isPossibleNameWithRole(user, value)) {
				if (!idList.contains(user.getId())) {
					UserSelectModel model = new UserSelectModel(user);
					possibleUsers.add(model);
				}
			}
		}
		return possibleUsers;
	}

	private boolean isPossibleName(User user, String value) {
		if (user.getName().contains(value.trim())
				|| JString.getPinYinHeadChar(user.getName()).contains(
						value.trim())) {
			return true;
		}
		return false;
	}

	private boolean isPossibleNameWithRole(User user, String value) {
		if (!UserUtils.isHosLeader() && !UserUtils.isKJDept()
				&& UserUtils.isDeptLeader()) {
			if (user.getOffice().getId()
					.equals(UserUtils.getUser().getOffice().getId())) {
				return isPossibleName(user, value);
			}
			return false;
		}
		return isPossibleName(user, value);
	}

	@Override
	public BaseOAService getService() {
		return null;
	}
}
