package com.ndtl.yyky.modules.cms.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ndtl.yyky.common.persistence.DataEntity;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.base.ProjectRelatedItem;
import org.hibernate.annotations.*;
import org.hibernate.annotations.Cache;

import javax.persistence.*;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

/**
 * 
 * 经费Entity
 * 
 * 
 */
@Entity
@Table(name = "oa_expense_account")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Account extends DataEntity {

	private static final long serialVersionUID = 1L;
	private Long id; // 编号
	private Project project;
	private String approp_depart; // 拨款单位
	private String approp_batch; // 拨款批次
	private String xb_fee; // 下拨经费
	private String sd_fee; // 实到经费
	private String pt_fee; // 配套经费
	private Date approp_date; // 拨款日期

	public String getApprop_depart() {
		return approp_depart;
	}

	public void setApprop_depart(String approp_depart) {
		this.approp_depart = approp_depart;
	}

	public String getApprop_batch() {
		return approp_batch;
	}

	public void setApprop_batch(String approp_batch) {
		this.approp_batch = approp_batch;
	}

	public String getXb_fee() {
		return xb_fee;
	}

	public void setXb_fee(String xb_fee) {
		this.xb_fee = xb_fee;
	}

	public String getSd_fee() {
		return sd_fee;
	}

	public void setSd_fee(String sd_fee) {
		this.sd_fee = sd_fee;
	}

	public String getPt_fee() {
		return pt_fee;
	}

	public void setPt_fee(String pt_fee) {
		this.pt_fee = pt_fee;
	}

	public Date getApprop_date() {
		return approp_date;
	}

	public void setApprop_date(Date approp_date) {
		this.approp_date = approp_date;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@ManyToOne
	@JoinColumn(name = "project_id")
	@NotFound(action = NotFoundAction.IGNORE)
	@JsonIgnore
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
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

}
