package com.ndtl.yyky.modules.oa.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.validator.constraints.Length;

import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.modules.oa.entity.base.ProjectRelatedEntity;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.DictUtils;

/**
 * 
 * 经费Entity
 * 
 *
 */
@Entity
@Table(name = "oa_expense")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Expense extends ProjectRelatedEntity {

	private static final long serialVersionUID = 7522882023320115912L;
	private String reason; // 申请原因
	private double amount; // 申请金额
	private String person; // 申请人
	private String expenseType; // 经费类型

	// -- 临时属性 --//
	private Date createDateStart; // 申请日期
	private Date createDateEnd;
	private Boolean isUsed;
	private Boolean isRejected;

	public Expense() {
		super();
	}

	public Expense(Long id) {
		this();
		this.id = id;
	}

	@ExcelField(title = "经费类型", align = 2, sort = 7, dictType = "oa_expense_type")
	public String getExpenseType() {
		return expenseType;
	}

	public void setExpenseType(String expenseType) {
		this.expenseType = expenseType;
	}

	@Length(min = 1, max = 255)
	@ExcelField(title = "申请原因", align = 2, sort = 5)
	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public double getAmount() {
		return amount;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	@Transient
	public User getUser() {
		return createBy;
	}

	@Transient
	@ExcelField(title = "申请人", align = 2, sort = 3)
	public String getCreateUserName() {
		if(createBy!=null){
		return createBy.getName();
		}
		return null;
	}

	@Transient
	@ExcelField(title = "申请时间", align = 2, sort = 4)
	public Date getApplyDate() {
		return createDate;
	}

	@Transient
	@ExcelField(title = "项目名", align = 2, sort = 2)
	public String getProjectName() {
		if(project!=null){
		return project.getProjectName();
		}
		return null;
	}

	@Transient
	@ExcelField(title = "项目立项号", align = 2, sort = 1)
	public String getProjectNo() {
		if(project!=null){
		return project.getProjectNo();
		}
		return null;
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

	public String getPerson() {
		return person;
	}

	public void setPerson(String person) {
		this.person = person;
	}

	@Transient
	public String getDicExpenseType() {
		return DictUtils.getDictLabel(expenseType, "oa_expense_type", "");
	}

	@Transient
	public Boolean getIsUsed() {
		return isUsed;
	}

	public void setIsUsed(Boolean isUsed) {
		this.isUsed = isUsed;
	}
	
	@Transient
	@ExcelField(title = "申请金额", align = 2, sort = 6)
	public String getBxamount() {
		return String.valueOf(amount);
	}

	@Transient
	public Boolean getIsRejected() {
		return isRejected;
	}

	public void setIsRejected(Boolean isRejected) {
		this.isRejected = isRejected;
	}

}
