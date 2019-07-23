
package com.ndtl.yyky.modules.cms.dao;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.cms.entity.Guestbook;

/**
 * 留言DAO接口
 */
public interface GuestbookDao extends GuestbookDaoCustom, CrudRepository<Guestbook, Long> {

	@Modifying
	@Query("update Guestbook set delFlag=?2 where id = ?1")
	public int updateDelFlag(Long id, String status);
	
}

/**
 * DAO自定义接口
 */
interface GuestbookDaoCustom extends BaseDao<Guestbook> {

}

/**
 * DAO自定义接口实现
 */
@Repository
class GuestbookDaoImpl extends BaseDaoImpl<Guestbook> implements GuestbookDaoCustom {

}
