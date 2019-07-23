package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Thesis;

/**
 * 经费DAO接口
 * 
 */
public interface ThesisDao extends ThesisDaoCustom, BaseOADao<Thesis> {

	@Modifying
	@Query("update Thesis set delFlag='" + Thesis.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Override
	@Modifying
	@Query("update Thesis set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Thesis where title = ?1 ")
	public Thesis findByThesisName(String thesisName);

	@Query("from Thesis where createBy.id = ?1 and delFlag='"
			+ Thesis.DEL_FLAG_NORMAL + "'")
	public List<Thesis> findUnfinished(Long id);
}

/**
 * DAO自定义接口
 * 
 */
interface ThesisDaoCustom extends BaseDao<Thesis> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class ThesisDaoImpl extends BaseDaoImpl<Thesis> implements ThesisDaoCustom {

}
