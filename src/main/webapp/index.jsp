<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>学生选课成绩管理系统_首页</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
</head>
<body>
	<div class="mainArea alignCenter">
		<div style="width:900px; display:block; margin:0px auto;" class="posCenter">
			<div class="pageTitle">系统_首页</div>
			<div style="height:90px;"></div>
			<div id="testArea"><a href="${theContextPath}/toTestCascade">级联学习</a></div>
			<div style="height: 20px;"></div>
<c:choose> <%-- 不考虑一个会话session同时登录了管理员和学生 --%>
	<c:when test="${sessionScope.administrator!=null}">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/loginOut">安全退出</a>
	</c:when>	  
	<c:when test="${sessionScope.student!=null}">
			<a href="${theContextPath}/student/toStudentMain">学生首页</a> <a href="${theContextPath}/student/loginOut">安全退出</a>
	</c:when>
	<c:otherwise><a href="${theContextPath}/login">登录</a></c:otherwise>
</c:choose>
		</div>		
	</div>	
</body>
</html>