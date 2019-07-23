package com.ndtl.yyky.modules.oa.web.model;

import java.util.List;

import com.google.common.collect.Lists;
import com.ndtl.yyky.modules.oa.entity.Project;

public class ProjectModel {

	private String users = "";
	private String projects;
	private List<Long> hosProjectIds;
	private List<Long> lxProjectIds;
	private List<Project> kjkAuditProjects = Lists.newArrayList();
	private List<Project> hosAuditProjects = Lists.newArrayList();
	private List<Project> lxAuditProjects = Lists.newArrayList();
	private List<Project> assignedProject = Lists.newArrayList();
	private List<Long> userIds;
	private String projectStatus;

	public List<Long> getHosProjectIds() {
		return hosProjectIds;
	}

	public void setHosProjectIds(List<Long> hosProjectIds) {
		this.hosProjectIds = hosProjectIds;
	}

	public List<Long> getUserIds() {
		return userIds;
	}

	public void setUserIds(List<Long> userIds) {
		this.userIds = userIds;
	}

	public String getProjectStatus() {
		return projectStatus;
	}

	public void setProjectStatus(String projectStatus) {
		this.projectStatus = projectStatus;
	}

	public String getUsers() {
		return users;
	}

	public void setUsers(String users) {
		this.users = users;
	}

	public String getProjects() {
		return projects;
	}

	public void setProjects(String projects) {
		this.projects = projects;
	}

	public List<Project> getKjkAuditProjects() {
		return kjkAuditProjects;
	}

	public void setKjkAuditProjects(List<Project> kjkAuditProjects) {
		this.kjkAuditProjects = kjkAuditProjects;
	}

	public List<Project> getLxAuditProjects() {
		return lxAuditProjects;
	}

	public void setLxAuditProjects(List<Project> lxAuditProjects) {
		this.lxAuditProjects = lxAuditProjects;
	}

	public List<Project> getHosAuditProjects() {
		return hosAuditProjects;
	}

	public void setHosAuditProjects(List<Project> hosAuditProjects) {
		this.hosAuditProjects = hosAuditProjects;
	}

	public List<Long> getLxProjectIds() {
		return lxProjectIds;
	}

	public void setLxProjectIds(List<Long> lxProjectIds) {
		this.lxProjectIds = lxProjectIds;
	}

	public List<Project> getAssignedProject() {
		return assignedProject;
	}

	public void setAssignedProject(List<Project> assignedProject) {
		this.assignedProject = assignedProject;
	}

}
