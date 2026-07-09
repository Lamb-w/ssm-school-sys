<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<c:set var="theDepartment" value="${requestScope.department}" scope="page"/>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>显示院系详情</title>
	<link href="${theContextPath}/css/myCSS.css" type="text/css" rel="stylesheet"/>
</head>
<body>
	<div class="mainArea">
		<div class="pageTitle">院系详情</div>
		<table class="posCenter">
			<tr>
				<th>名称</th><td>${theDepartment.name }</td>
			</tr>
			<tr>
				<th>备注</th><td>${theDepartment.memo }</td>
			</tr>			
		</table>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/findDepartments">院系信息管理</a>
		</div>
	</div>
</body>
</html>