package com.ndtl.yyky.modules.cms.web.model;

import java.util.List;

import com.google.common.collect.Lists;

public class TotlaPerformanceModel {

	private List<DeptPerformanceModel> deptModels = Lists.newArrayList();

	public List<DeptPerformanceModel> getDeptModels() {
		return deptModels;
	}

	public void setDeptModels(List<DeptPerformanceModel> deptModels) {
		this.deptModels = deptModels;
	}
}
