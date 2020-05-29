<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	String name = (String)session.getAttribute("member_name");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="./css/index.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="dist/jquery.sliderPro.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function($) {
			var windowWidth = $(window).width();
			slider = function() {
				if (windowWidth > 767) {
					$('#example1 , #example2, #example3').sliderPro({
						width : 1200,
						height : 630,
						arrows : true,
						buttons : false,
						waitForLayers : true,
						thumbnailsPosition : 'top',
						thumbnailWidth : 200,
						thumbnailHeight :80,
						thumbnailPointer : true,
						autoplay : true,
						autoScaleLayers : false,
						breakpoints : {
							500 : {
								thumbnailWidth : 120,
								thumbnailHeight : 50
							}
						}
					});
				} else{
					$('#example1 , #example2, #example3').sliderPro({
				
						arrows : true,
						buttons : false,
						waitForLayers : true,
						thumbnailsPosition : 'top',
						thumbnailWidth : 200,
						thumbnailHeight :80,
						thumbnailPointer : true,
						autoplay : true,
						autoScaleLayers : false,
						breakpoints : {
							500 : {
								thumbnailWidth : 120,
								thumbnailHeight : 50
							}
						}
					});
				}
			}
			slider();

			$(".tab").on("click", function() {
				$(".tab").removeClass("active");
				$(".tab-content").removeClass("show");
				$(this).addClass("active");
				$($(this).attr("href")).addClass("show");
				slider();
			});
			$("nav_open div a").on("click", function(){
				$("nav_open div a").removeClass("click");
				$(this).addClass("click");
			})
		});
	</script>
</head>
<body>
	<div id="container">
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
		<div class="mobile_text">
			<h1>Wash</h1>
			<h1>Life</h1>
			<h1>Balance</h1>
		</div>
		<nav>
			<div class="content">

				<div>
					<ul class="logo">
						<li><a href="./" class ="logo_a"><img src="images/logo.png" alt="로고"></a></li>
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
				<div>
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
		<header>
		</header>
		<section id="use-area">
			<div class="content">
				<h1>세탁곰 이용방법</h1>
				<div class="tabs">
					<div class="tab-list">
						<a href="#one" class="tab active">세탁</a>
						<a href="#two" class="tab">수선</a>
						<a href="#three" class="tab">보관</a>
					</div>

					<div id="one" class="tab-content show">
						<div id="example1" class="slider-pro">
							<div class="sp-thumbnails">
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">1. 로그인</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">2. 세탁물 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">3. 방법, 수량 입력</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">4. 수선 카테고리선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">5. 수선 치수 입력</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">6. 수선 수량, 택 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">7. 보관 기간 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">8. 보관 박스 수량 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">9. 장바구니</div>
								</div>							
							</div>
							<div class="sp-slides">
								<div class="sp-slide">
									<img class="sp-image" src="images/login.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/wash1.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/wash2.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/wash3.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/wash4.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/wash5.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/wash6.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/wash7.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/cart.jpg" />
								</div>
								
							</div>
						</div>
					</div>
					<div id="two" class="tab-content">
						<div id="example2" class="slider-pro">
							<div class="sp-thumbnails">
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">1. 로그인</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">2. 카테고리 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">3. 치수 밑 데이터 입력</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">4. 수량, 택 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">5. 장바구니</div>
								</div>
							</div>
							<div class="sp-slides">
								<div class="sp-slide">
									<img class="sp-image" src="images/login.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/mending1.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/mending2.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/mending3.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/m_cart.jpg" />
								</div>
							</div>
						</div>
					</div>
					<div id="three" class="tab-content">
						<div id="example3" class="slider-pro">
							<div class="sp-thumbnails">
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">1. 로그인</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">2. 카테고리 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">3. 옷 수량, 기간 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">4. 박스 수량 선택</div>
								</div>
								<div class="sp-thumbnail">
									<div class="sp-thumbnail-title">5. 장바구니</div>
								</div>
							</div>
							<div class="sp-slides">
								<div class="sp-slide">
									<img class="sp-image" src="images/login.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/keep1.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/keep2.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/keep3.jpg" />
								</div>
								<div class="sp-slide">
									<img class="sp-image" src="images/k_cart.jpg" />
								</div>								
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
		<section id="about-area">
			<div class="content">
			 	<ul>
					<li>
						<h3>세탁</h3>
						<h4>wish your better life</h4>
						<p>세탁곰은 여러분의 하루가 편하고 깨끗해져 삶이 풍요로워 지길 바랍니다. 항상 새 옷을 입는 듯한 상쾌함과 디테일한 세탁 서비스를 제공해 드리고 있으며, 고객님의 더 나은 삶과 만족을 위해 오늘도 연구하고 있습니다.</p>
					</li>
					<li>
						<h3>수선</h3>
						<h4>design your life</h4>
						<p>세탁곰은 한 땀 한 땀 핏을 살려주는 전문 수선사들의 감각적인 디자인을 통해 옷의 가치는 그대로, 퀄리티는 한층 더 업그레이드해 드립니다. 고객님의 옷에 '날개'를 달아보세요.</p>
					</li>
					<li>
						<h3>보관</h3>
						<h4>save your time</h4>
						<p>세탁곰의 보관 서비스는 의류보관에 최적화된 환경과 차별화된 시스템을 보유하고 있습니다. 한쪽 구석에 쌓아두었던 소중한 옷들 저희 세탁곰이 안전하게 보관하겠습니다. 고객님의 공간에 여유를 가져보세요.</p>
					</li>
				</ul>
			</div>
		</section>
		<div id="go-top">TOP</div>
		<footer>
			<div class="content">
				<ul>
					<li>㈜세탁곰컴퍼니</li>
					<li><a href="https://www.youtube.com/channel/UChTTbqy5Wd_GPaGCZLJcpFA/" target="_blank"><i class="fab fa-youtube"></i></a><a href="https://www.instagram.com/laundrybear138/?hl=ko" target="_blank"><i class="fab fa-instagram"></i></a><a href="https://twitter.com/laundrybear138"><i class="fab fa-twitter"></i></a></li>			
				</ul>
				<hr>
				<p>대표 : 세탁곰 | 주소 : 서울 서초구 강남대로 459</p>
				<p>사업자 등록번호 : 123-12-123456 | 통신판매업신고 : 제1234-서울 강남-1234호</p>
				<p>고객센터 : 1234-1234 평일 오전 9시 ~ 오후 9시, 주말/공휴일 오전 9시~ 오후 6시 영업시간 외 카톡채팅만 가능합니다. | 카카오톡 @세탁곰</p>
			</div>
		</footer>
	</div>
	<script>
		$(function() {
			var windowWidth = $(window).width();
			if (windowWidth > 769) {
				
				//스크롤에따라 네비게이션 보이고 안보이고 
				$(window).scroll(function() {
					if ($(window).scrollTop() >= $("#use-area").position().top) {
						$("nav").css('display', 'none');
					}
					if ($(window).scrollTop() <= $("#use-area").position().top) {
						$("nav").css('display', 'block');
					}
				});
				
				//커뮤니티 메뉴 hover시.
				$(".sub-nav > li:last-child").hover(function () {
		            $(".sub-nav-sub").css('display', 'block');
		        },
		        function() {
		            $(".sub-nav-sub").css('display', 'none');
		        });

				//화면 너비 769초과일 때 세탁,수선,보관 탭 누르면 탭 위로 위치 자동으로 가게 해줌.
				$('a').click(function() {
					$('html, body').animate({
						scrollTop : $($.attr(this, 'href')).offset().top - 150
					}, 500);
					return false;
				});
			
				//스크롤 한칸이라도 내리면 오른쪽 아래 top 버튼 생성
				$(window).scroll(function() {
					if ($(window).scrollTop() > 10) {
						$("#go-top").fadeIn(100)
					} else {
						$("#go-top").fadeOut(100);
					}
				});
				
				//top버튼 누르면 맨 위로 올라가게.
				$("#go-top").on("click", function() {
					$("html, body").animate({
						scrollTop : 0
					}, 500);
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
					$(".mobile_text").css("display","none");
				});
				
				//마이페이지아이콘 컬러 입히기 홈 컬러 없애기
				$(".ick").on("click", function() {
					$(this).addClass("ick_color");
					$('.click').removeClass("click");
				});
				
				//커뮤니티 눌렀을 때
				$(".sub-nav > li:last-child > a").click(function () {
					event.preventDefault();
					$(".sub-nav-sub").toggle(300);
				});
				
				$('.tab-list a').click(function() {
					event.preventDefault();
				});
				
			}
		});
	</script>
	<div id="frogue-container" class="position-right-bottom"
      data-chatbot="f5f4d84c-cc74-490c-96b2-6b2994010204"
      data-user="setakgom"
      data-init-key="value"
      ></div>
	<script>
	(function(d, s, id){
	    var js, fjs = d.getElementsByTagName(s)[0];
	    if (d.getElementById(id)) {return;}
	    js = d.createElement(s); js.id = id;
	    js.src = "https:\/\/danbee.ai/js/plugins/frogue-embed/frogue-embed.min.js";
	    fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'frogue-embed')); 
	</script>
</body>
</html>
