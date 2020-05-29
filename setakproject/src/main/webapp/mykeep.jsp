<%@page import="com.spring.order.OrderListVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*, com.spring.setak.*"%>
<%@ page import="java.util.*, com.spring.member.*"%>
<%@ page import="java.util.*, com.spring.mypage.*"%>
<%
	List<OrderListVO> ordernumlist = (ArrayList<OrderListVO>) request.getAttribute("ordernumlist");
	ArrayList<ArrayList<KeepVO>> keeplist2 = (ArrayList<ArrayList<KeepVO>>) request.getAttribute("keeplist2");
	ArrayList<ArrayList<KeepPhotoVO>> kpvolist2 = (ArrayList<ArrayList<KeepPhotoVO>>) request.getAttribute("kpvolist2");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	List<Integer> seq_count = (ArrayList<Integer>) request.getAttribute("seq_count");
	MemberVO memberVO = (MemberVO) request.getAttribute("memberVO");
	String member_phone1 = (String) request.getAttribute("member_phone1");
	String member_phone2 = (String) request.getAttribute("member_phone2");
	String member_phone3 = (String) request.getAttribute("member_phone3");
	String member_addr1 = (String) request.getAttribute("member_addr1");
	String member_addr2 = (String) request.getAttribute("member_addr2");
	String zipcode = (String) request.getAttribute("zipcode");
	
	  int listcount = ((Integer)request.getAttribute("listcount")).intValue();
	   int nowpage = ((Integer)request.getAttribute("page")).intValue();
	   int maxpage = ((Integer)request.getAttribute("maxpage")).intValue();
	   int startpage = ((Integer)request.getAttribute("startpage")).intValue();
	   int endpage = ((Integer)request.getAttribute("endpage")).intValue();
	   int limit = ((Integer)request.getAttribute("limit")).intValue();
	
%>
<!DOCTYPE html>
<html>
<script src="//code.jquery.com/jquery.min.js"></script>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>세탁곰</title>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz"crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css" />
<link rel="stylesheet" type="text/css" href="./css/default.css" />
<link rel="stylesheet" type="text/css" href="./css/mykeep.css" />
<link rel="shortcut icon" href="favicon.ico">
   
<!-- 여기 본인이 지정한 css로 바꿔야함 -->
<script type="text/javascript" src="./js/controller.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.2.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var member_id = "<%=session.getAttribute("member_id")%>";
		
		$("#header").load("./header.jsp")
		$("#footer").load("./footer.jsp")
	
	});
	
</script>
</head>
<body>
	<div id="header"></div>

	<!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
	<section id="test">
		<!-- id 변경해서 사용하세요. -->
		<div class="content">
			<!-- 변경하시면 안됩니다. -->
         <div class="title-text">
            <h2>보관현황</h2>
         </div>
			<div class="mypage_head">
				<ul>
					<li class="mypage-title">마이페이지</li>
					<li>
						<ul class="mypage_list">
							<li>주문관리</li>
							<li><a href="orderview.do">주문/배송현황</a></li>
							<li><a href="mykeep.do">보관현황</a></li>
						</ul>
						<ul class="mypage_list">
							<li>정기구독</li>
							<li><a href="mysub.do">나의 정기구독</a></li>
						</ul>
						<ul class="mypage_list">
							<li>고객문의</li>
							<li><a href="myqna.do">Q&amp;A 문의내역</a></li>
						</ul>
						<ul class="mypage_list">
							<li>정보관리</li>
							<li><a href="profile1.do">개인정보수정</a></li>
							<li><a href="mycoupon.do">쿠폰조회</a></li>
							<li><a href="mysavings.do">적립금 조회</a></li>
							<li><a href="withdraw.do">회원탈퇴</a></li>
						</ul>
					</li>
				</ul>
			</div>
			<div class="solmin">
				<div class="mypage_content">
					<h2>보관현황</h2>
					<%if(ordernumlist.size() == 0 ) {%>
					<h3 class="null">보관하신 목록이 없습니다.</h3>
					<%} else { %>
					<%
						for (int i = 0; i < ordernumlist.size(); i++) {
							OrderListVO olvo = (OrderListVO) ordernumlist.get(i);
							ArrayList<KeepVO> keeplist = keeplist2.get(i);
							ArrayList<KeepPhotoVO> kpvo = kpvolist2.get(i);

							String start = keeplist.get(0).getKeep_start();
							String[] date = start.split(" ");
							String start_date = date[0];

							String end = keeplist.get(0).getKeep_end();
							String[] date2 = end.split(" ");
							String end_date = date2[0];

							Date sol = sdf.parse(end_date);

							Calendar one = Calendar.getInstance();
							one.setTime(sol);
							one.add(Calendar.MONTH, 1);
							String m1 = sdf.format(one.getTime());

							Calendar three = Calendar.getInstance();
							three.setTime(sol);
							three.add(Calendar.MONTH, 3);
							String m3 = sdf.format(three.getTime());

							Calendar six = Calendar.getInstance();
							six.setTime(sol);
							six.add(Calendar.MONTH, 6);
							String m6 = sdf.format(six.getTime());
							long num = 0;
					%>
					<div class="accordion2">
						<div class="accordion-header2" id="<%=olvo.getOrder_num()%>">
							<table class="header">
								<tr>
									<th style="width: 30%;" class="num">주문번호</th>
									<th style="width: 20%;" class="box">박스 수량</th>
									<th style="width: 40%;" class="day">보관 기간</th>
									<th style="width: 10%;" class="detail">상세보기</th>
								</tr>
								<tr>
									<td><%=olvo.getOrder_num()%></td>
									<td><%=keeplist.get(0).getKeep_box()%></td>
									<td><%=start_date%>&nbsp;~&nbsp;<%=end_date%></td>
									<td>
										<button id='up' class="up">&#8897;</button>
									</td>
								</tr>
							</table>
						</div>
						<div class="accordion-content2">
						<table>
						</table>
							<div class="photo">
								<ul class="img-list">
								<%for(int p = 0; p<kpvo.size(); p++) {
									KeepPhotoVO kpvo2 = (KeepPhotoVO) kpvo.get(p);
									if (kpvo2.getKeep_path()== null){								
								%>
								<li>
									<img src="http://placehold.it/255x280" onclick="window.open('http://placehold.it/800x600', 'new', 'width=800, height=600, left=500, top= 100, scrollbars=no');">
								</li>
								<%} else {%>	
								<li>
									<img src="https://kr.object.ncloudstorage.com/airbubble/setakgom/keep/<%=kpvo2.getKeep_path() %>" onclick="window.open('https://kr.object.ncloudstorage.com/airbubble/setakgom/keep/<%=kpvo2.getKeep_path() %>', 'new', 'width=800, height=600, left=500, top= 100, scrollbars=no');" class="keep_photo">
								</li>
								<%
									} 
								}
								%>
								</ul>
							</div>
							<div class="keepbox" style="border-right: 1px solid rgb(255, 255, 255);">보관 기간 연장</div>
							<div class="keepbox2">반환 신청</div>
							<div class="keep_month">
								<ul>
									<li class="month" value="<%=m1%>"><h3>1개월</h3>
										<p><%=end_date%> ~ <%=m1%></p>
										<h1>
											<span class="price">10000</span>원
										</h1>
									</li>
									<li class="month" value="<%=m3%>"><h3>3개월</h3>
										<p><%=end_date%> ~ <%=m3%></p>
										<h1>
											<span class="price">28000</span>원
										</h1>
									</li>
									<li class="month" value="<%=m6%>"><h3>6개월</h3>
										<p><%=end_date%> ~ <%=m6%></p>
										<h1>
											<span class="price">55000</span>원
										</h1>
									</li>
								</ul>
								<div class="total_price">
									<p>
										보관비 총 금액 : <span class="tot_price" id="select_price">0</span>원
									</p>
								</div>

								<button class="pay_btn" value="<%=olvo.getOrder_num()%>">결제하기</button>
							</div>
							<div class="rt-service">
								<form name="rt-form" class="rt-form" id="testform">
									<table id="rt-table" name="rt-table" class="rt-table">

										<tr style="background-color: #3498db;">
											<td width="20%">종류</td>
											<td width="80%" colspan="2">옷의 특징을 상세히 입력해주세요. 
											<input type="button" value="+" name='btn_add_row' class="btn_add_row" id="<%=olvo.getOrder_num()%>" /> 
											<input type="hidden" name="order_num" value="<%=olvo.getOrder_num()%>"> 
											<input type="hidden" name="return_confirm" value="반환신청완료">
											</td>
										</tr>
										<tr class="keep_tr">
											<td>
												<select class="rt-list" name="return_kind"></select>
											</td>
											<td>
												<textarea rows="2" cols="30" placeholder="상세내용" class="return_content" name="return_content"></textarea>
											</td>
											<td class="bt_del">
												<input type="button" value="x" class="btn_del_row" />
											</td>
										</tr>
									</table>
								</form>
								<div class="rt_button">
									<button class="part_return" name="rt-form" value="<%=olvo.getOrder_num()%>">부분반환</button>
									<button class="all_return" name="rt-form" value="<%=olvo.getOrder_num()%>">전체반환</button>
								</div>
								<p>
									※ 부분 반환 신청시 회당 추가 배송비 2,000원이 부과됩니다.<br>
								</p>
								<p>※ 옷의 특징을 상세히 알려주세요. 부합하는 물품이 없을 시 개인 정보에 적혀있는 전화번호로 연락을
									드리며,</p>
								<p>&nbsp;&nbsp;공휴일 제외 5일 이상 부재중 시 결제 및 반환이 취소됩니다.</p>
								<p>※ 반환 후 재 보관은 불가하며, 보관을 원하실 경우 새로 보관 서비스를 이용하시길 바랍니다.</p>
							</div>
						</div>
						<br>
					</div>
					<%
						}
					%>
				</div>
				 <div class="page1">
            <table class="page">
               <tr align = center height = 20>
                       <td>
              				<%if(nowpage <= 1) {
              				%>
              				<div class="page_a"><a>&#60;</a></div>
              				<%} else {%>
              					<div class="page_a"><a href ="./mykeep.do?page=<%=nowpage-1 %>">&#60;</a></div>
              				<%} %>
              				<%for (int a=startpage; a<= endpage; a++) {
              					if(a==nowpage) {
           					%>
           					<div class="page_a active2"><a><%=a %></a></div>
           					<%} else {%>
           						<div class="page_a"><a href="./mykeep.do?page=<%=a %>"><%=a %></a></div>
           					<%} %>
           					<%} %>
           					<%if (nowpage >= maxpage) {
           					%>	
           						<div class="page_a"><a>&#62;</a></div>
           					<%} else { %>	
                  				<div class="page_a"><a href ="./mykeep.do?page=<%=nowpage+1 %>">&#62;</a></div>
                  			<%} %>	
                  			</td>
                     </tr>
            </table>
            </div>
				
				
				<%} %>
			</div>
		</div>
		<!-- content -->
	</section>
	<!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
	<!-- 나의 주소록 레이어 -->
	<div id="footer"></div>
</body>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script>//보관기간연장 아코디언
//보관품목

$(document).ready(function () {
	
	function selectData() {
		
		$(".up").click(function() {
			var order_num = $(this).parent().parent().parent().parent().parent().attr('id');
			$(".accordion-content2 > table").empty();
			$(".rt-list").empty();
			
		$.ajax({
			url : '/setak/keepcatelist.do',
			type : 'POST',
			data : {'order_num': order_num},
			dataType : "json",
			content : 'application/x-www-form-urlencoded; charset = utf-8',
			
			success:function(data) {
					var output= '';
					var input='';
					output += '<tr>';
					output += '<td style="background-color: #3498db;">보관하신품목</td>';
					output += '</tr>';
				$.each(data, function(index, item) {
					output += '<tr>';
					output += '<td>' + item.keep_cate + '&nbsp;&nbsp;' + '(' + item.keep_kind + ')' + '&nbsp;&nbsp;' +item.keep_count + '</td>';
					output += '</tr>';
				});
				var kind_arr = new Array();
				$.each(data, function(index, item) {
					if(!(kind_arr.includes(item.keep_kind))){
					input += '<option value='+item.keep_kind+'>' + item.keep_kind + '</option>';
					kind_arr.push(item.keep_kind);
					}
				})
				console.log("output : " + output);
				$('.accordion-content2 > table').append(output);
				$('.rt-list').append(input);
			},
			error:function(){
				alert("ajax 통신 실패");
			}
			});
		});  
	}
	 selectData();
});

//보관기간 선택 시 css효과, 보관기간의 돈 값 가져와서 합계에 보여주기.
var monthclick = 0;
var price = parseInt(0);
$(".month").on("click", function(){
	$(".month").removeClass("month_click");
	$(this).addClass("month_click");
	monthclick = 1;
	price = parseInt($($(this).children().children('.price')).html());
	var n = $('.count').index(this);
	$('.tot_price').html(price);
	$.pricefun(n);
});
//수량에 따른 값변경
$.pricefun = function(n){
	var num = parseInt($(".box_count:eq(" + n + ")").val());
	
};

	$(document).ready(function() {
	  jQuery(".accordion-content2").hide();
	//content 클래스를 가진 div를 표시/숨김(토글)
	
	  $(".up").click(function(){
		$except = $(this).parent().parent().parent().parent().parent();
		$except.toggleClass("active");
	    $(".accordion-content2")
	    	.not($(this).parent().parent().parent().parent().parent().next(".accordion-content2").slideToggle(500)).slideUp();
	    $('.mypage_content_cover2').find('.accordion2>.accordion-header2').not($except).removeClass("active");
	  });
	
	  $(document).on("click",".btn_del_row", function() {
			$(this).parent().parent().remove();
		});	
	  
	  $(document).on("click","input[name='btn_add_row']", function () {
		  var select_btn = $(this);
		  var order_num = $(this).attr('id');
		  	
			$.ajax({
			url : '/setak/keepcatelist.do',
			type : 'POST',
			data : {'order_num': order_num},
			dataType : "json",
			content : 'application/x-www-form-urlencoded; charset = utf-8',
			success:function(data) {
				
					var str='';			
					str += '<tr>';
					str += '<td>';
					str += '<select class="rt-list" name="return_kind">';
					var kind_arr = new Array();
				$.each(data, function(index, item) {
					if(!(kind_arr.includes(item.keep_kind))){
					str += '<option value='+ item.keep_kind +'>' + item.keep_kind + '</option>';
					kind_arr.push(item.keep_kind);
					}
				})
					str += '</select>';
					str += '</td>';
					str += '<td>';
					str += '<textarea rows="2" cols="30" placeholder="상세내용" name="return_content"></textarea>';
					str += '</td>';
					str += '<td class="bt_del">';
					str += '<input type="button" value="x" class="btn_del_row"/>';
					str += '</td>';
					str += '</tr>'; 
					
					var tr = select_btn.parent().parent().parent();
					tr.append(str);  
			},
			error:function(){
				alert("ajax 통신 실패");
			}
			});
			
			//$("table[name='rt-table']:eq(-1) > tbody:last").append(str);
	});
	});

//반환아코디언
$(document).ready(function() {
	jQuery(".rt-service").hide();
	$(".keepbox2").click(function() {
		$except = $(this);
		$except.toggleClass("active");
		$(".rt-service").slideToggle(300);
		$(".keep_month").slideUp(0);
	});
});


//보관 연장 결제 스크립트
$(document).ready(function() {
	
 	  jQuery(".keep_month").hide();
 	//content 클래스를 가진 div를 표시/숨김(토글)
 	  $(".keepbox").click(function(){
 		$except = $(this);
		$except.toggleClass("active");
		$(".keep_month").slideToggle(200);
		$(".rt-service").slideUp(0);
 	 	});
 	// 결제 : 아임포트 스크립트
 		var end_date; 	
 		$(".month").click(function() {
				end_date = $(this).attr('value');
 	    });
 		
 		$(".pay_btn").on("click", function(){
 			
	 		var select_price = $("#select_price").text();
			
	 		var order_num = $(this).attr('value');
	 	    
	        var IMP = window.IMP; // 생략가능
	        IMP.init('imp30471961'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
	        var msg;
	 	    
	        if (select_price == 0){
	        	Swal.fire("","연장 기간을 선택해 주시기 바랍니다.","info");
	        	return false;
	        }
	        
	        IMP.request_pay({
	            pg : 'inicis',
	            pay_method : 'card',
	            merchant_uid : 'merchant_' + new Date().getTime(),
	            name : '세탁곰 결제',
	            amount : select_price,
	            buyer_email : '<%=memberVO.getMember_email()%>',
	            buyer_name : '<%=memberVO.getMember_name()%>', 
	            buyer_tel : '<%=memberVO.getMember_phone()%>',
	            buyer_addr : '<%=memberVO.getMember_loc()%>',
	            buyer_postcode : '<%=memberVO.getMember_zipcode()%>',
	            //m_redirect_url : 'http://www.naver.com'
	        }, function(rsp) {
	            if (rsp.success) {
	               //[1] 서버단에서 결제정보 조회를 위해 jQuery ajax로 imp_uid 전달하기
	 	  	  	jQuery.ajax({
		 	    	url: '/setak/update_Month.do',
		 	    	type:'POST',
		 	    	data : { 
		 	    		'order_num' : order_num,
			        	'keep_end' : end_date
		 	    	},
		 	    	dataType : "json",
					content : 'application/x-www-form-urlencoded; charset = utf-8',
					success:function(data){
		            	var num = data.order_num;
		            	Swal.fire({
							text: "신청을 완료하였습니다.",
							icon: "info",
						}) .then(function(){
							location.href='/setak/mykeep.do';
						});
					}
	 	    	});
	 	 		} else {
	            	//실패시 이동할 페이지
	            	Swal.fire({
						text: "결제에 실패하였습니다.",
						icon: "error",
					}) .then(function(){
						location.href='/setak/mykeep.do';
					});
	 	 		}
	 		});
 	});
});
//부분반환 결제
	$(document).ready(function() {
	
 	//content 클래스를 가진 div를 표시/숨김(토글)
 	// 결제 : 아임포트 스크립트
 	 $(".part_return").on("click", function(){
 		   
 		var select_price = 2000;
 			
 		// 테이블 값을 받아오기 (for문)
 		// 나눠서 kindArr, contentArr 넣어줌
 		var return_keep = $("#testform").serializeArray();
 		
 	
 		// 결제 금액 받아오기 
 		  var IMP = window.IMP; // 생략가능
 	        IMP.init('imp30471961'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
 	        var msg;
 	        var massage;
 	       if (select_price == 0){
	        	Swal.fire("","금액을 선택해주십시오.","info");
	        	return false;
	        }
 	        
 	        IMP.request_pay({
 	            pg : 'kakaopay',
 	            pay_method : 'card',
 	            merchant_uid : 'merchant_' + new Date().getTime(),
 	            name : '세탁곰 결제',
 	            amount : select_price,
 	            buyer_email : '<%=memberVO.getMember_email()%>',
 	            buyer_name : '<%=memberVO.getMember_name()%>', 
 	            buyer_tel : '<%=memberVO.getMember_phone()%>',
 	            buyer_addr : '<%=memberVO.getMember_loc()%>',
 	            buyer_postcode : '<%=memberVO.getMember_zipcode()%>',
 	            //m_redirect_url : 'http://www.naver.com'
 	       		 }, function(rsp) {
 	            if ( rsp.success ) {
 	                //[1] 서버단에서 결제정보 조회를 위해 jQuery ajax로 imp_uid 전달하기
 	                jQuery.ajax({
 	                    url: "/setak/part_Return.do", //cross-domain error가 발생하지 않도록 주의해주세요. 결제 완료 이후
 	                    type: 'POST',
 	                    dataType: 'json',
 	                    data: return_keep,
 	                success : function(data) {
 	                	massage = '부분반환 결제에 성공하셨습니다';
 	                	location.href = "/setak/mykeep.do";
						}
					});
					} else {
						//실패시 이동할 페이지
						Swal.fire({
							text: "결제에 실패하였습니다.",
							icon: "error",
						}) .then(function(){
							location.href='/setak/mykeep.do';
						});
					  }
					});
 	 				});
				});
		
	
	//전체반환
	$('.all_return').on("click", function() {
		var order_num = $(this).attr('value');
		var msg = '';
		$.ajax({
			url : '/setak/all_Return.do',
			type : 'POST',
			data : {'order_num' : order_num},
			dataType : "json",
			content : 'application/x-www-form-urlencoded; charset = utf-8',
			success:function(data){
				Swal.fire({
					text: "전체반환신청완료",
					icon: "success",
				}) .then(function(){
					location.href='/setak/mykeep.do';
				});
			},
			error:function(){
				alert("ajax 통신 실패");
			}
		});
	});		
			
	//업다운 이미지 변환
	$(function() {
		$('.up').on("click", function() {
			if ($(this).html() == '⋁') {
				$(this).html('&#8896;')
			} else {
				$(this).html('&#8897;');
			}
		});
	});

</script>
</html>