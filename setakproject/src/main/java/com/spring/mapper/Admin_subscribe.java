package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.spring.member.MemberSubVO;

public interface Admin_subscribe {

	// 정기구독 회원 리스트
	List<Object> getMemberSubList();
	
	// 정기구독 회원 검색
	List<Object> subMemberSearch(HashMap<String, Object> map);
	// 정기구독 관리자 페이지 수정
	int updateMemberSubList(MemberSubVO msv);
	// 정기구독 관리자 페이지 삭제 > member_subs 테이블 변경
	int deleteMemberSubList(String member_id);
	// 정기구독 관리자 페이지 삭제 > member 테이블 변경
	int updateSubNum(HashMap<String, Object> map);
	
	// 정기구독 차트 > 전체 유형 비율 
	int getMemberSubCnt(String subsname); 
	int getMemberSubCnt2(String subsname); 
	// 정기구독 차트 > 일별 정기구독 신청 수 + 유형 비율 
	int getMemberDailySubCnt(HashMap<String, Object> map);
	
	// 정기구독 > 인기 차트 
	ArrayList<HashMap<String, Object>> getSubPopular(); 
	
}
