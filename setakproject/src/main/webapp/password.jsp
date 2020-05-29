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
   <link rel="stylesheet" type="text/css" href="./css/password.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
   <link rel="shortcut icon" href="favicon.ico">

   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script type="text/javascript">
      $(document).ready(function(){
         $("#header").load("header.jsp")
         $("#footer").load("footer.jsp")     
         var sessionID = "<%=session.getAttribute("member_id") %>"
         /*비밀번호 일치하면 개인정보 수정 페이지로 이동 */    
         $('.btn').on('click', function(event){ 
        	 
  			var params = {	'member_id': sessionID,
  							'member_password':$("#member_password").val() 
  						};
 			$.ajax({
 	            url : '/setak/chk_pw.do', // url
 	            type:'post',
 	            data : params,
 	            dataType:'json', 
 	            contentType : 'application/x-www-form-urlencoded;charset=utf-8',
 	            success: function(result) {
 	               if(result.res=="OK") {
 	            	   $(location.href="/setak/profile2.do");
 	               }
 	               else { // 실패했다면
 	            	  Swal.fire("","비밀번호가 다릅니다.","info");
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
				<h2>개인정보수정</h2>
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
			
			<div class="pw_text"> <!-- class 변경해서 사용하세요. -->
					<h1>개인정보수정</h1>
					<%
						String str=(String)session.getAttribute("member_id");
						String last = str.substring(str.length() - 1);
						if(last.equals("K")){
					%>
					<h3>카카오 계정으로 로그인 하셨습니다</h3>
					<%} else if(last.equals("N")) {%>
					<h3>네이버 계정으로 로그인 하셨습니다</h3>
					<%} else if(last.equals("G")) {%>
					<h3>구글 계정으로 로그인 하셨습니다</h3>     
					<% } else { %>
					<h3>Login ID : <%=session.getAttribute("member_id") %></h3>
					<%} %>
					<h2>회원님의 개인정보를 안전하게 보호하기 위해<br>
						비밀번호를 작성해 주세요</h2>
					<input class="pw" type="password" name="member_password" id="member_password" placeholder="비밀번호를 입력해주세요" /><br>
					<input class="btn" type="button" name="submit" value="확인"/>
					<h4>세탁곰은 회원님의 개인정보를 신중히 취급하며, 회원님의 동의 없이는 기재하신 회원정보가 공개되지 않습니다.<br>
					보다 다양한 서비스를 받으시려면 정확한 정보를 항상 유지해 주셔야 합니다.</h4>
			</div>
		</div>
	</section>
	<!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
   
   <div id="footer"></div>
</body>
</html>