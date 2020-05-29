package com.spring.order;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.member.CouponService;
import com.spring.member.CouponVO;
import com.spring.member.MemberSubService;
import com.spring.member.MemberSubVO;
import com.spring.member.MemberVO;
import com.spring.member.MileageServiceImpl;
import com.spring.member.MileageVO;
import com.spring.member.SubscribeVO;
import com.spring.setak.KeepVO;
import com.spring.setak.MendingVO;
import com.spring.setak.WashingVO;

@Controller
public class OrderController {

   @Autowired
   private MileageServiceImpl mileageService;
   @Autowired
   private CouponService couponService;
   @Autowired
   private OrderService orderService;
   @Autowired
   private CartService cartService;
   @Autowired
   private MemberSubService membersubservice;

   // 장바구니
   @RequestMapping(value = "/order.do")
   public String cart(Model model, HttpServletRequest request, HttpServletResponse response) throws IOException {

      // 로그인 세션 값 읽기
      HttpSession session = request.getSession();
      String member_id = (String) session.getAttribute("member_id");

      // 세탁 장바구니 값 읽기
      List<WashingVO> washingList = new ArrayList<WashingVO>();
      List<WashingCartVO> list3 = cartService.getWashSeq(member_id);

      if (list3.size() != 0) {
         for (int i = 0; i < list3.size(); i++) {

            int wash_seq = list3.get(i).getWash_seq();
            WashingVO wvo = new WashingVO();
            wvo = cartService.getWashingList(wash_seq);
            washingList.add(wvo);
         }
      }

      // 수선 장바구니 값 읽기
      List<MendingVO> mendingList = new ArrayList<MendingVO>();
      List<MendingCartVO> list2 = cartService.getMendingSeq(member_id);

      if (list2.size() != 0) {
         for (int i = 0; i < list2.size(); i++) {

            int repair_seq = list2.get(i).getRepair_seq();
            MendingVO mvo = new MendingVO();
            mvo = cartService.getMendingList(repair_seq);
            mendingList.add(mvo);
         }
      }

      // 보관 장바구니 값 읽기
      List<KeepVO> keepList = new ArrayList<KeepVO>();
      
      HashMap<String, Object> map = new HashMap<String, Object>();
      map.put("member_id", member_id);

      int maxGroup = 0;

      if (orderService.getKeepExist(member_id) != 0) {
         maxGroup = orderService.getKeepMaxGroup(member_id);
      }

      for (int i = 1; i <= maxGroup; i++) {
         map.put("keep_group", i);
         ArrayList<KeepVO> kvo = cartService.getKeepGroupList(map);
         keepList.add(kvo.get(0));
      }

      model.addAttribute("washingList", washingList);
      model.addAttribute("mendingList", mendingList);
      model.addAttribute("keepList", keepList);

      String type = request.getParameter("type");

      if (type == null) {
         return "cart";
      } else {

         MemberVO memberVO = orderService.getMemberInfo(member_id);
         String member_name = memberVO.getMember_name();
         String last = member_id.substring(member_id.length() - 1);
         if(last.equals("K")|| last.equals("N")||last.equals("G")) {
            member_name = " "; 
         }      

         String member_phone1 = " ", member_phone2 = " ", member_phone3 = " ";

         if (memberVO.getMember_phone() != null) {

            String phone = memberVO.getMember_phone();
            member_phone1 = phone.substring(0, 3);

            if (phone.length() == 11) {
               member_phone2 = phone.substring(3, 7);
               member_phone3 = phone.substring(7);
            } else {
               member_phone2 = phone.substring(3, 6);
               member_phone3 = phone.substring(6);
            }

         }

         String member_addr1 = " ", member_addr2 = " ";

         if (!(memberVO.getMember_loc().equals(("!")))) {
            String addr = memberVO.getMember_loc();
            String[] locArr = addr.split("!");
            member_addr1 = locArr[0];
            if (locArr.length == 2) {
               member_addr2 = locArr[1];
            }

         }

         String zipcode = " ";
         if (memberVO.getMember_zipcode() != null) {
            zipcode = memberVO.getMember_zipcode();
         }

         int havePoint = mileageService.getSum(member_id);

         ArrayList<CouponVO> couponList = couponService.getAbleCouponList(member_id);
         int haveCoupon = couponService.getCouponCount(member_id);

         model.addAttribute("member_name", member_name);
         model.addAttribute("memberVO", memberVO);

         model.addAttribute("member_phone1", member_phone1);
         model.addAttribute("member_phone2", member_phone2);
         model.addAttribute("member_phone3", member_phone3);

         model.addAttribute("member_addr1", member_addr1);
         model.addAttribute("member_addr2", member_addr2);
         model.addAttribute("zipcode", zipcode);

         model.addAttribute("havePoint", havePoint);

         model.addAttribute("haveCoupon", haveCoupon);
         model.addAttribute("couponList", couponList);

         return "order";
      }

   }

   // 장바구니 비우기
   @RequestMapping(value = "/cartDelete.do", method = RequestMethod.POST)
   @ResponseBody
   public Map<String, Object> cartDelete(@RequestParam(value = "loc") String loc, String[] washSeqArr,
         String[] repairSeqArr, String[] keepSeqArr, HttpSession session) {

      Map<String, Object> retVal = new HashMap<String, Object>();

      // 세탁 선택 시퀀스
      ArrayList<WashingCartVO> washSeqList = new ArrayList<WashingCartVO>();
      // 수선 선택 시퀀스
      ArrayList<MendingCartVO> mendingSeqList = new ArrayList<MendingCartVO>();

      try {

         if (washSeqArr != null) {
            for (int i = 0; i < washSeqArr.length; i++) {
               WashingCartVO wcv = new WashingCartVO();
               int wash_seq = Integer.parseInt(washSeqArr[i]);
               cartService.deleteWashCart(wash_seq);
               cartService.deleteWash(wash_seq);
            }
         }

         if (repairSeqArr != null) {
            for (int i = 0; i < repairSeqArr.length; i++) {
               MendingCartVO mcv = new MendingCartVO();
               int repair_seq = Integer.parseInt(repairSeqArr[i]);
               int res = cartService.deleteMendingCart(repair_seq);

               if (loc.equals("cart")) {
                  int res2 = cartService.deleteMending(repair_seq);
               }
            }
         }

         if (keepSeqArr != null) {
            String member_id = (String) session.getAttribute("member_id");
            List<KeepCartVO> list = cartService.getKeepSeq(member_id);
            int res = cartService.deleteKeepCart(member_id);

            if (loc.equals("cart")) {
               for (int i = 0; i < list.size(); i++) {
                  int keep_seq = list.get(i).getKeep_seq();
                  int res2 = cartService.deleteKeep(keep_seq);
               }
            }

         }

         retVal.put("res", "OK");
      } catch (Exception e) {
         retVal.put("res", "FAIL");
         retVal.put("message", "Failure");
      }

      return retVal;
   }

   // 정기구독
   @RequestMapping(value = "/subscribe.do")
   public String subscribe(Model model, HttpSession session) {

      String member_id = (String) session.getAttribute("member_id");
      MemberVO mvo = new MemberVO();

      if (member_id != null) {
         mvo = orderService.getMemberInfo(member_id);
         model.addAttribute("memberVO", mvo);
      }

      return "subscribe";
   }

   // 주문완료
   @RequestMapping(value = "/orderSuccess.do")
   public String orderSuccess(HttpServletRequest request, Model model, HttpSession session) {

      String member_id = (String) session.getAttribute("member_id");

      long order_num = Long.parseLong(request.getParameter("order_num"));

      OrderListVO olv = new OrderListVO();
      olv.setOrder_num(order_num);

      List<OrderListVO> orderList = orderService.getOrderList(olv);
      
      //시퀀스 저장
      List<WashingVO> washingList = new ArrayList<WashingVO>();
      List<MendingVO> mendingList = new ArrayList<MendingVO>();
      List<KeepVO> keepList = new ArrayList<KeepVO>();

      //시퀀스에 맞는 내용 저장 
      List<WashingVO> washingList2 = new ArrayList<WashingVO>();
      List<MendingVO> mendingList2 = new ArrayList<MendingVO>();
      List<KeepVO> keepList2 = new ArrayList<KeepVO>();

      for (int i = 0; i < orderList.size(); i++) {

         OrderListVO ovo = orderList.get(i);

         if (ovo.getWash_seq() != 0) {
            WashingVO wvo = new WashingVO();
            wvo.setWash_seq(ovo.getWash_seq());
            washingList.add(wvo);
         }

         if (ovo.getRepair_seq() != 0) {
            MendingVO mvo = new MendingVO();
            mvo.setRepair_seq(ovo.getRepair_seq());
            mendingList.add(mvo);
         }

         if (ovo.getKeep_seq() != 0) {
            KeepVO kvo = new KeepVO();
            kvo.setKeep_seq(ovo.getKeep_seq());
            keepList.add(kvo);
         }
      }

      for (int i = 0; i < washingList.size(); i++) {
         int wash_seq = washingList.get(i).getWash_seq();
         WashingVO wvo = cartService.getWashingList(wash_seq);
         washingList2.add(wvo);
      }

      for (int i = 0; i < mendingList.size(); i++) {
         int repair_seq = mendingList.get(i).getRepair_seq();
         MendingVO mvo = cartService.getMendingList(repair_seq);
         mendingList2.add(mvo);
      }

      HashMap<String, Object> map = new HashMap<String, Object>();
      map.put("member_id", member_id);

      int maxGroup = 0;

      if (orderService.getKeepExist(member_id) != 0) {
         maxGroup = orderService.getKeepMaxGroup(member_id);
      }

      for (int i = 1; i <= maxGroup; i++) {
         map.put("keep_group", i);
         ArrayList<KeepVO> kvo = cartService.getKeepGroupList(map);

         keepList2.add(kvo.get(0));
      }

      // 장바구니 비우기
      orderService.deleteWashCartbyID(member_id);
      orderService.deleteMendingCartbyID(member_id);
      orderService.deleteKeepCartbyID(member_id);

      int price = orderService.getOrderPrice(olv);

      model.addAttribute("washingList", washingList2);
      model.addAttribute("mendingList", mendingList2);
      model.addAttribute("keepList", keepList2);
      model.addAttribute("price", price);

      return "order_success";
   }

   // 주문 정보 입력
   @RequestMapping(value = "/insertOrder.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public OrderVO insertOrder(OrderVO ovo, @RequestParam(value = "usePoint") String usePoint, String[] useCoupon,
         HttpSession session, @RequestParam(value = "defaultAddrChk") String defaultAddrChk) {

      String member_id = (String) session.getAttribute("member_id");

      // 장바구니 시퀀스 값 읽기

      // 세탁 장바구니 값 읽기
      List<WashingVO> washingList = new ArrayList<WashingVO>();
      List<WashingCartVO> list3 = cartService.getWashSeq(member_id);

      if (list3.size() == 0) {
         System.out.println("");
      } else {
         for (int i = 0; i < list3.size(); i++) {

            int wash_seq = list3.get(i).getWash_seq();
            WashingVO wvo = new WashingVO();
            wvo = cartService.getWashingList(wash_seq);
            washingList.add(wvo);
         }
      }

      // 수선 장바구니 값 읽기
      List<MendingVO> mendingList = new ArrayList<MendingVO>();
      List<MendingCartVO> list2 = cartService.getMendingSeq(member_id);

      if (list2.size() == 0) {
         System.out.println("");
      } else {
         for (int i = 0; i < list2.size(); i++) {

            int repair_seq = list2.get(i).getRepair_seq();
            MendingVO mvo = new MendingVO();
            mvo = cartService.getMendingList(repair_seq);
            mendingList.add(mvo);
         }
      }

      // 보관 장바구니 값 읽기
      List<KeepVO> keepList = new ArrayList<KeepVO>();
      List<KeepCartVO> list = cartService.getKeepSeq(member_id);

      if (list.size() == 0) {
         System.out.println("");
      } else {
         for (int i = 0; i < list.size(); i++) {

            int keep_seq = list.get(i).getKeep_seq();
            KeepVO kvo = new KeepVO();
            kvo = cartService.getKeepList(keep_seq);
            keepList.add(kvo);

         }
      }

      // 주문번호
      long order_num = System.currentTimeMillis();

      // 주문목록 DB 저장
      int wash_size = list3.size();
      int repair_size = list2.size();
      int keep_size = list.size();

      int big = (wash_size > repair_size) && (wash_size > keep_size) ? wash_size
            : (keep_size > repair_size ? keep_size : repair_size);

      List<OrderListVO> orderList = new ArrayList<OrderListVO>();

      for (int i = 0; i < big; i++) {
         OrderListVO olv = new OrderListVO();
         // 주문번호 저장
         olv.setOrder_num(order_num);
         // 세탁 시퀀스 저장
         if (washingList.size() > i) {
            if (washingList.get(i) != null) {
               olv.setWash_seq(washingList.get(i).getWash_seq());
            }
         }
         // 수선 시퀀스 저장
         if (mendingList.size() > i) {
            if (mendingList.get(i) != null) {
               olv.setRepair_seq(mendingList.get(i).getRepair_seq());
            }
         }

         // 보관 시퀀스 저장
         if (keepList.size() > i) {
            if (keepList.get(i) != null) {
               olv.setKeep_seq(keepList.get(i).getKeep_seq());
            }
         }

         orderList.add(olv);
      }

      // 주문날짜, 적립금 사용 날짜
      Date today = new Date();
      SimpleDateFormat sdf = new SimpleDateFormat("yy/MM/dd HH:mm");
      SimpleDateFormat sdf2 = new SimpleDateFormat("yy/MM/dd");
      String date = sdf.format(today);
      String date2 = sdf2.format(today);

      ovo.setOrder_num(order_num);
      ovo.setOrder_date(date);
      ovo.setOrder_delete("0");

      // 주문 테이블 DB 추가
     orderService.insertOrder(ovo);

      for (int i = 0; i < orderList.size(); i++) {
         OrderListVO olv = orderList.get(i);
         orderService.insertOrderList(olv);
      }
      
      // 기본 배송지 저장   
      if(defaultAddrChk.equals("1")) {
         MemberVO mvo = new MemberVO();
         mvo.setMember_id(member_id);
         mvo.setMember_phone(ovo.getOrder_phone());
         mvo.setMember_zipcode(ovo.getOrder_zipcode());
         mvo.setMember_loc(ovo.getOrder_address());
         
        orderService.defaultAddrUpdate(mvo);
      }

      // 사용 적립금 차감
      if (usePoint != "") {
         MileageVO mvo = new MileageVO();
         int point = Integer.parseInt(usePoint) * (-1);
         mvo.setMember_id(member_id);
         mvo.setMile_date(date2);
         mvo.setMile_content("결제 차감");
         mvo.setMile_price(point);

         mileageService.useMileage(mvo);

      }

      // 사용 쿠폰 소멸
      if (useCoupon != null) {

         for (int i = 0; i < useCoupon.length; i++) {
            int coupon_seq = Integer.parseInt(useCoupon[i]);
            couponService.useCoupon(coupon_seq);
         }
      }

      return ovo;
   }

   // 정기구독 정보 입력
   @RequestMapping(value = "/insertSubscribe.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public String insertSubscribe(MemberVO mvo, HttpServletRequest request, HttpServletResponse response,
         @RequestParam(value = "merchant_uid") String merchant_uid,
         @RequestParam(value = "customer_uid") String customer_uid, @RequestParam(value = "amount") String amount)
         throws Exception {
      
      Map<String, Object> map = new HashMap<String, Object>();
      map.put("member_id", mvo.getMember_id());
      map.put("subs_num", mvo.getSubs_num());
      map.put("customer_uid", customer_uid);
      
      // MemberVO 값 변경 (번호 입력)
      orderService.updateSubInfo(mvo);
      // member_subs 테이블 값 추가
      orderService.insertMemberSubInfo(map);
      // history_sub 테이블 값 추가
      orderService.insertSubHistory(mvo);

      // 쿠폰 발급
      int coupon_num = orderService.getCouponNum(mvo);
      for (int i = 0; i < coupon_num; i++) {
         orderService.insertCoupon(mvo);
      }
      merchant_uid += "s";
      
      Iamport iamport = new Iamport();
      iamport.subsres(customer_uid, merchant_uid, amount, request, response);

      return "";
   }
   // 정기구독 결제 성공
   @RequestMapping(value = "/subSuccess.do")
   public String subSuccess(Model model, HttpServletRequest request, HttpSession session) {

      String member_id = (String) session.getAttribute("member_id");

      // 회원 정보 및 구독 정보 넘기기
      MemberVO memberVO = orderService.getMemberInfo(member_id);
      SubscribeVO subscribeVO = orderService.getSubscribeInfo(memberVO);

      model.addAttribute("memberVO", memberVO);
      model.addAttribute("subscribeVO", subscribeVO);

      return "sub_success";
   }

   // 결제 주문 취소
   @RequestMapping(value = "/cancelPay.do", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   @ResponseBody
   public Map<String, Object> cancelPay(OrderVO ovo, HttpServletRequest request, HttpServletResponse response)
         throws Exception {

      Iamport iamport = new Iamport();

      // 아임포트 억세스 토큰생성
      String imp_key = URLEncoder.encode("9458449343571602", "UTF-8");
      String imp_secret = URLEncoder
            .encode("c78aAvqvXVnomnIQHgAPXG42aFDaIZGU7P4IludiqBGNYoDGFevCVzF5fjgYiWSqMX87slpSX6FWvjCa", "UTF-8");
      JSONObject json = new JSONObject();
      json.put("imp_key", imp_key);
      json.put("imp_secret", imp_secret);

      String requestURL = "https://api.iamport.kr/users/getToken";

      String token = iamport.getToken(request, response, json, requestURL);

      String order_muid = ovo.getOrder_muid();
      int res = iamport.cancelPayment(token, order_muid);
      orderService.orderCancle(ovo);

      Map<String, Object> result = new HashMap<String, Object>();

      if (res == 1) {
         result.put("result", "성공");
      } else {
         result.put("result", "실패");
      }

      return result;
   }
   
   // 재결제 되고 다시 예약하는 부분 > 아임포트 콜백
   @RequestMapping(value = "/iamport-callback", method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
   public void callback(@RequestBody HashMap<String, Object> map,HttpServletRequest request, HttpServletResponse response) throws Exception{
      //String imp_uid =(String)map.get("imp_uid");
      String merchant_uid =(String)map.get("merchant_uid");
      String end_uid = merchant_uid.substring(merchant_uid.length()-1, merchant_uid.length());
      String status = (String)map.get("status");
      
      if(end_uid.equals("s") && status.equals("paid")) {
         Iamport iamport = new Iamport();
         String requestURL = "https://api.iamport.kr/users/getToken";
         String imp_key = URLEncoder.encode("9458449343571602", "UTF-8");
         String imp_secret = URLEncoder
               .encode("c78aAvqvXVnomnIQHgAPXG42aFDaIZGU7P4IludiqBGNYoDGFevCVzF5fjgYiWSqMX87slpSX6FWvjCa", "UTF-8");
         JSONObject json = new JSONObject();
         json.put("imp_key", imp_key);
         json.put("imp_secret", imp_secret);
         
         String token = iamport.getToken(request, response, json, requestURL);
         
         HashMap<String, Object> getinfo = iamport.getSchedule(merchant_uid, token); 
         String customer_uid = (String)getinfo.get("customer_uid");
         String amount = ""+getinfo.get("amount");
         Calendar c = Calendar.getInstance();
         long time = c.getTimeInMillis() / 1000;
         String muid = "merchant_" + time +"s";
         
         iamport.subsres(customer_uid, muid, amount, request, response);
      }
      
   }
   
   // 정기구독 재구독
   @RequestMapping (value ="/subs_bye0.do", produces = "application/json; charset=utf-8")
   @ResponseBody 
   public Map<String, Object> resub (String member_id,HttpServletRequest request, HttpServletResponse response) throws Exception {
      // 아임포트
      MemberSubVO msv = membersubservice.sub_list(member_id);
      String stringSubEnd = msv.getSubs_end();
      
      DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      Date date = df.parse(stringSubEnd);
      long time = date.getTime() / 1000 + 86400;
      
      String muid = "merchant_" + new Date().getTime();
      String customer_uid = msv.getCustomer_uid();
      String amount =  Integer.toString(msv.getSubsprice());
      
      Iamport iamport = new Iamport();
      String requestURL = "https://api.iamport.kr/users/getToken";
      String imp_key = URLEncoder.encode("9458449343571602", "UTF-8");
      String imp_secret = URLEncoder
            .encode("c78aAvqvXVnomnIQHgAPXG42aFDaIZGU7P4IludiqBGNYoDGFevCVzF5fjgYiWSqMX87slpSX6FWvjCa", "UTF-8");
      JSONObject json = new JSONObject();
      json.put("imp_key", imp_key);
      json.put("imp_secret", imp_secret);
      
      String token = iamport.getToken(request, response, json, requestURL);
      iamport.resub(customer_uid, muid, amount, time, request, response);
      
       HashMap<String, Object> map = new HashMap<String, Object>();
       map.put("member_id", member_id);
       
       Map<String, Object> result = new HashMap<String, Object>();
         int res = membersubservice.resub(member_id);
            if(res==1) {
               result.put("res", "OK");
            } else {
               result.put("res", "FAIL");
               result.put("message", "Failure");
            }
      return result;
    }
   
   
}