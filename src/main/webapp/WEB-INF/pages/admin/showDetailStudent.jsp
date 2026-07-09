<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theStudent" value="${requestScope.student}" scope="page"/>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>显示学生详情</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
</head>
<body>
	<div style="width:1000px; margin:0px auto;">
		<h2 style="text-align:center">学生详情</h2>
		<c:if test="${theStudent==null }">
			<div style="text-align:center">无此编号的学生</div>
		</c:if>
		<c:if test="${theStudent!=null }">
			<table class="posCenter">
				<tr>
					<th class="alignRight" style="width: 90px;">学号</th><td>${theStudent.sNo }</td>
				</tr>			
				<tr>
					<th class="alignRight">密码</th><td>${theStudent.sPwd}</td>
				</tr>
				<tr>
					<th class="alignRight">姓名</th><td>${theStudent.name}</td>
				</tr>
				<tr>
					<th class="alignRight">性别</th><td>${theStudent.gender}</td>
				</tr>
				<tr>
					<th class="alignRight">院系</th><td>${theStudent.department.name}</td>
				</tr>
				<tr>
					<th class="alignRight">专业</th><td>${theStudent.major.name}</td>
				</tr>
				<tr>
					<th class="alignRight">联系电话</th><td>${theStudent.contactPhone}</td>
				</tr>	
				<tr>
					<td colspan="2">
						<fieldset style="width: 300px; margin-left:90px;margin-bottom:5px;">
							<legend>身份证</legend>
							<c:set var="theIdCard" value="${theStudent.idCard}"/>
							号码：<b>${theIdCard.cardNo}</b><br>
							有效期：${theIdCard.expireDateStart} - ${theIdCard.expireDateEnd}<br>
							发证机关：${theIdCard.issuingAuthority}
						</fieldset>
					</td>
				</tr>	
				<tr>
					<th class="alignRight">图片</th>
					<td>
						<c:set var="theImageOriginal" value="${myUtils.trim(theStudent.image)}"/>
						<c:choose>
							<c:when test="${theImageOriginal==null or theImageOriginal==''}">
								暂未上传图片
							</c:when>
							<c:otherwise>
								原图：<img id="imageOriginal" src="${theContextPath}/${myUtils.getImageSrc(1,theImageOriginal)}" width="50" height="50"/>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th class="alignRight">介绍</th>
					<td>${theStudent.memo}</td>
				</tr>													
			</table>			
		</c:if>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/findStudents">学生信息管理</a> <a href="${theContextPath}/admin/toAdminMain">管理员首页</a>
		</div>
	</div>
</body>
</html>