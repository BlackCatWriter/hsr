package com.ndtl.yyky.modules.cms.dao;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.cms.entity.Account;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.cms.entity.ExpenseRatio;
import com.ndtl.yyky.modules.sys.entity.Office;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 成果DAO接口
 * 
 */
public interface ExpenseRatioDao extends ExpenseRatioDaoCustom,CrudRepository<ExpenseRatio, Long> {

	@Query("from ExpenseRatio where project.id =?1 and expense_type=?2")
	ExpenseRatio findRatioByType(Long project_id,String expenseType);

	@Query("from ExpenseRatio where project.id =?1")
	List<ExpenseRatio> findRatioListByProjectId(Long project_id);
}

/**
 * DAO自定义接口
 * 
 */
interface ExpenseRatioDaoCustom extends BaseDao<ExpenseRatio> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class ExpenseRatioDaoImpl extends BaseDaoImpl<ExpenseRatio> implements
		ExpenseRatioDaoCustom {

}
