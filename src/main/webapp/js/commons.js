function isPositiveInteger(theV){ // 验证传入的数是否是正整数
    if(theV=="" || isNaN(theV) || theV.indexOf(".")!=-1 || theV < 0){
        return true;
    }
    return false;
}
function isPositiveIntegerAndProcess(theV, theO){ // 验证传入的数是否是正整数， 如不是就将第2个参数对应的表单输入元素选中完整内容
    if(theV=="" || isNaN(theV) || theV.indexOf(".")!=-1 || theV < 0){
        theO.select();
        return false;
    }
    return true;
}

function isPositiveRealNumberAndProcess(theV, theO){ // 验证传入的数是否是正实数， 如不是就将第2个参数对应的表单输入元素选中完整内容
    if(theV=="" || isNaN(theV) || theV < 0){
        theO.select();
        return false;
    }
    return true;
}
function isNullAndProcess(theV, theO){ // 验证传入的串theV是否是空串，如是空串则将第2个参数对应的表单输入元素选中完整内容
    if(theV=="" ){
        theO.select();
        return true;
    }
    return false;
}