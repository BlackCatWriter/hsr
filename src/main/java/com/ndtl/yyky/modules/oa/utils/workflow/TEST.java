package com.ndtl.yyky.modules.oa.utils.workflow;

import java.util.HashMap;
import java.util.Map;

public class TEST {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String i="true|1||";
		String[] is=i.split("\\|");
		/*for(String ii:is){
			System.out.println(ii+";");
		}*/
		Map map = new HashMap<>();
		double a = 1.23;
		double b = 0.12;
		System.out.println(a-b);
	}

}
