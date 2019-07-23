package com.ndtl.yyky.modules.oa.service;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.RewardDao;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.sys.entity.Office;

@Service
@Transactional
public class RewardModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private RewardDao rewardDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Reward reward = rewardDao.findOne(new Long(processInstance
				.getBusinessKey()));
		reward.setRewardName((String) delegateTask.getVariable("rewardName"));
		reward.setAuthor1((String) delegateTask.getVariable("author1"));
		reward.setAuthor2((String) delegateTask.getVariable("author2"));
		reward.setAuthor3((String) delegateTask.getVariable("author3"));
		reward.setWeightBelong(Long.valueOf(delegateTask.getVariable(
				"weightBelong").toString()));
		reward.setProfession((String) delegateTask.getVariable("profession"));
		if (delegateTask.getVariable("officeName") != null) {
			Office office = new Office();
			office.setId(Long.valueOf(delegateTask.getVariable("officeName")
					.toString()));
			reward.setOffice(office);
		}
		reward.setGrade((String) delegateTask.getVariable("grade"));
		reward.setGrade((String) delegateTask.getVariable("grade"));
		reward.setLevel((String) delegateTask.getVariable("level"));
		reward.setFile((String) delegateTask.getVariable("file"));
		reward.setApprovalOrg((String) delegateTask.getVariable("approvalOrg"));
		reward.setXb_fee((String) delegateTask.getVariable("xb_fee"));
		reward.setPt_fee((String) delegateTask.getVariable("pt_fee"));
		reward.setYear((String) delegateTask.getVariable("year"));
		reward.setProcessStatus(((String) delegateTask
				.getVariable("processStatus")));
		reward.setRemarks((String) delegateTask.getVariable("remarks"));
		rewardDao.save(reward);
	}

}
