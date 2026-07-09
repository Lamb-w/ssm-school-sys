package com.javaee.utils;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.util.FileCopyUtils;

public class MyUtils {
	public static final String dateFormat="yyyy-MM-dd"; // theType=0
	public static final String longDateTimeFormat="yyyy-MM-dd HH:mm:ss";  // theType=1
	public static final String longDateTimeWithMillisFormat="yyyy-MM-dd HH:mm:ss.SSS";// yyyy-MM-dd HH:mm:ss.SSS 精确到毫秒
	public static final String ADMINISTRATOR_SESSION="administrator", STUDENT_SESSION="student"; // 登录后存入session的标志的键值。
	private static String studentImageURLRoot="/upload/studentImages/", tempDirectory="/upload/temp/";
	private static int defaultSPwdPosInIdCard=6; // 证件号码的后6位是默认的密码
	private static String randString = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";//随机产生的字符串
	public static int serialLength = 8;
	public static String getDateFormat(int theType) {
		String temp="";
		switch (theType) {
		case 0:
			temp=dateFormat;
			break;		
		case 1:
			temp=longDateTimeFormat;
			break;	
		default:
			temp=longDateTimeWithMillisFormat;
		}	
		return temp;
	}
	public static String getStudentImageURLRoot() {
		return studentImageURLRoot;
	}

	public static String getTempDirectory() {
		return tempDirectory;
	}
	public static String getDateTimeString(Date theDate, int theType) {
		if(theDate == null) return "无";
		SimpleDateFormat sdf = new SimpleDateFormat(getDateFormat(theType));
		return sdf.format(theDate);
	}	
	public static String getDateTimeString(int theType) {		
		Date theDate = new Date();
		return getDateTimeString(theDate, theType);
	}	
	public static String getDateTimeString(Date theDate) {
		if(theDate == null) return "无";
		SimpleDateFormat sdf = new SimpleDateFormat(getDateFormat(2));
		return sdf.format(theDate);
	}
	public static String getDateTimeString() {		
		Date theDate = new Date();
		return getDateTimeString(theDate);
	}	
	public static String getGenderString(String theGenderCode) {		
		
		return "0".equals(theGenderCode)?"男":"女";//getDateTimeString(theDate);
	}	
	public static String getDateTimePureString() {		
		Date theDate = new Date();
		//String temp=getDateTimeString(theDate);
		//return temp.replace("-", "").replace(" ", "").replace(":", "").replace(".", "");
		return getDateTimePureString(new Date());
	}	
	public static String getDateTimePureString(Date theDate) {		
		return getDateTimeString(theDate).replace("-", "").replace(" ", "").replace(":", "").replace(".", "");// 20200714104026290
	}
	public static String getImageSrc(String theType,String theImagePathLeft) {
		String thePrefix = "";
		if("1".equals(theType)) {
			thePrefix = studentImageURLRoot;
		}
		return thePrefix+theImagePathLeft;
	}
	public static String trim(String theStr) {
		if(theStr==null) {
			return null;
		}
		return theStr.trim();
	}	
	public static void copyAndDelete(HttpServletRequest request, String remainingFileName, String sourceDirectory, String  destinationDirectory) {
		if(!"".equals(remainingFileName)) { // 现在有图片 
			ServletContext myServletContext = request.getServletContext();
			String dirPath = myServletContext.getRealPath(destinationDirectory); // D:\\Program Files\\tomcat\wtpwebapps\\ch04\\upload\\studentImages
			File filePath = new File(dirPath);					
			// 如果保存文件的地址不存在，就先创建目录
			if (!filePath.exists()) {
				filePath.mkdirs();
			}
			
			//MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request; //运行时报错。
			//MultipartFile file = (MultipartFile)multiRequest.getFile(product.getImage());
			File sourceTempFile = new File(myServletContext.getRealPath(sourceDirectory)  + remainingFileName);
			try {
				FileCopyUtils.copy(sourceTempFile, new File(dirPath + remainingFileName));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			sourceTempFile.delete();					
		}
	}
	public static int getInitialStartYear(Integer startYearFromDB) {
		if(startYearFromDB==null ) {
			//return date.getYear();
			Calendar calender = Calendar.getInstance();
			//Date date=new Date(); calender.setTime(date);
			return calender.get(Calendar.YEAR);			
		}
		return startYearFromDB+1;
	}
	public static String getInitialTitle(int startYear, int type) {
		
		return startYear+"-"+(startYear+1)+"-"+type;
	}	
	public static String getDefaultSPwd(String theIdCardNo) { // 从证件号码的后6位作为默认的密码。
		return theIdCardNo.substring(theIdCardNo.length() - defaultSPwdPosInIdCard);
	}
	/**
	 * 获取ip地址
	 * 参考：https://bbs.csdn.net/topics/392376661
	 * @param request
	 * @return
	 */
	public static String getIPAddress(HttpServletRequest request) {
		// 获取请求主机IP地址,如果通过代理进来，则透过防火墙获取真实IP地址
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("Proxy-Client-IP");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("WL-Proxy-Client-IP");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("HTTP_CLIENT_IP");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getHeader("HTTP_X_FORWARDED_FOR");
			}
			if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
				ip = request.getRemoteAddr();
			}
		} else if (ip.length() > 15) {
			String[] ips = ip.split(",");
			for (int index = 0; index < ips.length; index++) {
				String strIp = (String) ips[index];
				if (!("unknown".equalsIgnoreCase(strIp))) {
					ip = strIp;
					break;
				}
			}
		}
		return ip;
	}
	
	public static void pause(long millis) {
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
    public static String getRandomString(int length) {
    	Random random = new Random();
    	int lengthTotal = randString.length();
    	StringBuffer sb = new StringBuffer();
    	for(int i=1; i<= length; i++) {
    		sb.append(randString.charAt(random.nextInt(lengthTotal)));
    	}
    	return sb.toString();
    }
}
/*
显示客户端主机IP地址：https://blog.csdn.net/yin_jw/article/details/24470131
在Servlet里，获取客户端的IP地址的方法是：request.getRemoteAddr()，这种方法在大部分情况下都是有效的。
但是在通过Apache，Squid，Nginx等反向代理软件后就不能获取到客户端的真实IP地址了。
 * */
