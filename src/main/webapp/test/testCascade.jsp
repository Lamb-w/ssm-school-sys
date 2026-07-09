<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="theContextPath" value="${pageContext.request.contextPath}"/>
<jsp:useBean id="myUtils" class="com.javaee.utils.MyUtils"/>
<c:set var="theListDepartments" value="${requestScope.listDepartments}"/>
<html>
<head>
    <title>级联学习</title>
    <link href="${theContextPath}/css/myCSS.css" rel="stylesheet">
    <script src="${theContextPath}/js/jquery-4.0.0.min.js"></script>
    <script>
        var $departmentIdO, $majorIdO, $btnSubmitO, $showResultO;
        var theDepartmentIdV;
        $(function(){
            $departmentIdO = $("#departmentId");
            $majorIdO = $("#majorId");
            $btnSubmitO = $("#btnSubmit");
            $showResultO = $("#showResult");
            $majorIdO.html("<option value='-1'>请先选择院系</option>");

            $departmentIdO.change(function () {
                theDepartmentIdV = $departmentIdO.val();
                if(theDepartmentIdV == -1){
                    $majorIdO.empty().append('<option value="-1">请先选择院系</option>');
                } else{
                    setMajorContent(theDepartmentIdV);
                }
            });
            $btnSubmitO.click(function () {
                var resultStr = "专业的选项内容：" + $majorIdO.html() + "<br>初始提交的是：院系：" + $departmentIdO.val() + "、 专业：" + $majorIdO.val();
                var theTestValue = 2;
                $majorIdO.val(theTestValue); // 已证实：若该select元素的option中没有这个对应值，执行后，$majorIdO.val()值是null且该下拉框显示空白。
                //$majorIdO.options[0].attr("selected", true); 不行。
                var theOption, theOptionValue, theOptionText;
                if($majorIdO.val() == null){
                    theOption = $majorIdO.find("option:first");
                    theOptionValue = theOption.val();
                    theOptionText = theOption.text();
                    $majorIdO.val(theOptionValue);
                    console.log("按钮点击事件：经修正后，选中首项，其值和文本分别是：" + theOptionValue + "、" + theOptionText);
                } else{
                    theOption = $majorIdO.find("option:selected");
                    theOptionValue = theOption.val();
                    theOptionText = theOption.text();
                    console.log("按钮点击事件：正好有项，其值和文本分别是：" + theOptionValue + "、" + theOptionText);
                }
                resultStr = resultStr + "<br>最终提交的是：院系：" + $departmentIdO.val() + "、 专业：" + $majorIdO.val();
                $showResultO.html(resultStr);
            });
        });
        function setMajorContent(theDepartmentId){
            $.get("${theContextPath}/findMajorsByDepartmentId",
                {"departmentId":theDepartmentId},
                function (resultData) {
                    $majorIdO.empty();
                    <%-- // OK js的 for in
                    var optionsStr = "";
                    for(var item in resultData){
                        optionsStr = optionsStr + "<option value='" + resultData[item].id + "'>" + resultData[item].name + "</option>";
                    }
                    if(optionsStr == ""){
                        optionsStr = "<option value='-2'>暂无选项</option>";
                    }
                    $majorIdO.html(optionsStr);
                    --%>
                    <%-- // OK
                    $.each(resultData, function(index, item) {
                        $majorIdO.append($('<option>', {"value": item.id, "text": item.name})); OK
                        // $majorIdO.append("<option value='" + item.id + "'>" + item.name + "</option>"); //用这句也OK
                    });
                    if($majorIdO.html() == ""){
                        $majorIdO.html("<option value='-2'>暂无选项</option>");
                    }
                    --%>
                    var optionsStr = "";
                    $.each(resultData, function(index, item) {
                        optionsStr = optionsStr + "<option value='" + item.id + "'>" + item.name + "</option>";
                    });
                    if(optionsStr == ""){
                        optionsStr = "<option value='-2'>暂无选项</option>";
                    }
                    $majorIdO.html(optionsStr); //alert($majorIdO.html());
                    console.log("设置专业选择框后，majorId的项目内容： " + $majorIdO.html());
                }
            );
        }
    </script>
</head>
<body>
    <div class="mainArea">
        <div class="pageTitle">级联学习</div>
        <div class="posCenter" style="width: 600px;">
            院系：
            <select name="department.id" id="departmentId">
                <option value="-1">不限</option>
        <c:forEach items="${theListDepartments}" var="theDepartment">
                <option value="${theDepartment.id}">${theDepartment.name}</option>
        </c:forEach>
            </select>
            专业：
            <select name="major.id" id="majorId">

            </select><br>
            <input type="button" value="提交" id="btnSubmit"/><br>
            <div id="showResult"></div>
        </div>
        <div class="posCenter navDiv alignCenter">
            <a href="${theContextPath}">首页</a>
        </div>
    </div>
</body>
</html>
<%--
//不行 原因：遍历的方式错误。  for/in - 遍历对象属性、数组。循环变量要用作索引放在被遍历对象后的中括号里。
var optionsStr = "";

for(var item in resultData){
    optionsStr = optionsStr + "<option value='" + item.id + "'>" + item.name + "</option>";
}
$majorIdO.html(optionsStr);

初始提交的是：院系：3、 专业：7
最终提交的是：院系：3、 专业：null

--%>
