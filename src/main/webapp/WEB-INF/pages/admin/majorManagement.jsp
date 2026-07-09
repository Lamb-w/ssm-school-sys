<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<c:set var="theListMajors" value="${requestScope.listMajors }" scope="page"/>
<c:set var="theListMajorsSize" value="${theListMajors.size()}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>专业信息管理</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
<script>
	function formUpdateInitialContent(theIndex, theId, theDepartmentId){
		$("#theUpdatedId").val(theId);
		$("#theUpdatedName").val($("#theName"+theIndex).text());
		$("#theUpdatedDepartmentId").val(theDepartmentId);
		$("#theIdShow").text(theId);
		$("#btnUpdate").css({"visibility":"visible"});
	}
	function prepareOperate(theType){
		$("#operateType").val(theType);
		
	}	
	function checkValid(theForm){
		var $theUpdatedName = $("#theUpdatedName");
		var theUpdatedNameV = $theUpdatedName.val().trim();
		if(theUpdatedNameV==""){
			alert("专业名称不能为空");
			$theUpdatedName.select();
			return false;
		}
		return true;
	}
</script>
</head>
<body>
	<div class="mainArea">
		<div class="pageTitle">专业信息管理</div>
		<c:if test="${theListMajorsSize==0}">目前无专业信息</c:if>
		<c:if test="${theListMajorsSize>0 }">
			<table class="posCenter">
				<tr><th>序号</th><th>编号</th><th>名称</th><th>院系</th><th>修改</th><th>删除</th></tr>
			<c:forEach items="${theListMajors }" var="major" varStatus="theStatus">
				<c:set var="theId" value="${major.id }" scope="page"/>
				<tr>
					<td>${theStatus.index+1 }</td><td>${theId }</td><td id="theName${theStatus.index+1 }">${major.name }</td><td>${major.department.name }</td>
					<td><a href="#" onclick="formUpdateInitialContent(${theStatus.index+1 }, ${theId }, ${major.department.id})">修改</a></td>
					<td><a href="${theContextPath}/admin/deleteMajor?id=${theId}" onclick="return confirm('确定删除吗？');">删除</a></td>
				</tr>
			</c:forEach>
			</table>
		</c:if>
		<br><br>
		<form action="${theContextPath}/admin/operateMajor" id="myForm" onsubmit="return checkValid(this);" method="post">
			<input type="hidden" value="0" name="id" id="theUpdatedId"> <%-- 因为空值是不能被绑定到类型为int型属性赋值。设置初始值为零，是为了让添加时也能顺利打包成department对象，如未设值，则在绑定成department时报错。 --%>
			<input type="hidden" value="i" name="operateType" id="operateType">
			<table class="posCenter">
				<tr>
					<th>专业名称</th><td><input name="name" id="theUpdatedName"></td>
				</tr>
				<tr>
					<th>所属院系</th>
					<td>
						<select name="department.id"  id="theUpdatedDepartmentId">
						<c:forEach items="${requestScope.listDepartments }" var="department">
							<option value="${department.id}" >${department.name}</option>
						</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="alignCenter">
						<button onclick="prepareOperate('u')" type="submit" id="btnUpdate" style="visibility:hidden">更新编号为“<span id="theIdShow"></span>”的专业信息</button>
						<button onclick="prepareOperate('i')" type="submit">添加新专业信息</button> <input type="reset" value="重填">
					</td>
				</tr>				
			</table>		
		</form><br>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a>
			<br><br>${requestScope.theMessage }
		</div>
	</div>
</body>
</html>