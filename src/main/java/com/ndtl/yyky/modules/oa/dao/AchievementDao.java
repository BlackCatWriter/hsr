package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Achievement;
import com.ndtl.yyky.modules.sys.entity.Office;

/**
 * 成果DAO接口
 * 
 */
public interface AchievementDao extends AchievementDaoCustom,
		BaseOADao<Achievement> {

	@Modifying
	@Query("update Achievement set delFlag='" + Achievement.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Modifying
	@Query("update Achievement set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Achievement where projectName = ?1 and delFlag = '"
			+ Achievement.DEL_FLAG_NORMAL + "'")
	public Achievement findByProjectName(String projectName);

	@Query("from Office o where o.id =?1 and o.delFlag= '"
			+ Office.DEL_FLAG_NORMAL + "'")
	public Office findByOfficeId(Long officeId);

	@Query("from Achievement where createBy.id = ?1 and delFlag='"
			+ Achievement.DEL_FLAG_NORMAL + "'")
	public List<Achievement> findUnfinished(Long id);
}

/**
 * DAO自定义接口
 * 
 */
interface AchievementDaoCustom extends BaseDao<Achievement> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class AchievementDaoImpl extends BaseDaoImpl<Achievement> implements
		AchievementDaoCustom {

}
