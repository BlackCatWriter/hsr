
package com.ndtl.yyky.modules.sys.dao;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.sys.entity.Role;

/**
 * 角色DAO接口
 */
public interface RoleDao extends RoleDaoCustom, CrudRepository<Role, Long> {
	
	@Query("from Role where name = ?1 and delFlag = '" + Role.DEL_FLAG_NORMAL + "'")
	public Role findByName(String name);

	@Modifying
	@Query("update Role set delFlag='" + Role.DEL_FLAG_DELETE + "' where id = ?1")
	public int deleteById(Long id);
}

/**
 * DAO自定义接口
 */
interface RoleDaoCustom extends BaseDao<Role> {
}

/**
 * DAO自定义接口实现
 */
@Repository
class RoleDaoImpl extends BaseDaoImpl<Role> implements RoleDaoCustom {

}
