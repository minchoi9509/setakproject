package com.spring.mypage;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.mapper.Admin_C_M_Mapper;
import com.spring.member.CouponVO;
import com.spring.member.MileageVO;

@Service("admin_C_M_Service")
public class Admin_C_M_ServiceImpl implements Admin_C_M_Service {
	
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public ArrayList<Object> Admin_CouponList(){
		ArrayList<Object> list = null;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		list = mapper.Admin_CouponList();
		
		return list;
	}
	
	@Override
	public ArrayList<Object> couponSerach (HashMap<String, Object> map){
	
		ArrayList<Object> couponlist = null;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		couponlist = mapper.couponSerach(map);
		return couponlist;
	}
	
	@Override
	public int getCouponCount() {
		int count = 0;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		count = mapper.getCouponCount();
		
		return count;
	}
	
	@Override
	public int updateCoupon(CouponVO params) {
		int res = 0;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		res = mapper.updateCoupon(params);
		
		return res;
	}
	
	@Override
	public int insertCoupon(CouponVO cvo) {
		int res = 0;
		
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		res = mapper.insertCoupon(cvo);
		
		return res;
	}
	
	@Override
	public int deleteCoupon(int coupon) {
		int res = 0;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		res = mapper.deleteCoupon(coupon);
		
		return res;
		
		
	}
	
	@Override
	public ArrayList<Object> Admin_MileList(){
		ArrayList<Object> list = null;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		list = mapper.Admin_MileList();
		
		return list;
	}
	
	@Override
	public ArrayList<Object> mileSerach (HashMap<String, Object> map){
	
		ArrayList<Object> milelist = null;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		milelist = mapper.mileSerach(map);
		
		return milelist;
	}
	
	@Override
	public int getMileCount() {
		int count = 0;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		count = mapper.getMileCount();
		
		return count;
	}
	
	@Override
	public int updateMileage(MileageVO params) {
		int res = 0;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		res = mapper.updateMileage(params);
		
		return res;
	}
	
	@Override
	public int insertMileage(MileageVO cvo) {
		int res = 0;
		
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		res = mapper.insertMileage(cvo);
		
		return res;
	}
	
	@Override
	public int deleteMileage(int mile) {
		int res = 0;
		Admin_C_M_Mapper mapper = sqlSession.getMapper(Admin_C_M_Mapper.class);
		
		res = mapper.deleteMileage(mile);
		
		return res;
		
		
	}
	
}
