package com.ndtl.yyky.modules.oa.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
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

/**
 * 
 * 进修Entity
 * 
 */
@Entity
@Table(name = "oa_advstudy")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Advstudy extends BaseOAEntity {

	private static final long serialVersionUID = 1L;

	private String bxFee; // 报销金额
	private String hostUnit; // 主办单位
	private String advstudyDirection; // 进修方向
	private Date startDate; // 开始时间
	private Date endDate; // 结束时间
	private Office office; // 所属科室
	private Academiccost academiccost; // bxfee
	
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
	
	@OneToOne
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

	public Advstudy() {
		super();
	}

	public Advstudy(Long id) {
		this();
		this.id = id;
	}

	public String getBxFee() {
		return bxFee;
	}

	public void setBxFee(String bxFee) {
		this.bxFee = bxFee;
	}

	public String getAdvstudyDirection() {
		return advstudyDirection;
	}

	public void setAdvstudyDirection(String advstudy_direction) {
		this.advstudyDirection = advstudy_direction;
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

}
