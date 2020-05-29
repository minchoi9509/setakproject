package com.spring.community;

import java.io.File;
import java.io.FileInputStream;

import java.io.PrintWriter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import org.springframework.web.multipart.MultipartHttpServletRequest;


@Controller public class ReviewController 
{
	@Autowired private ReviewService reviewService;
	
	@RequestMapping (value = "/review.do") public String review(Model model) throws Exception
	{	
		
		ArrayList<ReviewVO> list = reviewService.reviewList();
		String a = null;
	    String b = null;
	    
		HashMap<String, Object> m_namelist = new HashMap<String, Object>();
		
	      for(int i =0; i<list.size(); i++) {
	    	  a= list.get(i).getMember_id();    
	    	  b= reviewService.getMemberName(a); 
	    	  m_namelist.put(a,b);
	      }
		model.addAttribute("reviewlist", list); 
		model.addAttribute("m_namelist", m_namelist);
		
		return "review_list";			
	}
	
	@RequestMapping (value="/reviewList.do", produces="application/json; charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST} )
	@ResponseBody public ArrayList<ReviewVO> reviewList(Model model) throws Exception
	{
		ArrayList<ReviewVO> list = reviewService.reviewList();
		System.out.println(list.get(1));
		model.addAttribute("reviewList", list);	
		return list;		
	}
	
	@PostMapping(value = "/reviewInsert.do") public String reviewInsert(HttpSession session ,MultipartHttpServletRequest request, HttpServletResponse response) throws Exception 
	{
		
		ReviewVO vo = new ReviewVO();
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer  = response.getWriter();	
		int mile_price = 0;
		String mile_content	="";		
		
		vo.setMember_id((String)session.getAttribute("member_id"));
		vo.setReview_kind(request.getParameter("Review_kind"));	
		vo.setReview_star(Double.parseDouble( request.getParameter("Review_star"))*2);
		vo.setReview_content(request.getParameter("Review_content"));
		vo.setReview_like(request.getParameter("Review_like"));
		
		if(request.getParameter("Review_photo").equals("")) {
			vo.setReview_photo("등록한 파일이 없습니다._등록한 파일이 없습니다.");
			mile_price = 500;
			mile_content ="리뷰 적립";	
			reviewService.insertMileage(vo, mile_price, mile_content );
		}else {
			vo.setReview_photo(request.getParameter("Review_photo"));
			mile_price = 1500;
			mile_content ="사진 리뷰 적립";
			reviewService.insertMileage(vo, mile_price, mile_content);
		}	
		
		int res = reviewService.reviewInsert(vo);		
		
		
		
		
		
		if(res == 0 ) 
		{
			writer.write("<script>alert('수정 실패');location.href='./review.do';</script>");			
			return null;
		}
		writer.write("<script>location.href='./review.do';</script>");
		return null;
			
	}
	
	@PostMapping(value = "/fileDownload.do") public void fileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		response.setCharacterEncoding("UTF-8");
		String of = request.getParameter("of"); //서버에 업로드된 변경된 실제 파일명
		String of2 = request.getParameter("of2"); // 오리지날 파일명 
		//두 이름 모두 전달해줌 
		/*
		 웹사이트 루트디렉토리의 실제 디스트상의 경로 알아내기 
		String uploadPath = request.getSession().getServletContext().getRealPath("/upload");
		String fullPath = uploadPath+"/"+of;
		*/
		
		String uploadPath="C:\\Project138\\upload\\";		
		//직접 경로 지정
		String fullPath = uploadPath + of;
		File downloadFile = new File (fullPath);
		
		//파일 다운로드 컨텐츠 타입을 위한 application/download 설정 
		response.setContentType("application/download; charset=UTF-8");
		
		//파일사이즈 지정
		response.setContentLength((int)downloadFile.length()); //파일의 길이 -> 파일의 크기
		
		//다운로드 창을 띄우기 위한 헤더 조작 
		response.setHeader("Content-Disposition", "attachment; filename=" + new String(of2.getBytes(),"ISO8859_1"));
		response.setHeader("Content-Transfer-Encoding", "binary"); //전송 시,  엔코딩 방식,형식 ( binary: 이진수)
		
		FileInputStream fin = new FileInputStream(downloadFile);//실제 파일명을 담아 
		ServletOutputStream sout = response.getOutputStream(); //출력할 객체 (서버에서 클라이언트로 )
		
		byte[] buf = new byte[1024];
		int size = -1;
		while ((size = fin.read(buf, 0, buf.length)) != -1 ) //읽다가 끝에 도달하면 -1과 마주한다 .-1을 만나면 빠져나오기 
		{
			sout.write(buf, 0, size); //버퍼크기반큼 읽어와서 0번쨰 위치부터 쭉
	
		}
		fin.close();
		sout.close();

	}
	
	@RequestMapping (value="/reviewSearch.do", produces="application/json; charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST} )
	@ResponseBody public ArrayList<ReviewVO> reviewSearch(HttpServletRequest request, Model model,String keyfield, String keyword ) throws Exception
	{
		keyfield=request.getParameter("keyfield");
		keyword=request.getParameter("keyword");
		ArrayList<ReviewVO> list = reviewService.reviewSearch(keyfield, keyword);
		model.addAttribute("reviewSearch", list);	
		return list;		
	}
	
	@RequestMapping (value="/reviewCondition.do", produces="application/json; charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST} )
	@ResponseBody public ArrayList<ReviewVO> reviewCondition (HttpServletRequest request, Model model, String re_condition) throws Exception
	{
		re_condition=request.getParameter("re_condition");	
		if(re_condition.equals("review_date")) {
			ArrayList<ReviewVO> list = reviewService.reviewCondition1(re_condition);
			model.addAttribute("reviewCondition1", list);
			return list;
		}else if(re_condition.equals("review_like")) {
			ArrayList<ReviewVO> list = reviewService.reviewCondition2(re_condition);
			model.addAttribute("reviewCondition2", list);	
			return list;
			
		}else {
			ArrayList<ReviewVO> list = reviewService.reviewCondition3(re_condition);
			model.addAttribute("reviewCondition3", list);	
			return list;			
		}

	}
	
	@RequestMapping(value ="/reviewDelete.do", produces="application/json; charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST} ) 	
	@ResponseBody public Map<String, Object> reviewDelete(ReviewVO vo) {
		
		int review_num = vo.getReview_num();
		Map<String, Object> retVal = new HashMap<String, Object>();		
		retVal.put("review_num", review_num);		
		try {
			int res = reviewService.reivewDelete(vo);
			
			if (res==1)
				retVal.put("res", "OK");
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			
		}
		return retVal;
	}
	
	@PostMapping(value ="/reviewUpdate.do") public String reviewUpdate(HttpServletResponse response,  MultipartHttpServletRequest request) throws Exception {
		
		ReviewVO vo = new ReviewVO();
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer  = response.getWriter();	
				
		vo.setReview_kind(request.getParameter("Review_kind"));
		if(request.getParameter("Review_star").equals("")) {
			System.out.println(request.getParameter("Review_star"));
			vo.setReview_star(Double.parseDouble(request.getParameter("ex-Review_star"))*2);
			
		}else {
			vo.setReview_star(Double.parseDouble(request.getParameter("Review_star"))*2);
		}
		
		vo.setReview_content(request.getParameter("Review_content"));
		vo.setReview_num(Integer.parseInt(request.getParameter("Review_num")));

		if(request.getParameter("Review_photo").equals("")) {
			vo.setReview_photo(request.getParameter("exist_file"));
			
		}else {
			vo.setReview_photo(request.getParameter("Review_photo"));
			
		}

		int res = reviewService.reivewUpdate(vo);
		
		if(res== 0)
		{
			writer.write("<script>alert('수정 실패');location.href='./review.do';</script>");
			return null;				
		}
		else
		{				
			writer.write("<script>location.href='./review.do'; </script>");
		}
		return null;
	}

	@RequestMapping(value = "/admin/admin_review.do")public String adminReview(Model model) throws Exception 
	{							
		return "admin/admin_review";		
	}
	
	@RequestMapping (value="/admin/ad_reviewlist.do", produces="application/json; charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST} )
	@ResponseBody public ArrayList<ReviewVO> ad_reviewList() throws Exception
	{
		ArrayList<ReviewVO> list = reviewService.reviewList();
		return list;		
	}
	
	@RequestMapping (value="/admin/ad_reviewDelete.do", produces="application/json; charset=UTF-8", method = {RequestMethod.GET, RequestMethod.POST} )
	@ResponseBody public Map<String, Object> ad_reviewDelete(ReviewVO vo) throws Exception
	{
		Map<String, Object> retVal = new HashMap<String, Object>();		
		try {
			int res = reviewService.reivewDelete(vo);
			
			if (res==1)
				retVal.put("res", "OK");
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			
		}
		return retVal;
	}


	
}
