<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theCourse" value="${requestScope.course}" scope="page"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>显示课程详情</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
</head>
<body>
	<div style="width:1200px; margin:0px auto;">
		<h2 style="text-align:center">课程详情</h2>
		<c:if test="${theCourse==null }">
			<div style="text-align:center">无此编号的课程</div>
		</c:if>
		<c:if test="${theCourse!=null }">
			<table class="posCenter">
				<tr>
					<th class="alignRight" width="60">课程号</th><td>${theCourse.cNo }</td>
				</tr>			
				<tr>
					<th class="alignRight">课程名</th><td>${theCourse.name}</td>
				</tr>
				<tr>
					<th class="alignRight">学分</th><td>${theCourse.credit}</td>
				</tr>			
				<tr>
					<th class="alignRight">学时</th><td>${theCourse.classHour}</td>
				</tr>
				<tr>
					<th>介绍</th>
					<td>${theCourse.memo}</td>
				</tr>													
			</table>			
		</c:if>
		<div style="text-align:center">
			<a href="${theContextPath}/admin/courseManagement">课程信息管理</a>
		</div>		
	</div>
</body>
</html>