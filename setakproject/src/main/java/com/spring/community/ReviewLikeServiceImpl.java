package com.spring.community;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.spring.mapper.ReviewLikeMapper;

@Service("reviewLikeService")
public class ReviewLikeServiceImpl implements ReviewLikeService
{
	@Autowired (required = false) private SqlSession sqlSession;
	
	public void insertReviewLike(ReviewLikeVO vo) 
	{
		ReviewLikeMapper reviewLikeMapper = sqlSession.getMapper(ReviewLikeMapper.class);
		reviewLikeMapper.insertReviewLike(vo);
		System.out.println("서비스임플 인설트까지 오냐");
		
	}
    public void deleteReviewLike(ReviewLikeVO vo)
    {
    	ReviewLikeMapper reviewLikeMapper = sqlSession.getMapper(ReviewLikeMapper.class);
    	reviewLikeMapper.deleteReviewLike(vo);
    	System.out.println("서비스임플 딜리트까지 오냐");
    	
    	
	}
	@Override
	public int getReviewLike(ReviewLikeVO vo) {
		ReviewLikeMapper reviewLikeMapper = sqlSession.getMapper(ReviewLikeMapper.class);		
		return reviewLikeMapper.getReviewLike(vo);
		
	}
	@Override
	public void updateReviewLike1(ReviewLikeVO vo) {
		ReviewLikeMapper reviewLikeMapper = sqlSession.getMapper(ReviewLikeMapper.class);
		reviewLikeMapper.updateReviewLike1(vo);
		
	}
	@Override
	public void updateReviewLike2(ReviewLikeVO vo) {
		ReviewLikeMapper reviewLikeMapper = sqlSession.getMapper(ReviewLikeMapper.class);
		reviewLikeMapper.updateReviewLike2(vo);
		
	}

	
}
