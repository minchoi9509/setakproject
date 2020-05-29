package com.spring.member;

import java.util.ArrayList;
import java.util.HashMap;

public interface MemberSubService {
	
	// 나의정기구독
	public MemberSubVO sub_list(String member_id);
	
	// 해당 정기구독 리스트
	public SubscribeVO subscribe_list (String member_id);
	
	// 정기구독 내역 리스트
	public ArrayList<HistorySubVO> subhistory_list(HashMap<String, Object> map); 

	// 정기구독 리스트 갯수
	public int listcount(String member_id); 	
	
	//수거고
	public int sugo2(String member_id);
			 
	//수거고취소
	public int sugo0(String member_id);
	
	//구독해지함
	public int subcancle(String member_id);
		 
    //재구독함
	public int resub(String member_id);
	
	//리뷰 작성
    public int review_chk(HashMap<String, Object> map);
}
