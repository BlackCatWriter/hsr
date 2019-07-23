package com.ndtl.yyky.modules.oa.web.model;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.google.common.collect.Lists;
import com.ndtl.yyky.modules.oa.entity.Reward;

public class RewardModel {

	private String users = "";
	private String rewards;
	private List<Long> hosRewardIds;
	private List<Long> lxRewardIds;
	private List<Reward> kjkAuditRewards = Lists.newArrayList();
	private List<Reward> hosAuditRewards = Lists.newArrayList();
	private List<Reward> lxAuditRewards = Lists.newArrayList();
	private List<Reward> assignedReward = Lists.newArrayList();
	private List<Long> userIds;
	private String rewardStatus;

	public List<Long> getHosRewardIds() {
		return hosRewardIds;
	}

	public void setHosRewardIds(List<Long> hosRewardIds) {
		this.hosRewardIds = hosRewardIds;
	}

	public List<Long> getUserIds() {
		return userIds;
	}

	public void setUserIds(List<Long> userIds) {
		this.userIds = userIds;
	}

	public String getRewardStatus() {
		return rewardStatus;
	}

	public void setRewardStatus(String rewardStatus) {
		this.rewardStatus = rewardStatus;
	}

	public String getUsers() {
		return users;
	}

	public void setUsers(String users) {
		if (StringUtils.isEmpty(users)) {
			this.users = "";
		} else {
			this.users = users;
		}
	}

	public String getRewards() {
		return rewards;
	}

	public void setRewards(String rewards) {
		this.rewards = rewards;
	}

	public List<Reward> getKjkAuditRewards() {
		return kjkAuditRewards;
	}

	public void setKjkAuditRewards(List<Reward> kjkAuditRewards) {
		this.kjkAuditRewards = kjkAuditRewards;
	}

	public List<Reward> getLxAuditRewards() {
		return lxAuditRewards;
	}

	public void setLxAuditRewards(List<Reward> lxAuditRewards) {
		this.lxAuditRewards = lxAuditRewards;
	}

	public List<Reward> getHosAuditRewards() {
		return hosAuditRewards;
	}

	public void setHosAuditRewards(List<Reward> hosAuditRewards) {
		this.hosAuditRewards = hosAuditRewards;
	}

	public List<Long> getLxRewardIds() {
		return lxRewardIds;
	}

	public void setLxRewardIds(List<Long> lxRewardIds) {
		this.lxRewardIds = lxRewardIds;
	}

	public List<Reward> getAssignedReward() {
		return assignedReward;
	}

	public void setAssignedReward(List<Reward> assignedReward) {
		this.assignedReward = assignedReward;
	}

}
