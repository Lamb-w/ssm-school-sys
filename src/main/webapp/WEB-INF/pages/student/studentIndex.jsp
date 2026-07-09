<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<c:set var="theStudent" value="${sessionScope.student}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>学生首页</title>
	<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
</head>
<body>
	<div class="mainArea">
		<div class="pageTitle">学生“${theStudent.sNo} ${theStudent.name}”首页</div>
		<div id="functionsArea" style="width: 600px;" class="posCenter">
			<br>
			<a href="#" title="尚在完善中">选课信息</a><br>
			<br>
			<a href="${theContextPath}/student/toUpdateStudentSelfPwd">修改密码</a><br>
			<a href="${theContextPath}/student/showDetailStudentSelf">查看个人信息</a><br>
			<br>
			<a href="${theContextPath}/student/loginOut">安全退出</a>
		</div>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}">系统首页</a>
		</div>
	</div>
</body>
</html>