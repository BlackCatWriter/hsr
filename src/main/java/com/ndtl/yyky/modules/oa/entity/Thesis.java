package com.ndtl.yyky.modules.oa.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.common.utils.excel.fieldtype.UserType;
import com.ndtl.yyky.common.utils.excel.fieldtype.WeightBelongType;
import com.ndtl.yyky.modules.oa.entity.base.ProjectRelatedItem;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.DictUtils;

/**
 * 
 * 论文Entity
 * 
 * 
 */
@Entity
@Table(name = "oa_thesis")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Thesis extends ProjectRelatedItem {

	private static final long serialVersionUID = 1L;
	private String author1; // 作者1
	private String author2; // 作者2
	private String author3; // 作者3
	private String co_author; // 通讯作者
	private String title; // 文题
	private String mag_name; // 杂志名称
	private String annual_volume; // 年卷期
	private String impact_factor; // 影响因子
	private String level; // 论文等级
	private String ybm_fee; // 原版面费
	private String bx_fee; // 报销版费
	private String jl; // 奖励
	private String category; // 论文类别

	// -- 临时属性 --//
	private Date createDateStart;
	private Date createDateEnd;

	public Thesis() {
		super();
	}

	public Thesis(Long id) {
		this();
		this.id = id;
	}

	@NotNull(message = "第一作者不能为空")
	@ExcelField(title = "第一作者", align = 2, sort = 10, fieldType = UserType.class)
	public String getAuthor1() {
		return author1;
	}

	public void setAuthor1(String author1) {
		this.author1 = author1;
	}

	@ExcelField(title = "第二作者", align = 2, sort = 11, fieldType = UserType.class)
	public String getAuthor2() {
		return author2;
	}

	public void setAuthor2(String author2) {
		this.author2 = author2;
	}

	@ExcelField(title = "第三作者", align = 2, sort = 12, fieldType = UserType.class)
	public String getAuthor3() {
		return author3;
	}

	public void setAuthor3(String author3) {
		this.author3 = author3;
	}

	@NotNull(message = "通讯作者不能为空")
	@ExcelField(title = "通讯作者", align = 2, sort = 9, fieldType = UserType.class)
	public String getCo_author() {
		return co_author;
	}

	public void setCo_author(String co_author) {
		this.co_author = co_author;
	}

	@ExcelField(title = "论文题目", align = 2, sort = 3)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@ExcelField(title = "论文类别", align = 2, sort = 4, dictType = "thesis_category_type")
	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	@ExcelField(title = "杂志名称", align = 2, sort = 13)
	public String getMag_name() {
		return mag_name;
	}

	public void setMag_name(String mag_name) {
		this.mag_name = mag_name;
	}

	@ExcelField(title = "年卷期", align = 2, sort = 14)
	public String getAnnual_volume() {
		return annual_volume;
	}

	public void setAnnual_volume(String annual_volume) {
		this.annual_volume = annual_volume;
	}

	@ExcelField(title = "影响因子", align = 2, sort = 22)
	public String getImpact_factor() {
		return impact_factor;
	}

	public void setImpact_factor(String impact_factor) {
		this.impact_factor = impact_factor;
	}


	@ExcelField(title = "论文等级", align = 2, sort = 5, dictType = "thesis_level_type")
	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	@ExcelField(title = "版面费用", align = 2, sort = 19)
	public String getYbm_fee() {
		return ybm_fee;
	}

	public void setYbm_fee(String ybm_fee) {
		this.ybm_fee = ybm_fee;
	}

	@ExcelField(title = "报销金额", align = 2, sort = 20)
	public String getBx_fee() {
		return bx_fee;
	}

	public void setBx_fee(String bx_fee) {
		this.bx_fee = bx_fee;
	}

	@ExcelField(title = "奖励金额", align = 2, sort = 21)
	public String getJl() {
		return jl;
	}

	public void setJl(String jl) {
		this.jl = jl;
	}

	@Transient
	public String getThesisLevel() {
		return DictUtils.getDictLabel(level, "thesis_level_type", "");
	}

	@Transient
	public String getThesisCategory() {
		return DictUtils.getDictLabel(category, "thesis_category_type", "");
	}

	@Transient
	public User getUser() {
		return createBy;
	}

	public void setUser(User user) {
		this.createBy = user;
	}

	@Transient
	public Date getCreateDateStart() {
		return createDateStart;
	}

	public void setCreateDateStart(Date createDateStart) {
		this.createDateStart = createDateStart;
	}

	@Transient
	public Date getCreateDateEnd() {
		return createDateEnd;
	}

	public void setCreateDateEnd(Date createDateEnd) {
		this.createDateEnd = createDateEnd;
	}

	@Transient
	@ExcelField(title = "权属", align = 2, sort = 13, fieldType = WeightBelongType.class)
	public Long getExportWeightBelong() {
		return super.getWeightBelong();
	}

	public void setExportWeightBelong(Long weightBelong) {
		super.setWeightBelong(weightBelong);
	}

	@Transient
	@ExcelField(title = "所属科室", align = 2, sort = 4)
	public String getExportOffice() {
		if (super.getOffice() != null) {
			super.setOfficeName(super.getOffice().getName());
		}
		return super.getOfficeName();
	}

	public void setExportOffice(String officeName) {
		super.setOfficeName(officeName);
	}
	
	@Transient
	public String getProjectNo() {
		if(project!=null){
		return project.getProjectNo();
		}
		return null;
	}

}
