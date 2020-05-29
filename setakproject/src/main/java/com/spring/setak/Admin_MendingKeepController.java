package com.spring.setak;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class Admin_MendingKeepController {

	@Autowired()
	private Admin_MendingKeepService mendingKeepService;
	
	@RequestMapping("/admin/admin_wash.do")
	public ModelAndView admin_wash() {
		ModelAndView result = new ModelAndView();
		result.setViewName("./admin/admin_wash");
		return result;
	}
	
	@RequestMapping("/admin/admin_mending.do")
	public ModelAndView admin_mending() {
		ModelAndView result = new ModelAndView();
		result.setViewName("./admin/admin_mending");
		return result;
	}
	
	@RequestMapping("/admin/admin_keep.do")
	public ModelAndView admin_keep() {
		ModelAndView result = new ModelAndView();
		result.setViewName("./admin/admin_keep");
		return result;
	}
	
	//세탁
	@RequestMapping(value="/getWashList.do", produces="application/json;charset=UTF-8")
	public List<Object> getWashList() {
		List<Object> list = mendingKeepService.getWashList();
		
		return list;
	}

	@RequestMapping(value="/updateWash.do", produces="application/json;charset=UTF-8")
	public Map<String, Object> updateWash(WashingVO params){
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = mendingKeepService.updateWash(params);
			retVal.put("res", "OK");
		}
		catch(Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		return retVal;
	}
	
	@RequestMapping(value = "/admin/deleteWash.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> deleteWash(@RequestParam(value = "wash_seq") List<Integer> wash) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			ArrayList<Integer> washlist = new ArrayList<Integer>();
			for (int i = 0; i < wash.size(); i++) {
				washlist.add(wash.get(i));
			}
			
			for (int j = 0; j < washlist.size(); j++) {
				mendingKeepService.deleteWash(washlist.get(j));
			}
			retVal.put("res", "OK");
		} catch (Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		return retVal;
	}
	
	@RequestMapping(value="/admin/washSearch.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> washSearch(@RequestParam(value="keyword") String keyword){
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		List<Object> washlist = mendingKeepService.washSearch(map); 
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("washlist", washlist);
	
		return res;
	}
	
	//수선
	@RequestMapping(value="/getMendingList.do", produces="application/json;charset=UTF-8")
	public List<Object> getMendingList() {
		List<Object> list = mendingKeepService.getMendingList();
		
		return list;
	}
	
	@RequestMapping(value="/updateMending.do", produces="application/json;charset=UTF-8")
	public Map<String, Object> updateMending(MendingVO params){
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = mendingKeepService.updateMending(params);
			retVal.put("res", "OK");
		}
		catch(Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		return retVal;
	}
	
	@RequestMapping(value = "/admin/deleteMending.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> deleteMending(@RequestParam(value = "mending_seq") List<Integer> mending) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			ArrayList<Integer> mendinglist = new ArrayList<Integer>();
			for (int i = 0; i < mending.size(); i++) {
				mendinglist.add(mending.get(i));
			}
			
			for (int j = 0; j < mendinglist.size(); j++) {
				mendingKeepService.deleteMending(mendinglist.get(j));
			}
			retVal.put("res", "OK");
		} catch (Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		return retVal;
	}
	
	@RequestMapping(value="/admin/mendingSearch.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> mendingSearch(@RequestParam(value="keyword") String keyword){
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		List<Object> mendinglist = mendingKeepService.mendingSearch(map); 
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("mendinglist", mendinglist);
	
		return res;
	}
	
	@RequestMapping(value="/admin/mendingLoadImg.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> mendingLoadImg(@RequestParam(value="repair_seq") String repair_seq){
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("repair_seq", repair_seq);
		List<Object> imglist = mendingKeepService.mendingLoadImg(map);
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("imglist", imglist);
	
		return res;
	}
	
	@RequestMapping(value="/admin/deleteMendingImg.do", produces = "application/json;charset=UTF-8")
	public void deleteMendingImg(@RequestParam(value="repair_file") String repair_file){
		mendingKeepService.deleteMendingImg(repair_file);	
	}
	
	@RequestMapping(value="/MendingImg.do")
	public String MendingImg(HttpSession session , HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer = response.getWriter();
		
		String repair_file = request.getParameter("repair_file");
		String order_num = request.getParameter("order_num");
		String repair_code = request.getParameter("repair_code");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("repair_file",repair_file);	
		map.put("order_num",order_num);
		map.put("repair_code",repair_code);

		int res = mendingKeepService.MendingImg(map);
	
		if(res == 0 ) {
			writer.write("<script>alert('사진 업로드 실패!'); location.href='javascript:history.back()';</script>");
		}
		if(res > 0) {
			writer.write("<script>alert('사진 업로드가 정상적으로 이루어 졌습니다.'); location.href='javascript:history.back()'; </script>");
		}
		return null;
	}
	
	//보관
	@RequestMapping(value="/getKeepList.do", produces="application/json;charset=UTF-8")
	public List<Object> getKeepList() {
		List<Object> list = mendingKeepService.getKeepList();
		
		return list;
	}
	
	@RequestMapping(value="/updateKeep.do", produces="application/json;charset=UTF-8")
	public Map<String, Object> updateKeep(KeepVO params){
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = mendingKeepService.updateKeep(params);
			retVal.put("res", "OK");
		}
		catch(Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		return retVal;
	}
	
	@RequestMapping(value="/keepImg.do")
	public String keepImg(HttpSession session , HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter writer = response.getWriter();
		
		String keep_path[] = request.getParameterValues("keep_path");
		String order_num = request.getParameter("order_num");
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		int res = 0;
		for(int i =0; i<keep_path.length; i++) {
			String keep[] = keep_path[i].split(",");
			for(int j=0; j<keep.length; j++) {
				map.put("keep_path",keep[j]);	
				map.put("order_num",order_num);

				res = mendingKeepService.keepImg(map);
			}
			if(res ==0 ) 
			{
				writer.write("<script>alert('사진 업로드 실패!'); location.href='javascript:history.back()';</script>");
			}
			if(res==1) {
				writer.write("<script>alert('사진 업로드가 정상적으로 이루어 졌습니다.'); location.href='javascript:history.back()'; </script>");
			}
		}
		return null;
	}
	
	@RequestMapping(value="/admin/deleteImg.do", produces = "application/json;charset=UTF-8")
	public void deleteImg(@RequestParam(value="keep_path") String keep_path){
		mendingKeepService.deleteImg(keep_path);	
	}
	
	@RequestMapping(value="/admin/loadImg.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> loadImg(@RequestParam(value="order_num") String order_num){
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("order_num", order_num);
		List<Object> imglist = mendingKeepService.loadImg(map);
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("imglist", imglist);
	
		return res;
	}
	
	@RequestMapping(value = "/admin/deleteKeep.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> deletekeep(@RequestParam(value = "keep_seq") List<Integer> keep) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			ArrayList<Integer> keeplist = new ArrayList<Integer>();
			for (int i = 0; i < keep.size(); i++) {
				keeplist.add(keep.get(i));
			}
			
			for (int j = 0; j < keeplist.size(); j++) {
				mendingKeepService.deleteKeep(keeplist.get(j));
			}
			retVal.put("res", "OK");
		} catch (Exception e) {
			retVal.put("res", "fail");
			retVal.put("message", "fail");
		}
		return retVal;
	}
	
	@RequestMapping(value="/admin/keepSearch.do", produces = "application/json;charset=UTF-8")
	public Map<String, Object> keepSearch(@RequestParam(value="keyword") String keyword){
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("keyword", keyword);
		List<Object> keeplist = mendingKeepService.keepSerach(map); 
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("keeplist", keeplist);
	
		return res;
	}
	
}
