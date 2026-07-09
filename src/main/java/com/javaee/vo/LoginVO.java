package com.javaee.vo;

import java.io.Serializable;

public class LoginVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private String loginName, loginPwd, loginRole; // 用于登录时用的账号、密码、角色。根据不同角色，到相应的表中核对。

	public String getLoginName() {
		return loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}

	public String getLoginPwd() {
		return loginPwd;
	}

	public void setLoginPwd(String loginPwd) {
		this.loginPwd = loginPwd;
	}

	public String getLoginRole() {
		return loginRole;
	}

	public void setLoginRole(String loginRole) {
		this.loginRole = loginRole;
	}
	
}
