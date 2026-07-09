package com.javaee.service;

import com.javaee.po.Administrator;
import com.javaee.vo.ChangePwdVO;
import com.javaee.vo.LoginVO;

public interface AdministratorService {
	public Administrator findAdministratorById(int id);
	public Administrator findAdministratorByLogin(LoginVO loginVO);
	public int updateAdminPwd(ChangePwdVO changePwdVO);
}
