package com.javaee.dao;
import java.util.List;
import java.util.Map;

import com.javaee.po.Student;

import com.javaee.vo.ChangePwdVO;
import com.javaee.vo.FieldExistValidVO;
import com.javaee.vo.LoginVO;
/**
 * Customer接口文件
 */
public interface StudentDao {
	public Student findStudentByLogin(LoginVO loginVO);
	public int getTotalOfStudents();
	public Student findStudentById(int id); //Integer id 按教材这样写也可

	// 有查询条件的分页  2个方法
	public List<Student> findStudentsByConditionPage(Map<String,Object> map);
	public int getStudentsCountByConditionPage(Map<String,Object> map);
	
	public int getSameCount(FieldExistValidVO fieldExistValidVO); // 添加时查重
	public int getOtherSameCount(FieldExistValidVO fieldExistValidVO); // 修改时 查重
	public int insertStudent(Student student);
	public int deleteStudent(int id);
	public int updateStudent(Student student);
	public int updateStudentPwd(ChangePwdVO changePwdVO);
}
