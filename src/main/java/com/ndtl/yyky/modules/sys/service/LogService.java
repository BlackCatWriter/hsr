package com.ndtl.yyky.modules.sys.service;

import java.util.Date;
import java.util.Map;

import org.apache.commons.lang3.ObjectUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.common.utils.StringUtils;
import com.ndtl.yyky.modules.sys.dao.LogDao;
import com.ndtl.yyky.modules.sys.entity.Log;

/**
 * 日志Service
 */
@Service
@Transactional(readOnly = true)
public class LogService extends BaseService {

	@Autowired
	private LogDao logDao;
	
	public Log get(Long id) {
		return logDao.findOne(id);
	}
	
	public Page<Log> find(Page<Log> page, Map<String, Object> paramMap) {
		DetachedCriteria dc = logDao.createDetachedCriteria();

		Long createById = StringUtils.toLong(paramMap.get("createById"));
		if (createById > 0){
			dc.add(Restrictions.eq("createBy.id", createById));
		}
		
		String requestUri = ObjectUtils.toString(paramMap.get("requestUri"));
		if (StringUtils.isNotBlank(requestUri)){
			dc.add(Restrictions.like("requestUri", "%"+requestUri+"%"));
		}

		String exception = ObjectUtils.toString(paramMap.get("exception"));
		if (StringUtils.isNotBlank(exception)){
			dc.add(Restrictions.eq("type", Log.TYPE_EXCEPTION));
		}
		
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
		dc.add(Restrictions.between("createDate", beginDate, endDate));
		
		dc.addOrder(Order.desc("id"));
		return logDao.find(page, dc);
	}
	
}
