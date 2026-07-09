package com.javaee.dao;

import java.util.List;

import com.javaee.po.Major;

public interface MajorDao {
	public Major findMajorById(int id);
	public List<Major> findMajors();
	public List<Major> findMajorsByDepartmentId(int departmentId);
	public int insertMajor(Major Major);
	public int updateMajor(Major Major);
	public int deleteMajor(int id);
}
