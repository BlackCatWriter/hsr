package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Achievement;
import com.ndtl.yyky.modules.oa.entity.Book;
import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Patent;
import com.ndtl.yyky.modules.oa.entity.Project;
import com.ndtl.yyky.modules.oa.entity.Reward;
import com.ndtl.yyky.modules.oa.entity.Thesis;

/**
 * 经费DAO接口
 * 
 */
public interface ProjectDao extends ProjectDaoCustom, BaseOADao<Project> {

	@Modifying
	@Query("update Project set delFlag='" + Project.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Query("from Project where createBy.id = ?1 and delFlag='"
			+ Project.DEL_FLAG_NORMAL + "'")
	public List<Project> findUnfinished(Long id);

	@Modifying
	@Query("update Project set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Project where projectName = ?1 and delFlag != '"
			+ Project.DEL_FLAG_DELETE + "'")
	public Project findByProjectName(String projectName);

	@Query("from Project where status in ('CLOSE','FINISH')")
	public List<Project> findApprovalProjects();

	@Query("from Project where status in ('CLOSE','FINISH') and weightBelong = ?1")
	public List<Project> findOwnedApprovalProjects(Long id);

	@Query("from Thesis where project.id = ?1")
	public List<Thesis> findThesisForProject(Long id);

	@Query("from Achievement where project.id = ?1 ")
	public List<Achievement> findAchievementForProject(Long id);
	
	@Query("from Reward where project.id = ?1 ")
	public List<Reward> findRewardForProject(Long id);
	
	@Query("from Book where project.id = ?1 ")
	public List<Book> findBookForProject(Long id);
	
	@Query("from Patent where project.id = ?1 ")
	public List<Patent> findPatentForProject(Long id);

	@Query("from Expense where project.id = ?1")
	public List<Expense> findExpenseForProject(Long id);
	
	@Query("select id from Project where projectNo LIKE ?1 group by id")
	public List<Long> findIdsByProjectNo(String likeId);
	
	@Modifying
	@Query("update Project set sy_fee = ?2 where id = ?1")
	public int updateSyfee(Long id, String sy_fee);

	@Query("update Project set xb_fee = ?2,pt_fee = ?3,sd_fee = sd_fee+?4 where id = ?1")
	public int updateProjectfee(Long id, String xb_fee,String pt_fee, String sd_fee);
}

/**
 * DAO自定义接口
 * 
 */
interface ProjectDaoCustom extends BaseDao<Project> {

}

/**
 * DAO自定义接口实现
 * 
 */
@Component
class ProjectDaoImpl extends BaseDaoImpl<Project> implements ProjectDaoCustom {

}
