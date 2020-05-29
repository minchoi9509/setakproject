<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
   <title>세탁곰</title>
   <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
   <link rel="stylesheet" type="text/css" href="./css/default.css"/>
   <link rel="stylesheet" type="text/css" href="./css/withdrawform.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
   <link rel="shortcut icon" href="favicon.ico">
   
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script type="text/javascript">
      $(document).ready(function(){
         $("#header").load("header.jsp")
         $("#footer").load("footer.jsp")   
         var sessionID = "<%=session.getAttribute("member_id") %>";
         
         /*탈퇴신청 버튼 클릭*/
         $(".btn").click(function(event){
	       	  $(".back").css('display', 'block');
        	 $(".alert_withdraw").css('display', 'block'); 
         });
         
         $(".close").click(function(event){
        	  $(".alert_withdraw").css('display', 'none');
        	  $(".back").css('display', 'none');
        	  
        	  $.ajax({
      		 	url : '/setak/request-withdraw.do', 
      		 	type:'post',
      		 	data : {	'member_id': "<%=session.getAttribute("member_id") %>",
      		 				'member_memo':'탈퇴 신청' },
      		 	dataType:'json', 
     			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
      		 	
     			success: function(result) {
          			if(result.res=="OK") {
          			} else { 
          				// 실패했다면
          			}
       			},
       			error:function() {
          			alert("insert ajax 통신 실패");
       			}			
  			});
        	  
          });
         
     });
    </script>
</head>
<body>
   <div id="header"></div>
   
    <!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
	<section id="title"> <!-- 변경하시면 안됩니다. -->
		<div class="content">
			<!-- 변경하시면 안됩니다. -->
			<div class="title-text">
				<!-- 변경하시면 안됩니다. -->
				<h2>회원탈퇴</h2>
			</div>
		</div>
	</section>
	
	<section id="test">	<!-- id 변경해서 사용하세요. -->
		<div class="content">	<!-- class 변경해서 사용하세요. -->
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
			
			<div class="withdraw">
					<h3>회원탈퇴 안내<span>(탈퇴신청에 앞서 아래의 사항을 반드시 확인하시기 바랍니다)</span></h3>
					<hr>
					<h4>1. 탈퇴 후 고객님의 정보는 전자상거래 소비자보호법에 의거한<span> 세탁곰 개인정보보호정책(1조 4항 개인정보의 보유 및 이용기간)</span> 에 따라 관리됩니다.</h4>
					<h4>2. 탈퇴 시 보유하고 있는<span> 적립금과 쿠폰은 모두 삭제 </span>됩니다.</h4>
					<h4>3. 배송/반품/A.S/교환/송금예정/서비스 문의 등 거래관련 및 상담이 진행중인 경우</h4>
						<h4>     회원탈퇴가 불가하니  해당 사항이 있으신 경우는 내역을<span> 종료하신 후 탈퇴 </span>신청 하시기 바랍니다.</h4>
					<h4>4. 회원탈퇴 후 <span>재가입 시에는 신규가입으로 처리</span>되며, 탈퇴하신 ID는 다시 사용하실 수 없습니다.</h4>
					<h5>회원탈퇴 안내를 모두 확인하였으며 탈퇴에 동의합니다.</h5>
					<input type="button" class="btn" value="탈퇴신청" />
				</div>
		</div>
	</section>
	
	<!--탈퇴신청 팝업 -->
	<div class="alert_withdraw">
		<div class="back"></div>
		<div class="content">
			<h3>탈퇴신청되었습니다.</h3>
			<h3>탈퇴는 심사 후 처리됩니다.</h3>
			<h3>그동안 세탁곰을 이용해 주셔서 감사합니다.</h3>
			<button type="button" class="close">확인</button>
		</div>
	</div>
	<!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
   
   <div id="footer"></div>
</body>
</html>