package com.ndtl.yyky.modules.sys.service;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.cms.dao.ExpensePlanDao;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.sys.dao.UserWorkDao;
import com.ndtl.yyky.modules.sys.entity.UserWork;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

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

	public List<Map> expertUserWorkDetail(Long userId) {

		StringBuilder ql = new StringBuilder();
		List<Object> ps = Lists.newArrayList();

		ql.append(" select DATE_FORMAT(t.start_date,'%Y-%m-%d %H:%i:%s') as start_date,DATE_FORMAT(t.end_date,'%Y-%m-%d %H:%i:%s') as end_date,t.company_name,d.label as post,d1.label as title from oa_user_work t ");
		ql.append(" left join sys_dict d on t.post=d.`value` and d.type='acad_exercise_role' left join sys_dict d1 on t.title=d1.`value` and d1.type='professional_title' where 1=1 ");

		if(StringUtils.isNotBlank(String.valueOf(userId))){
			ql.append(" and t.user_id = ?");
			ps.add(userId);
		}

		List<Map> resultList = userWorkDao.findBySql(ql.toString(), Map.class, ps.toArray());

		return resultList;
	}
}
