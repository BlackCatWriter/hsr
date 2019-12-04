package com.ndtl.yyky.modules.oa.entity;

import com.ndtl.yyky.modules.oa.entity.base.ProjectRelatedItem;
import com.ndtl.yyky.modules.sys.entity.User;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.search.annotations.Analyze;
import org.hibernate.search.annotations.Field;
import org.hibernate.search.annotations.Index;
import org.hibernate.search.annotations.Store;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;
import java.util.Date;

@Entity
@Table(name = "oa_project_data")
@DynamicInsert
@DynamicUpdate
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProjectData extends ProjectRelatedItem {

	private static final long serialVersionUID = 1L;
	private String contentContract; // 合同
	private String contentProgress; // 进展
	private String contentSummary; // 总结

	// -- 临时属性 --//
	private Date createDateStart;
	private Date createDateEnd;

	public ProjectData() {
		super();
	}

	public ProjectData(Long id) {
		this();
		this.id = id;
	}

	@Transient
	public Date getCreateDateStart() {
		return createDateStart;
	}

	public void setCreateDateStart(Date createDateStart) {
		this.createDateStart = createDateStart;
	}

	@Transient
	public Date getCreateDateEnd() {
		return createDateEnd;
	}

	public void setCreateDateEnd(Date createDateEnd) {
		this.createDateEnd = createDateEnd;
	}

	@Field(index= Index.YES, analyze= Analyze.YES, store= Store.NO)
	public String getContentContract() {
		return contentContract;
	}

	public void setContentContract(String contentContract) {
		this.contentContract = contentContract;
	}

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)
	public String getContentProgress() {
		return contentProgress;
	}

	public void setContentProgress(String contentProgress) {
		this.contentProgress = contentProgress;
	}

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)
	public String getContentSummary() {
		return contentSummary;
	}

	public void setContentSummary(String contentSummary) {
		this.contentSummary = contentSummary;
	}

	@Transient
	public User getUser() {
		return createBy;
	}

	public void setUser(User user) {
		this.createBy = user;
	}

	@Transient
	public String getProjectNo() {
		if(project!=null){
		return project.getProjectNo();
		}
		return null;
	}

}
