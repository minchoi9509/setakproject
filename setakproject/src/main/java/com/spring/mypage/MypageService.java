package com.spring.mypage;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.spring.member.MemberVO;
import com.spring.order.OrderListVO;
import com.spring.order.OrderVO;
import com.spring.setak.KeepVO;
import com.spring.setak.MendingVO;
import com.spring.setak.WashingVO;

public interface MypageService {
	public ArrayList<OrderVO> getOrderlist(HashMap<String, Object> map);
	public ArrayList<OrderListVO> getOrdernumlist(HashMap<String, Object> map);
	public int getOrdernumcount(String member_id);
	public ArrayList<KeepVO> selectMykeeplist(long order_num);
	public int selectMykeep(long order_num);
	public KeepVO getKeepSeq(int keep_seq);
	public OrderVO selectOrder(long order_num);
	public String selectOrderId(String member_id);
	public int getOrdercount(String member_id);
	public int getKeepcount();
	public ArrayList<MendingVO> selectMending(long order_num);
	public ArrayList<KeepVO> selectKeep(long order_num);
	public ArrayList<WashingVO> selectWashing(long order_num);
	
	//보관연장
	public int updateKeepMonth(HashMap<String, Object> map);
	public int all_Return(HashMap<String, Object> map);
	public int part_Return_now(HashMap<String, Object> map);
	//return
	public int part_Return(KeepReturnVO krvo);
	public MemberVO getMember(String member_id);
	
	public ArrayList<KeepPhotoVO> selectPhoto(long order_num);
	
	public int updateReview(HashMap<String, Object> map);
	
	
	public int getQnaCount(String member_id);
}
