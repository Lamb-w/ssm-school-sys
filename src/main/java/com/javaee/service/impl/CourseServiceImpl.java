package com.javaee.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.javaee.dao.CourseDao;
import com.javaee.po.Course;
import com.javaee.service.CourseService;
import com.javaee.utils.PageBean;
import com.javaee.vo.FieldExistValidVO;
@Service
public class CourseServiceImpl implements CourseService {

	@Autowired
	private CourseDao courseDao;
	@Override
	public Course findCourseById(int id) {
		return courseDao.findCourseById(id);
	}


	public List<Integer> getCredits(){
		return courseDao.getCredits();
	}
	public List<Integer> getClassHours(){
		return courseDao.getClassHours();
	}

	// 带查询条件的分页查询
	public PageBean<Course> findCoursesByConditionPage(Map<String, Object> queryConditionMap){//封装成Map型参数，获得更好的扩展性 Course course, int currentPage, int pageSize
		int currentPage = (int)queryConditionMap.get("currentPage"), pageSize = (int) queryConditionMap.get("size");		
        PageBean<Course> pageBean = new PageBean<Course>();
        //每页显示的数据
        //int pageSize=2; // 固定，不太好。有的记录在不同情景模块中，每页允许显示的最大记录数很可能不同。
        pageBean.setPageSize(pageSize);
        //封装总记录数
        //map.put("course", course);
        int totalCount = courseDao.getCoursesCountByConditionPage(queryConditionMap);// 将来要考虑分页显示出模糊查询的结果集
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
            
            queryConditionMap.put("start",(currentPage-1)*pageSize);
            //map.put("size", pageBean.getPageSize());
            //封装每页显示的数据
            List<Course> lists = courseDao.findCoursesByConditionPage(queryConditionMap);
            pageBean.setLists(lists);        	
        } else{
        	pageBean.setLists(null); 
        }
        return pageBean;		
	}
	
	public int getSameCount(FieldExistValidVO fieldExistValiddVO) {
		return courseDao.getSameCount(fieldExistValiddVO);
	}
	
	@Override
	public int updateCourse(Course course) {
		return courseDao.updateCourse(course);
	}

	@Override
	public int deleteCourse(int id) {
		return courseDao.deleteCourse(id);
	}

	@Override
	public int insertCourse(Course course) {
		return courseDao.insertCourse(course);
	}

}
