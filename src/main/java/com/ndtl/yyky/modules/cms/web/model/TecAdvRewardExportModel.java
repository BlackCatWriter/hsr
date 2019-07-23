package com.ndtl.yyky.modules.cms.web.model;

import javax.persistence.Transient;

import com.ndtl.yyky.common.utils.excel.annotation.ExcelField;
import com.ndtl.yyky.common.utils.excel.fieldtype.UserType;
import com.ndtl.yyky.common.utils.excel.fieldtype.WeightBelongType;
import com.ndtl.yyky.modules.oa.entity.Reward;

public class TecAdvRewardExportModel extends Reward {

	private static final long serialVersionUID = -2619878942549499342L;

	@ExcelField(title = "获奖年份", align = 2, sort = 1)
	public String getYear() {
		return super.getYear();
	}

	@ExcelField(title = "专业", align = 2, sort = 2)
	public String getProfession() {
		return super.getProfession();
	}

	@Transient
	@ExcelField(title = "所属科室", align = 2, sort = 3)
	public String getExportOffice() {
		return super.getExportOffice();
	}

	@ExcelField(title = "奖项题目", align = 2, sort = 4)
	public String getRewardName() {
		return super.getRewardName();
	}

	@ExcelField(title = "项目级别", align = 2, sort = 5, dictType = "reward_gradetech")
	public String getGrade() {
		return super.getGrade();
	}

	@ExcelField(title = "项目等级", align = 2, sort = 6, dictType = "reward_level")
	public String getLevel() {
		return super.getLevel();
	}

	@ExcelField(title = "第一完成人", align = 2, sort = 7, fieldType = UserType.class)
	public String getAuthor1() {
		return super.getAuthor1();
	}

	@ExcelField(title = "第二完成人", align = 2, sort = 8, fieldType = UserType.class)
	public String getAuthor2() {
		return super.getAuthor2();
	}

	@ExcelField(title = "第三完成人", align = 2, sort = 9, fieldType = UserType.class)
	public String getAuthor3() {
		return super.getAuthor3();
	}

	@Transient
	@ExcelField(title = "权属", align = 2, sort = 10, fieldType = WeightBelongType.class)
	public Long getExportWeightBelong() {
		return super.getWeightBelong();
	}

	@ExcelField(title = "奖励金额", align = 2, sort = 12)
	public String getXb_fee() {
		return super.getXb_fee();
	}

	@ExcelField(title = "第一年病例数", align = 2, sort = 13)
	public String getCaseCountFirst() {
		return super.getCaseCountFirst();
	}

	@ExcelField(title = "奖励1", align = 2, sort = 14)
	public String getJlFirst() {
		return super.getJlFirst();
	}

	@ExcelField(title = "第二年病例数", align = 2, sort = 15)
	public String getCaseCountSecond() {
		return super.getCaseCountSecond();
	}

	@ExcelField(title = "奖励2", align = 2, sort = 16)
	public String getJlSecond() {
		return super.getJlSecond();
	}

}
