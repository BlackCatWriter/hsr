package com.ndtl.yyky.modules.sys.service;

import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.cms.dao.ExpensePlanDao;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.sys.dao.UserEducationDao;
import com.ndtl.yyky.modules.sys.entity.UserEducation;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 个人学历经验Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class UserEducationService extends BaseService {

	@Autowired
	private UserEducationDao userEducationDao;

	public List<UserEducation> findPlanListByUserId(Long user_id) {
		return userEducationDao.findPlanListByUserId(user_id);
	}

	@Transactional(readOnly = false)
	public void save(UserEducation bean) {
		bean.setUpdateBy(UserUtils.getUser());
		bean.setUpdateDate(new Date());
		userEducationDao.clear();
		userEducationDao.save(bean);
	}

	@Transactional(readOnly = false)
	public void delete(Long id){
		userEducationDao.delete(id);
	}
}
