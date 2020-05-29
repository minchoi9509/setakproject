<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "com.spring.setak.WashingVO" %>
<%@ page import = "com.spring.setak.MendingVO" %>
<%@ page import = "com.spring.setak.KeepVO" %>
<%@ page import = "com.spring.setak.*" %>
<%@ page import = "java.util.ArrayList" %>

<%
	String order_num = request.getParameter("order_num");

	ArrayList<WashingVO> washingList = (ArrayList<WashingVO>)request.getAttribute("washingList");
	ArrayList<MendingVO> mendingList = (ArrayList<MendingVO>)request.getAttribute("mendingList");
	ArrayList<KeepVO> keepList = (ArrayList<KeepVO>)request.getAttribute("keepList");
	int price = (int) request.getAttribute("price");
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
         $("#header").load("header.jsp")
         $("#footer").load("footer.jsp")
         
         var price = '<%=price%>'; 
         $("#pay_price").html(numberFormat(price));
         
      	// 모바일 이미지 
      	var windowWidth = $(window).width();
      	if (windowWidth > 769) {
      		$('.tab').click(function() {
      			$('html, body').animate({
      				scrollTop : 300
      			}, 500);
      			return false;
      		});
      	} else {
      		$('.tab-list a').click(function() {
      			event.preventDefault();
      		});
      		$('.arrow-img').attr("src","images/m_order3.png")
      	}
             
      	
      });
      	
  	// 콤마      
      function numberFormat(inputNumber) {
  		   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      }
     	
     	
    </script>
</head>
<body>
   <div id="header"></div>
   
   <!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
   <section id="order_success"> <!-- id 변경해서 사용하세요. -->
      <div class="content"> <!-- 변경하시면 안됩니다. -->
         <div class="title-text"> <!-- 변경하시면 안됩니다. -->
            <h2>주문완료</h2>
         </div>
         
         <div class = "div-1000">
	         <img class = "arrow-img" src = "images/order3.png" />
	 
	 		<hr/>
			
			<h1>주문해 주셔서 감사합니다.</h1>
			<br/>
			주문번호는 아래와 같습니다. 
			<br/>
			<p class = "p_orderNum"><%=order_num %></p>
			
			<table class = "order_success_table">
				<thead>
					<th colspan = "5" align = "left"> &nbsp; &nbsp; 주문 상품 확인 (총 <span id = "pay_price"></span>원)</th>
				</thead>
				<tbody align = "center">
					<tr>
						<td>구분</td>
						<td>종류</td>
						<td>수량</td>
						<td>가격</td>
						<td>비고</td>
	
					</tr>
					<tr>
						<td colspan = "5" style = "height :3px; background-color : #3498db"></td>
					</tr>
						<% if(washingList.size() != 0) {
						for(int i = 0; i < washingList.size(); i++) {
						WashingVO wvo = washingList.get(i);%>		
						  <tr>
		                     <td>세탁</td>
		                     <td><%=wvo.getWash_kind() %></td>
		                     <td><%=wvo.getWash_count() %>장</td>
		                     <td class = "product_price"><%=wvo.getWash_price() %>원</td>
		                     <td><%=wvo.getWash_method() %></td>
		                  </tr>   
                  		<% } } else { %>
                  		<tr></tr>
                  		<%} %>
						<% if(mendingList.size() != 0) {
						for(int i = 0; i < mendingList.size(); i++) {
						MendingVO mvo = mendingList.get(i);%>		
						  <tr>
		                     <%if(mvo.getRepair_wash() == 0) { %>
		                     <td>수선</td>
		                     <%} else { %>
		                     <td>세탁-수선</td>
		                     <%} %>
		                     <td><%=mvo.getRepair_cate()%></td>
		                     <td><%=mvo.getRepair_count()%>장</td>
		                     <td class = "product_price"><%=mvo.getRepair_price()%>원</td>
		                     <td><%=mvo.getRepair_kind()%> <span class = "repairCode">[텍코드 : <%=mvo.getRepair_code()%>]</span></td>
		                  </tr>   
                  		<% } } else { %>
                  		<tr></tr>
                  		<%} %>
                  		
						<% if(keepList.size() != 0) {
							for(int i = 0; i < keepList.size(); i++) {
							KeepVO kvo = keepList.get(i); %>		
						  <tr>
		                     <%if(kvo.getKeep_wash() == 0) { %>
		                     <td>보관</td>
		                     <% } else { %>
		                     <td>세탁-보관</td>
		                     <% } %>
		                     <td></td>
		                     <td><%=kvo.getKeep_box()%>박스</td>
		                     <td class = "product_price"><%=kvo.getKeep_price()%>원</td>
		                     <td><%=kvo.getKeep_month()%>개월</td>
		                  </tr>   
                  		<% } }else { %>
                  		<tr></tr>
                  		<%} %>					
				</tbody>
			</table>
			
			<p class = "goP"><a class = "goMain" href = "/setak/">홈으로 가기</a></p>

			<div class="notice">
	            <p>※ 주문내역 확인은 마이페이지 > 주문/배송 현황에서 확인 가능합니다.</p>
	      	</div>
	      	        
	      </div>
	    
      </div>
   </section>
   <!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
   
   <div id="footer"></div>
</body>
</html>