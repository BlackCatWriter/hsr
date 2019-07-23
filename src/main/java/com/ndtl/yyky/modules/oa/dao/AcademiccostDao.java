package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Academiccost;

/**
 * 经费DAO接口
 * 
 */
public interface AcademiccostDao extends AcademiccostDaoCustom, BaseOADao<Academiccost> {

	@Modifying
	@Query("update Academiccost set delFlag='" + Academiccost.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Modifying
	@Query("update Academiccost set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

//	@Query("from Academiccost where project_id=?1 and delFlag = '"
//			+ Expense.DEL_FLAG_NORMAL + "'")
//	public List<Expense> getExpensesForProject(Long projectId);
//

	@Query("from Academiccost where createBy.id = ?1 and delFlag='"
			+ Academiccost.DEL_FLAG_NORMAL + "'")
	public List<Academiccost> findUnfinished(Long id);
	
	@Query("from Academiccost where createBy.id = ?1 and delFlag='"
			+ Academiccost.DEL_FLAG_AUDIT + "'")
	public List<Academiccost> findFinished(Long id);
	
	@Query("from Academiccost where createBy.id = ?1 and ( delFlag='"
			+ Academiccost.DEL_FLAG_AUDIT + "'" + "or delFlag='"
			+ Academiccost.DEL_FLAG_NORMAL + "')" )
	public List<Academiccost> findAll(Long id);
}

/**
 * DAO自定义接口
 * 
 */
interface AcademiccostDaoCustom extends BaseDao<Academiccost> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class AcademiccostDaoImpl extends BaseDaoImpl<Academiccost> implements AcademiccostDaoCustom {

}
