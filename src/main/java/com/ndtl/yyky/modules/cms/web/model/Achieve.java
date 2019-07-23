package com.ndtl.yyky.modules.cms.web.model;

import java.util.List;

import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.sys.entity.User;

public class Achieve {

	// 个人绩效
	private Long weightBelong;
	private String weightBelongDisplayName;
	private String searchYear;
	private User weightBelongUser;
	private List<Project> projectList;
	private List<Thesis> thesisList;
	private List<Patent> patentList;
	private List<Book> bookList;
	private List<Reward> rewardList;
	private List<Reward> newTecRewardList;
	private List<Reward> tecAdvrewardList;

	public Long getWeightBelong() {
		return weightBelong;
	}

	public void setWeightBelong(Long weightBelong) {
		this.weightBelong = weightBelong;
	}

	public String getSearchYear() {
		return searchYear;
	}

	public void setSearchYear(String searchYear) {
		this.searchYear = searchYear;
	}

	public User getWeightBelongUser() {
		return weightBelongUser;
	}

	public void setWeightBelongUser(User weightBelongUser) {
		this.weightBelongUser = weightBelongUser;
	}

	public List<Project> getProjectList() {
		return projectList;
	}

	public void setProjectList(List<Project> projectList) {
		this.projectList = projectList;
	}

	public List<Patent> getPatentList() {
		return patentList;
	}

	public void setPatentList(List<Patent> patentList) {
		this.patentList = patentList;
	}

	public List<Book> getBookList() {
		return bookList;
	}

	public void setBookList(List<Book> bookList) {
		this.bookList = bookList;
	}

	public List<Thesis> getThesisList() {
		return thesisList;
	}

	public void setThesisList(List<Thesis> thesisList) {
		this.thesisList = thesisList;
	}

	public List<Reward> getRewardList() {
		return rewardList;
	}

	public void setRewardList(List<Reward> rewardList) {
		this.rewardList = rewardList;
	}

	public String getWeightBelongDisplayName() {
		return weightBelongDisplayName;
	}

	public void setWeightBelongDisplayName(String weightBelongDisplayName) {
		this.weightBelongDisplayName = weightBelongDisplayName;
	}

	public List<Reward> getNewTecRewardList() {
		return newTecRewardList;
	}

	public void setNewTecRewardList(List<Reward> newTecRewardList) {
		this.newTecRewardList = newTecRewardList;
	}

	public List<Reward> getTecAdvrewardList() {
		return tecAdvrewardList;
	}

	public void setTecAdvrewardList(List<Reward> tecAdvrewardList) {
		this.tecAdvrewardList = tecAdvrewardList;
	}

}
