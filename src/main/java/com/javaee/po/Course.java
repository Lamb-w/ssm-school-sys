package com.javaee.po;

import java.io.Serializable;

public class Course  implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private int id;
	private String cNo, name;
	private int credit, classHour;
	private String memo;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getcNo() {
		return cNo;
	}
	public void setcNo(String cNo) {
		this.cNo = cNo;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getCredit() {
		return credit;
	}
	public void setCredit(int credit) {
		this.credit = credit;
	}
	public int getClassHour() {
		return classHour;
	}
	public void setClassHour(int classHour) {
		this.classHour = classHour;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}	
}