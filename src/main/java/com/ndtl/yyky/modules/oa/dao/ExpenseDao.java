package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Expense;

/**
 * 经费DAO接口
 * 
 */
public interface ExpenseDao extends ExpenseDaoCustom, BaseOADao<Expense> {

	@Modifying
	@Query("update Expense set delFlag='" + Expense.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);
	
	@Modifying
	@Query("update Expense set delFlag='" + Expense.DEL_FLAG_AUDIT
			+ "' where id = ?1")
	public int completeById(Long id);

	@Modifying
	@Query("update Expense set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Expense where project_id=?1 and ( delFlag='"
			+ Expense.DEL_FLAG_AUDIT + "'" + "or delFlag='"
			+ Expense.DEL_FLAG_NORMAL + "') order by delFlag desc" )
	public List<Expense> getExpensesForProject(Long projectId);

	@Query("from Expense where name = ?1 and delFlag = '"
			+ Expense.DEL_FLAG_NORMAL + "'")
	public Expense findByExpenseName(String expenseName);

	@Query("from Expense where createBy.id = ?1 and delFlag='"
			+ Expense.DEL_FLAG_NORMAL + "'")
	public List<Expense> findUnfinished(Long id);
}

/**
 * DAO自定义接口
 * 
 */
interface ExpenseDaoCustom extends BaseDao<Expense> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class ExpenseDaoImpl extends BaseDaoImpl<Expense> implements ExpenseDaoCustom {

}
