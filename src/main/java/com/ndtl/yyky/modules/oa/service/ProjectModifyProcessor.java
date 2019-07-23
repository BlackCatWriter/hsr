package com.ndtl.yyky.modules.oa.service;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.ProjectDao;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.sys.entity.Office;

/**
 * 论文登记内容处理器
 * 
 */
@Service
@Transactional
public class ProjectModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private ProjectDao projectDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Project project = projectDao.findOne(new Long(processInstance
				.getBusinessKey()));
		project.setProjectName((String) delegateTask.getVariable("projectName"));
		project.setAuthor1((String) delegateTask.getVariable("author1"));
		project.setAuthor2((String) delegateTask.getVariable("author2"));
		project.setAuthor3((String) delegateTask.getVariable("author3"));
		project.setWeightBelong(Long.valueOf(delegateTask.getVariable(
				"weightBelong").toString()));
		project.setProfession((String) delegateTask.getVariable("profession"));
		if (delegateTask.getVariable("officeName") != null) {
			Office office = new Office();
			office.setId(Long.valueOf(delegateTask.getVariable("officeName")
					.toString()));
			project.setOffice(office);
		}
		project.setLevel((String) delegateTask.getVariable("level"));
		project.setFile((String) delegateTask.getVariable("file"));
		project.setRemarks((String) delegateTask.getVariable("remarks"));
		projectDao.save(project);
	}

}
