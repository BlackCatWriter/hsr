package com.ndtl.yyky.modules.cms.web.model;

import java.util.List;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.modules.sys.entity.Office;

public class DeptPerformanceModel extends UserPerformanceModel {

	private Office office;
	private List<UserPerformanceModel> userPerformance = Lists.newArrayList();

	public List<UserPerformanceModel> getUserPerformance() {
		return userPerformance;
	}

	public void setUserPerformance(List<UserPerformanceModel> userPerformance) {
		this.userPerformance = userPerformance;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

	@ExcelField(title = "SCI论文数", type = 1, align = 2, sort = 9)
	public int getSciCount() {
		return super.getSciCount();
	}

	@ExcelField(title = "SCI论文权重", type = 1, align = 2, sort = 10)
	public int getSciWeight() {
		return super.getSciWeight();
	}

	@ExcelField(title = "中华论文数", type = 1, align = 2, sort = 11)
	public int getChineseCount() {
		return super.getChineseCount();
	}

	@ExcelField(title = "中华论文权重", type = 1, align = 2, sort = 12)
	public int getChineseWeight() {
		return super.getChineseWeight();
	}

	@ExcelField(title = "其他论文数", type = 1, align = 2, sort = 13)
	public int getOtherCount() {
		return super.getOtherCount();
	}

	@ExcelField(title = "其他论文权重", type = 1, align = 2, sort = 14)
	public int getOtherWeight() {
		return super.getOtherWeight();
	}

	@ExcelField(title = "国家级项目数", type = 1, align = 2, sort = 3)
	public int getCountryCount() {
		return super.getCountryCount();
	}

	@ExcelField(title = "国家级项目权重", type = 1, align = 2, sort = 4)
	public int getCountryWeight() {
		return super.getCountryWeight();
	}

	@ExcelField(title = "省级项目数", type = 1, align = 2, sort = 5)
	public int getProvinceCount() {
		return super.getProvinceCount();
	}

	@ExcelField(title = "省级项目权重", type = 1, align = 2, sort = 6)
	public int getProvinceWeight() {
		return super.getProvinceWeight();
	}

	@ExcelField(title = "其他项目数", type = 1, align = 2, sort = 7)
	public int getOtherProjectCount() {
		return super.getOtherProjectCount();
	}

	@ExcelField(title = "其他项目权重", type = 1, align = 2, sort = 8)
	public int getOtherProjectWeight() {
		return super.getOtherProjectWeight();
	}

	@ExcelField(title = "新技术引进奖数", type = 1, align = 2, sort = 15)
	public int getNewTecCount() {
		return super.getNewTecCount();
	}

	@ExcelField(title = "新技术引进奖权重", type = 1, align = 2, sort = 16)
	public int getNewTecWeight() {
		return super.getNewTecWeight();
	}

	@ExcelField(title = "院重大实用领先技术奖数", type = 1, align = 2, sort = 19)
	public int getTecAdvCount() {
		return super.getTecAdvCount();
	}

	@ExcelField(title = "院重大实用领先技术奖权重", type = 1, align = 2, sort = 20)
	public int getTecAdvWeight() {
		return super.getTecAdvWeight();
	}

	@ExcelField(title = "科技进步奖数", type = 1, align = 2, sort = 17)
	public int getTecProCount() {
		return super.getTecProCount();
	}

	@ExcelField(title = "科技进步奖权重", type = 1, align = 2, sort = 18)
	public int getTecProWeight() {
		return super.getTecProWeight();
	}

	@ExcelField(title = "著作数", type = 1, align = 2, sort = 23)
	public int getBookCount() {
		return super.getBookCount();
	}

	@ExcelField(title = "著作权重", type = 1, align = 2, sort = 24)
	public int getBookWeight() {
		return super.getBookWeight();
	}

	@ExcelField(title = "专利数", type = 1, align = 2, sort = 21)
	public int getPatentCount() {
		return super.getPatentCount();
	}

	@ExcelField(title = "专利权重", type = 1, align = 2, sort = 22)
	public int getPatentWeight() {
		return super.getPatentWeight();
	}

	@ExcelField(title = "科室", type = 1, align = 2, sort = 1)
	public String getOfficeName() {
		return office.getName();
	}

	@ExcelField(title = "总权重", type = 1, align = 2, sort = 25)
	public int getTotalWeight() {
		return super.getTotalWeight();
	}

}
