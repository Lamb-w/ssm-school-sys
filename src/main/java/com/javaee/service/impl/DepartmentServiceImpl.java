package com.javaee.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaee.dao.DepartmentDao;
import com.javaee.po.Department;
import com.javaee.service.DepartmentService;
import com.javaee.vo.DepartmentWithMajorCountVO;
@Service
public class DepartmentServiceImpl implements DepartmentService {

	@Autowired
	private DepartmentDao departmentDao;
	
	@Override
	public Department findDepartmentById(int id) {
		return departmentDao.findDepartmentById(id);
	}

	@Override
	public List<Department> findDepartments() {
		return departmentDao.findDepartments();
	}
	
	public List<DepartmentWithMajorCountVO> findDepartmentsWithMajorCount(){
		return departmentDao.findDepartmentsWithMajorCount();
	}
	@Override
	public int insertDepartment(Department department) {
		return departmentDao.insertDepartment(department);
	}

	@Override
	public int updateDepartment(Department department) {
		return departmentDao.updateDepartment(department);
	}

	@Override
	public int deleteDepartment(int id) {
		return departmentDao.deleteDepartment(id);
	}

}
