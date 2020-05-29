<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰 관리자페이지</title>
	<link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	<link rel="stylesheet" type="text/css" href="../css/admin_notice.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#admin").load("./admin.jsp")			
		
			
			//수정버튼 누르면		
			/* 	$('.update').on('click', function(){ */
			$(document).on('click', 'li .update', function () { 
				 if(!$(this).hasClass("active")){
					$(this).attr('value', '수정 확인 ');
					$(this).addClass("active");
					$('#ad_notice_form').attr('action', "./admin_noticeUpdate.do");					
					$(this).parent().prev().children().attr('disabled',false).css({'background':'#e1e4e4', 'border' : '1px solid #444'});
					$(this).parent().prev().prev().children().attr('disabled',false).css({'background':'#e1e4e4', 'border' : '1px solid #444'});
					$(this).parent().prev().prev().prev().children().attr('disabled',false).css({'background':'#e1e4e4', 'border' : '1px solid #444'});										
				 }else{
					$(this).attr('value','수정');
					$(this).removeClass("active");
					$('#ad_notice_form').attr('action', "");		
					$(this).parent().prev().children().attr('disabled',true).css({'background':'none', 'border' : 'none'});
					$(this).parent().prev().prev().children().attr('disabled',true).css({'background':'none', 'border' : 'none'});
					$(this).parent().prev().prev().prev().children().attr('disabled',true).css({'background':'none', 'border' : 'none'});
										
				 }
				
				
			});
			
			//추가버튼 누르면 
			$(document).on('click', '#ad-notice-insert-btn', function () { 			
				if(!$(this).hasClass("active")){					
					$(this).attr('value', '추가 취소');
					$(this).addClass("active");
					$('#ad-notice-insert').show();
					$('#ad-notice-insert-form').attr('action', './noticeInsert.do');
					
				}else{
					$(this).removeClass("active");
					$(this).attr('value','추가');
					$('#ad-notice-insert-form').attr('action', '');
					$('#ad-notice-insert').hide();					

				}
				
			});
			
			
			
			//목록 띄우기
			function selectData(){				
				$.ajax({
					url :'/setak/admin/ad_noticeList.do',
					type :'POST',
					dataType :'json',
					contentType : 'application/x-www-form-urlencoded; charset=utf-8',
					success:function(data){
						$.each(data, function(index, item){
							var re_d =JSON.stringify(item.notice_date);					
							var rdate= re_d.substr(1 ,10);
							var str = '';																					
							str += '<ul>';
							str += '<li class="listtd"><input type="text" class="notice_num" value="'+item.notice_num+'" disabled="disabled"></li>';
							str += '<li class="listtd"><input type="text" class="notice_title" value="'+item.notice_title +'" disabled="disabled"></li>';
							str += '<li class="listtd"><input type="text" class="notice_content" value="'+item.notice_content+'" disabled="disabled"></li>';
							str += '<li class="listtd"><input type="text" class="notice_date"  value="'+ rdate +'" disabled="disabled"></li>';														
							str += '<li class="listtd"><input type="button" class="update" value="수정"></li>';
							str += '<li class="listtd"><input type="button" class="a-n-delete" value="삭제"></li>';
							str += '</ul>';
							$(".ad_noticelist").append(str);
						});
						page();
					},
					error:function(){
						alert("ajax통신 실패!!!");
					}
				});
			}
			
			selectData();
			
			function test(){
				var title = $(this).parents().eq(1).children().val();
				console.log(title);
			}
			
			
			
			$(document).on('click','.update.active', function(event){
				var num = $(this).parent().parent().find('.notice_num').val();
				var title = $(this).parent().parent().find('.notice_title').val();
				var content = $(this).parent().parent().find('.notice_content').val();
				var date = $(this).parent().parent().find('.notice_date').val();								
				var params = {"notice_num": num, "notice_title" : title, "notice_content" : content, "notice_date" : date }				
				jQuery.ajax({
					url : './noticeUpdate.do', 
					type : 'post',
					data : params,
					contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					dataType : "json", //서버에서 보내줄 데이터 타입
					success:function(retVal){
						if(retVal.res == "OK"){
							$('.ad_noticelist').empty()
							selectData();
						} else {
							alert("수정 실패");
						}
					},
					error:function(){
						alert("ajax통신 실패");
					}
				});
				event.preventDefault();
			}); 
			
			$(document).on('click','.a-n-delete', function(event){
				var num = $(this).parent().parent().find('.notice_num').val();	
				var param = {"notice_num": num}
				jQuery.ajax({
					url : './noticeDelete.do', 
					type : 'post',
					data : param,
					contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					dataType : "json", //서버에서 보내줄 데이터 타입
					success:function(retVal){
						if(retVal.res == "OK"){
							$('.ad_noticelist').empty()
							selectData();
						} else {
							alert("삭제 실패");
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
			}
			
			
		});

	</script>
</head>
<body>
		<div id="admin"></div>
		<div class="content">
			<!-- 여기서부터 작업하세요. -->
			<h1>공지사항 관리</h1>
			<ul class="notice_title">
				<li>NO</li>
				<li>제목</li>
				<li>내용</li>
				<li>날짜</li>
				<li>수정</li>
				<li>삭제</li>
			</ul>
			<form id="ad_notice_form" action="">
				<div class="ad_noticelist paginated"></div>
				
			</form>
			
			<form action="" id="ad-notice-insert-form" method="post" enctype="multipart/form-data">			
				<input type="button" value="추가" id="ad-notice-insert-btn">
				<div id=ad-notice-insert><div>제목:<input id="a-n-i-text" name="notice_title" type="text" value="[공지]"></div><span id="a-n-i-tarea">내용:<textarea name="notice_content"></textarea></span>
				<input type="submit" value="등록"> 
				</div>		
			</form>
		
		</div>
	

</div><!--지우지마세요 -->
</body>
</html>
