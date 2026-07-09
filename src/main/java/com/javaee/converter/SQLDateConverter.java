package com.javaee.converter;

import org.springframework.core.convert.converter.Converter;

import java.text.ParseException;
import java.text.SimpleDateFormat;

// 将串形式的日期时间，变成Date型。配置后，将输入的日期串自动转成相应的Date型绑定到封装对象的对应属性
public class SQLDateConverter implements Converter<String, java.sql.Date> { // 专门针对java.sql.Date型参数的获得值（将提交的串型值赋给该类型的属性、形参）
    // 定义日期格式
    private String datePatternShort="yyyy-MM-dd", datePatternLong = "yyyy-MM-dd HH:mm:ss";

    @Override
    public java.sql.Date convert(String source) {
        // 格式化日期
        if(source==null || "".equals(source)) {
            return null;
        }
        String thePattern = source.indexOf(":")==-1?datePatternShort:datePatternLong;
        SimpleDateFormat sdf = new SimpleDateFormat(thePattern);
        try {
            return new java.sql.Date(sdf.parse(source).getTime());
        } catch (ParseException e) {
            throw new IllegalArgumentException("无效的日期格式，请使用这种格式:"+thePattern);
        }
    }
}