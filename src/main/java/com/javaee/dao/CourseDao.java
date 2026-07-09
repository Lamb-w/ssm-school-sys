package com.javaee.dao;

import java.util.List;
import java.util.Map;

import com.javaee.po.Course;
import com.javaee.po.Department;
import com.javaee.vo.FieldExistValidVO;

public interface CourseDao {

	public Course findCourseById(int id);	
	//public List<Course> findCourses();
	public List<Integer> getCredits();
	public List<Integer> getClassHours();
	
	// 带查询条件的分页
	public List<Course> findCoursesByConditionPage(Map<String, Object> map);
	public int getCoursesCountByConditionPage(Map<String, Object> map);
	
	public int getSameCount(FieldExistValidVO fieldExistValiddVO);
	
	public int updateCourse(Course course);
	public int deleteCourse(int id);
	public int insertCourse(Course course);
}
