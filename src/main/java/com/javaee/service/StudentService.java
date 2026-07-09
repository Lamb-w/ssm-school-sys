package com.javaee.service;

import java.util.List;
import java.util.Map;

import com.javaee.po.Student;
import com.javaee.utils.PageBean;
import com.javaee.vo.ChangePwdVO;
import com.javaee.vo.FieldExistValidVO;
import com.javaee.vo.LoginVO;

public interface StudentService {

	public Student findStudentByLogin(LoginVO loginVO);
	public int getTotalOfStudents();
	public Student findStudentById(int id);

	// 带查询条件的分页	
	public PageBean<Student> findStudentsByConditionPage(Map<String, Object> queryConditionMap);
	
	public int getSameCount(FieldExistValidVO fieldExistValidVO); // 添加时查重
	public int getOtherSameCount(FieldExistValidVO fieldExistValidVO); // 修改时 查重
	public int insertStudent(Student student);
	public int deleteStudent(int id);
	public int updateStudent(Student student);
	public int updateStudentPwd(ChangePwdVO changePwdVO);
}
