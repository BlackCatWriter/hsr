package com.ndtl.yyky.modules.oa.entity.base;

import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;

import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import com.ndtl.yyky.modules.oa.entity.Project;

@MappedSuperclass
public abstract class ProjectRelatedEntity extends BaseOAEntity {

	private static final long serialVersionUID = -8292964065010915018L;

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
