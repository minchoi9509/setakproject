<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page import = "java.util.*" %>
<html>
<head>
<%
 	HttpSession session = request.getSession();
%>
<link rel="shortcut icon" href="#">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="./css/default.css"/>
	<link rel="stylesheet" type="text/css" href="./css/washing.css"/>
</head>

<!-- http://www.webmadang.net/javascript/javascript.do?action=read&boardid=8001&page=14&seq=190 : 테이블 클릭시 색-->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script type="text/javascript">
var num = 0;
var cate = "상의";

$(document).ready(function($) {
	
	
	
	/* 헤더풋터 생성 */
	$("#header").load("./header.jsp")
    $("#footer").load("./footer.jsp")
	
	/* 카테고리선택하면 메뉴리스트 변경함수 */
	$(".tab").on("click", function() {
		$(".tab").removeClass("active");
		$(".menulist").removeClass("show");
		$(this).addClass("active");
		$($(this).attr("href")).addClass("show");
		cate = $(this).text();
	});
	
	var windowWidth = $(window).width();
	if (windowWidth > 769) {
		$('.tab').click(function() {
			$('html, body').animate({
				scrollTop : 300
			}, 500);
			return false;
		});
	} else {
		$('.tab-list a').click(function() {
			event.preventDefault();
		});
		$('.step img').attr("src","images/ms1.png")
	}
	
	/* 메뉴리스트 눌렀을때 가격테이블 생성 */
	$(".downlist").on("click", function() {
		var td = $(this);
		var tdtext = td.text().split('!');
		var str = ""
		num++;
		str += '<tr id="'+num+'">';
		str += '<td align="center"><input type="checkbox" name="chk" value="'+tdtext[0]+'" checked></td>';
		str += '<td align="center"><input type="hidden" value="'+tdtext[0]+'" name = "wash_kind">'+tdtext[0]+'</td>';
		str += '<td align="center"><select class = "howsetak" name="wash_method">';
		str += '<option value="물세탁">물세탁</option>';
		str += '<option value="드라이">드라이(+2000)</option>';
		str += '<option value="삶음">삶음(+1500)</option></td>';
		str += '<td align="center"><input type="number" class="qnum" name="wash_count" min="1" max="1000" value="1"></td>';
		str += '<td value="'+tdtext[2]+'" align="center">'+tdtext[2]+'원</td>';
		str += '<input type="hidden" name="wash_price" value="'+tdtext[2]+'">';
		str += '<input type="hidden" name="wash_cate" value="'+cate+'">';
		$(".pricemenu").after(str);
		
		sumprice();
		
	});
	
	/* 가격 합계 구하는 합수 */
	sumprice = function() {
		var hap = 0;
		var tr = $("#pricetable").children().children();
		var pricearr = new Array();
		
		tr.each(function(i) {
			pricearr.push(tr.eq(i).children().eq(4).text())
		});
		
		for(var i = 1; i<pricearr.length;i++){
			hap += parseInt(pricearr[i]);
		}
		
		$("#sumprice").html(numberFormat(hap));
		$(".wash_tprice").val(hap);	
	}
	
	/* 가격바뀌는 함수 */
	$.pricefun = function(){
		var td = $(this).parent().parent().children();
		console.log(td.eq(4));
		var price = parseInt(td.eq(4).attr('value'));
		var quan = td.eq(3).children().val();
		var tr = $("#pricetable").children().children();
		
		if(td.eq(2).children().val()=="드라이"){
			td.eq(4).html((price+2000)*quan+'원');
			td.eq(5).val((price+2000)*quan);
		}else if(td.eq(2).children().val()=="삶음"){
			td.eq(4).html((price+1500)*quan+'원');
			td.eq(5).val((price+1500)*quan);
		}else{
			td.eq(4).html(price*quan+'원');
			td.eq(5).val(price*quan);
		}
		
		console.log(td.eq(5).val());
		sumprice();
	};
	
	/* 수량바뀔때 가격 바뀌는 함수호출 */
	$(document).on("propertychange change keyup paste",".qnum", $.pricefun);
	
	/* 세탁방법 변경했을때 가격바뀌는 함수호출 */
	$(document).on("change",".howsetak", $.pricefun);
	
	/* 체크박스 전체선택 */
	$("#allcheck").click(function(){
        //클릭되었으면
        if($("#allcheck").prop("checked")){
            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
            $("input[name=chk]").prop("checked",true);
            //클릭이 안되있으면
        }else{
            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
            $("input[name=chk]").prop("checked",false);
        }
    })
	
    /* 체크박스 삭제 */
	$("#checkdel").click(function(){
		var checkbox = $("input[name=chk]:checked");
		checkbox.each(function(){
			var tr = checkbox.parent().parent();
			tr.remove();
		}) 
		
		sumprice();
	});
	
	/* 숫자 3자리마다 쉼표 넣어줌 */
	numberFormat = function(inputNumber) {
		   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
});

function checkform() {
	if($("#pricetable tr").length == "1"){
		Swal.fire("","세탁물을 선택해 주시기 바랍니다.","info");
		return false;		
	}
}


$(document).on('click','#gonext',function(event) {
	var member_id = "<%=session.getAttribute("member_id") %>";
	if(member_id=="null"){
		Swal.fire({
			text: "로그인 후 이용 가능합니다.",
			icon: "info",
		}) .then(function(){
			location.href='login.do';
		});
		return false;
	}
});          

</script>
<body>
	<div id="header"></div>
  
	<div class = content>
		<div class = title-text>
			<h2>세탁 서비스</h2>
		</div>
		
		<div class="setakmain">
			<div class="step"><img src="images/s1.png" alt="step1_세탁"></div>
			<p>※ 본 가격은 물세탁 기준이며, 드라이클리닝 또는 삶음 가격은 세탁물 선택 후 아래창에서 확인 가능합니다.</p>
			
			<!-- 카테고리 테이블 -->
			<div class="tabs">
				<div class="tab-list">
					<a href="#one" class="tab active">상의</a>
					<a href="#two" class="tab">하의</a>
					<a href="#three" class="tab">아우터</a>
					<a href="#four" class="tab">아동</a>
				</div>
				<div class="tab-list" id = "tab-two">
					<a href="#five" class="tab">침구</a>
					<a href="#six" class="tab">리빙</a>
					<a href="#seven" class="tab">신발</a>
					<a href="#eight" class="tab">잡화</a>
				</div>
			</div>
			
			<div>
				<div id="one" class="menulist show">
					<ul class="top">
						<li class ="downlist">셔츠<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>2000</span></li>
						<li class = "downlist">티셔츠<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>2500</span></li>
						<li class = "downlist">블라우스<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>4000</span></li>
						<li class = "downlist">후드티,맨투맨티<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3500</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">니트,스웨터<br><span class= "hidetext">!</span><span>원</span><span class="hidetext">!</span><span>4000</span></li>
						<li class ="downlist">원피스/점프수트<br><span class= "hidetext">!</span><span>원</span><span class="hidetext">!</span><span>5000</span></li>
						<li class ="downlist">원피스(니트,실크,레자)<br><span class= "hidetext">!</span><span>원</span><span class="hidetext">!</span><span>6000</span></li>
						<li class ="downlist">후리스<br><span class= "hidetext">!</span><span>원</span><span class="hidetext">!</span><span>5000</span></li>
					</ul>
				</div>
				<div id="two" class="menulist">
					<ul class="top">
						<li class ="downlist">바지<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3500</span></li>
						<li class = "downlist">바지(니트,레자,패딩)<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>5000</span></li>
						<li class = "downlist">스커트<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3500</span></li>
						<li class = "downlist">스커트(니트,레자,패딩)<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>5000</span></li>
					</ul>
				</div>
				
				<div id="three" class="menulist">
					<ul class="top">
						<li class ="downlist">가디건<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>5000</span></li>
						<li class = "downlist">롱가디건<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>6000</span></li>
						<li class = "downlist">점퍼(야상,청자켓,항공점퍼,집업)<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>5000</span></li>
						<li class = "downlist">자켓<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>6000</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">패딩<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>10000</span></li>
						<li class = "downlist">롱패딩<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>15000</span></li>
						<li class = "downlist">프리미엄패딩<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>20000</span></li>
						<li class = "downlist">코트<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>20000</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">기능성의류(등산용,바람막이)<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>20000</span></li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
				</div>
				
				<div id="four" class="menulist">
					<ul class="top">
						<li class ="downlist">아동 상의<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>2000</span></li>
						<li class = "downlist">아동 바지/치마<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>2500</span></li>
						<li class = "downlist">아동 자켓/점퍼<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3500</span></li>
						<li class = "downlist">아동 코트<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>8000</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">아동 패딩<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>10000</span></li>
						<li class = "downlist">아동 원피스<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>4000</span></li>
						<li class = "downlist">아동 운동화<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>4000</span></li>
						<li class = "downlist">아동 부츠<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>5000</span></li>
					</ul>
				</div>
				
				<div id="five" class="menulist">
					<ul class="top">
						<li class ="downlist">베개,쿠션 커버<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>2000</span></li>
						<li class = "downlist">침대,매트리스,이불커버,홑이불<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>2500</span></li>
						<li class = "downlist">일반 이불<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3500</span></li>
						<li class = "downlist">극세사,일반 토퍼<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>8000</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">구스이불,양모이불<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>10000</span></li>
						<li class = "downlist">실크이불<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>4000</span></li>
						<li></li>
						<li></li>
					</ul>
				</div>
				
				<div id="six" class="menulist">
					<ul class="top">
						<li class ="downlist">발매트<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>4000</span></li>
						<li class = "downlist">원룸커튼<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>15000</span></li>
						<li class = "downlist">일반커튼<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>20000</span></li>
						<li class = "downlist">벨벳커튼<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>25000</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">러그,카펫<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>15000</span></li>
						<li class = "downlist">식탁보<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>10000</span></li>
						<li></li>
						<li></li>
					</ul>
				</div>
				
				<div id="seven" class="menulist">
					<ul class="top">
						<li class ="downlist">운동화,스니커즈<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>5000</span></li>
						<li class = "downlist">캐주얼샌들/슬리퍼<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>4500</span></li>
						<li class = "downlist">구두,로퍼<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>7000</span></li>
						<li class = "downlist">등산화<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>7000</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">부츠화<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>10000</span></li>
						<li class = "downlist">롱부츠<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>15000</span></li>
						<li class = "downlist">가죽부츠(발목)<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>20000</span></li>
						<li class = "downlist">어그부츠<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>25000</span></li>
					</ul>
				</div>
				
				<div id="eight" class="menulist">
					<ul class="top">
						<li class ="downlist">니트모자<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3000</span></li>
						<li class = "downlist">스카프,장갑<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3000</span></li>
						<li class = "downlist">숄<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>6000</span></li>
						<li class = "downlist">넥타이<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>1000</span></li>
					</ul>
					<ul class="top">
						<li class ="downlist">에코백<br><span class= "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>3000</span></li>
						<li class = "downlist">목도리<br><span class = "hidetext">!</span><span>원</span><span class = "hidetext">!</span><span>15000</span></li>
						<li></li>
						<li></li>
					</ul>
				</div>
			</div>
			<form id="pricediv" action="./washmending.do" method="post" onsubmit="return checkform();">
				<table id = "pricetable">
					<tr class= "pricemenu">
						<td><input type="checkbox" id = "allcheck" checked></td>
						<td>세탁물</td>
						<td>세탁방법</td>
						<td>수량</td>
						<td>합계</td>
					</tr>
				</table>
			
			<div class="total"> 
				<p>총 금액 : 세탁비 <span id = "sumprice">0</span>원</p>
				<input type="hidden" name="wash_tprice" value="" class="wash_tprice">
			</div>
			<div class="total-button">
				<input type="submit" value="다음" id = "gonext">
				<input type="button" value="선택삭제" id="checkdel">
			</div>
			</form>
		</div>
	</div>
	
	
	<div id="footer"></div>
</body>
</html>
