package com.ndtl.yyky.modules.oa.entity;

import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.hibernate.annotations.Where;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.common.utils.excel.fieldtype.UserType;
import com.ndtl.yyky.common.utils.excel.fieldtype.WeightBelongType;
import com.ndtl.yyky.modules.oa.entity.base.ProjectRelatedItem;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.DictUtils;

@Entity
@Table(name = "oa_reward")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Reward extends ProjectRelatedItem {

	private static final long serialVersionUID = 7411237758186131653L;

	public enum RewardType {
		tecProgress, newTec, tecAdv
	};

	private String author1; // 第一负责人All
	private String author2; // 第二负责人All
	private String author3; // 第三负责人All
	private String year; // 获奖年度All
	private String rewardNo; // 项目编号：新技术引进奖
	private String rewardName; // 项目名称All
	private String profession; // 专业All
	private String processStatus; // 申报进度ALL(流程中信息)
	private String caseCountFirst; // 第一年病例数
	private String caseCountSecond; // 第二年病例数

	private String type; // 获奖类别ALL
	private String approvalOrg; // 奖励部门:新技术引进奖
	private String xb_fee; // 奖励经费ALL
	private String jlFirst; // 奖励1
	private String pt_fee; // 配套经费:新技术引进奖
	private String jlSecond; // 奖励2
	private String grade; // 获奖等级ALL
	private String level; // 获奖等级ALL
	private List<RewardToUser> rewardToUser = Lists.newArrayList();
	private String rewardType; // 科技进步奖,新技术引进奖,院内重大领先技术奖

	private Date createDateStart;
	private Date createDateEnd;

	// -- 临时属性 --//
	private boolean selected;

	@NotNull(message = "第一完成人不能为空")
	@ExcelField(title = "第一完成人", align = 2, sort = 7, fieldType = UserType.class)
	public String getAuthor1() {
		return author1;
	}

	public void setAuthor1(String author1) {
		this.author1 = author1;
	}

	@ExcelField(title = "第二完成人", align = 2, sort = 8, fieldType = UserType.class)
	public String getAuthor2() {
		return author2;
	}

	public void setAuthor2(String author2) {
		this.author2 = author2;
	}

	@ExcelField(title = "第三完成人", align = 2, sort = 9, fieldType = UserType.class)
	public String getAuthor3() {
		return author3;
	}

	public void setAuthor3(String author3) {
		this.author3 = author3;
	}

	@ExcelField(title = "奖励部门", align = 2, sort = 5)
	public String getApprovalOrg() {
		return approvalOrg;
	}

	public void setApprovalOrg(String approvalOrg) {
		this.approvalOrg = approvalOrg;
	}

	public String getRewardNo() {
		return rewardNo;
	}

	public void setRewardNo(String rewardNo) {
		this.rewardNo = rewardNo;
	}

	@ExcelField(title = "奖项题目", align = 2, sort = 4)
	public String getRewardName() {
		return rewardName;
	}

	public void setRewardName(String rewardName) {
		this.rewardName = rewardName;
	}

	@ExcelField(title = "获奖年份", align = 2, sort = 1)
	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	@ExcelField(title = "项目等级", align = 2, sort = 6, dictType = "reward_level")
	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	@ExcelField(title = "奖励金额", align = 2, sort = 10)
	public String getXb_fee() {
		return xb_fee;
	}

	public void setXb_fee(String xb_fee) {
		this.xb_fee = xb_fee;
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

	@ExcelField(title = "配套金额", align = 2, sort = 11)
	public String getPt_fee() {
		return pt_fee;
	}

	public void setPt_fee(String pt_fee) {
		this.pt_fee = pt_fee;
	}

	@ExcelField(title = "专业", align = 2, sort = 2)
	public String getProfession() {
		return profession;
	}

	public void setProfession(String profession) {
		this.profession = profession;
	}

	@OneToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE,
			CascadeType.REMOVE }, fetch = FetchType.LAZY, mappedBy = "reward")
	@Where(clause = "del_flag='" + DEL_FLAG_NORMAL + "'")
	@OrderBy(value = "id")
	@NotFound(action = NotFoundAction.IGNORE)
	@JsonIgnore
	public List<RewardToUser> getRewardToUser() {
		Collections.sort(rewardToUser, new Comparator<RewardToUser>() {
			public int compare(RewardToUser o1, RewardToUser o2) {
				if (o2.getFinished() && (!o1.getFinished())) {
					return 1;
				}
				return 0;
			};
		});
		return rewardToUser;
	}

	public void setRewardToUser(List<RewardToUser> rewardToUser) {
		this.rewardToUser = rewardToUser;
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
		for (RewardToUser ptu : rewardToUser) {
			if (ptu.getFinished()) {
				i++;
			}
		}
		return Long.valueOf(i);
	}

	@Transient
	public long getAssignCount() {
		return Long.valueOf(rewardToUser.size());
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@ExcelField(title = "奖励1", align = 2, sort = 13)
	public String getJlFirst() {
		return jlFirst;
	}

	public void setJlFirst(String jlFirst) {
		this.jlFirst = jlFirst;
	}

	@ExcelField(title = "奖励2", align = 2, sort = 15)
	public String getJlSecond() {
		return jlSecond;
	}

	public void setJlSecond(String jlSecond) {
		this.jlSecond = jlSecond;
	}

	@ExcelField(title = "第一年病例数", align = 2, sort = 12)
	public String getCaseCountFirst() {
		return caseCountFirst;
	}

	public void setCaseCountFirst(String caseCountFirst) {
		this.caseCountFirst = caseCountFirst;
	}

	@ExcelField(title = "第二年病例数", align = 2, sort = 14)
	public String getCaseCountSecond() {
		return caseCountSecond;
	}

	public void setCaseCountSecond(String caseCountSecond) {
		this.caseCountSecond = caseCountSecond;
	}

	public String getRewardType() {
		return rewardType;
	}

	public void setRewardType(String rewardType) {
		this.rewardType = rewardType;
	}

	@ExcelField(title = "项目级别", align = 2, sort = 5, dictType = "reward_grade")
	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	@Transient
	public String getRewardGrade() {
		return DictUtils.getDictLabel(grade, "reward_grade", "");
	}

	@Transient
	public String getRewardLevel() {
		return DictUtils.getDictLabel(level, "reward_level", "");
	}
	
	@Transient
	public String getTecRewardGrade() {
		return DictUtils.getDictLabel(level, "reward_gradetech", "");
	}
	

	@Transient
	@ExcelField(title = "权属", align = 2, sort = 10, fieldType = WeightBelongType.class)
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
