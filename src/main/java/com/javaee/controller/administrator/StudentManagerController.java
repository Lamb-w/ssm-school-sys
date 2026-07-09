package com.javaee.controller.administrator;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.javaee.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.javaee.utils.ImageUpload;
import com.javaee.utils.MyUtils;
import com.javaee.po.IdCard;
import com.javaee.po.Student;
import com.javaee.service.IdCardService;
import com.javaee.service.MajorService;
import com.javaee.service.StudentService;
import com.javaee.vo.FieldExistValidVO;

@Controller
@RequestMapping("/admin")
public class StudentManagerController {// XXController控制类根据角色分在不同包后，类名依然不能有区别。否则加载xml配置文件时报错。

	@Autowired
	private StudentService studentService;

	@Autowired
	private DepartmentService departmentService;
	
	@Autowired
	private MajorService majorService;
	
	@Autowired
	private IdCardService idCardService;
	
	private int pageSize=5;

	@RequestMapping("/findStudentByIdOrSomeStudentsWithPage")  // 考虑了分页的查询请求  这是含查询条件表单提交后对应的处理
	public String findStudentByIdOrSomeStudentsWithPage(HttpServletRequest request, Student student) {//String typeOfQuery查询类型也不提交
		int id = student.getId();
		if(id>0) {// 用户在查询表单中输入了id，表示是精确查询
			return "forward:/admin/showDetailStudent?id="+id;
		} else {// 提交时，id输入框中无值，表示模糊查询 不管id输入框的值 （sNo name idCard.cardNo contactPhone）
			// 第一次提交模糊查询，此时应清除掉之前的查询条件的影响
			Map<String, Object> queryCondition = new HashMap<String, Object>();
			queryCondition.put("student", student);
			
			queryCondition.put("currentPage", 1); // 默认显示第1页
			queryCondition.put("size", pageSize);
			request.getSession().setAttribute("queryCondition", queryCondition); // 将查询条件存入session，方便用户通过点击链接去访问第几页。
			return "forward:/admin/findStudents?currentPage=1";
		}			
	}		
	@RequestMapping("findStudents") // 考虑了查询条件的分页查询 这是处理访问某页结果集的请求。
	public String findStudents(HttpServletRequest request, @RequestParam(value="currentPage",defaultValue="0", required=false) int currentPage) {
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
		request.setAttribute("pageMsg", studentService.findStudentsByConditionPage(queryConditionMap));
		request.setAttribute("listDepartments", departmentService.findDepartments());
		return "/admin/studentManagement";
	}	
	@RequestMapping("showDetailStudent")
	public String showDetailStudent(HttpServletRequest request, int id) {		
		request.setAttribute("student", studentService.findStudentById(id));
		return "/admin/showDetailStudent";
	}
	@ResponseBody
    @RequestMapping("/isExistSame")
    public boolean ajaxValidate(@RequestBody FieldExistValidVO fieldExistValidVO) {
        return studentService.getSameCount(fieldExistValidVO)==1;
    }

	@ResponseBody
    @RequestMapping("/isOtherExistSame")
    public boolean ajaxValidateOhter(@RequestBody FieldExistValidVO fieldExistValidVO) {
        System.out.println(studentService.getOtherSameCount(fieldExistValidVO));
		return studentService.getOtherSameCount(fieldExistValidVO)==1;
    }	
	@RequestMapping("insertStudent")
	public String insertStudent(HttpServletRequest request) {
		request.setAttribute("totalOfStudents", studentService.getTotalOfStudents());
		request.setAttribute("listDepartments", departmentService.findDepartments());
		return "/admin/insertStudent";
	}
	@RequestMapping("doInsertStudent")
	public String doInsertStudent(HttpServletRequest request, Student student) {
		String theMessage="";
		// 先要向IdCard表中添加表单提交上来的student中的idCard属性
		IdCard idCard = student.getIdCard();
		int rows = idCardService.insertIdCard(idCard);// 本句执行后，idCard的属性id已被赋值为添加进IdCard表时的id列的值
		student.setIdCard(idCard);
		if(student.getsPwd().trim()=="") {
			student.setsPwd(MyUtils.getDefaultSPwd(idCard.getCardNo()));
		}// 若不是空就表示管理员未用默认的密码而是另设密码。
		if(studentService.insertStudent(student)==1) {
			String theImageURLInDB = student.getImage();
			MyUtils.copyAndDelete(request, theImageURLInDB, MyUtils.getTempDirectory(), MyUtils.getStudentImageURLRoot());
			theMessage="学生（学号：" + student.getsNo() + "、姓名：" + student.getName() + "）添加成功！";
		} else {
			theMessage = "<script>alert('学生（学号：" + student.getsNo() + "、姓名：" + student.getName() + "）添加失败！');</script>";
		}
		request.setAttribute("theMessage", theMessage);
		return "forward:/admin/insertStudent";
	}
	// 修改学生
	@RequestMapping("toUpdateStudent")
	public String toUpdateStudent(HttpServletRequest request, int id) {
		request.setAttribute("student", studentService.findStudentById(id));
		request.setAttribute("listDepartments", departmentService.findDepartments());
		return "/admin/updateStudent";
	}
	@RequestMapping("doUpdateStudent")
	public String doUpdateStudent(HttpServletRequest request, Student student) {
		String theMessage="";
		if(student.getsPwd().trim()=="") {
			student.setsPwd(MyUtils.getDefaultSPwd(student.getIdCard().getCardNo()));
		}
		if(idCardService.updateIdCard(student.getIdCard())==1 && studentService.updateStudent(student)==1) {
			String theImageURLInDB = student.getImage();
			MyUtils.copyAndDelete(request, theImageURLInDB, MyUtils.getTempDirectory(), MyUtils.getStudentImageURLRoot());
			theMessage="学生（学号：" + student.getsNo() + "）修改成功！";
		} else {
			theMessage = "<script>alert('学生（学号：" + student.getsNo() + "）修改失败！');</script>";
		}
		request.setAttribute("theMessage", theMessage);
		return "forward:/admin/toUpdateStudent";
	}	
	@RequestMapping("deleteStudent")
	public String deleteStudent(HttpServletRequest request, int id, int currentPage) {
		String theMessage="";
		int theIDCardId = studentService.findStudentById(id).getIdCard().getId();
		if(studentService.deleteStudent(id)==1 && idCardService.deleteIdCard(theIDCardId)==1) { // 因学生表的idCardId参照证件表id，所以要先删学生表，然后删证件表。
			theMessage = "删除学生成功！";
		} else {
			theMessage = "<script>alert('删除学生失败！可能之前已不存在！');</script>";
		}
		request.setAttribute("theMessage", theMessage);
		return "forward:/admin/findStudents?currentPage=" + currentPage;
	}	
	@ResponseBody
	@RequestMapping("ajaxImageFileUpload")
	public Map<String, Object> ajaxImageFileUpload(HttpServletRequest request, MultipartFile photo){
		Map<String, Object> map = new HashMap<String, Object>();
		String prefixImagePath = MyUtils.getTempDirectory(); // 每次都是上传到服务器上的临时文件夹中以便各浏览器都能正确显示预览图。待正式提交后，要复制到正式的文件夹中，然后删除。

		String imageURL = ImageUpload.upload(request, photo, prefixImagePath);
		map.put("status","error".equals(imageURL)? false:true);
		map.put("imageURL", imageURL);
		return map;
		
	}
}
