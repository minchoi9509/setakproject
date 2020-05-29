<%@page import="com.spring.community.QnaVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.spring.setak.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>

<%
	String member_id = (String)session.getAttribute("member_id");
	String member_name = (String)session.getAttribute("member_name");	
	
	HashMap<String, Object> qnaMap = (HashMap<String, Object>)request.getAttribute("qnaMap");
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<!-- include summernote css/js-->
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-lite.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-lite.js"></script>
<!-- include summernote-ko-KR -->
<script src="/js/summernote-ko-KR.js"></script>


<script type="text/javascript">
$(document).ready(function(){
    $("#header").load("header.jsp")
    $("#footer").load("footer.jsp") 
	
    $("input[name=qna_type][value='<%=qnaMap.get("qna_type")%>']").prop('checked', true);
    
	var filecontent;
	var filename="";
	
	$("#qna_file").change(function(){
		filecontent = $(this)[0].files[0];
		filename = Date.now() + "_" + $(this)[0].files[0].name;
	});
	
	$("#update-form").on("submit", function() {
		if(!formCheck()){
			event.preventDefault();
		}
	});

	$('#summernote').summernote({
	        placeholder: 'content',
	        minHeight: 370,
	        maxHeight: null,
	        focus: true, 
	        lang : 'ko-KR'
	});	
	
	// 한글 금지, 영문 금지 
	$("#qna_pass").on("keyup", function() { 
		$(this).val($(this).val().replace(/[^0-9]/g,"")); 
	});
	
});

// form 공백 체크
function formCheck(){	
	
	if (document.getElementById('qna_title').value==""){
		Swal.fire("","제목을 입력하세요.","info");
        document.getElementById('qna_title').focus();
        return false;
    }else if (document.getElementById('summernote').value==""){
		Swal.fire("","내용을 입력하세요.(최대 500자)","info");
        document.getElementById('summernote').focus();
        return false;
    }else if(document.getElementById('qna_pass').value==""){
		Swal.fire("","비밀번호를 입력하세요.(숫자 최대 4자)","info");
        document.getElementById('qna_pass').focus();
        return false;
    }
	
	return true;
}

function updateCancel(){
    Swal.fire({
    	  text: "수정을 취소하시겠습니까?",
    	  icon: 'warning',
    	  showCancelButton: true,
    	  confirmButtonColor: '#3085d6',
    	  cancelButtonColor: '#d33',
    	  confirmButtonText: '네, 취소하겠습니다.',
  	  cancelButtonText: '아니요'
    	}).then((result) => {
    	  if (result.value) {
    		  location.href='./qnaDetail.do?qna_num=<%=qnaMap.get("qna_num")%>';
   	  }else {
   		 event.preventDefault();
   	  }
   	});
}
 
</script>
</head>
<body>
<div id="header"></div>
<section id="qna">
<div class="content">
<div class="title-text"><h2><a href="./qnaList.do">Q&A</a></h2></div>
<div class="qna">

<form id="update-form" action="./updateQna.do" method="post" enctype="multipart/form-data">
	<input type="hidden" name="qna_num" value="<%=qnaMap.get("qna_num")%>">
	<table class="update-table">
		<tr>
			<td>작성자</td>		
			<td colspan="2">
				<span class = "txt-span"><%=member_name%></span>
				<input value="<%=member_id%>" type="hidden" name="member_id">
			</td>
		</tr>
		<tr>
			<td>문의유형</td>
			<td colspan="2" class="qwr">
				<div>			
					<input type="radio" id="type1" name="qna_type" value="주문 취소"><label for="type1">주문 취소</label>
					<input type="radio" id="type2" name="qna_type" value="배송 문의 "><label for="type2">배송 문의 </label>
					<input type="radio" id="type3" name="qna_type" value="적립금"><label for="type3">적립금</label>
					<input type="radio" id="type4" name="qna_type" value="서비스이용"><label for="type4">서비스이용</label>
					<input type="radio" id="type5" name="qna_type" value="회원정보"><label for="type5">회원정보</label>
					<input type="radio" id="type6" name="qna_type" value="기타"><label for="type7">기타</label>			
				</div>
			</td>
		</tr>
		<tr>
			<td>주문번호</td>
			<td colspan="2">
				<span class = "txt-span">
					<% 
					String order_num = String.valueOf(qnaMap.get("order_num")); 
					if(order_num.equals("0")) {
					%>
					선택 없음
					<%}else { %>
						<%=order_num %>
					<%} %>
					
				</span>
			</td>
		</tr>
		<tr>
			<td>제 목</td>
			<td colspan="2">
				<input id="qna_title" name="qna_title" type="text" size="50" maxlength="100" value="<%=qnaMap.get("qna_title")%>">
			</td>
		</tr>
		<tr>
			<td>내 용</td>
			<td colspan="2">
				<textarea id="summernote" name="qna_content">
					<%=qnaMap.get("qna_content") %>
				</textarea>
			</td>
		</tr>	
		<tr>
			<td>파일첨부</td>		
			<td colspan="2">
				<input type="hidden" name="exist_file" value="<%=qnaMap.get("qna_file")%>">
				<input value="<%
				String qna_file = (String) qnaMap.get("qna_file");
				if(!(qna_file==null)){ 
					int i = qna_file.indexOf("_");%><%=qna_file.substring(i+1).trim()%>
				<%}else{ 
				%>파일이 존재하지 않습니다 .<%}%>" disabled="disabled">
				<input type="file" class="padding-5" />
				<input type="hidden" class="padding-5" name="qna_file" >		
			</td>
		</tr>		
		<tr > 
			<td>비밀번호</td>
			<td><input id="qna_pass" name="qna_pass" type="password" maxlength="4"/></td>							
			<td>
				<input id="qna_scr" name="qna_scr" type="radio" value="공개"/><label for="qna_scr">공 개</label>			
				<input id="qna_scr2" name="qna_scr" type="radio" value="비공개" checked="checked"/><label for="qna_scr2">비공개 </label>
			</td>					
		</tr>			
		<tr>
			<td colspan="3" align="center" valign="middle">
				<input class="btn" type="submit" name="submit" value="등록" >			
				<input class="btn" type="button" name="cancel" value="취소" onclick="updateCancel();">		
			</td>
		</tr>
	</table>			
</form>
</div></div>
</section>
<div id="footer"></div> 
</body>
</html>
