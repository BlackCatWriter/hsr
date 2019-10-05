package com.ndtl.yyky.modules.cms.dao;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.cms.entity.Account;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;

/**
 * 成果DAO接口
 * 
 */
public interface AccountDao extends AccountDaoCustom,CrudRepository<Account, Long> {

	@Query("from Account where projectName = ?1")
	public Account findByProjectName(String projectName);

}

/**
 * DAO自定义接口
 * 
 */
interface AccountDaoCustom extends BaseDao<Account> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class AccountDaoImpl extends BaseDaoImpl<Account> implements
		AccountDaoCustom {

}
