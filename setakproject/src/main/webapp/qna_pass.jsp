<%@ page import="com.spring.community.QnaVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "com.spring.community.*"%>   
<%
	int qna_num = Integer.parseInt(request.getParameter("qna_num")); 
	String type = (String) request.getParameter("type");
	String enter = (String) request.getParameter("enter"); 
	String session_id = (String) session.getAttribute("member_id");
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
<script src="https://kit.fontawesome.com/4b95560b7c.js" crossorigin="anonymous"></script>

<script type="text/javascript">
$(document).ready(function(){
    $("#header").load("header.jsp")
    $("#footer").load("footer.jsp")  
    
    var enter = '<%=enter%>';
    if(enter == 'again') {
    	$(".pass-p").text("비밀번호를 확인 후 다시 입력해주세요."); 
    	$(".pass-p").css("color", "red");
    	$(".pass-p").css("font-weight", "bold");
    }
});


function formCheck(){	
	if (document.getElementById('enterPass').value=="") {
		Swal.fire("","비밀번호를 입력하세요.","info");
        document.getElementById('enterPass').focus();
        return false;
    }
	
	return true; 
}
	

</script>

</head>
<body>
<div id="header"></div>t
<section id="qna">
<div class="content">
<div class="title-text"><h2>Q&A</h2></div>
<div class="qna">

<div>
	<div id="pass-div">
		<p class = "pass-p">비밀번호를 입력하세요</p>
		<div id="pass-form-div">
			<form action="./qnaCheckPass.do" method="post" enctype="multipart/form-data">
				<input type="hidden" name="qna_num" value="<%=qna_num%>">		
				<input type="hidden" name="type" value="<%=type%>">		
				<input id="enterPass" type="password" name="qna_pass" placeholder="비밀번호" maxlength="4">
				<input class = "btn" type="submit" onclick="formCheck()" value="확인">						
			</form>
		</div>
	</div>
</div>	

</div></div>
</section>
<div id="footer"></div> 
</body>
</html>