package com.spring.admin_member;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.member.MemberVO;

@Controller
public class Admin_memberController {
	
	@Autowired
	private Admin_memberService admemberservice;
	
	/*회원관리 페이지로 이동*/
	@RequestMapping(value="/admin/member.do", produces = "application/json; charset=utf-8") 
	public String list(Model model, HttpServletRequest request) {
		
		//회원 리스트 출력
		HashMap<String, Object> map = new HashMap<String, Object>();
	   
		int page = 1;
	    int limit = 20; 
	    
	    if(request.getParameter("page") != null) {
	        page = Integer.parseInt(request.getParameter("page"));
	    }
	    
	    int startrow = (page-1)*20 +1; 
	    int endrow = startrow + limit-1;
	    
	    map.put("startrow", startrow);
	    map.put("endrow", endrow);
	    ArrayList<MemberVO> list =  admemberservice.adminlist(map);
	    
	    
	    int listcount = admemberservice.adminlistcount();
	    int maxpage = (int)((double)listcount/limit+0.95);
	    int startpage=(((int) ((double)page/10+0.9))-1)*10+1;
	    int endpage = startpage + 10-1;
	    if(endpage > maxpage)
	      {
	         endpage = maxpage;
	         
	      }
	    
	    //오늘 가입한 회원 수
	    int todaycount = admemberservice.todaycount();
	    
	  
	    model.addAttribute("page", page);
	    model.addAttribute("limit", limit);
	    model.addAttribute("list", list);
	    model.addAttribute("listcount", listcount);
	    model.addAttribute("maxpage", maxpage);
	    model.addAttribute("startpage",startpage);
	    model.addAttribute("endpage", endpage );
	    model.addAttribute("todaycount", todaycount);
		 
		return "/admin/member";
	}
	
	
	/*메모 수정*/
	@RequestMapping(value ="/admin/admin_update.do", produces = "application/json; charset=utf-8")
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
	
	/*검색*/
	@RequestMapping(value ="/admin/searchmember.do", produces = "application/json; charset=utf-8", method = {RequestMethod.POST })
	@ResponseBody 
	public Map<String, Object> search (String startDate, String endDate, String searchType, String keyword, String [] statusArr, Model model) {
		String start = startDate.replace("-", "/").substring(2, startDate.length());
		String end = endDate.replace("-", "/").substring(2, endDate.length());
		HashMap<String, Object> map = new HashMap<String, Object>();
		 map.put("startDate", start);
		 map.put("endDate", end);
		 map.put("searchType", searchType);
		 map.put("keyword", keyword);
		 map.put("statusArr", statusArr);
		 
		ArrayList<MemberVO> list =  admemberservice.searchlist(map);
		int searchcount = admemberservice.searchlistcount(map);
		
		Map<String, Object> result = new HashMap<String, Object>();
		 result.put("list", list);
		 result.put("searchcount", searchcount);
		
		
		return result;
	}
	
	/*회원상세정보 보기 */
	@RequestMapping(value ="/admin/admin_detail.do", produces = "application/json; charset=utf-8", method = {RequestMethod.POST })
	@ResponseBody 
	public Map<String, Object> detail (String member_id ) {
		MemberVO memberVO = admemberservice.detail(member_id);
		
		Map<String, Object> result = new HashMap<String, Object>();
		 result.put("list", memberVO);
		return result;
	}
	
	/*회원상세정보 수정*/
	@RequestMapping(value ="/admin/detail_update.do", produces = "application/json; charset=utf-8", method = {RequestMethod.POST })
	@ResponseBody 
	public Map<String, Object> detail_update (String member_id, String member_name, String member_phone, 
											String member_email, String member_zipcode, String member_loc, Integer subs_num ) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		 map.put("member_id", member_id);
		 map.put("member_name", member_name);
		 map.put("member_phone", member_phone);
		 map.put("member_email", member_email);
		 map.put("member_zipcode", member_zipcode);
		 map.put("member_loc", member_loc);
		 map.put("subs_num", subs_num);
		 
		int res = admemberservice.detail_update(map);
		
		Map<String, Object> result = new HashMap<String, Object>();
		if (res == 1) {
			result.put("res", "OK");
		} else {
			result.put("res", "FAIL");
			result.put("message", "Failure");

		}
	return result;
	}
	
}
