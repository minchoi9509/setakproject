package com.spring.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.member.CouponVO;
import com.spring.member.MileageVO;

public interface Admin_C_M_Mapper {
	//목록
	ArrayList<Object> Admin_CouponList();
	
	//검색
	ArrayList<Object> couponSerach (HashMap<String, Object> map);
	
	//쿠폰수 
	int getCouponCount();
	
	//쿠폰수정
	int updateCoupon(CouponVO params);
	
	//쿠폰입력
	int insertCoupon(CouponVO cvo);

	//쿠폰 삭제
	int deleteCoupon(int coupon);
	
	
	
	//마일리지
	//목록
		ArrayList<Object> Admin_MileList();
		
		//검색
		ArrayList<Object> mileSerach (HashMap<String, Object> map);
		
		//마일리지수 
		int getMileCount();
		
		//마일리지수정
		int updateMileage(MileageVO params);
		
		//마일리지입력
		int insertMileage(MileageVO cvo);

		//마일리지 삭제
		int deleteMileage(int coupon);
}
