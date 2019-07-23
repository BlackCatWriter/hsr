package com.ndtl.yyky.modules.sys.web.model;

import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;
import com.ndtl.yyky.modules.sys.entity.User;

public class TaskModel {

	private User user;
	private BaseOAEntity entity;
	private String title;
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public BaseOAEntity getEntity() {
		return entity;
	}
	public void setEntity(BaseOAEntity entity) {
		this.entity = entity;
	}

}
