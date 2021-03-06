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
 * 学会Entity
 * 
 * 
 */
@Entity
@Table(name = "oa_acad")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Acad extends BaseOAEntity {

	private static final long serialVersionUID = 1L;

	private String acadName; // 学会名称
	private String level; // 会议级别(acad_level_type)
	private String exerciseRole; // 参会形式(acad_exercise_role)
	private Date startDate; // 开始时间
	private Date endDate; // 结束时间
	private Office office; // 所属科室
	private String isFinished;
	
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
	public String getAcadName() {
		return acadName;
	}

	public void setAcadName(String acadName) {
		this.acadName = acadName;
	}

	public Acad() {
		super();
		this.isFinished = NO;
	}

	public Acad(Long id) {
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

	public String getIsFinished() {
		return isFinished;
	}

	public void setIsFinished(String isFinished) {
		this.isFinished = isFinished;
	}
	
	// -- 临时属性 --//
	private Date createDateStart;
	private Date createDateEnd;
	private String worktitle;
	private String applyuser;
	private String officeName;
	private String education; // 学历
	private Boolean isputoff; // 学历

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
	
	@Transient
	public String getEducation() {
		return education;
	}

	public void setEducation(String education) {
		this.education = education;
	}

	@Transient
	public Boolean getIsputoff() {
		return isputoff;
	}

	public void setIsputoff(Boolean isputoff) {
		this.isputoff = isputoff;
	}
	
	@Transient
	public String getAcadLevel() {
		return DictUtils.getDictLabel(level, "acad_level_type", "");
	}
	
	@Transient
	public String getRole() {
		return DictUtils.getDictLabel(exerciseRole, "acad_exercise_role", "");
	}

}
