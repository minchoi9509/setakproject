0[package com.spring.community;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class QnaController {
	@Autowired
	private QnaService qnaService;

	// 게시판 리스트 
	@RequestMapping(value = "/qnaList.do")
	public String qnaList(HttpServletRequest request, Model model) throws Exception {
		
		int page = 1;
		int limit = 10;
		int countpage = 10; 
		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}
		
		// QnA 리스트 개수 
		int listcount = qnaService.getListCount();
		
		int startrow = (page - 1) * 10 + 1;
		int endrow = startrow + limit - 1;

		int maxpage = listcount / limit;
		if(listcount % limit > 0) {
			maxpage++; 
		}
		if(maxpage < page) {
			page = maxpage; 
		}
		
		int startpage = ((page - 1) / countpage) * limit + 1;
		int endpage = startpage + countpage - 1;

		if (endpage > maxpage) {
			endpage = maxpage;
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("startrow", startrow);
		map.put("endrow", endrow);
		
		// Qna 리스트		
		ArrayList<HashMap<String, Object>> qnaList = qnaService.getQnaList(map);
		
		model.addAttribute("qnaList", qnaList); 
		model.addAttribute("currentpage", page); 
		model.addAttribute("startpage", startpage); 
		model.addAttribute("endpage", endpage); 
		model.addAttribute("maxpage", maxpage); 
		
		return "qna_list";

	}

	// 게시판 입력 폼 
	@RequestMapping(value = "/qnaWrite.do")
	public String writeForm(QnaVO vo, Model model, HttpSession session) throws Exception {
		String member_id = (String) session.getAttribute("member_id");
		
		ArrayList<Long> list = qnaService.getOrderList(member_id);
		model.addAttribute("orderList", list);
		return "qna_write";
	}
	
	// 게시판 입력 프로세스
	@RequestMapping(value = "/insertQna.do")
	public String insertQna(QnaVO qvo, MultipartHttpServletRequest request, HttpServletResponse response) throws Exception {
		
		if(qvo.getQna_file().equals("")) {
			qvo.setQna_file("등록한 파일이 없습니다.");
		}
		
		int res = qnaService.insertQna(qvo);
		if(res == 0) {
			return "redirect:/qnaWrite.do";
		}

		return "redirect:/qnaList.do";
	}

	// 게시판 상세보기
	@RequestMapping(value = "/qnaDetail.do")
	public String getDetail(QnaVO qvo, Model model) throws Exception {
		
		HashMap<String, Object> map = qnaService.getDetail(qvo);
		model.addAttribute("qnaMap", map);

		return "qna_view";
	}
	
	// 게시판 수정 폼
	@RequestMapping(value = "/updateForm.do")
	public String updateForm(QnaVO qvo, Model model) throws Exception {

		HashMap<String, Object> map = qnaService.getDetail(qvo);
		
		model.addAttribute("qnaMap", map);
		
		return "qna_update";
	}

	// 게시판 수정 프로세스
	@RequestMapping(value = "/updateQna.do")
	public String updateQna(HttpServletRequest request, QnaVO qvo) throws Exception {

		if(qvo.getQna_file().equals("")) {
			qvo.setQna_file(request.getParameter("exist_file"));
		}
		
		int res = qnaService.updateQna(qvo);
		if(res == 0) {
			return "redirect:/updateForm.do?qna_num="+qvo.getQna_num();
		}
		return "redirect:/qnaDetail.do?qna_num="+qvo.getQna_num();
		
	}
	
	// 게시판 삭제 비밀번호 입력 폼
	@RequestMapping(value = "/qnaPass.do")
	public String qnaDeletePass(Model model) throws Exception {
		return "qna_pass";
	}

	// 게시판 삭제 
	@RequestMapping(value = "/qnaCheckPass.do")
	public String deleteQna(QnaVO qvo, HttpServletRequest request) throws Exception {
		
		HashMap<String, Object> qnaMap = qnaService.getDetail(qvo);
		// 받아온 비밀번호
		String pass = qvo.getQna_pass();
		// DB 저장 비밀번호
		String qna_pass = (String) qnaMap.get("qna_pass");
		
		// 유형 구분 1. 삭제 2. 수정 3. view
		String type = request.getParameter("type"); 
		// 유형 구분 ver 2. 
		String num = request.getParameter("num"); 
		
		int res = 0;
		
		// 비밀번호 일치 시 유형에 따라서 구분
		if(pass.equals(qna_pass)) {

			if (type.equals("view")) {
				return "redirect:/qnaDetail.do?qna_num=" + qvo.getQna_num();
			} else if (type.equals("update")) {
				return "redirect:/updateForm.do?qna_num=" + qvo.getQna_num();
			} else {
				res = qnaService.deleteQna(qvo);
				return "redirect:/qnaList.do";
			}				
		}else {
			// 비밀번호 일치 하지 않는 경우 다시
			return "redirect:/qnaPass.do?qna_num="+qvo.getQna_num()+"&type="+type+"&enter=again";
		}
	}
	
	// 게시판 댓글 리스트 불러오기
	@RequestMapping(value = "/getReplyList.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public ArrayList<ReplyVO> replyList(QnaVO qvo) throws Exception {
		
		ArrayList<ReplyVO> replyList = qnaService.getReplyList(qvo);
		return replyList;
	}
	
	// 게시판 댓글 입력하기
	@RequestMapping(value = "/insertReply.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String insertReply(ReplyVO rvo) throws Exception {
		
		int res = qnaService.insertReply(rvo);
		return null;
	}
	
	// 게시판 댓글 수정하기
	@RequestMapping(value = "/updateReply.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String updateReply(ReplyVO rvo) throws Exception {
		
		qnaService.updateReply(rvo);
		return null;
	}
	
	// 게시판 댓글 삭제하기
	@RequestMapping(value = "/deleteReply.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> deleteReply(ReplyVO rvo) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>(); 
		int res = qnaService.deleteReply(rvo);

		if(res == 1) {
			map.put("res", "success");
		}else {
			map.put("res", "error"); 
		}
		
		return map;
	}
	
	// 게시판 대댓글 입력하기
	@RequestMapping(value = "/insertReReply.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String insertReReply(ReplyVO rvo) throws Exception {
		
		qnaService.insertReReply(rvo);
		
		return null;
	}
	
	// 게시판 대댓글 입력하기
	@RequestMapping(value = "/getReplyCount.do", method=RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public Map<String, Object> getReplyCount(ReplyVO rvo) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		int cnt = qnaService.getReplyCount(rvo);
		map.put("cnt", cnt);
		
		return map; 
		
	}

	@RequestMapping(value = "/admin/admin_qna.do")
	public String adminQna(Model model) throws Exception {
		return "admin/admin_qna";
	}

	@RequestMapping(value = "/admin/ad_qnalist.do", produces = "application/json;charset=UTF-8", method = {
			RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public List<Object> adminQnalist() {
		List<Object> list = qnaService.ad_qnalist();

		return list;
	}

	@RequestMapping(value = "/admin/ad_qnaDelete.do", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public Map<String, Object> ad_qnaDelete(QnaVO vo) {
		Map<String, Object> retVal = new HashMap<String, Object>();
		try {
			int res = qnaService.deleteQna(vo);
			if (res == 1)
				retVal.put("res", "OK");
			else
				retVal.put("res", "Err");
		} catch (Exception e) {
			retVal.put("res", "FAIL");
		}

		return retVal;
	}

}