package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Book;

public interface BookDao extends BookDaoCustom, BaseOADao<Book> {

	@Modifying
	@Query("update Book set delFlag='" + Book.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Override
	@Modifying
	@Query("update Book set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Book where title = ?1 ")
	public Book findByBookName(String bookName);

	@Query("from Book where createBy.id = ?1 and delFlag='"
			+ Book.DEL_FLAG_NORMAL + "'")
	public List<Book> findUnfinished(Long id);
}

interface BookDaoCustom extends BaseDao<Book> {

}

@Component
class BookDaoImpl extends BaseDaoImpl<Book> implements BookDaoCustom {

}
