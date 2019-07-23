package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Advstudy;
import com.ndtl.yyky.modules.sys.entity.Office;

public interface AdvstudyDao extends AdvstudyDaoCustom, BaseOADao<Advstudy> {

	@Modifying
	@Query("update Advstudy set delFlag='" + Advstudy.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Override
	@Modifying
	@Query("update Advstudy set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	// @Query("from Academic where academicname = ?1 ")
	// public Academic findByAcademicname(String academicname);

	@Query("from Office o where o.id =?1 and o.delFlag= '"
			+ Office.DEL_FLAG_NORMAL + "'")
	public Office findByOfficeId(Long officeId);

	@Query("from Advstudy where createBy.id = ?1 and delFlag='"
			+ Advstudy.DEL_FLAG_NORMAL + "'")
	public List<Advstudy> findUnfinished(Long id);
	
	@Query("from Advstudy where createBy.id = ?1 and delFlag='"
			+ Advstudy.DEL_FLAG_AUDIT + "'")
	public List<Advstudy> findFinished(Long id);
}

/**
 * DAO自定义接口
 * 
 */
interface AdvstudyDaoCustom extends BaseDao<Advstudy> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class AdvstudyDaoImpl extends BaseDaoImpl<Advstudy> implements
		AdvstudyDaoCustom {

}
