package com.ndtl.yyky.modules.oa.web.model;

import javax.persistence.Transient;

import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;

public class UserTask extends BaseOAEntity {
	private static final long serialVersionUID = -4557080096754305920L;
	private String title;
	private String url = "";
	private String type;
	private String typeInSys;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getTypeInSys() {
		return typeInSys;
	}

	public void setTypeInSys(String typeInSys) {
		this.typeInSys = typeInSys;
	}

	private Long entityId;

	@Transient
	public Long getEntityId() {
		return entityId;
	}

	public void setEntityId(Long entityId) {
		this.entityId = entityId;
	}

}
