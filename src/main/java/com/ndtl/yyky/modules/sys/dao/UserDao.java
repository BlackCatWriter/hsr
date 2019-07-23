package com.ndtl.yyky.modules.sys.dao;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.sys.entity.User;

/**
 * 用户DAO接口
 */
public interface UserDao extends UserDaoCustom, CrudRepository<User, Long> {

	@Query("from User where loginName = ?1 and delFlag = '"
			+ User.DEL_FLAG_NORMAL + "'")
	public User findByLoginName(String loginName);

	@Query("from User where id = ?1 and delFlag = '" + User.DEL_FLAG_NORMAL
			+ "'")
	public User findUserById(Long id);

	@Query("from User where no = ?1 and delFlag = '" + User.DEL_FLAG_NORMAL
			+ "'")
	public User findUserByNO(String number);

	@Query("from User where delFlag='" + User.DEL_FLAG_NORMAL + "' order by no")
	public List<User> findAllList();

	@Modifying
	@Query("update User set delFlag='" + User.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Modifying
	@Query("update User set password=?1 where id = ?2")
	public int updatePasswordById(String newPassword, Long id);

	@Modifying
	@Query("update User set loginIp=?1, loginDate=?2 where id = ?3")
	public int updateLoginInfo(String loginIp, Date loginDate, Long id);
}

/**
 * DAO自定义接口
 */
interface UserDaoCustom extends BaseDao<User> {

}

/**
 * DAO自定义接口实现
 */
@Repository
class UserDaoImpl extends BaseDaoImpl<User> implements UserDaoCustom {

}
