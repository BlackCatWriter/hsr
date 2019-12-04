package com.ndtl.yyky.modules.oa.service;

import java.util.ArrayList;
import java.util.Arrays;
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
import com.ndtl.yyky.modules.oa.dao.ThesisDao;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;

/**
 * 论文登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class ThesisService extends BaseOAService {

	@Autowired
	private ThesisDao thesisDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return thesisDao;
	}

	public Page<Thesis> findForSelf(Page<Thesis> page, Thesis thesis) {
		return find(page, thesis, true);
	}

	public Page<Thesis> find(Page<Thesis> page, Thesis thesis) {
		return find(page, thesis, true);
	}

	public List<Thesis> findForAchieve(Long userId, String year) {
		DetachedCriteria dc = super.createDCForAchieve(year);
		List<Thesis> searchResult = thesisDao.find(dc);
		List<Thesis> result = Lists.newArrayList();
		for (Thesis thesis : searchResult) {
			if (isAchieve(thesis, userId)) {
				result.add(thesis);
			}
		}
		return result;
	}

	public List<Thesis> findForAchieve(Long userId) {
		DetachedCriteria dc = super.createDCForAchieve();
		List<Thesis> searchResult = thesisDao.find(dc);
		List<Thesis> result = Lists.newArrayList();
		for (Thesis thesis : searchResult) {
			if (isAchieve(thesis, userId)) {
				result.add(thesis);
			}
		}
		return result;
	}

	private boolean isAchieve(Thesis thesis, Long userId) {
		if (StringUtils.isNotEmpty(thesis.getAuthor1())
				&& Arrays.asList(thesis.getAuthor1().split(",")).contains(
						userId.toString())) {
			return true;
		}
		if (StringUtils.isNotEmpty(thesis.getAuthor2())
				&& Arrays.asList(thesis.getAuthor2().split(",")).contains(
						userId.toString())) {
			return true;
		}
		if (StringUtils.isNotEmpty(thesis.getAuthor3())
				&& Arrays.asList(thesis.getAuthor3().split(",")).contains(
						userId.toString())) {
			return true;
		}
		if (StringUtils.isNotEmpty(thesis.getCo_author())
				&& Arrays.asList(thesis.getCo_author().split(",")).contains(
						userId.toString())) {
			return true;
		}
		if (thesis.getWeightBelong() != null
				&& thesis.getWeightBelong().equals(userId)) {
			return true;
		}
		return false;
	}

	public List<Thesis> findForWeightBelong(Long userId, String year) {
		DetachedCriteria dc = super.createDCForWeightBelong(userId, year);
		return thesisDao.find(dc);
	}

	public List<Thesis> findForDept(Long officeId, String year) {
		DetachedCriteria dc = super.createDCForDept(officeId, year);
		return thesisDao.find(dc);
	}

	private Page<Thesis> find(Page<Thesis> page, Thesis thesis, boolean onlySelf) {
		DetachedCriteria dc = super.createBaseCriteria(page, thesisDao, thesis);
		if (StringUtils.isNotEmpty(thesis.getSearchYear())) {
			dc.add(Restrictions.like("annual_volume",
					"%" + thesis.getSearchYear() + "%"));
		}
		if (StringUtils.isNotEmpty(thesis.getTitle())) {
			dc.add(Restrictions.like("title", "%" + thesis.getTitle() + "%"));
		}
		if (thesis.getCategory() != null && !thesis.getCategory().equals("0")) {
			dc.add(Restrictions.like("category", "%" + thesis.getCategory()
					+ "%"));
		}
		if (thesis.getLevel() != null && !thesis.getLevel().equals("0")) {
			dc.add(Restrictions.like("level", "%" + thesis.getLevel() + "%"));
		}
		Page<Thesis> result = thesisDao.find(page, dc);
		for (Thesis item : result.getList()) {
			item = (Thesis) super.retriveProcessAndHistory(item);
		}
		return result;
	}

	public Page<Thesis> findForCMS(Page<Thesis> page, Thesis thesis) {
		DetachedCriteria dc = super.createBaseCriteria(page, thesisDao, thesis);
		if (StringUtils.isNotEmpty(thesis.getTitle())) {
			dc.add(Restrictions.like("title", "%" + thesis.getTitle() + "%"));
		}
		if (thesis.getCategory() != null && !thesis.getCategory().equals("0")) {
			dc.add(Restrictions.like("category", "%" + thesis.getCategory()
					+ "%"));
		}
		if (thesis.getLevel() != null && !thesis.getLevel().equals("0")) {
			dc.add(Restrictions.like("level", "%" + thesis.getLevel() + "%"));
		}
		if (StringUtils.isNotEmpty(thesis.getSearchYear())) {
			dc.add(Restrictions.like("annual_volume",
					"%" + thesis.getSearchYear() + "%"));
		}
		if (StringUtils.isNotEmpty(thesis.getImpact_factor())) {
			dc.add(Restrictions.like("impact_factor",
					"%" + thesis.getImpact_factor() + "%"));
		}
		if (thesis.getUpdateDate()!=null) {
			dc.add(Restrictions.between("updateDate", thesis.getUpdateDate(),new Date()));
		}
		dc.add(Restrictions.like("delFlag", "%" + thesis.getDelFlag() + "%"));
		return thesisDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Thesis thesis = thesisDao.findOne(id);
		thesis.setBx_fee((String) variables.get("bx_fee"));
		thesis.setJl((String) variables.get("jl"));
		thesis.setWeight((String) variables.get("weight"));
		thesis.setDelFlag(Thesis.DEL_FLAG_AUDIT);
		if(StringUtils.isNotEmpty((String) variables.get("remarks"))){
			thesis.setRemarks(thesis.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		thesisDao.save(thesis);
	}

	@SuppressWarnings("unchecked")
	public List<Thesis> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Thesis> results = new ArrayList<Thesis>();
		results = (List<Thesis>) super.findTodoTasks(userId, key);
		return results;
	}

	public Thesis getThesisByThesisName(String thesisName) {
		return thesisDao.findByThesisName(thesisName);
	}
	
	@Transactional(readOnly = false)
	public void saveThesis(Thesis thesis) {
		thesisDao.clear();
		thesisDao.save(thesis);
	}
	
	@Transactional(readOnly = false)
	public void editThesis(Thesis thesis) {
		thesisDao.clear();
		if(thesis.getProject()!=null&&thesis.getProject().getId()==null){
			thesis.setProject(null);
		}
		thesisDao.save(thesis);
	}

}
