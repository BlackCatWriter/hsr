package com.ndtl.yyky.modules.sys.utils;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.UnavailableSecurityManagerException;
import org.apache.shiro.subject.Subject;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.google.common.collect.Maps;
import com.ndtl.yyky.common.service.BaseService;
import com.ndtl.yyky.common.utils.SpringContextHolder;
import com.ndtl.yyky.modules.sys.dao.AreaDao;
import com.ndtl.yyky.modules.sys.dao.MenuDao;
import com.ndtl.yyky.modules.sys.dao.OfficeDao;
import com.ndtl.yyky.modules.sys.dao.UserDao;
import com.ndtl.yyky.modules.sys.entity.Area;
import com.ndtl.yyky.modules.sys.entity.Menu;
import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.security.SystemAuthorizingRealm.Principal;

/**
 * 用户工具类
 */
public class UserUtils extends BaseService {

	private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);
	private static MenuDao menuDao = SpringContextHolder.getBean(MenuDao.class);
	private static AreaDao areaDao = SpringContextHolder.getBean(AreaDao.class);
	private static OfficeDao officeDao = SpringContextHolder
			.getBean(OfficeDao.class);

	public static final String CACHE_USER = "user";
	public static final String CACHE_USER_LIST = "userList";
	public static final String CACHE_MENU_LIST = "menuList";
	public static final String CACHE_AREA_LIST = "areaList";
	public static final String CACHE_OFFICE_LIST = "officeList";

	public static User getUser() {
		User user = (User) getCache(CACHE_USER);
		if (user == null) {
			Principal principal = (Principal) SecurityUtils.getSubject()
					.getPrincipal();
			if (principal != null) {
				user = userDao.findOne(principal.getId());
				putCache(CACHE_USER, user);
			}
		}
		if (user == null) {
			user = new User();
			SecurityUtils.getSubject().logout();
		}
		return user;
	}

	public static User getUser(boolean isRefresh) {
		if (isRefresh) {
			removeCache(CACHE_USER);
		}
		return getUser();
	}

	public static List<Menu> getMenuList() {
		@SuppressWarnings("unchecked")
		List<Menu> menuList = (List<Menu>) getCache(CACHE_MENU_LIST);
		if (menuList == null) {
			User user = getUser();
			if (user.isAdmin()) {
				menuList = menuDao.findAllList();
			} else {
				menuList = menuDao.findByUserId(user.getId());
			}
			putCache(CACHE_MENU_LIST, menuList);
		}
		return menuList;
	}

	public static List<User> getUserList() {
		@SuppressWarnings("unchecked")
		List<User> userList = (List<User>) getCache(CACHE_USER_LIST);
		if (userList == null) {
			userList = userDao.findAllList();
			putCache(CACHE_USER_LIST, userList);
		}
		return userList;
	}

	public static Integer getUserAgeByUserId(String userId) {
		List<User> userList = (List<User>) getCache(CACHE_USER_LIST);
		if (userList == null) {
			userList = userDao.findAllList();
			putCache(CACHE_USER_LIST, userList);
		}
		for(User user : userList){
			if(StringUtils.equals(String.valueOf(user.getId()),userId)){
				return user.getAge();
			}
		}
		return -1;
	}


	public static List<Area> getAreaList() {
		@SuppressWarnings("unchecked")
		List<Area> areaList = (List<Area>) getCache(CACHE_AREA_LIST);
		if (areaList == null) {
			// User user = getUser();
			// if (user.isAdmin()){
			areaList = areaDao.findAllList();
			// }else{
			// areaList = areaDao.findAllChild(user.getArea().getId(),
			// "%,"+user.getArea().getId()+",%");
			// }
			putCache(CACHE_AREA_LIST, areaList);
		}
		return areaList;
	}

	public static List<Office> getOfficeList() {
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>) getCache(CACHE_OFFICE_LIST);
		if (officeList == null) {
			DetachedCriteria dc = officeDao.createDetachedCriteria();
			// User user = getUser();
			// dc.add(dataScopeFilter(user, dc.getAlias(), ""));
			dc.add(Restrictions.eq("delFlag", Office.DEL_FLAG_NORMAL));
			dc.addOrder(Order.asc("code"));
			officeList = officeDao.find(dc);
			putCache(CACHE_OFFICE_LIST, officeList);
		}
		return officeList;
	}

	public static Office getOfficeByOffid(Long officeId) {
		@SuppressWarnings("unchecked")
		List<Office> officeList = (List<Office>) getCache(CACHE_OFFICE_LIST);
		if (officeList == null) {
			DetachedCriteria dc = officeDao.createDetachedCriteria();
			// User user = getUser();
			// dc.add(dataScopeFilter(user, dc.getAlias(), ""));
			dc.add(Restrictions.eq("delFlag", Office.DEL_FLAG_NORMAL));
			dc.addOrder(Order.asc("code"));
			officeList = officeDao.find(dc);
			putCache(CACHE_OFFICE_LIST, officeList);
		}
		for(Office office : officeList){
			if(office.getId() == officeId){
				return office;
			}
		}
		return new Office();
	}

	// ============== User Cache ==============

	public static Object getCache(String key) {
		return getCache(key, null);
	}

	public static Object getCache(String key, Object defaultValue) {
		Object obj = getCacheMap().get(key);
		return obj == null ? defaultValue : obj;
	}

	public static void putCache(String key, Object value) {
		getCacheMap().put(key, value);
	}

	public static void removeCache(String key) {
		getCacheMap().remove(key);
	}

	public static Map<String, Object> getCacheMap() {
		Map<String, Object> map = Maps.newHashMap();
		try {
			Subject subject = SecurityUtils.getSubject();
			Principal principal = (Principal) subject.getPrincipal();
			return principal != null ? principal.getCacheMap() : map;
		} catch (UnavailableSecurityManagerException e) {
			return map;
		}
	}

	public static String getDisplayNameForUserList(String userIds) {
		if (StringUtils.isNotEmpty(userIds)) {
			String displayName = "";
			String[] str = userIds.split(",");
			if (str.length == 1) {
				displayName = getUserDisplayName(str[0]);
			} else {
				for (String id : str) {
					displayName += getUserDisplayName(id);
					displayName += ",";
				}
			}
			if (displayName.endsWith(",")) {
				displayName = displayName.substring(0,
						displayName.lastIndexOf(","));
			}
			return displayName;
		}
		return "";

	}

	public static String getUserDisplayName(String userId) {
		if (StringUtils.isBlank(userId)) {
			return "";
		}
		if((Object)userId instanceof Long){
			return getUserDisplayName(Long.valueOf(userId));
		}
		return userId;
	}

	public static String getUserDisplayName(Long userId) {
		if (userId == null) {
			return "";
		}
		User user = userDao.findOne(userId);
		String displayName = user.getName() + "(" + user.getNo() + ")--"
				+ user.getOffice().getName();
		return displayName;
	}

	public static Boolean isManager() {
		User user = getUser();
		return isManager(user);
	}

	public static Boolean isKJDept() {
		User user = getUser();
		if (user.getRoleIdList().contains(9L)) {
			return true;
		}
		return false;
	}

	public static Boolean isDeptLeader() {
		User user = getUser();
		return isDeptLeader(user);
	}

	public static Boolean isHosLeader() {
		User user = getUser();
		if (user.getRoleIdList().contains(10L)) {
			return true;
		}
		return false;
	}

	/**
	 * manager role is binded with DB
	 * 
	 * @param user
	 * @return
	 */
	public static boolean isManager(User user) {
		if (user.getRoleIdList().contains(1L)
				|| user.getRoleIdList().contains(9L)
				|| user.getRoleIdList().contains(10L)
				|| user.getRoleIdList().contains(12L)) {
			return true;
		}
		return false;
	}
	
	/**
	 * 除科主任之外的领导
	 * 
	 * @param user
	 * @return
	 */
	public static boolean isSysManager(User user) {
		if (user.getRoleIdList().contains(1L)
				|| user.getRoleIdList().contains(9L)
				|| user.getRoleIdList().contains(10L)) {
			return true;
		}
		return false;
	}

	public static boolean isDeptLeader(User user) {
		if (user.getRoleIdList().contains(12L)) {
			return true;
		}
		return false;
	}

	public static boolean isFinance(User user) {
		if (user.getRoleIdList().contains(11L)) {
			return true;
		}
		return false;
	}

	public static boolean isHosLeader(User user) {
		if (user.getRoleIdList().contains(10L)) {
			return true;
		}
		return false;
	}

	public static boolean isAdmin(User user) {
		if (user.getRoleIdList().contains(1L)) {
			return true;
		}
		return false;
	}
}
