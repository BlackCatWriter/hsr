package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.ProjectToUser;
import com.ndtl.yyky.modules.oa.entity.Reward;

/**
 * 文章DAO接口
 */
public interface ProjectToUserDao extends ProjectToUserDaoCustom,
		CrudRepository<ProjectToUser, Long> {

	@Modifying
	@Query("update ProjectToUser set delFlag=?2 where id = ?1")
	public int updateDelFlag(Long id, String status);

	public List<ProjectToUser> findByIdIn(Long[] ids);

	@Modifying
	@Query("update ProjectToUser set delFlag='" + ProjectToUser.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Query("from ProjectToUser where user.id = ?1 and finished='0' and delFlag='"
			+ Reward.DEL_FLAG_NORMAL + "'")
	public List<ProjectToUser> findByUserId(Long id);
}

/**
 * DAO自定义接口
 */
interface ProjectToUserDaoCustom extends BaseDao<ProjectToUser> {

}

/**
 * DAO自定义接口实现
 */
@Repository
class ProjectToUserDaoImpl extends BaseDaoImpl<ProjectToUser> implements
		ProjectToUserDaoCustom {

}
