package com.ndtl.yyky.modules.cms.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ndtl.yyky.common.persistence.BaseEntity;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.entity.Advstudy;
import com.ndtl.yyky.modules.oa.service.AcademiccostService;
import com.ndtl.yyky.modules.oa.service.AdvstudyService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.SystemService;

/**
 * 进修Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/advstudy")
public class CmsAdvstudyController extends BaseOAController {

	@Autowired
	private AdvstudyService advstudyService;
	
	@Autowired
	protected AcademiccostService academiccostService;

	@Autowired
	protected SystemService systemService;

	@ModelAttribute("advstudy")
	public Advstudy get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Advstudy) advstudyService.findOne(id);
		} else {
			return new Advstudy();
		}
	}

	@RequestMapping(value = { "list", "" })
	public String list(@RequestParam Map<String, Object> paramMap,
			Advstudy advstudy, HttpServletRequest request,
			HttpServletResponse response, Model model) {
		advstudy.setDelFlag(BaseEntity.DEL_FLAG_AUDIT);
		return search(paramMap, advstudy, request, response, model);
	}
	
	@RequestMapping(value = { "search" })
	public String search(Map<String, Object> paramMap, Advstudy advstudy,
			HttpServletRequest request, HttpServletResponse response,
			Model model) {
		Page<Advstudy> page = advstudyService.findForCMS(new Page<Advstudy>(request,
				response), advstudy, true, paramMap);
		setUserListInPage(page);
		model.addAttribute("page", page);
		model.addAllAttributes(paramMap);
		return "modules/cms/advstudyList";
	}

	private void setUserListInPage(Page<Advstudy> page) {
		for (int i = 0; i < page.getList().size(); i++) {
			Advstudy advstudy = page.getList().get(i);
			List<Academiccost> academiccosts=academiccostService.finishedCost(advstudy.getCreateBy().getId());
			advstudy.setApplyuser(advstudy.getCreateBy().getName());
			advstudy.setWorktitle(advstudy.getCreateBy().getJobTitle());
			for(Academiccost cost:academiccosts){
				if(cost.getAdvstudy()!=null&&advstudy.getId()==cost.getAdvstudy().getId()){
					advstudy.setAcademiccost(cost);
				}
			}
		}
	}

	@RequestMapping(value = "form")
	public String form(Advstudy advstudy, Model model) {
		advstudy.setApplyuser(advstudy.getCreateBy().getName());
		advstudy.setWorktitle(advstudy.getCreateBy().getJobTitle());
		model.addAttribute("advstudy", advstudy);
		return "modules/cms/advstudyForm";
	}

	@Override
	public BaseOAService getService() {
		return advstudyService;
	}
}
