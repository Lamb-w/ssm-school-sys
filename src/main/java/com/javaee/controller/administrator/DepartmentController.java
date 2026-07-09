package com.javaee.controller.administrator;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.javaee.po.Department;
import com.javaee.service.DepartmentService;

@Controller
@RequestMapping("/admin")
public class DepartmentController {
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping("findDepartmentById")
	public String findDepartmentById(HttpServletRequest request, int id) {
		request.setAttribute("department", departmentService.findDepartmentById(id));		
		return "admin/departmentManagement";
	}
	@RequestMapping("showDetailDepartment")
	public String showDetailDepartment(HttpServletRequest request, int id) {
		request.setAttribute("department", departmentService.findDepartmentById(id));		
		return "admin/showDetailDepartment";
	}
	@RequestMapping("findDepartments")
	public String findDepartments(HttpServletRequest request) {
		request.setAttribute("listDepartmentsWithMajorCountVO", departmentService.findDepartmentsWithMajorCount());		
		return "admin/departmentManagement";
	}	
	@RequestMapping("operateDepartment")
	public String operateDepartment(HttpServletRequest request, Department department, String operateType) {
		if("i".equals(operateType)) { // 添加
			System.out.println("添加");
			if(departmentService.insertDepartment(department)==1) {
				request.setAttribute("theMessage", "院系信息添加成功！");
			} else {
				request.setAttribute("theMessage", "<script>发生异常，院系信息添加失败！</script>");
			}			
		} else { // 更新
			System.out.println("更新");
			if(departmentService.updateDepartment(department)==1) {
				request.setAttribute("theMessage", "院系信息更新成功！");
			} else {
				request.setAttribute("theMessage", "<script>发生异常，院系信息更新失败！</script>");
			}			
		}
		return "forward:/admin/findDepartments";
	}
	@RequestMapping("deleteDepartment")
	public String deleteDepartment(HttpServletRequest request, int id) {
		if(departmentService.deleteDepartment(id)==1) {
			request.setAttribute("theMessage", "院系信息删除成功！");
		} else {
			request.setAttribute("theMessage", "<script>发生异常，院系信息删除失败！</script>");
		}
		return "forward:/admin/findDepartments"; // /admin 最左边的/ 不能少			
	}
}
