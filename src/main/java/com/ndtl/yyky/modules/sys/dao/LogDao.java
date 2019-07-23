
package com.ndtl.yyky.modules.sys.dao;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.sys.entity.Log;

/**
 * 日志DAO接口
 */
public interface LogDao extends LogDaoCustom, CrudRepository<Log, Long> {
	
}

/**
 * DAO自定义接口
 */
interface LogDaoCustom extends BaseDao<Log> {

}

/**
 * DAO自定义接口实现
 */
@Repository
class LogDaoImpl extends BaseDaoImpl<Log> implements LogDaoCustom {

}
