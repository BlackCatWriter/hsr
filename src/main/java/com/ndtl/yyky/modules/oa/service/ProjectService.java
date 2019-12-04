package com.ndtl.yyky.modules.oa.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.ndtl.yyky.modules.cms.dao.ExpensePlanDao;
import com.ndtl.yyky.modules.cms.dao.ExpenseRatioDao;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.oa.dao.BaseOADao;
import com.ndtl.yyky.modules.oa.dao.ExpenseDao;
import com.ndtl.yyky.modules.oa.dao.ProjectDao;
import com.ndtl.yyky.modules.oa.dao.ProjectToUserDao;
import com.ndtl.yyky.modules.oa.entity.Achievement;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.ProjectToUser;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Thesis;
import com.ndtl.yyky.modules.oa.entity.Reward.RewardType;
import com.ndtl.yyky.modules.oa.entity.enums.ProjectStatus;
import com.ndtl.yyky.modules.oa.service.base.BaseOAService;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 项目登记Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class ProjectService extends BaseOAService {

	@Autowired
	private ProjectDao projectDao;
	
	@Autowired
	private ExpenseDao expenseDao;

	@Autowired
	private ExpensePlanDao expensePlanDao;

	@Autowired
	private ExpenseRatioDao expenseRatioDao;

	@Autowired
	private ProjectToUserDao projectToUserDao;

	@SuppressWarnings("rawtypes")
	@Override
	public BaseOADao getDao() {
		return projectDao;
	}

	public List<Thesis> findThesisForProject(Long id) {
		return projectDao.findThesisForProject(id);
	}

	public List<Achievement> findAchievementForProject(Long id) {
		return projectDao.findAchievementForProject(id);
	}

	public List<Expense> findExpenseForProject(Long id) {
		return projectDao.findExpenseForProject(id);
	}

	public Page<Project> find(Page<Project> page, Project project) {
		return find(page, project, false);
	}

	public Page<Project> find(Page<Project> page, Project project,
			Boolean approvalProject) {
		DetachedCriteria dc = super.createBaseCriteria(page, projectDao,
				project);

		if (StringUtils.isNotBlank(project.getProjectNo())) {
			dc.add(Restrictions.like("projectNo", "%" + project.getProjectNo()
					+ "%"));
		}
		Date beginDate = project.getCreateDateStart();
		Date endDate = project.getCreateDateEnd();
		if (beginDate != null && endDate != null) {
			dc.add(Restrictions.or(Restrictions.and(
					Restrictions.between("startDate", beginDate, endDate),
					Restrictions.between("endDate", beginDate, endDate)),
					Restrictions.or(Restrictions.isNull("startDate"),
							Restrictions.isNull("endDate"))));
		}
		if (project.getStatus() != null) {
			dc.add(Restrictions.eq("status", project.getStatus()));
		}
		if (approvalProject) {
			dc.add(Restrictions.in("status", ProjectStatus.getApprovalStatus()));
		}
		Page<Project> result = projectDao.find(page, dc);
		for (Project item : result.getList()) {
			item = (Project) super.retriveProcessAndHistory(item);
		}
		for(Project p:result.getList()){
			copyRelatedAttribute(p);
		}
		return result;
	}

	public List<Project> findAuditProjects(Long id) {
		List<Project> searchResult = projectDao.findOwnedApprovalProjects(id);
		List<Project> result = Lists.newArrayList();
		for (Project p : searchResult) {
			if (StringUtils.isNotEmpty(p.getNotice())
					&& (p.getNotice().equals("1") || p.getNotice().equals("3"))) {
				result.add(p);
			}
		}
		return result;
	}

	public List<Project> findApprovalProjects() {
		return projectDao.findApprovalProjects();
	}

	public List<Project> findFinishAndApprovalProjects() {
		return projectDao.findFinishAndApprovalProjects();
	}

	public List<Project> findOwnedApprovalProjects() {
		return projectDao
				.findOwnedApprovalProjects(UserUtils.getUser().getId());
	}

	public List<Project> findApprovalProjectsByRole() {
		List<Project> projects = projectDao.findApprovalProjects();
		return filterResultByRole(projects);
	}

	private List<Project> filterResultByRole(List<Project> list) {
		User user = UserUtils.getUser();
		if (UserUtils.isAdmin(user) || UserUtils.isFinance(user)
				|| UserUtils.isHosLeader(user) || UserUtils.isKJDept()) {
			return list;
		} else if (UserUtils.isDeptLeader(user)) {
			Office office = user.getOffice();
			List<Project> result = Lists.newArrayList();
			for (Project e : list) {
				if ((e != null && e.getOffice() != null && e.getOffice()
						.getId().equals(office.getId()))
						|| (e.getCreateBy() != null && e.getCreateBy().getId()
								.equals(user.getId()))) {
					result.add(e);
				}
			}
			return result;
		} else {
			List<Project> result = Lists.newArrayList();
			for (Project e : list) {
				if (e != null && e.getCreateBy() != null
						&& e.getCreateBy().getId().equals(user.getId())) {
					result.add(e);
				}
			}
			return result;
		}
	}
	
	public Page<Project> findForRelatedCMS(Page<Project> page, Project project,
			Map<String, Object> paramMap) {
		Page<Project> result = findForCMS(page, project,paramMap);
		for(Project p:result.getList()){
			copyRelatedAttribute(p);
		}
		return result;
	}
	
	public void copyRelatedAttribute(Project project){
		List<Reward> rewards=projectDao.findRewardForProject(project.getId());
		project.setReward(new ArrayList<Reward>());
		project.setNewTec(new ArrayList<Reward>());
		project.setTecAdv(new ArrayList<Reward>());
		for(Reward reward:rewards){
			if(reward.getType().equals(RewardType.tecProgress.name())){
				project.getReward().add(reward);
			}
			if(reward.getType().equals(RewardType.newTec.name())){
				project.getNewTec().add(reward);
			}
			if(reward.getType().equals(RewardType.tecAdv.name())){
				project.getTecAdv().add(reward);
			}
		}
		project.setThesis(projectDao.findThesisForProject(project.getId()));
		project.setPatent(projectDao.findPatentForProject(project.getId()));
		project.setBook(projectDao.findBookForProject(project.getId()));
		project.setPlan(expensePlanDao.findPlanListByProjectId(project.getId()));
		project.setRatio(expenseRatioDao.findRatioListByProjectId(project.getId()));
	}

	public Page<Project> findForCMS(Page<Project> page, Project project,
			Map<String, Object> paramMap) {
		DetachedCriteria dc = super.createBaseCriteria(page, projectDao,
				project);
		if (StringUtils.isNotBlank(project.getProjectNo())) {
			dc.add(Restrictions.like("projectNo", "%" + project.getProjectNo()
					+ "%"));
		}
		if (StringUtils.isNotEmpty(project.getProjectName())) {
			dc.add(Restrictions.like("projectName",
					"%" + project.getProjectName() + "%"));
		}
		if (StringUtils.isNotEmpty(project.getLevel())) {
			dc.add(Restrictions.like("level",
					"%" + project.getLevel() + "%"));
		}
		Date beginDate = DateUtils.parseDate(paramMap.get("beginDate"));
		Date endDate = DateUtils.parseDate(paramMap.get("endDate"));
		if (beginDate != null && endDate != null) {
			dc.add(Restrictions.or(Restrictions.and(
					Restrictions.between("startDate", beginDate, endDate),
					Restrictions.between("endDate", beginDate, endDate)),
					Restrictions.or(Restrictions.isNull("startDate"),
							Restrictions.isNull("endDate"))));
		}
		if (project.getStatus() != null) {
			dc.add(Restrictions.eq("status", project.getStatus()));
		}
		return projectDao.find(page, dc);
	}

	@Transactional(readOnly = false)
	public void complete(Long id, Map<String, Object> variables)
			throws ParseException {
		Project project = projectDao.findOne(id);
		if (StringUtils.isNotEmpty((String) variables.get("projectNo"))) {
			project.setProjectNo((String) variables.get("projectNo"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("projectHospitalNo"))) {
			project.setProjectHospitalNo((String) variables.get("projectHospitalNo"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("approvalOrg"))) {
			project.setApprovalOrg((String) variables.get("approvalOrg"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("xb_fee"))) {
			project.setXb_fee((String) variables.get("xb_fee"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("sd_fee"))) {
			project.setSd_fee((String) variables.get("sd_fee"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("pt_fee"))) {
			project.setPt_fee((String) variables.get("pt_fee"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("level"))) {
			project.setLevel((String) variables.get("level"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("auditDate"))) {
			project.setAuditDate((String) variables.get("auditDate"));
		}		
		if(StringUtils.isNotEmpty((String) variables.get("weight"))){
			project.setWeight((String) variables.get("weight"));
		}
		String startDate = (String) variables.get("startDate");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (startDate != null && startDate.trim().length() != 0) {
			project.setStartDate(sdf.parse(startDate));
		}
		String endDate = (String) variables.get("endDate");
		if (startDate != null && startDate.trim().length() != 0) {
			project.setEndDate(sdf.parse(endDate));
		}
		if (((Boolean) variables.get("pass") != null)
				&& ((Boolean) variables.get("pass")).equals(false)) {
			project.setStatus(ProjectStatus.CREATE);
		} else if (((Boolean) variables.get("editexpense") != null)) {
		} else {
			project.setStatus(project.getStatus().next());
		}
		if (((Boolean) variables.get("lxSuccess") != null)
				&& ((Boolean) variables.get("lxSuccess")).equals(true)) {
			project.setDelFlag(Project.DEL_FLAG_AUDIT);
		}
		if (StringUtils.isNotEmpty((String) variables.get("remarks"))) {
			project.setRemarks(project.getRemarks() + '\n'
					+ (String) variables.get("remarks"));
		}
		if (StringUtils.isNotEmpty((String) variables.get("processStatus"))) {
			project.setProcessStatus((String) variables.get("processStatus"));
		}
		projectDao.save(project);
		if (((Boolean) variables.get("pass") != null)) {
			for (ProjectToUser ptu : project.getProjectToUser()) {
				projectToUserDao.deleteById(ptu.getId());
			}
		}

	}

	@Transactional(readOnly = false)
	public Project close(Long id) {
		Project project = projectDao.findOne(id);
		project.setStatus(ProjectStatus.FINISH);
		projectDao.save(project);
		return project;
	}

	@Transactional(readOnly = false)
	public void saveProject(Project project) {
		projectDao.clear();
		projectDao.save(project);
	}

	public Project getProjectByProjectName(String projectName) {
		return projectDao.findByProjectName(projectName);
	}

	public Project findOne(Long id) {
		projectDao.flush();
		Project project = (Project) super.findOne(id);
		return project;
	}

	public void refresh() {
		projectDao.flush();
	}

	public List<Project> findForWeightBelong(Long userId, String year) {
		DetachedCriteria dc = super.createDCForWeightBelongWithAuditDate(
				userId, year);
		return projectDao.find(dc);
	}

	public List<Project> findForAchieve(Long userId, String year) {
		DetachedCriteria dc = super.createDCForAchieveWithAuditDate(year);
		dc.add(Restrictions.or(
				Restrictions.eq("author1", String.valueOf(userId)),
				Restrictions.eq("author2", String.valueOf(userId)),
				Restrictions.eq("author3", String.valueOf(userId)),
				Restrictions.eq("weightBelong", userId)));
		return projectDao.find(dc);
	}

	public List<Project> findForAchieve(Long userId) {
		DetachedCriteria dc = super.createDCForAchieve();
		dc.add(Restrictions.or(
				Restrictions.eq("author1", String.valueOf(userId)),
				Restrictions.eq("author2", String.valueOf(userId)),
				Restrictions.eq("author3", String.valueOf(userId)),
				Restrictions.eq("weightBelong", userId)));
		return projectDao.find(dc);
	}

	public List<Project> findForDept(Long userId, String year) {
		DetachedCriteria dc = super.createDCForDeptWithAuditDate(userId, year);
		return projectDao.find(dc);
	}
	
	@Transactional(readOnly = false)
	public void updateSyfee(Long id, String sy_fee) {
		projectDao.flush();
		Double result=Double.valueOf(findOne(id).getSy_fee())+ Double.valueOf(sy_fee);	
		projectDao.updateSyfee(id, String.valueOf(result));
	}

	@Transactional(readOnly = false)
	public void updateProjectfee(Long id, String xb_fee,String pt_fee, String sd_fee) {
		projectDao.flush();
		projectDao.updateProjectfee(id, xb_fee, pt_fee, sd_fee);
	}
	
	@Transactional(readOnly = false)
	public void editProject(Project reward) {
		projectDao.clear();
		projectDao.save(reward);
	}
}
