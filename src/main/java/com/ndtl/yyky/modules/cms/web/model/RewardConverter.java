package com.ndtl.yyky.modules.cms.web.model;

import com.ndtl.yyky.common.utils.excel.fieldtype.OfficeType;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Reward.RewardType;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAItem;

public class RewardConverter {

	public static Reward convertReward(NewTecRewardExportModel model) {
		Reward reward = new Reward();
		reward.setYear(model.getYear());
		reward.setProfession(model.getProfession());
		reward = convertOffice(model, reward);
		reward.setRewardName(model.getRewardName());
		reward.setGrade(model.getGrade());
		reward.setLevel(model.getLevel());
		reward.setAuthor1(model.getAuthor1());
		reward.setAuthor2(model.getAuthor2());
		reward.setAuthor3(model.getAuthor3());
		reward.setWeightBelong(model.getWeightBelong());
		reward.setApprovalOrg(model.getApprovalOrg());
		reward.setXb_fee(model.getXb_fee());
		reward.setPt_fee(model.getPt_fee());

		reward.setDelFlag(Reward.DEL_FLAG_AUDIT);
		reward.setType(RewardType.newTec.name());
		return reward;
	}

	public static Reward convertReward(RewardExportModel model) {
		Reward reward = new Reward();
		reward.setYear(model.getYear());
		reward.setProfession(model.getProfession());
		reward = convertOffice(model, reward);
		reward.setRewardName(model.getRewardName());
		reward.setGrade(model.getGrade());
		reward.setLevel(model.getLevel());
		reward.setAuthor1(model.getAuthor1());
		reward.setAuthor2(model.getAuthor2());
		reward.setAuthor3(model.getAuthor3());
		reward.setWeightBelong(model.getWeightBelong());
		reward.setXb_fee(model.getXb_fee());
		reward.setPt_fee(model.getPt_fee());

		reward.setDelFlag(Reward.DEL_FLAG_AUDIT);
		reward.setType(RewardType.tecProgress.name());
		return reward;
	}

	public static Reward convertReward(TecAdvRewardExportModel model) {
		Reward reward = new Reward();
		reward.setYear(model.getYear());
		reward.setProfession(model.getProfession());
		reward = convertOffice(model, reward);
		reward.setRewardName(model.getRewardName());
		reward.setGrade(model.getGrade());
		reward.setLevel(model.getLevel());
		reward.setAuthor1(model.getAuthor1());
		reward.setAuthor2(model.getAuthor2());
		reward.setAuthor3(model.getAuthor3());
		reward.setWeightBelong(model.getWeightBelong());
		reward.setXb_fee(model.getXb_fee());
		reward.setCaseCountFirst(model.getCaseCountFirst());
		reward.setJlFirst(model.getJlFirst());
		reward.setCaseCountSecond(model.getCaseCountSecond());
		reward.setJlSecond(model.getJlSecond());

		reward.setDelFlag(Reward.DEL_FLAG_AUDIT);
		reward.setType(RewardType.tecAdv.name());
		return reward;
	}

	private static Reward convertOffice(BaseOAItem entity, Reward reward) {
		reward.setOffice(OfficeType.getValue(entity.getOfficeName()));
		return reward;
	}
}
