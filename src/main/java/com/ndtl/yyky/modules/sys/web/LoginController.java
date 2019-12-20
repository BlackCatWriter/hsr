package com.ndtl.yyky.modules.sys.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.excel.ExportExcel;
import com.ndtl.yyky.modules.sys.utils.PPLicClientUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresUser;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.google.common.collect.Maps;
import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.utils.CacheUtils;
import com.ndtl.yyky.common.utils.CookieUtils;
import com.ndtl.yyky.common.utils.StringUtils;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 登录Controller
 */
@Controller
@SessionAttributes("CKFinder_UserRole")
public class LoginController extends BaseController {

	/**
	 * 管理登录
	 */
	@RequestMapping(value = "${adminPath}/login", method = RequestMethod.GET)
	public String login(HttpServletRequest request,
			HttpServletResponse response, Model model) {
		User user = UserUtils.getUser();
		// 如果已经登录，则跳转到管理首页
		if (user.getId() != null) {
			return "redirect:" + Global.getAdminPath();
		}
		return "modules/sys/sysLogin";
	}

	/**
	 * 管理注册
	 */
	@RequestMapping(value = "${adminPath}/register", method = RequestMethod.GET)
	public String register(HttpServletRequest request,User user, Model model) {
		model.addAttribute("user", user);
		return "modules/sys/registerForm";
	}

	/**
	 * 登录失败，真正登录的POST请求由Filter完成
	 */
	@RequestMapping(value = "${adminPath}/login", method = RequestMethod.POST)
	public String login(
			@RequestParam(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM) String username,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		User user = UserUtils.getUser();
		// 如果已经登录，则跳转到管理首页
		if (user.getId() != null) {
			return "redirect:" + Global.getAdminPath();
		}
		model.addAttribute(FormAuthenticationFilter.DEFAULT_USERNAME_PARAM,
				username);
		model.addAttribute("isValidateCodeLogin",
				isValidateCodeLogin(username, true, false));
		return "modules/sys/sysLogin";
	}

	/**
	 * 登录成功，进入管理首页
	 */
	@RequiresUser
	@RequestMapping(value = "${adminPath}")
	public String index(HttpServletRequest request,
			HttpServletResponse response, Model model) {
		User user = UserUtils.getUser();
		// 未登录，则跳转到登录页
		if (user.getId() == null) {
			return "redirect:" + Global.getAdminPath() + "/login";
		}
		// 权限验证
		Map<String,Object> map = PPLicClientUtils.validateLicDate();
		if(!(boolean)map.get("isLicense")){
			model.addAttribute("basecode", PPLicClientUtils.generateLicRequest());
			model.addAttribute("message", String.valueOf(map.get("message")));
			return "modules/sys/sysLicense";
		}
		if (user.getIsCheck() == 0) {
			addMessage(model, "登录失败，用户还未审核通过！");
			return "modules/sys/sysLogin";
		}
		// 设置文件管理权限
		String ckfinderUserRole = "test";
		if (user.getRoleIdList().contains(9L)) {
			ckfinderUserRole = "admin";
		}
		model.addAttribute("CKFinder_UserRole", ckfinderUserRole);
		// 登录成功后，验证码计算器清零
		isValidateCodeLogin(user.getLoginName(), false, true);
		UserUtils.getUserList();
		if (!user.isInitPsw()) {
			model.addAttribute("user", user);
			return "modules/sys/initPwd";
		}
		if (!user.isInitInfo()) {
			model.addAttribute("user", user);
			return "modules/sys/initInfo";
		}
		// 登录成功后，获取上次登录的当前站点ID
		UserUtils.putCache("siteId",
				StringUtils.toLong(CookieUtils.getCookie(request, "siteId")));
		return "modules/sys/sysIndex";
	}

	@RequestMapping(value = "${adminPath}/license", method = RequestMethod.POST)
	public String saveLicense(@RequestParam(required = false) String licensecode, Model model) {
		// 权限验证
		Map<String,Object> map = PPLicClientUtils.saveLicCode(licensecode);

		if(!(boolean)map.get("isLicense")){
			model.addAttribute("basecode", PPLicClientUtils.generateLicRequest());
			model.addAttribute("message", String.valueOf(map.get("message")));
			return "modules/sys/sysLicense";
		}

		return "modules/sys/sysLogin";
	}

	/**
	 * 获取主题方案
	 */
	@RequestMapping(value = "/theme/{theme}")
	public String getThemeInCookie(@PathVariable String theme,
			HttpServletRequest request, HttpServletResponse response) {
		if (StringUtils.isNotBlank(theme)) {
			CookieUtils.setCookie(response, "theme", theme);
		} else {
			theme = CookieUtils.getCookie(request, "theme");
		}
		return "redirect:" + request.getParameter("url");
	}

	/**
	 * 是否是验证码登录
	 * 
	 * @param useruame
	 *            用户名
	 * @param isFail
	 *            计数加1
	 * @param clean
	 *            计数清零
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static boolean isValidateCodeLogin(String useruame, boolean isFail,
			boolean clean) {
		Map<String, Integer> loginFailMap = (Map<String, Integer>) CacheUtils
				.get("loginFailMap");
		if (loginFailMap == null) {
			loginFailMap = Maps.newHashMap();
			CacheUtils.put("loginFailMap", loginFailMap);
		}
		Integer loginFailNum = loginFailMap.get(useruame);
		if (loginFailNum == null) {
			loginFailNum = 0;
		}
		if (isFail) {
			loginFailNum++;
			loginFailMap.put(useruame, loginFailNum);
		}
		if (clean) {
			loginFailMap.remove(useruame);
		}
		return loginFailNum >= 3;
	}
}
