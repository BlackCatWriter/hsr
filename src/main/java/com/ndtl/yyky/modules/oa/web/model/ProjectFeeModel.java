package com.ndtl.yyky.modules.oa.web.model;

public class ProjectFeeModel {

	private Double totalFee;
	private Double usedFee;
	private Double applyFee;
	private Double remaindFee;

	public ProjectFeeModel(Double totalFee, Double usedFee, Double applyFee) {
		this.totalFee = totalFee;
		this.usedFee = usedFee;
		this.applyFee = applyFee;
		this.remaindFee = this.totalFee - this.usedFee;

	}

	public Double getTotalFee() {
		return totalFee;
	}

	public void setTotalFee(Double totalFee) {
		this.totalFee = totalFee;
	}

	public Double getUsedFee() {
		return usedFee;
	}

	public void setUsedFee(Double usedFee) {
		this.usedFee = usedFee;
	}

	public Double getApplyFee() {
		return applyFee;
	}

	public void setApplyFee(Double applyFee) {
		this.applyFee = applyFee;
	}

	public Double getRemaindFee() {
		return remaindFee;
	}

	public void setRemaindFee(Double remaindFee) {
		this.remaindFee = remaindFee;
	}

}
