package com.ndtl.yyky.modules.oa.service.base;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.BaseEntity;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.common.utils.Collections3;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAItem;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.service.SystemService;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

@Service
@Transactional(readOnly = true)
public abstract class BaseOAService extends BaseService {

	@Autowired
	private RuntimeService runtimeService;
	@Autowired
	private SystemService systemService;
	@Autowired
	protected TaskService taskService;
	@Autowired
	protected HistoryService historyService;
	@Autowired
	protected RepositoryService repositoryService;
	@Autowired
	private IdentityService identityService;

	public DetachedCriteria createDCForAchieve(String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, Integer.valueOf(year));
		calendar.set(Calendar.MONTH, Calendar.JANUARY);
		calendar.set(Calendar.DATE, 1);
		Date before = calendar.getTime();
		Calendar calendar1 = Calendar.getInstance();
		calendar1.set(Calendar.YEAR, Integer.valueOf(year));
		calendar1.set(Calendar.MONTH, Calendar.DECEMBER);
		calendar1.set(Calendar.DATE, 31);
		Date after = calendar1.getTime();
		dc.add(Restrictions.between("updateDate", before, after));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForAchieve() {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForAchieveWithAuditDate(String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("auditDate", year));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForAchieveWithYear(String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("year", year));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForWeightBelong(Long userId, String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("weightBelong", userId));
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, Integer.valueOf(year));
		calendar.set(Calendar.MONTH, Calendar.JANUARY);
		calendar.set(Calendar.DATE, 1);
		Date before = calendar.getTime();
		Calendar calendar1 = Calendar.getInstance();
		calendar1.set(Calendar.YEAR, Integer.valueOf(year));
		calendar1.set(Calendar.MONTH, Calendar.DECEMBER);
		calendar1.set(Calendar.DATE, 31);
		Date after = calendar1.getTime();
		dc.add(Restrictions.between("updateDate", before, after));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForWeightBelongWithAuditDate(Long userId,
			String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("weightBelong", userId));
		dc.add(Restrictions.eq("auditDate", year));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForWeightBelongWithYear(Long userId,
			String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("weightBelong", userId));
		dc.add(Restrictions.eq("year", year));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForDept(Long deptId, String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("office.id", deptId));
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, Integer.valueOf(year));
		calendar.set(Calendar.MONTH, Calendar.JANUARY);
		calendar.set(Calendar.DATE, 1);
		Date before = calendar.getTime();
		Calendar calendar1 = Calendar.getInstance();
		calendar1.set(Calendar.YEAR, Integer.valueOf(year));
		calendar1.set(Calendar.MONTH, Calendar.DECEMBER);
		calendar1.set(Calendar.DATE, 31);
		Date after = calendar1.getTime();
		dc.add(Restrictions.between("updateDate", before, after));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForDeptWithAuditDate(Long deptId,
			String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("office.id", deptId));
		dc.add(Restrictions.eq("auditDate", year));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	public DetachedCriteria createDCForDeptWithYear(Long deptId, String year) {
		DetachedCriteria dc = getDao().createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		dc.add(Restrictions.eq("office.id", deptId));
		dc.add(Restrictions.eq("year", year));
		dc.add(Restrictions.like("delFlag", "%" + BaseEntity.DEL_FLAG_AUDIT
				+ "%"));
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	@SuppressWarnings("unchecked")
	public ProcessInstance save(BaseOAEntity entity,
			Map<String, Object> variables, ProcessDefinitionKey key) {
		getDao().save(entity);
		logger.debug("save entity: {}", entity);
		String businessKey = entity.getId().toString();
		identityService.setAuthenticatedUserId(ObjectUtils.toString(entity
				.getCreateBy().getId()));

		ProcessInstance processInstance = runtimeService
				.startProcessInstanceByKey(key.getKey(), businessKey, variables);
		String processInstanceId = processInstance.getId();
		entity.setProcessInstanceId(processInstanceId);
		getDao().updateProcessInstanceId(entity.getId(),
				entity.getProcessInstanceId());
		logger.debug(
				"start process of {key={}, bkey={}, pid={}, variables={}}",
				new Object[] { key.getKey(), businessKey, processInstanceId,
						variables });
		return processInstance;
	}

	@SuppressWarnings("unchecked")
	public void save(BaseOAEntity entity) {
		getDao().save(entity);
	}

	/**
	 * 获取流程详细及工作流参数
	 * 
	 * @param id
	 */
	@SuppressWarnings("unchecked")
	public BaseOAEntity findOne(Long id) {
		BaseOAEntity entity = (BaseOAEntity) getDao().findOne(id);
		Map<String, Object> variables = null;
		if (StringUtils.isNotEmpty(entity.getProcessInstanceId())) {
			HistoricProcessInstance historicProcessInstance = historyService
					.createHistoricProcessInstanceQuery()
					.processInstanceId(entity.getProcessInstanceId())
					.singleResult();
			if (historicProcessInstance != null) {
				variables = Collections3.extractToMap(historyService
						.createHistoricVariableInstanceQuery()
						.processInstanceId(historicProcessInstance.getId())
						.list(), "variableName", "value");
			} else {
				variables = runtimeService.getVariables(runtimeService
						.createProcessInstanceQuery()
						.processInstanceId(entity.getProcessInstanceId())
						.active().singleResult().getId());
			}
		}
		entity.setVariables(variables);
		return entity;
	}

	/**
	 * 获取流程详细及工作流参数
	 * 
	 * @param id
	 */
	@SuppressWarnings("unchecked")
	public BaseOAEntity findById(Long id) {
		BaseOAEntity entity = (BaseOAEntity) getDao().findOne(id);
		return entity;
	}

	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public List<?> findOwnedTasks(Long userId) {
		List<BaseOAEntity> results = getDao().findUnfinished(userId);
		return results;
	}

	/**
	 * 查询待办任务
	 * 
	 * @param userId
	 *            用户ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public List<?> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<BaseOAEntity> results = new ArrayList<BaseOAEntity>();
		List<Task> tasks = new ArrayList<Task>();
		// 根据当前人的ID查询
		List<Task> todoList = taskService.createTaskQuery()
				.processDefinitionKey(key.getKey()).taskAssignee(userId)
				.active().orderByTaskPriority().desc().orderByTaskCreateTime()
				.desc().list();
		// 根据当前人未签收的任务
		List<Task> unsignedTasks = taskService.createTaskQuery()
				.processDefinitionKey(key.getKey()).taskCandidateUser(userId)
				.active().orderByTaskPriority().desc().orderByTaskCreateTime()
				.desc().list();
		// 合并
		tasks.addAll(todoList);
		tasks.addAll(unsignedTasks);
		User user = systemService.findUserById(Long.valueOf(userId));
		// 根据流程的业务ID查询实体并关联
		for (Task task : tasks) {
			String processInstanceId = task.getProcessInstanceId();
			ProcessInstance processInstance = runtimeService
					.createProcessInstanceQuery()
					.processInstanceId(processInstanceId).active()
					.singleResult();
			String businessKey = processInstance.getBusinessKey();
			BaseOAEntity entity = (BaseOAEntity) getDao().findOne(
					new Long(businessKey));
			if(task.getTaskDefinitionKey().equals("deptLeaderAudit")){
				if (UserUtils.isDeptLeader(user)
					&& !user.getOffice().getId()
							.equals(entity.getCreateBy().getOffice().getId())) {
				continue;
				}
			}
			entity.setTask(task);
			entity.setProcessInstance(processInstance);
			entity.setProcessDefinition(repositoryService
					.createProcessDefinitionQuery()
					.processDefinitionId(
							(processInstance.getProcessDefinitionId()))
					.singleResult());
			results.add(entity);
		}
		return results;
	}

	/**
	 * 查询第一步审核任务
	 * 
	 * @param userId
	 *            用户ID
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Transactional(readOnly = true)
	public List<?> findTodoTasksWithFirstStep(String userId,
			ProcessDefinitionKey key) {
		List<BaseOAEntity> results = new ArrayList<BaseOAEntity>();
		List<Task> tasks = new ArrayList<Task>();
		// 根据当前人的ID查询
		List<Task> todoList = taskService.createTaskQuery()
				.processDefinitionKey(key.getKey()).taskAssignee(userId)
				.active().orderByTaskPriority().desc().orderByTaskCreateTime()
				.desc().list();
		// 根据当前人未签收的任务
		List<Task> unsignedTasks = taskService.createTaskQuery()
				.processDefinitionKey(key.getKey()).taskCandidateUser(userId)
				.active().orderByTaskPriority().desc().orderByTaskCreateTime()
				.desc().list();
		// 合并
		tasks.addAll(todoList);
		tasks.addAll(unsignedTasks);
		// 根据流程的业务ID查询实体并关联
		for (Task task : tasks) {
			if (!(task.getTaskDefinitionKey().equals("kjDeptAudit")||(ProcessDefinitionKey.Project.equals(key)&&task.getTaskDefinitionKey().equals("deptLeaderAudit")))) {
				continue;
			}
			String processInstanceId = task.getProcessInstanceId();
			ProcessInstance processInstance = runtimeService
					.createProcessInstanceQuery()
					.processInstanceId(processInstanceId).active()
					.singleResult();
			String businessKey = processInstance.getBusinessKey();
			BaseOAEntity entity = (BaseOAEntity) getDao().findOne(
					new Long(businessKey));
			entity.setTask(task);
			entity.setProcessInstance(processInstance);
			entity.setProcessDefinition(repositoryService
					.createProcessDefinitionQuery()
					.processDefinitionId(
							(processInstance.getProcessDefinitionId()))
					.singleResult());
			results.add(entity);
		}
		return results;
	}

	public BaseOAEntity retriveProcessAndHistory(BaseOAEntity item) {
		String processInstanceId = item.getProcessInstanceId();
		if (processInstanceId == null || processInstanceId.trim().length() == 0) {
			return item;
		}
		Task task = taskService.createTaskQuery()
				.processInstanceId(processInstanceId).active().singleResult();
		item.setTask(task);
		HistoricProcessInstance historicProcessInstance = historyService
				.createHistoricProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		if (historicProcessInstance != null) {
			item.setHistoricProcessInstance(historicProcessInstance);
			item.setProcessDefinition(repositoryService
					.createProcessDefinitionQuery()
					.processDefinitionId(
							historicProcessInstance.getProcessDefinitionId())
					.singleResult());
		} else {
			ProcessInstance processInstance = runtimeService
					.createProcessInstanceQuery()
					.processInstanceId(processInstanceId).active()
					.singleResult();
			item.setProcessInstance(processInstance);
			item.setProcessDefinition(repositoryService
					.createProcessDefinitionQuery()
					.processDefinitionId(
							processInstance.getProcessDefinitionId())
					.singleResult());
		}
		return item;
	}

	/**
	 * 创建基础查询逻辑，按office查询，只查自己，限制查询范围，按照id查询，按照权属查询
	 * 
	 * @param page
	 * @param oaDao
	 * @param entity
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public DetachedCriteria createBaseCriteria(Page<?> page, BaseOADao oaDao,
			BaseOAItem entity) {
		DetachedCriteria dc = oaDao.createDetachedCriteria();
		dc.createAlias("office", "office");
		User currentUser = UserUtils.getUser();
		if (entity.getSelfOnly()) {
			dc.add(Restrictions.eq("createBy.id", currentUser.getId()));
		}
		if (entity.getOffice() != null && entity.getOffice().getId() != null) {
			dc.add(Restrictions.or(Restrictions.eq("office.id", entity
					.getOffice().getId())));
		}
		dc.add(dataScopeFilter(currentUser, "office", "createBy"));
		if (StringUtils.isNotBlank(entity.getIds())) {
			String ids = entity.getIds().trim().replace("　", ",")
					.replace(" ", ",").replace("，", ",");
			List<Long> idList = Lists.newArrayList();
			for (String id : ids.split(",")) {
				if (id.matches("\\d*")) {
					idList.add(Long.valueOf(id));
				}
			}
			if (idList.size() > 0) {
				dc.add(Restrictions.in("id", idList));
			}
		}
		if (entity.getWeightBelong() != null && entity.getWeightBelong() != 0l) {
			dc.add(Restrictions.eq("weightBelong", entity.getWeightBelong()));
		}
		dc.addOrder(Order.desc("id"));
		return dc;
	}

	/**
	 * 创建基础查询逻辑，按office查询，只查自己，限制查询范围，按照id查询，按照权属查询
	 * 
	 * @param page
	 * @param oaDao
	 * @param entity
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	public DetachedCriteria createBaseCriteria(Page<?> page, BaseOADao oaDao,
			BaseOAEntity entity) {
		DetachedCriteria dc = oaDao.createDetachedCriteria();
		User currentUser = UserUtils.getUser();
		if (entity.getSelfOnly()) {
			dc.add(Restrictions.eq("createBy.id", currentUser.getId()));
		}
		if (StringUtils.isNotBlank(entity.getIds())) {
			String ids = entity.getIds().trim().replace("　", ",")
					.replace(" ", ",").replace("，", ",");
			List<Long> idList = Lists.newArrayList();
			for (String id : ids.split(",")) {
				if (id.matches("\\d*")) {
					idList.add(Long.valueOf(id));
				}
			}
			if (idList.size() > 0) {
				dc.add(Restrictions.in("id", idList));
			}
		}
		return dc;
	}

	@SuppressWarnings("rawtypes")
	public abstract BaseOADao getDao();

}
