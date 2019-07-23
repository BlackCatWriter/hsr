package com.ndtl.yyky.modules.oa.entity.base;

import java.util.Map;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;

import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.hibernate.validator.constraints.Length;

import com.ndtl.yyky.common.persistence.DataEntity;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;

@MappedSuperclass
public abstract class BaseOAEntity extends DataEntity {

	private static final long serialVersionUID = 6162321084170249329L;
	protected Long id; // 编号
	protected String file; // 上传文件名

	protected String processInstanceId; // 流程实例编号
	// 流程任务
	protected Task task;
	protected Map<String, Object> variables;
	// 运行中的流程实例
	protected ProcessInstance processInstance;
	// 历史的流程实例
	protected HistoricProcessInstance historicProcessInstance;
	// 流程定义
	protected ProcessDefinition processDefinition;

	protected Boolean selfOnly = false; // 只查自己
	private String ids;
	protected String taskKey;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@ExcelField(title = "序号", type = 1, align = 2, sort = 1)
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getProcessInstanceId() {
		return processInstanceId;
	}

	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}

	@Length(min = 0, max = 255)
	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}

	@Transient
	public Boolean getSelfOnly() {
		return selfOnly;
	}

	public void setSelfOnly(Boolean selfOnly) {
		this.selfOnly = selfOnly;
	}

	@Transient
	public Task getTask() {
		return task;
	}

	public void setTask(Task task) {
		this.task = task;
	}

	@Transient
	public Map<String, Object> getVariables() {
		return variables;
	}

	public void setVariables(Map<String, Object> variables) {
		this.variables = variables;
	}

	@Transient
	public ProcessInstance getProcessInstance() {
		return processInstance;
	}

	public void setProcessInstance(ProcessInstance processInstance) {
		this.processInstance = processInstance;
	}

	@Transient
	public HistoricProcessInstance getHistoricProcessInstance() {
		return historicProcessInstance;
	}

	public void setHistoricProcessInstance(
			HistoricProcessInstance historicProcessInstance) {
		this.historicProcessInstance = historicProcessInstance;
	}

	@Transient
	public ProcessDefinition getProcessDefinition() {
		return processDefinition;
	}

	public void setProcessDefinition(ProcessDefinition processDefinition) {
		this.processDefinition = processDefinition;
	}

	@Transient
	public String getIds() {
		return ids;
	}

	public void setIds(String ids) {
		this.ids = ids;
	}
	

	@Transient
	public String getTaskKey() {
		if(this.task==null){
			return null;
		}
		return this.task.getTaskDefinitionKey();
	}

	public void setTaskKey(String taskKey) {
		this.taskKey = taskKey;
	}

}
