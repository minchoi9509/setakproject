<%@page import="com.spring.community.QnaVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "com.spring.setak.*"%>

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

<%
	ArrayList<HashMap<String, Object>> qnaList = (ArrayList<HashMap<String, Object>>)request.getAttribute("qnaList");
	int currentpage = (int)request.getAttribute("currentpage");
	int startpage = (int)request.getAttribute("startpage");
	int endpage = (int)request.getAttribute("endpage");
	int maxpage = (int)request.getAttribute("maxpage");
%>

<script type="text/javascript">
$(document).ready(function(){
    $("#header").load("header.jsp")
    $("#footer").load("footer.jsp")
    
    var member_id = '<%=session.getAttribute("member_id")%>';
    $("#write-btn").on("click", function() {
    	if(member_id == "null") {
    		Swal.fire({
    			text: "로그인 하신 후 글을 작성하실수 있습니다.",
    			icon: "info",
    		}) .then(function(){
    			location.href='login.do';
    		});    		
    	}else {
    		location.href='./qnaWrite.do';
    	}
    });
});

</script>
</head>
<body>
<div id="header"></div>
<section id="qna">
<div class="content">
<div class="title-text"><h2>Q&A</h2></div>
<div class="qna">
<table class="qna-table">
	<thead>	
		<tr>
			<th>번호</th>
			<th>문의유형</th>
			<th>제목</th>
			<th>작성자</th>
			<th>작성일</th>
		</tr>
	</thead>
	<tbody>
		<% for(int i = 0; i < qnaList.size(); i++) { 
			HashMap<String, Object> qna = qnaList.get(i);
			String[] dateArr = qna.get("qna_date").toString().split(" ");
			String date = dateArr[0]; 
			
			String scr = qna.get("qna_scr").toString();
		%>
			<tr>
				<td><%=qna.get("rnum") %></td>
				<td><%=qna.get("qna_type") %></td>
				<td class = "table-title">
					<%if(scr.equals("공개")) { %>
					<a href='./qnaDetail.do?qna_num=<%=qna.get("qna_num")%>'><%=qna.get("qna_title")%><span class = "reply_cnt">[<%=qna.get("reply_cnt")%>]</span></a>
					<%}else { %>
					<a href='./qnaPass.do?qna_num=<%=qna.get("qna_num")%>&type=view'%>
						<img src="https://img.icons8.com/ultraviolet/25/000000/lock.png"/>
						&nbsp; &nbsp; 비밀글입니다.
					</a>
					<%} %>
				</td>
				<td><%=qna.get("member_name") %></td>
				<td><%=date%></td>
			</tr>
		<%} %>
	</tbody>
</table>

<input id="write-btn" type = "button" class = "btn btn-right" value = "글작성"/>

</div>
<div class = "qna-paging">
	<%if(currentpage == 1) { %>
		<a>&lt;</a>
	<%}else {%>
		<a href = "./qnaList.do?page<%=currentpage-1%>">&lt;</a>
	<%} %>
	<%for(int i = startpage; i <= endpage; i++) {
		if(i == currentpage){%>
			<a class="page active" href=""><%=i %></a>
		<%}else {%>
			<a href="./qnaList.do?page=<%=i%>"><%=i %></a>
		<%} %>
	<%} %>
	<%if(currentpage >= maxpage) { %>
		<a>&gt;</a>
	<%}else { %>
		<a href="./qnaList.do?page=<%=currentpage+1%>">&gt;</a>
	<%} %>
</div>
</div>
</section>
<div id="footer"></div> 
</body>
</html>
