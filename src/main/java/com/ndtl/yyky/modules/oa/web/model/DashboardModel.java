package com.ndtl.yyky.modules.oa.web.model;

import java.util.List;

import com.google.common.collect.Lists;
import com.ndtl.yyky.modules.cms.entity.Article;

public class DashboardModel {

	private List<Article> notices = Lists.newArrayList();
	private List<UserTask> tasks = Lists.newArrayList();
	private List<UserTask> ownedTasks = Lists.newArrayList();

	public List<Article> getNotices() {
		return notices;
	}

	public void setNotices(List<Article> notices) {
		this.notices = notices;
	}

	public List<UserTask> getTasks() {
		return tasks;
	}

	public void setTasks(List<UserTask> tasks) {
		this.tasks = tasks;
	}

	public List<UserTask> getOwnedTasks() {
		return ownedTasks;
	}

	public void setOwnedTasks(List<UserTask> ownedTasks) {
		this.ownedTasks = ownedTasks;
	}

}
