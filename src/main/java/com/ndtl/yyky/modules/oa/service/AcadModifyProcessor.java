package com.ndtl.yyky.modules.oa.service;


import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.oa.dao.AcadDao;
import com.ndtl.yyky.modules.oa.entity.Acad;

/**
 * 论文登记内容处理器
 * 
 */
@Service
@Transactional
public class AcadModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private AcadDao acadDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Acad acad = acadDao.findOne(new Long(
				processInstance.getBusinessKey()));
		acad.setAcadName((String) delegateTask.getVariable("acadName"));
		acad.setExerciseRole((String) delegateTask.getVariable("exerciseRole"));
		if(DateUtils.parseDate(delegateTask.getVariable("startDate"))!=null){
			acad.setStartDate(DateUtils.parseDate(delegateTask.getVariable("startDate")));
		}
		if(DateUtils.parseDate(delegateTask.getVariable("endDate"))!=null){
			acad.setEndDate(DateUtils.parseDate(delegateTask.getVariable("endDate")));
		}
		acad.setLevel((String) delegateTask.getVariable("level"));
		acad.setRemarks((String) delegateTask.getVariable("remarks"));
		acadDao.save(acad);
	}
}
