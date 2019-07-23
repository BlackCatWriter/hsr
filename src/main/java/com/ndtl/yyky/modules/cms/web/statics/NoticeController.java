package com.ndtl.yyky.modules.cms.web.statics;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ndtl.yyky.common.config.Global;
import com.ndtl.yyky.common.mapper.JsonMapper;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.StringUtils;
import com.ndtl.yyky.common.web.BaseController;
import com.ndtl.yyky.modules.cms.entity.Article;
import com.ndtl.yyky.modules.cms.entity.Category;
import com.ndtl.yyky.modules.cms.entity.Site;
import com.ndtl.yyky.modules.cms.service.ArticleService;
import com.ndtl.yyky.modules.cms.service.CategoryService;

/**
 * 文章Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/notice")
public class NoticeController extends BaseController {

	@Autowired
	private ArticleService articleService;
	@Autowired
	private CategoryService categoryService;

	@ModelAttribute
	public Article get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return articleService.get(id);
		} else {
			return new Article();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(Article article, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		Page<Article> page = articleService.find(new Page<Article>(request,
				response), article, true);
		model.addAttribute("page", page);
		return "modules/cms/noticeList";
	}

	@RequestMapping(value = "form")
	public String form(Article article, Model model) {
		// 如果当前传参有子节点，则选择取消传参选择
		if (article.getCategory() != null
				&& article.getCategory().getId() != null) {
			List<Category> list = categoryService.findByParentId(article
					.getCategory().getId(), Site.getCurrentSiteId());
			if (list.size() > 0) {
				article.setCategory(null);
			}
		}
		model.addAttribute("article", article);
		return "modules/cms/noticeForm";
	}

	@RequestMapping(value = "view")
	public String view(Article article, Model model) {
		// 如果当前传参有子节点，则选择取消传参选择
		if (article.getCategory() != null
				&& article.getCategory().getId() != null) {
			List<Category> list = categoryService.findByParentId(article
					.getCategory().getId(), Site.getCurrentSiteId());
			if (list.size() > 0) {
				article.setCategory(null);
			}
		}
		model.addAttribute("article", article);
		return "modules/cms/noticeView";
	}

	@RequestMapping(value = "save")
	public String save(Article article, Model model,
			RedirectAttributes redirectAttributes) {
		articleService.save(article);
		addMessage(redirectAttributes,
				"保存文章'" + StringUtils.abbr(article.getTitle(), 50) + "'成功");
		return "redirect:" + Global.getAdminPath() + "/cms/notice";
	}

	@RequestMapping(value = "delete")
	public String delete(Long id, Long categoryId,
			@RequestParam(required = false) Boolean isRe,
			RedirectAttributes redirectAttributes) {
		// 如果没有审核权限，则不允许删除或发布。
		articleService.delete(id, isRe);
		addMessage(redirectAttributes, (isRe != null && isRe ? "发布" : "删除")
				+ "文章成功");
		return "redirect:" + Global.getAdminPath() + "/cms/notice/";
	}

	/**
	 * 文章选择列表
	 */
	@RequestMapping(value = "selectList")
	public String selectList(Article article, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		list(article, request, response, model);
		return "modules/cms/noticeSelectList";
	}

	/**
	 * 通过编号获取文章标题
	 */
	@ResponseBody
	@RequestMapping(value = "findByIds")
	public String findByIds(String ids) {
		List<Object[]> list = articleService.findByIds(ids);
		return JsonMapper.nonDefaultMapper().toJson(list);
	}
}
