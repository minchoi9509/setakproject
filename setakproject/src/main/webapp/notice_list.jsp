<%@page import="com.spring.community.NoticeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "com.spring.setak.*"%>

<%
	ArrayList<NoticeVO> noticeList = (ArrayList<NoticeVO>)request.getAttribute("noticelist");	
	int listcount = ((Integer)request.getAttribute("listcount")).intValue();
	int nowpage = ((Integer)request.getAttribute("page")).intValue();
	int maxpage = ((Integer)request.getAttribute("maxpage")).intValue();
	int startpage = ((Integer)request.getAttribute("startpage")).intValue();
	int endpage = ((Integer)request.getAttribute("endpage")).intValue();
	int limit = ((Integer)request.getAttribute("limit")).intValue();	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1">
<title>세탁곰</title>
<link rel="shortcut icon" href="favicon.ico">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="./css/default.css"/>
<link rel="stylesheet" type="text/css" href="./css/notice.css"/>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
    $("#header").load("./header.jsp")
    $("#footer").load("./footer.jsp")     
 });

</script>
</head>
<body>
	<div id="header"></div>
	<section id="notice">
	<div class="content">
		<div class = title-text>
			<h2>Notice</h2><small>공지사항</small>
		</div>
<div class="notice">

<table class="nlt1">	
	<tr>
		<td width="10%">번 호</td>
		<td width="80%">제 목</td>
		<td width="10%">날 짜</td>
	</tr>
</table>
		
<%if (listcount > 0){ %>
	<% for (int i=0; i<noticeList.size(); i++) 
	{ NoticeVO bl = (NoticeVO)noticeList.get(i); %>
<table class="nlt2">		
	<tr align="center" valign="middle" onmouseover="this.style.backgroundColor='#e6f8fc'" onmouseout="this.style.backgroundColor=''" >
		<td height="40px" width="10%"><%=((listcount - ((nowpage-1) * 10))- i) %></td>
		<td width="80%"> 
			<div  id="no_title" align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a  href="./getDetail.do?notice_num=<%=bl.getNotice_num() %>">
			<%=bl.getNotice_title() %></a></div></td>
		<td width="10%"><div id="no_date" align="center"><%=bl.getNotice_date().substring(0,11) %></div></td>
	</tr>
</table>
<%}%>
<table class="nlt3">	
<tr align=center height="40px">
<td colspan=7 >
<%if(nowpage<=1) {%>
<a>&lt;</a>
<%}else{%>
<a href="./noticeList.do?page=<%=nowpage-1 %>" >&lt;</a>
<%}
	for (int a=startpage; a<=endpage; a++){ 
		if(a==nowpage) { %>
		<a class="page active"><%=a %></a>
		<%}else{%>
		<a href="./noticeList.do?page=<%=a %>"><%=a %></a>
		<%}%>
<%}%>
<%if(nowpage >= maxpage ) { %>
<a>&gt;</a>
<%}else{%><a href="./noticeList.do?page=<%=nowpage+1 %>" >&gt;</a>
<%}%>
</td>
</tr>
</table>		
	<%
	} else {
	%>	
<table class="nlt2">	
<tr align="center" valign="middle">
	<td colspan="4"> 공 지 사 항  </td>
	<td align=right><font size=2>등록된 글이 없습니다.</font></td>
</tr>
<% } %>
</table>
<br>


</div></div></section>
<div id="footer"></div> 
</body>
</html>


