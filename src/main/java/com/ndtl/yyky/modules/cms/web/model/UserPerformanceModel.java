package com.ndtl.yyky.modules.cms.web.model;

import java.util.List;

import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.sys.entity.User;

public class UserPerformanceModel {

	private User user;
	private String userName;
	private String officeName;
	private List<Project> projectList;
	private List<Thesis> thesisList;
	private List<Patent> patentList;
	private List<Book> bookList;
	private List<Reward> rewardList;
	private List<Reward> newTecRewardList;
	private List<Reward> tecAdvrewardList;
	// 论文统计信息
	private int sciCount = 0;
	private int sciWeight = 0;
	private int chineseCount = 0;
	private int chineseWeight = 0;
	private int otherCount = 0;
	private int otherWeight = 0;

	// 项目统计信息
	private int countryCount = 0;
	private int countryWeight = 0;
	private int provinceCount = 0;
	private int provinceWeight = 0;
	private int otherProjectCount = 0;
	private int otherProjectWeight = 0;

	// 奖项统计信息
	private int newTecCount = 0;
	private int newTecWeight = 0;
	private int tecAdvCount = 0;
	private int tecAdvWeight = 0;
	private int tecProCount = 0;
	private int tecProWeight = 0;

	// 专著统计信息
	private int bookCount = 0;
	private int bookWeight = 0;
	// 专利统计信息
	private int patentCount = 0;
	private int patentWeight = 0;

	// 总权重
	private int totalWeight = 0;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<Project> getProjectList() {
		return projectList;
	}

	public void setProjectList(List<Project> projectList) {
		this.projectList = projectList;
	}

	public List<Thesis> getThesisList() {
		return thesisList;
	}

	public void setThesisList(List<Thesis> thesisList) {
		this.thesisList = thesisList;
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

	public List<Reward> getRewardList() {
		return rewardList;
	}

	public void setRewardList(List<Reward> rewardList) {
		this.rewardList = rewardList;
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

	@ExcelField(title = "SCI论文数", type = 1, align = 2, sort = 9)
	public int getSciCount() {
		return sciCount;
	}

	public void setSciCount(int sciCount) {
		this.sciCount = sciCount;
	}

	@ExcelField(title = "SCI论文权重", type = 1, align = 2, sort = 10)
	public int getSciWeight() {
		return sciWeight;
	}

	public void setSciWeight(int sciWeight) {
		this.sciWeight = sciWeight;
	}

	@ExcelField(title = "中华论文数", type = 1, align = 2, sort = 11)
	public int getChineseCount() {
		return chineseCount;
	}

	public void setChineseCount(int chineseCount) {
		this.chineseCount = chineseCount;
	}

	@ExcelField(title = "中华论文权重", type = 1, align = 2, sort = 12)
	public int getChineseWeight() {
		return chineseWeight;
	}

	public void setChineseWeight(int chineseWeight) {
		this.chineseWeight = chineseWeight;
	}

	@ExcelField(title = "其他论文数", type = 1, align = 2, sort = 13)
	public int getOtherCount() {
		return otherCount;
	}

	public void setOtherCount(int otherCount) {
		this.otherCount = otherCount;
	}

	@ExcelField(title = "其他论文权重", type = 1, align = 2, sort = 14)
	public int getOtherWeight() {
		return otherWeight;
	}

	public void setOtherWeight(int otherWeight) {
		this.otherWeight = otherWeight;
	}

	@ExcelField(title = "国家级项目数", type = 1, align = 2, sort = 3)
	public int getCountryCount() {
		return countryCount;
	}

	public void setCountryCount(int countryCount) {
		this.countryCount = countryCount;
	}

	@ExcelField(title = "国家级项目权重", type = 1, align = 2, sort = 4)
	public int getCountryWeight() {
		return countryWeight;
	}

	public void setCountryWeight(int countryWeight) {
		this.countryWeight = countryWeight;
	}

	@ExcelField(title = "省级项目数", type = 1, align = 2, sort = 5)
	public int getProvinceCount() {
		return provinceCount;
	}

	public void setProvinceCount(int provinceCount) {
		this.provinceCount = provinceCount;
	}

	@ExcelField(title = "省级项目权重", type = 1, align = 2, sort = 6)
	public int getProvinceWeight() {
		return provinceWeight;
	}

	public void setProvinceWeight(int provinceWeight) {
		this.provinceWeight = provinceWeight;
	}

	@ExcelField(title = "其他项目数", type = 1, align = 2, sort = 7)
	public int getOtherProjectCount() {
		return otherProjectCount;
	}

	public void setOtherProjectCount(int otherProjectCount) {
		this.otherProjectCount = otherProjectCount;
	}

	@ExcelField(title = "其他项目权重", type = 1, align = 2, sort = 8)
	public int getOtherProjectWeight() {
		return otherProjectWeight;
	}

	public void setOtherProjectWeight(int otherProjectWeight) {
		this.otherProjectWeight = otherProjectWeight;
	}

	@ExcelField(title = "新技术引进奖数", type = 1, align = 2, sort = 15)
	public int getNewTecCount() {
		return newTecCount;
	}

	public void setNewTecCount(int newTecCount) {
		this.newTecCount = newTecCount;
	}

	@ExcelField(title = "新技术引进奖权重", type = 1, align = 2, sort = 16)
	public int getNewTecWeight() {
		return newTecWeight;
	}

	public void setNewTecWeight(int newTecWeight) {
		this.newTecWeight = newTecWeight;
	}

	@ExcelField(title = "院重大实用领先技术奖数", type = 1, align = 2, sort = 19)
	public int getTecAdvCount() {
		return tecAdvCount;
	}

	public void setTecAdvCount(int tecAdvCount) {
		this.tecAdvCount = tecAdvCount;
	}

	@ExcelField(title = "院重大实用领先技术奖权重", type = 1, align = 2, sort = 20)
	public int getTecAdvWeight() {
		return tecAdvWeight;
	}

	public void setTecAdvWeight(int tecAdvWeight) {
		this.tecAdvWeight = tecAdvWeight;
	}

	@ExcelField(title = "科技进步奖数", type = 1, align = 2, sort = 17)
	public int getTecProCount() {
		return tecProCount;
	}

	public void setTecProCount(int tecProCount) {
		this.tecProCount = tecProCount;
	}

	@ExcelField(title = "科技进步奖权重", type = 1, align = 2, sort = 18)
	public int getTecProWeight() {
		return tecProWeight;
	}

	public void setTecProWeight(int tecProWeight) {
		this.tecProWeight = tecProWeight;
	}

	@ExcelField(title = "著作数", type = 1, align = 2, sort = 23)
	public int getBookCount() {
		return bookCount;
	}

	public void setBookCount(int bookCount) {
		this.bookCount = bookCount;
	}

	@ExcelField(title = "著作权重", type = 1, align = 2, sort = 24)
	public int getBookWeight() {
		return bookWeight;
	}

	public void setBookWeight(int bookWeight) {
		this.bookWeight = bookWeight;
	}

	@ExcelField(title = "专利数", type = 1, align = 2, sort = 21)
	public int getPatentCount() {
		return patentCount;
	}

	public void setPatentCount(int patentCount) {
		this.patentCount = patentCount;
	}

	@ExcelField(title = "专利权重", type = 1, align = 2, sort = 22)
	public int getPatentWeight() {
		return patentWeight;
	}

	public void setPatentWeight(int patentWeight) {
		this.patentWeight = patentWeight;
	}

	@ExcelField(title = "姓名", type = 1, align = 2, sort = 2)
	public String getUserName() {
		return user.getName();
	}

	public void setUserName(String userName) {
		this.userName = user.getName();
	}

	@ExcelField(title = "科室", type = 1, align = 2, sort = 1)
	public String getOfficeName() {
		return officeName;
	}

	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}

	@ExcelField(title = "总权重", type = 1, align = 2, sort = 25)
	public int getTotalWeight() {
		totalWeight = this.sciWeight + this.chineseWeight + this.otherWeight
				+ this.countryWeight + this.provinceWeight
				+ this.otherProjectWeight + this.newTecWeight
				+ this.tecAdvWeight + this.tecProWeight + this.patentWeight
				+ this.bookWeight;
		return totalWeight;
	}

	public void setTotalWeight(int totalWeight) {
		this.totalWeight = totalWeight;
	}
}
