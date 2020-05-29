<%@page import="javax.websocket.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.spring.member.MemberSubVO"  %>    
<%@ page import="com.spring.member.HistorySubVO" %>
<%@ page import="com.spring.member.SubscribeVO" %>
<%@ page import="com.spring.member.MemberVO" %>
<%@ page import = "java.util.ArrayList" %>
<%
	MemberSubVO sub_list = (MemberSubVO) request.getAttribute("sub_list");
	SubscribeVO subscribe = (SubscribeVO) request.getAttribute("subscribe");
	MemberVO name = (MemberVO) request.getAttribute("name");
	ArrayList<HistorySubVO> list = (ArrayList<HistorySubVO>)request.getAttribute("subhistory_list");
	int limit = ((Integer)request.getAttribute("limit")).intValue();
	int nowpage = ((Integer)request.getAttribute("page")).intValue();
	int maxpage = ((Integer)request.getAttribute("maxpage")).intValue();
	int startpage = ((Integer)request.getAttribute("startpage")).intValue();
	int endpage = ((Integer)request.getAttribute("endpage")).intValue();
	int listcount = ((Integer)request.getAttribute("listcount")).intValue();
%>	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>세탁곰</title>
<link rel="stylesheet"	href="https://use.fontawesome.com/releases/v5.4.1/css/all.css"	integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="./css/default.css" />
<link rel="stylesheet" type="text/css" href="./css/mysub.css" />
<link rel="stylesheet" type="text/css" href="./css/review.css" />
<link rel="shortcut icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<script type="text/javascript">
	
	$(document).ready(function() {
		$("#header").load("./header.jsp")
		$("#footer").load("./footer.jsp")
		
		      <% if(sub_list != null) {%>
		         
		         //수거취소
		         var subs_cancel = <%=sub_list.getSubs_cancel() %>;
		         if(subs_cancel=="0") { //수거고 
		        	 $("#go").css('display', 'block');
					 $("#cancle").css('display', 'none');
		         
		         } else if(subs_cancel=="2") { // 수거취소 가능
		        	 $("#go").css('display', 'none');
					 $("#cancle").css('display', 'block');
		       
		         } else  { // 수거취소 불가능 sub_cancel =="1"
		        	$("#go").css('display', 'none');
					$("#cancle").css('display', 'block');
		            $('#cancle').css('background-color','#e1e4e4');
		            $('#cancle').css('color','#444');
		            $("#cancle").css({ 'pointer-events': 'none' });// 버튼 비활성화
		         };
		         
		         //구독해지
		         var subs_bye = <%=sub_list.getSubs_bye() %>;
		         if(subs_bye =="0") { // 취소 가능 
		            $("#sub").css("display","block");
		            $('#re-sub').css("display","none");
		         } else { // 취소 불가능 
		            $('#re-sub').css("display","block");
		            $('#sub').css("display","none");
		         }
		         
		       <% }%>
		       
		     //수거고 클릭
				 $("#go").on("click", function() {  
						$("#cancletxt").css('display', 'none');	 
				        $("#gotxt").css({
				            "top": (($(window).height()-$("#gotxt").outerHeight())/2+$(window).scrollTop())+"px",
				            "left": (($(window).width()-$("#gotxt").outerWidth())/2+$(window).scrollLeft())+"px"
				            //팝업창을 가운데로 띄우기 위해 현재 화면의 가운데 값과 스크롤 값을 계산하여 팝업창 CSS 설정
				           
				            }); 
				        $(".popup_back").css("display","block"); //팝업 뒷배경 display block
				        $("#gotxt").css("display","block"); //팝업창 display block
				        
				        $("#go").css('display', 'none');
						$("#cancle").css('display', 'block');
						
						$.ajax({
							url :'/setak/sugo2.do',
							type:'post',
							data : {
								'member_id': "<%=session.getAttribute("member_id") %>"
							},
							dataType:'json',
			    			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
							success:function(result) {
								if(result.res=="OK") {         
									console.log("됩니까?");
				     			}
				     			else { // 실패했다면
				     			}
							},
							// 문제가 발생한 경우 
							error:function (request, status, error) {
								alert("ajax 통신 실패");
								alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
							}
						});
						
					  });
		     
					//수거고 - 확인
					$(".pop_btn").click(function(event){
				        $(".popup_back").css("display","none"); //팝업창 뒷배경 display none
				        $(".popup").css("display","none"); //팝업창 display none
				    });
				       
			//수거고 취소 클릭 
			 $("#cancle").on("click", function() {  
				 $("#cancletxt").css({
				 	"top": (($(window).height()-$(".popup").outerHeight())/2+$(window).scrollTop())+"px",
			  	    "left": (($(window).width()-$(".popup").outerWidth())/2+$(window).scrollLeft())+"px"
			 	 }); 
			          
				$(".popup_back").css("display","block");
				$("#cancletxt").css("display","block");
	    	});
		
		//수거취소 - 수거취소
		 $(".pop_btn2").click(function(event){
		        $(".popup_back").css("display","none"); //팝업창 뒷배경 display none
		        $(".popup").css("display","none"); //팝업창 display none
		        
		        $("#go").css('display', 'block');
				$("#cancle").css('display', 'none');
				
				
				$.ajax({
					url :'/setak/sugo0.do',
					type:'post',
					data : {
						'member_id': "<%=session.getAttribute("member_id") %>"
					},
					dataType:'json',
	    			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					success:function(result) {
						if(result.res=="OK") {            
		     			}
		     			else { // 실패했다면
		     			}
					},
					// 문제가 발생한 경우 
					error:function (request, status, error) {
						alert("ajax 통신 실패");
						alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				});
		    });
		 
		//수거취소 - 수거접수
		 $(".pop_btn3").click(function(event){
		        $(".popup_back").css("display","none"); //팝업창 뒷배경 display none
		        $(".popup").css("display","none"); //팝업창 display none
		        
		        $("#go").css('display', 'none');
				$("#cancle").css('display', 'block');
		    });
		
	/*구독해지*/	
		//구독해지 신청 클릭 
		   $("#sub").click(function(event){
			   $(".subcancle").css('display', 'block');
			});
		
		//구독해지 신청 -> 유지
		   $(".keep").on("click", function() {
				$(".subcancle").css('display', 'none');
				$("#sub").css('display', 'block');
			});
		   
		   
		 //구독해지 신청 -> 취소
			$(".bye").on("click", function() {
				$(".subcancle").css('display', 'none'); 
				$("#re-sub").css('display', 'block'); 
				$("#sub").css('display', 'none'); 
				
				$.ajax({
					url :'/setak/subs_bye1.do',
					type:'post',
					data : {
						'member_id': "<%=session.getAttribute("member_id") %>"
					},
					dataType:'json',
	    			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					success:function(result) {
						if(result.res=="OK") {            
		     			}
		     			else { // 실패했다면
		     			}
					},
					// 문제가 발생한 경우 
					error:function (request, status, error) {
						alert("ajax 통신 실패");
						alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				});
			});
			
		 
		 // 구독해지 취소  클릭
		 $('#re-sub').on('click',function() {
			 $('.subback').css('display','block');
			 $('.reback').css('display','block');
			 $('#sub').css('display', 'block');
			 $('#re-sub').css('display', 'none');
			 
			 $.ajax({
					url :'/setak/subs_bye0.do',
					type:'post',
					data : {
						'member_id': "<%=session.getAttribute("member_id") %>"
					},
					dataType:'json',
	    			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
					success:function(result) {
						if(result.res=="OK") {            
							console.log("subs_bye 0");
		     			}
		     			else { // 실패했다면
		     			}
					},
					// 문제가 발생한 경우 
					error:function (request, status, error) {
						alert("ajax 통신 실패");
						alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				});
			});
		 
		 //구독해지 취소 팝업창 닫기	
		 $('#sub-back #close5').on('click', function() {
			 $('.reback').css('display','none');
			 $('#sub-back').css('display','none');
		 })
		 
	/*나의 정기구독이 0/0일 때 -로 바꿈*/
		for(var i = 0; i < 6; i++) {
			if($('.cell').eq(i).text() == "0/0") {
				$('.cell').eq(i).text('-');
			}
		}
		
		/*수거고 날짜*/
		var d = new Date(); 
		var day = (d.getMonth()+1)+"월" + (d.getDate()+1)+"일";
		document.getElementById("printday").innerHTML =day;
		
		
		/*리뷰작성여부*/
		var payDate = "";
		
		 /*리뷰 관련 스크립트*/   
	      //모달팝업 오픈
	       $(".open").on('click', function(){
	    	   
	    	  /*리뷰작성여부*/ 
	    	  var select_btn = $(this);
		      payDate = select_btn.parent().parent().children().eq(3).text();
	         
		      /*리뷰버튼 클릭*/
		      var login_id="<%=session.getAttribute("member_id")%>";      
	          
	          if(!(login_id=="null"))
	          {
	             $("#re_layer").show();   
	             $(".dim").show();
	          }
	          else{
	        	 Swal.fire("","비회원은 리뷰를 작성 할 수 없습니다.");
	             location.href="login.do";
	             return false;
	          }   
	      });
	       $(".close").on('click', function(){
	          $(".re_layer").hide();   
	          $(".dim").hide();
	          location.href='./mysub.do';
	          
	      });
	      
	        //별점 구동   
	      $('.r_content a').click(function () {
	      $(this).parent().children('a').removeClass('on');
	       $(this).addClass('on').prevAll('a').addClass('on');      
	       $('#Review_star').val($(this).attr("value")/2);
	       return false;
	      });   
	        
	        //파일 인설트 부분
	      var filecontent;
	      var filename="";   
	      $("#Review_photo").change(function(){
	         filecontent = $(this)[0].files[0];
	         filename = Date.now() + "_" + $(this)[0].files[0].name;
	      });   
	      
	      $("#reviewform").on("submit", function() {
	    	 
	    	 /*리뷰작성여부*/ 
	    	 $.ajax({
	    		url :'/setak/review_chk.do',
				type:'post',
				data : {
					'member_id' : "<%=session.getAttribute("member_id") %>",
	    			'his_date' : payDate
				},
				dataType:'json',
    			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
				success:function(result) {
					if(result.res=="OK") {            
						console.log("review_chk 1");
	     			}
	     			else { // 실패했다면
	     			}
				},
				// 문제가 발생한 경우 
				error:function (request, status, error) {
					alert("ajax 통신 실패");
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
	      
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
	});
	function rwcancel(){
	   location.href='./mysub.do';  
	}
	
	
</script>
</head>
<body>
	<div id="header"></div>

	<!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
	<section id="test">
		<!-- id 변경해서 사용하세요. -->
		<div class="content">
			<!-- 변경하시면 안됩니다. -->
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
				<h5>정기구독</h5>
				<% if(sub_list == null) {%>
				<h4>정기구독을 이용해 주세요</h4>
				<% } else { %> 
				<h3>나의 정기구독</h3>
				<div class="mysub">
					<!-- class 변경해서 사용하세요. -->
					<div class="one">
						<ul class="mysub_top">
							<li class="list">요금제</li>
							<li class="list">물빨래 30L</li>
							<li class="list">와이셔츠</li>
							<li class="list">드라이클리닝</li>
							<li class="list">이불</li>
							<li class="list">배송</li>
							<li class="list">구독신청일</li>
							<li class="list">구독만료일</li>
							<li class="list">수거</li>
							<li class="list">구독해지</li>
						</ul>
					</div>
					
					
					<div class="two">
						<ul class="mysub_bottom">
							<li class="cell"><%=sub_list.getSubsname() %></li>
							<li class="cell"><%=sub_list.getWashcnt() %>/<%=subscribe.getSubs_water() %></li>
							<li class="cell"><%=sub_list.getShirtscnt() %>/<%=subscribe.getSubs_shirts() %></li>
							<li class="cell"><%=sub_list.getDrycnt() %>/<%=subscribe.getSubs_dry() %></li>
							<li class="cell"><%=sub_list.getBlacketcnt() %>/<%=subscribe.getSubs_blanket() %></li>
							<li class="cell"><%=sub_list.getDeliverycnt() %>/<%=subscribe.getSubs_delivery() %></li>
							<li class="cell"><% String a =sub_list.getSubs_start();
												String b=a.substring(0,10);
												%><%=b %></li>
							<li class="cell"><%String c =sub_list.getSubs_end(); 
											   String d =c.substring(0,10);
												%><%=d %></li>
							<li class="btn">
								<a id="go" class="help">수거고 </a>
								<a id="cancle" href="javascript:">수거취소</a>
							</li>
							<li class="btn">
								<a id="sub" href="javascript:" >신청</a>
								<a id="re-sub" href="javascript:" >취소</a>
							</li>
						</ul>
					
						<br>
						<p>※ 수거고를 누르시면 다음날 수거가 이루어집니다.</p>
						<p>※ 수거 취소는 수거 신청 버튼을 누른 당일 밤 10시까지만 가능하니 유의해주세요.</p>
						<p>※ 구독해지는 당일이 아닌 다음 달부터 구독 해지가 이루어집니다.</p>
					</div>
					<%} %>	
					<!--정기구독내역이 없을 경우 -->		
					<% if(listcount == 0 ) {%> 
					<% } else { %> 	
					<div class="myrecord">
						<div class="text">
							<h2>정기구독 내역</h2>
							<table class="record_list"> 
								<thead>
									<tr>
										<th></th>
										<th>요금제</th>
										<th>결제금액</th>
										<th>결제일</th>
										<th>리뷰</th>
									</tr>
								</thead>
						
						
								 <% for (int i=0; i<list.size(); i++) {
									HistorySubVO hlist = (HistorySubVO)list.get(i);
								%>
								<tbody>
									<tr>
										<td><%=i+1 %></td>
										<td><%=hlist.getHis_name() %></td>
										<td><%=hlist.getHis_price() %>원</td>
										<td><%=hlist.getHis_date() %></td>
										<td>
										<% if(!(hlist.getReview_chk().equals("1"))) {  %>
											<a id="review" href="#" class="open">리뷰작성</a>
										<% } else { %>	
										     -
										<% } %>
										</td>
									</tr>
								</tbody>
								<%} %>
							   
							</table>
						</div>
					</div>
					<%} %>  
					
					<% if(sub_list == null) {%>
					<% } else { %> 		
					<div class="page_a1">
							<table class="page_a">
                     		<tr align = center height = 20>
                          		<td>
                          		<% if(nowpage <= 1) {%>
                          			<span class="page_a"><a>&#60;</a></span>
                         		 <%} else {%>  <!-- nowpage가 1페이지 아닐 때, 2 페이지거나 3페이지 등등 -->
                             		<span class="page_a"><a href ="./mysub.do?page=<%=nowpage-1 %>">&#60;</a></span>
                         		 <%} %>
                         	
                         		<%
                         			for (int af=startpage; af<=endpage; af++) {
                             			if(af==nowpage) {
                          		%>
                          			<span class="page_a active"><a><%=af %></a></span>
                          		<%} else {%>
                             		<span class="page_a"><a href="./mysub.do?page=<%=af %>"><%=af %></a></span>
                          			<%} %>
                          		<%} %>
                          
                          		<% if (nowpage >= maxpage) { %>   <!-- 링크 걸지 않겠다.. -->
                             		<span class="page_a"><a>&#62;</a></span>
                          		<%} else { %>   
                              		<span class="page_a"><a href ="./mysub.do?page=<%=nowpage+1 %>">&#62;</a></span>
                           		<% } 
					} %> 
                           		</td>
                        	</tr>
              			 </table>
					</div>
				</div>
<!--           popup -->
                <div class="popup_back"></div> <!-- 팝업 배경 DIV -->
        
        		<!-- 수거고 팝업창 -->
                <div class="popup" id="gotxt"> 
                	<img src="images/popup.png">
                    <div class="text">
                                           수거 신청이 되었습니다.<br><br>
                       	<span id="printday"></span>에 수거됩니다.
                    </div>
                    <div class="pop_btn">확인</div>
                </div>    
                 
                 <!-- 수거취소 팝업창 -->
                 <div class="popup" id="cancletxt"> 
                	<img src="images/popup.png">
                    <div class="text">
                    	수거취소  하시겠어요?<br><br>
                    	취소는 신청 당일 저녁 10시까지 가능합니다.
                    </div>
                    <div class="pop_btn2">수거취소</div>
                    <div class="pop_btn3">닫기</div>
                </div>
                
                <!-- 구독해지 팝업창 -->
                
                <div class="subcancle" id="subcancle" >
	                <div class="back">
						<img class="sub_image" src="images/back.png">
						<div class="text">
							<h2><span><%=name.getMember_name() %></span>님</h2>
							<p>지금 정기구독을 해지하시면,</p>
							<h4>최대<span>60%</span>저렴한 정기구독권</h4>
							<h4>보관 1BOX<span>1개월 쿠폰</span></h4>
							<h4>구독회원 전용<span>상시이벤트</span></h4>
							<h6>이 모든 세탁곰의 <span>정기구독 전용 혜택</span>이 사라져요<br>그래도 해지하시겠어요?<br><br>
							구독해지는 당일이 아닌 다음 달부터 구독 해지가 이루어집니다.</h6>
						</div>
						<input type="button" class="keep" value="구독하고 혜택 유지">
						<input type="button" class="bye" value="해지하고 혜택 포기">
					</div>
				</div>
				
			<!-- 구독해지 취소 팝업창 -->
			<div class="reback"></div>
			<div class="subback" id="sub-back">
				<h2>정기구독 재구독</h2>
				<hr>
				<h4>재구독 해주셔서 감사합니다<br>
					정기구독 재결제는 구독 만료일 다음날에 시행됩니다.<br><br><br>
					더욱더 나은 서비스를 제공하겠습니다.</h4>
				<input type="button" class="btn5" id="close5" value="닫기" />
			</div>
				
        </div><!-- mypage_content -->
			
		</div><!-- content -->
	</section>
	
	<!-- 리뷰 -->
	<div>
	 <!-- 레이아웃 팝업  -->
      
      <div id="re_layer" class="re_layer">
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
                        <div id = "r_content2">
                        <table class="r_content">
                           <tr><td colspan="7" class = "r_notice">&nbsp;REVIEW|&nbsp;<p style="display:inline-block; font-size: 0.8rem; color:#e1e4e4 ;"> 문의글은 무통보 삭제 됩니다</p></td></tr>
                            <tr><td colspan="7"><textarea id="Review_content" name="Review_content" maxlength="300" placeholder="리뷰를 작성해 주세요"></textarea></td></tr>
                            <tr><td>
                                <input type="file" id="Review_photo"/>                        
                                <input type="hidden" id="Review_photo2" name="Review_photo" /></td>                          
                                <td>
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
                                 <input class="cbtn" type="button" value="취소" onclick="rwcancel()"/></td>    
                           </tr></table>
                          </div>
                        </form>
                        <a class="close"><i class="fas fa-times" aria-hidden="true" style="color:#444; font-size:30px;"></i></a>
                        </div>
                        <div class="dim"></div><br><br>
	
	</div>
	<!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->

	<div id="footer"></div>
</body>

                
</html>