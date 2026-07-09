package com.javaee.vo;

import java.io.Serializable;

public class ChangePwdVO implements Serializable {
	private static final long serialVersionUID = 1L;
	// 在一个类中，只有两种成员：属性、方法。属性表示特征(它他们常是名词)，方法表示动作(常是动词)。
	// 一般都是希望PO(也叫POJO、Entity、Model)、VO包下的类都是常驻内存以降低频繁撤销、创建而产生的开销，解决方案就是：implements Serializable接口。
	
	private String userName, userPwd, userPwdNew; // 属性  为能实现准确绑定，表单输入元素的name属性值和这些属性值完全相同。否则无法绑定。

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserPwdNew() {
		return userPwdNew;
	}

	public void setUserPwdNew(String userPwdNew) {
		this.userPwdNew = userPwdNew;
	}
	
}
