package com.javaee.po;

import java.io.Serializable;

public class Administrator implements Serializable { // po、vo包里的类因在多个层都可能被用到，所以希望这些类常驻内存，方便调用，定义类常实现Serializable接口。
	private static final long serialVersionUID = 1L;
	
	private int id;
	private String adminName, adminPwd;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getAdminName() {
		return adminName;
	}
	public void setAdminName(String adminName) {
		this.adminName = adminName;
	}
	public String getAdminPwd() {
		return adminPwd;
	}
	public void setAdminPwd(String adminPwd) {
		this.adminPwd = adminPwd;
	}
	
}
