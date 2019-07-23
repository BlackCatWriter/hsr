package com.ndtl.yyky.modules.cms.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.CookieUtils;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.cms.entity.Site;
import com.ndtl.yyky.modules.cms.service.SiteService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 站点Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/site")
public class SiteController extends BaseController {

	@Autowired
	private SiteService siteService;

	@ModelAttribute
	public Site get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return siteService.get(id);
		} else {
			return new Site();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(Site site, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Site> page = siteService.find(new Page<Site>(request, response),
				site);
		model.addAttribute("page", page);
		return "modules/cms/siteList";
	}

	@RequestMapping(value = "form")
	public String form(Site site, Model model) {
		model.addAttribute("site", site);
		return "modules/cms/siteForm";
	}

	@RequestMapping(value = "save")
	public String save(Site site, Model model,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/site/?repage";
		}
		if (!beanValidator(model, site)) {
			return form(site, model);
		}
		siteService.save(site);
		addMessage(redirectAttributes, "保存站点'" + site.getName() + "'成功");
		return "redirect:" + Global.getAdminPath() + "/cms/site/?repage";
	}

	@RequestMapping(value = "delete")
	public String delete(Long id, @RequestParam(required = false) Boolean isRe,
			RedirectAttributes redirectAttributes) {
		if (Global.isDemoMode()) {
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + Global.getAdminPath() + "/cms/site/?repage";
		}
		if (Site.isDefault(id)) {
			addMessage(redirectAttributes, "删除站点失败, 不允许删除默认站点");
		} else {
			siteService.delete(id, isRe);
			addMessage(redirectAttributes, (isRe != null && isRe ? "恢复" : "")
					+ "删除站点成功");
		}
		return "redirect:" + Global.getAdminPath() + "/cms/site/?repage";
	}

	/**
	 * 选择站点
	 * 
	 * @param siteId
	 * @return
	 */
	@RequestMapping(value = "select")
	public String select(Long id, boolean flag, HttpServletResponse response) {
		if (id != null) {
			UserUtils.putCache("siteId", id);
			// 保存到Cookie中，下次登录后自动切换到该站点
			CookieUtils.setCookie(response, "siteId", id.toString());
		}
		if (flag) {
			return "redirect:" + Global.getAdminPath();
		}
		return "modules/cms/siteSelect";
	}
}
