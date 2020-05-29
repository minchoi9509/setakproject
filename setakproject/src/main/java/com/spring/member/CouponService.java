package com.spring.member;

import java.util.ArrayList;

public interface CouponService {

	// 쿠폰 리스트
	public ArrayList<CouponVO> getCouponList(String member_id);
	public ArrayList<CouponVO> getAbleCouponList(String member_id); 
	// 쿠폰 갯수
	public int getCouponCount(String member_id);
	// 쿠폰 사용
	public int useCoupon(int coupon_seq);
}
