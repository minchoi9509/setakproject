<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String name = (String)session.getAttribute("member_name");
%>
<meta charset="UTF-8">
<div id="container">
	<header>
		<div class="nav_open">
			<div>
				<a href="./" class="click"><i class="fas fa-home"></i></a>
				<a><i class="fas fa-bars"></i></a>
				<%
					if(session.getAttribute("member_id")==null){
				%>
				<a href="./login.do"><i class="fas fa-shopping-cart"></i></a><!-- 로그인 안했으면 장바구니눌러도 로그인 -->
				<a href="./login.do"><i class="fas fa-user"></i></a>
				<%
					} else {
				%>
				<a href="./order.do"><i class="fas fa-shopping-cart"></i></a><!-- 로그인 했으면 장바구니로-->
				<a><i class="fas fa-user ick"></i></a><!-- 로그인 했으면 마이페이지 보임 -->
				<%
					}
				%>
			</div>
		</div>
		<div class="nav_close"><i class="fas fa-times"></i></div>
		
		<nav>
			<div class="content">
				<ul class="logo">
					<li><a href="./" class ="logo_a"><img src="images/logo.png" alt="로고"></a></li>
				</ul>
				<ul class="logo2">
					<li><a href="./" class ="logo_a"><img src="images/logo2.png" alt="로고"></a></li>
				</ul>
				<ul class="main-nav">

				<%
					if(session.getAttribute("member_id")==null){
				%>
					<li><a href="./login.do">로그인</a></li>
					<li><a href="./join.do">회원가입</a></li>
				<%						
					} else {
				%>
					
					<li><a href="./logout.do">로그아웃</a></li>
					<li><a href="./orderview.do">마이페이지</a></li>
					<li><a href="./order.do">장바구니</a></li>
				<%} %>

				</ul>
			</div>
			<div class="content">
				<ul class="sub-nav">
					<li><a href="./history.do">회사소개</a></li>
					<li><a href="./subscribe.do">정기구독</a></li>
					<li><a href="./setak.do">세탁서비스</a></li>
					<li><a href="./mendingform.do">수선서비스</a></li>
					<li><a href="./keepform.do">보관서비스</a></li>
					<li><a href="./noticeList.do">커뮤니티</a>
						<div>
							<ul class="sub-nav-sub">
								<li><a href="./noticeList.do">공지사항</a></li>
								<li><a href="./review.do">리뷰</a></li>
								<li><a href="./faqList.do">FAQ</a></li>
								<li><a href="./qnaList.do">Q&amp;A</a></li>
							</ul>
						</div>
					</li>
				</ul>
			</div>
		</nav>
		<div class="m_mypage">
			<div class="m_mypage_title">
				<img src="images/logo2.png" alt="로고">
				<h3>마이페이지</h3>
			</div>
			<div class="m_mypage_nav">
				<ul>
					<li><%=name %>님 환영합니다.</li>
					<li><i class="far fa-edit"></i><a href="profile1.do">정보수정</a></li>
				</ul>
			</div>
			<div class="m_mypage_nav2">
				<ul>
					<li><a href="orderview.do">주문/배송현황</a><span>&gt;</span></li>
					<li><a href="mykeep.do">보관현황</a><span>&gt;</span></li>
					<li><a href="mysub.do">나의 정기구독</a><span>&gt;</span></li>
					<li><a href="myqna.do">Q&amp;A 문의내역</a><span>&gt;</span></li>
					<li><a href="mycoupon.do">쿠폰조회</a><span>&gt;</span></li>
					<li><a href="mysavings.do">적립금 조회</a><span>&gt;</span></li>
					<li><a href="withdraw.do">회원탈퇴</a><span>&gt;</span></li>
				</ul>
				<ul>
					<li><a href="./logout.do">로그아웃</a><span>&gt;</span></li>
				</ul>
			</div>
		</div>
	</header>
	<div class="header_space">
	</div>
	<script type="text/javascript" src="js/sweet.js"></script>
	<script>
		$(function(){
			var windowWidth = $(window).width();
			if (windowWidth > 769) {
				$(window).scroll(function() {
					if ($(window).scrollTop() > 10) {
						$("nav").addClass("shrink");
						$(".logo li img").css('display', 'none');
						$(".logo2 li img").css('display', 'block');
					} else {
						$("nav").removeClass("shrink");
						$(".logo li img").css('display', 'block');
						$(".logo2 li img").css('display', 'none');
					}
				});
				$(".sub-nav > li:last-child").hover(function () {
		            $(".sub-nav-sub").css('display', 'block');
		        },
		        function() {
		            $(".sub-nav-sub").css('display', 'none');
		        });
			} else{
				//nav 보이게, 안보이게. 
				$('.nav_open div a:nth-child(2)').click(function(){//햄버거 버튼 눌렀을 때
					$("nav").fadeIn(300);
					$(".nav_close").fadeIn(300);
					$(".nav_open").fadeOut(300);
				});
				$('.nav_close').click(function(){
					$("nav").fadeOut(300);
					$(".nav_close").fadeOut(300);
					$(".nav_open").fadeIn(300);
				});
				$('.nav_open div a:last-child').click(function(){//사람 버튼 눌렀을 때
					$(".m_mypage").fadeIn(300);
				});
				
				//마이페이지아이콘 컬러 입히기
				$(".ick").on("click", function() {
					$(".fa-shopping-cart").removeClass("ick_color");
					$(this).addClass("ick_color");
				});
				//커뮤니티 눌렀을 때
				$(".sub-nav > li:last-child > a").click(function () {
					event.preventDefault();
					$(".sub-nav-sub").toggle(300);
				});
			}
		});
	</script>