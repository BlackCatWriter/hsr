package com.ndtl.yyky.modules.oa.service;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.dao.RewardDao;
import com.ndtl.yyky.modules.oa.dao.RewardToUserDao;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.RewardToUser;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;

@Service
@Transactional(readOnly = true)
public class RewardService extends BaseOAService {

	@Autowired
	private RewardDao rewardDao;

	@Autowired
	private RewardToUserDao rewardToUserDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return rewardDao;
	}

	public void flush() {
		rewardDao.flush();
	}

	public Page<Reward> find(Page<Reward> page, Reward reward, String type) {
		DetachedCriteria dc = super.createBaseCriteria(page, rewardDao, reward);
		String searchYear = reward.getYear();
		if (StringUtils.isNotBlank(searchYear)) {
			dc.add(Restrictions.eq("year", searchYear));
		}
		dc.add(Restrictions.eq("type", type));
		if(reward.getProject()!=null&&StringUtils.isNotBlank(reward.getProjectNo())){
			dc.createAlias("project", "project");
			dc.add(Restrictions.like("project.projectNo",  "%"+reward.getProjectNo()+"%"));
		}
		dc.addOrder(Order.desc("delFlag"));
		Page<Reward> result = rewardDao.find(page, dc);
		for (Reward item : result.getList()) {
			item = (Reward) super.retriveProcessAndHistory(item);
		}
		return result;
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public List<?> findTodoTasks(String userId, ProcessDefinitionKey key,
			String type) {
		List<Reward> results = (List<Reward>) super.findTodoTasks(userId, key);
		List<Reward> result = Lists.newArrayList();
		for (Reward r : results) {
			if (r.getType().equals(type)) {
				result.add(r);
			}
		}
		return result;
	}

	public Page<Reward> findForCMS(Page<Reward> page, Reward reward,
			Map<String, Object> paramMap, String type) {
		DetachedCriteria dc = super.createBaseCriteria(page, rewardDao, reward);
		if (StringUtils.isNotEmpty(reward.getRewardName())) {
			dc.add(Restrictions.like("rewardName", "%" + reward.getRewardName()
					+ "%"));
		}
		String searchYear = reward.getYear();
		if (StringUtils.isNotBlank(searchYear)) {
			dc.add(Restrictions.eq("year", searchYear));
		}
		if(reward.getProject()!=null&&StringUtils.isNotBlank(reward.getProjectNo())){
			dc.createAlias("project", "project");
			dc.add(Restrictions.like("project.projectNo",  "%"+reward.getProjectNo()+"%"));
		}
		if (StringUtils.isNotBlank(reward.getDelFlag())) {
			dc.add(Restrictions.like("delFlag", "%" + reward.getDelFlag() + "%"));
		}
		
		dc.add(Restrictions.eq("type", type));
		dc.addOrder(Order.desc("delFlag"));
		return rewardDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables)
			throws ParseException {
		Reward reward = rewardDao.findOne(id);
		reward.setApprovalOrg((String) variables.get("approvalOrg"));
		reward.setXb_fee((String) variables.get("xb_fee"));
		reward.setPt_fee((String) variables.get("pt_fee"));
		reward.setJlFirst((String) variables.get("jlFirst"));
		reward.setJlSecond((String) variables.get("jlSecond"));
		reward.setCaseCountFirst((String) variables.get("caseCountFirst"));
		reward.setCaseCountSecond((String) variables.get("caseCountSecond"));
		reward.setGrade((String) variables.get("grade"));
		reward.setLevel((String) variables.get("level"));
		reward.setYear((String) variables.get("year"));
		reward.setProcessStatus((String) variables.get("processStatus"));
		if(StringUtils.isNotEmpty((String) variables.get("weight"))){
			reward.setWeight((String) variables.get("weight"));
		}
		if(StringUtils.isNotEmpty((String) variables.get("remarks"))){
			reward.setRemarks(reward.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		if (((Boolean) variables.get("lxSuccess") != null)
				&& ((Boolean) variables.get("lxSuccess")).equals(true)) {
			reward.setDelFlag(Reward.DEL_FLAG_AUDIT);
		}

		if (((Boolean) variables.get("pass") != null)) {
			for (RewardToUser ptu : reward.getRewardToUser()) {
				rewardToUserDao.deleteById(ptu.getId());
			}
		}
		rewardDao.save(reward);
	}

	@Transactional(readOnly = false)
	public void saveReward(Reward reward) {
		rewardDao.clear();
		rewardDao.save(reward);
	}

	public Reward getRewardByRewardName(String rewardName) {
		return rewardDao.findByRewardName(rewardName);
	}

	public Reward findOne(Long id) {
		rewardDao.flush();
		Reward reward = (Reward) super.findOne(id);
		return reward;
	}

	public void refresh() {
		rewardDao.flush();
	}

	public List<Reward> findForWeightBelong(Long userId, String year) {
		DetachedCriteria dc = super.createDCForWeightBelongWithYear(userId,
				year);
		return rewardDao.find(dc);
	}

	public List<Reward> findForAchieve(Long userId, String year) {
		DetachedCriteria dc = super.createDCForAchieveWithYear(year);
		dc.add(Restrictions.or(Restrictions.eq("author1", userId.toString()),
				Restrictions.eq("author2", userId.toString()),
				Restrictions.eq("author3", userId.toString()),
				Restrictions.eq("weightBelong", userId)));
		return rewardDao.find(dc);
	}

	public List<Reward> findForDept(Long userId, String year) {
		DetachedCriteria dc = super.createDCForDeptWithYear(userId, year);
		return rewardDao.find(dc);
	}
	
	@Transactional(readOnly = false)
	public void editReward(Reward reward) {
		rewardDao.clear();
		rewardToUserDao.clear();
		Reward old = rewardDao.findOne(reward.getId());
		reward.setRewardToUser(old.getRewardToUser());
		if(reward.getProject()!=null&&reward.getProject().getId()==null){
			reward.setProject(null);
		}
		rewardDao.save(reward);
	}
}
