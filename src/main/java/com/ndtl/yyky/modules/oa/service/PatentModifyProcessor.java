package com.ndtl.yyky.modules.oa.service;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.PatentDao;
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.sys.entity.Office;

/**
 * 论文登记内容处理器
 * 
 */
@Service
@Transactional
public class PatentModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private PatentDao patentDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Patent patent = patentDao.findOne(new Long(processInstance
				.getBusinessKey()));
		patent.setTitle((String) delegateTask.getVariable("title"));
		patent.setNumber((String) delegateTask.getVariable("number"));
		patent.setCategory((String) delegateTask.getVariable("category"));
		patent.setTime((String) delegateTask.getVariable("time"));
		patent.setProfession((String) delegateTask.getVariable("profession"));
		if (delegateTask.getVariable("officeName") != null) {
			Office office = new Office();
			office.setId(Long.valueOf(delegateTask.getVariable("officeName")
					.toString()));
			patent.setOffice(office);
		}
		patent.setOtherAuthor((String) delegateTask.getVariable("otherAuthor"));
		patent.setAuthor1((String) delegateTask.getVariable("author1"));
		patent.setAuthor2((String) delegateTask.getVariable("author2"));
		patent.setAuthor3((String) delegateTask.getVariable("author3"));
		patent.setWeightBelong(Long.valueOf(delegateTask.getVariable(
				"weightBelong").toString()));
		patent.setRemarks((String) delegateTask.getVariable("remarks"));
		patent.setFile((String) delegateTask.getVariable("file"));
		patentDao.save(patent);
	}

}
