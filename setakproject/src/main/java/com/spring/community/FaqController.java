package com.spring.community;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.RequestMapping;

@Controller public class FaqController 
{
	@Autowired private FaqService faqService;
	
	@RequestMapping(value="/faqList.do") public String faqList(FaqVO vo, Model model) throws Exception 
	{	
		ArrayList<FaqVO> faqlist = new ArrayList<FaqVO>();
		faqlist = faqService.getFaqList();			
		model.addAttribute("faqdata", faqlist);		
		return "faq_list";
		
	}
	
	@RequestMapping(value="/admin/admin_faq.do")public String adminFaqList(Model model) throws Exception 
	{	
		ArrayList<FaqVO> faqlist = new ArrayList<FaqVO>();
		faqlist = faqService.getFaqList();
		model.addAttribute("faqdata", faqlist);				
		return "admin/admin_faq";		
	}
	
	@RequestMapping(value="/admin/admin_faqInsert.do")public String adminFaqInsert(FaqVO vo, HttpServletResponse response) throws Exception 
	{	
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer = response.getWriter();
		faqService.faqInsert(vo);	
		writer.write("<script> location.href='./admin_faq.do'; </script>");	
		
		return null;
		
	}
	@RequestMapping(value="/admin/admin_faqUpdate.do")public void adminFaqUpdate(FaqVO vo, HttpServletResponse response) throws Exception
	{	
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer = response.getWriter();
		faqService.faqModify(vo);
		writer.write("<script> location.href='./admin_faq.do'; </script>");
			
				
	}
	@RequestMapping(value="/admin/admin_faqDelete.do")public void adminFaqDelete(FaqVO vo, HttpServletResponse response) throws Exception 
	{	
		int num = vo.getFaq_num();
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter writer = response.getWriter();
		faqService.faqDelete(num);	
		writer.write("<script> location.href='./admin_faq.do'; </script>");
		
				
	}


	
}
