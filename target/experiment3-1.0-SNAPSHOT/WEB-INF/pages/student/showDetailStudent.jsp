<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theStudent" value="${requestScope.student}"/>
<c:set var="theContext" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>显示学生详情</title>
<link href="${theContext}/css/myCSS.css" rel="stylesheet">
</head>
<body>
	<div class="mainArea">
		<div class="pageTitle">学生详情</div>
		<c:if test="${theStudent==null }">
			<div style="text-align:center">无此编号的学生</div>
		</c:if>
		<c:if test="${theStudent!=null }">
			<table class="tableCenter" style="margin:0px auto;">
				<tr>
					<th class="alignRight">学号</th><td>${theStudent.sNo }</td>
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
						<fieldset>
							<legend>身份证</legend>
							<br>
							号码：${theStudent.idCard.cardNo}<br>
							有效期：${theStudent.idCard.expireDateStart} - ${theStudent.idCard.expireDateEnd}<br>
							发证机关：${theStudent.idCard.issuingAuthority}
						</fieldset>
					</td>
				</tr>	
				<tr>
					<th>图片</th>
					<td>
						<c:set var="theImageOriginal" value="${myUtils.trim(theStudent.image)}"/>
						<c:choose>
							<c:when test="${theImageOriginal==null or theImageOriginal==''}">
								暂未上传图片
							</c:when>
							<c:otherwise>
								原图：<img id="imageOriginal" src="${theContext}/${myUtils.getImageSrc(1,theImageOriginal)}" width="50" height="50"/>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<th>介绍</th>
					<td>${theStudent.memo}</td>
				</tr>													
			</table>			
		</c:if>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContext}/">系统首页</a> <a href="${theContext}/student/toStudentMain">学生首页</a>
		</div>
	</div>
</body>
</html>