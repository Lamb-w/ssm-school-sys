package com.javaee.controller.administrator;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaee.po.Course;
import com.javaee.po.Student;
import com.javaee.service.CourseService;
import com.javaee.vo.FieldExistValidVO;

@Controller
@RequestMapping("/admin")
public class CourseController {

	@Autowired
	private CourseService courseService;
	
	private int pageSize=3;

	@RequestMapping("showDetailCourse")
	public String showDetailCourse(HttpServletRequest request, int id) {
		request.setAttribute("course", courseService.findCourseById(id));
		return "admin/showDetailCourse";		
	}

	@RequestMapping("/findCourseByIdOrSomeCoursesWithPage")  // 考虑了分页的查询请求  这是含查询条件表单提交后对应的处理
	public String findStudentByIdOrSomeStudentsWithPage(HttpServletRequest request, Course course) {
		int id = course.getId();
		if(id>0) {// 用户在查询表单中输入了id，表示是精确查询
			return "forward:/admin/showDetailCourse?id="+id;
		} else {// 提交时，id输入框中无值，表示模糊查询 不管id输入框的值 （cNo name credit classHour） memo字段不参与模糊查询
			Map<String, Object> queryCondition = new HashMap<String, Object>();
			queryCondition.put("course", course);
			queryCondition.put("currentPage", 1); // 默认显示第1页
			
			queryCondition.put("size", pageSize);
			request.getSession().setAttribute("queryCondition", queryCondition); // 将查询条件存入session，方便用户通过点击链接去访问第几页。 
			
			request.setAttribute("pageMsg", courseService.findCoursesByConditionPage(queryCondition)); 
			request.setAttribute("listCredits", courseService.getCredits());//为了形成学分信息的下拉框列表
			request.setAttribute("listClassHours", courseService.getClassHours()); // 为了形成学时信息的下拉框列表			
			return "admin/courseManagement";
		}			
	}		
	// 考虑了查询条件的分页查询 这是处理访问某页结果集的请求。
	@RequestMapping("courseManagement")  // 能发起这个请求的可能是：初次显示课程管理、在课程管理页面访问了特定的页号、删除某个课程后返回的课程管理。
	public String coursesManagement(HttpServletRequest request, @RequestParam(value="currentPage",defaultValue="0", required=false) int currentPage) {
		HttpSession session = request.getSession();
		Map<String, Object> queryConditionMap = new HashMap<String, Object>();
		if(currentPage <= 0) {
			session.removeAttribute("queryCondition");
			currentPage = 1; // 默认显示第1页。	
		} else {
			Map<String, Object> queryConditionMapTemp = (Map<String, Object>) session.getAttribute("queryCondition");	
			if(queryConditionMapTemp != null) {
				queryConditionMap = queryConditionMapTemp;
			}
		}
		queryConditionMap.put("currentPage", currentPage);
		queryConditionMap.put("size", pageSize); // 注：Dao层实现类(即MyBatis的映射文件)的limit子句中是limit #{start}, #{size} ，所以键值已与Dao层的limit子句中的第2个参数相同。
		request.setAttribute("pageMsg", courseService.findCoursesByConditionPage(queryConditionMap));
		request.setAttribute("listCredits", courseService.getCredits());//为了形成学分信息的下拉框列表
		request.setAttribute("listClassHours", courseService.getClassHours()); // 为了形成学时信息的下拉框列表
		return "admin/courseManagement";
	}	
	
	@RequestMapping("insertCourse")
	public String insertCourse() {
		return "admin/insertCourse";
		
	}
	
	@RequestMapping("doInsertCourse")
	public String doInsertCourse(HttpServletRequest request, Course course) {
		String theMessage="<script>alert('添加课程失败！');</script>";
		if(courseService.insertCourse(course)==1) {
			theMessage = "添加课程成功！";
		}
		request.setAttribute("theMessage", theMessage);
		return "forward:/admin/insertCourse";		
	}
	
	@ResponseBody
	@RequestMapping("isExistSameCourse")
	public boolean isExistSameCourse(@RequestBody FieldExistValidVO fieldExistValidVO) {// 用于在添加课程时，以ajax方式判断所输的课程号是否已存在		
		return courseService.getSameCount(fieldExistValidVO)==1? true: false;
	}

	@RequestMapping("toUpdateCourse")
	public String toUpdateCourse(HttpServletRequest request, int id) {
		request.setAttribute("course", courseService.findCourseById(id));
		return "admin/updateCourse";		
	}
	
	@RequestMapping("doUpdateCourse")
	public String doUpdateCourse(HttpServletRequest request, Course course) {
		String theMessage="<script>alert('修改课程失败！');</script>";
		if(courseService.updateCourse(course)==1) {
			theMessage = "修改课程成功！";
		}
		request.setAttribute("theMessage", theMessage);
		return "forward:/admin/toUpdateCourse";		
	}
	@RequestMapping("deleteCourse")
	public String deleteCourse(HttpServletRequest request, int id, int currentPage) {
		String theMessage="";
		if(courseService.deleteCourse(id)==1) {
			theMessage = "删除课程成功！";
		} else {
			theMessage = "<script>alert('删除课程失败！可能之前已不存在！');</script>";
		}
		request.setAttribute("theMessage", theMessage);

		return "forward:/admin/courseManagement?currentPage=" + currentPage;
	}
}
