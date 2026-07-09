package com.javaee.service;

import com.javaee.po.IdCard;
import com.javaee.vo.FieldExistValidVO;

public interface IdCardService {
	public IdCard findIdCardById(int id);
	public int getSameCount(FieldExistValidVO fieldExistValidVO); // 添加时查重
	public int getOtherSameCount(FieldExistValidVO fieldExistValidVO); //修改时查重
	public int insertIdCard(IdCard idCard);
	public int deleteIdCard(int id);
	public int updateIdCard(IdCard idCard);
}
