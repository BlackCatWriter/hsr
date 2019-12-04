package com.ndtl.yyky.modules.oa.dao;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.ProjectData;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import java.util.List;

public interface ProjectDataDao extends ProjectDataDaoCustom, BaseOADao<ProjectData> {

	@Modifying
	@Query("update ProjectData set delFlag='" + ProjectData.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Override
	@Modifying
	@Query("update ProjectData set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from ProjectData where createBy.id = ?1 and delFlag='"
			+ ProjectData.DEL_FLAG_NORMAL + "'")
	public List<ProjectData> findUnfinished(Long id);
}

interface ProjectDataDaoCustom extends BaseDao<ProjectData> {

}

@Component
class ProjectDataDaoImpl extends BaseDaoImpl<ProjectData> implements ProjectDataDaoCustom {

}
