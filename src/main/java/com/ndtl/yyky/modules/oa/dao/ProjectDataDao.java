package com.ndtl.yyky.modules.oa.dao;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.ProjectData;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import java.util.Date;
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

	@Query("from ProjectData where project.id =?1")
	List<ProjectData> findProjectDataListByProjectId(Long project_id);

	@Modifying
	@Query(value = "insert into oa_project_data (office_id,project_id,create_by,create_date) values(?1,?2,?3,?4)",nativeQuery = true)
	int insertProjectData(Long office_id, Long project_id, Long create_by,Date date);


}

interface ProjectDataDaoCustom extends BaseDao<ProjectData> {

}

@Component
class ProjectDataDaoImpl extends BaseDaoImpl<ProjectData> implements ProjectDataDaoCustom {

}
