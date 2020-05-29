<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.*, com.spring.order.*" %>
<%@ page import="com.spring.setak.*" %>
<%@ page import="java.util.*, com.spring.setak.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%
   List<OrderVO> orderlist = (ArrayList<OrderVO>)request.getAttribute("orderlist");
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-d");
   int listcount = ((Integer)request.getAttribute("listcount")).intValue();
   int nowpage = ((Integer)request.getAttribute("page")).intValue();
   int maxpage = ((Integer)request.getAttribute("maxpage")).intValue();
   int startpage = ((Integer)request.getAttribute("startpage")).intValue();
   int endpage = ((Integer)request.getAttribute("endpage")).intValue();
   int limit = ((Integer)request.getAttribute("limit")).intValue();
   
   ArrayList<ArrayList<WashingVO>> washVO = (ArrayList<ArrayList<WashingVO>>)request.getAttribute("washVO2");
   ArrayList<ArrayList<MendingVO>> mendVO = (ArrayList<ArrayList<MendingVO>>)request.getAttribute("mendingVO2");
   ArrayList<ArrayList<KeepVO>> keepVO = (ArrayList<ArrayList<KeepVO>>)request.getAttribute("keepVO2");
   
   
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>세탁곰</title>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="./css/default.css"/>
<link rel="stylesheet" type="text/css" href="./css/orderview.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
<link rel="shortcut icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<script type="text/javascript">
   $(document).ready(function(){
      var member_id = "<%=session.getAttribute("member_id")%>";
      
      $("#header").load("./header.jsp");
      $("#footer").load("./footer.jsp");  
      
      var order_num;
      
      //모달팝업 오픈
       $(".open").on('click', function(){
          var login_id="<%=session.getAttribute("member_id")%>";      
          
          //작성여부
          var select_btn = $(this);
          order_num = select_btn.parent().parent().children().eq(0).children().eq(2).val();          
          
          if(!(login_id=="null"))
          {
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
          $(".re_layer").hide();   
          $(".dim").hide();
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
    	   $.ajax({
    		 url :'updatereview.do',
    		 type : 'POST',
    		 data : {
    			 "order_num" : order_num
    		 },
    		 dataType : 'json',
    		 contentType : 'application/x-www-form-urlencoded; charset=utf-8',
    		 success:function(retVal){
    			 if(retVal.res=="OK"){
    				 console.log("수정성공");
    			 }
    			 else{
    				 console.log("수정 실패");
    			 }
    		 },
    		 error: function() {
				alert("통신실패");
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
      

      jQuery(".accordion-content").hide();
      //content 클래스를 가진 div를 표시/숨김(토글)
      $(".accordion-header").click(function(){
         $except = $(this).closest("div");
         $except.toggleClass("active");
         $(".accordion-content")
            .not($(this).next(".accordion-content").slideToggle(500)).slideUp();
         $('.mypage_content_cover').find('.accordion>.accordion-header').not($except).removeClass("active");
         
         
      });
      
      // 결제 취소      
      $(document).on('click', '#order_false', function(event) {
         var btn = $(this); 
         var order_muid = btn.attr('name');
         
         Swal.fire({
        	text: "선택한 주문을 취소하시겠습니까?",
			icon: 'warning',
			showCancelButton: true,
			confirmButtonText: '네, 취소합니다.',
			cancelButtonColor: '#d33',
			cancelButtonText: '아니요'
         }).then((result) => {
         if(result.value) {
             jQuery.ajax({
                  "url": "/setak/cancelPay.do",
                  "type": "POST",
                  "contentType": "application/x-www-form-urlencoded; charset=UTF-8",
                  "data": {
                    "order_muid" : order_muid
                  },
                  "dataType": "json"
                }).done(function(result) { // 환불 성공시 로직 
                    Swal.fire({
						text: "주문이 성공적으로 취소 되었습니다.",
						icon: "success",
					}) .then(function(){
						window.location.href = "./orderview.do";
					});
                }).fail(function(result) { // 환불 실패시 로직
                     Swal.fire("","주문 취소가 실패했습니다. 고객센터로 연락주세요.","error");
                });   
         } 
         })
      }); 
       
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
   
   function rwcancel(){
	  location.href = "./orderview.do";
			
   }   

function cancle() {
   confirm("주문을 취소하시겠습니까?");
}
</script>
</head>
<body>
   <div id="header"></div>
   
   <!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
   <section id="test"> <!-- id 변경해서 사용하세요. -->
      <div class="content"> <!-- 변경하시면 안됩니다. -->
         <div class="title-text">
            <h2>주문/배송현황</h2>
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
            <h2 class="content_h2">주문/배송현황</h2>
            <%if (orderlist.size() == 0) {%>
               <h3 class="null">주문 내역이 없습니다.</h3>
            <%} else { %>
            <div class="mypage_content_cover">
               <p>
                  <font size=2.5rem style="color:#3498db;">※ 취소 버튼은 신청 당일 밤 10시 전까지만 활성화됩니다. 이후 취소는 불가합니다.</font>
               </p>
               <% 
                     for (int i = 0; i<orderlist.size(); i++) {   
                    	 
                        OrderVO orderVO = (OrderVO)orderlist.get(i);
                        
                        ArrayList<KeepVO> kvo = keepVO.get(i);         
                        
                        ArrayList<MendingVO> mvo = mendVO.get(i);         
                        ArrayList<WashingVO> wvo = washVO.get(i);         
                        
                        // 리스트 하고 싶으면 for문을 돌려 힘을내 > keepVO도 리스트일거 아녀.. 
                        
                     
               %>
               <div class="accordion">
                  <div class="accordion-header">주문일자 : <%=orderVO.getOrder_date() %></div>
                  <div class="accordion-content">
                     <!--snb -->
                     <div class="snb">
                        <div class="ordernumber" >
                           <p>※ 주문 번호</p>
                           <p><%=orderVO.getOrder_num() %></p>
                           <input type="hidden" value="<%=orderVO.getOrder_num() %>">
                        </div>
                        <div class="addr">
                           <p>※ 주소</p>
                           <p><%=orderVO.getOrder_address().replace("!", " ") %></p>
                        </div>
                        <br><br><br><br><br>
                        
                        <div class="order_dateClass">
                           
                           <%if (orderVO.getOrder_cancel().equals("1")) {%>
                           <input type="button" value="리뷰작성" class="open" disabled />
                           <%} else if (orderVO.getReview_chk().equals("1")){ %>
                           	<input type="button" value="리뷰작성" class="open" disabled />
                           <%} else { %>
                            <input type="button" value="리뷰작성" class="open" />
                           <%} %>
                           <%if (orderVO.getOrder_delete().equals("1")) {%>
                           <input type="button" class="button" id="order_false" name="<%=orderVO.getOrder_muid()%>"  value="주문취소" disabled/>
                           <%} else { %>
                           <input type="button" class="button" id="order_false" name="<%=orderVO.getOrder_muid()%>"  value="주문취소" />
                           <%} %>
                           
                        </div>
                     </div>
                     <!--//snb -->
                     <!--content -->
                     <div class="row_content">
                        <div class="row_content2">
                        <div class="my_laundry">
                           <p>세탁 :</p>
                           <%for (int w = 0; w < wvo.size(); w++){ %>
                           <%if (wvo.get(w).getWash_seq() != 0) { %>
                           <p><%=wvo.get(w).getWash_kind() %> - <%=wvo.get(w).getWash_method() %> - <%=wvo.get(w).getWash_count() %>개</p>
                           <%
                              } 
                           }
                           %>
                        </div>
                        <div class="my_mending">
                           <p>수선 :</p>
                           <%for (int m = 0; m<mvo.size(); m++) {%>
                           <%if (mvo.get(m).getRepair_seq() != 0) {%>
                           <p><%=mvo.get(m).getRepair_cate() %> - <%=mvo.get(m).getRepair_kind() %> - 태그(<%=mvo.get(m).getRepair_code() %>) - <%=mvo.get(m).getRepair_count() %>개</p>
                           <%
                              }   
                           } 
                           %>
                        </div>
                        <div class="my_keep">
                           <p>보관 :</p>
                           <%for (int k= 0; k < kvo.size(); k++) {%>
                           <%if (kvo.get(k).getKeep_seq() != 0) {%>
                           <p><%=kvo.get(k).getKeep_cate() %> - <%=kvo.get(k).getKeep_kind() %> - <%=kvo.get(k).getKeep_count() %>개 - <%=kvo.get(k).getKeep_box() %>박스</p>
                           <%
                              } 
                           }
                           %>
                        </div>
                        </div>
                        <div class="price">
                           <%
                           if(orderVO.getOrder_delicode() == null)    
                              orderVO.setOrder_delicode("");
                           %>
                              <p class="delicode">송장번호 : <%=orderVO.getOrder_delicode() %></p>
                              <p class="status">   상태 : <%=orderVO.getOrder_status() %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 합계 : <%=orderVO.getOrder_price() %>&nbsp;원</p>
                        </div>
                     </div>
                  </div>
               </div>
               <%
               
                  }
%>
            </div>
            
            <div class="page1">
            <table class="page">
               <tr align = center height = 20>
                       <td>
              				<%if(nowpage <= 1) {
              				%>
              				<div class="page_a"><a>&#60;</a></div>
              				<%} else {%>
              					<div class="page_a"><a href ="./orderview.do?page=<%=nowpage-1 %>">&#60;</a></div>
              				<%} %>
              				<%for (int a=startpage; a<= endpage; a++) {
              					if(a==nowpage) {
           					%>
           					<div class="page_a active"><a><%=a %></a></div>
           					<%} else {%>
           						<div class="page_a"><a href="./orderview.do?page=<%=a %>"><%=a %></a></div>
           					<%} %>
           					<%} %>
           					<%if (nowpage >= maxpage) {
           					%>	
           						<div class="page_a"><a>&#62;</a></div>
           					<%} else { %>	
                  				<div class="page_a"><a href ="./orderview.do?page=<%=nowpage+1 %>">&#62;</a></div>
                  			<%} %>	
                  			</td>
                     </tr>
            </table>
            </div>
           <%} %>
            <!-- 리뷰 추가 -->
            <div id="re_layer" class="re_layer">
                        <h2>리뷰 작성</h2>
                        <form action="./reviewInsert.do" method="post" enctype="multipart/form-data" name="reviewform" id="reviewform">
                        <div class="r_content">
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
                  <!-- 리뷰 추가 끝 -->
				 
         </div>
         
      </div>
   </section>
   <!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
   
   <div id="footer"></div>
</body>
</html>