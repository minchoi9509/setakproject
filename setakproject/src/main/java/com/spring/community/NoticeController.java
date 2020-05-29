package com.spring.community;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;


@Controller public class NoticeController 
{
	@Autowired private NoticeService noticeService;
	
	@RequestMapping(value = "/noticeList.do") public String noticeList(HttpServletRequest request, Model model) throws Exception
	{
		ArrayList<NoticeVO> noticelist = new ArrayList<NoticeVO>();
		int page = 1;
		int limit = 10;
		if (request.getParameter("page") != null)
		{
			page = Integer.parseInt(request.getParameter("page"));			
		}
		int startrow= (page-1)*10+1;
		int endrow=startrow +limit-1;

		int listcount = noticeService.getListCount();
		
		noticelist = noticeService.getNoticeList(startrow, endrow);
		
		int maxpage = (int)((double)listcount/limit+0.95);
		int startpage = (((int) ((double)page/10 + 0.9)) -1) * 10 + 1;
		int endpage = startpage+10-1;
		
		
		
		if(endpage > maxpage )
		{
			endpage = maxpage;			
		}
		
		model.addAttribute("limit", limit);
		model.addAttribute("page", page);
		model.addAttribute("maxpage", maxpage);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("listcount", listcount);
		model.addAttribute("noticelist", noticelist);
		
		return "notice_list";

	}
		
	@RequestMapping(value = "/admin/noticeInsert.do") public String insertNotice(MultipartHttpServletRequest request, HttpServletResponse response) throws Exception 
	{				
		NoticeVO noticevo = new NoticeVO();
		noticevo.setNotice_title(request.getParameter("notice_title"));
		noticevo.setNotice_content(request.getParameter("notice_content"));	
		int res = noticeService.noticeInsert(noticevo);		
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer = response.getWriter();
		
		if (res !=0 ) {
			writer.write("<script>location.href='./admin_notice.do';</script>");
		}
		else {
			writer.write("<script>alert('공지사항 작성 실패..');location.href='./admin_notice.do';</script>");
		}
		
		return null;
	}
	
	@RequestMapping(value = "/getDetail.do") public String getDetail( NoticeVO noticevo, Model model) throws Exception
	{
		NoticeVO vo = noticeService.getDetail(noticevo);
		model.addAttribute("noticedata", vo);
		return "notice_view";
	}
	
	@RequestMapping (value = "/admin/noticeUpdate.do", produces="application/json;charset=UTF-8",  method = {RequestMethod.GET, RequestMethod.POST} ) 
	@ResponseBody public  Map<String, Object> noticeModify (NoticeVO vo)
	{
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = noticeService.noticeModify(vo);		
			if (res==1)
				retVal.put("res", "OK");
			else {
				retVal.put("res", "Err");}
			}
			catch (Exception e) {
				retVal.put("res", "FAIL");
				retVal.put("message", "Failure");
			}
		
			return retVal;		
	}
	
	@RequestMapping(value = "/admin/noticeDelete.do", produces="application/json;charset=UTF-8", method = { RequestMethod.GET, RequestMethod.POST } ) 
	@ResponseBody public Map<String, Object> noticeDelete(NoticeVO vo) throws Exception 
	{	
		
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = noticeService.noticeDelete(vo);				
			if (res==1) {
				System.out.println(res);
				retVal.put("res", "OK");
			}else {
				retVal.put("res", "PassErr");}
			}
			catch (Exception e) {
				retVal.put("res", "FAIL");
				retVal.put("message", "Failure");
			}
		
			return retVal;		
	}
	
	@RequestMapping(value = "/admin/admin_notice.do")public String adminNotice(Model model) throws Exception 
	{			
		List<Object> list = noticeService.ad_noticeList();
		model.addAttribute("noticeList", list);				
		return "admin/admin_notice";		
	}

	
	@RequestMapping(value = "/admin/ad_noticeList.do", produces="application/json;charset=UTF-8",  method = {RequestMethod.GET, RequestMethod.POST} ) 
	@ResponseBody public List<Object> ad_noticeList()
	{
		List<Object> list = noticeService.ad_noticeList();
		return list;		
	}
	



}
