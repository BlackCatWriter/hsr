package com.ndtl.yyky.modules.cms.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ndtl.yyky.common.persistence.DataEntity;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.sys.utils.DictUtils;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.*;

import javax.persistence.Entity;
import javax.persistence.*;
import javax.persistence.Table;

/**
 * 
 * 申请规划Entity
 * 
 * 
 */
@Entity
@Table(name = "oa_expense_plan")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ExpensePlan extends DataEntity {

	private static final long serialVersionUID = 1L;
	private Long id; // 编号
	private Project project;
	private String expense_type; // 报销类型
	private String expense_name;
	private Integer ratio; // 百分比

	/*临时变量*/
	private double sd_fee;
	private double sy_fee;
	private double re_fee;

	@Transient
	public String getExpense_name() {
		return expense_name;
	}

	public void setExpense_name(String expense_name) {
		this.expense_name = expense_name;
	}

	public String getExpense_type() {
		return expense_type;
	}

	public void setExpense_type(String expense_type) {
		this.expense_type = expense_type;
	}

	public Integer getRatio() {
		return ratio;
	}

	public void setRatio(Integer ratio) {
		this.ratio = ratio;
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
	@Transient
	public String getDicExpenseType() {
		return DictUtils.getDictLabel(expense_type, "oa_expense_type", "");
	}

	@Transient
	public double getSd_fee() {
		return sd_fee;
	}

	public void setSd_fee(double sd_fee) {
		this.sd_fee = sd_fee;
	}

	@Transient
	public double getSy_fee() {
		return sy_fee;
	}

	public void setSy_fee(double sy_fee) {
		this.sy_fee = sy_fee;
	}

	@Transient
	public double getRe_fee() {
		return re_fee;
	}

	public void setRe_fee(double re_fee) {
		this.re_fee = re_fee;
	}
}
