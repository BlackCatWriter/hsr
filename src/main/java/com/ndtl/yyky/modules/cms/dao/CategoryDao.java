
package com.ndtl.yyky.modules.cms.dao;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.cms.entity.Category;

/**
 * 栏目DAO接口
 */
public interface CategoryDao extends CategoryDaoCustom, CrudRepository<Category, Long> {

	@Modifying
	@Query("update Category set delFlag='" + Category.DEL_FLAG_DELETE + "' where id = ?1 or parentIds like ?2")
	public int deleteById(Long id, String likeParentIds);
	
	public List<Category> findByParentIdsLike(String parentIds);

	@Query("from Category where delFlag='" + Category.DEL_FLAG_NORMAL + "' and (module='' or module=?1) order by site.id, sort")
	public List<Category> findByModule(String module);

	@Query("from Category where delFlag='" + Category.DEL_FLAG_NORMAL + "' and parent.id=?1 and site.id=?2 order by site.id, sort")
	public List<Category> findByParentId(Long parentId, Long siteId);
	
	@Query("from Category where delFlag='" + Category.DEL_FLAG_NORMAL + "' and parent.id=:parentId order by site.id, sort")
	public Page<Category> findByParentId(@Param("parentId") Long parentId, Pageable pageable);
	
	@Query("from Category where delFlag='" + Category.DEL_FLAG_NORMAL + "' and parent.id=?1 and inMenu=?2 order by site.id, sort")
	public List<Category> findByParentId(Long parentId, String isMenu);
	
	public List<Category> findByIdIn(Long[] ids);
	
}

/**
 * DAO自定义接口
 */
interface CategoryDaoCustom extends BaseDao<Category> {

}

/**
 * DAO自定义接口实现
 */
@Repository
class CategoryDaoImpl extends BaseDaoImpl<Category> implements CategoryDaoCustom {

}
