package com.ndtl.yyky.modules.oa.dao;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Leave;

/**
 * 请假DAO接口
 */
public interface LeaveDao extends LeaveDaoCustom, CrudRepository<Leave, Long> {

	@Modifying
	@Query("update Leave set delFlag='" + Leave.DEL_FLAG_DELETE + "' where id = ?1")
	public int deleteById(Long id);
	
	@Modifying
	@Query("update Leave set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id,String processInstanceId);
}

/**
 * DAO自定义接口
 */
interface LeaveDaoCustom extends BaseDao<Leave> {

}

/**
 * DAO自定义接口实现
 */
@Component
class LeaveDaoImpl extends BaseDaoImpl<Leave> implements LeaveDaoCustom {

}
