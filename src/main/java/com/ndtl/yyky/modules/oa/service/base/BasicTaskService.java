package com.ndtl.yyky.modules.oa.service.base;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.oa.dao.BookDao;
import com.ndtl.yyky.modules.oa.dao.PatentDao;
import com.ndtl.yyky.modules.oa.dao.ProjectDao;
import com.ndtl.yyky.modules.oa.dao.RewardDao;
import com.ndtl.yyky.modules.oa.dao.ThesisDao;

@Service
@Transactional(readOnly = true)
public class BasicTaskService extends BaseService {

	@Autowired
	private ThesisDao thesisDao;
	@Autowired
	private ProjectDao projectDao;
	@Autowired
	private PatentDao patentDao;
	@Autowired
	private BookDao bookDao;
	@Autowired
	private RewardDao rewardDao;

	// public List<?> findTodoTasks(String userId) {
	// List<BaseOAEntity> results = new ArrayList<BaseOAEntity>();
	// List<Task> tasks = new ArrayList<Task>();
	// // 根据当前人的ID查询
	// List<Task> todoList = taskService.createTaskQuery()
	// .taskAssignee(userId).active().orderByTaskPriority().desc()
	// .orderByTaskCreateTime().desc().list();
	// // 根据当前人未签收的任务
	// List<Task> unsignedTasks = taskService.createTaskQuery()
	// .taskCandidateUser(userId).active().orderByTaskPriority()
	// .desc().orderByTaskCreateTime().desc().list();
	// // 合并
	// tasks.addAll(todoList);
	// tasks.addAll(unsignedTasks);
	// // 根据流程的业务ID查询实体并关联
	// for (Task task : tasks) {
	// String processInstanceId = task.getProcessInstanceId();
	// ProcessInstance processInstance = runtimeService
	// .createProcessInstanceQuery()
	// .processInstanceId(processInstanceId).active()
	// .singleResult();
	// String businessKey = processInstance.getBusinessKey();
	// @SuppressWarnings("unchecked")
	// BaseOAEntity entity = (BaseOAEntity) getDao().findOne(
	// new Long(businessKey));
	// entity.setTask(task);
	// entity.setProcessInstance(processInstance);
	// entity.setProcessDefinition(repositoryService
	// .createProcessDefinitionQuery()
	// .processDefinitionId(
	// (processInstance.getProcessDefinitionId()))
	// .singleResult());
	// results.add(entity);
	// }
	// return results;
	// }

}