package com.spring.mypage;

import java.util.ArrayList;
import java.util.HashMap;

import com.spring.member.CouponVO;
import com.spring.member.MileageVO;

public interface Admin_C_M_Service {
	//일반 리스트
	public ArrayList<Object> Admin_CouponList();
	
	//검색
	public ArrayList<Object> couponSerach (HashMap<String, Object> map);
	
	//쿠폰수
	public int getCouponCount();
	
	//쿠폰 수정
	public int updateCoupon(CouponVO params);
	
	//쿠폰 입력
	public int insertCoupon(CouponVO cvo);
	
	//쿠폰삭제
	public int deleteCoupon(int coupon);
	
	
	
	
	//마일리지
		//목록
	public ArrayList<Object> Admin_MileList();
			
			//검색
	public ArrayList<Object> mileSerach (HashMap<String, Object> map);
			
			//마일리지수 
	public int getMileCount();
			
			//마일리지수정
	public int updateMileage(MileageVO params);
			
			//마일리지입력
	public int insertMileage(MileageVO mvo);

			//마일리지 삭제
	public int deleteMileage(int mile);

}
