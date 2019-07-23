package com.ndtl.yyky.modules.oa.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.oa.dao.AdvstudyDao;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.entity.Advstudy;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 学术活动Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class AdvstudyService extends BaseOAService{
	@Autowired
	private AdvstudyDao advstudyDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return advstudyDao;
	}
	
	public Page<Advstudy> find(Page<Advstudy> page, Advstudy advstudy) {
		DetachedCriteria dc = super.createBaseCriteria(page, advstudyDao,
				advstudy);
		dc.createAlias("office", "office");
		dc.add(dataScopeFilter(UserUtils.getUser(), "office", "createBy"));
		
		Date beginDate = advstudy.getStartDate();
		Date endDate = advstudy.getEndDate();
		if (beginDate != null&& endDate != null) {
			dc.add(Restrictions.or(Restrictions.and(
					Restrictions.between("startDate", beginDate, endDate),
					Restrictions.between("endDate", beginDate, endDate)),
					Restrictions.or(Restrictions.isNull("startDate"),
							Restrictions.isNull("endDate"))));
		}
		Page<Advstudy> result = advstudyDao.find(page, dc);
		for (Advstudy item : result.getList()) {
			super.retriveProcessAndHistory(item);
		}
		return result;
	}

	public Page<Advstudy> findForCMS(Page<Advstudy> page, Advstudy advstudy,
			boolean isDataScopeFilter, Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, advstudyDao, advstudy);
		if (advstudy.getOffice() != null && advstudy.getOffice().getId() != null) {
			dc.add(Restrictions.or(Restrictions.eq("office.id", advstudy
					.getOffice().getId())));
		}
		dc.createAlias("office", "office");
		dc.add(dataScopeFilter(UserUtils.getUser(), "office", "createBy"));
//		if (StringUtils.isNotEmpty(advstudy.getAdvstudyName())) {
//			dc.add(Restrictions.like("advstudyName",
//					"%" + advstudy.getAdvstudyName() + "%"));
//		}
		Date beginDate = DateUtils.parseDate(paramMap.get("startDate"));
		Date endDate = DateUtils.parseDate(paramMap.get("endDate"));
		if (beginDate != null&& endDate != null) {
			dc.add(Restrictions.or(Restrictions.and(
					Restrictions.between("startDate", beginDate, endDate),
					Restrictions.between("endDate", beginDate, endDate)),
					Restrictions.or(Restrictions.isNull("startDate"),
							Restrictions.isNull("endDate"))));
		}
		dc.add(Restrictions.like("delFlag", "%" + advstudy.getDelFlag()
				+ "%"));
		return advstudyDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Advstudy advstudy = advstudyDao.findOne(id);
		if(variables.get("remarks")!=null){
			advstudy.setRemarks(advstudy.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		advstudy.setDelFlag(Advstudy.DEL_FLAG_AUDIT);
		advstudyDao.save(advstudy);
	}

	@Transactional(readOnly = false)
	public void saveAdvstudy(Advstudy advstudy) {
		advstudyDao.clear();
		advstudyDao.save(advstudy);
	}

	@SuppressWarnings("unchecked")
	public List<Advstudy> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Advstudy> results = new ArrayList<Advstudy>();
		results = (List<Advstudy>) super.findTodoTasks(userId, key);
		return results;
	}

	public List<Advstudy> findAdvstudyWithoutCost(Long userId, List<Academiccost> academiccosts) {
		List<Advstudy> results = advstudyDao.findFinished(userId);
		for(Advstudy advstudy: advstudyDao.findFinished(userId)){
			for(Academiccost academiccost:academiccosts){
				if(academiccost.getAcademic()!=null&&advstudy.getId()==academiccost.getAcademic().getId()){
					results.remove(advstudy);
				}
			}
		}
		return results;
	}
	
	public List<Advstudy> findFinishedAcademicByUser(Long userId) {
		return advstudyDao.findFinished(userId);
	}
	
	@Transactional(readOnly = false)
	public void editAdvstudy(Advstudy book) {
		advstudyDao.clear();
		advstudyDao.save(book);
	}
}
