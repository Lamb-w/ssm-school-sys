package com.javaee.po;

import java.io.Serializable;

public class Major implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int id;
	private String name;
	// private int departmentId;  // 外键：参照了Department表的主键id   为便于结果集的封装，实体类中常将外键字段写成对应的实体用作类的属性
	private Department department;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Department getDepartment() {
		return department;
	}
	public void setDepartment(Department department) {
		this.department = department;
	}
}
