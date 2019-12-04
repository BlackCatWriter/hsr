package com.ndtl.yyky.modules.oa.utils.workflow;

/**
 * 工作流枚举
 * 
 */
public enum ProcessDefinitionKey {
	Leave("leave"), Expense("expense"), Thesis("thesis"), Project("project"), Achievement(
			"achievement"), Patent("patent"), Book("book"), ProjectData("projectData"), Reward("reward"), Academic("academic"),Academiccost("academiccost"),Advstudy("advstudy"),Acad("acad");

	private String key;

	private ProcessDefinitionKey(String key) {
		this.key = key;
	}

	public String getKey() {
		return this.key;
	}
}
