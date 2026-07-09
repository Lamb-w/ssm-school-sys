package com.javaee.controller.administrator;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaee.po.Major;
import com.javaee.service.DepartmentService;
import com.javaee.service.MajorService;

@Controller
@RequestMapping("/admin")
public class MajorController {
	@Autowired
	private MajorService majorService;
	
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping("findMajorById")
	public String findMajorById(HttpServletRequest request, int id) {
		request.setAttribute("Major", majorService.findMajorById(id));		
		return "admin/majorManagement";
	}
	@RequestMapping("findMajors")
	public String findMajors(HttpServletRequest request) {
		request.setAttribute("listMajors", majorService.findMajors());
		request.setAttribute("listDepartments", departmentService.findDepartments());
		return "admin/majorManagement";
	}

	
	@RequestMapping("operateMajor")
	public String operateMajor(HttpServletRequest request, Major Major, String operateType) {
		if("i".equals(operateType)) { // 添加
			System.out.println("添加");
			if(majorService.insertMajor(Major)==1) {
				request.setAttribute("theMessage", "专业信息添加成功！");
			} else {
				request.setAttribute("theMessage", "<script>发生异常，专业信息添加失败！</script>");
			}			
		} else { // 更新
			System.out.println("更新");
			if(majorService.updateMajor(Major)==1) {
				request.setAttribute("theMessage", "专业信息更新成功！");
			} else {
				request.setAttribute("theMessage", "<script>发生异常，专业信息更新失败！</script>");
			}			
		}
		return "forward:/admin/findMajors";
	}
	@RequestMapping("deleteMajor")
	public String deleteMajor(HttpServletRequest request, int id) {
		if(majorService.deleteMajor(id)==1) {
			request.setAttribute("theMessage", "专业信息删除成功！");
		} else {
			request.setAttribute("theMessage", "<script>发生异常，专业信息删除失败！</script>");
		}
		return "forward:/admin/findMajors"; // /admin 最左边的/ 不能少			
	}
	
	@ResponseBody
	@RequestMapping("findMajorsByDepartmentId")
	public List<Major> findMajorByDepartmentIdSimple(int departmentId) {
		return majorService.findMajorsByDepartmentId(departmentId);
	}
	public List<Major> findMajorByDepartmentId(@RequestBody Map<String, Integer> map) { //  int，它接受不了null值。@RequestBody Integer departmentId
		int departmentId = map.get("departmentId");
		return majorService.findMajorsByDepartmentId(departmentId);
	}
}