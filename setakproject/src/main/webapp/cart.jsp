<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "com.spring.setak.WashingVO" %>
<%@ page import = "com.spring.setak.MendingVO" %>
<%@ page import = "com.spring.setak.KeepVO" %>
<%@ page import = "java.util.ArrayList" %>
<%

	ArrayList<WashingVO> washingList = (ArrayList<WashingVO>)request.getAttribute("washingList");
	ArrayList<MendingVO> mendingList = (ArrayList<MendingVO>)request.getAttribute("mendingList");
	ArrayList<KeepVO> keepList = (ArrayList<KeepVO>)request.getAttribute("keepList");

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
	<link rel="stylesheet" type="text/css" href="./css/cart.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
</head>

    <script type="text/javascript">
	  $(window).load(function(){
	     $('.fa-shopping-cart').addClass('ick_color');
	  });

	  $(document).ready(function(){
    	 $("#header").load("./header.jsp")
    	 $("#footer").load("./footer.jsp")
    	 
		
		getTotal();
         deliveryFee();
         
     	// 모바일 이미지 
    var windowWidth = $(window).width();
	if (windowWidth <= 769) {
		$('.arrow-img').attr("src","images/m_order1.png")
	}
                  
	    /* 체크박스 전체선택 */
		$("#allcheck").click(function(){
	        if($("#allcheck").prop("checked")){
	            $("input[name=check]").prop("checked",true);
	        }else{
	            $("input[name=check]").prop("checked",false);
	        }
	    });
         
         /* 체크박스 삭제 */ 
     	$(".total-button a").click(function(){
     		var checkbox = $("input[name=check]:checked");
     		
     		if(checkbox.length == 0) {
     			Swal.fire("", "선택한 상품이 존재하지 않습니다.", "warning");
     			return; 
     		}
     		
     		// 전체 삭제 할 경우
     		var rd = false;      		
     		if($('#cartList tbody tr.cnt').length == checkbox.length) {
     			rd = true; 
     		}
     		
     		Swal.fire({
				text: "선택한 상품을 삭제하시겠습니까?",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonText: '네, 삭제합니다.',
				cancelButtonColor: '#d33',
				cancelButtonText: '아니요'
     		}).then((result) => {
     			if(result.value){
     			
                var washSeqArr = []; 
                var repairSeqArr = []; 
                var keepSeqArr = []; 
         		
         		checkbox.each(function(){
         			var tr = checkbox.parent().parent();
         			var type = $(this).val().substr(0, 1); 
         			var seq = $(this).val().substr(1, $(this).val().length);
         			         			
         			if(type == 'w') {
         				washSeqArr.push(seq);   				
         			}else if (type == 'r') {
         				repairSeqArr.push(seq);
         			}else {
         				keepSeqArr.push(seq);
         			}
      
         			tr.remove();
         			getTotal();
         			deliveryFee(); 
         			
         		});

         		var params = {
         			"washSeqArr" : washSeqArr,
         			"repairSeqArr" : repairSeqArr,
         			"keepSeqArr" : keepSeqArr,
         			"loc" : "cart"
         		};
         		
         		$.ajax({
         			url : '/setak/cartDelete.do',
         			type : 'post',
         			data : params,
         			traditional : true,
         			success : function(retVal) {
         				if(retVal.res == "OK") {
         					console.log("삭제 성공")
         					if(rd) {
         						window.location.href = "./order.do";
         					}
         				}else {
         					console.log("삭제 실패");
         				}
         			},
         			error : function() {
         				alert("삭제 과정 실패 ajax"); 
         			}
         		}); 
     		}else{
     			console.log("삭제안해!");
 			}
 		})

     		
     	});
         
         $('.fa-shopping-cart').addClass('ick_color');         
      });
      
      // 합계 구하는 함수
      function getTotal() {
    	  var total = 0; 
          $('.product_price').each(function() {
	          var price = parseInt($(this).text().slice(0, -1)); 
	          total += price; 
          });
          $("#order_price").html(numberFormat(total+'원'));
      }

      /* 배송비 */
      function deliveryFee() {
          var price = $("#order_price").text().replace(',',"").slice(0, -1);
          if(price < 30000) {
          	$("#deliver_price").text("2,500원");
          	var order_price = parseInt(price) + 2500;
          	$("#pay_price").html(numberFormat(order_price+'원'));
          } else {
         	 $("#deliver_price").text("0원");
         	 $("#pay_price").html(numberFormat(price+'원'));
          }         	 
      }

      
      function numberFormat(inputNumber) {
		   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      }
      
	</script>
<body>
	<div id="header"></div>
	
	<!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
	<section id="cart"> <!-- id 변경해서 사용하세요. -->
		<div class="content"> <!-- 변경하시면 안됩니다. -->
			<div class="title-text"> <!-- 변경하시면 안됩니다. -->
				<h2>장바구니</h2>
			</div>
						
			<div class = "cart-div">
							
				<img class = "arrow-img" src = "images/order1.png" />
				
				<table id = "cartList" class = "cart_list">
											
						<%if(washingList.size() == 0 && mendingList.size() == 0 && keepList.size() == 0) { %>
						<tr>
							<td colspan = "6" class = "empty_cart"> 
								<img src="https://img.icons8.com/ultraviolet/80/000000/shopping-cart.png">
								<p>장바구니에 담긴 상품이 없습니다.</p> 
								<p><a class = "goMain" href = "/setak/">홈으로 가기</a></p>
							</td>
						</tr>
						<%} else { %>
					<thead>
						<tr>
							<th><input id = "allcheck" type = "checkbox" /></th>
							<th>구분</th>
							<th>종류</th>
							<th>수량</th>
							<th>가격</th>
							<th>비고</th>
						</tr>
					</thead>
					<tbody align = "center">			
						<% if(washingList.size() != 0) {
						for(int i = 0; i < washingList.size(); i++) {
						WashingVO wvo = washingList.get(i);%>		
						  <tr class="cnt">
		                     <td>
		                     	<input type = "checkbox" name = "check" value = "w<%=wvo.getWash_seq() %>"/>
		                     </td>
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
						  <tr class="cnt">
		                     <td>
		                     	<input type = "checkbox" name = "check" value = "r<%=mvo.getRepair_seq()%>"/>
		                     </td>
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
								KeepVO kvo = keepList.get(i);%>			
						  <tr class="cnt">
		                     <td>
		                     	<input type = "checkbox" name = "check" value = "k<%=kvo.getKeep_seq()%>"/>
		                     </td>
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
                  		<%}
						}%>
					</tbody>
				</table>
				
				<p/>

				
				<%if(!(washingList.size() == 0 && mendingList.size() == 0 && keepList.size() == 0)) { %> 
				<div class="total-button">
					<a href="javascript:">선택삭제</a>
				</div>

				<table class = "cart_price">
					<thead>
						<tr>
							<th>주문금액</th>
							<th></th>
							<th>배송비</th>
							<th></th>
							<th>결제 예정금액</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><span id = "order_price"></span></td>
							<td class = "td_big">+</td>
							<td><span id = "deliver_price"></span></td>
							<td class = "td_big">=</td>
							<td class = "td_blue"><span id = "pay_price"></span></td>
						</tr>
					</tbody>
				</table>
				
				<button class="bt_1000" onclick="location.href='/setak/order.do?type=pay'">주문결제</button>
				<%} %>
		</div>
		

		</div>
	</section>
	<!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
	
	<div id="footer"></div>
</body>
</html>