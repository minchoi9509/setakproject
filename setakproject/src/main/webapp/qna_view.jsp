<%@page import="com.spring.community.QnaVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<%@ page import="com.spring.setak.*, java.util.*" %>

<%
	HashMap<String, Object> qnaMap = (HashMap<String, Object>)request.getAttribute("qnaMap");
	String member_id = (String) qnaMap.get("member_id"); 
	String session_id= (String)session.getAttribute("member_id");
	boolean isWriter = false; 
	if(member_id.equals(session_id)) { isWriter = true; };	
	String qna_scr = (String) qnaMap.get("qna_scr");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1" >
<title>세탁곰</title>
<link rel="shortcut icon" href="favicon.ico">

<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="./css/default.css"/>
<link rel="stylesheet" type="text/css" href="./css/qna.css"/>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>
$(document).ready(function() {
	$("#header").load("header.jsp")
    $("#footer").load("footer.jsp")  
    
    getReplyList(); 
	
	var session_id = '<%=session_id%>';
    var isWriter = <%=isWriter%>;

    
    $("#updateBtn").on("click", function() {
        var qna_scr = '<%=qna_scr%>';
        if(session_id == 'null') {
    		Swal.fire({
    			text: "로그인 이후 이용해주세요.",
    			icon: "info",
    		}) .then(function(){
    			location.href='login.do';
    		});  
        }else {
            if(!isWriter) {
            	Swal.fire("","작성자만 글을 수정 할 수 있습니다.","info");
            }else {
            	var reply_cnt = $(".reply-cnt").text();
            	if(reply_cnt > 0) {
            		Swal.fire("","답변이 작성 된 글은 수정 할 수 없습니다.","info");
            	}else {
                	if(qna_scr == "공개") {
                		location.href='./qnaPass.do?qna_num=<%=qnaMap.get("qna_num") %>&type=update';	
                	}else {
                		location.href='./updateForm.do?qna_num=<%=qnaMap.get("qna_num")%>';
                	}	
            	}
            }		
        }
    }); 
    
    $("#deleteBtn").on("click", function() {
        var qna_scr = '<%=qna_scr%>';
        if(session_id == 'null') {
    		Swal.fire({
    			text: "로그인 이후 이용해주세요.",
    			icon: "info",
    		}) .then(function(){
    			location.href='login.do';
    		});  
        }else {
            if(!isWriter) {
            	Swal.fire("","작성자만 글을 삭제 할 수 있습니다.","info");
            }else {
            	var reply_cnt = $(".reply-cnt").text();
            	if(reply_cnt > 0) {
            		Swal.fire("","답변이 작성 된 글은 삭제 할 수 없습니다.","info");
            	}else {
            		location.href='./qnaPass.do?qna_num=<%=qnaMap.get("qna_num") %>&type=delete';	
            	}	
            	
            }		
        }
    }); 
    
    // 댓글 입력 
    $(".reply-origin-btn").on("click", function() {
    	var reply_content = $(".reply-text").val(); 
    	
        if(session_id == 'null') {
    		Swal.fire({
    			text: "로그인 이후 이용해주세요.",
    			icon: "info",
    		}) .then(function(){
    			location.href='login.do';
    		});  
        }else {
            if(!isWriter) {
            	Swal.fire("","작성자만 댓글을 입력 할 수 있습니다.","info");
            }else {
            	if(reply_content == '') {
            		Swal.fire("","내용을 입력해주세요.","info");
            	}else {
            		
            		var param = $("#reply-origin").serialize(); 
                	$.ajax({
                		type : 'POST',
                		url : '/setak/insertReply.do',
                		data : param,
                		dataType : 'text',
                		contentType:'application/x-www-form-urlencoded; charset=utf-8',
            			success:function(){
            				getReplyList(); 
            			},
            			error:function() {
            				alert("Ajax 통신 실패");
            			}
                	});
            	}
            }		
        }

    });
    
    // 댓글 수정 버튼 클릭
    $(document).on('click','.reply-update',function(){
    	$('.reply-update-content').val(''); 
    	
		var tr = $(this).parent().parent().parent(); 
        
		$("#reply-tr").css('display', 'none');
        $("#reply-update-tr").css('display', 'table-row');
        $("#reply-update-tr").insertAfter(tr);
        
        var content = $(this).next().next().next().text();
        $('.reply-update-content').val(content); 
     });
    
    // 댓글 수정 과정
    $(document).on('click','.reply-update-btn',function(){
    	var reply_content =  $('.reply-update-content').val(); 
    	
    	var tr = $(this).parent().parent().prev();
    	var reply_seq = tr.attr('name');

    	var param = { 
    			'reply_seq' : reply_seq,
    			'reply_content' : reply_content
    	};

    	$.ajax({
    		type : 'POST',
    		url : '/setak/updateReply.do',
    		data : param,
    		dataType : 'text',
    		contentType:'application/x-www-form-urlencoded; charset=utf-8',
			success:function(){
				getReplyList(); 				
			},
			error:function() {
				alert("Ajax 통신 실패");
			}
    	});    	
    }); 
    
    // 댓글 삭제 
    $(document).on('click','.reply-delete',function(){
    	
    	var reply_group = $(this).attr('name');
    	var tr = $(this).parent().parent().parent();
    	var reply_seq = tr.attr('name');
    	
    	var param = { 
    			'reply_seq' : reply_seq,
    			'reply_group' : reply_group
    	};    	

    	$.ajax({
    		type : 'POST',
    		url : '/setak/deleteReply.do',
    		data : param,
    		dataType : 'json',
    		contentType:'application/x-www-form-urlencoded; charset=utf-8',
			success:function(data){
				if(data.res == 'success') {
					getReplyList(); 									
				}else {
	            	Swal.fire("","댓글이 달린 글은 삭제 할 수 없습니다.","info");
				}
			},
			error:function() {
				alert("Ajax 통신 실패");
			}
    	});
    	
    }); 
    
    // 댓글 대댓글 버튼 클릭
    $(document).on('click','.reply-btn',function(){
    	$('.reply-re-content').val(''); 
    	
		var tr = $(this).parent().parent().parent(); 
		
		$("#reply-update-tr").css('display', 'none');
        $("#reply-tr").css('display', 'table-row');
        $("#reply-tr").insertAfter(tr);        
  
    }); 
    
    // 댓글 대댓글 등록 과정
    $(document).on('click','.reply-re-btn',function(){

    	var reply_content =  $('.reply-re-content').val(); 
    	
    	var tr = $(this).parent().parent().prev();
    	var reply_group = tr.attr('class');
    	
    	var param = {
    		'member_id' : '<%=member_id%>',
    		'qna_num' : <%=qnaMap.get("qna_num")%>,
    		'reply_content' : reply_content,
    		'reply_group' : reply_group
    	}
    	
    	$.ajax({
    		type : 'POST',
    		url : '/setak/insertReReply.do',
    		data : param,
    		dataType : 'text',
    		contentType:'application/x-www-form-urlencoded; charset=utf-8',
			success:function(){
				getReplyList(); 
			},
			error:function() {
				alert("Ajax 통신 실패");
			}
    	});
    	
    }); 
    
    Date.prototype.yymmdd = function() {
  	  var yy = this.getFullYear();
  	  var mm = this.getMonth() < 9 ? "0" + (this.getMonth() + 1) : (this.getMonth() + 1); // getMonth() is zero-based
  	  var dd = this.getDate() < 10 ? "0" + this.getDate() : this.getDate();
  	  return "".concat(yy+'.').concat(mm+'.').concat(dd);
  	};

  	Date.prototype.yyyymmddhhmm = function() {
  	  var yymmdd = this.yymmdd();
  	  var hh = this.getHours() < 10 ? "0" + this.getHours() : this.getHours();
  	  var min = this.getMinutes() < 10 ? "0" + this.getMinutes() : this.getMinutes();
  	  return "".concat(yymmdd+' ').concat(hh+':').concat(min);
  	};
  	
	
    // 댓글 리스트
    function getReplyList() {
    	
    	var qna_num = <%=qnaMap.get("qna_num")%>;
    	var param = { 
    			'qna_num' : qna_num 
    			};
    	$('.reply-table tbody').empty();
    	
    	$.ajax({
    		type : 'POST',
    		url : '/setak/getReplyList.do',
    		data : param,
    		dataType : 'json',
    		contentType:'application/x-www-form-urlencoded; charset=utf-8',
			success:function(data){
				$.each(data, function(index, item){
					var output = ''; 
					var date = new Date(item.reply_date);
					var order = item.reply_order;
					
					var member_id = item.member_id; 
					
					output += '<tr class="'+item.reply_group+'" name="'+item.reply_seq+'">';
					if(order > 0) {
						output += '<td class = "reply-arrow">ㄴ</td><td>'; 
					}else {
						output += '<td colspan = "2">'
					}
					output += '<span class = "reply-writer">글쓴이</span>';
					output += '<span class = "reply-date">'+date.yyyymmddhhmm();+'</span>';
					
					if(item.reply_delete != 1) {
						output += '<img src="https://img.icons8.com/ultraviolet/12/000000/right3.png"/><span class = "reply-btn">답글</span>'
						if(session_id == member_id) {
							output += '<span class = "reply-update">수정</span>';
							output += '<span class = "reply-delete" name = "'+item.reply_group+'">삭제</span>';								
						}
						
					}
					
					if(item.reply_update == 1 && item.reply_delete == 0) {
						output += '<p class = "update-notice">수정 된 글입니다.</p><p class = "reply-content">'+item.reply_content+'</p>';
						output += '</td></tr>'
					}else {
						output += '<p></p><p class = "reply-content">'+item.reply_content+'</p></td></tr>';						
					}
						
					$('.reply-table tbody').append(output); 
				});
				
				var output = ''; 
				output += '<tr id = "reply-update-tr"><td colspan = "2"><textarea class = "reply-update-content" name="reply_content" /></textarea>';
				output += '<input class = "reply-update-btn" type = "button" value = "수정"></td></tr>';
				output += '<tr id = "reply-tr"><td colspan = "2"><textarea class = "reply-re-content" name="reply_content" /></textarea>';
				output += '<input class = "reply-re-btn" type = "button" value = "등록"></td></tr>';

				$('.reply-table tbody').append(output);
				
				getReplyCount(); 
				
			},
			error:function() {
				alert("Ajax 통신 실패");
			}
    	});
    	
    }
    
    // 댓글 개수 카운트
    function getReplyCount() {
    	
    	var qna_num = <%=qnaMap.get("qna_num")%>;
    	var param = { 
    			'qna_num' : qna_num 
    			};
    	
    	$.ajax({
    		type : 'POST',
    		url : '/setak/getReplyCount.do',
    		data : param,
    		dataType : 'json',
    		contentType:'application/x-www-form-urlencoded; charset=utf-8',
			success:function(data){
				
				$(".reply-cnt").text(data.cnt); 
				
			},
			error:function() {
				alert("Ajax 통신 실패");
			}
    	});
    	
    }
    
});

</script>

</head>
<body>
<div id="header"></div>
<section id="qna">
<div class="content">
<div class="title-text"><h2><a href="./qnaList.do">Q&A</a></h2></div>
<div class="qna">

<table class="view-table">
	<tr>					
		<td>
			<p>문의유형 </p>:<small><%=(String) qnaMap.get("qna_type")%></small>
		</td>			
		<td>
			제목 : <%=qnaMap.get("qna_title")%>
			<small> &nbsp; 주문번호 : 
				<%
					String order_num = String.valueOf(qnaMap.get("order_num")); 
				if(order_num.equals("0")) {%>
					-
				<%} else{%>
					<%=order_num%>
				<%}%>
			</small>
		</td>		
		<td> 작성자 :&nbsp;<small><%=qnaMap.get("member_name") %></small></td>					
	</tr>
	<tr>			
		<td class = "view-content" colspan="3">
			<img src="https://img.icons8.com/dusk/25/000000/q.png"/>
			<img src="https://img.icons8.com/dusk/5/000000/sphere.png"/> 
			<br/>		
			<%=qnaMap.get("qna_content")%>	
					
			<div class="thumbnail-wrapper">
			  <div class="thumbnail">			    
			    	<% String qna_file = (String) qnaMap.get("qna_file"); 
			    	if(!qna_file.split("_")[0].equals("등록한 파일이 없습니다.")){ 
			    	
			    	%>
			      		<img class="thumbnail-img" src="https://kr.object.ncloudstorage.com/airbubble/setakgom/qna/<%=qna_file%>"  
			      		onclick="window.open('https://kr.object.ncloudstorage.com/airbubble/setakgom/qna/<%=qna_file%>', 'new', 'width=800, height=600, left=500, top= 100, scrollbars=no');">								
			      	<%} %>			    
			  </div>
			</div>
		</td>						
	</tr>
</table>
<div id = "reply-div">
댓글 <b><span class = "reply-cnt"></span></b>개
<table class = "reply-table">
	<tbody></tbody>
</table>
<form id = "reply-origin">
	<input type = "hidden" name = "qna_num" value = "<%=qnaMap.get("qna_num") %>"/>
	<input type = "hidden" name = "member_id" value = "<%=member_id%>" />
	<textarea name = "reply_content" class = "reply-text"></textarea>
	<input class = "reply-origin-btn" type = "button" value = "등록" />
</form>
</div>

<div id = "btn-div">
	<input id = "updateBtn" class = "btn btn-right" type = "button" value = "수정"/>
	<input id = "deleteBtn" class = "btn btn-right" type = "button" value = "삭제"/>
	<input class = "btn" type = "button" value = "글목록" onclick="location.href='./qnaList.do'"/>
	
</div>

</div></div>
</section>
<div id="footer"></div> 
</body>
</html>