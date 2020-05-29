<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "com.spring.setak.*"%>
<%
String login_id=(String)session.getAttribute("member_id");	

HashMap<String, Object> m_namelist = (HashMap<String, Object>)request.getAttribute("m_namelist");

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
<title>세탁곰</title>
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="./css/default.css"/>
<link rel="stylesheet" type="text/css" href="./css/review.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script src="https://kit.fontawesome.com/4b95560b7c.js" crossorigin="anonymous"></script>

<script type="text/javascript"></script>
<script>
$(document).ready(function () {	
	//헤더, 푸터연결
	$("#header").load("header.jsp")
    $("#footer").load("footer.jsp")    
   
    //모달팝업 오픈
    $(".open").on('click', function(){
    	var login_id="<%=session.getAttribute("member_id")%>";   	
    	if(!(login_id=="null")){
    		$("#re_layer").show();	
    		$(".dim").show();
    	}
    	else{

    		Swal.fire("","비회원은 리뷰를 작성 할 수 없습니다.","info");

    		location.href="login.do";
    		return false;
    	}
	});
	
    $(".close").on('click', function(){
    	$(this).parent().hide();	
    	$(".dim").hide();	
	});
    
    //리뷰 insert 파일 업로드   
    var filecontent;
	var filename="";
	
	$("#Review_photo").change(function(){
		filecontent = $(this)[0].files[0];
		filename = Date.now() + "_" + $(this)[0].files[0].name;
	});	
	
	$("#reviewform").on("submit", function() {
		if(rwchk()){			
			if(filecontent != null){
				var data = new FormData();
				data.append("purpose", "review");
				data.append("files", filecontent);
				data.append("filename", filename);
				
				$("#Review_photo2").val(filename);
				
				$.ajax({
	                type: "POST",
	                enctype: 'multipart/form-data',
	                url: "/setak/testImage.do",
	                data: data,
	                processData: false,
	                contentType: false,
	                cache: false,
	                dataType: 'json',	
	                success: function (data) {	                	
	                },
	                error: function (e) {	
					}	                
				});
			}			
		}else{
			event.preventDefault();
		}
	});
	
	//리뷰 update 파일 업로드   
    var filecontent;
	var filename="";
	
	$("#update-Review_photo").change(function(){
		filecontent = $(this)[0].files[0];
		filename = Date.now() + "_" + $(this)[0].files[0].name;
	});	
	$("#re_updateform").on("submit", function() {
		if(ruchk()){			
			if(filecontent != null){
				var data = new FormData();
				data.append("purpose", "review");
				data.append("files", filecontent);
				data.append("filename", filename);
				
				$("#update-Review_photo2").val(filename);
				
				$.ajax({
	                type: "POST",
	                enctype: 'multipart/form-data',
	                url: "/setak/testImage.do",
	                data: data,
	                processData: false,
	                contentType: false,
	                cache: false,
	                dataType: 'json',	
	                success: function (data) {	                	
	                },
	                error: function (e) {	
					}	                
				});
			}			
		}else{
			event.preventDefault();
		}
	});
	
	
    //별점 구동	
	$('.r_content a').click(function () {
	$(this).parent().children('a').removeClass('on');
    $(this).addClass('on').prevAll('a').addClass('on');      
    $('#Review_star').val($(this).attr("value")/2);
    return false;
	});	
    
	//top버튼 누르면 맨 위로 올라가게.
	$('span .page-number').on("click", function() {
		$("html, body").animate({scrollTop : 0}, 1000);
	});
	
	// 조건 ()
	$('input[type="radio"]').on('click', function() {		
		$('#re_list').empty();
		var rec= {re_condition : $('input[name="radio_val"]:checked').val()}; 	    
		$.ajax({
			url:'/setak/reviewCondition.do', 
			type:'POST',
			data: rec,
			dataType:"json",
			contentType:'application/x-www-form-urlencoded; charset=utf-8',
			success:function(data) {				
				$.each(data, function(index, item) {
					var re_list = '';					
					var i = item.review_star;
					var res =JSON.stringify(item.review_photo);			
					var idx= res.indexOf("_");
					var rphoto=res.substring(1,idx);
					var re_d =JSON.stringify(item.review_date);					
					var rdate= re_d.substr(1 ,16);
									
					re_list += '<form class="xx"><table id="re_table" class="re_table'+item.review_num+'">';
					re_list += '<tr style="display:none;"><td><input type="hidden" name="review_num" value="'+item.review_num+'"></td></tr>';							
					re_list += '<tr><td>' 
					if(i%2 == 1){
						for(var abc = 0; abc<(i-1)/2; abc++){
							re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4 on" value="'+item.review_star+'">';
						}
						re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
						re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
						for(var x = 0; x<((10-i)-1)/2; x++){  
							re_list += '<a id="rstar" class="starR3" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
						}
					}		
					if(i%2 == 0){
						for(var abc = 0; abc<i/2; abc++){
							re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4 on" value="'+item.review_star+'">';
						}
						for(var x = 0; x<(10-i)/2; x++){  
							re_list += '<a id="rstar" class="starR3" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
						}
					}
					
					re_list += '</td><td><input class="heart" type="button" name="Review_like'+index+'" value="추천 '+item.review_like+'"></td></tr>';
					
					re_list += '<tr><td>'+ item.review_kind +'</td><td>작성자 :&nbsp;'+ item.member_name +'<span>|</span>'+rdate+'</td></tr>';		
					re_list += '<tr><td class="ret">'+item.review_content+'</td>';																																						
					re_list += '<td class="re_list_td1">';
					re_list += '<div class="thumbnail-wrapper"><div class="thumbnail">';				 
								if (!(rphoto=="등록한 파일이 없습니다.")){ 
								  //re_list += '<img class="thumbnail-img" src="https://kr.object.ncloudstorage.com/airbubble/setakgom/review/'+item.review_photo+'"/>';
							   		re_list += '<img class="thumbnail-img" style="cursor:pointer;" src="https://kr.object.ncloudstorage.com/airbubble/setakgom/review/'+item.review_photo+'" onclick="window.open('+"'https://kr.object.ncloudstorage.com/airbubble/setakgom/review/"+item.review_photo+"'"+','+"'new'"+','+"'width=800 , height=600, left=500, top=100 , scrollbars= no'"+');">'; 
								}
								else
								{ //re_list += '<img class="thumbnail-img" src="./images/No_image_available.png"/>';
									re_list += '<img class="thumbnail-img" src="images/review.jpg">';
								}
					re_list += '</div></div>';	
					re_list += '</td></tr>';
					
					re_list += '<tr><td colspan="2">';																	
					re_list += '<input ur_num ="'+item.review_num+'" ur_id="'+item.member_id+'" ur_star="'+item.review_star+'" ur_content="'+item.review_content+'" ur_kind="'+item.review_kind+'" ur_photo="'+item.review_photo+'" class="updateForm" type="button" value="수정">';										
					re_list += '<input delete_id = "'+item.review_num+'" class="re_delete" type="button" value="삭제">';
					re_list += '</td></tr></table></form>';					
					$('#re_list').append(re_list);
					
				})
				page();
			},
			error: function() {
				alert("ajax통신 실패!!!");
		    }
	    });	
	});			
		
	//리뷰 리스트 뿌리기 		
	function selectData() {					
		$('#re_list').empty();		
		$.ajax({
			url:'/setak/reviewList.do', 
			type:'POST', 
			dataType:"json", //리턴 데이터 타입
			contentType:'application/x-www-form-urlencoded; charset=utf-8',
			success:function(data) {				
				$.each(data, function(index, item) {
					var re_list = '';					
					var i = item.review_star;
					var res =JSON.stringify(item.review_photo);			
					var idx= res.indexOf("_");
					var rphoto=res.substring(1,idx);
					var re_d =JSON.stringify(item.review_date);					
					var rdate= re_d.substr(1 ,16);
					var m_id=JSON.stringify(item.member_id);															
					
					re_list += '<form class="xx"><table id="re_table" class="re_table'+item.review_num+'">';
					re_list += '<tr style="display:none;"><td><input type="hidden" name="review_num" value="'+item.review_num+'"></td></tr>';							
					re_list += '<tr><td>' 
					if(i%2 == 1){
						for(var abc = 0; abc<(i-1)/2; abc++){
							re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4 on" value="'+item.review_star+'">';
						}
						re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
						re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
						for(var x = 0; x<((10-i)-1)/2; x++){  
							re_list += '<a id="rstar" class="starR3" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
						}
					}		
					if(i%2 == 0){
						for(var abc = 0; abc<i/2; abc++){
							re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4 on" value="'+item.review_star+'">';
						}
						for(var x = 0; x<(10-i)/2; x++){  
							re_list += '<a id="rstar" class="starR3" value="'+item.review_star+'">';
							re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
						}
					}
					
					re_list += '</td><td><input class="heart" type="button" name="Review_like'+index+'" value="추천 '+item.review_like+'"></td></tr>';
					
					re_list += '<tr><td>'+ item.review_kind +'</td><td>작성자 :&nbsp;'+ item.member_name +'<span>|</span>'+rdate+'</td></tr>';		
					re_list += '<tr><td class="ret">'+item.review_content+'</td>';																																						
					re_list += '<td class="re_list_td1">';
					re_list += '<div class="thumbnail-wrapper"><div class="thumbnail">';				 
								if (!(rphoto=="등록한 파일이 없습니다.")){ 
								  //re_list += '<img class="thumbnail-img" src="https://kr.object.ncloudstorage.com/airbubble/setakgom/review/'+item.review_photo+'"/>';
							   		re_list += '<img class="thumbnail-img" style="cursor:pointer;" src="https://kr.object.ncloudstorage.com/airbubble/setakgom/review/'+item.review_photo+'" onclick="window.open('+"'https://kr.object.ncloudstorage.com/airbubble/setakgom/review/"+item.review_photo+"'"+','+"'new'"+','+"'width=800 , height=600, left=500, top=100 , scrollbars= no'"+');">'; 
								}else
								{ //re_list += '<img class="thumbnail-img" src="./images/No_image_available.png"/>';
									re_list += '<img class="thumbnail-img" src="images/review.jpg">';
														
								}
					re_list += '</div></div>';	
					re_list += '</td></tr>';
					
					re_list += '<tr><td colspan="2">';																	
					re_list += '<input ur_num ="'+item.review_num+'" ur_id="'+item.member_id+'" ur_star="'+item.review_star+'" ur_content="'+item.review_content+'" ur_kind="'+item.review_kind+'" ur_photo="'+item.review_photo+'" class="updateForm" type="button" value="수정">';										
					re_list += '<input delete_id = "'+item.review_num+'" class="re_delete" type="button" value="삭제">';
					re_list += '</td></tr></table></form>';					
					$('#re_list').append(re_list);
						
				});
				page();									
			},
			error:function() {
				alert("ajax통신 실패!!!");
			}
						
		});
		
	}
		
	//삭제 버튼 - 삭제 실행
	$(document).on('click','.re_delete', function(event){ 
		var login_id="<%=session.getAttribute("member_id")%>";
		var ur_id = $(this).prev().attr("ur_id");
    	if(login_id=="null"||!(login_id==ur_id)){
    		Swal.fire("","권한이 없습니다.","warning");
    		return false;
    	} 
    	
		var result = confirm("리뷰를 삭제하시겠습니까?");
		if(result){
			var para = {review_num : $('input[name="review_num"]').val()}; 
			jQuery.ajax({
				url : '/setak/reviewDelete.do',
				type : 'POST',
				data : para,
				contentType : 'application/x-www-form-urlencoded; charset=utf-8',
				dataType : "json",
				success : function(retVal) {
					if (retVal.res == "OK") {
						selectData();						
					}
				
				},
				error:function() {
					alert("ajax통신 실패");
				}
			});	
			Event.preventDefault();
						
		}else{
			return false;
		}	
				
	});//삭제 끝
		
	//수정버튼 - 폼
	$(document).on('click','.updateForm', function(){
		var login_id="<%=session.getAttribute("member_id")%>";
		var ur_num = $(this).attr("ur_num");			
		var ur_id = $(this).attr("ur_id");			
		var ur_star= $(this).attr("ur_star")/2;						
		var ur_content=$(this).attr("ur_content"); 						
		var ur_kind=$(this).attr("ur_kind");					
		var ur_photo=$(this).attr("ur_photo"); //오리지날
		var res =JSON.stringify(ur_photo);			
		var idx= res.indexOf("_");
		var rphoto=res.substr(idx+1);//원래 파일 이름만 
		var rphoto2=rphoto.replace('"',"").trim();//원래 파일 이름만 
    	
		if(login_id=="null" || !(login_id==ur_id)){
    		Swal.fire("","권한이 없습니다.","warning");
    		return false;
    	} 
		
		$("#re_layer2").show();	
	    $(".dim2").show();			
	    $(".close2").on('click', function(){	    		    	
	    	$(this).parent().hide();	    	
	    	$(".dim2").hide();
		});
	    
	    $('.r_content a').click(function () {
	    	$(this).parent().children('a').removeClass('on');
	        $(this).addClass('on').prevAll('a').addClass('on');      
	        $('#Review_star2').val($(this).attr("value")/2);
	        return false;
	    	});
		
		
		$('#upload-name').attr('value',rphoto2);
		
		$('#Review_num2').attr('value', ur_num);
		$('#Review_star1').attr('value', ur_star);
		$('#member_id2').attr('value',ur_id);
		$('#Review_content2').val(ur_content);
		$("#Review_kind2").val(ur_kind);
		$('#exist_file').val(ur_photo);
		
	});
	
	//추천
	$(document).on('click', '.heart', function () { 
		var login_id="<%=session.getAttribute("member_id")%>";   	
		if(login_id=="null"){
			Swal.fire("","비회원은 리뷰를 추천 할 수 없습니다.","warning");
			return false;
		}
		
		var re_num=$(this).parent().parent().parent().children().eq(4).children().children().attr("ur_num");
		var re_like =$(this).val().replace("추천","").trim();
		var sendData = {'review_num' : re_num , 'review_like' : re_like};			        
		$.ajax({
			url:'/setak/heart.do',
			type:'POST',
			data:sendData,
			dataType:"json", 
			contentType:'application/x-www-form-urlencoded; charset=utf-8',				            			
			success: function(list){
				
				$('#re_list').empty();
				selectData();
			},
			
			error:function(){
				alert("ajax통신 실패!!!");
			}
							
		});
	 });
	selectData();

});

		
//검색
function searchCheck() {	
	//입력안한거 입력하도록 
	if (document.getElementById('keyword').value=="") {
		Swal.fire("","검색어를 입력하세요.","info");
        document.getElementById('keyword').focus();
        return;
    }
   
	$('#re_list').empty();
    var key= { keyfield :$('#keyfield').val(), keyword: $('input#keyword').val() };  
	$.ajax({
		url:'/setak/reviewSearch.do', 
		type:'POST',
		data:key,
		dataType:"json", //리턴 데이터 타입
		contentType:'application/x-www-form-urlencoded; charset=utf-8',
		success:function(data) {				
			$.each(data, function(index, item) {
				var re_list = '';					
				var i = item.review_star;
				var res =JSON.stringify(item.review_photo);			
				var idx= res.indexOf("_");
				var rphoto=res.substring(1,idx);
				var re_d =JSON.stringify(item.review_date);					
				var rdate= re_d.substr(1 ,16);
								
				re_list += '<form class="xx"><table id="re_table" class="re_table'+item.review_num+'">';
				re_list += '<tr style="display:none;"><td><input type="hidden" name="review_num" value="'+item.review_num+'"></td></tr>';							
				re_list += '<tr><td>' 
				if(i%2 == 1){
					for(var abc = 0; abc<(i-1)/2; abc++){
						re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
						re_list += '<a id="rstar" class="starR4 on" value="'+item.review_star+'">';
					}
					re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
					re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
					for(var x = 0; x<((10-i)-1)/2; x++){  
						re_list += '<a id="rstar" class="starR3" value="'+item.review_star+'">';
						re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
					}
				}		
				if(i%2 == 0){
					for(var abc = 0; abc<i/2; abc++){
						re_list += '<a id="rstar" class="starR3 on" value="'+item.review_star+'">';
						re_list += '<a id="rstar" class="starR4 on" value="'+item.review_star+'">';
					}
					for(var x = 0; x<(10-i)/2; x++){  
						re_list += '<a id="rstar" class="starR3" value="'+item.review_star+'">';
						re_list += '<a id="rstar" class="starR4" value="'+item.review_star+'">';
					}
				}
				
				re_list += '</td><td><input class="heart" type="button" name="Review_like'+index+'" value="추천 '+item.review_like+'"></td></tr>';
				
				re_list += '<tr><td>'+ item.review_kind +'</td><td>작성자 :&nbsp;'+ item.member_name +'<span>|</span>'+rdate+'</td></tr>';		
				re_list += '<tr><td class="ret">'+item.review_content+'</td>';																																						
				re_list += '<td class="re_list_td1">';
				re_list += '<div class="thumbnail-wrapper"><div class="thumbnail">';				 
							if (!(rphoto=="등록한 파일이 없습니다.")){ 
							  //re_list += '<img class="thumbnail-img" src="https://kr.object.ncloudstorage.com/airbubble/setakgom/review/'+item.review_photo+'"/>';
						   		re_list += '<img class="thumbnail-img" style="cursor:pointer;" src="https://kr.object.ncloudstorage.com/airbubble/setakgom/review/'+item.review_photo+'" onclick="window.open('+"'https://kr.object.ncloudstorage.com/airbubble/setakgom/review/"+item.review_photo+"'"+','+"'new'"+','+"'width=800 , height=600, left=500, top=100 , scrollbars= no'"+');">'; 
							}
							else
							{ //re_list += '<img class="thumbnail-img" src="./images/No_image_available.png"/>';
								re_list += '<img class="thumbnail-img" src="images/review.jpg">';
							}
				re_list += '</div></div>';	
				re_list += '</td></tr>';
				
				re_list += '<tr><td colspan="2">';																	
				re_list += '<input ur_num ="'+item.review_num+'" ur_id="'+item.member_id+'" ur_star="'+item.review_star+'" ur_content="'+item.review_content+'" ur_kind="'+item.review_kind+'" ur_photo="'+item.review_photo+'" class="updateForm" type="button" value="수정">';										
				re_list += '<input delete_id = "'+item.review_num+'" class="re_delete" type="button" value="삭제">';
				re_list += '</td></tr></table></form>';					
				$('#re_list').append(re_list);
				
			})
			page();
		},
		error: function() {
			alert("ajax통신 실패!!!");
	    }
    });	
	}	

//만들어진 테이블에 페이지 처리
function page(){ 
	
	$('#re_list').each(function() {
		var pagesu = 10;  //페이지 번호 갯수		
		var currentPage = 0;		
		var numPerPage = 10;  //목록의 수		
		var $table = $(this);    
		//length로 원래 리스트의 전체길이구함
		var numRows = $table.find('form').length;//10
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
		$table.find('form').hide().slice(currentPage * numPerPage, (currentPage + 1) * numPerPage).show();						
		$("#remo").html("");		
		if (numPages > 1) { // 한페이지 이상이면
			if (currentPage < 5 && numPages-currentPage >= 5) { // 현재 5p 이하이면
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
		// [처음]
		$('<br /><span class="page-number" cursor: "pointer"> << </span>').bind('click', {newPage: page},function(event) {
			currentPage = 0;   
		    $table.trigger('repaginate');  
		    $($(".page-number")[2]).addClass('active').siblings().removeClass('active');
		    $("html, body").animate({ scrollTop : 0 }, 500);
		}).appendTo($pager).addClass('clickable');
		// [이전]
		$('<span class="page-number" cursor: "pointer"> < </span>').bind('click', {newPage: page},function(event) {
		    if(currentPage == 0) return; 
		    currentPage = currentPage-1;
		    $table.trigger('repaginate'); 
		    $($(".page-number")[(currentPage-nowp)+2]).addClass('active').siblings().removeClass('active');
		    $("html, body").animate({ scrollTop : 0 }, 500);
		}).appendTo($pager).addClass('clickable');
		// [1,2,3,4,5,6,7,8]
		for (var page = nowp ; page < endp; page++) {
			$('<span class="page-number" cursor: "pointer" style="margin-left: 8px;"></span>').text(page + 1).bind('click', {newPage: page}, function(event) {
		    currentPage = event.data['newPage'];
		    $table.trigger('repaginate');
		    $($(".page-number")[(currentPage-nowp)+2]).addClass('active').siblings().removeClass('active');
		    $("html, body").animate({ scrollTop : 0 }, 500);
		    }).appendTo($pager).addClass('clickable');
		} 
		// [다음]
		$('<span class="page-number" cursor: "pointer"> > </span>').bind('click', {newPage: page},function(event) {
		    if(currentPage == numPages-1) return;
		    currentPage = currentPage+1;
		    $table.trigger('repaginate'); 
		    $($(".page-number")[(currentPage-nowp)+2]).addClass('active').siblings().removeClass('active');
		    $("html, body").animate({ scrollTop : 0 }, 500);
		}).appendTo($pager).addClass('clickable');
		// [끝]
		$('<span class="page-number" cursor: "pointer"> >> </span>').bind('click', {newPage: page},function(event) {
		    currentPage = numPages-1;
		    $table.trigger('repaginate');
		    $($(".page-number")[endp-nowp+1]).addClass('active').siblings().removeClass('active');
		    $("html, body").animate({ scrollTop : 0 }, 500);
		}).appendTo($pager).addClass('clickable');
		$($(".page-number")[2]).addClass('active');
		
	 });
	 $pager.insertAfter($table).find('span.page-number:first').next().next().addClass('active');   
	 $pager.appendTo($table);
	 $table.trigger('repaginate');
  });

}

//입력받을곳 확인체크 + 값 컨트롤러로 전달
function rwchk(){	

	if (document.getElementById('Review_content').value=="") 
	{
		Swal.fire("","리뷰의 내용을 작성하세요.(최대 300자)","info");
        document.getElementById('Review_content').focus();
        return false;
        
    }
	else if (document.getElementById('Review_star').value=="") 
	{
		Swal.fire("","별점을 눌러주세요","info");
        document.getElementById('Review_star').focus();
        return false;
    }
	
	else if (document.getElementById('Review_kind').value=="") 
	{
		Swal.fire("","이용하신 서비스를 선택해주세요","info");
        document.getElementById('Review_kind').focus();
        return false;
    }
	
	return true;
	
}
//리뷰 수정
function ruchk(){	

	if (document.getElementById('Review_content2').value=="") 
	{
		Swal.fire("","리뷰의 내용을 작성하세요.(최대 300자)","info");
        document.getElementById('Review_content2').focus();
        return false;
        
    }
	else if (document.getElementById('Review_star1').value=="") 
	{
		Swal.fire("","별점을 눌러주세요","info");
        document.getElementById('Review_star1').focus();
        return false;
    }
	else if (document.getElementById('Review_kind2').value=="") 
	{
		Swal.fire("","이용하신 서비스를 선택해주세요","info");
        document.getElementById('Review_kind2').focus();
        return false;
    }
	
	else{
		return true;
	}
}
//취소
function rwcancel(){
	  var check = confirm("작성을 취소하시겠습니까");
	  /* if(check == true) else false */
	  if(check)
	  { 
		  location.href='./review.do';
	  }
	  else
	  { 
		  return false;
	  }
}

	
</script>	
</head>
<body>
<div id="header"></div>
<section id="review">
<div class="content">
<div class="title-text"><h2>Review<small id="h_small">리뷰</small></h2></div>
<div class="review">

<!-- 리뷰작성 모달 팝업 
<a href="#" class="open">리뷰작성</a>
<div id="re_layer">
<h2>리뷰 작성</h2>
<form action="./reviewInsert.do" method="post" enctype="multipart/form-data" name="reviewform" id="reviewform">
<div class="r_content">
	<p style="margin-bottom:5px;">사용자 평점</p> 
	<a class="starR1 on" value="1" >별1_왼쪽</a>
    <a class="starR2" value="2">별1_오른쪽</a>
    <a class="starR1" value="3">별2_왼쪽</a>
    <a class="starR2" value="4">별2_오른쪽</a>
    <a class="starR1" value="5">별3_왼쪽</a>
    <a class="starR2" value="6">별3_오른쪽</a>
    <a class="starR1" value="7">별4_왼쪽</a>
    <a class="starR2" value="8">별4_오른쪽</a>
    <a class="starR1" value="9">별5_왼쪽</a>
    <a class="starR2" value="10">별5_오른쪽</a>    
    <small>&nbsp;별점 :<input type="text" id="Review_star" name="Review_star" value="" readonly="readonly">점</small>   
   	<input type="hidden" id="Review_like" name="Review_like" value="0">  	
</div>      
<table class="r_content">
	<tr><td colspan="7" class = "r_notice">&nbsp;REVIEW|&nbsp;<p style="display:inline-block; font-size: 0.8rem; color:#e1e4e4 ;"> 문의글은 무통보 삭제 됩니다</p></td></tr>
    <tr><td colspan="7"><textarea id="Review_content" name="Review_content" maxlength="300" placeholder="리뷰를 작성해 주세요"></textarea></td></tr>
    <tr><td width="40px">
     	<input type="file" id="Review_photo"/>                        
     	<input type="hidden" id="Review_photo2" name="Review_photo" /></td>                          
        <td width="40px">
        	<select name="Review_kind" id="Review_kind">
           		<option value="">분류</option>
                <option value="세탁">세탁</option>
                <option value="세탁-수선">세탁-수선</option>
                <option value="세탁-보관">세탁-보관</option>
                <option value="수선">수선</option>
                <option value="보관">보관</option>
                <option value="정기구독">정기구독</option>
           </select></td>
		<td align="right"  colspan="4">
			<input class="cbtn" type="submit" name="submit" value="등록" >		
			<input class="cbtn" type="button" value="취소" onclick="rwcancel();"/></td> 	
	</tr></table>
</form>
<a class="close"><i class="fas fa-times" aria-hidden="true" style="color:#444; font-size:30px;"></i></a>
</div>
<div class="dim"></div>
 -->

<!-- 리뷰수정 모달 팝업  -->
<div id="re_layer2">
<form action="./reviewUpdate.do" method="post" enctype="multipart/form-data" name="re_updateform" id="re_updateform" onsubmit="return ruchk();">
<h2>리뷰 수정</h2>
<div class="r_content">
	<div >작성자 :&nbsp;<label for="member_id2"></label><input onfocus="this.blur()" id="member_id2" name="member_id" value="">기존 별점 : 
	<input type="text" name="ex-Review_star" id="Review_star1" value="" readonly="readonly">점</div> 
	<small style=" float: left;" >별점 :</small> 
	<a class="starR1 on" value="1" >별1_왼쪽</a>
    <a class="starR2" value="2">별1_오른쪽</a>
    <a class="starR1" value="3">별2_왼쪽</a>
    <a class="starR2" value="4">별2_오른쪽</a>
    <a class="starR1" value="5">별3_왼쪽</a>
    <a class="starR2" value="6">별3_오른쪽</a>
    <a class="starR1" value="7">별4_왼쪽</a>
    <a class="starR2" value="8">별4_오른쪽</a>
    <a class="starR1" value="9">별5_왼쪽</a>
    <a class="starR2" value="10">별5_오른쪽</a>    
    <small>(<input type="text" id="Review_star2" name="Review_star" value="" readonly="readonly">) 점</small>
   	<input type="hidden" id="Review_num2" name="Review_num" value="">  	
</div>      
<table class="r_content">
	<tr><td colspan="7" class = "r_notice">&nbsp;REVIEW|&nbsp;<p style="display:inline-block; font-size: 0.8rem; color:#e1e4e4 ;"> 문의글은 무통보 삭제 됩니다</p></td></tr>
    <tr><td colspan="7"><textarea id="Review_content2" name="Review_content" maxlength="300" placeholder="리뷰를 작성해 주세요"></textarea></td></tr>
    <tr><td class="r_content_photo">
    		<input type="hidden" id="exist_file" name="exist_file" value="">
    		현재 이미지 : <input id="upload-name" value="" disabled="disabled">
    		<input type="file" id="update-Review_photo"/>                        
     		<input type="hidden" id="update-Review_photo2" name="Review_photo" /></td>   
		<td width="40px">
        	<select name="Review_kind" id="Review_kind2">
           		<option value="">분류</option>
                <option value="세탁">세탁</option>
                <option value="세탁-수선">세탁-수선</option>
                <option value="세탁-보관">세탁-보관</option>
                <option value="수선">수선</option>
                <option value="보관">보관</option>
                <option value="정기구독">정기구독</option>
           </select>
        </td>           
		<td align="right"  colspan="4">
			<input class="cbtn" type="submit" name="submit" value="등록" >		
			<input class="cbtn" type="button" value="취소" onclick="rwcancel();"/>
		</td>	 	
	</tr>
</table>
</form>
<a class="close2"><i class="fas fa-times" aria-hidden="true" style="color:#444; font-size:30px;"></i></a>
</div>
<div class="dim2"></div>


<!-- 글 분류 -->
<div class="re2">

<div class="re2_search">
<input type="radio" id="radio1" name="radio_val" value="review_date" ><label for="radio1">등록일순</label>
<input type="radio" id="radio2" name="radio_val" value="review_like"><label for="radio2">좋아요순</label>
<input type="radio" id="radio3" name="radio_val" value="review_star"><label for="radio3">별점순</label>
 
<!-- 검색 -->
<div class="re2_search2" style="float: right;">
<select name="keyfield" id="keyfield" size="1">
	<option value="member_name"> 이름 </option>
	<option value="review_content"> 내용 </option>
</select>
<input id="keyword" type="text" size="15" name="keyword" value="${keyword}">
<input id="kwbtn" type="button" value="검색" onClick="searchCheck()">
</div>
</div>

<!--리뷰 리스트 (ajax) -->  
<div class="paginated">
<div id="re_list">
</div>
</div>
<!--리뷰 리스트 끝-->
</div>


</div></div>
</section>
<div id="footer"></div>    
</body>

</html>

