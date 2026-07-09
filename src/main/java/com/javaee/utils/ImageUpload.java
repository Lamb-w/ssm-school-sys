package com.javaee.utils;

import java.io.File;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;


public class ImageUpload {
	private static long fileSizeUnit=1024*1024, allowedMaxFileSize=5*fileSizeUnit;
	public static String upload(HttpServletRequest request, MultipartFile file, String prefixImagePath) {
		String dirPath = request.getServletContext().getRealPath(prefixImagePath);
		File filePath = new File(dirPath);
		// 如果保存文件的地址不存在，就先创建目录
		if (!filePath.exists()) {
			filePath.mkdirs();
		}
		// 使用日期时间重新命名上传的文件名称
		String newFileName = MyUtils.getDateTimePureString()+ file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
		try {
			// 使用MultipartFile接口的方法完成文件上传到指定位置
			long theFileSize=file.getSize();
			if(theFileSize>allowedMaxFileSize) {
				request.setAttribute("theMessage", "文件大小"+ (theFileSize*1.0/fileSizeUnit)+"MB超过了"+(allowedMaxFileSize*1.0/fileSizeUnit)+"MB");
				return "error";
			}
			file.transferTo(new File(dirPath + newFileName));			
		} catch (Exception e) {
			e.printStackTrace();
            return "error";
		}
		return newFileName;
	}
}
