package com.spring.mapper;

import java.util.ArrayList;

import com.spring.community.ReviewLikeVO;




public interface ReviewLikeMapper 
{
	
	public void insertReviewLike(ReviewLikeVO vo);
    public void deleteReviewLike(ReviewLikeVO vo);
    public int getReviewLike(ReviewLikeVO vo);
    public void updateReviewLike1(ReviewLikeVO vo);
    public void updateReviewLike2(ReviewLikeVO vo);
}
