package com.ndtl.yyky.modules.oa.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.oa.dao.RewardToUserDao;
import com.ndtl.yyky.modules.oa.entity.RewardToUser;

@Service
@Transactional(readOnly = true)
public class RewardToUserService extends BaseService {

	@Autowired
	private RewardToUserDao rewardToUserDao;

	@Transactional(readOnly = false)
	public void save(RewardToUser entity) {
		rewardToUserDao.clear();
		rewardToUserDao.save(entity);
	}

	@Transactional(readOnly = false)
	public void save(List<RewardToUser> entity) {
		rewardToUserDao.clear();
		rewardToUserDao.save(entity);
	}

	@Transactional(readOnly = false)
	public RewardToUser findOne(long id) {
		return rewardToUserDao.findOne(id);
	}

	@Transactional(readOnly = true)
	public List<RewardToUser> findByUserId(Long userId) {
		return rewardToUserDao.findByUserId(userId);
	}

}
