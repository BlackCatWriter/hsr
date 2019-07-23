package com.ndtl.yyky.modules.oa.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;

/**
 * 
 * 外出经费Entity
 * 
 *
 */
@Entity
@Table(name = "oa_academiccost")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Academiccost extends BaseOAEntity {

	private static final long serialVersionUID = 7522882023320115912L;
	private String bxFee; // 报销金额
	private Academic academic; // 学术活动报销
	private Advstudy advstudy; // 进修报销
	// -- 临时属性 --//
	private Boolean isUsed;
	private String academicName; // 学术活动名称
	private String level; // 会议级别(academic_level_type)
	private String exerciseRole; // 参会形式(academic_exercise_role)
	private String hostUnit; // 主办单位
	private String place; // 外出地点
	private Date startDate; // 开始时间
	private Date endDate; // 结束时间
	private Office office; // 所属科室
	private String advstudyDirection; // 进修方向

	
	@OneToOne
	@JoinColumn(name = "academic_id")
	@JsonIgnore
	@NotFound(action = NotFoundAction.IGNORE)
	public Academic getAcademic() {
		return academic;
	}

	public void setAcademic(Academic academic) {
		this.academic = academic;
	}
	
	@OneToOne
	@JoinColumn(name = "advstudy_id")
	@JsonIgnore
	@NotFound(action = NotFoundAction.IGNORE)
	public Advstudy getAdvstudy() {
		return advstudy;
	}

	public void setAdvstudy(Advstudy advstudy) {
		this.advstudy = advstudy;
	}
	

	public Academiccost() {
		super();
	}

	public Academiccost(Long id) {
		this();
		this.id = id;
	}

	public String getBxFee() {
		return bxFee;
	}

	public void setBxFee(String bxFee) {
		this.bxFee = bxFee;
	}

	@Transient
	public Boolean getIsUsed() {
		return isUsed;
	}

	public void setIsUsed(Boolean isUsed) {
		this.isUsed = isUsed;
	}

	@Transient
	public String getAcademicName() {
		return academicName;
	}

	public void setAcademicName(String academicName) {
		this.academicName = academicName;
	}
	
	@Transient
	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	@Transient
	public String getExerciseRole() {
		return exerciseRole;
	}

	public void setExerciseRole(String exerciseRole) {
		this.exerciseRole = exerciseRole;
	}

	@Transient
	public String getHostUnit() {
		return hostUnit;
	}

	public void setHostUnit(String hostUnit) {
		this.hostUnit = hostUnit;
	}

	@Transient
	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	@Transient
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	@Transient
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	@Transient
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	@Transient
	public User getUser() {
		return createBy;
	}

	public void setUser(User user) {
		this.createBy = user;
	}
	
	@Transient
	public String getAdvstudyDirection() {
		return advstudyDirection;
	}

	public void setAdvstudyDirection(String advstudy_direction) {
		this.advstudyDirection = advstudy_direction;
	}
}
