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
import com.ndtl.yyky.modules.oa.entity.base.ProjectRelatedItem;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.DictUtils;

@Entity
@Table(name = "oa_achievement")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Achievement extends ProjectRelatedItem {
	private static final long serialVersionUID = 1L;
	private String major; // 专业
	private String awardLevel; // 奖项级别
	private String jlLevel; // 奖励等级
	private String author1; // 第一完成人
	private String author2; // 第二完成人
	private String author3; // 第三完成人
	private String otherAuthors; // 其他完成人
	private String jl; // 奖励金额
	private String yjl; // 院配套奖励金额
	private String projectName; // 奖项名称

	// -- 临时属性 --//
	private Date createDateStart;
	private Date createDateEnd;

	public Achievement() {
		super();
	}

	public Achievement(Long id) {
		this();
		this.id = id;
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

	@ExcelField(title = "专业", align = 2, sort = 11)
	public String getMajor() {
		return major;
	}

	public void setMajor(String major) {
		this.major = major;
	}

	@ExcelField(title = "项目名称", align = 2, sort = 14)
	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	@ExcelField(title = "奖项级别", align = 2, sort = 15, dictType = "award_level_type")
	public String getAwardLevel() {
		return awardLevel;
	}

	public void setAwardLevel(String awardLevel) {
		this.awardLevel = awardLevel;
	}

	@ExcelField(title = "奖励等级", align = 2, sort = 16, dictType = "achievement_jl_level_type")
	public String getJlLevel() {
		return jlLevel;
	}

	public void setJlLevel(String jlLevel) {
		this.jlLevel = jlLevel;
	}

	@NotNull(message = "第一完成人不能为空")
	@ExcelField(title = "第一完成人", align = 2, sort = 17)
	public String getAuthor1() {
		return author1;
	}

	public void setAuthor1(String author1) {
		this.author1 = author1;
	}

	@ExcelField(title = "第二完成人", align = 2, sort = 18)
	public String getAuthor2() {
		return author2;
	}

	public void setAuthor2(String author2) {
		this.author2 = author2;
	}

	@ExcelField(title = "第三完成人", align = 2, sort = 19)
	public String getAuthor3() {
		return author3;
	}

	public void setAuthor3(String author3) {
		this.author3 = author3;
	}

	@ExcelField(title = "其他完成人", align = 2, sort = 20)
	public String getOtherAuthors() {
		return otherAuthors;
	}

	public void setOtherAuthors(String otherAuthors) {
		this.otherAuthors = otherAuthors;
	}

	@ExcelField(title = "奖励金额", align = 2, sort = 22)
	public String getJl() {
		return jl;
	}

	public void setJl(String jl) {
		this.jl = jl;
	}

	@ExcelField(title = "院配套奖励金额", align = 2, sort = 23)
	public String getYjl() {
		return yjl;
	}

	public void setYjl(String yjl) {
		this.yjl = yjl;
	}

	@Transient
	public String getAchievementAwardLevel() {
		return DictUtils.getDictLabel(awardLevel, "award_level_type", "");
	}

	@Transient
	public String getAchievementJlLevel() {
		return DictUtils.getDictLabel(jlLevel, "achievement_jl_level_type", "");
	}
}
