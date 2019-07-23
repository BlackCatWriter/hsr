package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Component;

import com.ndtl.yyky.common.persistence.BaseDao;
import com.ndtl.yyky.common.persistence.BaseDaoImpl;
import com.ndtl.yyky.modules.oa.entity.Patent;

public interface PatentDao extends PatentDaoCustom, BaseOADao<Patent> {

	@Modifying
	@Query("update Patent set delFlag='" + Patent.DEL_FLAG_DELETE
			+ "' where id = ?1")
	public int deleteById(Long id);

	@Override
	@Modifying
	@Query("update Patent set processInstanceId=?2 where id = ?1")
	public int updateProcessInstanceId(Long id, String processInstanceId);

	@Query("from Patent where title = ?1 ")
	public Patent findByPatentName(String thesisName);

	@Query("from Patent where createBy.id = ?1 and delFlag='"
			+ Patent.DEL_FLAG_NORMAL + "'")
	public List<Patent> findUnfinished(Long id);
}

interface PatentDaoCustom extends BaseDao<Patent> {

}

@Component
class PatentDaoImpl extends BaseDaoImpl<Patent> implements PatentDaoCustom {

}
