
package com.ndtl.yyky.modules.cms.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.StringUtils;
import com.ndtl.yyky.modules.cms.dao.ArticleDao;
import com.ndtl.yyky.modules.cms.entity.Article;
import com.ndtl.yyky.modules.cms.entity.Site;

/**
 * 统计Service
 */
@Service
@Transactional(readOnly = true)
public class StatsService extends BaseService {

	@Autowired
	private ArticleDao articleDao;
	
	public List<Map<String, Object>> article(Map<String, Object> paramMap) {
		
		StringBuilder ql = new StringBuilder();
		List<Object> ps = Lists.newArrayList();
		
		ql.append("select new map(max(c.id) as categoryId, max(c.name) as categoryName, max(cp.id) as categoryParentId, max(cp.name) as categoryParentName,");
		ql.append("   count(*) as cnt, sum(a.hits) as hits, max(a.updateDate) as updateDate, max(o.id) as officeId, max(o.name) as officeName) ");
		ql.append(" from Article a join a.category c join c.office o join c.parent cp where c.site.id = ");
		ql.append(Site.getCurrentSiteId());
		
		Date beginDate = DateUtils.parseDate(paramMap.get("beginDate"));
		if (beginDate == null){
			beginDate = DateUtils.setDays(new Date(), 1);
			paramMap.put("beginDate", DateUtils.formatDate(beginDate, "yyyy-MM-dd"));
		}
		Date endDate = DateUtils.parseDate(paramMap.get("endDate"));
		if (endDate == null){
			endDate = DateUtils.addDays(DateUtils.addMonths(beginDate, 1), -1);
			paramMap.put("endDate", DateUtils.formatDate(endDate, "yyyy-MM-dd"));
		}
		
		Long categoryId = StringUtils.toLong(paramMap.get("categoryId"));
		if (categoryId > 0){
			ql.append(" and (c.id = ? or c.parentIds like ?)");
			ps.add(categoryId);
			ps.add("%,"+categoryId+",%");
		}
		
		Long officeId = StringUtils.toLong(paramMap.get("officeId"));
		if (officeId > 0){
			ql.append(" and (o.id = ? or o.parentIds like ?)");
			ps.add(officeId);
			ps.add("%,"+officeId+",%");
		}
		
		ql.append(" and a.updateDate between ? and ?");
		ps.add(beginDate);
		ps.add(DateUtils.addDays(endDate, 1));

		ql.append(" and c.delFlag = ?");
		ps.add(Article.DEL_FLAG_NORMAL);
		
		ql.append(" group by cp.sort, cp.id, c.sort, c.id");
		ql.append(" order by cp.sort, cp.id, c.sort, c.id");
		List<Map<String, Object>> list = articleDao.find(ql.toString(), ps.toArray());
		return list;
	}

}
