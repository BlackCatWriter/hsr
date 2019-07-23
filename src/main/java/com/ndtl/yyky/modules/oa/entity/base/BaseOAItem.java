package com.ndtl.yyky.modules.oa.entity.base;

import javax.persistence.CascadeType;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.MappedSuperclass;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.modules.sys.entity.Office;

@MappedSuperclass
public abstract class BaseOAItem extends BaseOAEntity {
	private static final long serialVersionUID = 1946943863932006809L;
	protected Office office; // 所属科室
	private String officeName; // 所属科室名
	protected Long weightBelong; // 权属
	protected String weight; // 权重
	protected String weightBelongDisplayName; // 权重的显示值
	private String author1DisplayName; // 作者1
	private String author2DisplayName; // 作者2
	private String author3DisplayName; // 作者3
	private String co_authorDisplayName; // 通讯作者
	protected String searchYear;

	@ManyToOne
	@JoinColumn(name = "office_id")
	@JsonIgnore
	@NotFound(action = NotFoundAction.IGNORE)
	@NotNull(message = "所属不能为空")
	@ExcelField(title = "所属科室", align = 2, sort = 4)
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}

	@NotNull(message = "权属不能为空")
	@ExcelField(title = "权属", align = 2, sort = 17)
	public Long getWeightBelong() {
		return weightBelong;
	}

	public void setWeightBelong(Long weightBelong) {
		this.weightBelong = weightBelong;
	}

	@ExcelField(title = "权重", align = 2, sort = 18)
	public String getWeight() {
		return weight;
	}

	public void setWeight(String weight) {
		this.weight = weight;
	}

	@Transient
	public String getWeightBelongDisplayName() {
		return weightBelongDisplayName;
	}

	public void setWeightBelongDisplayName(String weightBelongDisplayName) {
		this.weightBelongDisplayName = weightBelongDisplayName;
	}

	@Transient
	public String getSearchYear() {
		return searchYear;
	}

	public void setSearchYear(String searchYear) {
		this.searchYear = searchYear;
	}

	@Transient
	public String getAuthor1DisplayName() {
		return author1DisplayName;
	}

	public void setAuthor1DisplayName(String author1DisplayName) {
		this.author1DisplayName = author1DisplayName;
	}

	@Transient
	public String getAuthor2DisplayName() {
		return author2DisplayName;
	}

	public void setAuthor2DisplayName(String author2DisplayName) {
		this.author2DisplayName = author2DisplayName;
	}

	@Transient
	public String getAuthor3DisplayName() {
		return author3DisplayName;
	}

	public void setAuthor3DisplayName(String author3DisplayName) {
		this.author3DisplayName = author3DisplayName;
	}

	@Transient
	public String getCo_authorDisplayName() {
		return co_authorDisplayName;
	}

	public void setCo_authorDisplayName(String co_authorDisplayName) {
		this.co_authorDisplayName = co_authorDisplayName;
	}

	@Transient
	public String getOfficeName() {
		return officeName;
	}

	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}

}
