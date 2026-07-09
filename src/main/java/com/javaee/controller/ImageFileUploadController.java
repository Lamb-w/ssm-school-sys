package com.javaee.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.javaee.utils.ImageUpload;
import com.javaee.utils.MyUtils;

@Controller
public class ImageFileUploadController {
	
	@ResponseBody
	@RequestMapping("/ajaxImageFileUploadDo")
	public Map<String, Object> ajaxImageFileUploadDo(HttpServletRequest request, MultipartFile photo){
		Map<String, Object> map = new HashMap<String, Object>();
		String prefixImagePath = MyUtils.getTempDirectory(); // 每次都是上传到服务器上的临时文件夹中以便各浏览器都能正确显示预览图。待正式提交后，要复制到正式的文件夹中，然后删除。
		String imageURL = ImageUpload.upload(request, photo, prefixImagePath);
		map.put("status","error".equals(imageURL)? false:true); // 三元运算符： 变量=条件?值1:值2;
		map.put("imageURL", imageURL);
		return map;		
	}
}
