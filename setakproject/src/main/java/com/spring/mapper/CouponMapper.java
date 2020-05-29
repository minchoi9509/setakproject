package com.spring.mapper;

import java.util.ArrayList;

import com.spring.member.CouponVO;

public interface CouponMapper {

	// 쿠폰 리스트
	ArrayList<CouponVO> getCouponList(String member_id);
	ArrayList<CouponVO> getAbleCouponList(String member_id); 
	
	// 쿠폰 개수
	int getCouponCount(String member_id);
	
	// 쿠폰 사용
	int useCoupon(int coupon_seq); 
}
