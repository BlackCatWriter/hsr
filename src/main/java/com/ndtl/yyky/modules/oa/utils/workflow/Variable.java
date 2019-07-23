package com.ndtl.yyky.modules.oa.utils.workflow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.ConvertUtils;

import com.ndtl.yyky.common.utils.StringUtils;

public class Variable {

	private String keys;
	private String values;
	private String types;

	public String getKeys() {
		return keys;
	}

	public void setKeys(String keys) {
		this.keys = keys;
	}

	public String getValues() {
		return values;
	}

	public void setValues(String values) {
		this.values = values;
	}

	public String getTypes() {
		return types;
	}

	public void setTypes(String types) {
		this.types = types;
	}

	public Map<String, Object> getVariableMap() {
		Map<String, Object> vars = new HashMap<String, Object>();

		ConvertUtils.register(new DateConverter(), java.util.Date.class);

		if (StringUtils.isBlank(keys)) {
			return vars;
		}

		String[] arrayKey = keys.split("\\|");
		String[] arrayValue = values.split("\\|", -1);
		String[] arrayType = types.split("\\|");
		List<String> list = new ArrayList<String>();
		for (int i = 0; i < arrayValue.length; i++) {
			list.add(arrayValue[i]);
		}
		if (arrayValue.length < arrayKey.length) {
			list.add("");
		}
		String[] newArrayValue = list.toArray(new String[1]);
		for (int i = 0; i < arrayKey.length; i++) {
			String key = arrayKey[i];
			String value = newArrayValue[i].trim();
			String type = arrayType[i];

			Class<?> targetType = Enum.valueOf(PropertyType.class, type)
					.getValue();
			Object objectValue = ConvertUtils.convert(value, targetType);
			vars.put(key, objectValue);
		}
		return vars;
	}
}
