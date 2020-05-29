<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "com.spring.setak.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.*" %>
<!DOCTYPE html>
<%
	ArrayList<WashingVO> wlist = (ArrayList<WashingVO>)request.getAttribute("wlist");
	ArrayList<MendingVO> mlist = (ArrayList<MendingVO>)request.getAttribute("mlist");
	String wash_tprice = request.getParameter("wash_tprice");
	String mending_tprice = request.getParameter("mending_tprice");
	String member_id = null;

	if(session.getAttribute("member_id")== null){
		out.println("<script>");
		out.println("alert('로그인 후 이용 가능합니다.')");
		out.println("location.href='login.do'");
		out.println("</script>");
	}
	
	Date today = new Date();
	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd");
	
	Calendar start_cal = Calendar.getInstance();
	Calendar end_cal = Calendar.getInstance();
	start_cal.add(Calendar.DATE, 1);
	end_cal.add(Calendar.DATE, 1);
%>
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
			
			//모바일에서 step 이미지 변경
			var windowWidth = $(window).width();
			if (windowWidth < 769) {
				$('.step img').attr("src","images/ms3.png")
			}
			
			//보관기간 선택 시 css효과, 보관기간의 돈 값 가져와서 합계에 보여주기.
			var monthclick = 0;
			var price = parseInt(0);
			var month ="";
			$(".month").on("click", function(){
				$(".month").removeClass("month_click");
				$(this).addClass("month_click");
				month=($(this).html()).substring(4,5);//개월수
				if(month=="아"){
					month=0;
				}
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
					Swal.fire("",'보관하실 기간을 먼저 선택해주세요.',"info");
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
				$('.ktot_price').html(numberFormat(num*price));
				$('.tot_price').html(numberFormat(num*price+(parseInt(<%=wash_tprice%>))+(parseInt(<%=mending_tprice%>))));
				$(".keep_price").val(num*price);
			};
			//버튼안누르고 직접 수량 입력했을 때
			$(document).on("propertychange change keyup paste",".box_count", function(){
				var n = $('.box_count').index(this);
				$.pricefun(n);
			});
			
			/* 숫자 3자리마다 쉼표 넣어줌 */
			numberFormat = function(inputNumber) {
				   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			}
			$(".wtot_price").html(numberFormat(parseInt(<%=wash_tprice%>)));
			$(".mtot_price").html(numberFormat(parseInt(<%=mending_tprice%>)));
			$('.tot_price').html(numberFormat((parseInt(<%=wash_tprice%>))+(parseInt(<%=mending_tprice%>))));

			//다음 눌렀을 때. member_id 체크는 자동로그아웃 됐을 경우를 생각해서 넣음.
			$(document).on('click','.gocart',function(event) {
				var member_id = "<%=session.getAttribute("member_id") %>";
				if(member_id=="null"){
					Swal.fire("",'로그인 후 이용 가능합니다.',"info");
					location.href='login.do';
					return false;
				}
				if(monthclick==0){
					Swal.fire("",'보관하실 기간을 선택해주세요.',"info");
					return false;
				}
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
				<h2>세탁 서비스</h2>
			</div>
			<div class="keep">
				<div class="step"><img src="images/s3.png" alt="step3_보관"></div>
				<p>※ 세탁 신청이 들어간 세탁물에 대해서만 보관이 가능한 페이지입니다. 보관만 맡기실 옷들은 보관서비스 페이지를 이용해주세요.</p>
				<form name="washingKeepform" action="./washingKeep.do" method="post" enctype="multipart/form-data">					
					<div class="keep_month">
						<ul class="s_keep">
							<li class="month"><h2>1개월</h2><p><%=date.format(start_cal.getTime()) %> ~ <%end_cal.add(Calendar.MONTH,1);%><%=date.format(end_cal.getTime()) %></p><h5>10000원</h5><h1><span class="price">9500</span>원</h1><img src="images/sale.png" alt="세일"></li>
							<li class="month"><h2>3개월</h2><p><%=date.format(start_cal.getTime()) %> ~ <%end_cal.add(Calendar.MONTH,2);%><%=date.format(end_cal.getTime()) %></p><h5>28000원</h5><h1><span class="price">27500</span>원</h1><img src="images/sale.png" alt="세일"></li>
							<li class="month"><h2>6개월</h2><p><%=date.format(start_cal.getTime()) %> ~ <%end_cal.add(Calendar.MONTH,3);%><%=date.format(end_cal.getTime()) %></p><h5>55000원</h5><h1><span class="price">54500</span>원</h1><img src="images/sale.png" alt="세일"></li>
							<li class="month"><h2>아니오</h2><h1><span class="price" style="display:none;">0</span></h1></li>
						</ul>
						<div class="keep_caution">
							<p>※ 규격 안내 : - 월컴키트 안 세탁곰 규격 리빙박스(30L)가 기준입니다.</p>
							<p>- 웰컴키트에 포함된 리빙박스에 세탁물을 담으시면 정확히 몇 박스가 필요하신지 알기 쉽습니다.<br>
								- 세탁곰 리빙박스는 한 박스에 여름 티셔츠 50벌이 들어갑니다.<br>
								- 세탁곰 리빙박스는 한 박스에 겨울 니트류 10~30벌이 들어갑니다.<br>
								- 세탁곰 리빙박스는 한 박스에 외투 15벌이 들어갑니다.<br>
								- 세탁곰 리빙박스는 한 박스에 겨울 코트 10벌이 들어갑니다.
							</p>
							<p>※ 배송은 만료 기준 1회 무료이며, 도중 개별 반환도 가능합니다.  도중 개별 반환 시 배송비가 청구됩니다.</p>
							<p>※ 기간 만료 2주 전 카카오톡 알람 서비스가 제공됩니다. 연장을 원하신다면 마이페이지 > 보관현황에서 연장 신청을 이용해주세요.</p>
							<p>※ 기간이 만료되면 입력하신 주소로 바로 배송됩니다. 배송 완료 후 알람을 드리며 이후 분실에 대해 책임을 지지 않습니다. 보관 중 배송지가 변경된다면 미리 정보를 수정해주세요.</p>
						</div>
					</div>
					<!-- 세탁 -->
					<%
						for (int i = 0; i < wlist.size(); i++) {
					%>
					<input type= "hidden" name="wash_cate" value="<%=wlist.get(i).getWash_cate()%>">
					<input type= "hidden" name="wash_kind" value="<%=wlist.get(i).getWash_kind()%>">
					<input type= "hidden" name="wash_method" value="<%=wlist.get(i).getWash_method()%>">
					<input type= "hidden" name="wash_count" value="<%=wlist.get(i).getWash_count()%>">
					<input type= "hidden" name="wash_price" value="<%=wlist.get(i).getWash_price()%>">
					<%
						}
					%>
					<!-- 수선 -->
					<%
					if(mlist!=null){
						for (int i = 0; i < mlist.size(); i++) {
					%>
					<input type= "hidden" name="repair_cate" value="<%=mlist.get(i).getRepair_cate()%>">
					<input type= "hidden" name="repair_kind" value="<%=mlist.get(i).getRepair_kind()%>">
					<input type= "hidden" name="repair_var1" value="<%=mlist.get(i).getRepair_var1()%>">
					<input type= "hidden" name="repair_var2" value="<%=mlist.get(i).getRepair_var2()%>">
					<input type= "hidden" name="repair_var3" value="<%=mlist.get(i).getRepair_var3()%>">
					<input type= "hidden" name="repair_content" value="<%=mlist.get(i).getRepair_content()%>">
					<input type= "hidden" name="repair_code" value="<%=mlist.get(i).getRepair_code()%>">
					<input type= "hidden" name="repair_count" value="<%=mlist.get(i).getRepair_count()%>">
					<input type= "hidden" name="repair_price" value="<%=mlist.get(i).getRepair_price()%>">
					<input type= "hidden" name="repair_file" value="<%=mlist.get(i).getRepair_file()%>">
					<input type= "hidden" name="repair_wash" value="<%=mlist.get(i).getRepair_wash()%>">
					<%
						}
					}
					%>
					<!-- 보관 -->
					<div class="keep_list">
						<p>보관하시게 될 품목</p>
					<%
						for(int i= 0; i <wlist.size(); i++){
					%>
						<p><%=wlist.get(i).getWash_kind()%>(<%=wlist.get(i).getWash_count()%>)</p>
						<input type= "hidden" name="keep_cate" value="<%=wlist.get(i).getWash_cate()%>">
						<input type= "hidden" name="keep_kind" value="<%=wlist.get(i).getWash_kind()%>">
						<input type= "hidden" name="keep_count" value="<%=wlist.get(i).getWash_count()%>">
						<input type= "hidden" name="keep_month" class="month_value" value="0">
					<%
						}
					%>
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
						<p>세탁비 <span class="wtot_price">0</span>원 + 수선비 <span class="mtot_price">0</span>원 + 보관비 <span class="ktot_price">0</span>원 = 합계 : <span class="tot_price">0</span>원</p>
						<p>보관비 : <span class="ktot_price">0</span>원</p>
						<input style="display:none;" class="keep_price" type="hidden" name="keep_price" value="0">
					</div>
					<div class="total-button">
						<a><input type="submit" value="다음" class="gocart"></a>
						<a><input type="button" value="이전" onclick="history.back(); return false;"></a>
					</div>
				</form>
			</div>
		</div>
	</section>
	
	<div id="footer"></div>
</body>
</html>