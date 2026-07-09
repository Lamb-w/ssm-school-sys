package com.javaee.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaee.dao.AdministratorDao;
import com.javaee.po.Administrator;
import com.javaee.service.AdministratorService;
import com.javaee.vo.ChangePwdVO;
import com.javaee.vo.LoginVO;

@Service  // @Service 注解一定是加在服务层实现类的外面。
public class AdministratorServiceImpl implements AdministratorService {

	@Autowired
	private AdministratorDao administratorDao;
	@Override
	public Administrator findAdministratorById(int id) {
		
		return administratorDao.findAdministratorById(id); // 由Service层调用Dao层
	}

	@Override
	public Administrator findAdministratorByLogin(LoginVO loginVO) {
		
		return administratorDao.findAdministratorByLogin(loginVO);
	}

	@Override
	public int updateAdminPwd(ChangePwdVO changePwdVO) {
		
		return administratorDao.updateAdminPwd(changePwdVO);
	}




	

}
