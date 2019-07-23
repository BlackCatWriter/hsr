package com.ndtl.yyky.modules.cms.web;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;



import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.service.AcademiccostService;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.web.base.BaseOAController;
import com.ndtl.yyky.modules.sys.service.SystemService;

/**
 * 奖励Controller
 */
@Controller
@RequestMapping(value = "${adminPath}/cms/academiccost")
public class CmsAcademiccostController extends BaseOAController {
	
	@Autowired
	protected AcademiccostService academiccostService;
	
	@Autowired
	protected SystemService systemService;

	@ModelAttribute("academiccost")
	public Academiccost get(@RequestParam(required = false) Long id) {
		if (id != null) {
			return (Academiccost) academiccostService.findOne(id);
		} else {
			return new Academiccost();
		}
	}

	@Override
	public BaseOAService getService() {
		return academiccostService;
	}
}
