package com.ndtl.yyky.modules.oa.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import com.ndtl.yyky.modules.oa.entity.base.BaseOAItem;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.DictUtils;

/**
 * 
 * 学术活动Entity
 * 
 * 
 */
@Entity
@Table(name = "oa_academic")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Academic extends BaseOAEntity {

	private static final long serialVersionUID = 1L;

	private String academicName; // 学术活动名称
	private String level; // 会议级别(academic_level_type)
	private String exerciseRole; // 参会形式(academic_exercise_role)
	private String hostUnit; // 主办单位
	private String place; // 外出地点
	private Date startDate; // 开始时间
	private Date endDate; // 结束时间
	private Office office; // 所属科室
	private Academiccost academiccost; // bxfee
	private Boolean used = false; // 是否报销出差费用
	private String reportTopic;//汇报题目
	private String reviewOpinion;//评审意见
	private String speechContent;//发言内容
	private String author1; // 作者
	private String expenseSource;//费用来源

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
	
	@ManyToOne
	@JoinColumn(name = "academiccost_id")
	@JsonIgnore
	@NotFound(action = NotFoundAction.IGNORE)
	public Academiccost getAcademiccost() {
		return academiccost;
	}

	public void setAcademiccost(Academiccost academiccost) {
		this.academiccost = academiccost;
	}
	
	public String getHostUnit() {
		return hostUnit;
	}

	public void setHostUnit(String hostUnit) {
		this.hostUnit = hostUnit;
	}
	
	public boolean getUsed() {
		return used;
	}

	public void setUsed(boolean used) {
		this.used = used;
	}

	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(pattern = "yyyy-MM-dd")
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(pattern = "yyyy-MM-dd")
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getAcademicName() {
		return academicName;
	}

	public void setAcademicName(String academicName) {
		this.academicName = academicName;
	}

	public Academic() {
		super();
	}

	public Academic(Long id) {
		this();
		this.id = id;
	}

	public String getExerciseRole() {
		return exerciseRole;
	}

	public void setExerciseRole(String exerciseRole) {
		this.exerciseRole = exerciseRole;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	// -- 临时属性 --//
	private Date createDateStart;
	private Date createDateEnd;
	private String worktitle;
	private String applyuser;
	private String officeName;

	@Transient
	public User getUser() {
		return createBy;
	}

	public void setUser(User user) {
		this.createBy = user;
	}
	
	@Transient
	public String getOfficeName() {
		return officeName;
	}

	public void setOfficeName(String officeName) {
		this.officeName = officeName;
	}

	@Transient
	public String getWorktitle() {
		return worktitle;
	}

	public void setWorktitle(String worktitle) {
		this.worktitle = worktitle;
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
	public String getApplyuser() {
		return applyuser;
	}

	public void setApplyuser(String applyuser) {
		this.applyuser = applyuser;
	}
	public String getReportTopic() {
		return reportTopic;
	}

	public void setReportTopic(String reportTopic) {
		this.reportTopic = reportTopic;
	}

	public String getReviewOpinion() {
		return reviewOpinion;
	}

	public void setReviewOpinion(String reviewOpinion) {
		this.reviewOpinion = reviewOpinion;
	}

	public String getSpeechContent() {
		return speechContent;
	}

	public void setSpeechContent(String speechContent) {
		this.speechContent = speechContent;
	}
	@Transient
	public String getAcademicLevel() {
		return DictUtils.getDictLabel(level, "academic_level_type", "");
	}
	public String getAuthor1() {
		return author1;
	}

	public void setAuthor1(String author1) {
		this.author1 = author1;
	}
	public String getExpenseSource() {
		return expenseSource;
	}

	public void setExpenseSource(String expenseSource) {
		this.expenseSource = expenseSource;
	}
}
