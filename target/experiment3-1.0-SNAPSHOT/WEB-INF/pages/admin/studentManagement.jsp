<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<c:set var="theListDepartments" value="${requestScope.listDepartments}"/>
<c:set var="thePageMsg" value="${requestScope.pageMsg}" scope="page"/>
<c:set var="theListStudents" value="${thePageMsg.lists}" scope="page"/>
<c:set var="theCurrentPage" value="${thePageMsg.currPage}"/>

<c:set var="theQueryCondition" value="${sessionScope.queryCondition}"/>
<c:set var="theStudent" value="${theQueryCondition.student}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>学生管理</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
<script>
	var majorOKFlag = true, defaultCardTypeCardNoLength=18;
	var $departmentIdO, $majorIdO, $showInputStatusO, $btnSubmitO;
	var theStudentExistFlag, theOriginalDepartmentId, theOriginalMajorId = -1;
	$(function(){
		$departmentIdO = $("#departmentId");
		$majorIdO = $("#majorId");
		$showInputStatusO = $("#showInputStatus");
		$btnSubmitO = $("#btnSubmit");

		$departmentIdO.change(function () {
			theDepartmentIdV = $departmentIdO.val();
			theOriginalMajorId = -1;
			$majorId0 = $("#majorId");
		});

	<c:if test="${theStudent == null}"> <%-- // 对应两种情形：1、提交的搜索条件中，没有能封装在Student类中的特征（只要提交搜索了，就不可能是null）。 2、根据没点搜索就是在学生管理界面中单纯地上下翻页而已。 --%>
		theStudentExistFlag = false;
		theOriginalDepartmentId = -1;
		theOriginalMajorId = -1;
		$departmentIdO.val(-1);
		$majorIdO.html("<option value='-1'>先选院系，再定专业</option>");
		$majorIdO.val(-1);
	</c:if>
	<c:if test="${theStudent != null}">
		theStudentExistFlag = true;
		theOriginalDepartmentId = ${theStudent.department.id};
		theOriginalMajorId = ${theStudent.major.id};
		$departmentIdO.val(theOriginalDepartmentId);
		setMajorContent(theOriginalDepartmentId);
	</c:if>
	});

	function setMajorContent(theDepartmentId){
		if(theDepartmentId == -1){
			$majorIdO.html("<option value='-1' class='required'>先选院系，再定专业</option>");
		} else{
			$.get(
				"${theContextPath}/findMajorsByDepartmentId",
				{"departmentId":theDepartmentId},
				function (resultData) {
					$majorIdO.empty();
					var initOption = "<option value='-1'>不限</option>", optionsStr = "";
					$.each(resultData, function(index, item) {
						optionsStr = optionsStr + "<option value='" + item.id + "'>" + item.name + "</option>";
					});
					if(optionsStr == ""){
						optionsStr = "<option value='-1'>已选的院系中暂无专业</option>";
						$majorIdO.html(optionsStr);
						majorOKFlag = false;
						$btnSubmitO.prop("disabled", true);
					} else {
						$majorIdO.html(initOption + optionsStr);
						majorOKFlag = true;
						$btnSubmitO.prop("disabled", false);
					}
					$majorIdO.val(theOriginalMajorId);
				}
			);
		}

	}
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
			location.href="${theContextPath}/admin/findStudents?currentPage="+thePageNo;
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
		//alert("OK"); // OK
		document.getElementById(theShowId).style.visibility="visible";
		document.getElementById(theHiddenId).style.visibility="hidden";
	}
	function processInputStatus(theO, maxLength){
		var theInputLength=theO.value.length, theRemainingLength = maxLength - theInputLength;
		$showInputStatusO.html("已输<b class='strong'>"+theInputLength+"</b>个字符，还可输<b class='strong'>"+theRemainingLength+"</b>个"); // theO.value.trim().length 既然是实时统计已输个数，还是不要trim了。
	}
</script>
</head>
<body>
	<div style="width:1200px; margin:0px auto;">
		<h2 style="text-align:center;">学生管理</h2>
	<c:set var="theListStudentsSize" value="${theListStudents.size()}"/>
		<form action="${theContextPath}/admin/findStudentByIdOrSomeStudentsWithPage" method="post" onsubmit="return checkValid(this);">
			<div id="queryArea" style="margin:0px auto; width:800px;">
				<div id="uniqueQuery" style="border-bottom:1px solid green; margin-bottom:2px;">
					<div id="selectUniqueQuery" style="width:90px; float:left;"><input type="radio" value="u" name="typeOfQuery" onclick="showHidden('uniqueQueryOperateArea', 'fuzzyQueryOperateArea');"/>精确查询</div>
					<div id="uniqueQueryOperateArea" style="visibility:hidden;">编号<input name="id" size="5"  maxlength="6"></div>
				</div>
				<div style="clear:both;"></div>
				<div id="fuzzyQuery" style="">
					<div id="selectFuzzyQuery" style="width:90px;float:left;"><input type="radio" value="f" name="typeOfQuery" checked="checked"  onclick="showHidden('fuzzyQueryOperateArea', 'uniqueQueryOperateArea');"/>模糊查询</div>
					<div id="fuzzyQueryOperateArea" style="border:1px solid green;float:left;">
						学号<input type="text" name="sNo" id="sNo" value="${theStudent.sNo }"> 姓名<input type="text" name="name" value="${theStudent.name }"> 性别
						<c:choose>
							<c:when test="${theStudent==null or theStudent.gender=='-1'}">
								<input type="radio" name="gender" value="-1" checked="checked">不限 <input type="radio" name="gender" value="男">男 <input type="radio" name="gender" value="女">女<br>
							</c:when>
							<c:when test="${theStudent.gender=='男'}">
								<input type="radio" name="gender" value="-1">不限 <input type="radio" name="gender" value="男" checked="checked">男 <input type="radio" name="gender" value="女">女<br>
							</c:when>
							<c:otherwise>
								<input type="radio" name="gender" value="-1">不限 <input type="radio" name="gender" value="男">男 <input type="radio" name="gender" value="女" checked="checked">女<br>
							</c:otherwise>					
						</c:choose>
						院系 <select name="department.id" id="departmentId">
								<option value="-1">不限</option>
						<c:forEach items="${theListDepartments}" var="item">
								<option value="${item.id}">${item.name}</option>
						</c:forEach>
					</select> 专业<select name="major.id" id="majorId"></select><br>
						电话<input name="contactPhone" value="${theStudent.contactPhone}">
						身份证号码<input name="idCard.cardNo" id="cardNo" value="${theStudent.idCard.cardNo}" size="20" maxlength="18" onkeyup="processInputStatus(this, defaultCardTypeCardNoLength);"><span id="showInputStatus"></span><br>
					</div>
				</div>
				<div style="clear:both;"></div>
				<div style="text-align:center;"><input type="submit" value="查询" class="searchBtn" id="btnSubmit"> <input type="reset" value="重填"></div>
				<hr>
			</div>
		</form>		
	<c:if test="${theListStudents==null }">
		<div style="text-align:center">没有学生</div>
	</c:if>
	<c:if test="${theListStudents!=null }">
		<c:set var="thePageSize" value="${thePageMsg.pageSize}"/>
		<c:set var="theTotalCount" value="${thePageMsg.totalCount}"/>
		<c:set var="theTotalPage" value="${thePageMsg.totalPage}"/>
		<c:set var="thePageIndexStart" value="${(theCurrentPage-1)*thePageSize }"/>	
		<table class="posCenter">
			<tr>
				<th>总序号</th><th>页中序号</th><th>编号 图片</th><th>学号</th><th>姓名</th><th>性别</th><th>院系</th><th>专业</th><th>联系电话</th><th>身份证号</th>
				<th>详细</th><th>修改</th><th>删除</th>
			</tr>
	<c:forEach items="${theListStudents}" var="student" varStatus="theStatus">
		<c:set var="theId" value="${student.id }"/>
			<tr>
				<td>${thePageIndexStart+theStatus.index+1}</td><td>${theStatus.index+1}</td>
				<td>${theId }
					<c:set var="theImageOriginal" value="${myUtils.trim(student.image)}"/>
					<c:choose>
						<c:when test="${theImageOriginal==null or theImageOriginal==''}">
							无图
						</c:when>
						<c:otherwise>
							<img id="imageOriginal" src="${theContextPath}/${myUtils.getImageSrc(1,theImageOriginal)}" width="50" height="50"/>
						</c:otherwise>
					</c:choose>
				</td>
				<td>${student.sNo }</td><td>${student.name }</td><td>${student.gender }</td>
				<td>${student.department.name}</td><td>${student.major.name}</td>
				<td>${student.contactPhone }</td><td>${student.idCard.cardNo}</td>
				<td class="operate"><a href="${theContextPath}/admin/showDetailStudent?id=${theId}">详细</a></td>
				<td class="operate"><a href="${theContextPath}/admin/toUpdateStudent?id=${theId}">修改</a></td>
				<td class="operate"><a href="${theContextPath}/admin/deleteStudent?id=${theId}&currentPage=${theCurrentPage}" onclick="return confirm('确定删除学生？');">删除</a></td>
			</tr>	
	</c:forEach>	
		</table>
		<div class="alignCenter">本页共有<span class="strong">${theListStudentsSize}</span>条学生记录</div>
		<br>
		<table class="posCenter">
			<tr>
			<td class="td2">
			   <span>第${theCurrentPage }/ ${theTotalPage}页</span>&nbsp;&nbsp;
			   <span>总记录数：${theTotalCount }&nbsp;&nbsp;每页:${thePageSize}</span>&nbsp;&nbsp;
			   <span>
			       <c:if test="${theCurrentPage > 1}">
			           <a href="${theContextPath}/admin/findStudents?currentPage=1">[首页]</a>&nbsp;&nbsp;
			           <a href="${theContextPath}/admin/findStudents?currentPage=${theCurrentPage-1}">[上一页]</a>&nbsp;&nbsp;
			       </c:if>
			
			       <c:if test="${theCurrentPage < theTotalPage}">
			           <a href="${theContextPath}/admin/findStudents?currentPage=${theCurrentPage+1}">[下一页]</a>&nbsp;&nbsp;
			           <a href="${theContextPath}/admin/findStudents?currentPage=${theTotalPage}">[尾页]</a>&nbsp;&nbsp;
			       </c:if>
			       		<button onclick="gotothePage()" id="btnGo">转到</button> <input type="text" id="pageNo" value="${theCurrentPage }" size="4"  onkeypress="enterHandler(event);"> 
			   </span>
			</td>
			</tr>
		</table>
	</c:if>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/insertStudent">添加学生</a><br>
			${requestScope.theMesssage}
		</div>		
	</div>
</body>
</html>