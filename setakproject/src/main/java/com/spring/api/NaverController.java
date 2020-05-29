package com.spring.api;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class NaverController {
	
	@Autowired
	public Sens_sms_v2 sms;
	
	@Autowired
	public IPCountService ipcs;

	@RequestMapping(value="sendSMS.do")
    public @ResponseBody String sendsms(String pn, HttpServletRequest request) throws Exception {
		
		String ip = request.getRemoteAddr();
		System.out.println(ip);
		String r = request.getParameter("randomnum");
		System.out.println(r);
		
		sms.setPhonenumber(request.getParameter("pn"));
		sms.setMsgtext("인증번호는 " + request.getParameter("randomnum") + " 입니다.");
		sms.sendMessage();
		
		return "";
	}
	
	@RequestMapping(value="ipcount.do", produces = "application/json; charset=utf-8")
    public @ResponseBody Map<String, Object> ipcount(HttpServletRequest request) throws Exception {
		Map<String,Object> result = new HashMap<String, Object>(); 
		String member_ip = request.getRemoteAddr();
		int ipchk = ipcs.getIPList(member_ip);
		if(ipchk == 0) {
			ipcs.insertIP(member_ip);
			result.put("res", "OK");
			return result;
		}
		
		int ipcount = ipcs.countIP(member_ip);
		if(ipcount >= 10) {
			result.put("res", "FAIL");
		}else {
			ipcs.plusIPCount(member_ip);
			result.put("res", "OK");
		}
		
		return result;
	}
	
}
