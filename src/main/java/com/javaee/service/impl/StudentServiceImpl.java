package com.javaee.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.javaee.vo.ChangePwdVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaee.dao.StudentDao;
import com.javaee.po.Student;
import com.javaee.service.StudentService;
import com.javaee.utils.PageBean;
import com.javaee.vo.FieldExistValidVO;
import com.javaee.vo.LoginVO;
@Service
public class StudentServiceImpl implements StudentService {

	@Autowired
	private StudentDao studentDao;

	public Student findStudentByLogin(LoginVO loginVO) {
		return studentDao.findStudentByLogin(loginVO);
	}
	public int getTotalOfStudents() {
		return studentDao.getTotalOfStudents();
	}
	@Override
	public Student findStudentById(int id) {
		return studentDao.findStudentById(id);
	}

	// 带查询条件的分页查询
	public PageBean<Student> findStudentsByConditionPage(Map<String, Object> queryConditionMap){ // Student student, int currentPage, int pageSize
		PageBean<Student> pageBean = new PageBean<Student>();
		int currentPage = (int)queryConditionMap.get("currentPage"), pageSize = (int) queryConditionMap.get("size");
        
        //每页显示的数据
        //int pageSize=2; // 固定，不太好。有的记录在不同情景模块中，每页允许显示的最大记录数很可能不同。
        pageBean.setPageSize(pageSize);
        //封装总记录数
        int totalCount = studentDao.getStudentsCountByConditionPage(queryConditionMap);// 将来要考虑分页显示出模糊查询的结果集
        //System.out.println("总记录数："+totalCount);
        pageBean.setTotalCount(totalCount);
        if(totalCount>0) {
            //封装总页数
            double tc = totalCount;
            Double num =Math.ceil(tc/pageSize);//向上取整  28/10 = 2.8 最终是3
            int totalPage = num.intValue();
            pageBean.setTotalPage(totalPage);
            
            //封装当前页数  (要注意对删除操作后又返回分页页面时对当前页currentPage的影响，即拉回最新的[1, totalPage]。这才是合法的。)
            if(totalPage <= 0) {
            	currentPage = 1;
            } else {
    	        if(currentPage<1)
    	        	currentPage=1;
    	        else if(currentPage > totalPage) {
    	        	currentPage=totalPage;
    	        }        	
            }
            pageBean.setCurrPage(currentPage);        
            queryConditionMap.put("start", (currentPage - 1) * pageSize);
            List<Student> lists = studentDao.findStudentsByConditionPage(queryConditionMap);
            pageBean.setLists(lists);        	
        } else{
        	pageBean.setLists(null); 
        }
        return pageBean;		
	}	
	
	public int getSameCount(FieldExistValidVO fieldExistValidVO) {// 添加时查重
		return studentDao.getSameCount(fieldExistValidVO);
	} 
	public int getOtherSameCount(FieldExistValidVO fieldExistValidVO) { // 修改时 查重
		return studentDao.getOtherSameCount(fieldExistValidVO);				
	}
	
	@Override
	public int insertStudent(Student student) {
		return studentDao.insertStudent(student);
	}

	@Override
	public int deleteStudent(int id) {
		return studentDao.deleteStudent(id);
	}

	@Override
	public int updateStudent(Student student) {
		return studentDao.updateStudent(student);
	}

	@Override
	public int updateStudentPwd(ChangePwdVO changePwdVO) {
		return studentDao.updateStudentPwd(changePwdVO);
	}
}
