package com.ndtl.yyky.common.utils.excel.fieldtype;

import com.ndtl.yyky.modules.sys.entity.Office;
import com.ndtl.yyky.modules.sys.utils.UserUtils;

/**
 * 字段类型转换
 */
public class OfficeType {

	/**
	 * 获取对象值（导入）
	 */
	public static Office getValue(String val) {
		for (Office e : UserUtils.getOfficeList()) {
			if (val.equals(e.getName())) {
				return e;
			}
		}
		return null;
	}

	/**
	 * 设置对象值（导出）
	 */
	public static String setValue(Object val) {
		if (val != null && ((Office) val).getName() != null) {
			return ((Office) val).getName();
		}
		return "";
	}
}
