package com.javaee.vo;

import java.io.Serializable;

import com.javaee.po.Department;

public class DepartmentWithMajorCountVO implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private Department department;// 2列 id name
	private int majorCount; // 每个系对应的专业个数
	public Department getDepartment() {
		return department;
	}
	public void setDepartment(Department department) {
		this.department = department;
	}
	public int getMajorCount() {
		return majorCount;
	}
	public void setMajorCount(int majorCount) {
		this.majorCount = majorCount;
	}
	
	
}
