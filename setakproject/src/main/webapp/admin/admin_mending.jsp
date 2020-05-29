<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰 관리자페이지</title>
	<link rel="shortcut icon" href="../favicon.ico">
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	<link rel="stylesheet" type="text/css" href="../css/admin_mending.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<!--sweetalert2 -->
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@9"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#admin").load("./admin.jsp")
			
			//목록 띄우기
			function selectData(){
				
				$.ajax({
					url : '/setak/getMendingList.do',
					type : 'POST',
					dataType : 'json',
					contentType : 'application/x-www-form-urlencoded; charset=utf-8',
					success:function(data){
						$.each(data, function(index, item){
							var str = '';
							
							str += '<ul>'
							str += '<li class="listtd"><input type="checkbox" name="chk"></li>';
							str += '<li class="listtd">' + item.repair_rnum + '</li>';
							str += '<li class="listtd">' + item.order_num + '</li>';
							str += '<li class="listtd" title="' + item.member_id + '">' + item.member_id + '</li>';
							str += '<li class="listtd"><input type="text" class="repair_cate" value="' + item.repair_cate + '" disabled></li>';
							str += '<li class="listtd"><input type="text" class="repair_kind" value="' + item.repair_kind + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_var" value="' + item.repair_var1 + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_var" value="' + item.repair_var2 + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_var" value="' + item.repair_var3 + '" disabled></li>';
							if(item.repair_content == undefined){
								item.repair_content = "";
							}
							str += '<li class="listtd" title="' + item.repair_content + '"><input type="text" class="repair_content" value="' + item.repair_content + '" disabled></li>';
							str += '<li class="listtd"><input type="text" class="repair_code" value="' + item.repair_code + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_count" value="' + item.repair_count + '" disabled></li>';
							str += '<li class="listtd"><select class="repair_now" name="repair_now" disabled>';
							str += '<option value=' + item.repair_now + '>'+ item.repair_now +'</option>';
							str += '<option value="입고전">입고전</option>';
							str += '<option value="수선중">수선중</option>';
							str += '<option value="수선완료">수선완료</option>';
							str += '</select></li>';
							str += '<li class="listtd"><input type="button" class="mending_img_popup" value="사진"></li>';
							str += '<li class="listtd"><a class="update">수정</a>';
							str += '<a style="display: none;" value="/setak/updateMending.do?repair_seq=' + item.repair_seq + '" class="after">확인</a></li>';
							str += '<li class="listtd" style="display:none;"><input type="text" class="repair_seq" value="' + item.repair_seq + '" disabled></li>';
							str += '</ul>';
							$(".mending_list").append(str);
						});
						$(".mending_list").append('<input type="button" value="선택삭제" class="chkdelete">');
						page();
					},
					error:function(){
						alert("ajax통신 실패!!!");
					}
				});
			}
			
			selectData();
			
			//수정 눌렀을 때
			var update_repair_cate ="";
			var update_repair_kind ="";
			$(document).on('click','.update',function(event) {
				$(".after").css("display","none");
				$(".update").css("display","block");
				$(".repair_count").attr("disabled","disabled");
				$(".repair_content").attr("disabled","disabled");
				$(".repair_code").attr("disabled","disabled");
				$(".repair_var").attr("disabled","disabled");
				$(".repair_now").attr("disabled","disabled");
				$(".repair_count").removeClass("upadte_select");
				$(".repair_content").removeClass("upadte_select");
				$(".repair_code").removeClass("upadte_select");
				$(".repair_var").removeClass("upadte_select");
				$(".repair_now").removeClass("upadte_select");
				$('.listtd').removeClass("update_count");
				
				$($(this).parent().children(".after")).css("display","block");
				$(this).css("display","none");
				$($(this).parent().parent().children().children('.repair_count')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.repair_content')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.repair_code')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.repair_var')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.repair_now')).removeAttr("disabled");
				$($(this).parent().parent().children().children('.repair_count')).addClass("upadte_select");
				$($(this).parent().parent().children().children('.repair_content')).addClass("upadte_select");
				$($(this).parent().parent().children().children('.repair_code')).addClass("upadte_select");
				$($(this).parent().parent().children().children('.repair_var')).addClass("upadte_select");
				$($(this).parent().parent().children().children('.repair_now')).addClass("upadte_select");
				$($(this).parent().parent().children('.listtd:nth-child(6)')).addClass("update_count"); //팝업창 누를 수 있게 됨
				
				//나중에 옷종류 값 변경 시키기위해서.
				update_repair_cate = $($(this).parent().parent().children('.listtd:nth-child(5)').children(".repair_cate"));
				update_repair_kind = $($(this).parent().parent().children('.listtd:nth-child(6)').children(".repair_kind"));
				
				//다른 수정버튼 눌렀을 때 기본값으로 돌리기 위해서
				$('#mending_form')[0].reset();
			});

			//수정 활성화 됐을 때 종류 값 클릭시 팝업생성
			$(document).on('click','.update_count',function(event) {
				$(".popup_back").addClass("popup_on");
			});
			$(document).on('click','.close',function(event) {
	            $(".popup_back").removeClass("popup_on");
				$(".mending-list").removeClass("tab_active");
	        });

			//팝업에서 탭 눌렀을 때
			$(".tab").on("click", function() {
				$(".tab").removeClass("tab_active");
				$(".tab-content").removeClass("show");
				$(this).addClass("tab_active");
				$($(this).attr("href")).addClass("show");
			});
			$(".mending-list").on("click", function() {
				$(".mending-list").removeClass("tab_active");
				$(this).addClass("tab_active");
			});
			
			//팝업에서 확인 눌렀을 때
			var popup_repair_cate = "";	//큰카테
			var popup_repair_kind = "";	//작은카테
			$(document).on('click','.commit',function(event) {
				popup_repair_cate = document.getElementsByClassName('tab tab_active');
	            popup_repair_kind = document.getElementsByClassName('mending-list tab_active');
	            
	            if(!$(".mending-list").hasClass("tab_active")){
	            	Swal.fire("","종류를 선택하지 않았습니다.","info");
					return false;
				}
	            
	            //팝업닫기
	            $(".popup_back").removeClass("popup_on");

	            //옷종류 바꾼거 적용시키기 
	            $(update_repair_cate).val(popup_repair_cate[0].innerHTML);
	            $(update_repair_kind).val(popup_repair_kind[0].innerHTML);

	            $(".mending-list").removeClass("tab_active");
			});
			
			//수정 ajax
			$(document).on('click','.after', function(event){
				var cate = $(this).parents().eq(1).children().eq(4).children().val();
				var kind = $(this).parents().eq(1).children().eq(5).children().val();
				var var1 = $(this).parents().eq(1).children().eq(6).children().val();
				var var2 = $(this).parents().eq(1).children().eq(7).children().val();
				var var3 = $(this).parents().eq(1).children().eq(8).children().val();
				var content = $(this).parents().eq(1).children().eq(9).children().val();
				var code = $(this).parents().eq(1).children().eq(10).children().val();
				var count = $(this).parents().eq(1).children().eq(11).children().val();
				var now = $(this).parents().eq(1).children().eq(12).children().val();

				var params = {"repair_cate":cate,"repair_kind":kind,"repair_var1":var1,"repair_var2":var2,"repair_var3":var3,"repair_content":content,"repair_code":code,"repair_count":count,"repair_now":now}
				
				jQuery.ajax({
					url : $(this).attr("value"), 
					type : 'post',
					data : params,
					contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					dataType : "json", //서버에서 보내줄 데이터 타입
					success:function(retVal){
						if(retVal.res == "OK"){
							$('.mending_list').empty()
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
			
			
			//삭제 ajax
			$(document).on('click', '.chkdelete', function(){
				var mending_seq = [];
				var checkbox = $("input[name=chk]:checked");
				
				checkbox.each(function() {
					var seq = $(this).parents().eq(1).children().eq(15).children().val();
					mending_seq.push(seq);
				});
				
			 	$.ajax({
					url:'/setak/admin/deleteMending.do',
					type:'POST',
					data : {mending_seq : mending_seq},
					traditional : true,
					dataType:"json",
					contentType:'application/x-www-form-urlencoded; charset=utf-8',
					success:function(retVal) {
						if(retVal.res == "OK"){
							Swal.fire("","삭제되었습니다.","success");
							$('.mending_list').empty();
							selectData();
						} else {
							alert("삭제 실패");
						}            
					},
					error: function() {
						alert("ajax통신 실패");
					}
				}); 
			});
			
			// 전체선택
			$("#allcheck").click(function(){
				if($("#allcheck").prop("checked")){
					$("input[name=chk]").prop("checked",true);
				}else{
					$("input[name=chk]").prop("checked",false);
				}
			});
			
			//검색 ajax
			$(document).on('click', '#search-btn', function(){
				var param = {keyword : $('#keyword').val()};
				$.ajax({
					url:'/setak/admin/mendingSearch.do', 
					type:'POST',
					data:param,
					dataType:"json", //리턴 데이터 타입
					contentType:'application/x-www-form-urlencoded; charset=utf-8',
					success:function(data) {	
						$(".mending_list").empty();
						var list = data.mendinglist;				
						if (list.length == 0){
							var str = '';
							str += '<h3>결과값이 없습니다.</h3>'
							$(".mending_list").append(str);
						}
						$.each(list, function(index, item) {
							var str = '';

							str += '<ul>'
							str += '<li class="listtd"><input type="checkbox" name="chk"></li>';
							str += '<li class="listtd">' + item.repair_rnum + '</li>';
							str += '<li class="listtd">' + item.order_num + '</li>';
							str += '<li class="listtd">' + item.member_id + '</li>';
							str += '<li class="listtd"><input type="text" class="repair_cate" value="' + item.repair_cate + '" disabled></li>';
							str += '<li class="listtd"><input type="text" class="repair_kind" value="' + item.repair_kind + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_var" value="' + item.repair_var1 + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_var" value="' + item.repair_var2 + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_var" value="' + item.repair_var3 + '" disabled></li>';
							str += '<li class="listtd"><input type="text" class="repair_content" value="' + item.repair_content + '" disabled></li>';
							str += '<li class="listtd"><input type="text" class="repair_code" value="' + item.repair_code + '" disabled></li>';
							str += '<li class="listtd"><input type="number" class="repair_count" value="' + item.repair_count + '" disabled></li>';
							str += '<li class="listtd"><select class="repair_now" name="repair_now" disabled>';
							str += '<option value=' + item.repair_now + '>'+ item.repair_now +'</option>';
							str += '<option value="입고전">입고전</option>';
							str += '<option value="수선중">수선중</option>';
							str += '<option value="수선완료">수선완료</option>';
							str += '</select></li>';
							str += '<li class="listtd"><input type="button" class="mending_img_popup" value="사진"></li>';
							str += '<li class="listtd"><a class="update">수정</a>';
							str += '<a style="display: none;" value="/setak/updateMending.do?repair_seq=' + item.repair_seq + '" class="after">확인</a></li>';
							str += '<li class="listtd" style="display:none;"><input type="text" class="repair_seq" value="' + item.repair_seq + '" disabled></li>';
							str += '</ul>';
							$(".mending_list").append(str);
						});
						$(".mending_list").append('<input type="button" value="선택삭제" class="chkdelete">');
						page();
					},
					error: function() {
						alert("통신실패");
				    }
				});
			});
		});
		
		//사진 클릭시 팝업생성
		var mending_seq ="";
		$(document).on('click','.mending_img_popup',function(event) {
			$(".popup_img_back").addClass("popup_on");
			$(".imgs_wrap").empty();
			mending_seq = $(this).parents().eq(1).children().eq(15).children().val();
			order_num = $(this).parents().eq(1).children().eq(2).text();
			repair_code = $(this).parents().eq(1).children().eq(10).children().val();
			$('#input_order_num').val(order_num);
			$('#input_repair_code').val(repair_code);
			before_img();
		});
		$(document).on('click','.mending_img_close',function(event) {
            $(".popup_img_back").removeClass("popup_on");
            img_index = 0;
            $("#input_imgs").val("");
        });
		
		//저장된 이미지 불러오기
		function before_img(){
		 	$.ajax({
				url:'/setak/admin/mendingLoadImg.do',
				type:'POST',
				data : {"repair_seq" : mending_seq},
				dataType:"json",
				contentType:'application/x-www-form-urlencoded; charset=utf-8',
				success:function(data) {
					$('.before_img').empty();
					var list = data.imglist;
					if(list == ""){
						var str = '';
						str += '<h3>등록된 이미지가 없습니다.</h3>'
						$(".before_img").append(str);
						return;
					}
					$.each(list, function(index, item) {
						var str = '';
						str += "<a href='javascript:void(0);'><img src='https://kr.object.ncloudstorage.com/airbubble/setakgom/mending/" + item.repair_file + "'>";
						str += "<input type='hidden' class='deleteBefore' value='" + item.repair_file + "'><h3 class='deleteBeforeImg'>삭제</h3></a>";
						$(".before_img").append(str);
					});
				},
				error: function() {
					alert("통신실패!");
			    }
			}); 
		}
		
		//저장된 이미지 삭제하기
		$(document).on('click', '.deleteBeforeImg', function(){
			var del_mending_file = $($(this).parent().children(".deleteBefore")).val();
			$.ajax({
				url:'/setak/admin/deleteMendingImg.do',
				type:'POST',
				data : {"repair_file" : del_mending_file},
				dataType:"text",
				contentType:'application/x-www-form-urlencoded; charset=utf-8',
				success:function(data) {
					$('.before_img').empty();
					before_img();
					
					$.ajax({
						url:'/setak/deleteImage.do',
						type:'POST',
						data : {"filename":del_mending_file, "purpose":"mending"},
						dataType:"text",
						contentType:'application/x-www-form-urlencoded; charset=utf-8',
						success:function(data) {
							
						},
						error: function (e) {
		                	alert("이미지 클라우드 삭제 실패")
		                	console.log(e);
						}
					});
				},
                error: function (e) {
                	alert("이미지삭제 실패");
                	console.log(e);
				}
			}); 
		});

		//이미지 정보들 담을 배열
		var sel_files = [];
		$(document).ready(function(){
			$("#input_imgs").on("change", handleImgFileSelect);	
		});
		var img_index = 0;
		function handleImgFileSelect(e){
			//이미지 정보 초기화
			sel_files = [];
			$(".imgs_wrap").empty();
			
			var files = e.target.files;
			var filesArr = Array.prototype.slice.call(files);
			
			filesArr.forEach(function(f){
				if(!f.type.match("image.*")){
					Swal.fire("","이미지 확장자만 가능합니다.","info");
					$("#input_imgs").val("");
					return;
				}
				sel_files.push(f);
				
				var reader = new FileReader();
				reader.onload = function(e) {
					var html = "<a href='javascript:void(0);' id=\"img_id_"+img_index+"\"><img src=\"" + e.target.result + "\" data-file='"+f.name + "' title='Click to remove'><h3 onclick=\"deleteImageAction("+img_index+")\">삭제</h3></a>";
					$(".imgs_wrap").append(html);
					img_index++;
				}
				reader.readAsDataURL(f);
			});
		}
		
		//이미지 삭제
 		function deleteImageAction(img_index){
			sel_files.splice(img_index,1);
			
			var img_id = "#img_id_" + img_index;
			$(img_id).remove();
			$("#input_imgs").val("");
		}
		
		//사진 업로드 ajax
		var filecontent;
		var filename;
		var data = new FormData();// key/value로 채워지는것임 참고.
		
		$(document).on("change","#input_imgs",function(){
				filecontent = $(this)[0].files[0];
				filename = Date.now() + "_" + $(this)[0].files[0].name;
				data.append("files", filecontent);
				data.append("filename", filename);			
		}); 
		$(document).on("submit", "#imgform", function(){
			var zizi = $(this).children().children().children('.before_img').text();
			if(zizi=='삭제'){
				Swal.fire("","저장된 사진이 존재합니다","info");
				return false;
			}
			img_index = 0;

			if(filecontent != null){
				data.append("purpose", "mending");
				
				$("#input_imgs2").val(filename);
				$.ajax({
					type: "POST",
		            enctype: 'multipart/form-data',
		            url: "/setak/testImage.do",
		            data: data,
		            processData: false,
		            contentType: false,
		            cache: false,
		            dataType: 'text',
		            success: function (data) {
					},
	                error: function (e) {
	                	console.log(e);
					}
				});
			}
			else{
				Swal.fire("","선택된 파일이 없습니다.","info");
				event.preventDefault();
			}
			filecontent = null;
			data = new FormData();
			dbfilename = "";
			$("#input_imgs").val("");
		});
	</script>
</head>
<body>
		<div id="admin"></div>
		<div class="content">
			<h1>수선관리</h1>
			<div id = "search-div">
				<form id="search-form">
					<table id = "search-table">
						<tr>
							<td>
								<input id="keyword" type="text" size="40px" placeholder = "아이디를 입력하세요." />
							</td>
							<td>
								<input type="button" id="search-btn" value="검색" />
							</td>
						</tr>
					</table>
				</form>
			</div>			
			
			<ul class="mending_title">
				<li><input type="checkbox" id = "allcheck"></li>
				<li>NO</li>
				<li>주문번호</li>
				<li>아이디</li>
				<li>구분</li>
				<li>종류</li>
				<li>왼쪽</li>
				<li>오른쪽</li>
				<li>기장or허리</li>
				<li>요청사항</li>
				<li>택코드</li>
				<li>수량</li>
				<li>상황</li>
				<li>사진</li>
				<li>수정</li>
			</ul>
			<form id="mending_form">
				<div class="mending_list paginated">
					
				</div>
			</form>
		</div>
		<div class="popup_back">
			<div class="popup">
				<div class="tabs">
					<div class="tab-list">
						<a href="#one" id="tab" class="tab tab_active">상의</a>
						<a href="#two" id="tab" class="tab">하의</a>
						<a href="#three" id="tab" class="tab">아우터</a>
					</div>
				</div>
	
				<div id="one" class="tab-content show">
					<ul class="top">
						<li class="mending-list" value="소매줄임">소매줄임</li>
						<li class="mending-list" value="기장줄임">기장줄임</li>
						<li class="mending-list" value="단추수선">단추수선</li>
						<li class="mending-list" value="튿어짐">튿어짐</li>
					</ul>
					<ul class="top">
						<li class="mending-list" value="지퍼수선">지퍼수선</li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
				</div>
				<div id="two" class="tab-content">
					<ul class="top">
						<li class="mending-list" value="허리줄임">허리줄임</li>
						<li class="mending-list" value="기장줄임">기장줄임</li>
						<li class="mending-list" value="단추수선">단추수선</li>
						<li class="mending-list" value="튿어짐">튿어짐</li>
					</ul>
					<ul class="top">
						<li class="mending-list" value="지퍼수선">지퍼수선</li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
				</div>
				<div id="three" class="tab-content">
					<ul class="top">
						<li class="mending-list" value="소매줄임">소매줄임</li>
						<li class="mending-list" value="기장줄임">기장줄임</li>
						<li class="mending-list" value="단추수선">단추수선</li>
						<li class="mending-list" value="튿어짐">튿어짐</li>
					</ul>
					<ul class="top">
						<li class="mending-list" value="지퍼수선">지퍼수선</li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
				</div>
				<div class="mending_button">
					<input type="button" value="취소" class="close">
					<input type="button" value="확인" class="commit">
				</div>
			</div>
		</div>

		<form id="imgform" action=".././MendingImg.do" method="post" enctype="multipart/form-data">
			<div class="popup_img_back">
				<div class="popup_img">
					<h2>등록된 사진</h2>
					<div class="before_img">
					</div>
					
					<hr />
					<h2>업로드할 사진</h2>
					<div class="input_wrap">
						<input type="file" id="input_imgs" accept="image/*" />
						<input type="hidden" name="repair_file" id="input_imgs2">
						<input type="hidden" name="order_num" value="" id="input_order_num">
						<input type="hidden" name="repair_code" value="" id="input_repair_code">
					</div>
					<div class="imgs_wrap">
						
					</div>
				</div>
				<div class="mending_button">
					<input type="button" value="취소" class="mending_img_close">
					<input type="submit" value="등록">
				</div>
			</div>
		</form>

	</div>
</body>
</html>
