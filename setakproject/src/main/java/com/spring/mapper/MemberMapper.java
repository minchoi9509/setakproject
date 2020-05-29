package com.spring.mapper;

import java.util.HashMap;

import com.spring.member.MemberVO;

public interface MemberMapper {
	
	//아이디 확인(중복여부)
	String member_id(MemberVO mo);
	
	//회원가입
	void member_insert(MemberVO mo);
	
	//비밀번호 확인
	String member_password(MemberVO mo);
	String member_password2(HashMap<String, Object> map);
	
	// 회원정보 출력
	MemberVO member_list(MemberVO mo);
	
	// 회원정보 수정
	void member_update(MemberVO mo);
	
	 // 멤버 이름
	 MemberVO name(String member_id);
	 
	//로그인 연동시 회원가입
	 void linkage(MemberVO mo);
	
	//아이디 보여주기   
	 String show_id(HashMap<String, Object> map); 
	 
	// 비밀번호 찾기- 변경하기 버튼
	String chk_you(HashMap<String, Object> map); 

	//비밀번호 변경
	void change_pw(HashMap<String, Object> map); 
	 
	//회원 삭제
	void member_delete(String member_id);
	
}
