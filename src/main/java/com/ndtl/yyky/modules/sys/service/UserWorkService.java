package com.ndtl.yyky.modules.sys.service;

import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.cms.dao.ExpensePlanDao;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.sys.dao.UserWorkDao;
import com.ndtl.yyky.modules.sys.entity.UserWork;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 个人工作经验Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class UserWorkService extends BaseService {

	@Autowired
	private UserWorkDao userWorkDao;

	public List<UserWork> findPlanListByUserId(Long user_id) {
		return userWorkDao.findPlanListByUserId(user_id);
	}


	@Transactional(readOnly = false)
	public void save(UserWork plan) {
		plan.setUpdateBy(UserUtils.getUser());
		plan.setUpdateDate(new Date());
		userWorkDao.clear();
		userWorkDao.save(plan);
	}

	@Transactional(readOnly = false)
	public void delete(Long id){
		userWorkDao.delete(id);
	}
}
