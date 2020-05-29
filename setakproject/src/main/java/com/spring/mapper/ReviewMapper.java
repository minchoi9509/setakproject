package com.spring.mapper;

import java.util.ArrayList;

import com.spring.community.ReviewVO;
import com.spring.order.OrderVO;


public interface ReviewMapper 
{
	
	
	public int reviewInsert(ReviewVO vo);
	
	public int getMaxNum();
	public ArrayList<ReviewVO> reviewList();
	public void insertMileage( String member_id, int mile_price , String mile_content);
	public ArrayList<ReviewVO> reviewSearch(String keyfield, String keyword);
	public ArrayList<ReviewVO> reviewCondition1(String re_condition);
	public ArrayList<ReviewVO> reviewCondition2(String re_condition);
	public ArrayList<ReviewVO> reviewCondition3(String re_condition);
	public int reviewDelete(int review_num); 
	public int reviewUpdate(ReviewVO vo); 
	public int reviewCheck(OrderVO vo); 
	public String getMemberName (String name);
	
	
	

	
	
	
	
}
