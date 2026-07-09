package com.javaee.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaee.po.Administrator;
import com.javaee.po.Student;
import com.javaee.service.AdministratorService;
import com.javaee.service.StudentService;
import com.javaee.utils.MyUtils;
import com.javaee.utils.RandomValidateCode;
import com.javaee.vo.LoginVO;

@Controller  
public class LoginController {
	@Autowired
	private AdministratorService administratorService;   // 注：注解@Autowired对下下条的属性无效。 一条注解对应一个类。
	
	@Autowired
	private StudentService studentService;
	
	@RequestMapping("/login")
	public String toLogin(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.invalidate();
		return "login";
	}
	@RequestMapping("/admin/loginOut")
	public String loginOutForAdministrator(HttpServletRequest request) {
		HttpSession session = request.getSession();	
		session.removeAttribute(MyUtils.ADMINISTRATOR_SESSION);// session.removeAttribute("administrator"); 改用常量避免到处出现"administrator"这个键值，方便修改
		session.invalidate();
		return "login";
	}
	@RequestMapping("/student/loginOut")
	public String loginOutForCustomer(HttpServletRequest request) {
		HttpSession session = request.getSession();	
		session.removeAttribute(MyUtils.STUDENT_SESSION);//和上面不直接用"administrator"原因相同
		session.invalidate();
		return "login";
	}	
	@RequestMapping("/admin/toAdminMain")
	public String toAdminIndex() {
		return "/admin/adminIndex";
	}
	@RequestMapping("/student/toStudentMain")
	public String toStudentIndex() {
		return "/student/studentIndex";
	}	
	@RequestMapping("/doLogin")
	public String doLogin(HttpServletRequest request, LoginVO loginVO, String checkCode) {
		HttpSession session = request.getSession();
		if("0".equals(loginVO.getLoginRole())) { // 管理员 应到t_admin表中核对
			Administrator administrator = administratorService.findAdministratorByLogin(loginVO);
			if(null !=administrator) {
				session.setAttribute(MyUtils.ADMINISTRATOR_SESSION, administrator);
				return "redirect:/admin/toAdminMain";
			} else {
				request.setAttribute("loginError", "<script>alert('管理员的账号、密码错误！');</script>");
				return "login";
			}
		} else { // 不是管理员的其他角色。 比如是学生，此时应到Student表中核对
			Student student = studentService.findStudentByLogin(loginVO);
			if(null != student) {
				session.setAttribute(MyUtils.STUDENT_SESSION, student);
				return "forward:/student/toStudentMain"; // 转到角色首页
			} else {
				request.setAttribute("loginError", "<script>alert('学生的账号、密码错误！');</script>");
				return "login";
			}
		}
	}	
}
