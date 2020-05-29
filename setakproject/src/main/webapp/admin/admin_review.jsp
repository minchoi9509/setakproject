<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "com.spring.setak.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>세탁곰 관리자페이지</title>
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
<link rel="stylesheet" type="text/css" href="../css/admin_review.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	//헤더, 푸터연결
	$("#admin").load("./admin.jsp");
	
	//review 삭제
	$(document).on('click', 'li .a-r-delete', function () { 
		var num = $(this).parent().parent().find('.review_num').val();
		console.log(num);
		var param = {"review_num": num}
		jQuery.ajax({
			url : './ad_reviewDelete.do', 
			type : 'post',
			data : param,
			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
			dataType : "json", //서버에서 보내줄 데이터 타입
			success:function(retVal){
				if(retVal.res == "OK"){
					$('.ad_reviewlist').empty();
					selectData();	
				}
			},
			error:function(){
				alert("ajax통신 실패");
			}
		});
		event.preventDefault();
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
	};	
	
	//리스트 뿌리기
	function selectData(){				
		$.ajax({
			url :'/setak/admin/ad_reviewlist.do',
			type :'POST',
			dataType :'json',
			contentType : 'application/x-www-form-urlencoded; charset=utf-8',
			success:function(data){
				$.each(data, function(index, item){
					var review_d =JSON.stringify(item.review_date);					
					var rdate= review_d.substring(1 , 11).trim();
					var str = '';																					
					str += '<ul>';
					str += '<li><input type="text" class="review_num" value="'+item.review_num+'" disabled="disabled"></li>';
					str += '<li><input type="text" class="member_id" value="'+item.member_id +'" disabled="disabled"></li>';
					str += '<li><input type="text" class="review_kind" value="'+item.review_kind +'" disabled="disabled"></li>';
					str += '<li><input type="text" class="review_star" value="'+item.review_star +'" disabled="disabled"></li>';
					str += '<li><input type="text" class="review_content" value="'+item.review_content +'" disabled="disabled"></li>';
					str += '<li><input type="text" class="review_like" value="'+item.review_like +'" disabled="disabled"></li>';
					str += '<li><input type="text" class="review_photo"  value="'+ item.review_photo +'" disabled="disabled"></li>';
					str += '<li><input type="text" class="review_date" value="'+ rdate +'" disabled="disabled"></li>';
					str += '<li><input type="button" class="a-r-delete" value="삭제"></li>';
					str += '</ul>';
					$(".ad_reviewlist").append(str);
				});
				page();
			},
			error:function(){
				alert("ajax통신 실패!!!");
			}
		});				
	}
	selectData();

});			
</script>

</head>
<body>
	<div id="admin"></div>
	<div class="content">
	<!-- 여기서부터 작업하세요. -->
	<h1>REVIEW 관리</h1>
	<h4>qna 문의 내역</h4>
	<ul class="ad-review-title">
		<li>NO</li><!-- x -->
		<li>아이디</li><!-- x -->
		<li>항목</li><!--에어리어  -->
		<li>별점갯수</li><!-- 텍스트 -->
		<li>내용</li><!-- 파일수정 -->
		<li>좋아요갯수</li><!-- 셀옵 -->
		<li>사진경로</li><!-- 셀옵 -->
		<li>날짜</li><!-- 텍스트 -->
		<li>삭제</li><!-- 텍스트 -->
	</ul>
	<form id="ad_review_form" action="">
		<div class="ad_reviewlist paginated">
		
		</div>				
	</form><br><br><br><br><br><br><br><br><br>
	</div>
		
	

</div><!--지우지마세요 -->
</body>
</html>
