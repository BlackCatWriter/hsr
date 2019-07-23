package com.ndtl.yyky.modules.oa.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.dao.BookDao;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;

/**
 * 论文登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class BookService extends BaseOAService {

	@Autowired
	private BookDao bookDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return bookDao;
	}

	public Page<Book> findForSelf(Page<Book> page, Book book) {
		return find(page, book, true);
	}

	public Page<Book> find(Page<Book> page, Book book) {
		return find(page, book, true);
	}

	private Page<Book> find(Page<Book> page, Book book, boolean onlySelf) {
		DetachedCriteria dc = super.createBaseCriteria(page, bookDao, book);
		if (StringUtils.isNotEmpty(book.getSearchYear())) {
			dc.add(Restrictions.like("time", "%" + book.getSearchYear() + "%"));
		}
		if (StringUtils.isNotEmpty(book.getTitle())) {
			dc.add(Restrictions.like("title", "%" + book.getTitle() + "%"));
		}
		Page<Book> result = bookDao.find(page, dc);
		for (Book item : result.getList()) {
			item = (Book) super.retriveProcessAndHistory(item);
		}
		return result;
	}

	public Page<Book> findForCMS(Page<Book> page, Book book,
			boolean isDataScopeFilter, Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, bookDao, book);
		if (StringUtils.isNotEmpty(book.getTitle())) {
			dc.add(Restrictions.like("title", "%" + book.getTitle() + "%"));
		}
		if (StringUtils.isNotEmpty(book.getSearchYear())) {
			dc.add(Restrictions.like("time", "%" + book.getSearchYear() + "%"));
		}
		dc.add(Restrictions.like("delFlag", "%" + book.getDelFlag() + "%"));
		return bookDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Book book = bookDao.findOne(id);
		book.setJl((String) variables.get("jl"));
		book.setWeight((String) variables.get("weight"));
		book.setDelFlag(Book.DEL_FLAG_AUDIT);
		if(StringUtils.isNotEmpty((String) variables.get("remarks"))){
			book.setRemarks(book.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		bookDao.save(book);
	}

	@Transactional(readOnly = false)
	public void saveBook(Book book) {
		bookDao.clear();
		bookDao.save(book);
	}

	@SuppressWarnings("unchecked")
	public List<Book> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Book> results = new ArrayList<Book>();
		results = (List<Book>) super.findTodoTasks(userId, key);
		return results;
	}

	public Book getBookByBookName(String bookName) {
		return bookDao.findByBookName(bookName);
	}

	public List<Book> findForWeightBelong(Long userId, String year) {
		DetachedCriteria dc = super.createDCForWeightBelong(userId, year);
		return bookDao.find(dc);
	}

	public List<Book> findForAchieve(Long userId, String year) {
		DetachedCriteria dc = super.createDCForAchieve(year);
		dc.add(Restrictions.or(Restrictions.eq("author1", userId.toString()),
				Restrictions.eq("weightBelong", userId)));
		return bookDao.find(dc);
	}

	public List<Book> findForDept(Long userId, String year) {
		DetachedCriteria dc = super.createDCForDept(userId, year);
		return bookDao.find(dc);
	}
	
	@Transactional(readOnly = false)
	public void editBook(Book book) {
		bookDao.clear();
		if(book.getProject()!=null&&book.getProject().getId()==null){
			book.setProject(null);
		}
		bookDao.save(book);
	}
}
