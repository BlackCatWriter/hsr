package com.ndtl.yyky.modules.cms.service;

import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.cms.dao.ExpensePlanDao;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.cms.entity.ExpenseRatio;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 费用填报Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class ExpensePlanService extends BaseService {

	@Autowired
	private ExpensePlanDao expensePlanDao;

	public List<ExpensePlan> findPlanListByProjectId(Long project_id) {
		return expensePlanDao.findPlanListByProjectId(project_id);
	}
	public ExpensePlan findPlanByType(Long project_id, String expenseType) {
		return expensePlanDao.findPlanByType(project_id,expenseType);
	}

	@Transactional(readOnly = false)
	public void save(ExpensePlan plan) {
		plan.setUpdateBy(UserUtils.getUser());
		plan.setUpdateDate(new Date());
		expensePlanDao.clear();
		expensePlanDao.save(plan);
	}

}
