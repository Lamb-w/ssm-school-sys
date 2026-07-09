package com.javaee.controller.administrator;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.javaee.po.Administrator;
import com.javaee.service.AdministratorService;
import com.javaee.utils.MyUtils;
import com.javaee.vo.ChangePwdVO;

@Controller
@RequestMapping("/admin")
public class AdministratorController {// 控制层 只能调用Service层、PO、VO，不能调用Dao。应由Service层去调用Dao层。
	@Autowired
	private AdministratorService administratorService;

	@RequestMapping("toUpdateAdminPwd")
	public String toChangeAdminPwd(HttpServletRequest request) {
		HttpSession session = request.getSession();
		Administrator administrator = (Administrator)session.getAttribute(MyUtils.ADMINISTRATOR_SESSION);// 从session中取出administrator对象
		request.setAttribute("administrator", administrator); // 然后接着放入request作用域中。
		return "/admin/updateAdminPwd";
	}
	
	@RequestMapping("doUpdateAdminPwd")
	public String doChangeAdminPwd(HttpServletRequest request, ChangePwdVO changePwdVO) {
		if(administratorService.updateAdminPwd(changePwdVO)==1) { // 在修改管理员密码那个界面上输入的旧密码是对的，
			request.setAttribute("theMessage", "<span class='success'>密码修改成功，记住新密码！</span>");
		} else {
			request.setAttribute("theMessage", "<script>alert('因旧密码错误，密码不变！');</script>");
		}			
		return "forward:/admin/toUpdateAdminPwd";
	}
}
