package com.ndtl.yyky.modules.oa.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.oa.dao.AcadDao;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.entity.Acad;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 学会登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class AcadService extends BaseOAService{
	@Autowired
	private AcadDao acadDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return acadDao;
	}
	
	public Page<Acad> find(Page<Acad> page, Acad acad) {
		DetachedCriteria dc = super.createBaseCriteria(page, acadDao,
				acad);
		if (StringUtils.isNotEmpty(acad.getAcadName())) {
			dc.add(Restrictions.like("acadName",
					"%" + acad.getAcadName() + "%"));
		}
		if (StringUtils.isNotEmpty(acad.getLevel())) {
			dc.add(Restrictions.like("level",
					"%" + acad.getLevel() + "%"));
		}
		dc.createAlias("office", "office");
		dc.add(dataScopeFilter(UserUtils.getUser(), "office", "createBy"));
		Date beginDate = acad.getStartDate();
		Date endDate = acad.getEndDate();
		if (beginDate != null&& endDate != null) {
			dc.add(Restrictions.or(Restrictions.and(
					Restrictions.between("startDate", beginDate, endDate),
					Restrictions.between("endDate", beginDate, endDate)),
					Restrictions.or(Restrictions.isNull("startDate"),
							Restrictions.isNull("endDate"))));
		}
		
		Page<Acad> result = acadDao.find(page, dc);
		List<Acad> putoffAcads= findOwnedContinuedAcad(UserUtils.getUser().getId());
		for (Acad item : result.getList()) {
			if(putoffAcads.contains(item)){
				item.setIsputoff(true);
			}else{
				item.setIsputoff(false);
			}
			super.retriveProcessAndHistory(item);
		}
		return result;
	}
	
	public List<Acad> findOwnedContinuedAcad(Long userId) {
		return (List<Acad>) acadDao.findOwnedContinuedAcad(new Date(), userId);
	}
	
	public void updateEndDate(Long userId, Date date) {
		acadDao.updateEndDate(userId, date);
	}

	public Page<Acad> findForCMS(Page<Acad> page, Acad acad,
			boolean isDataScopeFilter, Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, acadDao, acad);
		dc.createAlias("office", "office");
		dc.add(dataScopeFilter(UserUtils.getUser(), "office", "createBy"));
		if (acad.getOffice() != null && acad.getOffice().getId() != null) {
			dc.add(Restrictions.or(Restrictions.eq("office.id", acad
					.getOffice().getId())));
		}
		if (StringUtils.isNotEmpty(acad.getAcadName())) {
			dc.add(Restrictions.like("acadName",
					"%" + acad.getAcadName() + "%"));
		}
		Date beginDate = DateUtils.parseDate(paramMap.get("startDate"));
		Date endDate = DateUtils.parseDate(paramMap.get("endDate"));
		if (beginDate != null&& endDate != null) {
			dc.add(Restrictions.or(Restrictions.and(
					Restrictions.between("startDate", beginDate, endDate),
					Restrictions.between("endDate", beginDate, endDate)),
					Restrictions.or(Restrictions.isNull("startDate"),
							Restrictions.isNull("endDate"))));
		}
		dc.add(Restrictions.like("delFlag", "%" + acad.getDelFlag()
				+ "%"));
		return acadDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Acad acad = acadDao.findOne(id);
		if(StringUtils.isNotEmpty((String) variables.get("remarks"))){
			acad.setRemarks(acad.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		acad.setDelFlag(Acad.DEL_FLAG_AUDIT);
		acadDao.save(acad);
	}

	@Transactional(readOnly = false)
	public void saveAcad(Acad acad) {
		acadDao.clear();
		acadDao.save(acad);
	}

	@SuppressWarnings("unchecked")
	public List<Acad> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Acad> results = new ArrayList<Acad>();
		results = (List<Acad>) super.findTodoTasks(userId, key);
		return results;
	}

	public Acad getByAcadName(String acadname) {
		return acadDao.findByAcadname(acadname);
	}
	
	@Transactional(readOnly = false)
	public void editAcad(Acad acad) {
		acadDao.clear();
		acadDao.save(acad);
	}
}
