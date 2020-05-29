<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.util.*, java.text.*" %>
<%
	Date today = new Date();
	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	
	Calendar start_cal = Calendar.getInstance();
	Calendar end_cal = Calendar.getInstance();
	start_cal.add(Calendar.DATE, 1);
	end_cal.add(Calendar.DATE, 1);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="./css/default.css"/>
	<link rel="stylesheet" type="text/css" href="./css/keep.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#header").load("./header.jsp")
			$("#footer").load("./footer.jsp")
			
			//세탁, 수선, 보관 탭 눌렀을 때
			$(".tab").on("click", function() {
				$(".tab").removeClass("active");
				$(".tab-content").removeClass("show");
				$(this).addClass("active");
				$($(this).attr("href")).addClass("show");
			});
			
			//세탁, 수선, 보관 탭 눌렀을 때 위로 올라가는 제이쿼리
			var windowWidth = $(window).width();
			if (windowWidth > 769) {
				$('.tab-list a').click(function() {
					$('html, body').animate({
						scrollTop : $($.attr(this, 'href')).offset().top - 250
					}, 500);
					return false;
				});
			} else {
				$('.tab-list a').click(function() {
					event.preventDefault();
				});
			}
			
			//옷 종류 눌렀을 때
			var sortation = document.getElementsByClassName('active');
			$(".keep-list").on("click", function() {
				var str = "";
				
				str += '<tr class="keepclick true">';
				str += '<td><input type="checkbox" name="check" value="yes" checked></td>';
				str += '<td>'+$.attr(this, 'value')+'</td>';
				str += '<td style="display:none;"><input type="hidden" name="keep_cate" value="'+sortation[0].innerHTML+'">';
				str += '<input type="hidden" name="keep_kind" value="'+$.attr(this, 'value')+'">';
				str += '<input type="hidden" class="month_value" name="keep_month" value="'+month+'"></td>';
				//keep_box, keep_price는 아래 html코드에 있음.
				str += '<td><input type="text" maxlength="3" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" name="keep_count" value="1" id="" class="count">';
				str += '<div><a class="bt_up">▲</a><a class="bt_down">▼</a></div>';
				str += '</td>';
				str += '</tr>';		
				
				$(".keep_sortation_title").after(str);
			});
			
			//보관기간 선택 시 css효과, 보관기간의 돈 값 가져와서 합계에 보여주기.
			var monthclick = 0;
			var price = parseInt(0);
			var month ="";
			$(".month").on("click", function(){
				$(".month").removeClass("month_click");
				$(this).addClass("month_click");
				month=($(this).html()).substring(4,5);//개월수
				$(".month_value").attr('value', month);
				monthclick = 1;
				price = parseInt($($(this).children().children('.price')).html());
				var n = $('.count').index(this);
				$.pricefun(n);
			});
			
			//수량
			$(document).on('click','.bt_up',function(event) {
				var n = $('.bt_up').index(this);
				var num = $(".count:eq(" + n + ")").val();
				num = $(".count:eq(" + n + ")").val(num * 1 + 1);
			});
			$(document).on('click','.bt_down',function(event) {
				var n = $('.bt_down').index(this);
				var num = $(".count:eq(" + n + ")").val();
				if (num == 1) {
					Swal.fire("","최저 수량은 1개입니다.","info");
				} else {
					num = $(".count:eq(" + n + ")").val(num * 1 - 1);
				}
			});
			
			//박스 수량
			$(document).on('click','.box_up',function(event) {
				if(monthclick==0){
					Swal.fire("","보관하실 기간을 먼저 선택해주세요.","info");
					return;
				}
				var n = $('.box_up').index(this);
				var num = $(".box_count:eq(" + n + ")").val();
				num = $(".box_count:eq(" + n + ")").val(num * 1 + 1);
				
				$.pricefun(n);
			});
			$(document).on('click','.box_down',function(event) {
				var n = $('.bt_down').index(this);
				var num = $(".box_count:eq(" + n + ")").val();
				if (num == 1) {
					Swal.fire("","최저 수량은 1박스입니다.","info");
				} else {
					num = $(".box_count:eq(" + n + ")").val(num * 1 - 1);
				}
				
				$.pricefun(n);
			});

			//수량에 따른 값변경
			$.pricefun = function(n){
				var num = parseInt($(".box_count:eq(" + n + ")").val());
				$('.tot_price').html(numberFormat(num*price));
				$(".keep_price").val(num*price);
			};
			//버튼안누르고 직접 수량 입력했을 때
			$(document).on("propertychange change keyup paste",".box_count", function(){
				var n = $('.box_count').index(this);
				$.pricefun(n);
			});

			//전체선택, 전체선택해제
			$("#allcheck").click(function(){
		        if($("#allcheck").prop("checked")){
		            $("input[name=check]").prop("checked",true);
		        }else{
		            $("input[name=check]").prop("checked",false);
		        }
		    })
		    //선택 삭제
		    $(".chkdelete").click(function(){
				var checkbox = $("input[name=check]:checked");
				checkbox.each(function(){
					var tr = checkbox.parent().parent();
					tr.remove();
				})
			});
			
			/* 숫자 3자리마다 쉼표 넣어줌 */
			numberFormat = function(inputNumber) {
				   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			}
			
			//장바구니 눌렀을 때
			 $(document).on('click','.gocart',function(event) {
				var member_id = "<%=session.getAttribute("member_id") %>";
				if(member_id=="null"){
					Swal.fire({
						text: "로그인 후 이용 가능합니다.",
						icon: "warning",
					}) .then(function(){
						location.href='login.do';
					});
					return false;
				};
	            if(!$(".keepclick").hasClass("true")){
					Swal.fire("","보관하실 의류를 선택하지 않았습니다.","info");
					return false;
				};
				if(monthclick==0){
					Swal.fire("","보관하실 기간을 선택해주세요.","info");
					return false;
				};
			 });
		});
		//한글, 영어 금지
		function onlyNumber(event) {
			event = event || window.event;
			var keyID = (event.which) ? event.which : event.keyCode;
			if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105)
					|| keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
				return;
			else
				return false;
		}
		function removeChar(event) {
			event = event || window.event;
			var keyID = (event.which) ? event.which : event.keyCode;
			if (keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
				return;
			else
				event.target.value = event.target.value.replace(/[^0-9]/g, "");
		}
	</script>
</head>
<body>
	<div id="header"></div>

	<section id="mending">
		<div class="content">
			<div class="title-text">
				<h2>보관 서비스</h2>
			</div>
			<div class="keep">
				<p>※ 보관만 가능한 페이지입니다. 보관할 옷에 세탁 서비스도 이용하실 예정이시면 세탁 페이지를 이용해주세요.</p>
				<div class="tabs">
					<div class="tab-list">
						<a href="#one" id="tab" class="tab active">상의</a>
						<a href="#two" id="tab" class="tab">하의</a>
						<a href="#three" id="tab" class="tab">아우터</a>
						<a href="#four" id="tab" class="tab">아동</a>
					</div>
					<div class="tab-list">
						<a href="#five" id="tab" class="tab">침구</a>
						<a href="#six" id="tab" class="tab">리빙</a>
						<a href="#seven" id="tab" class="tab">신발</a>
						<a href="#eight" id="tab" class="tab">잡화</a>
					</div>
				</div>

				<div id="one" class="tab-content show">
					<ul class="top">
						<li class="keep-list" value="셔츠">셔츠</li>
						<li class="keep-list" value="티셔츠">티셔츠</li>
						<li class="keep-list" value="블라우스">블라우스</li>
						<li class="keep-list" value="후드티,맨투맨티">후드티,맨투맨티</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="니트,스웨터">니트,스웨터</li>
						<li class="keep-list" value="원피스/점프수트">원피스/점프수트</li>
						<li class="keep-list" value="원피스(니트,실크,레자)">원피스(니트,실크,레자)</li>
						<li class="keep-list" value="후리스">후리스</li>
					</ul>
				</div>
				
				<div id="two" class="tab-content">
					<ul class="top">
						<li class="keep-list" value="바지">바지</li>
						<li class="keep-list" value="바지(니트,레자,패딩)">바지(니트,레자,패딩)</li>
						<li class="keep-list" value="스커트">스커트</li>
						<li class="keep-list" value="스커트(니트,레자,패딩)">스커트(니트,레자,패딩)</li>
					</ul>
				</div>
				
				<div id="three" class="tab-content">
					<ul class="top">
						<li class="keep-list" value="가디건">가디건</li>
						<li class="keep-list" value="롱가디건">롱가디건</li>
						<li class="keep-list" value="점퍼(야상,청자켓,항공점퍼,집업)">점퍼(야상,청자켓,항공점퍼,집업)</li>
						<li class="keep-list" value="자켓">자켓</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="패딩">패딩</li>
						<li class="keep-list" value="롱패딩">롱패딩</li>
						<li class="keep-list" value="프리미엄패딩">프리미엄패딩</li>
						<li class="keep-list" value="코트">코트</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="기능성의류(등산용,바람막이)">기능성의류(등산용,바람막이)</li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
				</div>
				
				<div id="four" class="tab-content">
					<ul class="top">
						<li class="keep-list" value="아동">아동</li>
						<li class="keep-list" value="아동 바지/치마">아동 바지/치마</li>
						<li class="keep-list" value="아동 자켓/점퍼">아동 자켓/점퍼</li>
						<li class="keep-list" value="아동 코트">아동 코트</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="아동 패딩">아동 패딩</li>
						<li class="keep-list" value="아동 원피스">아동 원피스</li>
						<li class="keep-list" value="아동 운동화">아동 운동화</li>
						<li class="keep-list" value="아동 부츠">아동 부츠</li>
					</ul>
				</div>
				
				<div id="five" class="tab-content">
					<ul class="top">
						<li class="keep-list" value="베개,쿠션 커버">베개,쿠션 커버</li>
						<li class="keep-list" value="침대,매트리스,이불커버,홑이불">침대,매트리스,이불커버,홑이불</li>
						<li class="keep-list" value="일반 이불">일반 이불</li>
						<li class="keep-list" value="극세사,일반 토퍼">극세사,일반 토퍼</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="구스이불,양모이불">구스이불,양모이불</li>
						<li class="keep-list" value="실크이불">실크이불</li>
						<li></li>
						<li></li>
					</ul>
				</div>
				
				<div id="six" class="tab-content">
					<ul class="top">
						<li class="keep-list" value="발매트">발매트</li>
						<li class="keep-list" value="원룸커튼">원룸커튼</li>
						<li class="keep-list" value="일반커튼">일반커튼</li>
						<li class="keep-list" value="벨벳커튼">벨벳커튼</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="러그,카펫">러그,카펫</li>
						<li class="keep-list" value="식탁보">식탁보</li>
						<li></li>
						<li></li>
					</ul>
				</div>
				
				<div id="seven" class="tab-content">
					<ul class="top">
						<li class="keep-list" value="운동화,스니커즈">운동화,스니커즈</li>
						<li class="keep-list" value="캐주얼샌들/슬리퍼">캐주얼샌들/슬리퍼</li>
						<li class="keep-list" value="구두,로퍼">구두,로퍼</li>
						<li class="keep-list" value="등산화">등산화</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="부츠화">부츠화</li>
						<li class="keep-list" value="롱부츠">롱부츠</li>
						<li class="keep-list" value="가죽부츠(발목)">가죽부츠(발목)</li>
						<li class="keep-list" value="어그부츠">어그부츠</li>
					</ul>
				</div>
				
				<div id="eight" class="tab-content">
					<ul class="top">
						<li class="keep-list" value="니트모자">니트모자</li>
						<li class="keep-list" value="스카프,장갑">스카프,장갑</li>
						<li class="keep-list" value="숄">숄</li>
						<li class="keep-list" value="넥타이">넥타이</li>
					</ul>
					<ul class="top">
						<li class="keep-list" value="에코백">에코백</li>
						<li class="keep-list" value="목도리">목도리</li>
						<li></li>
						<li></li>
					</ul>
				</div>
				<form name="keepform" action="./keep.do" method="post">
					<table class="keep_sortation">
						<tr class="keep_sortation_title">
							<td width="5%"><input type="checkbox" id = "allcheck" checked></td>
							<td style="width:47.5%;">구분</td>
							<td style="width:47.5%;">수량</td>
						</tr>
					</table>
					
					<div class="delete-button">
						<a class="chkdelete" href="javascript:">선택삭제</a>
					</div>
					
					<div class="keep_month">
						<ul>
							<li class="month"><h2>1개월</h2><p><%=date.format(start_cal.getTime()) %> ~ <%end_cal.add(Calendar.MONTH,1);%><%=date.format(end_cal.getTime()) %></p><h1><span class="price">10000</span>원</h1></li>
							<li class="month"><h2>3개월</h2><p><%=date.format(start_cal.getTime()) %> ~ <%end_cal.add(Calendar.MONTH,2);%><%=date.format(end_cal.getTime()) %></p><h1><span class="price">28000</span>원</h1></li>
							<li class="month"><h2>6개월</h2><p><%=date.format(start_cal.getTime()) %> ~ <%end_cal.add(Calendar.MONTH,3);%><%=date.format(end_cal.getTime()) %></p><h1><span class="price">55000</span>원</h1></li>
						</ul>
						<div class="keep_caution">
							<p>※ 규격 안내 : - 월컴키트 안 세탁곰 규격 리빙박스(30L)가 기준입니다.</p>
							<p>- 웰컴키트에 포함된 리빙박스에 세탁물을 담으시면 정확히 몇 박스가 필요하신지 알기 쉽습니다.<br>
								- 세탁곰 리빙박스는 한 박스에 여름 티셔츠 50벌이 들어갑니다.<br>
								- 세탁곰 리빙박스는 한 박스에 겨울 니트류 10~30벌이 들어갑니다.<br>
								- 세탁곰 리빙박스는 한 박스에 외투 15벌이 들어갑니다.<br>
								- 세탁곰 리빙박스는 한 박스에 겨울 코트 10벌이 들어갑니다.
							</p>
							<p>※ 배송은 만료 기준 1회 무료이며, 도중 개별 반환도 가능합니다. 도중 개별 반환 시 배송비가 청구됩니다.</p>
							<p>※ 기간 만료 2주 전 카카오톡 알람 서비스가 제공됩니다. 연장을 원하신다면 마이페이지 > 보관현황에서 연장 신청을 이용해주세요.</p>
							<p>※ 기간이 만료되면 입력하신 주소로 바로 배송됩니다. 배송 완료 후 알람을 드리며 이후 분실에 대해 책임을 지지 않습니다. 보관 중 배송지가 변경된다면 미리 정보를 수정해주세요.</p>
						</div>
					</div>
					
					<div class="box_quantity">
						<p>박스 수량을 선택 해 주세요</p>
						<div>
							<input type="text" maxlength="3" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" name="keep_box" value="1" id="" class="box_count">
							<a class="box_up">+</a>
							<a class="box_down">-</a>
						</div>
					</div>
					
					<div class="total_price">
						<p>보관비 총 금액 : <span class="tot_price">0</span>원</p>
						<p>보관비 총 금액 : <span class="tot_price">0</span>원</p>
						<input style="display:none;" class="keep_price" type="hidden" name="keep_price" value="0">
					</div>
					<div class="total-button">
						<input type="submit" value="장바구니" class="gocart">
					</div>
				</form>
			</div>
		</div>
	</section>
	
	<div id="footer"></div>
</body>
</html>