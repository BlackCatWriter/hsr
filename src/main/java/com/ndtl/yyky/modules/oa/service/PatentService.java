package com.ndtl.yyky.modules.oa.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.dao.PatentDao;
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;

/**
 * 论文登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class PatentService extends BaseOAService {

	@Autowired
	private PatentDao patentDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return patentDao;
	}

	public Page<Patent> findForSelf(Page<Patent> page, Patent patent) {
		return find(page, patent, true);
	}

	public Page<Patent> find(Page<Patent> page, Patent patent) {
		return find(page, patent, true);
	}

	private Page<Patent> find(Page<Patent> page, Patent patent, boolean onlySelf) {
		DetachedCriteria dc = super.createBaseCriteria(page, patentDao, patent);
		if (StringUtils.isNotEmpty(patent.getSearchYear())) {
			dc.add(Restrictions.like("time", "%" + patent.getSearchYear() + "%"));
		}
		if (StringUtils.isNotEmpty(patent.getTitle())) {
			dc.add(Restrictions.like("title", "%" + patent.getTitle() + "%"));
		}
		if (patent.getCategory() != null && !patent.getCategory().equals("0")) {
			dc.add(Restrictions.like("category", "%" + patent.getCategory()
					+ "%"));
		}
		Page<Patent> result = patentDao.find(page, dc);
		for (Patent item : result.getList()) {
			item = (Patent) super.retriveProcessAndHistory(item);
		}
		return result;
	}

	public Page<Patent> findForCMS(Page<Patent> page, Patent patent,
			Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, patentDao, patent);
		if (StringUtils.isNotEmpty(patent.getTitle())) {
			dc.add(Restrictions.like("title", "%" + patent.getTitle() + "%"));
		}
		if (patent.getCategory() != null && !patent.getCategory().equals("0")) {
			dc.add(Restrictions.like("category", "%" + patent.getCategory()
					+ "%"));
		}
		if (StringUtils.isNotEmpty(patent.getSearchYear())) {
			Calendar calendar = Calendar.getInstance();
			calendar.set(Calendar.YEAR, Integer.valueOf(patent.getSearchYear()));
			calendar.set(Calendar.MONTH, Calendar.JANUARY);
			calendar.set(Calendar.DATE, 1);
			Date before = calendar.getTime();
			Calendar calendar1 = Calendar.getInstance();
			calendar1.set(Calendar.YEAR,
					Integer.valueOf(patent.getSearchYear()));
			calendar1.set(Calendar.MONTH, Calendar.DECEMBER);
			calendar1.set(Calendar.DATE, 31);
			Date after = calendar1.getTime();
			dc.add(Restrictions.between("time", before, after));
			// dc.add(Restrictions.like("time", "%" + patent.getSearchYear() +
			// "%"));
		}
		dc.add(Restrictions.like("delFlag", "%" + patent.getDelFlag() + "%"));
		return patentDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Patent patent = patentDao.findOne(id);
		patent.setJl((String) variables.get("jl"));
		patent.setWeight((String) variables.get("weight"));
		patent.setDelFlag(Patent.DEL_FLAG_AUDIT);
		if(StringUtils.isNotEmpty((String) variables.get("remarks"))){
			patent.setRemarks(patent.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		patentDao.save(patent);
	}

	@Transactional(readOnly = false)
	public void savePatent(Patent patent) {
		patentDao.clear();
		patentDao.save(patent);
	}

	@SuppressWarnings("unchecked")
	public List<Patent> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Patent> results = new ArrayList<Patent>();
		results = (List<Patent>) super.findTodoTasks(userId, key);
		return results;
	}

	public Patent getPatentByPatentName(String patentName) {
		return patentDao.findByPatentName(patentName);
	}

	public List<Patent> findForWeightBelong(Long userId, String year) {
		DetachedCriteria dc = super.createDCForWeightBelong(userId, year);
		return patentDao.find(dc);
	}

	public List<Patent> findForAchieve(Long userId, String year) {
		DetachedCriteria dc = super.createDCForAchieve(year);
		dc.add(Restrictions.or(Restrictions.eq("author1", userId.toString()),
				Restrictions.eq("author2", userId.toString()),
				Restrictions.eq("author3", userId.toString()),
				Restrictions.eq("weightBelong", userId)));
		List<Patent> searchResult = patentDao.find(dc);
		List<Patent> result = Lists.newArrayList();
		for (Patent patent : searchResult) {
			if (isAchieve(patent, userId)) {
				result.add(patent);
			}
		}
		return result;
	}

	public List<Patent> findForAchieve(Long userId) {
		DetachedCriteria dc = super.createDCForAchieve();
		dc.add(Restrictions.or(Restrictions.eq("author1", userId.toString()),
				Restrictions.eq("author2", userId.toString()),
				Restrictions.eq("author3", userId.toString()),
				Restrictions.eq("weightBelong", userId)));
		List<Patent> searchResult = patentDao.find(dc);
		List<Patent> result = Lists.newArrayList();
		for (Patent patent : searchResult) {
			if (isAchieve(patent, userId)) {
				result.add(patent);
			}
		}
		return result;
	}

	private boolean isAchieve(Patent patent, Long userId) {
		if (StringUtils.isNotEmpty(patent.getAuthor1())
				&& Arrays.asList(patent.getAuthor1().split(",")).contains(
						userId.toString())) {
			return true;
		}
		if (StringUtils.isNotEmpty(patent.getAuthor2())
				&& Arrays.asList(patent.getAuthor2().split(",")).contains(
						userId.toString())) {
			return true;
		}
		if (StringUtils.isNotEmpty(patent.getAuthor3())
				&& Arrays.asList(patent.getAuthor3().split(",")).contains(
						userId.toString())) {
			return true;
		}
		if (patent.getWeightBelong() != null
				&& patent.getWeightBelong().equals(userId)) {
			return true;
		}
		if (StringUtils.isNotEmpty(patent.getOtherAuthor())) {
			if (Arrays.asList(patent.getOtherAuthor().split(",")).contains(
					userId.toString())) {
				return true;
			}
		}
		return false;
	}

	public List<Patent> findForDept(Long userId, String year) {
		DetachedCriteria dc = super.createDCForDept(userId, year);
		return patentDao.find(dc);
	}
	
	@Transactional(readOnly = false)
	public void editPatent(Patent thesis) {
		patentDao.clear();
		if(thesis.getProject()!=null&&thesis.getProject().getId()==null){
			thesis.setProject(null);
		}
		patentDao.save(thesis);
	}
}
