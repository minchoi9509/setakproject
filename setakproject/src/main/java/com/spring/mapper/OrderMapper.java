package com.spring.mapper;

import java.util.ArrayList;
import java.util.Map;

import com.spring.member.MemberVO;
import com.spring.member.SubscribeVO;
import com.spring.order.OrderListVO;
import com.spring.order.OrderVO;

public interface OrderMapper {

	// 결제 정보 추가
	int insertOrder(OrderVO ovo);
	
	// 결제 이후 장바구니 비우기
	int deleteWashCartbyID(String member_id);
	int deleteMendingCartbyID(String member_id);
	int deleteKeepCartbyID(String member_id);
	
	// 주문 목록 추가
	int insertOrderList(OrderListVO olv);
	// 주문 목록 시퀀스 읽기
	ArrayList<OrderListVO> getOrderList(OrderListVO olv);
	// 결제 금액 
	int getOrderPrice(OrderListVO olv); 
	
	// 회원 정보 읽어오기
	MemberVO getMemberInfo(String member_id);
	// 회원 정보 수정
	int defaultAddrUpdate(MemberVO mvo); 
	
	// 회원 정보 수정 > 정기구독 번호 등록
	int updateSubInfo(MemberVO mvo); 
	// 회원 정기구독 정보 등록
	int insertMemberSubInfo(Map<String, Object> map);
	// 회원 정기구독 결제 정보 등록
	int insertSubHistory(MemberVO mvo); 
	// 쿠폰 제공 개수 구하기
	int getCouponNum(MemberVO mvo);
	// 쿠폰 발급하기
	int insertCoupon(MemberVO mvo);
	
	// 정기구독 정보 읽어오기
	SubscribeVO getSubscribeInfo(MemberVO mvo);
	
	// 주문 취소 정보 등록
	int orderCancle(OrderVO ovo);
	
	// 보관 장바구니 그룹 읽기
	int getKeepMaxGroup(String member_id); 
	// 보관 장바구니 존재 유무 확인
	int getKeepExist(String member_id); 

}
