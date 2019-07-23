package com.ndtl.yyky.common.config;

import java.io.UnsupportedEncodingException;
import java.util.Map;

import com.google.common.collect.Maps;
import com.ndtl.yyky.common.utils.PropertiesLoader;

/**
 * 全局配置类
 */
public class Global {

	/**
	 * 保存全局属性值
	 */
	private static Map<String, String> map = Maps.newHashMap();

	/**
	 * 属性文件加载对象
	 */
	private static PropertiesLoader propertiesLoader = new PropertiesLoader(
			"application.properties");

	/**
	 * 获取配置
	 */
	public static String getConfig(String key) {
		String value = map.get(key);
		if (value == null) {
			try {
				value = new String(propertiesLoader.getProperty(key).getBytes(
						"iso-8859-1"), "utf-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			map.put(key, value);
		}
		return value;
	}

	/**
	 * 获取管理端根路径
	 */
	public static String getAdminPath() {
		return getConfig("adminPath");
	}

	/**
	 * 获取前端根路径
	 */
	public static String getFrontPath() {
		return getConfig("frontPath");
	}

	/**
	 * 获取URL后缀
	 */
	public static String getUrlSuffix() {
		return getConfig("urlSuffix");
	}

	/**
	 * 是否是演示模式，演示模式下不能修改用户、角色、密码、菜单、授权
	 */
	public static Boolean isDemoMode() {
		String dm = getConfig("demoMode");
		return "true".equals(dm) || "1".equals(dm);
	}

	public static String getSavedFilePath() {
		return getConfig("savedFilePath");
	}

	public static String getUploadFilePath() {
		return getConfig("uploadFilePath");
	}

	public static String getProjectSN() {
		return getConfig("projectSN");
	}

}
