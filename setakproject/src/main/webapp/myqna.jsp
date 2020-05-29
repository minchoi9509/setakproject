<%@page import="com.spring.community.QnaVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.spring.setak.*" %>   
<%@ page import = "java.text.SimpleDateFormat" %> 
<%
	List<QnaVO> qnalist = (ArrayList<QnaVO>)request.getAttribute("qnalist");
	int nowpage = ((Integer)request.getAttribute("page")).intValue();
	int maxpage = ((Integer)request.getAttribute("maxpage")).intValue();
	int startpage = ((Integer)request.getAttribute("startpage")).intValue();
	int endpage = ((Integer)request.getAttribute("endpage")).intValue();
	int limit = ((Integer)request.getAttribute("limit")).intValue();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-d");

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="./css/default.css"/>
	<link rel="stylesheet" type="text/css" href="./css/myqna.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
	<link rel="shortcut icon" href="favicon.ico">
   
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
    <script type="text/javascript">
      $(document).ready(function(){
    	  var member_id = "<%=session.getAttribute("member_id")%>";
         $("#header").load("./header.jsp")
         $("#footer").load("./footer.jsp")     
      });
    </script>
</head>
<body>
	<div id="header"></div>
	
	<!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
	<section id="test"> <!-- id 변경해서 사용하세요. -->
		<div class="content"> <!-- 변경하시면 안됩니다. -->
		<div class="title-text">
			<h2>Q&A 문의내역</h2>
		</div>
			<div class="mypage_head">
				<ul>
					<li class="mypage-title">마이페이지</li>
					<li>
						<ul class="mypage_list">
							<li>주문관리</li>
							<li><a href="orderview.do">주문/배송현황</a></li>
							<li><a href="mykeep.do">보관현황</a></li>
						</ul>
						<ul class="mypage_list">
							<li>정기구독</li>
							<li><a href="mysub.do">나의 정기구독</a></li>
						</ul>
						<ul class="mypage_list">
							<li>고객문의</li>
							<li><a href="myqna.do">Q&amp;A 문의내역</a></li>
						</ul>
						<ul class="mypage_list">
							<li>정보관리</li>
							<li><a href="profile1.do">개인정보수정</a></li>
							<li><a href="mycoupon.do">쿠폰조회</a></li>
							<li><a href="mysavings.do">적립금 조회</a></li>
							<li><a href="withdraw.do">회원탈퇴</a></li>
						</ul>
					</li>
				</ul>
			</div>
		
				<div class="mypage_content">
				<h2>Q&A 문의내역</h2>
				<%if (qnalist.size() == 0) {%>
					<h3>Q&A 문의내역이 없습니다.</h3>
					
				<%}else{ %>
				<div class="mypage_content_cover">
				<div class="qna-title">
					<div>
						<table class="qna">
							<thead align="center">
								<tr>
									<th>문의유형</th>
									<th>제목</th>
									<th>문의날짜</th>
									<th>답변상태</th>
								</tr>
							</thead>
							<%for (int i=0; i<qnalist.size(); i++){ 
								QnaVO qvo = (QnaVO)qnalist.get(i);
							String date = qnalist.get(i).getQna_date();
							String[] date2 = date.split(" ");
							String date3 = date2[0];
								
							%>
							<tbody align="center">
								<tr>
									<td><%=qvo.getQna_type() %></td>
									<td><a href="./qnaDetail.do?qna_num=<%=qvo.getQna_num() %>" style="color:#3498db; font-weiht:bold;"><%=qvo.getQna_title() %></a></td>
									<td><%=date3 %></td>
									<td><%=qvo.getQna_check() %></td>
								</tr>
							</tbody>					
							<%} %>	
						</table>
					</div>
					</div>
					<div class="page1">
						<table class="page">
							<tr align = center height = 20>
              				<td>
              					<%if(nowpage <= 1) {%>
              				<div class="page_a"><a>&#60;</a></div>
              				<%} else {%>
              					<div class="page_a"><a href ="./myqna.do?page=<%=nowpage-1 %>">&#60;</a></div>
              				<%} %>
              				<%for (int a=startpage; a<= endpage; a++) {
              					if(a==nowpage) {
              						
           					%>
           					<div class="page_a active"><a><%=a %></a></div>
           					<%} else {%>
           						<div class="page_a"><a href="./myqna.do?page=<%=a %>"><%=a %></a></div>
           					<%} %>
           					<%} %>
           					<%if (nowpage >= maxpage) {%>	
           						<div class="page_a"><a>&#62;</a></div>
           					<%} else { %>	
                  				<div class="page_a"><a href ="./myqna.do?page=<%=nowpage+1 %>">&#62;</a></div>
                  			<%} %>	
                  			</td>
               			</tr>
					</table>
					</div>	
				</div>
			</div>
			<%} %>
			</div>
		
	</section>
	<!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
	
	<div id="footer"></div>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
</body>
<script>
    $(function () {
       $(".accordion-header").on("click", function () {
           $(this)
               .toggleClass("active")
               .next()
               .slideToggle(200);
       });
    });
</script>
</html>