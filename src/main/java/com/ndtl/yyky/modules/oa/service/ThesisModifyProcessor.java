package com.ndtl.yyky.modules.oa.service;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.ThesisDao;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.sys.entity.Office;

/**
 * 论文登记内容处理器
 * 
 */
@Service
@Transactional
public class ThesisModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private ThesisDao thesisDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Thesis thesis = thesisDao.findOne(new Long(processInstance
				.getBusinessKey()));
		thesis.setTitle((String) delegateTask.getVariable("title"));
		if (delegateTask.getVariable("officeName") != null) {
			Office office = new Office();
			office.setId(Long.valueOf(delegateTask.getVariable("officeName")
					.toString()));
			thesis.setOffice(office);
		}
		thesis.setCo_author((String) delegateTask.getVariable("co_author"));
		thesis.setAuthor1((String) delegateTask.getVariable("author1"));
		thesis.setAuthor2((String) delegateTask.getVariable("author2"));
		thesis.setAuthor3((String) delegateTask.getVariable("author3"));
		thesis.setWeightBelong(Long.valueOf(delegateTask.getVariable(
				"weightBelong").toString()));
		thesis.setMag_name((String) delegateTask.getVariable("mag_name"));
		thesis.setAnnual_volume((String) delegateTask
				.getVariable("annual_volume"));
		thesis.setLevel((String) delegateTask.getVariable("level"));
		thesis.setCategory((String) delegateTask.getVariable("category"));
		thesis.setYbm_fee((String) delegateTask.getVariable("ybm_fee"));
		thesis.setRemarks((String) delegateTask.getVariable("remarks"));
		thesis.setFile((String) delegateTask.getVariable("file"));
		thesisDao.save(thesis);
	}

}
