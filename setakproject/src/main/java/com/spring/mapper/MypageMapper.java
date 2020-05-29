package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.member.MemberVO;
import com.spring.mypage.KeepPhotoVO;
import com.spring.mypage.KeepReturnVO;
import com.spring.order.OrderListVO;
import com.spring.order.OrderVO;
import com.spring.setak.KeepVO;
import com.spring.setak.MendingVO;
import com.spring.setak.WashingVO;

public interface MypageMapper {
	ArrayList<OrderVO> getOrderlist(HashMap<String, Object> map);
	ArrayList<OrderListVO> getOrdernumlist(HashMap<String, Object> map);
	ArrayList<KeepVO> selectMykeeplist(long order_num);
	int getOrdernumcount(String member_id);
	int selectMykeep(long order_num);
	KeepVO getKeepSeq(int keep_seq);
	OrderVO selectOrder(long order_num);
	int getOrdercount(String member_id);
	String selectOrderId(String member_id);
	ArrayList<MendingVO> selectMending(long order_num);
	ArrayList<KeepVO> selectKeep(long order_num);
	ArrayList<WashingVO> selectWashing(long order_num);
	int getKeepcount();
	
	//보관연장
	int updateKeepMonth(HashMap<String, Object> map);
	int all_Return(HashMap<String, Object> map);
	int part_Return_now(HashMap<String, Object> map);
	//반환
	int part_Return(KeepReturnVO krvo);
	MemberVO getMember(String member_id);
	
	//사진
	ArrayList<KeepPhotoVO> selectPhoto(long order_num);
	
	int updateReview(HashMap<String, Object> map);
	
	//qna
	int getQnaCount(String member_id);

}
