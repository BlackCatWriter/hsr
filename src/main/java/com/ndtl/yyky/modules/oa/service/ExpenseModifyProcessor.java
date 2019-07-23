package com.ndtl.yyky.modules.oa.service;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.ExpenseDao;
import com.ndtl.yyky.modules.oa.entity.Expense;

/**
 * 调整经费内容处理器
 * 
 */
@Service
@Transactional
public class ExpenseModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private ExpenseDao expenseDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Expense expense = expenseDao.findOne(new Long(processInstance
				.getBusinessKey()));
		expense.setExpenseType((String) delegateTask.getVariable("expenseType"));
		expense.setReason((String) delegateTask.getVariable("reason"));
		expense.setAmount(Double.valueOf(delegateTask.getVariable("amount")
				.toString()));
		if(delegateTask.getVariable("reApply")!=null&&(Boolean) delegateTask.getVariable("reApply")){
			expense.setDelFlag(Expense.DEL_FLAG_DELETE);	
		}
		expenseDao.save(expense);
	}

}
