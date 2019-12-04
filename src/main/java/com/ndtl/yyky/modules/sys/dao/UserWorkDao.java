package com.ndtl.yyky.modules.sys.dao;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.sys.entity.UserWork;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 成果DAO接口
 * 
 */
public interface UserWorkDao extends UserWorkDaoCustom,CrudRepository<UserWork, Long> {

	@Query("from UserWork where user.id =?1")
	List<UserWork> findPlanListByUserId(Long user_id);

}

/**
 * DAO自定义接口
 * 
 */
interface UserWorkDaoCustom extends BaseDao<UserWork> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class UserWorkDaoImpl extends BaseDaoImpl<UserWork> implements
		UserWorkDaoCustom {

}
