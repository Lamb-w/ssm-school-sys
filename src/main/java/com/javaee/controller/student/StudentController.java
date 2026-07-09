package com.javaee.controller.student;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.javaee.vo.ChangePwdVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaee.po.Student;
import com.javaee.service.StudentService;
import com.javaee.utils.MyUtils;

@Controller
@RequestMapping("student")
public class StudentController {

	@Autowired
	private StudentService studentService;

	@RequestMapping("showDetailStudentSelf")
	public String findStudentById(HttpServletRequest request) {  // 
		HttpSession session = request.getSession();
		Student student = (Student) session.getAttribute(MyUtils.STUDENT_SESSION);// 在登录时存入session中的student只是Student表中的信息，未考虑表的连接，不全面。
		request.setAttribute("student", studentService.findStudentById(student.getId()));
		return "/student/showDetailStudent";
	}
	
	@RequestMapping("toUpdateStudentSelfPwd")
	public String toUpdateStudentSelfPwd(HttpServletRequest request) { // 学生登录时已用select * from Student where...，得到的student存入session。这对修改密码足够了。

		return "/student/updateStudentPwd";
	}
	@RequestMapping("doUpdateStudentSelfPwd")
	public String doUpdateStudentSelfPwd(HttpServletRequest request, ChangePwdVO changePwdVO) {
		if(studentService.updateStudentPwd(changePwdVO)==1) { // 在修改管理员密码那个界面上输入的旧密码是对的，
			request.setAttribute("theMessage", "<span class='success'>密码修改成功，记住新密码！</span>");
		} else {
			request.setAttribute("theMessage", "<script>alert('因旧密码错误，密码不变！');</script>");
		}
		return "forward:/student/toUpdateStudentSelfPwd";
	}
	
}
