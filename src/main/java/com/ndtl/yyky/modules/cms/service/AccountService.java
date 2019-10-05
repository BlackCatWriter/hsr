package com.ndtl.yyky.modules.cms.service;

import com.google.common.collect.Lists;
import com.ndtl.yyky.common.persistence.Page;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.common.utils.DateUtils;
import com.ndtl.yyky.modules.cms.dao.AccountDao;
import com.ndtl.yyky.modules.cms.entity.Account;
import com.ndtl.yyky.modules.cms.entity.Article;
import com.ndtl.yyky.modules.cms.entity.Site;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.sys.utils.UserUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 费用填报Service
 * 
 */
@Service
@Transactional(readOnly = true)
public class AccountService extends BaseService {

	@Autowired
	private AccountDao accountDao;


	public Page<Account> findForCMS(Page<Account> page, Account account,Map<String, Object> paramMap) {
		DetachedCriteria dc = accountDao.createDetachedCriteria();
		if (account.getProject() != null&&account.getProject().getId()!= null) {
			dc.add(Restrictions.eq("project.id", account.getProject().getId()));
		}
		if(account.getProject()!=null&&StringUtils.isNotBlank(account.getProjectNo())){
			dc.createAlias("project", "project");
			dc.add(Restrictions.like("project.projectNo",  "%"+account.getProjectNo()+"%"));
		}
		dc.addOrder(Order.desc("id"));
		return accountDao.find(page, dc);
	}

	 public Page<Map> projectAccountByYear(Page<Map> page,Map<String, Object> paramMap) {

		StringBuilder ql = new StringBuilder();
		List<Object> ps = Lists.newArrayList();

		ql.append(" SELECT t.project_no,t.project_name,account.budget,expense.expend,(account.budget-expense.expend) as balance,expense.year as year FROM");
		ql.append(" oa_project t LEFT JOIN (SELECT (a.xb_fee+a.pt_fee) as budget,a.project_id FROM oa_expense_account a GROUP BY a.project_id )");
		ql.append(" account ON account.project_id = t.id LEFT JOIN (SELECT SUM(b.amount) AS expend,b.project_id,DATE_FORMAT(b.update_date,'%Y') as year FROM oa_expense b");
		ql.append(" WHERE b.del_flag LIKE 2 GROUP BY b.project_id,DATE_FORMAT(b.update_date,'%Y') ) expense ON expense.project_id = t.id where t.del_flag LIKE 2");

		String project_no = (String)paramMap.get("project_no");
		if(StringUtils.isNotBlank(project_no)){
			ql.append(" AND project_no like ?");
			ps.add("%"+project_no+"%");
		}
		String project_name = (String)paramMap.get("project_name");
		if(StringUtils.isNotBlank(project_name)){
			ql.append(" AND project_name like ?");
			ps.add("%"+project_name+"%");
		}
		String year = (String)paramMap.get("year");
		if(StringUtils.isNotBlank(year)){
			ql.append(" AND year = ?");
			ps.add(year);
		}
		Page<Map> list = accountDao.findBySql(page,ql.toString(), Map.class, ps.toArray());
		return list;
	}

	public Page<Map> subjectRewardDetail(Page<Map> page,Map<String, Object> paramMap) {

		StringBuilder ql = new StringBuilder();
		List<Object> ps = Lists.newArrayList();

		ql.append(" select * from (select u.`name`,o.name as dept_name,p.project_name,t.jl,t.title,t.update_date from oa_thesis t ");
		ql.append(" INNER JOIN sys_user u ON t.co_author = u.id LEFT JOIN oa_project p ON t.project_id = p.id INNER JOIN sys_office o ON t.office_id = o.id");
		ql.append(" where t.del_flag = 2 UNION ALL select u.`name`,o.name as dept_name,p.project_name,t.jl,t.title,t.update_date from oa_patent t");
		ql.append(" INNER JOIN sys_user u ON t.author1 = u.id LEFT JOIN oa_project p ON t.project_id = p.id INNER JOIN sys_office o ON t.office_id = o.id");
		ql.append(" where t.del_flag = 2 UNION ALL select u.`name`,o.name as dept_name,p.project_name,t.jl,t.title,t.update_date from oa_book t ");

		ql.append(" INNER JOIN sys_user u ON t.author1 = u.id LEFT JOIN oa_project p ON t.project_id = p.id INNER JOIN sys_office o ON t.office_id = o.id");
		ql.append(" where t.del_flag = 2 UNION ALL select u.`name`,o.name as dept_name,p.project_name,t.xb_fee as jl,t.reward_name as title,t.update_date from oa_reward t ");
		ql.append(" INNER JOIN sys_user u ON t.author1 = u.id LEFT JOIN oa_project p ON t.project_id = p.id INNER JOIN sys_office o ON t.office_id = o.id ");
		ql.append(" where t.del_flag = 2 )this where 1=1");

		String project_name = (String)paramMap.get("project_name");
		if(StringUtils.isNotBlank(project_name)){
			ql.append(" AND this.project_name like ?");
			ps.add("%"+project_name+"%");
		}

		String name = (String)paramMap.get("name");
		if(StringUtils.isNotBlank(name)){
			ql.append(" AND this.`name` like ?");
			ps.add("%"+name+"%");
		}

		String title = (String)paramMap.get("title");
		if(StringUtils.isNotBlank(title)){
			ql.append(" AND this.title like ?");
			ps.add("%"+title+"%");
		}

		Page<Map> list = accountDao.findBySql(page,ql.toString(), Map.class, ps.toArray());
		return list;
	}

	public Page<Map> expertReviewDetail(Page<Map> page,Map<String, Object> paramMap) {

		StringBuilder ql = new StringBuilder();
		List<Object> ps = Lists.newArrayList();

		ql.append(" select o.name as dept_name,u.`name`,a.project_name,t.creativity,t.advancement,t.scientificity,t.feasibility,t.practicability,t.update_date,t.remarks from oa_project_user t ");
		ql.append(" left join oa_project a on t.project_id=a.id INNER JOIN sys_user u ON t.user_id = u.id INNER JOIN sys_office o ON u.office_id = o.id where 1=1 ");

		String project_name = (String)paramMap.get("project_name");
		if(StringUtils.isNotBlank(project_name)){
			ql.append(" AND project_name like ?");
			ps.add("%"+project_name+"%");
		}
		String name = (String)paramMap.get("name");
		if(StringUtils.isNotBlank(name)){
			ql.append(" AND u.`name` like ?");
			ps.add("%"+name+"%");
		}

		Page<Map> list = accountDao.findBySql(page,ql.toString(), Map.class, ps.toArray());
		return list;
	}

	public Page<Map> otherAccountDetail(Page<Map> page,Map<String, Object> paramMap) {

		StringBuilder ql = new StringBuilder();
		List<Object> ps = Lists.newArrayList();

		ql.append(" select * from ( select u.`name`,o.`name` as dept_name,a.academic_name as topic,t.bx_fee,t.update_date,t.remarks from oa_academiccost t");
		ql.append(" inner join oa_academic a on t.academic_id = a.id INNER JOIN sys_user u ON t.create_by = u.id INNER JOIN sys_office o ON a.office_id = o.id where t.del_flag = 2");
		ql.append(" union ALL select u.`name`,o.`name` as dept_name,b.advstudy_direction as topic,t.bx_fee,t.update_date,t.remarks from oa_academiccost t");
		ql.append(" inner join oa_advstudy b on t.advstudy_id = b.id INNER JOIN sys_user u ON t.create_by = u.id INNER JOIN sys_office o ON b.office_id = o.id where t.del_flag = 2 ) this where 1=1 ");

		String name = (String)paramMap.get("name");
		if(StringUtils.isNotBlank(name)){
			ql.append(" AND this.name like ?");
			ps.add("%"+name+"%");
		}
		String topic = (String)paramMap.get("topic");
		if(StringUtils.isNotBlank(topic)){
			ql.append(" AND this.topic like ?");
			ps.add("%"+topic+"%");
		}

		Page<Map> list = accountDao.findBySql(page,ql.toString(), Map.class, ps.toArray());
		return list;
	}

	@Transactional(readOnly = false)
	public void save(Account account) {
		account.setUpdateBy(UserUtils.getUser());
		account.setUpdateDate(new Date());
		accountDao.clear();
		accountDao.save(account);
	}

}
