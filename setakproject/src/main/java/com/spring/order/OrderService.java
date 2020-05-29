 package com.spring.order;

import java.util.ArrayList;
import java.util.Map;

import com.spring.member.MemberVO;
import com.spring.member.SubscribeVO;

public interface OrderService {

	// 결제 정보 추가
	public int insertOrder(OrderVO ovo); 
	
	public int deleteWashCartbyID(String member_id);
	public int deleteMendingCartbyID(String member_id);
	public int deleteKeepCartbyID(String member_id);
	
	public int insertOrderList(OrderListVO olv);
	public ArrayList<OrderListVO> getOrderList(OrderListVO olv);

	public int getOrderPrice(OrderListVO olv);
	
	public MemberVO getMemberInfo(String member_id);
	public int defaultAddrUpdate(MemberVO mvo); 
	
	public int updateSubInfo(MemberVO mvo); 
	public int insertMemberSubInfo(Map<String, Object> map); 
	public int insertSubHistory(MemberVO mvo); 
	public int getCouponNum(MemberVO mvo);
	public int insertCoupon(MemberVO mvo);
	
	public SubscribeVO getSubscribeInfo(MemberVO mvo);
	
	public int orderCancle(OrderVO ovo);
	
	public int getKeepMaxGroup(String member_id); 
	public int getKeepExist(String member_id);
	
}
