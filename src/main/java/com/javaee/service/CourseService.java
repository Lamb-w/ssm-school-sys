package com.javaee.service;

import java.util.List;
import java.util.Map;

import com.javaee.po.Course;
import com.javaee.utils.PageBean;
import com.javaee.vo.FieldExistValidVO;

public interface CourseService {
	public Course findCourseById(int id);	
	//public List<Course> findCourses();//不考虑分页
	public List<Integer> getCredits();
	public List<Integer> getClassHours();	

	public PageBean<Course> findCoursesByConditionPage(Map<String, Object> queryConditionMap); //带查询条件的分页 Course course, int currentPage, int pageSize
	
	public int getSameCount(FieldExistValidVO fieldExistValiddVO);
	
	public int updateCourse(Course course);
	public int deleteCourse(int id);
	public int insertCourse(Course course);
}
