<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.spring.member.MemberVO" %>
<%@ page import = "java.util.ArrayList" %>
<%
ArrayList<MemberVO> adminlist = (ArrayList<MemberVO>)request.getAttribute("list");
int limit = ((Integer)request.getAttribute("limit")).intValue();
int nowpage = ((Integer)request.getAttribute("page")).intValue();
int maxpage = ((Integer)request.getAttribute("maxpage")).intValue();
int startpage = ((Integer)request.getAttribute("startpage")).intValue();
int endpage = ((Integer)request.getAttribute("endpage")).intValue();
int listcount = ((Integer)request.getAttribute("listcount")).intValue();
int todaycount = ((Integer)request.getAttribute("todaycount")).intValue();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰 관리자페이지</title>
	<link rel="shortcut icon" href="../favicon.ico">
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	<link rel="stylesheet" type="text/css" href="../css/admin_member.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	
	<!-- datepicker script -->
	<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
	<script src="http://code.jquery.com/jquery-migrate-1.2.1.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	
	<!-- 우편번호 api -->
	<script	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	
	<script type="text/javascript">
	
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#admin").load("./admin.jsp");
			$('#result').css('display', 'none');
			$('#detail-div').css('display', 'none');
			
		
			
		/*팝업 닫기버튼*/
		$(document).on('click', '#detail-close', function(event) {
			$('#detail-div').css('display','none');
			$('.back').css('display','none');
		});
		
		
		/*수정버튼 클릭*/	
		$(document).on('click', '#update', function(event) {
			
			var select_btn = $(this);
			var tr = select_btn.parent().parent();
			var member_id = tr.children().eq(1).children().val();
			var member_memo = tr.children().eq(4).children().val();
			
			var params ={
						 'member_id':member_id,
						 'member_memo':member_memo
			};
			
			$.ajax ({
				url:'/setak/admin/admin_update.do',
				type:'post',
				data:params,
				dataType:'json',
				 contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					success: function(result) {
			        	 if(result.res=="OK") {
			        		 alert("메모수정 성공 : 아이디  "+member_id+"/ 메모  "+member_memo);
			        	 } else {
			        		 alert("메모수정 실패");
			        	 }
			        },
			        error:function() {
			               alert("insert ajax 통신 실패");s
			           }			
			});
			
		});
		
	});
		
		/*검색*/
		function searchUser() {
			$('#result').css('display', 'block');	 
			
			var checkbox = $("input[name=check]:checked");
			
			var statusArr = []; 
			
     		checkbox.each(function(){
     			var status = $(this).val(); 
     			statusArr.push(status);
     		});
     		
     		
     		
     		var start = $('#day1').val();
     		var end = $('#day2').val(); 
     		
     		if(start == ""){
                 start = "2020-01-01"
                 
                 var dateObj = new Date();
                 var year = dateObj.getFullYear();
                 var month = dateObj.getMonth()+1;
                 var day = dateObj.getDate();
                 var today = year + "-" + month + "-" + day; 
                 end = today;
                 
              }           
     		
			$('#result-table tbody').empty();
			
			var param = {
							startDate : start,
							endDate : end,
							statusArr : statusArr, 
							searchType : $('#searchType').val(),
							keyword : $('#keyword').val(),
						};
			
			$.ajax({
				url:'/setak/admin/searchmember.do', 
				type:'POST',
				data:param,
				traditional : true,
				dataType:"json", 
				contentType:'application/x-www-form-urlencoded; charset=utf-8',
				success:function(data) {
					$("#result-table tbody").empty();
					
					// 검색 리스트 갯수
					 $("#r-num").text(data.searchcount);

					 // 검색 리스트 결과 출력
					 var list = data.list;
					 
					 $.each(list, function(index, item) {
						 
						 // 날짜
						 var item_date = item.member_join; 
						 var sysdate = new Date(item_date); // Timestamp 값을 가진 Number 타입 값을 Date 타입으로 변환
						 var sdate = sysdate.toLocaleDateString();
						 
						 var strArray=sdate.split('.');
						 var year2 = strArray[0];
						 var month2 = strArray[1].trim();
						 	if(month2.length != 2) {
						 		month2 ="0"+month2;
						 	}
						 var day2 = strArray[2].trim();
						 	if(day2.length != 2) {
						 		day2 ="0"+day2;
						 	}	
						 
						 var date = year2+"-"+month2+"-"+day2;
						 
						 //메모 
						 var memo = item.member_memo;
						 if(memo == null) {
							 memo = " ";
						 }
						
						 
						 var output = '';
						 
						 output += '<tr>';
						 output += '<td><input type="button" id="search-detail" value="'+item.member_id+'"</td>';						 
						 output += '<td>'+item.member_name+'</td>';						 
						 output += '<td>'+date+'</td>';						 
						 output += '<td><input type="text" id="member_memo" value="'+memo+'"/></td>';						 
						 output += '<td><input type="button" class="search-update"  value="수정"></td>';						 
						 output += '</tr>';
						 
						 $('#result-table tbody').append(output); 
						 
						 $('.record_list').css('display', 'none');	 
						 $('.page').css('display', 'none');	 
					 });
				},
				error: function() {
					alert("ajax통신 실패!!!");
			    }
			});
		};
		
		
		/*검색 - 수정버튼 클릭*/
		$(document).on('click', '.search-update', function(event) {
			var select_btn = $(this);
			var tr = $(this).parent().parent();
			var member_id = tr.children().eq(0).children().val();
			var member_memo = tr.children().eq(3).children().val();
			
			var params ={
						 'member_id':member_id,
						 'member_memo':member_memo
			};
			
			$.ajax ({
				url:'/setak/admin/admin_update.do',
				type:'post',
				data:params,
				dataType:'json',
				 contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					success: function(result) {
			        	 if(result.res=="OK") {
			        		 alert("메모수정 성공 : 아이디  "+member_id+"/ 메모   "+member_memo);
			        	 } else {
			        		 alert("메모수정 실패");
			        	 }
			        },
			        error:function() {
			               alert("insert ajax 통신 실패");s
			           }			
			});
			
		});
		
		
		/*회원상세정보 보기 */
		$(document).on('click', '#search-detail', function(event) {
			$('.back').css('display','block');
			$('#detail-div').css('display','block');
			
			var select_id = $(this).val();
			
			$.ajax ({
				url:'/setak/admin/admin_detail.do',
				type:'post',
				data: {'member_id': select_id },
				dataType:'json',
				 contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					success: function(data) {
						// 검색 리스트 갯수
						 //$("#r-num").text(data.searchcount);
						
						 // 검색 리스트 결과 출력
					 	var list = data.list;
						
						var id = list.member_id; 
						var name = list.member_name;
						var phone = list.member_phone;
						var email = list.member_email;
						var subnum = list.subs_num;
						var zipcode = list.member_zipcode;
						
						var fullloc = list.member_loc;
						
						if (fullloc != null) {
							var strArray=fullloc.split('!');
							var loc = strArray[0];
							var locdetail = strArray[1];
						} else {
							var loc = "";
							var locdetail = "";

						}
						
						$("#detail-id").val(list.member_id);
						$("#detail-name").val(list.member_name);
						$("#detail-phone").val(list.member_phone);
						$("#detail-email").val(list.member_email);
						$("#detail-subnum").val(list.subs_num);
						$("#postcode").val(list.member_zipcode);
						$("#address").val(loc);
						$("#address_detail").val(locdetail);
						
			        },
			        error:function() {
			               alert("insert ajax 통신 실패");
			        }			
			});
			
		});
		
		/*회원상세정보 수정*/
		$(document).on('click', '#detail-update', function(event) {
			var btn_update = $(this).val();

			var address = $('#address').val();
			var address_detail = $('#address_detail').val();
			var loc = address +"!"+address_detail;
			
			var params ={
					 'member_id':$('#detail-id').val(),
					 'member_name':$('#detail-name').val(),
					 'member_phone':$('#detail-phone').val(),
					 'member_email':$('#detail-email').val(),
					 'member_zipcode':$('#postcode').val(),
					 'member_loc':loc,
					 'subs_num':$('#detail-subnum').val()
			};
			
			$.ajax ({
				url:'/setak/admin/detail_update.do',
				type:'post',
				data:params,
				dataType:'json',
				 contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					success: function(result) {
			        	 if(result.res=="OK") {
			        		 alert("회원정보 수정 성공");
			        	 } else {
			        		 alert("회원정보 실패");
			        	 }
			        },
			        error:function() {
			               alert("insert ajax 통신 실패");
			           }			
			});
		});
	
		
	</script>
</head>
<body>
		<div id="admin"></div>
		<div class="content">
			<!-- 여기서부터 작업하세요. -->
			<h1>회원관리</h1>
			<div class ="count">
				  오늘 가입한 회원수 <span><%=todaycount %></span> 명
				     총 회원수 <span>  <%=listcount %></span> 명
			</div>
			
			<!-- 회원검색 -->
			<div class="search">
	
				<h3>회원검색</h3>
				<hr>		
				<form id = "search_form" action = "">
					<table id = "search_table">
						<tr>
							<td class="search-left">검색</td>
							<td class="search-right">
								<select id = "searchType" name = "cate-select">
									<option value = "member_name">회원이름</option>
									<option value = "member_id">회원 아이디</option>
									<option value = "member_memo">내용</option>
								</select>
								<input id = "keyword" type = "text" size = "40px" placeholder = "내용을 입력해주세요." /> 
							</td>
						</tr>
						<tr>
							<td class="search-left">유형</td>
							<td class="search-right">
								<label for = "orderStatus1"><input id="orderStatus1" name = "check" value = "세탁곰" type = "checkbox" >세탁곰</label>
								<label for = "orderStatus2"><input id="orderStatus2" name = "check" value = "네이버"  type = "checkbox">네이버</label>
								<label for = "orderStatus3"><input id="orderStatus3" name = "check" value = "카카오"  type = "checkbox">카카오</label>
								<label for = "orderStatus4"><input id="orderStatus4" name = "check" value = "구글"  type = "checkbox">구글</label>
							</td>
						</tr>
						<tr>
							<td class="search-left">검색일자</td>
							<td class="search-right">
								<input id = "day1" name = "search_start" class = "search-date" type = "text" size = "10px"/>
								<img id="today1" src="../images/today.png">
								~
								<input id = "day2" name = "search_end" class = "search-date" type = "text" size = "10px"/>
								<img id="today2" src="../images/today.png">
								<input type = "button" class = "search-date-btn" name = "member_join" id = "today" value = "오늘"/>
								<input type = "button"  class = "search-date-btn" name = "member_join" id = "today" value = "일주일"/>
								<input type = "button"  class = "search-date-btn" name = "member_join" id = "today" value = "1개월"/>
								<input type = "button"  class = "search-date-btn" name = "member_join" id = "today" value = "3개월"/>
								<input type = "button"  class = "search-date-btn" name = "member_join" id = "today" value = "6개월"/>
							</td>
						</tr>
					</table>
				</form>
				
				<div id="search-btn-div">
					<input type="button" id = "search-btn" value = "검색" onclick = "searchUser();" />
					<input type="button" id ="reset-btn" value="초기화" />
				</div>
				
			</div>
			<!--회원검색 끝 -->
			
			<!--검색 결과 -->				
				<div id="result">
					<!-- 검색 결과 수 div-->
					<div id="result-num-div">
						갯수 <span id = "r-num"></span>
					</div>
					
					<!-- 결과 테이블 div 시작 -->
					<div id=result-div>
				
					<table id="result-table" class = "example">
						<thead>
							<tr>
								<th>아이디</th>
								<th>이름</th>
								<th>가입일</th>
								<th>메모</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
						
						</tbody>
					</table>
				</div>
				<!-- 결과 테이블 div 끝-->
				
			</div>			
			<!-- 결과 결과 끝-->
			
			
			<!-- 전체 회원 리스트 출력 -->
			<table class="record_list"> 
					<tr class="menu">
						<th>NO</th>
						<th>아이디</th>
						<th>이름</th>
						<th>가입일</th>
						<th>메모</th>
						<th>관리</th>
					</tr>
				<%
					for (int i=0; i<adminlist.size(); i++) {
					MemberVO list = (MemberVO)adminlist.get(i);
				%>
					<tr class="content">
						<td><%=i+1 %></td>
						<td><input type ="text" id="search-detail" class="content-id" value="<%=list.getMember_id() %>" readonly></td>
						<td><%=list.getMember_name() %></td>
						<td><%=list.getMember_join() %></td>
						<td>
							<%if( list.getMember_memo() != null) { %>
								<input type="text" id="member_memo" value="<%=list.getMember_memo() %>">
							<% } else { %>
							<input type="text" id="member_memo" value="">
							<%} %>
						</td>
						<td>
							<input type="button" id="update" value="수정" />
							<input type="button" id="delete" value="삭제" />
						</td>
					</tr>
				<%} %>   
			</table>
			<div class="page1">
				<table class="page">
                	<tr>
                    	<td>
                    	<% if(nowpage <= 1) {%>
                    		<span class="page"><a>&#60;</a></span>
                    	 <%} else {%> 
                       		<span class="page">
                       			<a href ="./member.do?page=<%=nowpage-1 %>">&#60;</a>
                       		</span>
                    	 <%} %>
                         	
                    	<%
                    		for (int af=startpage; af<=endpage; af++) {
                    			
                      			if(af==nowpage) {
                    	%>
                       				<span class="page active"><a><%=af %></a></span>
                    			<%} else {%>
                          			<span class="page">
	                       				<a href="./member.do?page=<%=af %>"><%=af %></a>
	                       			</span>
                    			<%} %>
                    		<%} %>
                          
                    	<% if (nowpage >= maxpage) { %> 
                       		<span class="page"><a>&#62;</a></span>
                    	<%} else { %>  
                       		<span class="page"><a href ="./member.do?page=<%=nowpage+1 %>">&#62;</a></span>
                    	<%} %> 
                    	</td>
                    </tr>
              	</table>
			</div>
	        
<!-- 팝업 -->
	<!-- 회원정보 상세보기 -->
	<section id = "detail">
		<div class="back"></div>
		<div class="detail-member" id="detail-div">
			<h3>회원 정보 </h3>
			<span id="detail-close">X</span>
			<table id="detail-table">
				<tr>
					<td class="detail-left">아이디</td>
					<td>
						<input id ="detail-id" type="text" readonly  name="member_id"  />
					</td>
				</tr>
				<tr>
					<td class="detail-left">이름</td>
					<td>
						<input id = "detail-name"  type = "text" name = "member_name" />
					</td>
				</tr>
				<tr>
					<td class="detail-left sum" >구독번호</td>
					<td>
						<input id = "detail-subnum" type = "text" name = "subs_num" />
					</td>
				</tr>
				<tr>
					<td class="detail-left">핸드폰</td>
					<td>
						<input id = "detail-phone"  type = "text" name = "member_phone" />
					</td>
				</tr>
				<tr>
					<td class="detail-left">이메일</td>
					<td>
						<input id = "detail-email" type = "text" name = "member_email" />
					</td>
				</tr>
				<tr>
					<td class="detail-left">주소</td>
					<td>
						<input id="postcode" type="text" style="width: 60px;" /> 
                        <input type="button" id="locbtn" onclick="execDaumPostcode()" value="우편번호 찾기"> <br /> 
                        <input id="address" class="txtInp" type="text"  readonly /> 
                        <input id="address_detail" class="txtInp" type="text" placeholder="상세 주소를 입력해주세요." /> 
                        <input id="extraAddress" type="hidden" placeholder="참고항목">
                    </td>
				</tr>
			</table>
			<button id="detail-update" >수정</button>
		</div>
	</section>	
	
	</div><!-- 지우지마세요 -->
</body>
<script type="text/javascript">
	
      $(document).ready(function(){
         //달력1
		$("#day1").datepicker ({
		  	dateFormat: 'yy-mm-dd', // 텍스트 필드에 입력되는 날짜 형식.
		  	prevText:'이전 달',
		  	nextText:'다음 달',
		  	monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		  	dayNamesMin:['일','월','화','수','목','금','토'],
		  	changeMonth:true, //월을 바꿀 수 있는 박스를 표시한다
		  	changeYear:true,
		  	showMonthAfterYear:true, //월, 년 순의 박스를 년, 월 순으로 바꿔준다
		  	yearRange:'c-100:c'// 년도 선택 박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할 것인가?
	 	 });
		
		//달력1 아이콘으로 포커스하기
		$('#today1').click(function(){
			$("#day1").focus();
		});
		
		 //달력1
		$("#day2").datepicker ({
		  	dateFormat: 'yy-mm-dd', // 텍스트 필드에 입력되는 날짜 형식.
		  	prevText:'이전 달',
		  	nextText:'다음 달',
		  	monthNamesShort:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		  	dayNamesMin:['일','월','화','수','목','금','토'],
		  	changeMonth:true, //월을 바꿀 수 있는 박스를 표시한다
		  	changeYear:true,
		  	showMonthAfterYear:true, //월, 년 순의 박스를 년, 월 순으로 바꿔준다
		  	yearRange:'c-100:c'// 년도 선택 박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할 것인가?
	 	 });
		//달력2 아이콘으로 포커스하기
		$('#today2').click(function(){
			$("#day2").focus();
		});
      
      
		// 초기화 버튼
		$("#reset-btn").on("click", function() {
			$("#searchType").val("member_name"); 
			$("#keyword").val(""); 
			$("input[name=check]").prop("checked",false);
            $('#day1').val("");
            $('#day2').val("");
		});
		
		//요일 버튼 누르기
		$(".search-date-btn").on("click", function() {
			
			var select_btn = $(this).val(); 
			
			if(select_btn == '오늘') {
	            $('#day1').datepicker('setDate', 'today');
	            $('#day2').datepicker('setDate', 'today');
			}else if(select_btn == '일주일') {
	            $('#day1').datepicker('setDate', '-7D');
	            $('#day2').datepicker('setDate', 'today');					
			}else if(select_btn == '1개월') {
	            $('#day1').datepicker('setDate', '-1M');
	            $('#day2').datepicker('setDate', 'today');					
			}else if(select_btn == '3개월') {
	            $('#day1').datepicker('setDate', '-3M');
	            $('#day2').datepicker('setDate', 'today');					
			}else if(select_btn == '6개월') {
	            $('#day1').datepicker('setDate', '-6M');
	            $('#day2').datepicker('setDate', 'today');					
			}else {
	            $('#day1').datepicker('setDate', '-1Y');
	            $('#day2').datepicker('setDate', 'today');					
			}
			
		});
      
      });
    //우편번호 api
      function execDaumPostcode() {
          new daum.Postcode({
              oncomplete: function(data) {
                  // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                  // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                  // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                  var addr = ''; // 주소 변수
                  var extraAddr = ''; // 참고항목 변수

                  //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                  if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                      addr = data.roadAddress;
                  } else { // 사용자가 지번 주소를 선택했을 경우(J)
                      addr = data.jibunAddress;
                  }

                  // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                  if(data.userSelectedType === 'R'){
                      // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                      // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                      if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                          extraAddr += data.bname;
                      }
                      // 건물명이 있고, 공동주택일 경우 추가한다.
                      if(data.buildingName !== '' && data.apartment === 'Y'){
                          extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                      }
                      // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                      if(extraAddr !== ''){
                          extraAddr = ' (' + extraAddr + ')';
                      }
                      // 조합된 참고항목을 해당 필드에 넣는다.
                      document.getElementById("extraAddress").value = extraAddr;
                  
                  } else {
                      document.getElementById("extraAddress").value = '';
                  }

                  // 우편번호와 주소 정보를 해당 필드에 넣는다.
                  document.getElementById("postcode").value = data.zonecode;
                  document.getElementById("address").value = addr;
                  // 커서를 상세주소 필드로 이동한다.
                  document.getElementById("address_detail").focus();
              }
          }).open();
      };
		
</script>
</html>
