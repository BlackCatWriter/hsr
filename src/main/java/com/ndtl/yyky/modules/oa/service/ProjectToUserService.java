package com.ndtl.yyky.modules.oa.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.oa.dao.ProjectToUserDao;
import com.ndtl.yyky.modules.oa.entity.ProjectToUser;

/**
 * 项目登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class ProjectToUserService extends BaseService {

	@Autowired
	private ProjectToUserDao projectToUserDao;

	@Transactional(readOnly = false)
	public void save(ProjectToUser entity) {
		projectToUserDao.clear();
		projectToUserDao.save(entity);
	}

	@Transactional(readOnly = false)
	public void save(List<ProjectToUser> entity) {
		projectToUserDao.clear();
		projectToUserDao.save(entity);
	}

	@Transactional(readOnly = false)
	public ProjectToUser findOne(long id) {
		return projectToUserDao.findOne(id);
	}

	@Transactional(readOnly = false)
	public void delete(List<ProjectToUser> ptus) {
		projectToUserDao.delete(ptus);
	}

	@Transactional(readOnly = true)
	public List<ProjectToUser> findByUserId(Long userId) {
		return projectToUserDao.findByUserId(userId);
	}
}
