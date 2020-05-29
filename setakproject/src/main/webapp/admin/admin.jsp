<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<meta charset="UTF-8">

<script>
	$(".admin-side-nav").hide();
	$("li.side-nav > a").click(function(){
	  $(this).parent().addClass('nav-color2');
	  $(this).next().slideToggle(300);
	  $("li.side-nav > a").not(this).next().slideUp(300);
	  $("li.side-nav > a").not(this).parent().removeClass('nav-color2');
	  $("li.side-nav > a").not(this).parent().addClass('nav-color1');
	  return false;
	});
</script>

	<div class="admin">
		<nav>
			<ul class="admin-nav">
				<a href="./">관리자 페이지</a>
				<li><a href="./member.do">회원관리</a></li>
				<li class = "side-nav"><a href="#">세탁수선보관 <span class = "align-right">∨</span></a>
					<ul class = "admin-side-nav">
						<li><a href="./admin_wash.do">세탁관리</a></li>
						<li><a href="./admin_mending.do">수선관리</a></li>
						<li><a href="./admin_keep.do">보관관리</a></li>
					</ul>
				</li>
				<li><a href="./order.do">주문관리</a></li>
				<li><a href="./subscribe.do">정기구독</a></li>
				<li class = "side-nav"><a href="#">차트<span class = "align-right">∨</span></a>
					<ul class = "admin-side-nav">
						<li><a href="./orderChart.do">주문관리</a></li>
						<li><a href="./adminChart.do">세탁수선보관</a></li>
						<li><a href="./subscribeChart.do">정기구독</a></li>					
					</ul>
				</li>
				<li><a href="./admin_mile.do">적립금</a></li>
				<li><a href="./admin_coupon.do">쿠폰</a></li>
				<li><a href="./admin_notice.do">공지사항</a></li>
				<li><a href="./admin_review.do">리뷰</a></li>
				<li><a href="./admin_faq.do">FAQ</a></li>
				<li><a href="./admin_qna.do">Q&amp;A</a></li>
			</ul>
		</nav>