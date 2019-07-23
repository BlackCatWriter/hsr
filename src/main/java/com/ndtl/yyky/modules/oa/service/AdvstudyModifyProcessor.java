package com.ndtl.yyky.modules.oa.service;


import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.oa.dao.AdvstudyDao;
import com.ndtl.yyky.modules.oa.entity.Advstudy;

/**
 * 论文登记内容处理器
 * 
 */
@Service
@Transactional
public class AdvstudyModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private AdvstudyDao advstudyDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Advstudy advstudy = advstudyDao.findOne(new Long(
				processInstance.getBusinessKey()));
		advstudy.setAdvstudyDirection(((String) delegateTask.getVariable("advstudyDirection")));
		advstudy.setHostUnit((String) delegateTask.getVariable("hostUnit"));
		if(DateUtils.parseDate(delegateTask.getVariable("startDate"))!=null){
			advstudy.setStartDate(DateUtils.parseDate(delegateTask.getVariable("startDate")));
		}
		if(DateUtils.parseDate(delegateTask.getVariable("endDate"))!=null){
			advstudy.setEndDate(DateUtils.parseDate(delegateTask.getVariable("endDate")));
		}
		advstudy.setRemarks((String) delegateTask.getVariable("remarks"));
		advstudyDao.save(advstudy);
	}
}
