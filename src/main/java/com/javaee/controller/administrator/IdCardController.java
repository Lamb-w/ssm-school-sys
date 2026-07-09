package com.javaee.controller.administrator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.javaee.service.IdCardService;
import com.javaee.vo.FieldExistValidVO;

@Controller
@RequestMapping("/admin")
public class IdCardController {

	@Autowired
	private IdCardService idCardService;
	

	@RequestMapping("isExistSameCard")
    @ResponseBody
    public boolean ajaxValidateCard(@RequestBody FieldExistValidVO fieldExistValidVO) {
        return idCardService.getSameCount(fieldExistValidVO)==1;
    }
	@ResponseBody
	@RequestMapping("isOtherExistSameCard")
    public boolean ajaxValidateCardOther(@RequestBody FieldExistValidVO fieldExistValidVO) {
        return idCardService.getOtherSameCount(fieldExistValidVO)==1;
    }

}
