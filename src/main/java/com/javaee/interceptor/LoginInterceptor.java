package com.javaee.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.javaee.po.Administrator;
import com.javaee.po.Student;
//import com.javaee.po.Student;
import com.javaee.utils.MyUtils;


public class LoginInterceptor implements HandlerInterceptor {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	    // 获取请求的URL  
        String url = request.getRequestURI();  // http://localhost:8080/ch04/admin/index.jsp
        // URL:除了login.jsp是可以公开访问的，其它的URL都进行拦截控制  
        int adminPos=url.indexOf("/admin/"), studentPos=url.indexOf("/student/");
        if(adminPos==-1 && studentPos==-1) {// 不含 串"/admin"、"/student"。说明不是管理员、会员，是游客而已。此时直接放行。
        	return true; 
        } else { // url中至少含串"/admin"、"/student"中的一个。
	        // 获取Session  
	        HttpSession session = request.getSession();         	
        	if(adminPos>=0) {// 试图执行管理员的操作
        		//Administrator administrator = (Administrator) session.getAttribute("administrator");
        		Administrator administrator = (Administrator) session.getAttribute(MyUtils.ADMINISTRATOR_SESSION);
		        // 判断Session中是否有用户数据，如果有，则返回true,继续向下执行
		        if(administrator != null){ // 存在键为"administrator"这个非空session，说明是经历过登录界面而转到这的。
		            return true;  
		        }        		
        	} else { // 试图执行学生的操作
        		Student student = (Student) session.getAttribute(MyUtils.STUDENT_SESSION);
		        // 判断Session中是否有用户数据，如果有，则返回true,继续向下执行
		        if(student != null){ // 存在键为"student"这个非空session，说明是经历过登录界面而转到这的。
		            return true;  
		        } 
		            		
        	}
        }
        // 不符合条件(其实就是else)的给出提示信息，并转发到登录页面
         request.setAttribute("theMessage", "<script>alert('必须先登录！');</script>");
         request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response); // 因此类不是控制类，所以只能用这样的方法转到(请求转发)那个页面
         return false;
	}
	// 余下的这两个方法postHandle、afterHandle尽管没实际代码，但根据实现接口的原则，必须放在这个类里。方法体是空，也是一种最简单的实现。
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
	
	}
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
	
	}
	
}
