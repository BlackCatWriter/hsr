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

@Entity
@Table(name = "oa_book")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Book extends ProjectRelatedItem {

	private static final long serialVersionUID = 1L;
	private String author1; // 作者1
	private String title; // 著作名称
	private String time; // 年限
	private String publisher; // 出版社
	private String number; // 书刊号
	private String profession; // 专业
	private String jl; // 奖励
	private Integer letters; // 承担字数
	private String role; // 担任角色

	// -- 临时属性 --//
	private Date createDateStart;
	private Date createDateEnd;

	public Book() {
		super();
	}

	public Book(Long id) {
		this();
		this.id = id;
	}

	@ExcelField(title = "书刊号", align = 2, sort = 5)
	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	@NotNull(message = "作者不能为空")
	@ExcelField(title = "作者", align = 2, sort = 7, fieldType = UserType.class)
	public String getAuthor1() {
		return author1;
	}

	public void setAuthor1(String author1) {
		this.author1 = author1;
	}

	@ExcelField(title = "著作名称", align = 2, sort = 6)
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@ExcelField(title = "奖励金额", align = 2, sort = 10)
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

	@ExcelField(title = "年限", align = 2, sort = 1)
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

	@ExcelField(title = "出版社", align = 2, sort = 4)
	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	@ExcelField(title = "担任角色", align = 2, sort = 8, dictType = "book_role_type")
	public String getRole() {
		return role;
	}

	@Transient
	public String getBookRole() {
		return DictUtils.getDictLabel(role, "book_role_type", "");
	}

	public void setRole(String role) {
		this.role = role;
	}

	@ExcelField(title = "承担部分字数", align = 2, sort = 9)
	public Integer getLetters() {
		return letters;
	}

	public void setLetters(Integer letters) {
		this.letters = letters;
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
