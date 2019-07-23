package com.ndtl.yyky.modules.sys.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;

/**
 * 机构DAO接口
 */
public interface OfficeDao extends OfficeDaoCustom,
		CrudRepository<Office, Long> {

	@Query("select u from User u left join u.office o  where u.delFlag='"
			+ Office.DEL_FLAG_NORMAL + "' order by o.id")
	List<User> findListWithUsers();

	@Modifying
	@Query("update Office set delFlag='" + Office.DEL_FLAG_DELETE
			+ "' where id = ?1 or parentIds like ?2")
	public int deleteById(Long id, String likeParentIds);

	public List<Office> findByParentIdsLike(String parentIds);
}

/**
 * DAO自定义接口
 */
interface OfficeDaoCustom extends BaseDao<Office> {

}

/**
 * DAO自定义接口实现
 */
@Repository
class OfficeDaoImpl extends BaseDaoImpl<Office> implements OfficeDaoCustom {

}
