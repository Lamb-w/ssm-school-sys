<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>管理员首页</title>
	<link href="${theContextPath}/css/myCSS.css" type="text/css" rel="stylesheet"/>
</head>
<body>
	<div class="mainArea posCenter">
		<div style="width:1000px; margin:0px auto;">
			<div class="pageTitle">管理员“${sessionScope.administrator.adminName}”首页</div>
			<div id="functionsArea" style="width: 600px;" class="posCenter">
				<a href="${theContextPath}/admin/findDepartments">院系信息管理</a><br>
				<a href="${theContextPath}/admin/findMajors">专业信息管理</a><br>
				<a href="${theContextPath}/admin/courseManagement">课程信息管理</a><br>
				<a href="${theContextPath}/admin/findStudents">学生信息管理</a><br>
				<br>
				<a href="#" title="尚在完善中">学期选课、录成绩时间管理</a><br>
				<br>
				<a href="${theContextPath}/admin/toUpdateAdminPwd">修改管理员密码</a><br>
				<a href="${theContextPath}/admin/loginOut">安全退出</a>
			</div>
		</div>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}">系统首页</a>
		</div>
	</div>
</body>
</html>