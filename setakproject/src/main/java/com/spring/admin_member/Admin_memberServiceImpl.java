package com.spring.admin_member;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.Admin_memberMapper;
import com.spring.mapper.MemberMapper;
import com.spring.member.MemberVO;

@Service
public class Admin_memberServiceImpl implements Admin_memberService{

	@Autowired
	private SqlSession sqlsession;

	
	//전체 회원리스트 출력 
	@Override
	public  ArrayList<MemberVO> adminlist(HashMap<String, Object> map) {
		  ArrayList<MemberVO> list = new ArrayList<MemberVO>();
		 try {
			 Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
			 list = mapper.adminlist(map);
		 } catch(Exception e) {
				System.out.println("멤버 리스트 검색 실패" + e.getMessage());
		 }
		 
		 return list;
	}
	
	// 정기구독 리스트 갯수
		@Override
		public int adminlistcount() {
			int count = 0;

			Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
			count = mapper.adminlistcount();
			return count;
		}
		
	 //오늘 가입한 회원 수
	@Override
	public int todaycount() {
		int todaycount = 0;
		
		Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
		todaycount = mapper.todaycount();
		return todaycount;
	}
	
	//메모수정
	@Override
	public int update_memo(MemberVO mo) {
		int res = 0;
		try {
			Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
			mapper.update_memo(mo);
			res = 1;
		} catch(Exception e) {
			System.out.println("메모 수정 실패" + e.getMessage());
			 res = 0;
		}
		 return res;
	}
	
	//검색
	@Override
	public ArrayList<MemberVO> searchlist(HashMap<String, Object> map) {
		ArrayList<MemberVO> list = new ArrayList<MemberVO>();
		 try {
			 Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
			 list = mapper.searchlist(map);
		 } catch(Exception e) {
				System.out.println("멤버 리스트 검색 실패" + e.getMessage());
		 }
		 
		 return list;
		
	}
	
	//검색 리스트 갯수 
	@Override
	public int searchlistcount(HashMap<String, Object> map) {
		int searchcount = 0;
			 try {
				 Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
				 searchcount = mapper.searchlistcount(map);
			 } catch(Exception e) {
					System.out.println("검색 리스트 갯수 실패" + e.getMessage());
			 }
			 
			 return searchcount;
			
		}
		
	// 회원상세정보 보기 
	@Override
	public MemberVO detail(String member_id) {
		MemberVO mo = null;
		try {
			Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
			 mo = mapper.detail(member_id);
		 } catch(Exception e) {
				System.out.println("회원정보 상세보기 실패" + e.getMessage());
		 }
		 
		 return mo;
	}
	
	// 회원상세정보 수정 
	public int detail_update(HashMap<String, Object> map) {
		int res = 0;
		try {
			Admin_memberMapper mapper = sqlsession.getMapper(Admin_memberMapper.class);
			mapper.detail_update(map);
			res = 1;
		} catch(Exception e) {
			System.out.println("회원상세정보 수정 실패" + e.getMessage());
			 res = 0;
		}
		 return res;
	}
}
