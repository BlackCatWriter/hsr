package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Reward;

/**
 * 经费DAO接口
 * 
 */
public interface RewardDao extends RewardDaoCustom, BaseOADao<Reward> {

	@Modifying
	@Query("update Reward set delFlag='" + Reward.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Modifying
	@Query("update Reward set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Reward where rewardName = ?1")
	public Reward findByRewardName(String rewardName);

	@Query("from Reward where createBy.id = ?1 and delFlag='"
			+ Reward.DEL_FLAG_NORMAL + "'")
	public List<Reward> findUnfinished(Long id);
}

/**
 * DAO自定义接口
 * 
 */
interface RewardDaoCustom extends BaseDao<Reward> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class RewardDaoImpl extends BaseDaoImpl<Reward> implements RewardDaoCustom {

}
