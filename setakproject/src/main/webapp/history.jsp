<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="./css/default.css"/>
	<link rel="stylesheet" type="text/css" href="./css/history.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#header").load("./header.jsp")
			$("#footer").load("./footer.jsp")
			
			var windowWidth = $(window).width();
			if (windowWidth > 769) {
				$(".history-left:nth-child(3), .history-right:nth-child(4), .history-left:nth-child(5), .history-right:nth-child(6)").fadeIn(1000);
				$(window).scroll(function () {
					if( $(window).scrollTop() > 50	 ) {
					    $(".history-left:nth-child(7)").fadeIn(1000)
					}
					if( $(window).scrollTop() > 150 ) {
					    $(".history-right:nth-child(8)").fadeIn(1000)
					}
					if( $(window).scrollTop() > 250 ) {
					    $(".history-left:nth-child(9)").fadeIn(1000)
					}
					if( $(window).scrollTop() > 350 ) {
					    $(".history-right:nth-child(10)").fadeIn(1000)
					}
					if( $(window).scrollTop() > 450 ) {
					    $(".history-left:nth-child(11)").fadeIn(1000)
					}
					if( $(window).scrollTop() > 650 ) {
					    $(".history-right:nth-child(12)").fadeIn(1000)
					}
					if( $(window).scrollTop() > 660 ) {
					    $(".history_people li").fadeIn(1000)
					}
				});
			}
		});
	</script>
</head>
<body>
	<div id="header"></div>

	<section id="history">
		<div class="content">
			<div class="title-text">
				<h2>회사소개</h2>
			</div>
			<div class="history">
				<p>세탁곰은 2019년부터 개발된 세탁 서비스 사이트로서 기존 세탁 서비스 사이트와는 다른 수선과 보관까지 가능한 신개념 세탁 서비스를 제공합니다.</p>
				<img src="images/history.png" alt="스케줄 이미지">
			</div>
			<div class="history-left">
				<h2>19.12.13 ~ 19.12.20</h2>
				<p>주제 선정</p>
			</div>
			<div class="history-right">
				<h2>19.12.21 ~ 19.12.23</h2>
				<p>메뉴 및 마스코트 선정</p>
			</div>
			<div class="history-left">
				<h2>19.12.24 ~ 20.01.02</h2>
				<p>UI 시안 설계</p>
				<p>DB 설계</p>
			</div>
			<div class="history-right">
				<h2>20.01.03 ~ 20.01.15</h2>
				<p>Front UI작업</p>
			</div>
			<div class="history-left">
				<h2>20.01.16 ~ 20.02.09</h2>
				<p>Front 기능작업</p>
			</div>
			<div class="history-right">
				<h2>20.02.10 ~ 02.02.16</h2>
				<p>관리자 UI 및 기능 작업</p>
			</div>
			<div class="history-left">
				<h2>20.02.17 ~ 20.02.20</h2>
				<p>반응형 웹페이지 작업</p>
			</div>
			<div class="history-right">
				<h2>20.02.21 ~ 20.02.26</h2>
				<p>프레젠테이션 준비</p>
			</div>
			<div class="history-left">
				<h2>20.02.27</h2>
				<p>최종 발표</p>
			</div>
		</div>
		<div class="content">
			<ul class="history_people">
 				<li><img src="images/mem1.png" alt="규환">
 					<p>조규환</p>
 					<p>- UI설계</p>
 					<p>- 커뮤니티</p>
 					<p>- [관리자]공지사항, FAQ, Q&amp;A, 리뷰</p>
 				</li>
				<li>
					<img src="images/mem2.png" alt="주희">
					<p>이주희</p>
					<p>- UI설계</p>
					<p>- 로그인, 회원가입</p>
					<p>- 마이페이지
					<p>- [관리자]차트, 회원관리</p>
				</li>
				<li>
					<img src="images/mem3.png" alt="승환">
					<p>정승환</p>
					<p>- 조장</p>
					<p>- 팀원 총괄</p>
					<p>- DB설계</p>
					<p>- 세탁, 챗봇, SMS, 네이버 스토리지</p>
				</li>
				<li>
					<img src="images/mem4.png" alt="솔민">
					<p>김솔민</p>
					<p>- 디자인 총괄</p>
					<p>- UI설계</p>
					<p>- 메인, 회사연혁, 수선, 보관</p>
					<p>- [관리자]세탁, 수선, 보관관리</p>
				</li>
				<li>
					<img src="images/mem5.png" alt="민경">
					<p>최민경</p>
					<p>- DB설계</p>
					<p>- 정기구독, 주문결제</p>
					<p>- [관리자]메인, 차트, 주문, 정기구독관리</p>
				</li>
				<li>
					<img src="images/mem6.png" alt="기응">
					<p>손기응</p>
					<p>- DB설계</p>
					<p>- 마이페이지</p>
					<p>- [관리자]쿠폰, 적립금 관리</p>
				</li>
 			</ul>
		</div>
	</section>
	
	<div id="footer"></div>
</body>
</html>