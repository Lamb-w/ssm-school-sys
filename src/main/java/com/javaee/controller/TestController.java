package com.javaee.controller;

import com.javaee.po.Major;
import com.javaee.service.DepartmentService;
import com.javaee.service.MajorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class TestController {
    @Autowired
    private DepartmentService departmentService;
    @Autowired
    private MajorService majorService;
    @RequestMapping("toTestCascade")
    public String toTestCascade(HttpServletRequest request){
        request.setAttribute("listDepartments", departmentService.findDepartments());
        return "forward:/test/testCascade.jsp";
    }
    @RequestMapping("findMajorsByDepartmentId")
    @ResponseBody
    public List<Major> findMajorsByDepartmentId(HttpServletRequest request, int departmentId){
        return majorService.findMajorsByDepartmentId(departmentId);

    }
}
