package com.ndtl.yyky.modules.oa.web.model;

import java.io.Serializable;

import com.ndtl.yyky.modules.sys.entity.User;

public class UserSelectModel implements Serializable {

	private static final long serialVersionUID = -6777274942648655612L;
	 private String name;
	 private String officeName;
	 private Long id;
	 private String no;

	public UserSelectModel() {
	}

	public UserSelectModel(User user) {
		 this.name = user.getName();
		 this.officeName = user.getOffice().getName();
		 this.id = user.getId();
		 this.no = user.getNo();
	}

	 public String getName() {
	 return name;
	 }
	
	 public void setName(String name) {
	 this.name = name;
	 }
	
	 public String getOfficeName() {
	 return officeName;
	 }
	
	 public void setOfficeName(String officeName) {
	 this.officeName = officeName;
	 }
	
	 public String getNo() {
	 return no;
	 }
	
	 public void setNo(String no) {
	 this.no = no;
	 }
	
	 public Long getId() {
	 return id;
	 }
	
	 public void setId(Long id) {
	 this.id = id;
	 }

}
