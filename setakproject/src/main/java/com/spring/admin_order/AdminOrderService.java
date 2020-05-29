package com.spring.admin_order;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.community.QnaVO;
import com.spring.order.OrderVO;

public interface AdminOrderService {

	public ArrayList<OrderVO> getOrderList(HashMap<String, Integer> map);
	public int getOrderCount();
	
	public ArrayList<OrderVO> orderSearch(HashMap<String, Object> map);
	public int orderSearchCount(HashMap<String, Object> map);
	
	public OrderVO getOrderInfo(OrderVO ovo);
	public int updateOrderInfo(OrderVO ov);
	public int statusUpdate(HashMap<String, Object> map);
	
	public int recentOrderStatusCnt(HashMap<String, Object> map);
	public int recentOrderCnt(HashMap<String, Object> map);
	public int recentOrderWeeklyCnt(HashMap<String, Object> map);
	
	public ArrayList<QnaVO> getQnAList();
	public int getNewMemberCnt(); 
	public ArrayList<OrderVO> getProcessOrderList();
	public int getProcessOrderCnt();
	public int getOrderAllPrice(String order_date);
	
	
	public ArrayList<FullCalendar> getCalendarList();
	public int addCalendar(HashMap<String, Object> map); 
}
