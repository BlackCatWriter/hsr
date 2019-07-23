package com.ndtl.yyky.modules.oa.service;


import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.AcademiccostDao;
import com.ndtl.yyky.modules.oa.entity.Academiccost;

/**
 *  外出报销金额处理器
 * 
 */
@Service
@Transactional
public class AcademiccostModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private AcademiccostDao academiccostDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Academiccost academiccost = academiccostDao.findOne(new Long(
				processInstance.getBusinessKey()));
		academiccost.setBxFee((String) delegateTask.getVariable("bxFee"));
		academiccost.setRemarks((String) delegateTask.getVariable("remarks"));
		academiccostDao.save(academiccost);
	}
}
