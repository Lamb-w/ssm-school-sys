package com.javaee.dao;

import com.javaee.po.Administrator;
import com.javaee.vo.ChangePwdVO;
import com.javaee.vo.LoginVO;

public interface AdministratorDao {

	public Administrator findAdministratorById(int id);
	public Administrator findAdministratorByLogin(LoginVO loginVO);
	public int updateAdminPwd(ChangePwdVO changePwdVO);
}
