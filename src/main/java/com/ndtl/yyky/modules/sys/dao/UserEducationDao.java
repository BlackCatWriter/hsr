package com.ndtl.yyky.modules.sys.dao;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.cms.entity.ExpensePlan;
import com.ndtl.yyky.modules.sys.entity.UserEducation;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * 成果DAO接口
 * 
 */
public interface UserEducationDao extends UserEducationDaoCustom,CrudRepository<UserEducation, Long> {

	@Query("from UserEducation where user.id =?1")
	List<UserEducation> findPlanListByUserId(Long user_id);

	@Query("from UserEducation where user.id =?1")
	List<Map> findPlanMapByUserId(Long user_id);

}

/**
 * DAO自定义接口
 * 
 */
interface UserEducationDaoCustom extends BaseDao<UserEducation> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class UserEducationDaoImpl extends BaseDaoImpl<UserEducation> implements
		UserEducationDaoCustom {

}
