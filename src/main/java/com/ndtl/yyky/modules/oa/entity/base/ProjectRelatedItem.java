package com.ndtl.yyky.modules.oa.entity.base;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import com.ndtl.yyky.modules.oa.entity.Project;

@MappedSuperclass
public abstract class ProjectRelatedItem extends BaseOAItem {

	private static final long serialVersionUID = -4785535334028860863L;
	protected Project project; // 关联项目

	@ManyToOne
	@JoinColumn(name = "project_id")
	@NotFound(action = NotFoundAction.IGNORE)
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

}
