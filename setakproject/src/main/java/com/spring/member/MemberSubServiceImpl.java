package com.spring.member;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.MemberSubMapper;

@Service
public class MemberSubServiceImpl implements MemberSubService{

	@Autowired
	private SqlSession sqlsession;
	
	 //나의정기구독
	@Override
	public MemberSubVO sub_list(String member_id) {
		MemberSubVO msv = null;
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			msv = mapper.sub_list(member_id);
		} catch (Exception e) {
			System.out.println("나의 정기구독 실패"+e.getMessage());
		}
		return msv;
		
	}
	
	// 해당 정기구독 리스트
	@Override
	public  SubscribeVO subscribe_list(String member_id) {
		 SubscribeVO sv = null;
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			sv = mapper.subscribe_list(member_id);
		} catch (Exception e) {
			System.out.println("해당 정기구독 리스트 실패"+e.getMessage());
		}
		return sv;
		
	}
	
	
	 // 정기구독 내역 리스트
	@Override
	public ArrayList<HistorySubVO> subhistory_list(HashMap<String, Object> map){
		ArrayList<HistorySubVO> list = new ArrayList<HistorySubVO> ();
		
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			list = mapper.subhistory_list(map);
		} catch (Exception e) {
			System.out.println("정기구독 리스트 실패"+e.getMessage());
		}
		return list;
			
	}
	
	// 정기구독 리스트 갯수
	@Override
	public int listcount(String member_id) {
		int count = 0;

		MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
		count = mapper.listcount(member_id);
		return count;
	}
	
	//구독해지함
	@Override
	public int subcancle(String member_id) {
		int res = 0;
		
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			res = mapper.subcancle(member_id);
			res = 1;
		} catch (Exception e) {
			System.out.println("구독해지 실패"+e.getMessage());
			res = -1;
		}
		return res;
	}
	
	//수거고
	public int sugo2(String member_id) {
		int res = 0;
		
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			res = mapper.sugo2(member_id);
			res = 1;
		} catch (Exception e) {
			System.out.println("수거고 실패"+e.getMessage());
			res = -1;
		}
		return res;
	}
				 
	//수거고취소
	public int sugo0(String member_id) {
		int res = 0;
		
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			res = mapper.sugo0(member_id);
			res = 1;
		} catch (Exception e) {
			System.out.println("수거고취소 실패"+e.getMessage());
			res = -1;
		}
		return res;
	}
		
	//재구독함
	@Override
	public int resub(String member_id) {
		int res = 0;
		
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			res = mapper.resub(member_id);
			res = 1;
		} catch (Exception e) {
			System.out.println("재구독 실패"+e.getMessage());
			res = -1;
		}
		return res;
	}
	
	//리뷰 작성
    public int review_chk(HashMap<String, Object> map) {
    	int res = 0;
		
		try {
			MemberSubMapper mapper = sqlsession.getMapper(MemberSubMapper.class);
			res = mapper.review_chk(map);
			res = 1;
		} catch (Exception e) {
			System.out.println("리뷰 작성 실패"+e.getMessage());
			res = -1;
		}
		return res;
    }
}
