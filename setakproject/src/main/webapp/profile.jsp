<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.spring.member.MemberVO"  %>    
<%
   String member_name = (String) request.getAttribute("member_name");
   String member_phone = (String) request.getAttribute("member_phone");
   String member_email = (String) request.getAttribute("member_email");
   String member_addr1 = (String) request.getAttribute("member_addr1");
   String member_addr2 = (String) request.getAttribute("member_addr2");
   String zipcode = (String) request.getAttribute("zipcode");
   
   String session_id=(String)session.getAttribute("member_id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
   <title>세탁곰</title>
   <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
   <link rel="stylesheet" type="text/css" href="./css/default.css"/>
   <link rel="stylesheet" type="text/css" href="./css/profile.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
   <link rel="shortcut icon" href="favicon.ico">
   <link rel="stylesheet" type="text/css" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
   <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

   <!-- 우편번호 api -->
   <script   src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <script type="text/javascript">
    var authchk = "0";
    //핸드폰 인증을 위한  난수 설정 함수
       randomnum = function() {
      var array = new Uint32Array(1);
      window.crypto.getRandomValues(array);
      var num = array[0] + "";
      var rnum = num.substring(0,6);
      console.log(rnum);

      /* for (var i = 0; i < array.length; i++) {
          console.log(array[i]);
      } */
      
      return rnum;
   }
   
    //난수
    var random = randomnum();
    
   $(document).ready(function(){
        //기본 
         $("#header").load("header.jsp");
         $("#footer").load("footer.jsp");
         
         
      
       var AuthTimer = new $ComTimer();
          //문자보내기
       $("#authbtn").click(function(event){
             $(".profile div:nth-child(6) h5").css("display","none");   
             AuthTimer.fnStop();
             random = randomnum();
             
             var daycount = 0; 
 			
 			$.ajax({
                 type: "POST",
                 url: "/setak/ipcount.do",
                 async:false,
                 contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                 dataType: 'json',
                 
                 success: function (data) {
                 	if(data.res=="OK") {
                 		daycount = 1;
 		        	 } else {
 		        		 Swal.fire("","오늘 사용횟수를 초과하였습니다.","warning");
 		        	 }
                 },
                 error: function (e) {
 					console.error(e);
 				}
 			});
 			
 			if(daycount == 1){
 				var phonenum = $("#member_phone").val();
 				
 				var allData = { "pn": phonenum , "randomnum": random };
 				
 				
 				
 				
 				$.ajax({
 	                type: "POST",
 	                url: "/setak/sendSMS.do", 
 	                data: allData,
 	                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
 	                dataType: 'text',
 	                
 	                success: function (data) {
 	        			AuthTimer.comSecond =  179;
 	        			AuthTimer.fnCallback = function(){Swal.fire("","다시인증을 시도해주세요.","warning");};
 	        			AuthTimer.timer =  setInterval(function(){AuthTimer.fnTimer()},1000);
 	        			AuthTimer.domId = document.getElementById("timer");
 	        			$("#authbtn").attr('disabled', true);
 	                },
 	                error: function (e) {
 						console.error(e);
 					}
 				});
 			}
 			
 		});
          
          
          //인증번호 확인
          $(document).on("click","#smsbtn",function(){
             if($("#member_sns").val()==random){
                console.log("인증성공");
                AuthTimer.fnStop();
                AuthTimer.domId = "";
                document.getElementById('timer').innerHTML = "";
                $("#authbtn").attr('disabled', false);
                $(".profile div:nth-child(6) h4").css("display","none");
                $(".profile div:nth-child(6) #authsucess").css("display","block");
                authchk = "1";
             }else{
                console.log("인증실패");
                $("#authbtn").attr('disabled', false);
                $(".profile div:nth-child(6) h4").css("display","none");
                $(".profile div:nth-child(6) #authfail").css("display","block");
             }
           });
           
       
       $('#update').on('click', function(event) {
          
          var pwReg = /^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,16}$/;
          var phReg =/^[0-9]{10,11}$/;
          var emReg =/^[a-z0-9_+.-]+@([a-z0-9-]+\.)+[a-z0-9]{2,4}$/;
          var poReg = /^[0-9]{5}$/;
             
           if(authchk == 0){
                Swal.fire("","인증번호 확인이 되지 않았습니다.","info");
                return false;
             }
          
           if( $("#member_name").val()  == '' || $("#member_id").val()  == ''|| 
                   $("#member_password").val() == '' || $("#pw2").val() == '' || 
                   $("#member_phone").val() == ''|| $("#member_sns").val() == '' || 
                   $("#member_email").val() == '' || $("#postcode").val() == '' || $('#chksns').val() == ''
                   
                   
                 ) {
                 Swal.fire("","빠짐없이 기입해 주세요","info");
                 return false; 
              };
          
           if(!pwReg.test($("#member_password").val())) {
              Swal.fire("","비밀번호를 8~16자 영문, 숫자, 특수문자의 조합으로 입력해주세요.","info");
              return false; 
           }
          
           if($('#member_password').val() != $('#pw2').val()) {
              Swal.fire("","비밀번호가 일치하지 않습니다.","info");
              return false; 
           }
           
           if(!phReg.test($("#member_phone").val())){
              Swal.fire("","핸드폰 번호를 입력해주세요","info");
              return false; 
           }
           
           if($("#member_sns").val()==random){
        	  Swal.fire("","핸드폰 번호를 입력해주세요","info");
              return false; 
           }
           
           
          var id = $("#member_id").val();
         var password = $("#member_password").val();
         var name = $("#member_name").val();
         var phone = $("#member_phone").val();
         var email = $("#member_email").val();
         var zipcode = $("#postcode").val();
         var address = $("#address").val();
         var detailAddress = $("#address_detail").val();
         var addr = address + '!' + detailAddress; 
         
          var params = {
                      'member_id': id,
                      'member_password':password,
                      'member_name': name,
                      'member_phone':phone,
                      'member_email': email,
                      'member_zipcode':zipcode,
                      'member_loc':addr
         };
         $.ajax({
               url : '/setak/updateMember.do', // url
               type:'post',
               data : params,
               dataType:'json', 
               contentType : 'application/x-www-form-urlencoded;charset=utf-8',
               success: function(result) {
                  if(result.res=="OK") {
                     Swal.fire({
 						text: "수정 성공",
 						icon: "success",
 					}) .then(function(){
 						window.location.href = "./profile2.do";
 					});
                  }
                  else { // 실패했다면
                     Swal.fire("","개인정보수정 실패","error");
                  }
               },
               error:function() {
                  alert("insert ajax 통신 실패");
               }         
         });
         
      });
         
      });
      
      function $ComTimer(){
           //prototype extend
       }

       $ComTimer.prototype = {
           comSecond : ""
           , fnCallback : function(){}
           , timer : ""
           , domId : ""
           , fnTimer : function(){
               var m = Math.floor(this.comSecond / 60) + "분 " + (this.comSecond % 60) + "초";
               this.comSecond--;               // 1초씩 감소
               this.domId.innerText = m;
               if (this.comSecond < 0) {         // 시간이 종료 되었으면..
                   clearInterval(this.timer);      // 타이머 해제
                   random = randomnum();
                   Swarl.fire("","인증시간이 초과하였습니다. 다시 인증해주시기 바랍니다.","warning")
               }
           }
           ,fnStop : function(){
               clearInterval(this.timer);
           }
       }
    </script>
</head>
<body>
   <div id="header"></div>
   
   <!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
   <section id="title"> <!-- 변경하시면 안됩니다. -->
      <div class="content">
         <!-- 변경하시면 안됩니다. -->
         <div class="title-text">
            <!-- 변경하시면 안됩니다. -->
            <h2>개인정보수정</h2>
         </div>
      </div>
   </section>
   
   <section id="test"> <!-- id 변경해서 사용하세요. -->
      <div class="content"> <!-- 변경하시면 안됩니다. -->
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
                     <li><a href="qnainquiry.do">Q&amp;A 문의내역</a></li>
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
         <div class="profile"> <!-- class 변경해서 사용하세요. -->
            <form name="profile">
               <div class="update_list">
               <%
                  String last = session_id.substring(session_id.length() - 1);
                  if(last.equals("K")){
                  %>  
                     <input type="hidden" name="member_id" id="member_id" value="<%=session_id %>">
                     <h1>카카오 계정으로 로그인 하셨습니다<h1>
                  <% } else if(last.equals("N")) { %>
                     <input type="hidden" name="member_id" id="member_id" value="<%=session_id %>" >
                     <h1>네이버 계정으로 로그인 하셨습니다<h1>
                  <% } else if(last.equals("G")) { %>
                     <input type="hidden" name="member_id" id="member_id" value="<%=session_id %>">
                     <h1>구글 계정으로 로그인 하셨습니다<h1>
                  <% } else { %>
                     <input type="text" name="member_id" id="member_id" value="<%=session_id %>" readonly >
                  <%} %>
            
               </div>               
               <% if(last.equals("K")||last.equals("N")||last.equals("G")) { %>
               <div class="update_list">
                  <input type="hidden" name="member_password" id="member_password" placeholder="새 비밀번호 " value="" />
                  <h2>8~16자 영문, 숫자, 특수문자의 조합으로 입력해주세요.</h2>
               </div>
               <div class="update_list">
                  <input type="hidden" name="pw2" id="pw2" value="" placeholder="비밀번호 확인" />
                   <h3>비밀번호가 일치하지 않습니다.</h3>
               </div>
               <% } else {%>
               <div class="update_list">
                  <input type="password"  name="member_password" id="member_password" placeholder="새 비밀번호 " />
                  <h2>8~16자 영문, 숫자, 특수문자의 조합으로 입력해주세요.</h2>
               </div>
               <div class="update_list">
                  <input type="password" name="pw2" id="pw2" placeholder="비밀번호 확인" />
                   <h3>비밀번호가 일치하지 않습니다.</h3>
               </div>
               <%} %>
               <div class="update_list">
                  <input type="text" name="member_name"  id="member_name" placeholder="이름" value="<%=member_name %>" />   
               </div>
               <div class="update_list">
                  <input type="text" name="member_phone"  id="member_phone" placeholder="핸드폰" value="<%=member_phone %>"  />   
                  <input class="btn" id="authbtn" type="button" value="인증번호 받기"  />
                  <h5>핸드폰 번호를 입력해주세요</h5>
               </div>
               <div class="update_list">
                  <ul id = "auth_ul"> 
                     <li>
                     <span class = "input">
                        <input type="text" name="" size="20" id="member_sns"  placeholder="SNS 인증번호" />
                        <input id="smsbtn" class="btn" type="button" value="인증번호 확인" />
                        <span id = "timer"></span>
                     </span>
                     </li>
                  </ul>
                     <h4 id = "authsucess">인증번호가 일치합니다.</h4>
                     <h4 id = "authfail">인증번호가 일치하지 않습니다.</h4>
               </div>
               <div class="update_list">
                  <input type="text" name="member_email" id="member_email" placeholder="이메일" value="<%=member_email %>">
                  <h6>메일주소를 입력해주세요</h6>   
               </div>
               <div class="update_list">
                  <input id="postcode" class="txt_info" type="text" name="member_post" value="<%=zipcode %>"  /> 
                  <input type="button" class="btn" onclick="execDaumPostcode()" value="우편번호 찾기" /> <br />
                  <input id="address"  class="txt_info" type="text" name="member_loc"   value="<%=member_addr1 %>" readonly/> 
                  <input id="address_detail" class="txt_info" type="text" name="member_locdetail"  value="<%=member_addr2 %>" />
                  <input id="extraAddress" type="hidden" placeholder="참고항목"><br>
                  <h7>주소를 입력해주세요</h7>
               </div>   
               <div class="total_button">
                  <input class="btns" type="submit" id="update" value="수정" />
               </div>   
            </form>
         </div>         
      </div>
      </div>
   </section>
   <!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->
   
   <div id="footer"></div>
   <script type="text/javascript">
   var pwReg = /^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,16}$/;
   var phReg =/^[0-9]{10,11}$/;
   var emReg =/^[a-z0-9_+.-]+@([a-z0-9-]+\.)+[a-z0-9]{2,4}$/;
   var poReg = /^[0-9]{5}$/;
      
    //비밀번호체크V
   $(document).ready(function(){
    $(document).on("propertychange change keyup paste","#member_password",function(){
       if(!pwReg.test($(this).val())){
          $(".profile h2").css("display","block");
       } else {
          $(".profile h2").css("display","none");
       }
       
     });
    
    //비밀번호 일치 체크V
         $(document).on("propertychange change keyup paste","#pw2",function(){
            if($('#member_password').val() != $('#pw2').val()) {
                $(".profile h3").css("display","block"); 
            } else {
                $(".profile h3").css("display","none"); 
            }
         });
    
    
      //핸드폰번호 체크V
       $(document).on("propertychange change keyup paste","#member_phone",function(){
          if(!phReg.test($(this).val())){
             $(".profile h5").css("display","block");
          } else {
             $(".profile h5").css("display","none");
          }
          
        });
      
       //인증번호 체크?????????????????????????????????
       $(document).on("propertychange change keyup paste","#chksns",function(){
          if($('#chksns').val() == ""){
             $(".profile h4").css("display","block");
          } else {
             $(".profile h4").css("display","none");
          }
          
        });
      
      
         //이메일체크V
       $(document).on("propertychange change keyup paste","#member_email",function(){
          if(!emReg.test($(this).val())){
             $(".profile h6").css("display","block");
          } else {
             $(".profile h6").css("display","none");
          }
          
        });
         
       
      
      //우편번호체크V
    $(document).on("propertychange change keyup paste","#postcode",function(){
       if(!poReg.test($(this).val())){
          $(".profile h7").css("display","block");
       } else {
          $(".profile h7").css("display","none");
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
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("address_detail").focus();
            }
        }).open();
    };
   
   
   
   </script>
</body>

</html>