package com.ndtl.yyky.modules.oa.dao;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Acad;
import com.ndtl.yyky.modules.sys.entity.Office;

public interface AcadDao extends AcadDaoCustom, BaseOADao<Acad> {

	@Modifying
	@Query("update Acad set delFlag='" + Acad.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Override
	@Modifying
	@Query("update Acad set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Acad where acadname = ?1 ")
	public Acad findByAcadname(String acadname);

	@Query("from Office o where o.id =?1 and o.delFlag= '"
			+ Office.DEL_FLAG_NORMAL + "'")
	public Office findByOfficeId(Long officeId);

	@Query("from Acad where createBy.id = ?1 and delFlag='"
			+ Acad.DEL_FLAG_NORMAL + "'")
	public List<Acad> findUnfinished(Long id);
	
	@Query("from Acad where endDate <=?1 and delFlag= '"
			+ Acad.DEL_FLAG_AUDIT + "'")
	public List<Acad> findContinuedAcad(Date currentDate);
	
	@Query("from Acad where createBy.id = ?2 and endDate <=?1 and delFlag= '"
			+ Acad.DEL_FLAG_AUDIT + "'and isFinished= '"+ Acad.NO+"'")
	public List<Acad> findOwnedContinuedAcad(Date currentDate, Long id);
	
	@Modifying
	@Query("update Acad set endDate=?2 where id = ?1")
	public int updateEndDate(Long id,Date endDate);
}

/**
 * DAO自定义接口
 * 
 */
interface AcadDaoCustom extends BaseDao<Acad> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class AcadDaoImpl extends BaseDaoImpl<Acad> implements AcadDaoCustom {

}
