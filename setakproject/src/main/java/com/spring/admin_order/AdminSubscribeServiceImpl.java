package com.spring.admin_order;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.Admin_subscribe;
import com.spring.member.MemberSubVO;

@Service
public class AdminSubscribeServiceImpl implements AdminSubscribeService {
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<Object> getMemberSubList() {
		List<Object> memberSubList = null;
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			memberSubList = adminSubscribeMapper.getMemberSubList();
		} catch(Exception e) {
			System.out.println("관리자 페이지 회원 목록 검색 실패" + e.getMessage());
		}
		
		return memberSubList;
	}

	@Override
	public List<Object> subMemberSearch(HashMap<String, Object> map) {
		List<Object> memberSubList = null;
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			memberSubList = adminSubscribeMapper.subMemberSearch(map);
		} catch(Exception e) {
			System.out.println("관리자 페이지 회원 검색 실패" + e.getMessage());
		}
		
		return memberSubList;
	}

	@Override
	public int updateMemberSubList(MemberSubVO msv) {
		int res = 0; 
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			res = adminSubscribeMapper.updateMemberSubList(msv);
		} catch(Exception e) {
			System.out.println("관리자 페이지 회원 정보 수정 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int deleteMemberSubList(String member_id) {
		int res = 0; 
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			res = adminSubscribeMapper.deleteMemberSubList(member_id);
		} catch(Exception e) {
			System.out.println("관리자 페이지 회원 정보 삭제 실패 > member_subs 정보 삭제 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int updateSubNum(HashMap<String, Object> map) {
		int res = 0; 
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			res = adminSubscribeMapper.updateSubNum(map);
		} catch(Exception e) {
			System.out.println("관리자 페이지 회원 정보 삭제 실패 > member 테이블 정보 수정 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int getMemberSubCnt(String subsname) {
		int res = 0; 
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			res = adminSubscribeMapper.getMemberSubCnt(subsname);
		} catch(Exception e) {
			System.out.println("정기구독 차트 > 전체 유형 비율 검색 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int getMemberDailySubCnt(HashMap<String, Object> map) {
		int res = 0; 
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			res = adminSubscribeMapper.getMemberDailySubCnt(map);
		} catch(Exception e) {
			System.out.println("정기구독 차트 > 일별 정기구독 신청 수 + 유형 비율  검색 실패" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public int getMemberSubCnt2(String subsname) {
		int res = 0; 
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			res = adminSubscribeMapper.getMemberSubCnt2(subsname);
		} catch(Exception e) {
			System.out.println("정기구독 차트 > 전체 유형 비율 검색 실패2" + e.getMessage());
		}
		
		return res;
	}

	@Override
	public ArrayList<HashMap<String, Object>> getSubPopular() {
		ArrayList<HashMap<String, Object>> subList = null;
		try {
			Admin_subscribe adminSubscribeMapper = sqlSession.getMapper(Admin_subscribe.class);
			subList = adminSubscribeMapper.getSubPopular();
		} catch(Exception e) {
			System.out.println("정기구독 > 인기 순위 검색 실패 " + e.getMessage());
		}
		
		return subList;
	}



}
