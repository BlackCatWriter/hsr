package com.ndtl.yyky.modules.oa.web.model;

import java.io.Serializable;
import java.util.List;

import com.ndtl.yyky.modules.oa.entity.Expense;
import com.ndtl.yyky.modules.oa.entity.Project;

public class ExpenseModel implements Serializable {

	private static final long serialVersionUID = -5845332574727301026L;
	private Expense expense;
	private Double ptFee;
	private Double sdFee;
	private Project project;
	private boolean isExceed;
	private List<Expense> expenseList;
	private Double totalFee;
	private Double wholeFee;
	private Double usedFee;
	private Double applyFee;
	private Double remaindFee;

	public Expense getExpense() {
		return expense;
	}

	public void setExpense(Expense expense) {
		this.expense = expense;
	}

	public Double getPtFee() {
		return ptFee;
	}

	public void setPtFee(Double ptFee) {
		this.ptFee = ptFee;
	}

	public Double getSdFee() {
		return sdFee;
	}

	public void setSdFee(Double sdFee) {
		this.sdFee = sdFee;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public boolean isExceed() {
		return isExceed;
	}

	public void setExceed(boolean isExceed) {
		this.isExceed = isExceed;
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
		if (remaindFee < 0) {
			return 0D;
		}
		return remaindFee;
	}

	public void setRemaindFee(Double remaindFee) {
		this.remaindFee = remaindFee;
	}

	public List<Expense> getExpenseList() {
		return expenseList;
	}

	public void setExpenseList(List<Expense> expenseList) {
		this.expenseList = expenseList;
	}

	public Double getWholeFee() {
		return wholeFee;
	}

	public void setWholeFee(Double wholeFee) {
		this.wholeFee = wholeFee;
	}

}
