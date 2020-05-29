package com.spring.mypage;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.order.OrderService;
import com.spring.order.OrderVO;
import com.spring.setak.KeepVO;

@RestController
public class MykeepController {
	
	@Autowired
	private MypageService mypageService;
	
	@Autowired
	private OrderService orderService; 
	
	@PostMapping(value="/keepcatelist.do", produces = "application/json; charset=UTF-8")
	public List<KeepVO> keepcatelist(OrderVO orderVO){
			long order_num = orderVO.getOrder_num();
			List<KeepVO> keeplist = mypageService.selectMykeeplist(order_num);
			
			return keeplist;
	}
	
	@RequestMapping(value="/part_Return.do", produces = "application/json; charset=UTF-8")
	public HashMap<String, Object> part_Return(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, KeepReturnVO krvo) throws Exception {
			HashMap<String, Object> hm = new HashMap<String, Object>();
			HashMap<String, Object> map = new HashMap<String, Object>();
			String kindtest[] = request.getParameterValues("return_kind");
			String content[] = request.getParameterValues("return_content");
			String keep_now = "부분반환";
			long order_num = Long.parseLong(request.getParameter("order_num"));
			int res = 0;
			int res2 = 0;
			
			for(int i = 0; i<kindtest.length; i++) {
				KeepReturnVO krVO = new KeepReturnVO();
				krVO.setOrder_num(order_num);
				krVO.setReturn_kind(kindtest[i]);
				krVO.setReturn_content(content[i]);
				krVO.setReturn_confirm(krvo.getReturn_confirm());
				res += mypageService.part_Return(krVO);
			}
			
			map.put("keep_now", keep_now);
			map.put("order_num", order_num);
			
			res2 = mypageService.part_Return_now(map);
			
			if(res2 != 0) {
				map.put("res2","ok");
			} else {
				map.put("res2","fail");
			}
			
			if(res != 0) {
				hm.put("res", "ok");
			}else {
				hm.put("res", "fail");
			}
		
		return hm;
	} 

	@RequestMapping(value="/all_Return.do", produces = "application/json; charset=UTF-8")
	public int all_Return(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, KeepVO kvo, Long order_num) throws Exception {
		 ArrayList<KeepVO> kvolist = new ArrayList<KeepVO>();	
		 int res = 0;  
		 
		 kvolist = mypageService.selectMykeeplist(order_num);
		 String keep_now ="전체반환";
		 HashMap<String, Object>map = new HashMap<String, Object>();
		 map.put("order_num", order_num);
		 map.put("keep_now", keep_now);
		 
		 res = mypageService.all_Return(map);
		 if (res != 0) {
				System.out.println("입력성공");
			} else {
				System.out.println("입력실패");
			}
		return res;
	}

	@RequestMapping(value="/update_Month.do", produces = "application/json; charset=UTF-8")
	public int update_Month(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, KeepVO kvo, Long order_num) throws Exception {
		ArrayList<KeepVO> kvolist = new ArrayList<KeepVO>();
		kvolist = mypageService.selectMykeeplist(order_num);
		String keep_now = null;
		String keep_end = null;
		
		kvo.getKeep_end(); // 받아온 값 		

		KeepVO keepVO = (KeepVO)kvolist.get(0);
		
		keep_end = kvo.getKeep_end();
		keep_now = "보관중";
		
		HashMap<String, Object>map = new HashMap<String, Object>();
		map.put("order_num", order_num);
		map.put("keep_end", keep_end);
		map.put("keep_now", keep_now);
		
		int res = mypageService.updateKeepMonth(map);
		if (res != 0) {
		} else {
		}
		
		return res;
	}

}

