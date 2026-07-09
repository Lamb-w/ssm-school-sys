package com.javaee.dao;

import java.util.List;

import com.javaee.po.Department;
import com.javaee.vo.DepartmentWithMajorCountVO;

public interface DepartmentDao {
	public Department findDepartmentById(int id);
	public List<Department> findDepartments();
	public List<DepartmentWithMajorCountVO> findDepartmentsWithMajorCount();
	public int insertDepartment(Department department);
	public int updateDepartment(Department department);
	public int deleteDepartment(int id);
	
	
}
