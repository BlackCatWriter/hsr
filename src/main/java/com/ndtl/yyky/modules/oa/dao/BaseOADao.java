package com.ndtl.yyky.modules.oa.dao;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.NoRepositoryBean;

import com.ndtl.yyky.common.persistence.BaseDao;

@NoRepositoryBean
public interface BaseOADao<T> extends BaseDao<T>, CrudRepository<T, Long> {

	public int updateProcessInstanceId(Long id, String processInstanceId);

	public List<T> findUnfinished(Long id);

}
