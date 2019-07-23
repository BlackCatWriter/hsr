package com.ndtl.yyky.modules.oa.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.criterion.DetachedCriteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.dao.AcademiccostDao;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.entity.Academic;
import com.ndtl.yyky.modules.oa.entity.Academiccost;
import com.ndtl.yyky.modules.oa.entity.Advstudy;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;

/**
 * 经费Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class AcademiccostService extends BaseOAService {

	@Autowired
	private AcademiccostDao academiccostDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return academiccostDao;
	}

	public Page<Academiccost> find(Page<Academiccost> page, Academiccost expense) {
		DetachedCriteria dc = super.createBaseCriteria(page, academiccostDao,
				expense);
		Page<Academiccost> result = academiccostDao.find(page, dc);
		for (Academiccost item : result.getList()) {
			super.retriveProcessAndHistory(item);
		}
		return result;
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		Academiccost academiccost = academiccostDao.findOne(id);
		academiccost.setDelFlag(Academic.DEL_FLAG_AUDIT);
		academiccostDao.save(academiccost);
	}
	
//	@SuppressWarnings("deprecation")
//	private Boolean isAcademiccostUsed(Academiccost expense) {
//		String processInstanceId = expense.getProcessInstanceId();
//		if (processInstanceId == null || processInstanceId.trim().length() == 0) {
//			return false;
//		}
//		HistoricProcessInstance historicProcessInstance = historyService
//				.createHistoricProcessInstanceQuery()
//				.processInstanceId(processInstanceId).singleResult();
//		if (historicProcessInstance != null
//				&& historicProcessInstance.getEndActivityId() != null
//				&& historicProcessInstance.getEndActivityId().equals(
//						"endevent3")) {
//			return true;
//		}
//		return false;
//	}
	@SuppressWarnings("unchecked")
	public List<Academic> findAcademicTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Academiccost> costs = new ArrayList<Academiccost>();
		costs = (List<Academiccost>) super.findTodoTasks(userId, key);
		List<Academic> results = new ArrayList<Academic>();
		for(Academiccost academiccost:costs){
//			for(Academic academic:academics){
				if(academiccost.getAcademic()!=null){
					Academic academic=academiccost.getAcademic();
					academic.setAcademiccost(academiccost);
					results.add(academic);
				}
//			}			
		}
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public List<Advstudy> findAdvstudyTodoTasks(String userId, ProcessDefinitionKey key) {
		List<Academiccost> costs = new ArrayList<Academiccost>();
		costs = (List<Academiccost>) super.findTodoTasks(userId, key);
		List<Advstudy> results = new ArrayList<Advstudy>();
		for(Academiccost academiccost:costs){
//			for(Advstudy advstudy:advstudys){
				if(academiccost.getAdvstudy()!=null){
					Advstudy advstudy=academiccost.getAdvstudy();
					advstudy.setAcademiccost(academiccost);
					results.add(advstudy);
				}
//			}
		}
		return results;
	}

	@Transactional(readOnly = false)
	public void saveAcademiccost(Academiccost academiccost) {
		academiccostDao.clear();
		academiccostDao.save(academiccost);
	}
	
	@Transactional(readOnly = false)
	public void flush() {
		academiccostDao.flush();
	}
	
	@Transactional(readOnly = false)
	public List<Academiccost> finishedCost(Long id) {
		return academiccostDao.findFinished(id);
	}
	
	@Transactional(readOnly = false)
	public List<Academiccost> allCost(Long id) {
		return academiccostDao.findAll(id);
	}

}
