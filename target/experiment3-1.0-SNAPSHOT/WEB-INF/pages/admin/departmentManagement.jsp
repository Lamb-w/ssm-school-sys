<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<c:set var="theListDepartmentsWithMajorCountVO" value="${requestScope.listDepartmentsWithMajorCountVO }" scope="page"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>院系信息管理</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.config.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.all.min.js"> </script>
	<script src="${theContextPath}/plugin/UEditor/lang/zh-cn/zh-cn.js"></script>
<script>
	var ue;
	$(function(){
		ue = UE.getEditor('theUpdatedMemo', {initialFrameWidth:'100%', initialFrameHeight:400});
		ue.autoHeightEnabled = false;
	});
	function formUpdateInitialContent(theIndex, theId){
		$("#theUpdatedId").val(theId);
		$("#theUpdatedName").val($("#theName"+theIndex).text());
		//alert($("#theMemo"+theIndex).html()); //OK
		ue.ready(function() {
			ue.setContent($("#theMemo"+theIndex).html());
		});

		$("#theIdShow").text(theId);
		$("#btnUpdate").css({"visibility":"visible"});
		$.ajax({
			type:"POST",
			url:"${theContextPath}/admin/findMajorsByDepartmentId",
			data:{"departmentId":theId}, //
			success:function(resultData){
				if (null != resultData) {
					var theLength = resultData.length;
					if(theLength==0){
						$("#theMajorsShowArea").html("编号为“"+theId+"”的院系尚无专业!");
					} else{
						var resultStr="<ul style='text-align:left;'><li>编号为“"+theId+"”的院系设置的专业信息：</li>";
						for(var i=0; i<theLength; i++){
							resultStr = resultStr + "<li>"+(i+1)+"、"+resultData[i].id +" "+ resultData[i].name+"</li>";
						}
						resultStr = resultStr +"</ul>";
						$("#theMajorsShowArea").html(resultStr);
					}
				}
			}
		});
		$("#showResult").html("");
	}
	function prepareOperate(theType){
		$("#operateType").val(theType);
		
	}	
	function checkValid(theForm){
		var $theUpdatedName = $("#theUpdatedName");
		var theUpdatedNameV = $theUpdatedName.val().trim();
		if(theUpdatedNameV==""){
			alert("系名称不能为空");
			$theUpdatedName.select();
			return false;
		}
		return true;
	}

</script>
</head>
<body>
	<div class="mainArea">
		<div class="pageTitle">院系信息管理</div>
		<c:if test="${theListDepartmentsWithMajorCountVO.size()==0 }">目前无院系信息</c:if>
		<c:if test="${theListDepartmentsWithMajorCountVO.size()>0 }">
			<table class="posCenter">
				<tr><th>序号</th><th>编号</th><th>名称</th><th>专业个数</th><th>详细</th><th>修改</th><th>删除</th></tr>
			<c:forEach items="${theListDepartmentsWithMajorCountVO }" var="departmentWithMajorCountVO" varStatus="theStatus">
				<c:set var="theDepartment" value="${departmentWithMajorCountVO.department}" scope="page"/>
				<c:set var="theMajorCount" value="${departmentWithMajorCountVO.majorCount}" scope="page"/>
				<c:set var="theId" value="${theDepartment.id }" scope="page"/>
				<tr>
					<td>${theStatus.index+1 }</td><td>${theId }<span id="theMemo${theStatus.index+1 }" style="display:none;">${theDepartment.memo}</span></td><td id="theName${theStatus.index+1 }">${theDepartment.name }</td>
					<td>${departmentWithMajorCountVO.majorCount}</td>
					<td><a href="${theContextPath}/admin/showDetailDepartment?id=${theId}">详细</a></td>
					<td><a href="#" onclick="formUpdateInitialContent(${theStatus.index+1 }, ${theId })">修改</a></td>
					<td>
						<c:if test="${theMajorCount>0 }">
							不能删除
						</c:if>
						<c:if test="${theMajorCount==0 }">
							<a href="${theContextPath}/admin/deleteDepartment?id=${theId}" onclick="return confirm('确定删除吗？');">删除</a>
						</c:if>
					</td>
				</tr>
			</c:forEach>
			</table>
		</c:if>
		<br>
		<form action="${theContextPath}/admin/operateDepartment" id="myForm" onsubmit="return checkValid(this);" method="post">
			<input type="hidden" value="0" name="id" id="theUpdatedId"> <%-- 因为空值是不能被绑定到类型为int型属性赋值。设置初始值为零，是为了让添加时也能顺利打包成department对象，如未设值，则在绑定成department时报错。 --%>
			<input type="hidden" value="i" name="operateType" id="operateType">
			<table class="posCenter">
				<tr>
					<th>名称</th><td><input name="name" id="theUpdatedName"></td>
				</tr>
				<tr>
					<th>备注</th><td><textarea id="theUpdatedMemo" name="memo" style="height:300px;width:890px;"></textarea></td>
				</tr>				
				<tr>
					<td colspan="2" class="alignCenter">
						<button onclick="prepareOperate('u')" type="submit" id="btnUpdate" style="visibility:hidden">更新编号为“<span id="theIdShow"></span>”的院系信息</button>
						<button onclick="prepareOperate('i')" type="submit">添加新院系信息</button> <input type="reset" value="重填">
					</td>
				</tr>				
			</table>		
		</form>
		<div id="theMajorsShowArea" class="alignCenter" style="width:500px; margin:0px auto;">
			
		</div>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a><br>
			<span id="showResult">${requestScope.theMessage}</span>
		</div>
	</div>
</body>
</html>