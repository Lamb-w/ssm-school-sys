<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theStudent" value="${requestScope.student}" scope="page"/>
<c:set var="theListDepartments" value="${requestScope.listDepartments}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改学生</title>
<link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
	<script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
	<script src='${theContextPath}/plugin/My97DatePicker/WdatePicker.js'></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.config.js"></script>
	<script src="${theContextPath}/plugin/UEditor/ueditor.all.min.js"> </script>
	<script src="${theContextPath}/plugin/UEditor/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
var defaultCardTypeCardNoLength=18;
var majorOKFlag = true, contactPhoneOKFlag = true, idCardOKFlag = true;
var ue, $idO, $sNoO, $stuNameO, $departmentIdO, $majorIdO, $contactPhoneO, $idCardIdO, $cardNoO, $issuingAuthorityO, $btnSubmitO;

$(function(){
	var ue = UE.getEditor('editor', {initialFrameWidth:'100%',initialFrameHeight:400});
	ue.autoHeightEnabled = false;

	$idO = $("#id");
	$stuNameO = $("#stuName");

	$departmentIdO = $("#departmentId");
	var theOriginalDepartmentId = ${theStudent.department.id};
	$departmentIdO.val(theOriginalDepartmentId);
	$departmentIdO.change(function () {
		theDepartmentIdV = $departmentIdO.val();
		setMajorContent(theDepartmentIdV);
		if(majorOKFlag && contactPhoneOKFlag && idCardOKFlag){
			$btnSubmitO.prop("disabled", false);
		} else {
			$btnSubmitO.prop("disabled", true);
		}
	});

	$majorIdO = $("#majorId");
	setMajorContent(theOriginalDepartmentId);
	$majorIdO.val(${theStudent.major.id});

	$contactPhoneO = $("#contactPhone");
	$idCardIdO = $("#idCardId");
	$cardNoO = $("#cardNo");
	$issuingAuthorityO = $("#issuingAuthority");
	$btnSubmitO = $("#btnSubmit");

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
				if(majorOKFlag && contactPhoneOKFlag && idCardOKFlag){
					$btnSubmitO.prop("disabled", false);
				} else {
					$btnSubmitO.prop("disabled", true);
				}
			}
			$majorIdO.html(optionsStr);
		}
	);
}
function ajaxValidateStudent(theFieldType) {
    var fieldValue, remindId, fieldName;
    if(theFieldType=="2"){
    	fieldValue = $contactPhoneO.val().trim();
    	remindId="contactPhoneRemind";
    	fieldName="联系电话";
    }
    if(fieldValue=="") {
    	$("#"+remindId).html(""); 
    	return;
    }
    $.ajax({
        type:"POST",
        url:"${theContextPath}/admin/isOtherExistSame",
        data:JSON.stringify({"fieldValue":fieldValue, "fieldType":theFieldType, "id":$idO.val()}),
        contentType : "application/json;charset=UTF-8",
        success:function(resultData){
        	if (true == resultData) {//不能添加
                $("#"+remindId).html("<span class='validError'>该" + fieldName + "已存在！</span>");
				contactPhoneOKFlag = false;
            } else{
            	$("#"+remindId).html("<span class='validSuccess'>可以修改</span>");//如果没有被添加过，将提示语清空。
				if(theFieldType == "2"){
					contactPhoneOKFlag = true;
				}
            }
			if(contactPhoneOKFlag && idCardOKFlag){
				$btnSubmitO.prop("disabled", false);
			} else {
				$btnSubmitO.prop("disabled", true);
			}
        }
    });
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
    } else if(fieldValue.length!=defaultCardTypeCardNoLength){
		theMessageInfo = "身份证号码必须是"+defaultCardTypeCardNoLength+"位！"
		$("#"+remindId).html(theMessageInfo);
		idCardOKFlag = false;
		$btnSubmitO.prop("disabled", true);
		return;
	} 
    $.ajax({
        type:"POST",
        url:"${theContextPath}/admin/isOtherExistSameCard",
        data:JSON.stringify({"fieldValue":fieldValue, "id":$idCardIdO.val()}),
        contentType : "application/json;charset=UTF-8",
        success:function(resultData){
        	if (true == resultData) {//不能修改
                $("#"+remindId).html("<span class='validError'>该" + fieldName + "已存在！</span>");
            	idCardOKFlag = false
            } else{
            	$("#"+remindId).html("<span class='validSuccess'>可以修改</span>");
            	idCardOKFlag = true;
            }
			if(contactPhoneOKFlag && idCardOKFlag){
				$btnSubmitO.prop("disabled", false);
			} else {
				$btnSubmitO.prop("disabled", true);
			}
        }
    })
}
function checkValid(){ //学生的学号、电话、身份证号都不能重复添加！
	var theStuNameV = $stuNameO.val().trim();
	var theIssuingAuthorityV = $issuingAuthorityO.val().trim();
	if(theStuNameV==""){
		alert("姓名不能为空！");
		$stuNameO.select();
	} else if(theIssuingAuthorityV==""){
		alert("身份证发证机构不能为空！");
		$issuingAuthorityO.select();
	} else if($("#startDate").val()=="" || $("#endDate").val()==""){
		alert("身份证有效期起止日期都不能为空！");					
	} else{
		return true;
	}		
	return false;
}	
function processInputStatus(theO, theOForShowID, maxLength){
	var theInputLength=theO.value.length, theRemainingLength=maxLength-theInputLength;
	$("#"+theOForShowID).html("已输<b class='strong'>"+theInputLength+"</b>个字符，还可输<b class='strong'>"+theRemainingLength+"</b>个"); // theO.value.trim().length 既然是实时统计已输个数，还是不要trim了。
}
function ajaxImageFileUpload(theO){
	var theImageFileV = theO.value.trim();
	if(theImageFileV==""){ // 并未选资源
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
        		document.getElementById("imagePreview").innerHTML="<img src='${theContextPath}/${myUtils.getTempDirectory()}"+theImageURL+"' width='50' height='50'/>";
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
		<h2 style="text-align:center;">修改学生</h2>
		<form action="${theContextPath}/admin/doUpdateStudent" method="post" onsubmit="return checkValid();">
			<input type="hidden" value="${theStudent.id }" name="id" id="id"/>
			<input type="hidden" value="${theStudent.sNo }" name="sNo"/>
			<table class="alignCenter" style="width: 100%;">
				<tr>
					<th class="alignRight" style='width:80px;'>学号</th>
					<td><span class="readonly">${theStudent.sNo}</span></td>
				</tr>
				<tr>
					<th class="alignRight">密码</th><td><input type="text" name="sPwd" value='${theStudent.sPwd}' size='30'>留空表示是默认(证件号码后6位)</td>
				</tr>
				<tr>
					<th class="alignRight">姓名</th><td><input type="text" name="name" id="stuName" value='${theStudent.name}' size='5'><span class="required">*</span></td>
				</tr>
				<tr>
					<th class="alignRight">性别</th>
					<td>
					<c:set var="theGender" value="${theStudent.gender}"/>
					<c:if test="${theGender=='男'}">
						[<input type="radio" name="gender" value="男" checked="checked">男] [<input type="radio" name="gender" value="女">女]
					</c:if>
					<c:if test="${theGender=='女'}">
						[<input type="radio" name="gender" value="男">男] [<input type="radio" name="gender" value="女" checked="checked">女]
					</c:if>						
					</td>
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
					<th class="alignRight">联系电话</th><td><input type="text" name="contactPhone" id="contactPhone" value="${theStudent.contactPhone}" onblur="ajaxValidateStudent('2')" size="30" maxlength="50"><span class="required">*，不能和别人重复</span><span id="contactPhoneRemind"></span></td>
				</tr>				
				<tr>
					<td colspan="2">
						<c:set var="theIdCard" value="${theStudent.idCard}"/>
						<input type="hidden" value="${theIdCard.id }" name="idCard.id" id="idCardId"/>
						<fieldset style="width: 650px; margin-left:70px;margin-bottom:5px;">
							<legend>身份证（每项均不能为空）</legend>
							<br>
							号码：<input type="text" name="idCard.cardNo" id="cardNo" value="${theIdCard.cardNo}" maxlength="18" size="20" onkeyup="processInputStatus(this, 'showInputStatusForCardNo', 18);" onblur="ajaxValidateCard()"><span class="required">不能和别人重复</span><span id="showInputStatusForCardNo"></span> <span id="cardNoRemind"></span><br>
							发证机关：<input type="text" name="idCard.issuingAuthority" id="issuingAuthority"  value="${theIdCard.issuingAuthority}" size="50"><br>
							有效期：<input type="text" readonly='readonly' name='idCard.expireDateStart' id="startDate" value="${theIdCard.expireDateStart}" class="Wdate" size="10" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', maxDate:'#F{$dp.$D(\'endDate\')}'})" /> -
                <input type="text" readonly='readonly' name='idCard.expireDateEnd' id="endDate" value="${theIdCard.expireDateEnd}" class="Wdate" size="10" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd', minDate:'#F{$dp.$D(\'startDate\')}'})" />
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
						<input type="file" name="imageFile" id="theImageFile" onchange="ajaxImageFileUpload(this);"><br>
						<span id="imagePreview"></span>						
						<input type="hidden" name="image" id="theImage" value="${theImageOriginal}"/>
					</td>
				</tr>
				<tr>
					<th class="alignRight">介绍</th>
					<td>
						<textarea id="editor" name="memo">${theStudent.memo }</textarea>
					</td>
				</tr>					
				<tr>
					<td colspan="2" class="alignCenter">
						<input type="submit" value="确定" id="btnSubmit"> <input type="reset" value="重填" class="btn">
					</td>
				</tr>													
			</table>		
		</form>
		<div class="posCenter navDiv alignCenter">
			<a href="${theContextPath}/admin/toAdminMain">管理员首页</a> <a href="${theContextPath}/admin/findStudents">管理学生信息</a>
			<br>${requestScope.theMessage }
		</div>
	</div>
</body>
</html>