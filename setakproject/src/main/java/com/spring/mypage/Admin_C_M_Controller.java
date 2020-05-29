package com.spring.mypage;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.spring.member.CouponVO;
import com.spring.member.MileageVO;

@RestController
public class Admin_C_M_Controller {
	
	@Autowired()
	private Admin_C_M_ServiceImpl admin_C_M_Service;
	
	@RequestMapping(value="/admin/admin_coupon.do")
	public ModelAndView coupon() {
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("admin/coupon");
		
		return mv;
	}
	
	
	@RequestMapping(value="/admin/coupon.do", produces = "application/json;charset=UTF-8")
	public ArrayList<Object> Admin_CouponList(){
		ArrayList<Object> list = admin_C_M_Service.Admin_CouponList();
		
		
		return list;
	}
	
	
	//검색
	@RequestMapping(value="/admin/couponSearch.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> couponSearch(@RequestParam(value="keyword") String keyword){
		HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("keyword", keyword);
			ArrayList<Object> couponlist = admin_C_M_Service.couponSerach(map); 
			int couponcount = 0; 
			couponcount = admin_C_M_Service.getCouponCount();
			
			Map<String, Object> res = new HashMap<String, Object>();
				res.put("couponlist", couponlist);
				res.put("couponcount", couponcount);
				
			return res;
	}
	
	//수정
	@RequestMapping(value="/admin/updateCoupon.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> updateCoupon(CouponVO params){
		Map<String, Object>retVal = new HashMap<String, Object>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			int res = admin_C_M_Service.updateCoupon(params);
			retVal.put("res", "OK");
		}
		catch(Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		
		return retVal;
	}
	
	//쿠폰 입력
	@RequestMapping(value="/admin/insertCoupon.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> insertCoupon(CouponVO cvo){
		Map<String, Object>retVal = new HashMap<String, Object>();

		try {
			int res = admin_C_M_Service.insertCoupon(cvo);
			
			retVal.put("res", "OK");
		}
		catch(Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		
		return retVal;
	}
	
	//쿠폰삭제
	@RequestMapping(value="/admin/deleteCoupon.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> deleteCoupon(@RequestParam(value="coupon_seq") List<Integer> coupon){
		Map<String, Object>retVal = new HashMap<String, Object>();
		try {
			ArrayList<Integer> couponlist = new ArrayList<Integer>();
			
			for (int i = 0; i < coupon.size(); i++) {
					couponlist.add(coupon.get(i));
			
			}
			for (int j = 0; j < couponlist.size(); j++) {
				admin_C_M_Service.deleteCoupon(couponlist.get(j));
				
			}
			retVal.put("res", "OK");

		}catch(Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		
		return retVal;
	}
	
	
	@RequestMapping(value="admin/admin_mile.do")
	public ModelAndView mileage() {
		
		ModelAndView mv = new ModelAndView();
		
		mv.setViewName("admin/mileage");
		
		return mv;
	}
	
	
	@RequestMapping(value="/admin/mileage.do", produces = "application/json;charset=UTF-8")
	public ArrayList<Object> Admin_MileList(){
		ArrayList<Object> list = admin_C_M_Service.Admin_MileList();
		
		return list;
	}
	
	//검색
	@RequestMapping(value="/admin/mileSearch.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> mileSearch(@RequestParam(value="keyword") String keyword){
		HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("keyword", keyword);
			ArrayList<Object> milelist = admin_C_M_Service.mileSerach(map); 
			int milecount = 0; 
			milecount = admin_C_M_Service.getMileCount();
			
			Map<String, Object> res = new HashMap<String, Object>();
				res.put("milelist", milelist);
				res.put("milecount", milecount);
				
			return res;
	}
	
	//수정
	@RequestMapping(value="/admin/updateMileage.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> updateMileage(MileageVO params){
		Map<String, Object>retVal = new HashMap<String, Object>();
		try {
			int res = admin_C_M_Service.updateMileage(params);
			retVal.put("res", "OK");
		}
		catch(Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		
		return retVal;
	}
	
	//쿠폰 입력
	@RequestMapping(value="/admin/insertMileage.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> insertMileage(MileageVO mvo){
		Map<String, Object>retVal = new HashMap<String, Object>();

		try {
			admin_C_M_Service.insertMileage(mvo);
			retVal.put("res", "OK");
		}
		catch(Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		
		return retVal;
	}
	
	//쿠폰삭제
	@RequestMapping(value="/admin/deleteMileage.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> deleteMileage(@RequestParam(value="mile_seq") List<Integer> mile){
		Map<String, Object>retVal = new HashMap<String, Object>();
		try {
			ArrayList<Integer> milelist = new ArrayList<Integer>();
			
			for (int i = 0; i < mile.size(); i++) {
				milelist.add(mile.get(i));
			
			}
			for (int j = 0; j < milelist.size(); j++) {
				admin_C_M_Service.deleteMileage(milelist.get(j));
				
			}
			retVal.put("res", "OK");

		}catch(Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		
		return retVal;
	}
	
	
}
