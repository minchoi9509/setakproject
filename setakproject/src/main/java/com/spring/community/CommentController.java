package com.spring.community;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.spring.community.CommentVO;


@RestController
public class CommentController 
{
	@Autowired CommentService commentService;
	@Autowired QnaService qnaService;
	
	@PostMapping(value="/commentList.do", produces="application/json; charset=UTF-8")
	public  List<CommentVO> commentList(CommentVO vo) 
	{	
		List<CommentVO> list = commentService.commentList(vo);
		return list;

	}
	
	@PostMapping(value="/commentInsert.do", produces="application/json; charset=UTF-8")
	public Map<String, Object> commentInsert(CommentVO vo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		
		try {
			int res = commentService.commentInsert(vo);
			
			retVal.put("res", "OK");
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal;
	}
	
	@PostMapping(value="/commentDelete.do", produces="application/json; charset=UTF-8")
	public Map<String, Object> commentDelete(CommentVO vo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = commentService.commentDelete(vo);		
			if (res==1)
				retVal.put("res", "OK");
			else
				retVal.put("res", "Err");
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal;
	}
	
	@PostMapping(value="/commentUpdate.do", produces="application/json; charset=UTF-8")
	public Map<String, Object> commentUpdate(CommentVO vo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		
		
		try {
			int res = commentService.commentUpdate(vo);			
			if (res==1)
				retVal.put("res", "OK");
			else if (res==-1)
				retVal.put("res", "PassErr");
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal;
	}
	
	@RequestMapping(value="admin/ad_commentList.do", produces="application/json; charset=UTF-8",  method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody public List<CommentVO> ad_commentList(CommentVO vo) 
	{	
		List<CommentVO> list = commentService.ad_commentList(vo);	
		return list;

	}
	
	@PostMapping(value="admin/commentInsert.do", produces="application/json; charset=UTF-8")
	public Map<String, Object> ad_commentInsert(CommentVO vo, QnaVO qvo, HttpServletRequest request) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		vo.setQna_num(Integer.parseInt(request.getParameter("qna_num")));
		vo.setQna_content(request.getParameter("qna_content"));
		vo.setMember_id("관리자");
		qvo.setQna_check(request.getParameter("qna_check"));
		qvo.setQna_num(Integer.parseInt(request.getParameter("qna_num")));
		
		try {
			int res = commentService.commentInsert(vo);
			int res2 = qnaService.ad_qnaModify(qvo);
			
			retVal.put("res", "OK");
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal;
	}
	
	@PostMapping(value="admin/commentUpdate.do", produces="application/json; charset=UTF-8")
	public Map<String, Object> ad_commentUpdate(CommentVO vo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		
		try {
			int res = commentService.commentUpdate(vo);	
			
			if (res==1) {
				retVal.put("res", "OK");
				
			}else {
				retVal.put("res", "Err");}
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal;
	}
	
	
	@PostMapping(value="admin/commentDelete.do", produces="application/json; charset=UTF-8")
	public Map<String, Object> ad_commentDelete(CommentVO vo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = commentService.commentDelete(vo);		
			if (res==1)
				retVal.put("res", "OK");
			else
				retVal.put("res", "Err");
		}
		catch (Exception e) {
			retVal.put("res", "FAIL");
			retVal.put("message", "Failure");
		}
		
		return retVal;
	}
	
	
	
	

}
