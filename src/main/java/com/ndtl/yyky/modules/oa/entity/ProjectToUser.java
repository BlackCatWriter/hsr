package com.ndtl.yyky.modules.oa.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ndtl.yyky.common.persistence.DataEntity;
import com.ndtl.yyky.modules.sys.entity.User;

@Entity
@Table(name = "oa_project_user")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProjectToUser extends DataEntity {
	private static final long serialVersionUID = -9201299024697648268L;
	private Long id; // 编号
	private Project project;
	private User user;
	private Boolean finished = false;
	private Integer creativity;// 创新性
	private Integer advancement;// 先进性
	private Integer scientificity;// 科学性
	private Integer feasibility;// 可行性
	private Integer practicability;// 实用性
	private Integer isRecommend;//是否推荐

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@ManyToOne
	@JoinColumn(name = "project_id")
	@NotFound(action = NotFoundAction.IGNORE)
	@JsonIgnore
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	@ManyToOne
	@JoinColumn(name = "user_id")
	@NotFound(action = NotFoundAction.IGNORE)
	@JsonIgnore
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public boolean getFinished() {
		return finished;
	}

	public void setFinished(boolean finished) {
		this.finished = finished;
	}

	public Integer getCreativity() {
		return creativity;
	}

	public void setCreativity(Integer creativity) {
		this.creativity = creativity;
	}

	public Integer getAdvancement() {
		return advancement;
	}

	public void setAdvancement(Integer advancement) {
		this.advancement = advancement;
	}

	public Integer getScientificity() {
		return scientificity;
	}

	public void setScientificity(Integer scientificity) {
		this.scientificity = scientificity;
	}

	public Integer getFeasibility() {
		return feasibility;
	}

	public void setFeasibility(Integer feasibility) {
		this.feasibility = feasibility;
	}

	public Integer getPracticability() {
		return practicability;
	}

	public void setPracticability(Integer practicability) {
		this.practicability = practicability;
	}

	public Integer getIsRecommend() {
		return isRecommend;
	}
	public void setIsRecommend(Integer isRecommend) {
		this.isRecommend = isRecommend;
	}
}
