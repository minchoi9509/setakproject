package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.member.HistorySubVO;
import com.spring.member.MemberSubVO;
import com.spring.member.SubscribeVO;

public interface MemberSubMapper {
	
	 // 나의정기구독
	 MemberSubVO sub_list(String member_id);
	
	 // 해당 정기구독 리스트
	 SubscribeVO subscribe_list(String member_id);
	 
	 // 정기구독 내역 리스트
	 ArrayList<HistorySubVO>subhistory_list(HashMap<String, Object> map); 

	 // 정기구독 리스트 갯수
	 int listcount(String member_id);
	 
	//수거고
	 int sugo2(String member_id);
		 
	 //수거고취소
	 int sugo0(String member_id);
	 
	 //구독해지함
	 int subcancle(String member_id);
	 
	 //재구독함
     int resub(String member_id);
     
     //리뷰 작성
     int review_chk(HashMap<String, Object> map);
	 
}
