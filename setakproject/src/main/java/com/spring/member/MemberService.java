package com.spring.member;

import java.util.HashMap;

public interface MemberService {
	
	//아이디 확인(중복여부)
	public int member_id(MemberVO mo);
	
	//회원가입
	public int member_insert(MemberVO mo);
	
	//비밀번호 확인
	public int member_password(MemberVO mo);
	public int member_password2(HashMap<String, Object> map);
	
	// 회원정보 출력
	public MemberVO member_list(MemberVO mo);
	
	// 회원정보 수정
	public int member_update(MemberVO mo);
	
	// 멤버 이름
	public MemberVO name(String member_id);

	//로그인 연동시 회원가입
	public int linkage(MemberVO mo);
	
	//아이디 보여주기   
	public String show_id(HashMap<String, Object> map);
	
	// 비밀번호 찾기- 변경하기 버튼
	public int chk_you(HashMap<String, Object> map); 

	//비밀번호 변경
	public int change_pw(HashMap<String, Object> map); 
		 
	
	//회원 삭제
	public int member_delete(String member_id);

}
