package com.ndtl.yyky.modules.cms.dao;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.cms.entity.ExpenseRatio;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 成果DAO接口
 * 
 */
public interface ExpensePlanDao extends ExpensePlanDaoCustom,CrudRepository<ExpensePlan, Long> {

	@Query("from ExpensePlan where project.id =?1")
	List<ExpensePlan> findPlanListByProjectId(Long project_id);

	@Query("from ExpensePlan where project.id =?1 and expense_type=?2")
	ExpensePlan findPlanByType(Long project_id,String expenseType);
}

/**
 * DAO自定义接口
 * 
 */
interface ExpensePlanDaoCustom extends BaseDao<ExpensePlan> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class ExpensePlanDaoImpl extends BaseDaoImpl<ExpensePlan> implements
		ExpensePlanDaoCustom {

}
