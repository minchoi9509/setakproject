 package com.spring.admin_order;

import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.admin_chart.AdminChartService;
import com.spring.admin_member.Admin_memberService;
import com.spring.community.QnaVO;
import com.spring.member.MemberSubVO;
import com.spring.order.OrderVO;

@Controller
public class AdminOrderController {
	
	@Autowired
	private AdminOrderService adminOrderService; 
	@Autowired
	private AdminSubscribeService adminSubService; 
	@Autowired
	private AdminSubscribeService adminMemberSubService; 
	@Autowired
	private AdminChartService adminchartService; 
	@Autowired
	private Admin_memberService adminMemberService; 
	
	//관리자 페이지 메인 > 대시보드
	@RequestMapping(value ="/admin/", method = RequestMethod.GET)
	public String home(Model model){
		
		// 오늘의 날씨 크롤링
		String url = "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=%EC%84%9C%EC%9A%B8+%EA%B0%95%EB%82%A8%EA%B5%AC+%EB%82%A0%EC%94%A8&oquery=%EC%98%A4%EB%8A%98%EC%9D%98+%EB%82%A0%EC%94%A8&tqi=UC3pKsprvxssssy%2F7Yhssssstws-470599";
		Document doc = null;
		
		try {
			doc = Jsoup.connect(url).get();
		} catch(IOException e) {
			e.printStackTrace();
		}
		
		Elements element = doc.select(".today_area div.info_data");
		
		// temp : 오늘 날씨, text : 어제 기온이랑 비교해서
		String temp = element.select("p.info_temperature span.todaytemp").text();
		String tempText = element.select("ul.info_list li p.cast_txt").text();
		
		
		// 최근 5일 날짜 배열 구하기 : dateArr
		String[] dateArr = Day.get5Days();

		// 최근 일주일 가입 회원 수 부분
		int memberCnt = adminOrderService.getNewMemberCnt();
		// 총 회원 수 
		int memberAllcnt = adminMemberService.adminlistcount();
		
		int orderAllPrice = adminOrderService.getOrderAllPrice(dateArr[0]);
		
		// 최근 5일 총 주문량 코드
		int orderSum = 0; 
		HashMap<String, Object> dateMap = new HashMap<String, Object>();
		for(int i = 0; i < 5; i++) {
			dateMap.put("order_date", dateArr[i]);
			orderSum += adminOrderService.recentOrderCnt(dateMap);
		}
		
		
		// 정기구독 차트 코드 시작 + 정기구독 신청 회원 수 
		int subSum = 0; 
		String[] planArr = Plan.planArr;
		String[] plan2Arr = Plan.plan2Arr;
		
		int[] subArr = new int[5]; 
		int[] sub2Arr = new int[22];
				
		int planArrlength = planArr.length;
		for(int i = 0; i < planArrlength; i++) {
			int cnt = adminMemberSubService.getMemberSubCnt(planArr[i]);
			subArr[i] = cnt;
			subSum += cnt;
		}

		// 총 회원수 대비 구독자수
		int subPercent = (int)((double) subSum / (double) memberAllcnt * 100);
	
		int plan2Arrlength = plan2Arr.length;
		for(int i = 0; i < plan2Arrlength; i++) {
			int cnt = adminMemberSubService.getMemberSubCnt2(plan2Arr[i]);
			sub2Arr[i] = cnt;
		}
		// 정기구독 차트 코드 끝		
		
		// 세수보 차트 코드 시작
		HashMap<String, Object> map = new HashMap<String, Object>();

		// 하루당 기간별 배열 : 세탁
		int[] wash2Arr = new int[5];
		int wash_dailyResult = 0; 
		
		// 하루당 기간별 배열 : 수선
		int[]repairArr = new int[5];
		int repair_dailyResult = 0;
		
		// 하루당 기간별 배열 : 보관
		int[] keepArr = new int[5];
		int keep_dailyResult = 0; 
		
		for(int j = 0;  j <5; j++) {
			map.put("order_date", dateArr[j]);
									
			// 하루당 주문량 계산 : 세탁
			wash_dailyResult = adminchartService.wash_count(map);
			wash2Arr[j] += wash_dailyResult; 
			
			// 하루당 주문량 계산 : 수선
			repair_dailyResult = adminchartService.repair_count(map);
			repairArr[j] += repair_dailyResult; 
			
			// 하루당 주문량 계산 : 보관
			keep_dailyResult = adminchartService.keep_count(map);
			keepArr[j] += keep_dailyResult; 
				
		}
		// 세수보 차트 코드 끝
		
		// 수입 차트 코드 시작
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		
		LocalDate basic = LocalDate.of(2020, 1, 28);
		LocalDate now = LocalDate.now();
		
		int a = (int)ChronoUnit.DAYS.between(basic, now);
		
		String[] profit_dateArr = new String[a];
		String[] dateArr2 = new String[a];
		
		//세수보 수익금액
		int[] ssbResultArr = new int[a];
		int ssbResult = 0;
		
		//정기결제 수익금액
		int[] subResultArr = new int[a];
		int subResult = 0;
		
		//총 수익금액
		int[] totalArr = new int[a];
		int total = 0;
		
		for(int i = 0; i < a ; i++) {
			
			basic.plusDays(i);
			String c = basic.plusDays(i).toString().substring(2).replace("-","/");
			
			profit_dateArr[i] = c;
			map2.put("order_date", profit_dateArr[i]);
			map2.put("his_date", profit_dateArr[i]);

			String d = basic.plusDays(i).toString();
			dateArr2[i] = d;
			
			//세수보 수익금액
			ssbResult = adminchartService.profit_ssb(map2);
			ssbResultArr[i] += ssbResult; 
			
			//정기결제 수익금액
			subResult = adminchartService.profit_sub(map2);
			subResultArr[i] += subResult; 
			
			total = ssbResult + subResult;
			totalArr[i] += total; 

		}
		
		model.addAttribute("num", a);
		model.addAttribute("dateArr2", dateArr2);
		
		model.addAttribute("ssbResultArr", ssbResultArr);
		model.addAttribute("subResultArr", subResultArr);
		
		model.addAttribute("totalArr", totalArr);
		// 수입 차트 코드 끝
		
		// 정기구독 인기 순위 구하기 부분
		ArrayList<HashMap<String, Object>> subList = adminSubService.getSubPopular();

		// qna 미답변 게시판 부분
		ArrayList<QnaVO> qnaList = adminOrderService.getQnAList();
		
		// 처리해야 하는 주문 테이블 부분
		ArrayList<OrderVO> orderList = adminOrderService.getProcessOrderList(); 
		int orderCnt = adminOrderService.getProcessOrderCnt();
		
		// 날씨 크롤링
		model.addAttribute("temp", temp);
		model.addAttribute("tempText", tempText);		
		
		// 타이틀 숫자 부분 
		model.addAttribute("memberCnt", memberCnt);
		model.addAttribute("orderSum", orderSum); 
		model.addAttribute("subPercent", subPercent); 
		model.addAttribute("orderAllPrice", orderAllPrice); 

		// 정기구독 차트 부분
		model.addAttribute("subArr", subArr); 
		model.addAttribute("sub2Arr", sub2Arr); 
		
		// 정기구독 인기 순위 구하기 부분
		model.addAttribute("subList", subList); 
		
		// 세수보 차트 부분
		model.addAttribute("washArr", wash2Arr);
		model.addAttribute("repairArr", repairArr);
		model.addAttribute("keepArr", keepArr);
		
		// qna 미답변 게시판 부분
		model.addAttribute("qnaList", qnaList);
		
		// 처리해야 하는 테이블 부분
		model.addAttribute("orderList", orderList);
		model.addAttribute("orderCnt", orderCnt); 
				
		return "/admin/admin_main";
		
	}
	
	//전체 주문 관리자 페이지
	@RequestMapping(value = "/admin/getEvent.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public ArrayList<FullCalendar> getEvent() {
		
		// 캘린더 
		ArrayList<FullCalendar> calendarList = adminOrderService.getCalendarList();
				
		return calendarList;
	}
	
	//전체 주문 관리자 페이지
	@RequestMapping(value = "/admin/addEvent.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String addEvent(String title, String start, String end) {
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("title", title);
		map.put("start", start);
		map.put("end", end);
		
		int res = adminOrderService.addCalendar(map);
		String msg = ""; 
		if(res == 0) {
			msg = "일정 추가에 실패했습니다.";
		}else {
			msg = "성공적으로 일정이 추가되었습니다.";
		}
		return msg; 
	}
	
	//전체 주문 관리자 페이지
	@RequestMapping(value = "/admin/order.do")
	public String adminOrderAll(Model model) {
		
		// 전체 주문 개수
		int orderCount = adminOrderService.getOrderCount();
		model.addAttribute("orderCount", orderCount);
		
		return "/admin/order";
	}
	
	//전체 주문 관리자 페이지
	@RequestMapping(value = "/admin/orderList.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public Map<String, Object> adminOrderList(@RequestParam(value="currentPage") String currentPage) {
		
		int nowpage = Integer.parseInt(currentPage);
		int startrow = (nowpage - 1) * 5 + 1;
		int endrow = startrow + 5 - 1; 

        HashMap<String, Integer> map = new HashMap<String, Integer>();
        map.put("startRow", startrow);
        map.put("endRow", endrow);
		
		// 전체 주문 개수
		ArrayList<OrderVO> orderList = adminOrderService.getOrderList(map);
		int orderCount = adminOrderService.getOrderCount();
		
		Map<String, Object> retVal = new HashMap<String, Object>();
	    retVal.put("orderList", orderList);
		retVal.put("orderCount", orderCount);
		
		return retVal;
	}
	
	// 주문 검색 
	@RequestMapping(value = "/admin/orderSearch.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public Map<String, Object> orderSearch2(@RequestParam(value="searchType") String searchType, @RequestParam(value="keyword") String keyword,
			String[] statusArr, @RequestParam(value="startDate") String startDate, @RequestParam(value="endDate") String endDate, 
			@RequestParam(value="orderBy") String orderBy, @RequestParam(value="currentPage") String currentPage) {
		
		int nowpage = Integer.parseInt(currentPage);
		int startrow = (nowpage - 1) * 5 + 1;
		int endrow = startrow + 5 - 1; 
		
		String start = startDate.replace("-", "/").substring(2, startDate.length());
		String end = endDate.replace("-", "/").substring(2, endDate.length());
		
		// 검색어 설정 
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("searchType", searchType);
		map.put("keyword", keyword);
		map.put("startDate", start);
		map.put("endDate", end);
		map.put("statusArr", statusArr);
		map.put("orderBy", orderBy);
		map.put("startrow", startrow);
		map.put("endrow", endrow);
		
		int orderSearchCount = adminOrderService.orderSearchCount(map);
		ArrayList<OrderVO> orderSearchList = adminOrderService.orderSearch(map);

		Map<String, Object> retVal = new HashMap<String, Object>();
		
		retVal.put("orderSearchCount", orderSearchCount);
		retVal.put("orderSearchList", orderSearchList);
		
		return retVal;
		
	}
	
	// 주문 상세보기
	@RequestMapping(value = "/admin/orderSelect.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public OrderVO orderSelect(OrderVO ovo) {
		
		OrderVO orderVO = adminOrderService.getOrderInfo(ovo);		
		return orderVO; 
	}
	
	// 주문 상세정보 수정
	@RequestMapping(value = "/admin/orderUpdate.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public OrderVO orderUpdate(OrderVO ovo) {
		
		adminOrderService.updateOrderInfo(ovo);
		OrderVO orderVO = adminOrderService.getOrderInfo(ovo);

		return orderVO; 
	}
	
	// 주문 상태 수정 
	@RequestMapping(value = "/admin/statusUpdate.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public OrderVO statusUpdate(String[] orderNumArr, OrderVO ovo) {
		
		String order_status = ovo.getOrder_status();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("orderNumArr", orderNumArr);
		map.put("order_status", order_status);
		
		int res = adminOrderService.statusUpdate(map);

		return ovo; 
	}
	
	// 기타 주문관리
	@RequestMapping(value = "/admin/orderChart.do")
	public String adminOrder(Model model) {
		
		String[] statusArr = {"결제완료", "수거중", "서비스중", "배송중", "배송완료", "주문취소"};
		
		String[] dateArr = Day.get5Days();
		String today = dateArr[0]; 
		
		String[] weekArr = Day.getWeekDays(); 
		HashMap<String, Object> map = new HashMap<String, Object>();

		// 상태별 배열 
		int[] payArr = new int[5]; 
		int[] pickArr = new int[5]; 
		int[] serviceArr = new int[5]; 
		int[] deliveryArr = new int[5]; 
		int[] completeArr = new int[5]; 
		int[] cancleArr = new int[5]; 
		
		// 기간별 배열 : 일별, 주별 
		int[] dailyArr = new int[5];
		int[] weeklyArr = new int[5];
		
		int dailySum = 0; 
		int weeklySum = 0; 
		
		for(int i = 0; i < statusArr.length; i++) {
			String status = statusArr[i]; 
			map.put("order_status", status);
			int daily = 0; 
			
			for(int j = 0;  j < dateArr.length; j++) {
				map.put("order_date", dateArr[j]);
				int dailyResult = 0; 
				int result = adminOrderService.recentOrderStatusCnt(map);

				// 상태별 총 주문량 계산
				switch(i) {
				case 0 :
					payArr[j] = result; 
					break;
				case 1 :
					pickArr[j] = result; 
					break;
				case 2 :
					serviceArr[j] = result; 
					break;
				case 3 :
					deliveryArr[j] = result; 
					break;
				case 4 :
					completeArr[j] = result; 
					break;
				case 5 :
					cancleArr[j] = result; 
					break;
				}
				
				// 일별 총 주문량 계산
				if(i == statusArr.length - 1) {
					dailyResult = adminOrderService.recentOrderCnt(map);
					dailyArr[j] = dailyResult; 
					dailySum += dailyResult;
				}
			}
			
		}
				
		// 주별 총 주문량 계산 
		for(int i = 0; i < weekArr.length; i+=2) {
			String end = weekArr[i];
			String start = weekArr[i+1];

			map.put("startDate", start);
			map.put("endDate", end);
			
			int result = adminOrderService.recentOrderWeeklyCnt(map);
			weeklyArr[i/2] = result; 
			weeklySum += result;
		}

		model.addAttribute("payArr", payArr);
		model.addAttribute("pickArr", pickArr);
		model.addAttribute("serviceArr", serviceArr);
		model.addAttribute("deliveryArr", deliveryArr);
		model.addAttribute("completeArr", completeArr);
		model.addAttribute("cancleArr", cancleArr);
		
		model.addAttribute("dateArr", dateArr); 
		model.addAttribute("weekArr", weekArr); 
		
		model.addAttribute("dailyArr", dailyArr);
		model.addAttribute("weeklyArr", weeklyArr);
		model.addAttribute("dailySum", dailySum);
		model.addAttribute("weeklySum", weeklySum);
		
		return "/admin/order_chart";
	}
	
	// 정기구독 관리자 페이지
	@RequestMapping(value = "/admin/subscribe.do")
	public String subscribe() {
		
		return "/admin/subscribe";
		
	}
	
	// 정기구독 관리자 리스트 띄우기
	@RequestMapping(value = "/admin/getMemberSubList.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public List<Object> getMemberSubList() {
		
		List<Object> memberSubList = adminMemberSubService.getMemberSubList();
		return memberSubList;
		
	}
	
	// 정기구독 관리자 검색 
	@RequestMapping(value = "/admin/subMemberSearch.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public List<Object> subMemberSearch(@RequestParam(value="keyword") String keyword, String[] planArr, @RequestParam(value="orderBy") String orderBy) {
				
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("orderBy", orderBy);
		map.put("keyword", keyword);
		map.put("planArr", planArr);
		
		List<Object> memberSubList = adminMemberSubService.subMemberSearch(map);
		
		return memberSubList;
		
	}
	
	// 정기구독 관리자 수정 
	@RequestMapping(value = "/admin/updateMemberSubList.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public Map<String, String> updateMemberSubList(MemberSubVO msv) {
		
		int res = adminMemberSubService.updateMemberSubList(msv);
		Map<String, String> retVal = new HashMap<String, String>();
		if(res == 1) {
			retVal.put("res", "OK");
		}else {
			retVal.put("res", "fail");
		}
		
		return retVal;
	}
		
	// 정기구독 관리자 삭제
	@RequestMapping(value = "/admin/deleteMemberSubList.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody 
	public Map<String, String> deleteMemberSubList(String member_id) {

		int res = adminMemberSubService.deleteMemberSubList(member_id);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		Integer subs_num = null; 
		map.put("subs_num", subs_num);
		map.put("member_id", member_id); 

		adminMemberSubService.updateSubNum(map); 
		
		Map<String, String> retVal = new HashMap<String, String>();
		if(res == 1) {
			retVal.put("res", "OK");
		}else {
			retVal.put("res", "fail");
		}
		
		return retVal;
	}
	
	// 기타 정기구독 관리 > 차트
	@RequestMapping(value = "/admin/subscribeChart.do")
	public String subscribeChart(Model model) {
		
		String[] planArr = Plan.planArr;
		String[] plan2Arr = Plan.plan2Arr;
		
		String[] dateArr = Day.get5Days();
			
		// 구독별
		int[] subArr = new int[5];
		int[] sub2Arr = new int[22];
	
		int[] allArr = new int[5];
		int[] shirtsArr = new int[5];
		int[] dryArr = new int[5];
		int[] washArr = new int[5];
		int[] washDryArr = new int[5];
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		
		for(int i = 0; i < planArr.length; i++) {
			int cnt = adminMemberSubService.getMemberSubCnt(planArr[i]);
			subArr[i] = cnt; // 전체 유형별 숫자
			
			map.put("subsname", planArr[i]); 
			for(int j = 0; j < dateArr.length; j++) {
				map.put("subs_start", dateArr[j]);
				
				int result = adminMemberSubService.getMemberDailySubCnt(map);

				switch(i) {
				case 0 :
					allArr[j] = result; 
					break;
				case 1 :
					shirtsArr[j] = result; 
					break;
				case 2 :
					dryArr[j] = result; 
					break;
				case 3 :
					washArr[j] = result; 
					break;
				case 4 :
					washDryArr[j] = result; 
					break;
				}
			}
		}
		
		for(int i = 0; i < plan2Arr.length; i++) {
			int cnt = adminMemberSubService.getMemberSubCnt2(plan2Arr[i]);
			sub2Arr[i] = cnt;
		}
		
		model.addAttribute("subArr", subArr); 
		model.addAttribute("sub2Arr", sub2Arr); 
		
		model.addAttribute("allArr", allArr); 
		model.addAttribute("shirtsArr", shirtsArr); 
		model.addAttribute("dryArr", dryArr); 
		model.addAttribute("washArr", washArr); 
		model.addAttribute("washDryArr", washDryArr); 
		
		return "/admin/subscribe_chart";
	}
		
}
