package com.ndtl.yyky.modules.oa.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ndtl.yyky.common.persistence.DataEntity;
import com.ndtl.yyky.modules.sys.entity.User;

@Entity
@Table(name = "oa_reward_user")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RewardToUser extends DataEntity {
	private static final long serialVersionUID = -9201299024697648268L;
	private Long id; // 编号
	private Reward reward;
	private User user;
	private Boolean finished = false;
	private Integer one;//
	private Integer two;//
	private Integer three;//
	private Integer four;//
	private Integer five;//

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@ManyToOne
	@JoinColumn(name = "reward_id")
	@NotFound(action = NotFoundAction.IGNORE)
	@JsonIgnore
	public Reward getReward() {
		return reward;
	}

	public void setReward(Reward reward) {
		this.reward = reward;
	}

	@ManyToOne
	@JoinColumn(name = "user_id")
	@NotFound(action = NotFoundAction.IGNORE)
	@JsonIgnore
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public boolean getFinished() {
		return finished;
	}

	public void setFinished(boolean finished) {
		this.finished = finished;
	}

	public Integer getOne() {
		return one;
	}

	public void setOne(Integer one) {
		this.one = one;
	}

	public Integer getThree() {
		return three;
	}

	public void setThree(Integer three) {
		this.three = three;
	}

	public Integer getTwo() {
		return two;
	}

	public void setTwo(Integer two) {
		this.two = two;
	}

	public Integer getFour() {
		return four;
	}

	public void setFour(Integer four) {
		this.four = four;
	}

	public Integer getFive() {
		return five;
	}

	public void setFive(Integer five) {
		this.five = five;
	}
}
