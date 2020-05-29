package com.spring.member;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.admin_member.Admin_memberService;
import com.spring.order.OrderService;

@Controller
public class MemberController {

	@Autowired
	private MemberService memberservice;
	
	@Autowired
	private OrderService orderService; 

	@Autowired
	private Admin_memberService admemberservice;
	
	// 회원가입 클릭 (메인, 로그인페이지)
	@RequestMapping(value = "/join.do", produces = "application/json; charset=utf-8")
	public String join() {
		return "joinform";
	}

	
	  //아이디 중복확인
	  
	  @RequestMapping(value="/chk_id.do", produces = "application/json; charset=utf-8")
	  @ResponseBody 
	  public Map<String, Object> check_id(HttpServletRequest request,MemberVO mo) {
	  Map<String,Object> result = new HashMap<String, Object>(); 

		  int res = memberservice.member_id(mo);
		 
		  if (res == 1) {
				result.put("res", "OK");
			} else {
				result.put("res", "FAIL");
				result.put("message", "Failure");

			}
			return result;
		}
	 
	
	// 멤버 추가
	@RequestMapping(value = "/insertMember.do", produces = "application/json; charset=utf-8")
	@ResponseBody 
	public Map<String, Object> insertMember(MemberVO mo) {
		Map<String, Object> result = new HashMap<String, Object>();
		try {
			memberservice.member_insert(mo);
			result.put("res", "OK");
		} catch (Exception e) {
			result.put("res", "FAIL");
			result.put("message", "Failure");
		}
		return result;
	}

	
	// 개인정보 수정 클릭시 비밀번호 입력페이지로 이동
	@RequestMapping(value = "/profile1.do", produces = "application/json; charset=utf-8", method = { RequestMethod.GET, RequestMethod.POST })
	public String password(Model model, HttpSession session) {
		
		if(session.getAttribute("member_id")==null) {
			return "redirect:/";
		}	
		
		
		String str=(String)session.getAttribute("member_id");
		String last = str.substring(str.length() - 1);
		
		MemberVO memberVO = orderService.getMemberInfo(str);
		// 멤버 아이디 구분해서 member_name, phone, loc 값 공백 
		
		//다른 서비스 계정으로 로그인 할때
		if(last.equals( "K")|| last.equals("N")||last.equals("G")) {
			
			String member_name = memberVO.getMember_name();
			
			String member_phone = " ";
				if(memberVO.getMember_phone() != null) {
   		 		
   		 			member_phone = memberVO.getMember_phone();
				}
				
			String member_email = memberVO.getMember_email();
			
			String member_addr1 = " ";
			String member_addr2 = " ";
			if (!(memberVO.getMember_loc().equals(("!")))) {
	            String addr = memberVO.getMember_loc();
	            String[] locArr = addr.split("!");
	            member_addr1 = locArr[0];
	            if (locArr.length == 2) {
	               member_addr2 = locArr[1];
	            }

	         }
   		 	
   		 	String zipcode = " ";
   		 		if(memberVO.getMember_zipcode() != null) {
   		 			zipcode = memberVO.getMember_zipcode();
   		 		}
   		 	
   		 	model.addAttribute("member_name", member_name); 
			model.addAttribute("member_phone", member_phone);
			model.addAttribute("member_email", member_email);
			model.addAttribute("member_addr1", member_addr1);
			model.addAttribute("member_addr2", member_addr2);
			model.addAttribute("zipcode", zipcode);

   		 	
   		 	return "profile";
   		 	
		
		//일반 로그인시	
   		 	
		} else {
			return "password";
		}
	}

	// 비밀번호 확인
		@RequestMapping(value = "/chk_pw.do", produces = "application/json; charset=utf-8")
		@ResponseBody
		public Map<String, Object> chk_password(HttpServletRequest request, MemberVO mo) {
			Map<String, Object> result = new HashMap<String, Object>();

			int res = memberservice.member_password(mo);

			if (res == 1) {
				result.put("res", "OK");
			} else {
				result.put("res", "FAIL");
				result.put("message", "Failure");

			}
			return result;
		}

	// 일반로그인시 비밀번호 입력후 개인정보수정 페이지로 이동
	@RequestMapping(value = "/profile2.do", produces = "application/json; charset=utf-8")
	public String profile(HttpServletRequest request, Model model, HttpSession session) {

		String ids = (String) session.getAttribute("member_id");

		MemberVO memberVO = orderService.getMemberInfo(ids);
	
			String member_name = memberVO.getMember_name();
			String member_phone = memberVO.getMember_phone();
			String member_email = memberVO.getMember_email();

			String member_addr1 = " ";
			String member_addr2 = " ";
   		 	if (!(memberVO.getMember_loc().equals(("!")))) {
	            String addr = memberVO.getMember_loc();
	            String[] locArr = addr.split("!");
	            member_addr1 = locArr[0];
	            if (locArr.length == 2) {
	               member_addr2 = locArr[1];
	            }

	         }
   		 	
   		 	String zipcode = memberVO.getMember_zipcode();

   		 	
   		 	model.addAttribute("member_name", member_name); 
			model.addAttribute("member_phone", member_phone);
			model.addAttribute("member_email", member_email);
			model.addAttribute("member_addr1", member_addr1);
			model.addAttribute("member_addr2", member_addr2);
			model.addAttribute("zipcode", zipcode);

			return "profile";
	}

	// 멤버 수정
	@RequestMapping(value = "/updateMember.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> updateMember(MemberVO mo) {
		Map<String, Object> result = new HashMap<String, Object>();
		int res = memberservice.member_update(mo);
		if(res==1) {
			result.put("res", "OK");
		} else {
			result.put("res", "FAIL");
			result.put("message", "Failure");
		}
		return result;
	}


	// 회원탈퇴 클릭시
	@RequestMapping(value = "/withdraw.do", produces = "application/json; charset=utf-8")
	public String withdraw(HttpSession session) {
		
		if(session.getAttribute("member_id")==null) {
			return "redirect:/";
		}	
		
		String str=(String)session.getAttribute("member_id");
		String last = str.substring(str.length() - 1);
		
		//다른 서비스 계정으로 로그인 할때
		if(last.equals( "K")|| last.equals("N")||last.equals("G")) {
			return "withdrawform";
		
		//일반 로그인시		
		} else {
			return "withdraw";
		}
	}

	// 탈퇴시 비밀번호 입력
	 @RequestMapping(value="/withdraw_pass.do", produces = "application/json; charset=utf-8")
	 @ResponseBody 
	 public Map<String, Object> withdraw(HttpServletRequest request,MemberVO mo) {
	  Map<String, Object> result = new HashMap<String, Object>();
	  
	  int res = memberservice.member_password(mo);
	  
	  if(res == 1) { 
		  result.put("res", "OK"); 
	  } else { 
		  result.put("res", "FAIL");
		  result.put("message", "Failure");
	  
	  	} 
	  return result; 
	  }
	 
	 //비밀번호 일치하면 탈퇴 페이지로 이동
	 @RequestMapping(value = "/withdrawform.do", produces = "application/json; charset=utf-8")
		public String withdrawform() {
			return "withdrawform";
	 }

	 
	 //아이디 보여주기 
	 @RequestMapping (value ="/show-id.do", produces = "application/json; charset=utf-8")
     @ResponseBody 
	 public Map<String, Object> show_id (String member_name, String member_phone) {
		 HashMap<String, Object> map = new HashMap<String, Object>();
		 map.put("member_name", member_name);
		 map.put("member_phone", member_phone);
		 
		 String dbid = memberservice.show_id(map);
		 Map<String, Object> result = new HashMap<String, Object>();
			result.put("id", dbid);
		
			return result;
		 
	 }
	 
	//비밀번호 찾기- 변경하기 버튼 
		 @RequestMapping (value ="/find-pw.do", produces = "application/json; charset=utf-8")
	     @ResponseBody 
		 public Map<String, Object> find_pw (String member_name, String member_id, String member_phone) {
			 HashMap<String, Object> map = new HashMap<String, Object>();
			 map.put("member_name", member_name);
			 map.put("member_id", member_id);
			 map.put("member_phone", member_phone);
			 
			 Map<String, Object> result = new HashMap<String, Object>();
			 int res = memberservice.chk_you(map);
			  if(res == 1) { 
				  result.put("res", "OK");
				  result.put("member_id", map.get("member_id"));
			  } else { 
				  result.put("res", "FAIL");
				  result.put("message", "Failure");
			  
			  	} 
			  return result; 
			  }
			 
		 
		 
		//비밀번호 변경하기 
		 @RequestMapping (value ="/change-pw.do", produces = "application/json; charset=utf-8")
	     @ResponseBody 
		 public Map<String, Object> change_pw (String member_id, String member_password) {
			 HashMap<String, Object> map = new HashMap<String, Object>();
			 map.put("member_id", member_id);
			 map.put("member_password", member_password);
			 
			Map<String, Object> result = new HashMap<String, Object>();
			int res = memberservice.change_pw(map);
				if(res==1) {
					result.put("res", "OK");
				} else {
					result.put("res", "FAIL");
					result.put("message", "Failure");
				}
				return result;
			}	
			 
		 	 
	 
		 /*탈퇴신청*/
			@RequestMapping(value ="/request-withdraw.do", produces = "application/json; charset=utf-8")
			@ResponseBody 
			public Map<String, Object> update_memo (MemberVO mo) {
				Map<String, Object> result = new HashMap<String, Object>();
				
					int res = admemberservice.update_memo(mo);
					if (res == 1) {
						result.put("res", "OK");
					} else {
						result.put("res", "FAIL");
						result.put("message", "Failure");

					}
				return result;
			}	 

	 
}
