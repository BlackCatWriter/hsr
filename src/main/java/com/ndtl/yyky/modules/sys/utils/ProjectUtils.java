package com.ndtl.yyky.modules.sys.utils;

import java.util.Arrays;
import java.util.List;

import com.ndtl.yyky.modules.oa.entity.enums.ProjectStatus;

public class ProjectUtils {

	public static List<ProjectStatus> getProjectStatus(){
//		List<String> status=new ArrayList<String>();
//		for(ProjectStatus s:ProjectStatus.values()){
//			status.add(s.getDisplayName());
//		}
//		return status;
		return Arrays.asList(ProjectStatus.values());
	}
}
