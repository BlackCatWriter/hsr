package com.ndtl.yyky.modules.oa.service;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.AchievementDao;
import com.ndtl.yyky.modules.oa.entity.Achievement;

/**
 * 论文登记内容处理器
 * 
 */
@Service
@Transactional
public class AchievementModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private AchievementDao achievementDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Achievement achievement = achievementDao.findOne(new Long(
				processInstance.getBusinessKey()));
		achievement.setOffice(achievementDao.findByOfficeId(new Long(
				(String) delegateTask.getVariable("office"))));
		achievement.setAuthor1((String) delegateTask.getVariable("author1"));
		achievement.setAuthor2((String) delegateTask.getVariable("author2"));
		achievement.setAuthor3((String) delegateTask.getVariable("author3"));
		achievement.setWeightBelong((Long) delegateTask
				.getVariable("weightBelong"));
		achievement.setRemarks((String) delegateTask.getVariable("remarks"));
		achievementDao.save(achievement);
	}
}
