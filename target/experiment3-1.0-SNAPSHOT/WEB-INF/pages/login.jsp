<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContext" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>登录</title>
    <style>
        .loginInput{
            font-size:20px;
        }

    </style>
    <link href="${theContext}/css/myCSS.css" type="text/css" rel="stylesheet"/>
    <script src="${theContext}/js/jquery-4.0.0.min.js"></script>
    <script>
        var $loginNameO, $loginPwdO, $checkCodeO, $btnSubmitO;
        var $showCheckCodeResultO;
        var theRequiredCheckCodeLength = 4, currentCheckCodeLength;
        $(function () {
            $loginNameO = $("#loginName");
            $loginPwdO = $("#loginPwd");
            $checkCodeO = $("#checkCode");
            $showCheckCodeResultO = $("#showCheckCodeResult");
            $btnSubmitO = $("#btnSubmit");

            $checkCodeO.keyup(function(){ // 当焦点在输入框内期间，键盘弹起事件处理
                var theCheckCodeContent = $checkCodeO.val().trim();
                currentCheckCodeLength = theCheckCodeContent.length;
                if(currentCheckCodeLength < theRequiredCheckCodeLength){
                    $showCheckCodeResultO.html("已输入" + currentCheckCodeLength + "位，还要输" + (theRequiredCheckCodeLength - currentCheckCodeLength) + "位！");
                    if(!$btnSubmitO.prop("disabled")){
                        $btnSubmitO.prop({"disabled": true});
                    }
                } else{
                    $(this).blur(); // 也可写成：$checkCodeO.blur();
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
                //contentType:"application/json; charset:utf-8;", //
                //contentType:"application/x-www-form-urlencoded; charset=UTF-8", // 用contentType的默认值，此时，可省。  证实：contentType这两种值都可。 后端负责接收的形参不加@RequestBody注解，可以是同名的参数，也可以是含有同名的属性的封装类。
                success:function (result) {
                    if(result){
                        $showCheckCodeResultO.html("验证码正确！").addClass("success").removeClass("fail"); // 链式调用方法
                        $btnSubmitO.prop("disabled", false);
                        //$btnSubmitO.attr("disabled", false);
                        //$btnSubmitO.removeAttr("disabled");
                    } else{
                        $showCheckCodeResultO.html("验证码错误！").addClass("fail").removeClass("success");
                        $btnSubmitO.prop("disabled", true);
                        alert("要按验证码图片上的内容输入验证码，不分大小写！");
                    }
                },
                dataType: "json" // dataType默认值是json，此时写成这样，可省。
            });
        }
        function check(){
            var loginNameV = $loginNameO.val();
            var loginPwdV = $loginPwdO.val();
            if(loginNameV.trim()==""){
                alert("账号非空且不能是连续的空格！");
                $loginNameO.select();
                return false;
            } else if(loginPwdV.trim()==""){
                alert("密码非空且不能是连续的空格！");
                $loginPwdO.select();
                return false;
            }
            return true;
        }

    </script>
    <script type="text/javascript">
        // 防止网页被嵌套 确保本页始终在顶部窗口打开
        if(window.location.href != parent.window.location.href){
            top.location.href = window.location.href
        }
    </script>
</head>
<body>
<div class="mainArea">
    <form method="post" action="${theContext}/doLogin" onsubmit="return check();">
        <table style="margin-top:100px;" class="posCenter">
            <tr><td height="30" colspan="2" style="color: #FFF; background-color: #3A8ECD;" class="alignCenter">登录</td></tr>
            <tr>
                <td height="30" style="width:110px;" class="alignRight">角色：</td>
                <td style="width:300px;" class="alignLeft">
                    <input type="radio" name="loginRole" class="" style="" value="1" checked/>用户 <input type="radio" name="loginRole" class="" style="" value="0"/> 管理员
                </td>
            </tr>
            <tr>
                <td height="30"  class="alignRight">账号：</td>
                <td class="alignLeft">
                    <input type="text" name="loginName" id="loginName" class="loginInput" style="width:150px;"/>
                </td>
            </tr>
            <tr><td height="30" class="alignRight">密码：</td>
                <td class="alignLeft"><input type="password" name="loginPwd" id="loginPwd" class="loginInput" style="width:150px;"/></td>
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
        <a href="${theContext}">首页</a>
        <br><span class="fail">${requestScope.loginError}</span>
    </div>
</div>
</body>
</html>