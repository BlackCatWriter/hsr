package com.ndtl.yyky.modules.oa.entity.base;

import java.util.Date;

import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonFormat;

@MappedSuperclass
public class OutsideStudy extends BaseOAEntity {

	private static final long serialVersionUID = 1L;

	private String hostUnit; // 主办单位
	private String place; // 外出地点
	private Date startDate; // 开始时间
	private Date endDate; // 结束时间

	public String getHostUnit() {
		return hostUnit;
	}

	public void setHostUnit(String hostUnit) {
		this.hostUnit = hostUnit;
	}

	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

}
