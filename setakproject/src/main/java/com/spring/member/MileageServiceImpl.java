package com.spring.member;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.MileageMapper;

@Service
public class MileageServiceImpl implements MileageService {


	@Autowired
	private SqlSession sqlSession;
	

	@Override
	public int getSum(String member_id) {
		int sum = 0;
		try {
			MileageMapper mileageMapper = sqlSession.getMapper(MileageMapper.class);
			sum = mileageMapper.getSum(member_id);
		} catch(Exception e) {
			System.out.println("사용가능금액 총합 계산 실패" + e.getMessage());
		}
		return sum; 
	}
	
	
	//기응
	@Override
	public ArrayList<MileageVO> getMileagelist(HashMap<String, Object> map){
		ArrayList<MileageVO> mileagelist = new ArrayList<MileageVO>();
		
		try {
			MileageMapper mileageMapper = sqlSession.getMapper(MileageMapper.class);
			mileagelist = mileageMapper.getMileagelist(map);
			
		}catch(Exception e) {
			System.out.println("적립금 리스트 실패" + e.getMessage());
		}
		
		return mileagelist;
	}
	
	@Override
	public int getListCount(String member_id) {
		int count=0;
		MileageMapper mileageMapper = sqlSession.getMapper(MileageMapper.class);
		try {
			count = mileageMapper.getListCount(member_id);
		}catch(Exception e) {
			System.out.println("카운트 실패" + e.getMessage());
		}
		
		return count;
	}
	
	@Override
	public int totSum(String member_id) {
		int sum = 0;
		try {
			MileageMapper mileageMapper = sqlSession.getMapper(MileageMapper.class);
			sum = mileageMapper.totSum(member_id);
		} catch(Exception e) {
			System.out.println("총적립금 계산 실패" + e.getMessage());
		}
		return sum; 
	}
	
	@Override
	public int useSum(String member_id) {
		int sum = 0;
		try {
			MileageMapper mileageMapper = sqlSession.getMapper(MileageMapper.class);
			sum = mileageMapper.useSum(member_id);
		} catch(Exception e) {
			System.out.println("사용한금액 총합 계산 실패" + e.getMessage());
		}
		return sum; 
	}


	@Override
	public int useMileage(MileageVO mvo) {
		int res = 0;
		try {
			MileageMapper mileageMapper = sqlSession.getMapper(MileageMapper.class);
			res = mileageMapper.useMileage(mvo);
		} catch(Exception e) {
			System.out.println("적립금 사용 입력 실패" + e.getMessage());
		}
		return res; 
	}
}
