<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "com.spring.member.MemberVO" %>
<%@ page import = "com.spring.member.SubscribeVO" %>
<%
	MemberVO memberVO = (MemberVO) request.getAttribute("memberVO");
	SubscribeVO subscribeVO = (SubscribeVO) request.getAttribute("subscribeVO");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel = "shortcut icon" href = "favicon.ico">
   <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
   <link rel="stylesheet" type="text/css" href="./css/default.css"/>
   <link rel="stylesheet" type="text/css" href="./css/success.css"/>
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script type="text/javascript">
      $(document).ready(function(){
         $("#header").load("./header.jsp")
         $("#footer").load("./footer.jsp")
         
         var subs_water = <%=subscribeVO.getSubs_water()%>;
         var subs_shirts = <%=subscribeVO.getSubs_shirts()%>;
         var subs_dry = <%=subscribeVO.getSubs_dry()%>;
         var subs_blanket = <%=subscribeVO.getSubs_blanket()%>;
         var subs_coupon = <%=subscribeVO.getSubs_coupon()%>;
         var subs_delivery = <%=subscribeVO.getSubs_delivery()%>;
         var subs_price = <%=subscribeVO.getSubs_price()%>;
         
 		 $("#subsWater").text(subs_water+'개');
 		 $("#subsShirts").text(subs_shirts+'장');
 		 $("#subsDry").text(subs_dry+'장');
 		 $("#subsBlanket").text(subs_blanket+'장');
 		 $("#subsCoupon").text(subs_coupon+'개');
 		 $("#subsDelivery").text(subs_delivery+'회');
         $("#subsPrice").html(numberFormat(subs_price+'원'));
         
  		for(var i = 0; i < 6; i++) {
			if($('.cell').eq(i).text().charAt(0) == "0") {
				$('.cell').eq(i).text('-');
			}
		}
         
         function numberFormat(inputNumber) {
     		   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
         }        	
         
         
      });
    </script>
</head>
<body>
   <div id="header"></div>
   
   <!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
   <section id="sub_success"> <!-- id 변경해서 사용하세요. -->
      <div class="content"> <!-- 변경하시면 안됩니다. -->
         <div class="title-text"> <!-- 변경하시면 안됩니다. -->
            <h2>결제완료</h2>
         </div>
         
         <div class = "div-1000">
	 
	 		<hr/>
			
			<h1 style = "margin-bottom : 100px;"><%=memberVO.getMember_name() %>님 구독 신청을 감사합니다.</h1>

			<table class = "sub_success_table">
				<thead>
					<th colspan = "7" align = "left" style = "height : 50px; background-color : #3498db"> &nbsp; &nbsp; 구독 상품 확인 (<%=subscribeVO.getSubs_name() %>)</th>
				</thead>
				<tbody align = "center">
					<tr>
						<td>물빨래 30L</td>
						<td>와이셔츠</td>
						<td>드라이클리닝</td>
						<td>이불</td>
						<td>보관 1BOX <br/>(1개월 쿠폰)</td>
						<td>배송</td>
						<td>금액</td>
					</tr>
					<tr>
						<td colspan = "7" style = "height :3px; background-color : #3498db"></td>
					</tr>
					<tr>
						<td class = "cell" id="subsWater"></td>
						<td class = "cell" id="subsShirts"></td>
						<td class = "cell" id="subsDry"></td>
						<td class = "cell" id="subsBlanket"></td>
						<td class = "cell" id="subsCoupon"></td>
						<td class = "cell" id="subsDelivery"></td>
						<td class = "cell" id="subsPrice"></td>
					</tr>				
				</tbody>
			</table>
			
			<div class="notice" style = "padding-top : 100px;">
	            <p>※ 구독관련 내용 확인은 마이페이지 > 나의 정기구독에서 확인 가능합니다.</p>
	      	</div>
	      	        		
			<p class = "goP"><a class = "goMain" href = "/setak/">홈으로 가기</a></p>
	      	        
	      </div>
	    
      </div>
   </section>
   <!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
   
   <div id="footer"></div>
</body>
</html>