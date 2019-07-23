package com.ndtl.yyky.modules.oa.service;

import java.util.Date;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.oa.dao.AchievementDao;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.entity.Achievement;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;

/**
 * 论文登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class AchievementService extends BaseOAService {

	@Autowired
	private AchievementDao achievementDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return achievementDao;
	}

	public Page<Achievement> find(Page<Achievement> page,
			Achievement achievement) {
		DetachedCriteria dc = super.createBaseCriteria(page, achievementDao,
				achievement);
		if (StringUtils.isNotEmpty(achievement.getProjectName())) {
			dc.add(Restrictions.like("projectName",
					"%" + achievement.getProjectName() + "%"));
		}
		if (achievement.getWeightBelong() != null
				&& achievement.getWeightBelong() != 0l) {
			dc.add(Restrictions.like("weightBelong",
					"%" + achievement.getWeightBelong() + "%"));
		}
		Page<Achievement> result = achievementDao.find(page, dc);
		for (Achievement item : result.getList()) {
			super.retriveProcessAndHistory(item);
		}
		return result;
	}

	public Page<Achievement> findForCMS(Page<Achievement> page,
			Achievement achievement, boolean isDataScopeFilter,
			Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, achievementDao,
				achievement);
		if (StringUtils.isNotEmpty(achievement.getProjectName())) {
			dc.add(Restrictions.like("projectName",
					"%" + achievement.getProjectName() + "%"));
		}
		if (achievement.getWeightBelong() != null
				&& achievement.getWeightBelong() != 0l) {
			dc.add(Restrictions.like("weightBelong",
					"%" + achievement.getWeightBelong() + "%"));
		}
		Date beginDate = DateUtils.parseDate(paramMap.get("beginDate"));
		if (beginDate == null) {
			beginDate = DateUtils.setDays(new Date(), 1);
			paramMap.put("beginDate",
					DateUtils.formatDate(beginDate, "yyyy-MM-dd"));
		}
		Date endDate = DateUtils.parseDate(paramMap.get("endDate"));
		if (endDate == null) {
			endDate = DateUtils.addDays(DateUtils.addMonths(beginDate, 1), -1);
			paramMap.put("endDate", DateUtils.formatDate(endDate, "yyyy-MM-dd"));
		}
		dc.add(Restrictions.between("createDate", beginDate, endDate));
		dc.add(Restrictions.like("delFlag", "%" + achievement.getDelFlag()
				+ "%"));
		return achievementDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Achievement achievement = achievementDao.findOne(id);
		achievement.setDelFlag(Achievement.DEL_FLAG_AUDIT);
		achievement.setRemarks(achievement.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		achievement.setAwardLevel((String) variables.get("awardLevel"));
		achievement.setJlLevel((String) variables.get("jlLevel"));
		achievement.setJl((String) variables.get("jl"));
		achievement.setYjl((String) variables.get("yjl"));
		achievementDao.save(achievement);
	}

	@Transactional(readOnly = false)
	public void saveAchievement(Achievement achievement) {
		achievementDao.clear();
		achievementDao.save(achievement);
	}

	public Achievement getAchievementByProjectName(String projectName) {
		return achievementDao.findByProjectName(projectName);
	}

}
