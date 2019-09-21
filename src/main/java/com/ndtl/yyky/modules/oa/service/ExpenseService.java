package com.ndtl.yyky.modules.oa.service;

import java.util.List;
import java.util.Map;

import org.activiti.engine.history.HistoricProcessInstance;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.dao.ExpenseDao;
import com.ndtl.yyky.modules.oa.dao.ProjectDao;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 经费Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class ExpenseService extends BaseOAService {

	@Autowired
	private ExpenseDao expenseDao;
	
	@Autowired
	private ProjectDao projectDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return expenseDao;
	}

	public Page<Expense> find(Page<Expense> page, Expense expense) {
		DetachedCriteria dc = super.createBaseCriteria(page, expenseDao,
				expense);
		if(expense.getIsRejected()==null||!expense.getIsRejected()){
			dc.add(Restrictions.ne("delFlag", Expense.DEL_FLAG_DELETE));
		}
		if (expense.getProject() != null&&expense.getProject().getId()!=null) {
			dc.add(Restrictions.eq("project.id", expense.getProject().getId()));
		}
		if (expense.getCreateDateStart() != null) {
			dc.add(Restrictions.ge("createDate", expense.getCreateDateStart()));
		}
		if (expense.getCreateDateEnd() != null) {
			dc.add(Restrictions.le("createDate", expense.getCreateDateEnd()));
		}
		if (StringUtils.isNotBlank(expense.getExpenseType())) {
			dc.add(Restrictions.like("expenseType", expense.getExpenseType()));
		}
		if(expense.getProject()!=null&&StringUtils.isNotBlank(expense.getProjectNo())){
			dc.createAlias("project", "project");
			dc.add(Restrictions.like("project.projectNo",  "%"+expense.getProjectNo()+"%"));
		}
		dc.addOrder(Order.desc("delFlag"));
		Page<Expense> searchResult = expenseDao.find(page, dc);
		List<Expense> expenseList = filterResultByRole(searchResult.getList());

		for (Expense item : expenseList) {
			super.retriveProcessAndHistory(item);
		}
		searchResult.setList(expenseList);
		return searchResult;
	}

	public Page<Expense> findForCMS(Page<Expense> page, Expense expense,
			Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, expenseDao,
				expense);
		if(expense.getIsRejected()==null||!expense.getIsRejected()){
			dc.add(Restrictions.eq("delFlag", Expense.DEL_FLAG_AUDIT));
		}
		if (expense.getCreateDateStart() != null) {
			dc.add(Restrictions.ge("createDate", expense.getCreateDateStart()));
		}
		if (expense.getCreateDateEnd() != null) {
			dc.add(Restrictions.le("createDate", expense.getCreateDateEnd()));
		}
		if (expense.getProject() != null&&expense.getProject().getId()!= null) {
			dc.add(Restrictions.eq("project.id", expense.getProject().getId()));
		}
		if (StringUtils.isNotBlank(expense.getExpenseType())) {
			dc.add(Restrictions.like("expenseType", expense.getExpenseType()));
		}
		if(expense.getProject()!=null&&StringUtils.isNotBlank(expense.getProjectNo())){
			dc.createAlias("project", "project");
			dc.add(Restrictions.like("project.projectNo",  "%"+expense.getProjectNo()+"%"));
		}
		dc.addOrder(Order.desc("delFlag"));
		Page<Expense> searchResult = expenseDao.find(page, dc);
		List<Expense> expenseList = filterResultByRole(searchResult.getList());
		for (Expense item : expenseList) {
			super.retriveProcessAndHistory(item);
		}
		searchResult.setList(expenseList);
		return searchResult;
	}

	private List<Expense> filterResultByRole(List<Expense> list) {
		User user = UserUtils.getUser();
		if (UserUtils.isAdmin(user) || UserUtils.isFinance(user)
				|| UserUtils.isHosLeader(user) || UserUtils.isKJDept()) {
			return list;
		} else if (UserUtils.isDeptLeader(user)) {
			Office office = user.getOffice();
			List<Expense> result = Lists.newArrayList();
			for (Expense e : list) {
				if ((e != null && e.getProject() != null
						&& e.getProject().getOffice() != null && e.getProject()
						.getOffice().getId().equals(office.getId()))
						|| (e.getCreateBy() != null && e.getCreateBy().getId()
								.equals(user.getId()))) {
					result.add(e);
				}
			}
			return result;
		} else {
			List<Expense> result = Lists.newArrayList();
			for (Expense e : list) {
				if (e != null && e.getCreateBy() != null
						&& e.getCreateBy().getId().equals(user.getId())) {
					result.add(e);
				}
			}
			return result;
		}
	}


	public List<Expense> getAllExpense(Long projectId) {
		List<Expense> existingExpenses = expenseDao
				.getExpensesForProject(projectId);
		for (Expense expense : existingExpenses) {
			expense.setIsUsed(isExpenseUsed(expense));
		}
		return existingExpenses;
	}

	@SuppressWarnings("deprecation")
	private Boolean isExpenseUsed(Expense expense) {
		String processInstanceId = expense.getProcessInstanceId();
		if (processInstanceId == null || processInstanceId.trim().length() == 0) {
			return false;
		}
		HistoricProcessInstance historicProcessInstance = historyService
				.createHistoricProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		if (historicProcessInstance != null
				&& historicProcessInstance.getEndActivityId() != null
				&& historicProcessInstance.getEndActivityId().equals(
						"endevent3")) {
			return true;
		}
		return false;
	}

	@Transactional(readOnly = false)
	public void saveExpense(Expense expense) {
		expenseDao.clear();
		expenseDao.save(expense);
	}

	public Expense getExpenseByExpenseName(String expenseName) {
		return expenseDao.findByExpenseName(expenseName);
	}
	
	public int completeById(Long id) {
		return expenseDao.completeById(id);
	}
}
