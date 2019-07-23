package com.ndtl.yyky.modules.oa.service;


import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.oa.dao.AcademicDao;
import com.ndtl.yyky.modules.oa.entity.Academic;

/**
 * 论文登记内容处理器
 * 
 */
@Service
@Transactional
public class AcademicModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private AcademicDao academicDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Academic academic = academicDao.findOne(new Long(
				processInstance.getBusinessKey()));
		academic.setAcademicName((String) delegateTask.getVariable("academicName"));
		academic.setPlace((String) delegateTask.getVariable("place"));
		academic.setHostUnit((String) delegateTask.getVariable("hostUnit"));
		academic.setExerciseRole((String) delegateTask.getVariable("exerciseRole"));
		if(DateUtils.parseDate(delegateTask.getVariable("startDate"))!=null){
			academic.setStartDate(DateUtils.parseDate(delegateTask.getVariable("startDate")));
		}
		if(DateUtils.parseDate(delegateTask.getVariable("endDate"))!=null){
			academic.setEndDate(DateUtils.parseDate(delegateTask.getVariable("endDate")));
		}
		academic.setLevel((String) delegateTask.getVariable("level"));
		academic.setRemarks((String) delegateTask.getVariable("remarks"));
		academicDao.save(academic);
	}
}
