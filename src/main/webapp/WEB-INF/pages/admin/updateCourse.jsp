<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="course" value="${requestScope.course}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改课程</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.config.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.all.min.js"> </script>
	<script src="${theContextPath}/plugin/UEditor/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
	var ue;
	$(function(){
		ue = UE.getEditor('editor', {initialFrameWidth:'100%', initialFrameHeight:400});
		ue.autoHeightEnabled = false;
	});

function checkValid(theForm){
	var theName=theForm.name, theNameV=theName.value.trim();	
	var theCredit=theForm.credit, thCreditV=theCredit.value.trim();
	var theClassHour=theForm.classHour, thClassHourV=theClassHour.value.trim();
	if(theNameV==""){
		alert("课程名不能为空！");
		theName.select();			
	} else if(theCreditV=="" || isNaN(theCreditV) || theCreditV.indexOf(".")!=-1 || parseInt(theCreditV)<=0){
		alert("学分必须是非空的正整数！");
		theCredit.select();			
	} else if(theClassHourV=="" || isNaN(theClassHourV) || theClassHourV.indexOf(".")!=-1 || parseInt(theClassHourV)<=0){
		alert("学时必须是非空的正整数！");
		$theClassHour.select();			
	} else{
		return true;
	}		
	return false;
}	

</script>	
</head>
<body>
	<div style="width:1200px; margin:0px auto;">
		<h2 style="text-align:center;">更新课程</h2>
		<form action="${theContextPath}/admin/doUpdateCourse" method="post" onsubmit="return checkValid(this);">
			<input type="hidden" name="id" value="${course.id}"/>
			<table class="alignCenter" style="width: 100%;">
				<tr>
					<th class="alignRight" style="width: 70px;">课程号</th><td>${course.cNo}</td> <%-- 约定：课程的编号、课程号都是不可改的。 --%>
				</tr>			
				<tr>
					<th class="alignRight">课程名</th><td><input type="text" name="name" size="40" maxlength="40" value="${course.name}"></td>
				</tr>
				<tr>
					<th class="alignRight">学分</th><td><input type="text" name="credit" id="credit" size="3" maxlength="2" value="${course.credit}"></td>
				</tr>	
				<tr>
					<th class="alignRight">学时</th><td><input type="text" name="classHour" id="classHour" size="4" maxlength="3" value="${course.classHour}"></td>
				</tr>							
				<tr>
					<th class="alignRight">介绍</th><td><textarea id="editor" name="memo">${course.memo}</textarea></td>
				</tr>	
				<tr>
					<td colspan="2" class="alignCenter"><input type="submit" value="确定" class="btn"> <input type="reset" value="重填" class="btn"></td>
				</tr>													
			</table>		
		</form>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/courseManagement">管理课程信息</a><br>
			${requestScope.theMessage }
		</div>
	</div>
</body>
</html>