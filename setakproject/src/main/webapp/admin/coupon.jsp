<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import = "com.spring.member.CouponVO" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰 관리자페이지</title>
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	<link rel="stylesheet" type="text/css" href="../css/admin_coupon.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
	<link rel="shortcut icon" href="favicon.ico">
   
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	
	<!-- datepicker -->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	
	<script type="text/javascript">
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#admin").load("./admin.jsp")
			
			
			//목록 띄우기
			function selectData(){
				
				$.ajax({
					url : '/setak/admin/coupon.do',
					type : 'POST',
					dataType : 'json',
					contentType : 'application/x-www-form-urlencoded; charset=utf-8',
					success:function(data){
						$.each(data, function(index, item){
							var str = '';
							
							str += '<ul>'
							str += '<li class="listtd"><input type="checkbox" name="chk"></li>';
							str += '<li class="listtd"><input type="button" class="member_id" value="' + item.member_id +'"></li>';
							str += '<li class="listtd"><input type="text" class="coupon_irum" name="coupon_name" value="' + item.coupon_name + '" disabled></li>';
							str += '<li class="listtd">' + item.coupon_start + '</li>';
							str += '<li class="listtd"><input type="date" class="coupon_end" name="coupon_end" value="' + item.coupon_end + '" disabled></li>';
							if(item.coupon_useday == null){
								str += '<li class="listtd">미사용</li>';
							} else {
								str += '<li class="listtd">' + item.coupon_useday + '</li>';
							}
							str += '<li class="listtd"><select class="coupon_use" name="coupon_use" disabled>';
							str += '<option value=' + item.coupon_use + '>'+ item.coupon_use +'</option>';
							str += '<option value="0">사용가능</option>';
							str += '<option value="1">사용불가</option>';
							str += '</select></li>';
							str += '<li class="listtd"><input type="hidden" value="'+item.coupon_seq+'"><a class="update">수정</a>';
							str += '<a style="display: none;" value="/setak/admin/updateCoupon.do?coupon_seq=' + item.coupon_seq + '" class="after">수정</a></li>';
							str += '</ul>';
							$(".coupon_list").append(str);
						});
						$(".coupon_list").append('<input type="button" value="선택삭제" class="checkdelete" id="delete-btn" >');
						page();
					},
					error:function(){
						alert("ajax통신 실패!!!");
					}
				});
			}
			
			selectData();	
			
			//아이디 넣기
			$(document).on("click", ".member_id", function () {
				var id = $(this).val();
				$("#i-keyword").val(id);
			});
			
			// 전체선택
			$("#allcheck").click(function(){
		        if($("#allcheck").prop("checked")){
		            $("input[name=chk]").prop("checked",true);
		        }else{
		            $("input[name=chk]").prop("checked",false);
		        }
		    }) 
			
			//수정버튼 클릭시
			$(document).on('click','.update',function(event) {
				$(".after").css("display","none");
				$(".update").css("display","block");
				$(".coupon_irum").attr("disabled","disabled");
				$(".coupon_end").attr("disabled","disabled");
				$(".coupon_use").attr("disabled","disabled");
				$(".coupon_irum").removeClass("upadte_select");
				$(".coupon_end").removeClass("upadte_select");
				$(".coupon_use").removeClass("upadte_select");
				$('.listtd').removeClass("update_count");
				
				$($(this).parent().children(".after")).css("display","block");
				$(this).css("display","none");
				$($(this).parent().parent().children().children('.coupon_irum')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.coupon_end')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.coupon_use')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.coupon_irum')).addClass("upadte_select");
				$($(this).parent().parent().children().children('.coupon_end')).addClass("upadte_select");
				$($(this).parent().parent().children().children('.coupon_use')).addClass("upadte_select");
				
								
				//다른 수정버튼 눌렀을 때 기본값으로 돌리기 위해서
				$('#coupon_form')[0].reset();
			});
		
			//수정 ajax
			$(document).on('click','.after', function(event){
				var name = $(this).parents().eq(1).children().eq(2).children().val();
				var end = $(this).parents().eq(1).children().eq(4).children().val();
				var use = $(this).parents().eq(1).children().eq(6).children().val();
				
				var params = {"coupon_name":name,"coupon_end":end,"coupon_use":use}
				
				jQuery.ajax({
					url : $(this).attr("value"), 
					type : 'post',
					data : params,
					contentType:'application/x-www-form-urlencoded; charset=utf-8',
					dataType : "json", //서버에서 보내줄 데이터 타입
					success:function(retVal){
						if(retVal.res == "OK"){
							$('.coupon_list').empty()
							selectData();	
						} else {
							alert("수정 실패2");
						}
					},
					error:function(){
						alert("ajax통신 실패");
					}
				});
				event.preventDefault();
			}); 
			
			
			//삭제
			$("#delete-btn").click(function () {
				var coupon_seq = [];
				var checkbox = $("input[name=chk]:checked");
				
				checkbox.each(function() {
					var chk = $(this);
					var seq = chk.parent().parent().children().eq(7).children().val();
					
					coupon_seq.push(seq);
				});
				
				
				$.ajax({
					
					url:'/setak/admin/deleteCoupon.do',
					type:'POST',
					data : {
						coupon_seq : coupon_seq
					},
					traditional : true,
					dataType:"json",
					contentType:'application/x-www-form-urlencoded; charset=utf-8',
					success:function(retVal) {
						if(retVal.res == "OK"){
							$('.coupon_list').empty();
							location.href = "/setak/admin/admin_coupon.do";
						} else {
							alert("삭제 실패.");
						}				
					},
					error: function() {
						alert("ajax통신 실패");
				    }
				});
			});
			
			
		});
		
		//페이징 작업
		function page(){ 
			$('div.paginated').each(function() {
				var pagesu = 10;  //페이지 번호 갯수
				var currentPage = 0;
				var numPerPage = 10;  //목록의 수
				var $table = $(this);    
				  
				//length로 원래 리스트의 전체길이구함
				var numRows = $table.find('ul').length;
				//Math.ceil를 이용하여 반올림
				var numPages = Math.ceil(numRows / numPerPage);
				//리스트가 없으면 종료
				if (numPages==0) return;
				//pager라는 클래스의 div엘리먼트 작성
				var $pager = $('<div id="remo"></div>');
				 
				var nowp = currentPage;
				var endp = nowp+10;
			  
				//페이지를 클릭하면 다시 셋팅
				$table.bind('repaginate', function() {
				//기본적으로 모두 감춘다, 현재페이지+1 곱하기 현재페이지까지 보여준다
					$table.find('ul').hide().slice(currentPage * numPerPage, (currentPage + 1) * numPerPage).show();
					$("#remo").html("");
					
					if (numPages > 1) {     // 한페이지 이상이면
						if (currentPage < 5 && numPages-currentPage >= 5) {   // 현재 5p 이하이면
							nowp = 0;     // 1부터 
							endp = pagesu;    // 10까지
						}else{
							nowp = currentPage -5;  // 6넘어가면 2부터 찍고
							endp = nowp+pagesu;   // 10까지
							pi = 1;
						}
						if (numPages < endp) {   // 10페이지가 안되면
							endp = numPages;   // 마지막페이지를 갯수 만큼
							nowp = numPages-pagesu;  // 시작페이지를   갯수 -10
						}
						if (nowp < 1) {     // 시작이 음수 or 0 이면
							nowp = 0;     // 1페이지부터 시작
						}
					}else{       // 한페이지 이하이면
						nowp = 0;      // 한번만 페이징 생성
						endp = numPages;
					}
					
					// [<<]
					$('<span class="page-number" cursor: "pointer"><<</span>').bind('click', {newPage: page},function(event) {
						currentPage = 0;
						$table.trigger('repaginate');  
						$($(".page-number")[2]).addClass('active').siblings().removeClass('active');
					}).appendTo($pager).addClass('clickable');
					// [<]
					$('<span class="page-number" cursor: "pointer"><</span>').bind('click', {newPage: page},function(event) {
						if(currentPage == 0) return;
						currentPage = currentPage-1;
						$table.trigger('repaginate');
						$($(".page-number")[(currentPage-nowp)+2]).addClass('active').siblings().removeClass('active');
					}).appendTo($pager).addClass('clickable');
					// [1,2,3,4,5,6,7,8]
					for (var page = nowp ; page < endp; page++) {
						$('<span class="page-number" cursor: "pointer"></span>').text(page + 1).bind('click', {newPage: page}, function(event) {
							currentPage = event.data['newPage'];
							$table.trigger('repaginate');
							$($(".page-number")[(currentPage-nowp)+2]).addClass('active').siblings().removeClass('active');
						}).appendTo($pager).addClass('clickable');
					}
					// [>]
					$('<span class="page-number" cursor: "pointer">></span>').bind('click', {newPage: page},function(event) {
						if(currentPage == numPages-1) return;
						currentPage = currentPage+1;
						$table.trigger('repaginate'); 
						$($(".page-number")[(currentPage-nowp)+2]).addClass('active').siblings().removeClass('active');
					}).appendTo($pager).addClass('clickable');
					// [>>]
					$('<span class="page-number" cursor: "pointer">>></span>').bind('click', {newPage: page},function(event) {
						currentPage = numPages-1;
						$table.trigger('repaginate');
						$($(".page-number")[endp-nowp+1]).addClass('active').siblings().removeClass('active');
					}).appendTo($pager).addClass('clickable');
					$($(".page-number")[2]).addClass('active');
				});
				$pager.insertAfter($table).find('span.page-number:first').next().next().addClass('active'); 
				$pager.appendTo($table);
				$table.trigger('repaginate');
			});
		}
		
		//검색
		function searchCoupon() {
			
			var param = {
					keyword : $('#keyword').val(),
					//orderBy : orderBy
				};
			
			
			$.ajax({
				url:'/setak/admin/couponSearch.do', 
				type:'POST',
				data:param,
				dataType:"json", //리턴 데이터 타입
				contentType:'application/x-www-form-urlencoded; charset=utf-8',
				success:function(data) {	
					$(".coupon_list").empty();
					
					var list = data.couponlist;
					
					if (list.length == 0){
						var str = '';
						str += '<h3 >결과값이 없습니다.</h3>'
						
						$(".coupon_list").append(str);
						
					}
					
					 $.each(list, function(index, item) {
						 
						 var str = '';
							str += '<ul>'
							str += '<li class="listtd"><input type="checkbox" name="chk"></li>';
							str += '<li class="listtd"><input type="button" class="member_id" value="' + item.member_id +'"></li>';
							str += '<li class="listtd"><input type="text" class="coupon_irum" name="coupon_name" value="' + item.coupon_name + '" disabled></li>';
							str += '<li class="listtd">' + item.coupon_start + '</li>';
							str += '<li class="listtd"><input type="date" class="coupon_day" name="coupon_end" value="' + item.coupon_end + '" disabled></li>';
							if(item.coupon_useday == null){
								str += '<li class="listtd">미사용</li>';
							} else {
								str += '<li class="listtd">' + item.coupon_useday + '</li>';
							}
							str += '<li class="listtd"><select class="coupon_use" name="coupon_use" disabled>';
							str += '<option value=' + item.coupon_use + '>'+ item.coupon_use +'</option>';
							str += '<option value="0">사용가능</option>';
							str += '<option value="1">사용불가</option>';
							str += '</select></li>';
							str += '<li class="listtd"><a class="update">수정</a>';
							str += '<a style="display: none;" value="/setak/admin/updateCoupon.do?coupon_seq=' + item.coupon_seq + '" class="after">수정</a></li>';
							str += '</ul>';
							$(".coupon_list").append(str);

					 });
					 $(".coupon_list").append('<input type="button" value="선택삭제" class="checkdelete" id="delete-btn" >');
					page();
				},
				error: function() {
					alert("통신실패!");
			    }
			});
		}	
		
		//쿠폰 입력
		function insertCoupon() {
			var id = $('#i-keyword').val();
			var name = $('#i-name').val();
			
			var cvo = {"member_id": id,"coupon_name":name}
			$.ajax({
				url : '/setak/admin/insertCoupon.do',
				type : 'POST',
				data : cvo,
				dataType : 'json',
				contentType : 'application/x-www-form-urlencoded; charset=utf-8',
				success:function(retVal){
					if(retVal.res == "OK"){
						$('.coupon_list').empty();
						location.href = "/setak/admin/admin_coupon.do";
					
					} else {
						alert("회원 아이디가 없습니다.");
					}
				},
				error:function(){
					alert("ajax통신 실패");
				}
			});
		}
		
		
	</script>
</head>
<body>
		<div id="admin"></div>
		
		<div class="content">
			<!-- 여기서부터 작업하세요. -->
			<h1>전체쿠폰관리</h1>
			
			<!-- 필터 -->
			<div id = "search-div">
				<h2>전체쿠폰검색</h2>
				<form id = "search-form" action = "">
					<table id = "search-table">
						<tr>
							<td>회원 검색</td>
							<td>
								<input id="keyword" type="text" size="40px" placeholder = "아이디를 입력하세요." /> 
							</td>
						</tr>
					</table>
				</form>
				
				<div id="search-btn-div">
					<input type="button" id = "search-btn" value = "검색" onclick = "searchCoupon();" />
				</div>
			</div>			
			<!-- 필터 끝 -->
			<!-- 쿠폰 부여 -->
			<div id = "insert-div">
				<h2>쿠폰 소매넣기</h2>
				<form id = "insert-form" action = "">
					<table id = "insert-table">
						<tr>
							<td>쿠폰</td>
							<td>
								<input id="i-keyword" type="text" size="40px" placeholder = "아이디를 입력하세요." /> 
								<input id="i-name" type="text" size="40px" placeholder = "쿠폰이름을 입력하세요." /> 
							</td>
							<td>
						</tr>
					</table>
				</form>
				
				<div id="insert-btn-div">
					<input type="button" id = "insert-btn" value = "확인" onclick = "insertCoupon();" />
				</div>
			</div>
			<!-- 쿠폰 부여 끝-->		
			
			
			<ul class="coupon_title">
				<li><input type="checkbox" id="allcheck"></li>
				<li>회원아이디</li>
				<li>쿠폰이름</li>
				<li>쿠폰부여날짜</li>
				<li>쿠폰만료날짜</li>
				<li>쿠폰사용날짜</li>
				<li>쿠폰사용여부</li>
				<li>수정</li>
			</ul>
			
			<form id="coupon_form">
				<div class="coupon_list paginated">
					
				</div>
			</form>


		</div>
		<!-- 결과  div 끝-->
	<!-- 지우지마세요 -->
</body>
</html>
