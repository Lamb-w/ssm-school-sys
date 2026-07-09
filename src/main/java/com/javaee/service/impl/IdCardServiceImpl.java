package com.javaee.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaee.dao.IdCardDao;
import com.javaee.po.IdCard;
import com.javaee.service.IdCardService;
import com.javaee.vo.FieldExistValidVO;
@Service
public class IdCardServiceImpl implements IdCardService {

	@Autowired
	private IdCardDao idCardDao;
	
	@Override
	public IdCard findIdCardById(int id) {
		return idCardDao.findIdCardById(id);
	}
	public int getSameCount(FieldExistValidVO fieldExistValidVO) {// 添加时查重
		return idCardDao.getSameCount(fieldExistValidVO);
	}
	public int getOtherSameCount(FieldExistValidVO fieldExistValidVO) { //修改时查重
		return idCardDao.getOtherSameCount(fieldExistValidVO);
	}

	@Override
	public int insertIdCard(IdCard idCard) {
		return idCardDao.insertIdCard(idCard);
	}

	@Override
	public int deleteIdCard(int id) {
		return idCardDao.deleteIdCard(id);
	}

	@Override
	public int updateIdCard(IdCard idCard) {
		return idCardDao.updateIdCard(idCard);
	}



}
