/**
 * Copyright &copy; 2012-2014 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.ndtl.yyky.common.utils.excel.fieldtype;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.ndtl.yyky.common.utils.SpringContextHolder;
import com.ndtl.yyky.modules.sys.dao.UserDao;
import com.ndtl.yyky.modules.sys.entity.User;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 字段类型转换
 * 
 */
public class UserType {
	private static UserDao userDao = SpringContextHolder.getBean(UserDao.class);

	/**
	 * 获取对象值（导入）
	 */
	public static Object getValue(String val) {
		String id = "";
		if (val != null && val.trim().length() != 0) {
			Pattern pattern = Pattern.compile("(?<=\\()[^\\)]+");
			Matcher matcher = pattern.matcher(val);
			while (matcher.find()) {
				String userNo = matcher.group();
				User user = userDao.findUserByNO(userNo);
				if (user != null) {
					id += user.getId();
					id += ",";
				}
			}
			if (id.trim().endsWith(",")) {
				id = id.trim().substring(0, id.trim().lastIndexOf(","));
			}
		}
		return id;
	}

	/**
	 * 设置对象值（导出）
	 */
	public static String setValue(Object val) {
		return UserUtils.getDisplayNameForUserList((String) val);
	}
}
