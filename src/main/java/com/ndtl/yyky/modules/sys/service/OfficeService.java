package com.ndtl.yyky.modules.sys.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.modules.sys.dao.OfficeDao;
import com.ndtl.yyky.modules.sys.dao.UserDao;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 机构Service
 */
@Service
@Transactional(readOnly = true)
public class OfficeService extends BaseService {

	@Autowired
	private OfficeDao officeDao;

	@Autowired
	private UserDao userDao;

	public Office get(Long id) {
		return officeDao.findOne(id);
	}

	public List<Office> findAll() {
		return UserUtils.getOfficeList();
	}

	public List<User> findListWithUsers() {
		return officeDao.findListWithUsers();
		// return userDao.findBySql("select * from sys_user;");
		// // return (List<User>) userDao.findAll();
	}

	@Transactional(readOnly = false)
	public void save(Office office) {
		office.setParent(this.get(office.getParent().getId()));
		String oldParentIds = office.getParentIds(); // 获取修改前的parentIds，用于更新子节点的parentIds
		office.setParentIds(office.getParent().getParentIds()
				+ office.getParent().getId() + ",");
		officeDao.clear();
		officeDao.save(office);
		// 更新子节点 parentIds
		List<Office> list = officeDao.findByParentIdsLike("%," + office.getId()
				+ ",%");
		for (Office e : list) {
			e.setParentIds(e.getParentIds().replace(oldParentIds,
					office.getParentIds()));
		}
		officeDao.save(list);
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
	}

	@Transactional(readOnly = false)
	public void delete(Long id) {
		officeDao.deleteById(id, "%," + id + ",%");
		UserUtils.removeCache(UserUtils.CACHE_OFFICE_LIST);
	}
	
	public Office getOfficeByName(String name) {
		for(Office office: findAll()){
			if(office.getName().equals(name)){
				return office;
			}
		}
		return null;
	}

}
