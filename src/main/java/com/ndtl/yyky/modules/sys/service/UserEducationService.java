package com.ndtl.yyky.modules.sys.service;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.cms.dao.ExpensePlanDao;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.sys.dao.UserEducationDao;
import com.ndtl.yyky.modules.sys.entity.UserEducation;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

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

	public List<Map> expertUserEducationDetail(Long userId) {

		StringBuilder ql = new StringBuilder();
		List<Object> ps = Lists.newArrayList();

		ql.append(" select DATE_FORMAT(t.start_date,'%Y-%m-%d %H:%i:%s') as start_date,DATE_FORMAT(t.end_date,'%Y-%m-%d %H:%i:%s') as end_date, ");
		ql.append(" t.school_name,t.prefression,t.graduate_advisor,d.label as degree,d1.label as educational_background from oa_user_education t ");
		ql.append(" left join sys_dict d on t.degree=d.`value` and d.type='degree' left join sys_dict d1 on t.educational_background=d1.`value` and d1.type='educational_background' where 1=1 ");

		if(StringUtils.isNotBlank(String.valueOf(userId))){
			ql.append(" and t.user_id = ?");
			ps.add(userId);
		}

		List<Map> resultList = userEducationDao.findBySql(ql.toString(), Map.class, ps.toArray());

		return resultList;
	}

}
