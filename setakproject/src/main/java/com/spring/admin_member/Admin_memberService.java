package com.spring.admin_member;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.member.MemberVO;

public interface Admin_memberService {
	//전체 회원리스트 출력 
	public  ArrayList<MemberVO> adminlist(HashMap<String, Object> map); 

	 //전체 회원리스트 갯수
	 public int adminlistcount();
	 
	 //오늘 가입한 회원 수
	 public int todaycount();
	 
	 //메모수정
	 public int update_memo(MemberVO mo);
	 
	//검색
	 public ArrayList<MemberVO> searchlist(HashMap<String, Object> map); 
	 
	//검색 리스트 갯수 
	public int searchlistcount(HashMap<String, Object> map); 
	
	 // 회원상세정보 보기  
	public MemberVO detail(String member_id);
	
	// 회원상세정보 수정 
	public int detail_update(HashMap<String, Object> map);

}
