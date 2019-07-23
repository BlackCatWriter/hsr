package com.ndtl.yyky.modules.oa.entity.enums;

public enum ProjectStatus {

	CREATE("未审核"), AUDIT("审核中"), APPROVAL("立项审核"), CLOSE("立项完成"),FINISH("项目完结");

	ProjectStatus(String displayName) {
		this.displayName = displayName;
	}

	private String displayName;

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getLabel() {
		return this.toString();
	}

	public ProjectStatus next() {
		if (this.equals(CREATE)) {
			return AUDIT;
		} else if(this.equals(AUDIT)) {
			return APPROVAL;
		}else if(this.equals(APPROVAL)){
			return CLOSE;
		}else{
			return FINISH;
		}
	}

	public boolean isApproval() {
		if (this.equals(FINISH) || this.equals(CLOSE)) {
			return true;
		}
		return false;
	}

	public static ProjectStatus[] getApprovalStatus() {
		ProjectStatus[] result = { FINISH, CLOSE };
		return result;
	}
}
