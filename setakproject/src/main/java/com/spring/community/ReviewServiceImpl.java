package com.spring.community;


import java.util.ArrayList;


import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.QnaMapper;
import com.spring.mapper.ReviewMapper;

@Service("reviewService")
public class ReviewServiceImpl implements ReviewService 
{
	@Autowired (required = false) private SqlSession sqlSession;
	
	

	@Override
	public ArrayList<ReviewVO> reviewList() throws Exception 
	{
		
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);			
		ArrayList<ReviewVO> list = reviewMapper.reviewList(); 
		return list; 
	}

	@Override
	public int reviewInsert(ReviewVO vo) throws Exception 
	{
		int res=0;
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);
		try
		{				
			res = reviewMapper.reviewInsert(vo);			
		}
		catch (Exception e)
		{
			throw new Exception(" 원글 쓰기  실패", e);			
		}
		return res;
	}

	

	@Override
	public ArrayList<ReviewVO> reviewSearch(String keyfield, String keyword) 
	{
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);			
		ArrayList<ReviewVO> list = reviewMapper.reviewSearch(keyfield, keyword);
		return list; 
	}

	@Override
	public ArrayList<ReviewVO> reviewCondition1(String re_condition) 
	{
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);			
		ArrayList<ReviewVO> list = reviewMapper.reviewCondition1(re_condition); 
		return list; 
	}
	@Override
	public ArrayList<ReviewVO> reviewCondition2(String re_condition) 
	{
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);			
		ArrayList<ReviewVO> list = reviewMapper.reviewCondition2(re_condition); 
		return list; 
	}
	@Override
	public ArrayList<ReviewVO> reviewCondition3(String re_condition) 
	{
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);			
		ArrayList<ReviewVO> list = reviewMapper.reviewCondition3(re_condition); 
		return list; 
	}

	@Override
	public int reivewDelete(ReviewVO vo) 
	{
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);		
		int res = reviewMapper.reviewDelete(vo.getReview_num());
		return res;
	}

	@Override
	public int reivewUpdate(ReviewVO vo)throws Exception {
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);		
		int res =0;
		try
		{
			res = reviewMapper.reviewUpdate(vo);
			
		}
		catch (Exception e)
		{
			throw new Exception("수정 실패", e);
		}
		return res;		
	}

	@Override
	public void insertMileage(ReviewVO vo, int mile_price, String mile_content) {
		System.out.println(vo.getMember_id());
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);
		reviewMapper.insertMileage(vo.getMember_id(), mile_price, mile_content);
		System.out.println(1);
		
	}

	@Override
	public String getMemberName(String name) {
		ReviewMapper reviewMapper = sqlSession.getMapper(ReviewMapper.class);
		String member_name = reviewMapper.getMemberName(name);
		return member_name;
	}
	

}

