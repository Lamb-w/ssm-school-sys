<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>添加课程</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.config.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.all.min.js"> </script>
	<script src="${theContextPath}/plugin/UEditor/lang/zh-cn/zh-cn.js"></script>
	<script type="text/javascript">
		var ue;
		$(function(){
			ue = UE.getEditor('editor', {initialFrameWidth:'100%', initialFrameHeight:400});
			ue.autoHeightEnabled = false;
		});
var existFlag=0, defaultCNoLength=9;
function ajaxValidateCourse(theFieldType) {
    //alert("OK"); //OK
	var fieldValue, remindId, fieldName;
    if(theFieldType=="1"){
    	fieldValue = $("#cNo").val().trim();
    	remindId="cNoRemind";
    	fieldName="课程号";
    	if(fieldValue.length!=defaultCNoLength){
    		theMessageInfo = "课程号必须是"+defaultCNoLength+"位！"
    		//alert(theMessageInfo);
    		$("#"+remindId).html(theMessageInfo); // 因已确定不含html标签也可用用text()
    		existFlag=0; 
    		return;
    	} 
    } else if(theFieldType=="2"){

    }
    if(fieldValue=="") {
    	$("#"+remindId).html(""); 
    	return;
    }
    $.ajax({
        type:"POST",
        url:"${theContextPath}/admin/isExistSameCourse",
        data:JSON.stringify({"fieldValue":fieldValue, "fieldType":theFieldType}),
        contentType : "application/json;charset=UTF-8",
        dataType:"json",
        success:function(resultData){            
        	if (true == resultData) {
            	$("#"+remindId).html("<span class='validError'>该" + fieldName + "已被添加过！</span>");
            	existFlag=1;
            } else{
            	$("#"+remindId).html("<span class='validSuccess'>可以添加</span>");//如果没有被添加过，将提示语清空。
            	existFlag=0;            	
            }
        }
    });
}

function checkValid(theForm){
	if(existFlag==1){
		alert("课程的课程号不能重复添加！");
		return false;
	}
	var theCNo=theForm.cNo, theCNoV=theCNo.value.trim();
	var theName=theForm.name, theNameV=theName.value.trim();	
	var theCredit=theForm.credit, thCreditV=theCredit.value.trim();
	var theClassHour=theForm.classHour, thClassHourV=theClassHour.value.trim();
	if(theCNoV=="" || theCNoV.length!=defaultCNoLength){
		alert("课程号位数必须是"+defaultCNoLength+"！");
		theCNo.select();
	} else if(theNameV==""){
		alert("课程名不能为空！");
		theName.select();			
	} else if(theCreditV=="" || isNaN(theCreditV) || theCreditV.indexOf(".")!=-1 || parseInt(theCreditV)<=0){
		alert("学分必须是非空的正整数！");
		theCredit.select();			
	} else if(theClassHourV=="" || isNaN(theClassHourV) || theClassHourV.indexOf(".")!=-1 || parseInt(theClassHourV)<=0){
		alert("学时必须是非空的正整数！");
		theClassHour.select();			
	} else{
		return true;
	}		
	return false;
}	
function processInputStatus(theO, theOForShowID, maxLength){
	var theInputLength=theO.value.length, theRemainingLength=maxLength-theInputLength;
	$("#"+theOForShowID).html("已输<b class='strong'>"+theInputLength+"</b>个字符，还可输<b class='strong'>"+theRemainingLength+"</b>个"); // theO.value.trim().length 既然是实时统计已输个数，还是不要trim了。
}
</script>
</head>
<body>
	<div style="width:1200px; margin:0px auto;">
		<h2 style="text-align:center;">添加课程</h2>
		<form action="${theContextPath}/admin/doInsertCourse" method="post" onsubmit="return checkValid(this);">
			<table class="alignCenter" style="width: 100%;">
				<tr>
					<th class="alignRight" style="width: 80px;">课程号</th><td><input type="text" name="cNo" size="11" maxlength="9" id="cNo" onkeyup="processInputStatus(this, 'showInputStatusForCNo', defaultCNoLength);" onblur="ajaxValidateCourse('1')"><span id="showInputStatusForCNo"></span> <span id="cNoRemind"></span></td>
				</tr>			
				<tr>
					<th class="alignRight">课程名</th><td><input type="text" name="name" size="40" maxlength="40"></td>
				</tr>
				<tr>
					<th class="alignRight">学分</th><td><input type="text" name="credit" id="credit" size="3" maxlength="2"></td>
				</tr>	
				<tr>
					<th class="alignRight">学时</th><td><input type="text" name="classHour" id="classHour" size="4" maxlength="3"></td>
				</tr>							
				<tr>
					<th>介绍</th><td><textarea id="editor" name="memo"></textarea></td>
				</tr>	
				<tr>
					<td colspan="2" class="alignCenter"><input type="submit" value="确定" class="btn"> <input type="reset" value="重填" class="btn"></td>
				</tr>													
			</table>		
		</form>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/courseManagement">管理课程信息</a>
			<br>${requestScope.theMessage}
		</div>
		
	</div>
</body>
</html>