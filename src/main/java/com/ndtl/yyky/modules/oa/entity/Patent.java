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
import com.ndtl.yyky.common.utils.excel.fieldtype.WeightBelongType;
import com.ndtl.yyky.modules.oa.entity.base.ProjectRelatedItem;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.DictUtils;

/**
 * 
 * 专利Entity
 * 
 * 
 */
@Entity
@Table(name = "oa_patent")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Patent extends ProjectRelatedItem {

	private static final long serialVersionUID = 1L;
	private String author1; // 完成人1
	private String author2; // 完成人2
	private String author3; // 完成人3
	private String otherAuthor; // 其他完成人
	private String number;// 专利号
	private String title; // 文题
	private String time; // 授权时间
	private String profession; // 专业
	private String category; // 专利类型
	private String jl; // 奖励
	private String otherAuthorDisplayName; // 其他完成人

	// -- 临时属性 --//
	private Date createDateStart;
	private Date createDateEnd;

	public Patent() {
		super();
	}

	public Patent(Long id) {
		this();
		this.id = id;
	}

	@ExcelField(title = "专利号", align = 2, sort = 4)
	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	@NotNull(message = "第一完成人不能为空")
	@ExcelField(title = "第一完成人", align = 2, sort = 7)
	public String getAuthor1() {
		return author1;
	}

	public void setAuthor1(String author1) {
		this.author1 = author1;
	}

	@ExcelField(title = "第二完成人", align = 2, sort = 8)
	public String getAuthor2() {
		return author2;
	}

	public void setAuthor2(String author2) {
		this.author2 = author2;
	}

	@ExcelField(title = "第三完成人", align = 2, sort = 9)
	public String getAuthor3() {
		return author3;
	}

	public void setAuthor3(String author3) {
		this.author3 = author3;
	}

	@ExcelField(title = "专利名称", align = 2, sort = 5)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@ExcelField(title = "奖励金额", align = 2, sort = 11)
	public String getJl() {
		return jl;
	}

	public void setJl(String jl) {
		this.jl = jl;
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

	public String getOtherAuthor() {
		return otherAuthor;
	}

	public void setOtherAuthor(String otherAuthor) {
		this.otherAuthor = otherAuthor;
	}

	@ExcelField(title = "授权时间", align = 2, sort = 1)
	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	@ExcelField(title = "专业", align = 2, sort = 2)
	public String getProfession() {
		return profession;
	}

	public void setProfession(String profession) {
		this.profession = profession;
	}

	@ExcelField(title = "专利类型", align = 2, sort = 6, dictType = "patent_category_type")
	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	@Transient
	public String getOtherAuthorDisplayName() {
		return otherAuthorDisplayName;
	}

	public void setOtherAuthorDisplayName(String otherAuthorDisplayName) {
		this.otherAuthorDisplayName = otherAuthorDisplayName;
	}

	@Transient
	public String getPatentCategory() {
		return DictUtils.getDictLabel(category, "patent_category_type", "");
	}

	@Transient
	@ExcelField(title = "权属", align = 2, sort = 10, fieldType = WeightBelongType.class)
	public Long getExportWeightBelong() {
		return super.getWeightBelong();
	}

	public void setExportWeightBelong(Long weightBelong) {
		super.setWeightBelong(weightBelong);
	}

	@Transient
	@ExcelField(title = "所属科室", align = 2, sort = 3)
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
