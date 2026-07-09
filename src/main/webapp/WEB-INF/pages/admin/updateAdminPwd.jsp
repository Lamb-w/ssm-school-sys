<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContext" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>修改管理员密码</title>
    <style>
        .loginInput{
            font-size:20px;
        }

    </style>
    <link href="${theContext}/css/myCSS.css" type="text/css" rel="stylesheet"/>
    <script src="${theContext}/js/jquery-4.0.0.min.js"></script>
    <script>
        var $adminPwdO, $newAdminPwdO, $newAdminPwdAgainO, $checkCodeO, $btnSubmitO;
        var $showCheckCodeResultO;
        var theRequiredCheckCodeLength = 4, currentCheckCodeLength;
        $(function () {
            $adminPwdO = $("#adminPwd");
            $newAdminPwdO = $("#newAdminPwd");
            $newAdminPwdAgainO = $("#newAdminPwdAgain");
            $checkCodeO = $("#checkCode");
            $showCheckCodeResultO = $("#showCheckCodeResult");
            $btnSubmitO = $("#btnSubmit");

            $checkCodeO.keyup(function(){
                var theCheckCodeContent = $checkCodeO.val().trim();
                currentCheckCodeLength = theCheckCodeContent.length;
                if(currentCheckCodeLength < theRequiredCheckCodeLength){
                    $showCheckCodeResultO.html("已输入" + currentCheckCodeLength + "位，还要输" + (theRequiredCheckCodeLength - currentCheckCodeLength) + "位！");
                    if(!$btnSubmitO.prop("disabled")){
                        $btnSubmitO.prop({"disabled": true});
                    }
                } else{
                    $(this).blur();
                }
            }).blur(function () {
                var theCheckCodeContent = $checkCodeO.val().trim();
                currentCheckCodeLength = theCheckCodeContent.length;
                if(currentCheckCodeLength == theRequiredCheckCodeLength){
                    processCheckCodeValidateForJava(theCheckCodeContent);
                } else{
                    // 不做内容
                }
            });
        });
        function processCheckCodeValidateForJava(theCheckCode){
            $.ajax({
                url:"${theContext}/validateCheckCodeInView",
                method:"get",
                data:{"checkCode": theCheckCode},
                success:function (result) {
                    if(result){
                        $showCheckCodeResultO.html("验证码正确！").addClass("success").removeClass("fail"); // 链式调用方法
                        $btnSubmitO.prop("disabled", false);
                    } else{
                        $showCheckCodeResultO.html("验证码错误！").addClass("fail").removeClass("success");
                        $btnSubmitO.prop("disabled", true);
                        alert("要按验证码图片上的内容输入验证码，不分大小写！");
                    }
                }
            });
        }
        function check(){
            var adminPwdV = $adminPwdO.val().trim(), newAdminPwdV = $newAdminPwdO.val().trim(), newAdminPwdAgainV = $newAdminPwdAgainO.val().trim();
            if(adminPwdV==""){
                alert("密码非空且不能是连续的空格！");
                $adminPwdO.select();
                return false;
            } else if(newAdminPwdV==""){
                alert("新密码非空且不能是连续的空格！");
                $newAdminPwdO.select();
                return false;
            } else if(newAdminPwdAgainV != newAdminPwdV){
                alert("两次新密码必须要相同！");
                $newAdminPwdAgainO.val("");
                $newAdminPwdO.select();
                return false;
            }
            return true;
        }

    </script>
</head>
<body>
<div class="mainArea">
    <form method="post" action="${theContext}/admin/doUpdateAdminPwd" onsubmit="return check();">
        <table style="margin-top:100px;" class="posCenter">
            <tr><td height="30" colspan="2" style="color: #FFF; background-color: #3A8ECD;" class="alignCenter">修改管理员密码</td></tr>
             <tr>
                <td height="30"  class="alignRight">账号：</td>
                <td class="alignLeft">
                    <input type="text" name="userName" id="adminName" value="${sessionScope.administrator.adminName}" readonly class="loginInput, readonlyInputText" style="width:150px;"/>  <%--- <input type="text" name="login_name" class="loginInput" style="width:150px;"/> --%>
                </td>
            </tr>
            <tr><td height="30" class="alignRight">原密码：</td>
                <td class="alignLeft"><input type="password" name="userPwd" id="adminPwd" class="loginInput" style="width:150px;"/></td>
            </tr>
            <tr><td height="30" class="alignRight">新密码：</td>
                <td class="alignLeft"><input type="password" name="userPwdNew" id="newAdminPwd" class="loginInput" style="width:150px;"/></td>
            </tr>
            <tr><td height="30" class="alignRight">重输新密码：</td>
                <td class="alignLeft"><input type="password" name="userPwdNewAgain" id="newAdminPwdAgain" class="loginInput" style="width:150px;"/></td>
            </tr>
            <tr>
                <td class="alignRight">验证码：</td>
                <td>
                    <input name="checkCode" id="checkCode"  maxlength="4" class="checkCodeInput" style="width:120px;"><span class="required">*</span><img src="${theContext}/checkCode" title="点击刷新" alt="点击刷新"  class="passCode" style="height:26px;cursor:pointer;" onclick="this.src=this.src+'?'+Math.random(); $checkCodeO.val('').keyup();">
                    <br><span id="showCheckCodeResult"></span>
                </td>
            </tr>
            <tr>
                <td height="30" colspan="2" class="alignCenter">
                    <input type="submit" name="btnSubmit" id="btnSubmit" value="提交" class="btn" disabled />&nbsp;
                    <input type="reset" name="btnReset" id="btnReset" value="重置" class="btn" />
                </td>
            </tr>
        </table>

    </form>
    <div class="posCenter navDiv alignCenter">
        <a href="${theContext}/admin/toAdminMain">管理员首页</a> <a href="${theContext}">系统首页</a>
        <br>${requestScope.theMessage}
    </div>
</div>
</body>
</html>