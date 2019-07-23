package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.RewardToUser;

public interface RewardToUserDao extends RewardToUserDaoCustom,
		CrudRepository<RewardToUser, Long> {

	@Modifying
	@Query("update RewardToUser set delFlag=?2 where id = ?1")
	public int updateDelFlag(Long id, String status);

	public List<RewardToUser> findByIdIn(Long[] ids);

	@Modifying
	@Query("update RewardToUser set delFlag='" + RewardToUser.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Query("from RewardToUser where user.id = ?1 and finished='0' and delFlag='"
			+ Reward.DEL_FLAG_NORMAL + "'")
	public List<RewardToUser> findByUserId(Long id);

}

/**
 * DAO自定义接口
 */
interface RewardToUserDaoCustom extends BaseDao<RewardToUser> {

}

/**
 * DAO自定义接口实现
 */
@Repository
class RewardToUserDaoImpl extends BaseDaoImpl<RewardToUser> implements
		RewardToUserDaoCustom {

}
