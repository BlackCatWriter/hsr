package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Academic;
import com.ndtl.yyky.modules.sys.entity.Office;

public interface AcademicDao extends AcademicDaoCustom, BaseOADao<Academic> {

	@Modifying
	@Query("update Academic set delFlag='" + Academic.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Override
	@Modifying
	@Query("update Academic set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Academic where academicname = ?1 ")
	public Academic findByAcademicname(String academicname);

	@Query("from Office o where o.id =?1 and o.delFlag= '"
			+ Office.DEL_FLAG_NORMAL + "'")
	public Office findByOfficeId(Long officeId);

	@Query("from Academic where createBy.id = ?1 and delFlag='"
			+ Academic.DEL_FLAG_NORMAL + "'")
	public List<Academic> findUnfinished(Long id);
	
	@Query("from Academic where createBy.id = ?1 and delFlag='"
			+ Academic.DEL_FLAG_AUDIT + "'")
	public List<Academic> findFinished(Long id);
}

/**
 * DAO自定义接口
 * 
 */
interface AcademicDaoCustom extends BaseDao<Academic> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class AcademicDaoImpl extends BaseDaoImpl<Academic> implements
		AcademicDaoCustom {

}
