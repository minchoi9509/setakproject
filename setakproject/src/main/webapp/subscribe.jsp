<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "com.spring.member.MemberVO" %>

<%
	MemberVO memberVO = new MemberVO();
	Integer sub_num = null; 
	if(session.getAttribute("member_id") != null) {
		memberVO = (MemberVO) request.getAttribute("memberVO");
		sub_num = memberVO.getSubs_num();	
	}
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
	<link rel="stylesheet" type="text/css" href="./css/subscribe.css"/>

   <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
   <script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.2.js"></script>
   
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script type="text/javascript">

    
      $(document).ready(function(){
         $("#header").load("./header.jsp")
         $("#footer").load("./footer.jsp")
         
         // 회원 별 보이는 화면 다르게
         var member_id = "<%=session.getAttribute("member_id")%>"; 
         var sub_num = '<%=sub_num%>';
         
         if(sub_num == "null") {
        	 $('.pay_td').show();
             // 아임포트 정기 결제 모바일
             $(document).on('click', '.subImg', function(event) {
            	 
            	 if(member_id == "null") {
            		 window.location.href = "./login.do";
            		 return; 
            	 }
            	 
            	 var tr = $(this).parent().parent();
            	 var subs_num = $(tr).attr('id'); 
            	 var final_price = $(tr).attr('class');             	 
            	 // merchant_uid
            	 var muid = 'merchant_' + new Date().getTime();
            	 
            	 // customer_uid를 위한 난수 생성 > 재결제 예약에 사용 
            	 var num = Math.floor(Math.random() * 1000) + 1; 
            	 var cuid = '<%=memberVO.getMember_id()%>' + num;
                 var IMP = window.IMP; // 생략가능
                 IMP.init('imp30471961'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
                 var msg;
                              
                 // IMP.request_pay(param, callback) 호출
                 IMP.request_pay({ // param
                   pay_method: "card", // "card"만 지원됩니다
                   merchant_uid : muid,
                   customer_uid: cuid, // 카드(빌링키)와 1:1로 대응하는 값
                   name: "정기 구독 결제 카드 등록 및 최초 결제",
                   amount: final_price
                 }, function (rsp) { // callback
                   if (rsp.success) {
                	   Swal.fire("","결제가 성공적으로 완료되었습니다.","success"); 
                	      // 빌링키 발급 성공
                	      // jQuery로 HTTP 요청
                	      jQuery.ajax({
                	        url: "/setak/insertSubscribe.do", 
                	        method: "POST",
                	        dataType: 'text',
                	        data: {
                	          merchant_uid : muid,
                	          customer_uid: cuid,
                	          'member_id' : member_id,
               				  'subs_num' : subs_num,
               				  'amount': final_price
                	        },
                            success : function() {
                            	
                                location.href='/setak/subSuccess.do';
                            } 
                	      });
                   } else {
                	 console.log(rsp); 
                     Swal.fire("","결제가 취소 되었습니다.","error"); 
                   }
                 });
                 
             });
             
         }else {
        	 $('.pay_td').hide();
         }
         
         // 아임포트 정기 결제
         $(document).on('click', '.pay_button', function(event) {
        	 
        	 if(member_id == "null") {
        		 window.location.href = "./login.do";
        		 return; 
        	 }
        	 
        	 var tr = $(this).parent().parent();
        	 var subs_num = $(tr).attr('id'); 
        	 var final_price = $(tr).attr('class');             	 
        	 // merchant_uid
        	 var muid = 'merchant_' + new Date().getTime();
        	 
        	 // customer_uid를 위한 난수 생성 > 재결제 예약에 사용 
        	 var num = Math.floor(Math.random() * 1000) + 1; 
        	 var cuid = '<%=memberVO.getMember_id()%>' + num;
             var IMP = window.IMP; // 생략가능
             IMP.init('imp30471961'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
             var msg;
                          
             // IMP.request_pay(param, callback) 호출
             IMP.request_pay({ // param
               pay_method: "card", // "card"만 지원됩니다
               merchant_uid : muid,
               customer_uid: cuid, // 카드(빌링키)와 1:1로 대응하는 값
               name: "정기 구독 결제 카드 등록 및 최초 결제",
               amount: final_price
             }, function (rsp) { // callback
               if (rsp.success) {
            	   Swal.fire("","결제가 성공적으로 완료되었습니다.","success"); 
            	      // 빌링키 발급 성공
            	      // jQuery로 HTTP 요청
            	      jQuery.ajax({
            	        url: "/setak/insertSubscribe.do", 
            	        method: "POST",
            	        dataType: 'text',
            	        data: {
            	          merchant_uid : muid,
            	          customer_uid: cuid,
            	          'member_id' : member_id,
           				  'subs_num' : subs_num,
           				  'amount': final_price
            	        },
                        success : function() {
                        	
                            location.href='/setak/subSuccess.do';
                        } 
            	      });
               } else {
            	 console.log(rsp); 
                 Swal.fire("","결제가 취소 되었습니다.","error"); 
               }
             });
             
         });
         
      });
    </script>
</head>
<body>

	<div id="header"></div>
		
   <!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
   <section id="subscribe"> <!-- id 변경해서 사용하세요. -->
      <div class="content"> <!-- 변경하시면 안됩니다. -->
		<div class = "div-1000">	
	         <div class="title-text"> <!-- 변경하시면 안됩니다. -->
	            <h2>정기구독</h2>
	         </div>
	                
	       	<div class="sub-div">
		         <p class = "p_subtitle">※ 정기구독을 신청하시면 할인 된 가격에 세탁곰을 이용하실 수 있습니다.</p> 	
		        
		        <p class = "sub_title">※ 올인원</p>
				<table class = "sub_table" border = "solid 1px" data-role="table">
					<thead>
						<tr>
							<th width = "10%">요금제</th>
							<th width = "15%">금액</th>
							<th width = "10%">물빨래 30L</th>
							<th width = "10%">와이셔츠</th>
							<th width = "10%">드라이클리닝</th>
							<th width = "10%">이불</th>
							<th width = "15%">보관 1BOX<br/>(1개월 쿠폰)</th>
							<th width = "10%">배송</th>
							<th class = "pay_td" width = "10%">결제</th>
						</tr>
					</thead>
					<tbody align = "center">
						<tr id = "1" class = "59000">
							<td>올인원59</td>
							<td>
								<span class = "origin_price">76,700원</span>
								<br/>
								<span class = "sale_price">59,000원</span>
							</td>
							<td>3개</td>
							<td>15장</td>
							<td>3장</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "2" class = "74000">
							<td>올인원74</td>
							<td>
								<span class = "origin_price">99,900원</span>
								<br/>
								<span class = "sale_price">74,000원</span>
							</td>
							<td>5개</td>
							<td>20장</td>
							<td>3장</td>
							<td>-</td>
							<td>-</td>
							<td>4회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "3" class = "89000">
							<td>올인원89</td>
							<td>
								<span class = "origin_price">113,900원</span>
								<br/>
								<span class = "sale_price">89,000원</span>
							</td>
							<td>8개</td>
							<td>20장</td>
							<td>4장</td>
							<td>-</td>
							<td>1장</td>
							<td>6회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "4" class = "104000">
							<td>올인원104</td>
							<td>
								<span class = "origin_price">136,900원</span>
								<br/>
								<span class = "sale_price">104,000원</span>
							</td>
							<td>8개</td>
							<td>20장</td>
							<td>5장</td>
							<td>1개</td>
							<td>1장</td>
							<td>8회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "5" class = "119000">
							<td>올인원119</td>
							<td>
								<span class = "origin_price">146,000원</span>
								<br/>
								<span class = "sale_price">119,000원</span>
							</td>
							<td>9개</td>
							<td>20장</td>
							<td>6장</td>
							<td>1개</td>
							<td>2장</td>
							<td>10회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "6" class = "134000">
							<td>올인원134</td>
							<td>
								<span class = "origin_price">164,900원</span>
								<br/>
								<span class = "sale_price">134,000원</span>
							</td>
							<td>15개</td>
							<td>20장</td>
							<td>7장</td>
							<td>1개</td>
							<td>3장</td>
							<td>12회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
							
					</tbody>
				</table>
				
				<table class = "sub_table_mobile" border = "solid 1px" data-role="table">
					<tbody align = "center">
						<tr id = "1" class = "59000">
							<td>
								<img class = "subImg" src = "images/sub-all1.png" />
							</td>
						</tr>
						<tr id = "2" class = "74000">
							<td>
								<img class = "subImg" src = "images/sub-all2.png" />
							</td>
						</tr>						
						<tr id = "3" class = "89000">
							<td>
								<img class = "subImg" src = "images/sub-all3.png" />
							</td>
						</tr>
						
						<tr id = "4" class = "104000">
							<td>
								<img class = "subImg" src = "images/sub-all4.png" />
							</td>
						</tr>
						
						<tr id = "5" class = "119000">
							<td>
								<img class = "subImg" src = "images/sub-all5.png" />
							</td>
						</tr>
						
						<tr id = "6" class = "134000">
							<td>
								<img class = "subImg" src = "images/sub-all6.png" />
							</td>
						</tr>
							
					</tbody>
				</table>
				
				<p/>
				<p class = "sub_title">※ 와이셔츠</p>
				<table class = "sub_table" border = "solid 1px">
					<thead>
						<tr>
							<th width = "10%">요금제</th>
							<th width = "15%">금액</th>
							<th width = "10%">물빨래 30L</th>
							<th width = "10%">와이셔츠</th>
							<th width = "10%">드라이클리닝</th>
							<th width = "10%">이불</th>
							<th width = "15%">보관 1BOX<br/>(1개월 쿠폰)</th>
							<th width = "10%">배송</th>
							<th class = "pay_td" width = "10%">결제</th>
						</tr>
					</thead>
					<tbody align = "center">
						<tr id = "7" class = "29000">
							<td>와이29</td>
							<td>
								<span class = "origin_price">35,900원</span>
								<br/>
								<span class = "sale_price">29,000원</span>
							</td>
							<td>-</td>
							<td>15장</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "8" class = "44000">
							<td>와이44</td>
							<td>
								<span class = "origin_price">59,900원</span>
								<br/>
								<span class = "sale_price">44,000원</span>
							</td>
							<td>-</td>
							<td>30장</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>4회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "9" class = "59000">
							<td>와이59</td>
							<td>
								<span class = "origin_price">75,900원</span>
								<br/>
								<span class = "sale_price">59,000원</span>
							</td>
							<td>-</td>
							<td>55장</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>6회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>	
					</tbody>
				</table>
				
				<table class = "sub_table_mobile" border = "solid 1px" data-role="table">
					<tbody align = "center">
						<tr id = "7" class = "29000">
							<td>
								<img class = "subImg" src = "images/sub-shirt1.png" />
							</td>
						</tr>				
						<tr id = "8" class = "44000">
							<td>
								<img class = "subImg" src = "images/sub-shirt2.png" />
							</td>
						</tr>				
						<tr id = "9" class = "59000">
							<td>
								<img class = "subImg" src = "images/sub-shirt3.png" />
							</td>
						</tr>
							
					</tbody>
				</table>
				
				<p/>
				<p class = "sub_title">※ 드라이</p>
				<table class = "sub_table" border = "solid 1px">
					<thead>
						<tr>
							<th width = "10%">요금제</th>
							<th width = "15%">금액</th>
							<th width = "10%">물빨래 30L</th>
							<th width = "10%">와이셔츠</th>
							<th width = "10%">드라이클리닝</th>
							<th width = "10%">이불</th>
							<th width = "15%">보관 1BOX<br/>(1개월 쿠폰)</th>
							<th width = "10%">배송</th>
							<th width = "10%"  class = "pay_td">결제</th>
						</tr>
					</thead>
					<tbody align = "center">
						<tr id = "10" class = "44000">
							<td>드라이44</td>
							<td>
								<span class = "origin_price">57,900원</span>
								<br/>
								<span class = "sale_price">44,000원</span>
							</td>
							<td>-</td>
							<td>-</td>
							<td>10장</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "11" class = "59000">
							<td>드라이59</td>
							<td>
								<span class = "origin_price">71,900원</span>
								<br/>
								<span class = "sale_price">59,000원</span>
							</td>
							<td>-</td>
							<td>-</td>
							<td>14장</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "12" class = "74000">
							<td>드라이74</td>
							<td>
								<span class = "origin_price">99,900원</span>
								<br/>
								<span class = "sale_price">74,000원</span>
							</td>
							<td>-</td>
							<td>-</td>
							<td>18장</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>	
					</tbody>
				</table>
				
				<table class = "sub_table_mobile" border = "solid 1px" data-role="table">
					<tbody align = "center">
						<tr id = "10" class = "44000">
							<td>
								<img class = "subImg" src = "images/sub-dry1.png" />
							</td>
						</tr>				
						<tr id = "11" class = "59000">
							<td>
								<img class = "subImg" src = "images/sub-dry2.png" />
							</td>
						</tr>				
						<tr id = "12" class = "74000">
							<td>
								<img class = "subImg" src = "images/sub-dry3.png" />
							</td>
						</tr>
							
					</tbody>
				</table>
				
				<p/>
				<p class = "sub_title">※ 물빨래</p>
				<table class = "sub_table" border = "solid 1px">
					<thead>
						<tr>
							<th width = "10%">요금제</th>
							<th width = "15%">금액</th>
							<th width = "10%">물빨래 30L</th>
							<th width = "10%">와이셔츠</th>
							<th width = "10%">드라이클리닝</th>
							<th width = "10%">이불</th>
							<th width = "15%">보관 1BOX<br/>(1개월 쿠폰)</th>
							<th width = "10%">배송</th>
							<th width = "10%"  class = "pay_td">결제</th>
						</tr>
					</thead>
					<tbody align = "center">
						<tr id = "13" class = "34000">
							<td>물빨래34</td>
							<td>
								<span class = "origin_price">39,900원</span>
								<br/>
								<span class = "sale_price">34,000원</span>
							</td>
							<td>3개</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "14" class = "49000">
							<td>물빨래49</td>
							<td>
								<span class = "origin_price">59,900원</span>
								<br/>
								<span class = "sale_price">49,000원</span>
							</td>
							<td>5개</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "15" class = "64000">
							<td>물빨래64</td>
							<td>
								<span class = "origin_price">72,900원</span>
								<br/>
								<span class = "sale_price">64,000원</span>
							</td>
							<td>7개</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>4회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "16" class = "79000">
							<td>물빨래79</td>
							<td>
								<span class = "origin_price">92,900원</span>
								<br/>
								<span class = "sale_price">79,000원</span>
							</td>
							<td>7개</td>
							<td>-</td>
							<td>-</td>
							<td>1개</td>
							<td>-</td>
							<td>5회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "17" class = "84000">
							<td>물빨래84</td>
							<td>
								<span class = "origin_price">99,900원</span>
								<br/>
								<span class = "sale_price">84,000원</span>
							</td>
							<td>8개</td>
							<td>-</td>
							<td>-</td>
							<td>1개</td>
							<td>-</td>
							<td>7회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "18" class = "99000">
							<td>물빨래99</td>
							<td>
								<span class = "origin_price">111,900원</span>
								<br/>
								<span class = "sale_price">99,000원</span>
							</td>
							<td>13개</td>
							<td>-</td>
							<td>-</td>
							<td>1개</td>
							<td>1장</td>
							<td>9회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
					</tbody>
				</table>
				
				<table class = "sub_table_mobile" border = "solid 1px" data-role="table">
					<tbody align = "center">
						<tr id = "13" class = "34000">
							<td>
								<img class = "subImg" src = "images/sub-wash1.png" />
							</td>
						</tr>				
						<tr id = "14" class = "49000">
							<td>
								<img class = "subImg" src = "images/sub-wash2.png" />
							</td>
						</tr>				
						<tr id = "15" class = "64000">
							<td>
								<img class = "subImg" src = "images/sub-wash3.png" />
							</td>
						</tr>
						<tr id = "16" class = "79000">
							<td>
								<img class = "subImg" src = "images/sub-wash4.png" />
							</td>
						</tr>				
						<tr id = "17" class = "84000">
							<td>
								<img class = "subImg" src = "images/sub-wash5.png" />
							</td>
						</tr>				
						<tr id = "18" class = "99000">
							<td>
								<img class = "subImg" src = "images/sub-wash6.png" />
							</td>
						</tr>
							
					</tbody>
				</table>
				
				<p/>
				<p class = "sub_title">※ 물빨래&드라이</p>
				<table class = "sub_table" border = "solid 1px" style = "margin-bottom : 150px; ">
					<thead>
						<tr>
							<th width = "10%">요금제</th>
							<th width = "15%">금액</th>
							<th width = "10%">물빨래 30L</th>
							<th width = "10%">와이셔츠</th>
							<th width = "10%">드라이클리닝</th>
							<th width = "10%">이불</th>
							<th width = "15%">보관 1BOX<br/>(1개월 쿠폰)</th>
							<th width = "10%">배송</th>
							<th width = "10%"  class = "pay_td">결제</th>
						</tr>
					</thead>
					<tbody align = "center">
						<tr id = "19" class = "44000">
							<td>물드44</td>
							<td>
								<span class = "origin_price">49,900원</span>
								<br/>
								<span class = "sale_price">44,000원</span>
							</td>
							<td>3개</td>
							<td>-</td>
							<td>3장</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "20" class = "59000">
							<td>물드59</td>
							<td>
								<span class = "origin_price">67,900원</span>
								<br/>
								<span class = "sale_price">59,000원</span>
							</td>
							<td>4개</td>
							<td>-</td>
							<td>4장</td>
							<td>-</td>
							<td>-</td>
							<td>3회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "21" class = "74000">
							<td>물드74</td>
							<td>
								<span class = "origin_price">84,900원</span>
								<br/>
								<span class = "sale_price">74,000원</span>
							</td>
							<td>6개</td>
							<td>-</td>
							<td>4장</td>
							<td>-</td>
							<td>-</td>
							<td>4회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
						<tr id = "22" class = "89000">
							<td>물드89</td>
							<td>
								<span class = "origin_price">109,900원</span>
								<br/>
								<span class = "sale_price">89,000원</span>
							</td>
							<td>7개</td>
							<td>-</td>
							<td>4장</td>
							<td>1회</td>
							<td>1장</td>
							<td>4회</td>
							<td class = "pay_td"><button class = "pay_button"><i class="far fa-credit-card"></i>&nbsp;결제</button></td>
						</tr>
						
					</tbody>
				</table>
				
				<table class = "sub_table_mobile" border = "solid 1px" data-role="table">
					<tbody align = "center">
						<tr id = "19" class = "44000">
							<td>
								<img class = "subImg" src = "images/sub-washDry1.png" />
							</td>
						</tr>				
						<tr id = "20" class = "59000">
							<td>
								<img class = "subImg" src = "images/sub-washDry2.png" />
							</td>
						</tr>				
						<tr id = "21" class = "74000">
							<td>
								<img class = "subImg" src = "images/sub-washDry3.png" />
							</td>
						</tr>
						<tr id = "22" class = "89000">
							<td>
								<img class = "subImg" src = "images/sub-washDry4.png" />
							</td>
						</tr>
							
					</tbody>
				</table>
				
			</div>
		</div>
      </div>
   </section>
   <!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
   
   <div id="footer"></div>
</body>

    
</html>