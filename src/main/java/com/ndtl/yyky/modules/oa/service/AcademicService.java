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
import com.ndtl.yyky.modules.oa.dao.AcademicDao;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.entity.Academic;
import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 学术活动Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class AcademicService extends BaseOAService{
	@Autowired
	private AcademicDao academicDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return academicDao;
	}
	
	public Page<Academic> find(Page<Academic> page, Academic academic) {
		DetachedCriteria dc = super.createBaseCriteria(page, academicDao,
				academic);
		dc.createAlias("office", "office");
		dc.add(dataScopeFilter(UserUtils.getUser(), "office", "createBy"));
		if (StringUtils.isNotEmpty(academic.getAcademicName())) {
			dc.add(Restrictions.like("academicName",
					"%" + academic.getAcademicName() + "%"));
		}
		if (StringUtils.isNotEmpty(academic.getLevel())) {
			dc.add(Restrictions.like("level",
					"%" + academic.getLevel() + "%"));
		}
		Date beginDate = academic.getStartDate();
		Date endDate = academic.getEndDate();
		if (beginDate != null&& endDate != null) {
			dc.add(Restrictions.or(Restrictions.and(
					Restrictions.between("startDate", beginDate, endDate),
					Restrictions.between("endDate", beginDate, endDate)),
					Restrictions.or(Restrictions.isNull("startDate"),
							Restrictions.isNull("endDate"))));
		}

		Page<Academic> result = academicDao.find(page, dc);
		for (Academic item : result.getList()) {
			super.retriveProcessAndHistory(item);
		}
		return result;
	}

	public Page<Academic> findForCMS(Page<Academic> page, Academic academic,
			boolean isDataScopeFilter, Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, academicDao, academic);
		dc.createAlias("office", "office");
		dc.add(dataScopeFilter(UserUtils.getUser(), "office", "createBy"));
		if (academic.getOffice() != null && academic.getOffice().getId() != null) {
			dc.add(Restrictions.or(Restrictions.eq("office.id", academic
					.getOffice().getId())));
		}
		if (StringUtils.isNotEmpty(academic.getAcademicName())) {
			dc.add(Restrictions.like("academicName",
					"%" + academic.getAcademicName() + "%"));
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
		dc.add(Restrictions.like("delFlag", "%" + academic.getDelFlag()
				+ "%"));
		return academicDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Academic academic = academicDao.findOne(id);
		if(StringUtils.isNotEmpty((String) variables.get("remarks"))){
			academic.setRemarks(academic.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		academic.setDelFlag(Academic.DEL_FLAG_AUDIT);
		academicDao.save(academic);
	}

	@Transactional(readOnly = false)
	public void saveAcademic(Academic academic) {
		academicDao.clear();
		academicDao.save(academic);
	}

	@SuppressWarnings("unchecked")
	public List<Academic> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Academic> results = new ArrayList<Academic>();
		results = (List<Academic>) super.findTodoTasks(userId, key);
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public List<Academic> findAcademicWithoutCost(Long userId, List<Academiccost> academiccosts) {
		List<Academic> results = academicDao.findFinished(userId);
		for(Academic academic: academicDao.findFinished(userId)){
			for(Academiccost academiccost:academiccosts){
				if(academiccost.getAcademic()!=null&&academic.getId()==academiccost.getAcademic().getId()){
					results.remove(academic);
				}
			}
		}
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public List<Academic> findFinishedAcademicByUser(Long userId) {
		return academicDao.findFinished(userId);
	}

	public Academic getByAcademicName(String academicname) {
		return academicDao.findByAcademicname(academicname);
	}
	
	@Transactional(readOnly = false)
	public void editAcademic(Academic acad) {
		academicDao.clear();
		academicDao.save(acad);
	}
}
