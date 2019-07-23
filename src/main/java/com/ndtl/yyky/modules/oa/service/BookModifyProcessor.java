package com.ndtl.yyky.modules.oa.service;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.modules.oa.dao.BookDao;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.sys.entity.Office;

@Service
@Transactional
public class BookModifyProcessor implements TaskListener {

	private static final long serialVersionUID = 1L;

	@Autowired
	private BookDao bookDao;
	@Autowired
	private RuntimeService runtimeService;

	public void notify(DelegateTask delegateTask) {
		String processInstanceId = delegateTask.getProcessInstanceId();
		ProcessInstance processInstance = runtimeService
				.createProcessInstanceQuery()
				.processInstanceId(processInstanceId).singleResult();
		Book book = bookDao.findOne(new Long(processInstance.getBusinessKey()));
		book.setAuthor1((String) delegateTask.getVariable("author1"));
		book.setTitle((String) delegateTask.getVariable("title"));
		if (StringUtils.isNotEmpty((String) delegateTask.getVariable("time"))) {
			book.setTime((String) delegateTask.getVariable("time"));
		}
		book.setPublisher((String) delegateTask.getVariable("publisher"));
		book.setNumber((String) delegateTask.getVariable("number"));
		book.setProfession((String) delegateTask.getVariable("profession"));
		if (delegateTask.getVariable("officeName") != null) {
			Office office = new Office();
			office.setId(Long.valueOf(delegateTask.getVariable("officeName")
					.toString()));
			book.setOffice(office);
		}
		book.setWeightBelong(Long.valueOf(delegateTask.getVariable(
				"weightBelong").toString()));
		book.setRemarks((String) delegateTask.getVariable("remarks"));
		book.setFile((String) delegateTask.getVariable("file"));
		book.setJl(String.valueOf(delegateTask.getVariable("jl")));
		if (StringUtils.isNotEmpty(delegateTask.getVariable("letters")
				.toString())) {
			book.setLetters(Integer.valueOf(delegateTask.getVariable("letters")
					.toString()));
		}
		book.setRole(String.valueOf(delegateTask.getVariable("role")));
		bookDao.save(book);
	}

}
