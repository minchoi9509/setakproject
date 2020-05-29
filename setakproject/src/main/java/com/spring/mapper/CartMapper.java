package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.spring.order.KeepCartVO;
import com.spring.order.MendingCartVO;
import com.spring.order.WashingCartVO;
import com.spring.setak.KeepVO;
import com.spring.setak.MendingVO;
import com.spring.setak.WashingVO;

public interface CartMapper {
	
	// 시퀀스 읽기
	ArrayList<WashingCartVO> getWashSeq(String member_id);
	ArrayList<MendingCartVO> getMendingSeq(String member_id);
	ArrayList<KeepCartVO> getKeepSeq(String member_id);
	
	// 데이터 읽기
	WashingVO getWashingList(int wash_seq); 
	MendingVO getMendingList(int repair_seq);
	KeepVO getKeepList(int keep_seq);
	ArrayList<KeepVO> getKeepGroupList(HashMap<String, Object> map); 
	
	// 장바구니 비우기
	int deleteWashCart(int wash_seq);
	int deleteWash(int wash_seq); 
	
	int deleteMendingCart(int repair_seq);
	int deleteMending(int repair_seq);
	
	int deleteKeepCart(String member_id);
	int deleteKeep(int keep_seq); 

}
