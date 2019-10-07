package com.ndtl.yyky.modules.oa.web.model.converter;

import java.util.List;

import com.google.common.collect.Lists;
import com.ndtl.yyky.modules.oa.entity.*;
import com.ndtl.yyky.modules.oa.entity.Reward.RewardType;
import com.ndtl.yyky.modules.oa.entity.base.BaseOAEntity;
import com.ndtl.yyky.modules.oa.web.model.UserTask;

public class UserTaskConverter {

	public static UserTask convert(BaseOAEntity entity) {
		UserTask ut = new UserTask();
		ut.setId(entity.getId());
		ut.setEntityId(entity.getId());
		ut.setProcessInstanceId(entity.getProcessInstanceId());
		ut.setProcessInstance(entity.getProcessInstance());
		if (entity instanceof Thesis) {
			ut.setTitle(((Thesis) entity).getTitle());
			ut.setType("论文");
			ut.setTypeInSys("thesis");
		} else if (entity instanceof Project) {
			ut.setTitle(((Project) entity).getProjectName());
			ut.setType("项目");
			ut.setTypeInSys("project");
		} else if (entity instanceof Book) {
			ut.setTitle(((Book) entity).getTitle());
			ut.setType("专著");
			ut.setTypeInSys("book");
		} else if (entity instanceof Patent) {
			ut.setTitle(((Patent) entity).getTitle());
			ut.setType("专利");
			ut.setTypeInSys("patent");
		} else if (entity instanceof Reward) {
			ut.setTitle(((Reward) entity).getRewardName());
			if (((Reward) entity).getType().equals(RewardType.newTec.name())) {
				ut.setType("新技术引进奖");
				ut.setTypeInSys("newTecReward");
			}
			if (((Reward) entity).getType().equals(RewardType.tecAdv.name())) {
				ut.setType("院重大实用领先技术奖");
				ut.setTypeInSys("tecAdvReward");
			}
			if (((Reward) entity).getType().equals(
					RewardType.tecProgress.name())) {
				ut.setType("科技进步奖");
				ut.setTypeInSys("reward");
			}
		} else if (entity instanceof Acad) {
			ut.setTitle(((Acad) entity).getAcadName());
			ut.setType("学会任职延期");
			ut.setTypeInSys("acad");
		} else if (entity instanceof Academic) {
			ut.setTitle(((Academic) entity).getAcademicName());
			ut.setType("学术活动名称");
			ut.setTypeInSys("academic");
		} else if (entity instanceof Advstudy) {
			ut.setTitle(((Advstudy) entity).getAdvstudyDirection());
			ut.setType("进修方向");
			ut.setTypeInSys("advstudy");
		}else if (entity instanceof Expense) {
			ut.setTitle(((Expense) entity).getDicExpenseType());
			ut.setType("经费申请");
			ut.setTypeInSys("expense");
		}else if (entity instanceof Academiccost) {
			if(((Academiccost) entity).getAcademic()!=null){
				ut.setTitle(((Academiccost) entity).getAcademic().getAcademicName());
				ut.setType("学术活动经费");
				ut.setTypeInSys("academic");
			}
			if(((Academiccost) entity).getAdvstudy()!=null){
				ut.setTitle(((Academiccost) entity).getAdvstudy().getAdvstudyDirection());
				ut.setType("进修经费");
				ut.setTypeInSys("advstudy");
			}
		}
		
		return ut;
	}

	public static UserTask convert(Project entity) {
		UserTask ut = new UserTask();
		ut.setId(entity.getId());
		ut.setEntityId(entity.getId());
		ut.setProcessInstanceId(entity.getProcessInstanceId());
		ut.setProcessInstance(entity.getProcessInstance());
		ut.setTitle(((Project) entity).getProjectName());
		ut.setType("项目");
		ut.setTypeInSys("project");
		if (entity.getNotice().equals("1")) {
			ut.setUrl("oa/project/projectMgmt/" + entity.getId() + "/mid");
		}
		if (entity.getNotice().equals("3")) {
			ut.setUrl("oa/project/projectMgmt/" + entity.getId() + "/end");
		}
		return ut;
	}

	public static List<UserTask> convert(List<Project> entity,
			Boolean isAuditProject) {
		List<UserTask> result = Lists.newArrayList();
		for (Project e : entity) {
			UserTask ut=convert(e);
			ut.setType("考核");
			result.add(convert(e));
		}
		return result;
	}

	public static List<UserTask> convert(List<?> entity) {
		List<UserTask> result = Lists.newArrayList();
		for (Object e : entity) {
			result.add(convert((BaseOAEntity) e));
		}
		return result;
	}

	public static List<UserTask> convertAcadputoff(List<Acad> putoffAcads) {
		List<UserTask> result = Lists.newArrayList();
		for (Acad e : putoffAcads) {
			result.add(convertAcadputoff(e));
		}
		return result;
	}

	private static UserTask convertAcadputoff(Acad entity) {
		UserTask ut = new UserTask();
		ut.setId(entity.getId());
		ut.setEntityId(entity.getId());
		ut.setProcessInstanceId(entity.getProcessInstanceId());
		ut.setProcessInstance(entity.getProcessInstance());
		ut.setTitle(entity.getAcadName());
		ut.setType("学会任职延期");
		ut.setTypeInSys("acad");
		ut.setUrl("oa/acad/list/");
		return ut;
	}
}
