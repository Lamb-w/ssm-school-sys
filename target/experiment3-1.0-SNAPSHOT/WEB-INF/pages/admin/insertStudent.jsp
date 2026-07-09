<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theListDepartments" value="${requestScope.listDepartments}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>添加学生</title>
<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
<script src='${theContextPath}/plugin/My97DatePicker/WdatePicker.js'></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.config.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.all.min.js"> </script>
	<script src="${theContextPath}/plugin/UEditor/lang/zh-cn/zh-cn.js"></script>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
<script type="text/javascript">
	var defaultSNoLength=9, defaultCardTypeCardNoLength=18;
	var sNoOKFlag = false, majorOKFlag = false, contactPhoneOKFlag = false, idCardOKFlag = false;
	var ue, $sNoO, $stuNameO, $departmentIdO, $majorIdO, $contactPhoneO, $cardNoO, $issuingAuthorityO, $btnSubmitO;

	$(function(){
		ue = UE.getEditor('editor', {initialFrameWidth:'100%',initialFrameHeight:400});
		ue.autoHeightEnabled = false;
		$sNoO = $("#sNo");
		$stuNameO = $("#stuName");
		$departmentIdO = $("#departmentId");
		$majorIdO = $("#majorId");
		$contactPhoneO = $("#contactPhone");
		$cardNoO = $("#cardNo");
		$issuingAuthorityO = $("#issuingAuthority");
		$btnSubmitO = $("#btnSubmit");

		theDepartmentIdV = $departmentIdO.val();
		setMajorContent(theDepartmentIdV);
		
		$departmentIdO.change(function () {
			theDepartmentIdV = $departmentIdO.val();
			setMajorContent(theDepartmentIdV);
			if(sNoOKFlag && majorOKFlag && contactPhoneOKFlag && idCardOKFlag){
				$btnSubmitO.prop("disabled", false);
			} else {
				$btnSubmitO.prop("disabled", true);
			}
		});
	});
	function setMajorContent(theDepartmentId){
		$.get(
			"${theContextPath}/findMajorsByDepartmentId",
			{"departmentId":theDepartmentId},
			function (resultData) {
				$majorIdO.empty();
				var optionsStr = "";
				$.each(resultData, function(index, item) {
					optionsStr = optionsStr + "<option value='" + item.id + "'>" + item.name + "</option>";
				});
				if(optionsStr == ""){
					optionsStr = "<option value='-1'>已选的院系中暂无专业</option>";
					majorOKFlag = false;
					$btnSubmitO.prop("disabled", true);
				} else {
					majorOKFlag = true;
				}
				$majorIdO.html(optionsStr);
			}
		);
	}
function ajaxValidateStudent(theFieldType) { // 添加时，学号、手机、身份证号 三个字段 不能重复。
    var fieldValue, remindId, fieldName;
    if(theFieldType=="1"){
    	fieldValue = $sNoO.val().trim();
    	remindId="sNoRemind";
    	fieldName="学号";
    	if(fieldValue.length!=defaultSNoLength){
    		theMessageInfo = "学号必须是"+defaultSNoLength+"位！"
    		$("#"+remindId).html(theMessageInfo);
			sNoOKFlag = false;
    		return;
    	} 
    } else if(theFieldType=="2"){
    	fieldValue = $contactPhoneO.val().trim();
    	remindId="contactPhoneRemind";
    	fieldName="联系电话";
		contactPhoneOKFlag = false;
    }
    if(fieldValue=="") {
    	$("#"+remindId).html("");
		sNoOKFlag = false;
		contactPhoneOKFlag = false;
    	return;
    }
    $.ajax({
        type:"POST",
        url:"${theContextPath}/admin/isExistSame",
        data:JSON.stringify({"fieldValue":fieldValue, "fieldType":theFieldType}),
        contentType : "application/json;charset=UTF-8",
        success:function(resultData){
        	if (true == resultData) {//不能添加
                $("#"+remindId).html("<span class='validError'>该" + fieldName + "已被添加过！</span>");
            } else{
            	$("#"+remindId).html("<span class='validSuccess'>可以添加</span>");//如果没有被添加过，将提示语清空。
            	if(theFieldType == "1"){
					sNoOKFlag = true;
				} else if(theFieldType == "2"){
					contactPhoneOKFlag = true;
				}
            }
        }
    });
	if(sNoOKFlag && majorOKFlag && contactPhoneOKFlag && idCardOKFlag){
		$btnSubmitO.prop("disabled", false);
	} else {
		$btnSubmitO.prop("disabled", true);
	}
}
function ajaxValidateCard() {
    var fieldValue, remindId, fieldName;
    var theMessageInfo="";
    fieldValue = $cardNoO.val().trim();
	remindId="cardNoRemind";
	fieldName="身份证号";
	if(fieldValue=="") {
    	$("#"+remindId).html(""); 
    	return;
    } else if(fieldValue.length!=defaultCardTypeCardNoLength){ // 身份证必须是输入了满18位 否则直接提示位数不够
		theMessageInfo = "身份证号码必须是"+defaultCardTypeCardNoLength+"位！"
		//alert(theMessageInfo);
		$("#"+remindId).html(theMessageInfo);
		idCardOKFlag = false;
		return;
	} 
    $.ajax({
        type:"POST",
        url:"${theContextPath}/admin/isExistSameCard",
        data:JSON.stringify({"fieldValue":fieldValue}),
        contentType:"application/json;charset=UTF-8",
        success:function(resultData){
        	if (true == resultData) {//不能添加
                $("#"+remindId).html("<span class='validError'>该" + fieldName + "已被添加过！</span>");
            	idCardOKFlag = false;
            } else{
            	$("#"+remindId).html("<span class='validSuccess'>可以添加</span>");//如果没有被添加过，将提示语清空。
            	idCardOKFlag = true;
            }
			if(sNoOKFlag && majorOKFlag && contactPhoneOKFlag && idCardOKFlag){
				$btnSubmitO.prop("disabled", false);
			} else {
				$btnSubmitO.prop("disabled", true);
			}
        }
    });
}
function checkValid(){
	var theStuNameV = $stuNameO.val().trim();
	var theIssuingAuthorityV = $issuingAuthorityO.val().trim();
	if(theStuNameV==""){
		alert("姓名不能为空！");
		$stuNameO.select();
	} else if(theIssuingAuthorityV==""){
		alert("身份证发证机构不能为空！");
		$issuingAuthorityO.select();
	} else if($("#startDateId").val()=="" || $("#endDateId").val()==""){
		alert("身份证有效期起止日期都不能为空！");					
	} else{
		return true;
	}		
	return false;
}	
function processInputStatus(theO, theOForShowID, maxLength){
	var theOV = theO.value, theInputLength = theOV.length, theRemainingLength = maxLength - theInputLength;
	if(theRemainingLength<0){
		theO.value = theO.substring(0, maxLength);
		theInputLength = maxLength;
		theRemainingLength = 0;
	} 
	$("#"+theOForShowID).html("已输<b class='strong'>"+theInputLength+"</b>个字符，还要输<b class='strong'>"+theRemainingLength+"</b>个"); // theO.value.trim().length 既然是实时统计已输个数，还是不要trim了。
}
function ajaxImageFileUpload(theO){
	var theImageFileV = theO.value.trim();
	if(theImageFileV==null || theImageFileV==""){ // 并未选资源
		document.getElementById("imagePreview").innerHTML="<span class='validError'>并未选任何图片！</span>";
		return;
	} else{
		var thePointPos= theImageFileV.lastIndexOf(".");
		if(thePointPos==-1 || thePointPos==theImageFileV.length-1){
			alert('必选选一个图片！');
			return ;
		}else{
			var theSuffix=theImageFileV.substring(thePointPos+1);
			if(!(theSuffix=="png" || theSuffix=="jpg" || theSuffix=="jpeg" || theSuffix=="gif")){
				alert('必选选一个后缀是png、jpg/jpeg、gif的格式图片！');
				return;
			} 
		}
	}
	var formData = new FormData();
	formData.append('photo', theO.files[0]);
    $.ajax({
        type:"POST",
        url:"${theContextPath}/admin/ajaxImageFileUpload",
		data:formData,
		contentType:false,
		processData:false,		        
        success:function(resultData){            
        	if (true == resultData.status) {
                var theImageURL = resultData.imageURL;
        		document.getElementById("imagePreview").innerHTML="<img src='${pageContext.request.contextPath}/${myUtils.getTempDirectory()}"+theImageURL+"' width='50' height='50'/>";
                document.getElementById("theImage").value=theImageURL;
            } else{
            	document.getElementById("imagePreview").innerHTML="<span class='fail'>图片未能成功上传</span>";
            }
        }
    });
}

</script>	
</head>
<body>
	<div style="width:1200px; margin:0px auto;">
		<div class="pageTitle">添加第<span class="dynamicNumber">${requestScope.totalOfStudents + 1}</span>名学生</div>
		<form action="${theContextPath}/admin/doInsertStudent" method="post" onsubmit="return checkValid();">
			<table style="margin:0px auto;" class="posCenter">
				<tr>
					<th class="alignRight" style="width:70px;">学号</th>
					<td><input type="text" name="sNo" size="11" maxlength="9" id="sNo" onkeyup="processInputStatus(this, 'showInputStatusForSNo', defaultSNoLength);" onblur="ajaxValidateStudent('1')"><span class="required">*</span><span id="showInputStatusForSNo"></span> <span id="sNoRemind"></span></td>
				</tr>
				<tr>
					<th class="alignRight">密码</th><td><input type="text" name="sPwd" size="30">留空表示是默认(证件号码后6位)</td>
				</tr>							
				<tr>
					<th class="alignRight">姓名</th><td><input type="text" name="name" id="stuName" size="5"><span class="required">*</span></td>
				</tr>
				<tr>
					<th class="alignRight">性别</th><td>[<input type="radio" name="gender" value="男" checked="checked">男] [<input type="radio" name="gender" value="女">女]</td>
				</tr>
				<tr>
					<th class="alignRight">院系</th>
					<td>
						<select name="department.id" id="departmentId">
							<c:forEach items="${theListDepartments}" var="item">
								<option value="${item.id}">${item.name}</option>
							</c:forEach>
						</select> 专业<select name="major.id" id="majorId"></select>
					</td>
				</tr>
				<tr>
					<th class="alignRight">联系电话</th><td><input type="text" name="contactPhone" id="contactPhone" onblur="ajaxValidateStudent('2')" size="30" maxlength="50"><span class="required">*，不能和别人重复</span><span id="contactPhoneRemind"></span></td>
				</tr>				
				<tr>
					<td colspan="2">
						<fieldset style="width: 650px; margin-left:70px;margin-bottom:5px;">
							<legend>身份证（每项均不能为空）</legend>
							号码：<input type="text" name="idCard.cardNo" id="cardNo" size="20" maxlength="18" onkeyup="processInputStatus(this, 'showInputStatusForCardNo', defaultCardTypeCardNoLength);" onblur="ajaxValidateCard()"><span class="required">不能和别人重复</span><span id="showInputStatusForCardNo"></span> <span id="cardNoRemind"></span><br>
							发证机关：<input type="text" name="idCard.issuingAuthority" id="issuingAuthority"> 有效期：<input type="text" readonly='readonly' name='idCard.expireDateStart' id="startDateId" class="Wdate" size="10" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', maxDate:'#F{$dp.$D(\'endDateId\')}'})" /> -
                <input type="text" readonly='readonly' name='idCard.expireDateEnd' id="endDateId" class="Wdate" size="10" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', minDate:'#F{$dp.$D(\'startDateId\')}'})" />
						</fieldset>
					</td>
				</tr>
				<tr>
					<th class="alignRight">图片</th>
					<td>
						
						<input type="file" name="imageFile" id="theImageFile" onchange="ajaxImageFileUpload(this);"><br>
						<span id="imagePreview"></span>						
						<input type="hidden" name="image" id="theImage"/>
					</td>
				</tr>
				<tr>
					<th class="alignRight">介绍</th>
					<td><textarea id="editor" name="memo"></textarea></td>
				</tr>	
				<tr>
					<td colspan="2" class="alignCenter">
						<input type="submit" value="确定" id="btnSubmit" class="btn" disabled> <input type="reset" value="重填" class="btn"/>
					</td>
				</tr>													
			</table>		
		</form>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/findStudents">管理学生信息</a>
			<hr>${requestScope.theMessage }
		</div>
	</div>
</body>
</html>