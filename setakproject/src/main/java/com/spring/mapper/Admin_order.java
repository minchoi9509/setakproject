package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.admin_order.FullCalendar;
import com.spring.community.QnaVO;
import com.spring.order.OrderVO;


public interface Admin_order {

	// 전체 주문 리스트 뿌리기
	ArrayList<OrderVO> getOrderList(HashMap<String, Integer> map);
	// 전체 주문 개수
	int getOrderCount();
	
	// 주문 검색
	ArrayList<OrderVO> orderSearch(HashMap<String, Object> map);
	// 주문 검색 개수
	int orderSearchCount(HashMap<String, Object> map);
	
	// 선택 주문 정보
	OrderVO getOrderInfo(OrderVO ovo); 
	// 선택 주문 정보 수정
	int updateOrderInfo(OrderVO ovo);
	// 주문 상태 수정
	int statusUpdate(HashMap<String, Object> map);
	
	// 최근 5일간 주문상태 카운트
	int recentOrderStatusCnt(HashMap<String, Object> map); 
	// 최근 5일간 주문 카운트
	int recentOrderCnt(HashMap<String, Object> map); 
	// 최근 5주간 주문 카운트
	int recentOrderWeeklyCnt(HashMap<String, Object> map);
	
	// 답변 대기 최근 게시물 리스트
	ArrayList<QnaVO> getQnAList();
	// 최근 일주일 가입 회원 수
	int getNewMemberCnt(); 
	// 처리해야 할 주문 리스트
	ArrayList<OrderVO> getProcessOrderList();
	// 처리해야 할 주문 갯수
	int getProcessOrderCnt();
	// 하루 매출액
	int getOrderAllPrice(String order_date);
	
	
	ArrayList<FullCalendar> getCalendarList(); 
	int addCalendar(HashMap<String, Object> map);
}
