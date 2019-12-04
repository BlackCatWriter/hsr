package com.ndtl.yyky.modules.oa.service;

import com.ndtl.yyky.modules.oa.dao.ProjectDataDao;
import com.ndtl.yyky.modules.oa.entity.ProjectData;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang3.StringEscapeUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ProjectDataProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private ProjectDataDao projectDataDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		ProjectData projectData = projectDataDao.findOne(new Long(processInstance.getBusinessKey()));
		if (delegateTask.getVariable("contentContract") != null) {
			projectData.setContentContract(
					StringEscapeUtils.unescapeHtml4((String)delegateTask.getVariable("contentContract")));
		}
		if (delegateTask.getVariable("contentProgress") != null) {
			projectData.setContentProgress(
					StringEscapeUtils.unescapeHtml4((String)delegateTask.getVariable("contentProgress")));
		}
		if (delegateTask.getVariable("contentSummary") != null) {
			projectData.setContentSummary(
					StringEscapeUtils.unescapeHtml4((String)delegateTask.getVariable("contentSummary")));
		}
		projectData.setRemarks((String) delegateTask.getVariable("remarks"));
		projectDataDao.save(projectData);
	}

}
