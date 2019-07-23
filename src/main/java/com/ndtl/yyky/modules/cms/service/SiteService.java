
package com.ndtl.yyky.modules.cms.service;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.cms.dao.SiteDao;
import com.ndtl.yyky.modules.cms.entity.Site;
import com.ndtl.yyky.modules.cms.utils.CmsUtils;

/**
 * 站点Service
 */
@Service
@Transactional(readOnly = true)
public class SiteService extends BaseService {

	@Autowired
	private SiteDao siteDao;
	
	public Site get(Long id) {
		return siteDao.findOne(id);
	}
	
	public Page<Site> find(Page<Site> page, Site site) {
		DetachedCriteria dc = siteDao.createDetachedCriteria();
		if (StringUtils.isNotEmpty(site.getName())){
			dc.add(Restrictions.like("name", "%"+site.getName()+"%"));
		}
		dc.add(Restrictions.eq(Site.DEL_FLAG, site.getDelFlag()));
		//dc.addOrder(Order.asc("id"));
		return siteDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void save(Site site) {
		if (site.getCopyright()!=null){
			site.setCopyright(StringEscapeUtils.unescapeHtml4(site.getCopyright()));
		}
		siteDao.save(site);
		CmsUtils.removeCache("site_"+site.getId());
		CmsUtils.removeCache("siteList");
	}
	
	@Transactional(readOnly = false)
	public void delete(Long id, Boolean isRe) {
		siteDao.updateDelFlag(id, isRe!=null&&isRe?Site.DEL_FLAG_NORMAL:Site.DEL_FLAG_DELETE);
		CmsUtils.removeCache("site_"+id);
		CmsUtils.removeCache("siteList");
	}
	
}
