package com.spring.member;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.order.Iamport;

@Controller
public class MemberSubController {

	@Autowired
	private MemberSubService membersubservice;

	@Autowired
	private MemberService memberservice;

	/* 나의정기구독 */
	@RequestMapping(value = "mysub.do", produces = "application/json; charset=utf-8")
	public String mysub(Model model, HttpSession session, HttpServletRequest request, HttpServletResponse response)
			throws IOException {

		if (session.getAttribute("member_id") == null) {
			return "redirect:/";
		}

		String member_id = (String) session.getAttribute("member_id");

		/* 나의정기구독 */
		MemberSubVO sub_list = membersubservice.sub_list(member_id);
		model.addAttribute("sub_list", sub_list);

		/* 해당 정기구독 리스트 */
		SubscribeVO subscribe = membersubservice.subscribe_list(member_id);
		model.addAttribute("subscribe", subscribe);

		/* 멤버 이름 */
		MemberVO name1 = memberservice.name(member_id);
		model.addAttribute("name", name1);

		/* 정기구독 내역 리스트 */
		HashMap<String, Object> map = new HashMap<String, Object>();

		int page = 1;
		int limit = 10;

		if (request.getParameter("page") != null) {
			page = Integer.parseInt(request.getParameter("page"));
		}

		int startrow = (page - 1) * 10 + 1;
		int endrow = startrow + limit - 1;

		int listcount = membersubservice.listcount(member_id);

		map.put("startrow", startrow);
		map.put("endrow", endrow);
		map.put("member_id", member_id);

		ArrayList<HistorySubVO> subhistory_list = membersubservice.subhistory_list(map);

		int maxpage = (int) ((double) listcount / limit + 0.95);
		int startpage = (((int) ((double) page / 10 + 0.9)) - 1) * 10 + 1;
		int endpage = startpage + 10 - 1;
		if (endpage > maxpage) {
			endpage = maxpage;

		}

		model.addAttribute("subhistory_list", subhistory_list);
		model.addAttribute("limit", limit);
		model.addAttribute("page", page);
		model.addAttribute("maxpage", maxpage);
		model.addAttribute("startpage", startpage);
		model.addAttribute("endpage", endpage);
		model.addAttribute("listcount", listcount);

		return "mysub";
	}

	/* 정기구독 해지 */
	// 민경 추가 부분 정기 구독 해지 > 아임포트 연동
	@RequestMapping(value = "/subs_bye1.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> subcancle(String member_id, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		Map<String, Object> result = new HashMap<String, Object>();

		// 정기구독 결제 해지
		Iamport iamport = new Iamport();
		String customer_uid = membersubservice.sub_list(member_id).getCustomer_uid();
		String token = iamport.getToken(request, response);
		int res2 = iamport.cancelSub(token, customer_uid);

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("member_id", member_id);

		int res = membersubservice.subcancle(member_id);
		if (res == 1 && res2 == 1) {
			result.put("res", "OK");
		} else {
			result.put("res", "FAIL");
			result.put("message", "Failure");
		}
		return result;
	}

	/* 수거고 클릭 */
	@RequestMapping(value = "/sugo2.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> sugo2(String member_id) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("member_id", member_id);

		Map<String, Object> result = new HashMap<String, Object>();
		int res = membersubservice.sugo2(member_id);
		if (res == 1) {
			result.put("res", "OK");
		} else {
			result.put("res", "FAIL");
			result.put("message", "Failure");
		}
		return result;
	}

	/* 수거고 취소 클릭 */
	@RequestMapping(value = "/sugo0.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> sugo0(String member_id) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("member_id", member_id);

		Map<String, Object> result = new HashMap<String, Object>();
		int res = membersubservice.sugo0(member_id);
		if (res == 1) {
			result.put("res", "OK");
		} else {
			result.put("res", "FAIL");
			result.put("message", "Failure");
		}
		return result;
	}

	/* 리뷰 작성 */
	@RequestMapping(value = "/review_chk.do", produces = "application/json; charset=utf-8")
	@ResponseBody
	public Map<String, Object> review_chk(String member_id, String his_date) throws Exception {

		String ndate = his_date;
		Date date = new SimpleDateFormat("yyyy-MM-dd").parse(ndate);

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("member_id", member_id);
		map.put("his_date", date);

		Map<String, Object> result = new HashMap<String, Object>();
		int res = membersubservice.review_chk(map);
		if (res == 1) {
			result.put("res", "OK");
		} else {
			result.put("res", "FAIL");
			result.put("message", "Failure");
		}
		return result;

	}
}
