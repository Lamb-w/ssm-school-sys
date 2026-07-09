package com.javaee.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaee.dao.MajorDao;
import com.javaee.po.Major;
import com.javaee.service.MajorService;
@Service
public class MajorServiceImpl implements MajorService {

	@Autowired
	private MajorDao majorDao;
	
	@Override
	public Major findMajorById(int id) {
		return majorDao.findMajorById(id);
	}

	@Override
	public List<Major> findMajors() {
		return majorDao.findMajors();
	}

	@Override
	public List<Major> findMajorsByDepartmentId(int departmentId) {
		return majorDao.findMajorsByDepartmentId(departmentId);
	}
	
	@Override
	public int insertMajor(Major Major) {
		return majorDao.insertMajor(Major);
	}

	@Override
	public int updateMajor(Major Major) {
		return majorDao.updateMajor(Major);
	}

	@Override
	public int deleteMajor(int id) {
		return majorDao.deleteMajor(id);
	}
}
