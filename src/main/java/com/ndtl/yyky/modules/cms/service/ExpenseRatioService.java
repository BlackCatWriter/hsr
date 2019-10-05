package com.ndtl.yyky.modules.cms.service;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.cms.dao.AccountDao;
import com.ndtl.yyky.modules.cms.dao.ExpenseRatioDao;
import com.ndtl.yyky.modules.cms.entity.Account;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.cms.entity.ExpenseRatio;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 费用填报Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class ExpenseRatioService extends BaseService {

	@Autowired
	private ExpenseRatioDao expenseRatioDao;



	public Page<ExpenseRatio> find(Page<ExpenseRatio> page) {
		return expenseRatioDao.find(page);
	}

	public List<ExpenseRatio> findRatioListByProjectId(Long project_id) {
		return expenseRatioDao.findRatioListByProjectId(project_id);
	}

	public ExpenseRatio findRatioByType(Long project_id,String expenseType) {
		return expenseRatioDao.findRatioByType(project_id,expenseType);
	}


	@Transactional(readOnly = false)
	public void save(ExpenseRatio ratio) {
		ratio.setUpdateBy(UserUtils.getUser());
		ratio.setUpdateDate(new Date());
		expenseRatioDao.clear();
		expenseRatioDao.save(ratio);
	}

}
