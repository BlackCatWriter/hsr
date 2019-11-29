package com.ndtl.yyky.modules.oa.entity;

import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.cms.entity.ExpenseRatio;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.hibernate.annotations.Where;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.common.utils.excel.fieldtype.UserType;
import com.ndtl.yyky.common.utils.excel.fieldtype.WeightBelongType;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAItem;
import com.ndtl.yyky.modules.oa.entity.enums.ProjectStatus;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.DictUtils;
import org.hibernate.validator.constraints.Length;

@Entity
@Table(name = "oa_project")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Project extends BaseOAItem {

	private static final long serialVersionUID = 7411237758186131653L;
	private String author1; // 第一负责人
	private String author2; // 第二负责人
	private String author3; // 第三负责人
	private String approvalOrg; // 立项单位
	private String projectNo; // 立项编号
	private String projectHospitalNo;// 院内项目编号
	private String projectName; // 项目名称
	private String xb_fee; // 下拨经费
	private String sd_fee; // 实到经费
	private String pt_fee; // 配套经费
	private String sy_fee; // 使用经费
	private Date startDate; // 开始时间
	private Date endDate; // 结束时间
	private String level; // 项目等级
	private ProjectStatus status;// 项目状态
	private String profession; // 专业
	private String processStatus; // 申报进度
	private List<ProjectToUser> projectToUser = Lists.newArrayList();
	private String auditDate;
	private String midTermFile; // 中期考核上传文件名
	private String endFile; // 结题上传文件名
	private String midTermFileTemplete; // 中期考核上传文件名
	private String endFileTemplete; // 结题上传文件名
	private String notice; // 结题上传文件名
	private String endtype; // 结题方式
	private String introduce; // 项目简介

	private Date createDateStart;
	private Date createDateEnd;

	// -- 临时属性 --//
	private boolean selected;

	private List<Thesis> thesis;
	private List<Reward> reward;
	private List<Reward> newTec;
	private List<Reward> tecAdv;
	private List<Book> book;
	private List<Patent> patent;

	private List<ExpenseRatio> ratio;
	private List<ExpensePlan> plan;

	@NotNull(message = "第一责任人不能为空")
	@ExcelField(title = "第一责任人", align = 2, sort = 5, fieldType = UserType.class)
	public String getAuthor1() {
		return author1;
	}

	public void setAuthor1(String author1) {
		this.author1 = author1;
	}

	@ExcelField(title = "第二责任人", align = 2, sort = 6, fieldType = UserType.class)
	public String getAuthor2() {
		return author2;
	}

	public void setAuthor2(String author2) {
		this.author2 = author2;
	}

	@ExcelField(title = "第三责任人", align = 2, sort = 7, fieldType = UserType.class)
	public String getAuthor3() {
		return author3;
	}

	public void setAuthor3(String author3) {
		this.author3 = author3;
	}

	@ExcelField(title = "立项单位", align = 2, sort = 8)
	public String getApprovalOrg() {
		return approvalOrg;
	}

	public void setApprovalOrg(String approvalOrg) {
		this.approvalOrg = approvalOrg;
	}

	@ExcelField(title = "立项编号", align = 2, sort = 2)
	public String getProjectNo() {
		return projectNo;
	}

	public void setProjectNo(String projectNo) {
		this.projectNo = projectNo;
	}

	public String getProjectHospitalNo() {
		return projectHospitalNo;
	}

	public void setProjectHospitalNo(String projectHospitalNo) {
		this.projectHospitalNo = projectHospitalNo;
	}

	@ExcelField(title = "项目题目", align = 2, sort = 1)
	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title = "开始时间", align = 2, sort = 9)
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(pattern = "yyyy-MM-dd")
	@ExcelField(title = "结束时间", align = 2, sort = 10)
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	@ExcelField(title = "项目等级", align = 2, sort = 11)
	public String getLevel() {
		return level;
	}

	@Transient
	public String getProjectLevel() {
		return DictUtils.getDictLabel(level, "project_level_type", "");
	}

	public void setLevel(String level) {
		this.level = level;
	}

	@ExcelField(title = "下拨经费", align = 2, sort = 12)
	public String getXb_fee() {
		if (StringUtils.isEmpty(xb_fee)) {
			return "0";
		}
		return xb_fee;
	}

	public void setXb_fee(String xb_fee) {
		this.xb_fee = xb_fee;
	}

	@ExcelField(title = "实到经费", align = 2, sort = 13)
	public String getSd_fee() {
		if (StringUtils.isEmpty(sd_fee)) {
			return "0";
		}
		return sd_fee;
	}

	public void setSd_fee(String sd_fee) {
		this.sd_fee = sd_fee;
	}

	@ExcelField(title = "使用经费", align = 2, sort = 14)
	public String getSy_fee() {
		if (StringUtils.isEmpty(sy_fee)) {
			return "0";
		}
		return sy_fee;
	}

	public void setSy_fee(String sy_fee) {
		this.sy_fee = sy_fee;
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

	public String getPt_fee() {
		if (StringUtils.isEmpty(pt_fee)) {
			return "0";
		}
		return pt_fee;
	}

	public void setPt_fee(String pt_fee) {
		this.pt_fee = pt_fee;
	}

	@Enumerated(EnumType.STRING)
	public ProjectStatus getStatus() {
		return status;
	}

	public void setStatus(ProjectStatus status) {
		this.status = status;
	}

	public String getProfession() {
		return profession;
	}

	public void setProfession(String profession) {
		this.profession = profession;
	}

	@OneToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE,
			CascadeType.REMOVE }, fetch = FetchType.EAGER, mappedBy = "project")
	@Where(clause = "del_flag='" + DEL_FLAG_NORMAL + "'")
	@OrderBy(value = "id")
	@NotFound(action = NotFoundAction.IGNORE)
	@JsonIgnore
	public List<ProjectToUser> getProjectToUser() {
		Collections.sort(projectToUser, new Comparator<ProjectToUser>() {
			public int compare(ProjectToUser o1, ProjectToUser o2) {
				if (o2.getFinished() && (!o1.getFinished())) {
					return 1;
				}
				return 0;
			};
		});
		return projectToUser;
	}

	public void setProjectToUser(List<ProjectToUser> projectToUser) {
		this.projectToUser = projectToUser;
	}

	@Transient
	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public String getProcessStatus() {
		return processStatus;
	}

	public void setProcessStatus(String processStatus) {
		this.processStatus = processStatus;
	}

	@Transient
	public long getCheckedCount() {
		int i = 0;
		for (ProjectToUser ptu : projectToUser) {
			if (ptu.getFinished()) {
				i++;
			}
		}
		return Long.valueOf(i);
	}

	@Transient
	public long getAssignCount() {
		return Long.valueOf(projectToUser.size());
	}

	public String getAuditDate() {
		return auditDate;
	}

	public void setAuditDate(String auditDate) {
		this.auditDate = auditDate;
	}

	@Transient
	@ExcelField(title = "权属", align = 2, sort = 4, fieldType = WeightBelongType.class)
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

	public String getMidTermFile() {
		return midTermFile;
	}

	public void setMidTermFile(String midTermFile) {
		this.midTermFile = midTermFile;
	}

	public String getEndFile() {
		return endFile;
	}

	public void setEndFile(String endFile) {
		this.endFile = endFile;
	}

	public String getMidTermFileTemplete() {
		return midTermFileTemplete;
	}

	public void setMidTermFileTemplete(String midTermFileTemplete) {
		this.midTermFileTemplete = midTermFileTemplete;
	}

	public String getEndFileTemplete() {
		return endFileTemplete;
	}

	public void setEndFileTemplete(String endFileTemplete) {
		this.endFileTemplete = endFileTemplete;
	}

	public String getNotice() {
		return notice;
	}

	public void setNotice(String notice) {
		this.notice = notice;
	}

	@Transient
	public List<Thesis> getThesis() {
		return thesis;
	}
	
	@Transient
	public String getThesissize() {
		if(thesis!=null){
			return String.valueOf(thesis.size());
		}
		return null;
	}

	public void setThesis(List<Thesis> thesis) {
		this.thesis = thesis;
	}

	@Transient
	public List<Reward> getReward() {
		return reward;
	}
	
	@Transient
	public String getRewardsize() {
		if(reward!=null){
			return String.valueOf(reward.size());
		}
		return null;
	}

	public void setReward(List<Reward> reward) {
		this.reward = reward;
	}

	@Transient
	public List<Book> getBook() {
		return book;
	}

	public void setBook(List<Book> book) {
		this.book = book;
	}

	@Transient
	public List<Patent> getPatent() {
		return patent;
	}

	public void setPatent(List<Patent> patent) {
		this.patent = patent;
	}

	@Transient
	public List<Reward> getNewTec() {
		return newTec;
	}

	public void setNewTec(List<Reward> newTec) {
		this.newTec = newTec;
	}

	@Transient
	public List<Reward> getTecAdv() {
		return tecAdv;
	}

	public void setTecAdv(List<Reward> tecAdv) {
		this.tecAdv = tecAdv;
	}

	public String getEndtype() {
		return endtype;
	}

	public void setEndtype(String endtype) {
		this.endtype = endtype;
	}

	@Transient
	public List<ExpenseRatio> getRatio() {
		return ratio;
	}
	public void setRatio(List<ExpenseRatio> ratio) {
		this.ratio = ratio;
	}
	@Transient
	public List<ExpensePlan> getPlan() {
		return plan;
	}
	public void setPlan(List<ExpensePlan> plan) {
		this.plan = plan;
	}

	@Length(min = 0, max = 800)
	public String getIntroduce() {
		return introduce;
	}

	public void setIntroduce(String introduce) {
		this.introduce = introduce;
	}
}
