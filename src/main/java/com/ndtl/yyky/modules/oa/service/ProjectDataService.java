package com.ndtl.yyky.modules.oa.service;

import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.dao.BookDao;
import com.ndtl.yyky.modules.oa.dao.ProjectDataDao;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.ProjectData;
import com.ndtl.yyky.modules.oa.entity.enums.ProjectStatus;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.oa.utils.workflow.ProcessDefinitionKey;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 论文登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class ProjectDataService extends BaseOAService {

	@Autowired
	private ProjectDataDao projectDataDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return projectDataDao;
	}

	public Page<ProjectData> find(Page<ProjectData> page, ProjectData projectData, boolean onlySelf) {
		DetachedCriteria dc = super.createBaseCriteria(page, projectDataDao,
				projectData);

		if (StringUtils.isNotBlank(projectData.getProjectNo())) {
			dc.add(Restrictions.like("projectNo", "%" + projectData.getProjectNo()
					+ "%"));
		}

		Page<ProjectData> result = projectDataDao.find(page, dc);
		for (ProjectData item : result.getList()) {
			item = (ProjectData) super.retriveProcessAndHistory(item);
		}
		return result;
	}

	public ProjectData findByDataId(Long id){
		return projectDataDao.findOne(id);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables) {
		ProjectData projectData = projectDataDao.findOne(id);
		projectData.setDelFlag(Book.DEL_FLAG_AUDIT);
		if(StringUtils.isNotEmpty((String) variables.get("remarks"))){
			projectData.setRemarks(projectData.getRemarks() + '\n'
				+ (String) variables.get("remarks"));
		}
		projectDataDao.save(projectData);
	}

	@Transactional(readOnly = false)
	public void saveProjectData(ProjectData projectData) {
		projectDataDao.clear();
		projectDataDao.save(projectData);
	}

	@SuppressWarnings("unchecked")
	public List<ProjectData> findTodoTasks(String userId, ProcessDefinitionKey key) {
		List<ProjectData> results = new ArrayList<ProjectData>();
		results = (List<ProjectData>) super.findTodoTasks(userId, key);
		return results;
	}

}
