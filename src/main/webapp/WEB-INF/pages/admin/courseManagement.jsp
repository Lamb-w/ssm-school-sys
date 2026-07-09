<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theListCredits" value="${requestScope.listCredits}" scope="page"/>
<c:set var="theListClassHours" value="${requestScope.listClassHours}" scope="page"/>
<c:set var="thePageMsg" value="${requestScope.pageMsg}" scope="page"/>
<c:set var="theListCourses" value="${thePageMsg.lists}" scope="page"/>
<c:set var="theCurrentPage" value="${thePageMsg.currPage}"/>  

<c:set var="theQueryCondition" value="${sessionScope.queryCondition}"/>
<c:set var="course" value="${theQueryCondition.course}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>课程管理</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
<script>
	function checkValid(theForm){
		if($("input[name='typeOfQuery']:checked").val()=="u"){ // 精确查询 提交时要保证id是>0的整型值
			var theIdO = theForm.id, theIdV = theIdO.value;
			if(theIdV=="" || isNaN(theIdV) || theIdV.indexOf(".")!=-1 || theIdV <=0 ){
				alert("精确查询时，id值必须是正整数！");
				theIdO.select();
				return false;
			}
		}else{ // 模糊查询  
			theForm.id.value="0"; // 因仍要提交这个id输入元素，所以要将其value设为零(主要目的是非空)以便绑定到int型的变量或封装对象的int型属性上
			
		}
		return true;
	}
	function gotothePage(){
		var thePageNoO=document.getElementById("pageNo");
		var thePageNoStr=thePageNoO.value.trim();
		if(thePageNoStr=="" || isNaN(thePageNoStr) || thePageNoStr.indexOf(".")!=-1){
			alert("页号必须是非空的数值！");
			thePageNoO.select();
		} else{
			var thePageNo = parseInt(thePageNoStr);
			location.href="${theContextPath }/admin/courseManagement?currentPage="+thePageNoStr;
		}
	}
	function enterHandler(event){
		var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
		//如果是回车键
		if (keyCode == 13){
			document.getElementById("btnGo").click();
		}
	}
	function showHidden(theShowId, theHiddenId){
		document.getElementById(theShowId).style.visibility="visible";
		document.getElementById(theHiddenId).style.visibility="hidden";
	}
	$(function(){
		var theCreditInQueryV=$("#theCreditInQuery").val();
		var theClassHourInQueryV=$("#theClassHourInQuery").val();
		if (theCreditInQueryV!=''){
			$("#credit").val(theCreditInQueryV);
		}
		if (theClassHourInQueryV!=''){
			$("#classHour").val(theClassHourInQueryV);
		}		
	});
</script>
</head>
<body>
	<div style="width:1200px; margin:0px auto;">
		<h2 style="text-align:center;">课程管理</h2>
		<c:set var="theListCoursesSize" value="${theListCourses.size()}"/>
		<input id="theCreditInQuery" type="hidden" value="${course.credit}"/>
		<input id="theClassHourInQuery" type="hidden" value="${course.classHour}"/>
		<form action="${theContextPath}/admin/findCourseByIdOrSomeCoursesWithPage" method="post" onsubmit="return checkValid(this);">
			<div id="queryArea" style="margin:0px auto; width:800px;">
				<div id="uniqueQuery" style="border-bottom:1px solid green; margin-bottom:2px;"> <%-- precise exact accurate --%>
					<div id="selectUniqueQuery" style="width:90px; float:left;"><input type="radio" value="u" name="typeOfQuery" onclick="showHidden('uniqueQueryOperateArea', 'fuzzyQueryOperateArea');"/>精确查询</div>
					<div id="uniqueQueryOperateArea" style="visibility:hidden;">编号<input name="id" size="5"  maxlength="6"></div>
				</div>
				<div style="clear:both;"></div>
				<div id="fuzzyQuery" style="">
					<div id="selectFuzzyQuery" style="width:90px;float:left;"><input type="radio" value="f" name="typeOfQuery" checked="checked"  onclick="showHidden('fuzzyQueryOperateArea', 'uniqueQueryOperateArea');"/>模糊查询</div>
					<div id="fuzzyQueryOperateArea" style="border:1px solid green;float:left;">
						课程号<input type="text" name="cNo" id="cNo" value="${course.cNo }"> 课程名<input type="text" name="name" value="${course.name }">						
						学分
						<select name="credit" id="credit">
							<option value="-1">不限</option>
						<c:forEach items="${theListCredits }" var="credit">
							<option value="${credit}">${credit}</option>
						</c:forEach>
						</select>					
						学时
						<select name="classHour" id="classHour">
							<option value="-1">不限</option>
						<c:forEach items="${theListClassHours }" var="classHour">
							<option value="${classHour}">${classHour}</option>
						</c:forEach>
						</select>
					</div>
				</div>
				<div style="clear:both;"></div>
				<div class="alignCenter"><input type="submit" value="查询" class="searchBtn"> <input type="reset" value="重填"></div>
				<hr>
			</div>
		</form>		
	<c:if test="${theListCourses==null }">
		<div class="alignCenter">没有课程</div>
	</c:if>
	<c:if test="${theListCourses!=null }">
		<c:set var="thePageSize" value="${thePageMsg.pageSize}"/>
		<c:set var="theTotalCount" value="${thePageMsg.totalCount}"/>
		<c:set var="theTotalPage" value="${thePageMsg.totalPage}"/>
		<c:set var="thePageIndexStart" value="${(theCurrentPage-1)*thePageSize }"/>	
		<table class="posCenter">
			<tr>
				<th>总序号</th><th>页中序号</th><th>编号</th><th>课程号</th><th>课程名</th><th>学分</th><th>学时</th>
				<th>详细</th><th>修改</th><th>删除</th>
			</tr>
	<c:forEach items="${theListCourses}" var="course" varStatus="theStatus">
		<c:set var="theId" value="${course.id }"/>
			<tr>
				<td>${thePageIndexStart+theStatus.index+1}</td><td>${theStatus.index+1}</td>
				<td>${theId }</td>
				<td>${course.cNo }</td><td>${course.name }</td><td>${course.credit }</td><td>${course.classHour}</td>
				<td class="operate"><a href="${theContextPath}/admin/showDetailCourse?id=${theId}">详细</a></td>
				<td class="operate"><a href="${theContextPath}/admin/toUpdateCourse?id=${theId}">修改</a></td>
				<td class="operate"><a href="${theContextPath}/admin/deleteCourse?id=${theId}&currentPage=${theCurrentPage}" onclick="return confirm('确定删除课程？');">删除</a></td>
			</tr>	
	</c:forEach>	
		</table>
		<div class="alignCenter">本页共有<span class="strong">${theListCourses.size()}</span>条课程记录</div>
		<br>
		<table class="posCenter">
			<tr>
			<td class="td2">
			   <span>第${theCurrentPage }/ ${theTotalPage}页</span>&nbsp;&nbsp;
			   <span>总记录数：${theTotalCount }&nbsp;&nbsp;每页:${thePageSize}</span>&nbsp;&nbsp;
			   <span>
			       <c:if test="${theCurrentPage > 1}">
			           <a href="${theContextPath }/admin/courseManagement?currentPage=1">[首页]</a>&nbsp;&nbsp;
			           <a href="${theContextPath }/admin/courseManagement?currentPage=${theCurrentPage-1}">[上一页]</a>&nbsp;&nbsp;
			       </c:if>
			
			       <c:if test="${theCurrentPage < theTotalPage}">
			           <a href="${theContextPath}/admin/courseManagement?currentPage=${theCurrentPage+1}">[下一页]</a>&nbsp;&nbsp;
			           <a href="${theContextPath}/admin/courseManagement?currentPage=${theTotalPage}">[尾页]</a>&nbsp;&nbsp;
			       </c:if>
			       		<button onclick="gotothePage()" id="btnGo">转到</button> <input type="text" id="pageNo" value="${theCurrentPage }" size="4"  onkeypress="enterHandler(event);"> 
			   </span>
			</td>
			</tr>
		</table>
	</c:if>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/insertCourse">添加课程</a>
			<br>${requestScope.theMesssage}
		</div>		
	</div>
</body>
</html>