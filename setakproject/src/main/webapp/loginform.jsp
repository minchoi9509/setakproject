<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%
   String name = (String) session.getAttribute("name");
   String member_id = (String) session.getAttribute("member_id");
   String backurl = (String)request.getAttribute("backurl");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>세탁곰</title>
<link rel="stylesheet"   href="https://use.fontawesome.com/releases/v5.4.1/css/all.css"   integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="./css/default.css" />
<link rel="stylesheet" type="text/css" href="./css/loginform.css" />
<link rel="shortcut icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<!-- 구글로그인 -->
<script src="https://apis.google.com/js/api:client.js"></script>

<script type="text/javascript">
   $(document).ready(function() {
      $("#header").load("header.jsp")
      $("#footer").load("footer.jsp")
      
      /*회원가입 클릭*/
      $(".btn_join").click(function(event) {
         $(location.href = "/setak/join.do");
      });
      
      /*로그인 */
      $("#btn-login").on('click',function(event) {
         
         $.ajax({
            url:'/setak/loginpro.do',
            type:'post',
            data: {
               'member_id':$('input[name=member_id]').val(),
               'member_password':  $('input[name=member_password]').val(),
               'backurl2': $('input[name=backurl]').val()
            },
            dataType:'json',
            contentType : 'application/x-www-form-urlencoded;charset=utf-8',
              success: function(result) {
                 if(result.res=="OK") {
                    location.href=result.backurl;
                 }
                 else { 
                    Swal.fire({
                     text: "아이디와 비밀번호를 다시 확인해 주세요",
                     icon: "error",
                  }).then(function(){
                     location.href='redirect:login.do';
                  });
                 }
            },
                 error:function() {
                     alert("insert ajax 통신 실패");
              }         
         });
         event.preventDefault();
         
      });
      
      /*다른 서비스 계정으로 로그인*/
      $(".kakao").click(function(event) {
         $(location.href = "${kakao_url}");
      });

		$(".naver").click(function(event) {
			$(location.href = "${naver_url}");
		});
		
		/*팝업창*/
		/*아이디찾기*/
		$(".find_id").click(function(event) {
			$(".id_back").css("display", "block");
			$(".popup").css("display", "block");

		});
		
		$(".close").click(function(event) {
			$(".id_back").css("display", "none");
			$(".popup").css("display", "none");
		});
		
		/*아이디 보여주기*/
		$("#show-id").on('click', function(event){
			
			var params = {
					'member_name':$("#member_name").val(),
					'member_phone':$("#member_phone").val()
			}
			
			$.ajax({
				url:'/setak/show-id.do',
				type:'post',
				data: params,
				dataType:'json',
				contentType : 'application/x-www-form-urlencoded;charset=utf-8',
     			success: function(data) {
					
     				$(".popup").css("display", "none");
					$(".id_back").css("display", "block");
					$(".yourid").css("display", "block");
					
					
					var id = data.id;
					$("#your-id").text(id);
					
					$("#member_name").val('');
					$("#member_phone").val('');
					$("#member_sns").val('');
					$(".text #authsucess").css("display","none");
					$(".text #show-id").css("display","none");
					$(".text #change-pw").css("display","none");
					
     			},
     			  error:function() {
		               alert("insert ajax 통신 실패");
		        }			
			});
			event.preventDefault();
			
		});
		
		$("#id-close1").click(function(event) {
			$(".id_back").css("display", "none");
			$(".yourid").css("display", "none");
		});
	
		$("#id-close2").click(function(event) {
			$(".id_back").css("display", "none");
			$(".yourid").css("display", "none");
		});
	
		
		/*비밀번호찾기*/
		$(".find_pw").click(function(event) {
			
			$(".pw_back").css("display", "block");
			$(".popup2").css("display", "block");

		});
		$(".close").click(function(event) {
			$(".pw_back").css("display", "none");
			$(".popup2").css("display", "none");
		});
		
		/*비밀번호 변경하기 버튼 클릭*/
		$("#change-pw").on('click', function(event){
			
			var member_id = $("#member_id").val();
			
			var params = {
					'member_name':$("#member_name2").val(),
					'member_id':$("#member_id").val(),
					'member_phone':$("#member_phone2").val()
			}
			
			$.ajax({
				url:'/setak/find-pw.do',
				type:'post',
				data: params,
				dataType:'json',
				contentType : 'application/x-www-form-urlencoded;charset=utf-8',
     			success: function(result) {
					
					if (result.res == "OK") {
						
						//비밀번호 변경 팝업창
						$(".popup2").css("display", "none");
						$(".pw_back").css("display", "block");
						$(".changepass").css("display", "block");
						
						$("#member_name2").val('');
						$("#member_id").val('');
						$("#member_phone2").val('');
						$("#member_sns2").val('');
						$(".text #authsucess2").css("display","none");
						$(".text #change-pw").css("display","none");
						
						
						
						 
						//비밀번호 변경하기
						$('#update-pw').on('click', function() {
							
							//비밀번호 유효성 검사
							var pwReg = /^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,16}$/;
							
							if( $("#member_password2").val() == '' || $("#pw2").val() == '' ) {
								Swal.fire("","빠짐없이 기입해 주세요","info");
									
							} else if(!pwReg.test($("#member_password2").val())) {
								Swal.fire("","8~16자 영문, 숫자, 특수문자의 조합으로 입력해주세요.","info");

							} else if($('#member_password2').val() != $('#pw2').val()) {
								Swal.fire("","비밀번호가 일치하지 않습니다.","info");
							   	
							} else { 
								
								$.ajax({
									url: '/setak/change-pw.do',
									type: 'POST',
									contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
									dataType : "json",
									data : {
										'member_id':result.member_id,
										'member_password':$("#member_password2").val()
									},
									
									success : function(result) {
										if(result.res == "OK") {
											Swal.fire({
												text: "비밀번호가 수정 되었습니다.",
												icon: "success",
											}).then(function(){
												location.href='/setak/login.do';
											});
											
											$("#member_name2").val('');
											$("#member_id").val('');
											$("#member_phone2").val('');
											$("#member_sns2").val('');
											
											$("#member_password2").val('');
											$("#pw2").val('');
											$(".text #authsucess2").css("display","none");
											$(".text #change-pw").css("display","none");
											
											$(".pw_back").css("display", "none");
											$(".changepass").css("display", "none");
											
										} else {
											Swal.fire({
												text: "비밀번호 수정 실패",
												icon: "error",
											}).then(function(){
												location.href='redirect:login.do';
											});
											
											$("#member_name2").val('');
											$("#member_id").val('');
											$("#member_phone2").val('');
											$("#member_sns2").val('');
											
											$("#member_password2").val('');
											$("#pw2").val('');
											$(".text #authsucess2").css("display","none");
											$(".text #change-pw").css("display","none");
											
											$(".pw_back").css("display", "none");
											$(".changepass").css("display", "none");
										}
									},
									error : function(request, error) {
										alert("message : " + request.responseText);
									}
								});
							   }
							
						});
												
					} else {
						Swal.fire({
							text: "입력하신 정보가 일치하지 않습니다.",
							icon: "warning",
						}).then(function(){
							location.href='/setak/login.do';
						});
					}
					
     			},
     			  error:function() {
		               alert("insert ajax 통신 실패");
		        }			
			});
			event.preventDefault();
			
		}); 
		
	});

   /*구글로그인*/
   var googleUser = {};
   var startApp = function() {
      gapi.load('auth2',function() {
         auth2 = gapi.auth2.init({
            client_id : '114414180398-cjl49jqvelctnaiuvj6vi2ffjbrrv1dc.apps.googleusercontent.com',
            cookiepolicy : 'single_host_origin'
            });
         attachSignin(document.getElementById('customBtn'));
      });
   };

   function attachSignin(element) {
      auth2.attachClickHandler(element, {}, function(googleUser) {
         var profile = googleUser.getBasicProfile();
         
         var g_id = profile.getId();
         var g_nickname = profile.getName();
         var g_email = profile.getEmail();
         var params = { 
               'member_id' : g_id+"_G",
               'member_name' : g_nickname,
               'member_email' : g_email,
               'member_loc' : "!"
          }
         
         $.ajax({
               url : '/setak/google.do', 
               type:'post',
               data : params,
               dataType:'json', 
               contentType : 'application/x-www-form-urlencoded;charset=utf-8',
               success: function(result) {
                  if(result.res=="OK") {
                     location.href="/setak/";
                  }
                  else { // 실패했다면
                     location.href="/setak/login.do";
                  }
               },
               error:function() {
                  alert("insert ajax 통신 실패");
               }         
         });

      }, function(error) {
               location.href='/setak/login.do';
      });
      

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
            <h2>로그인</h2>
         </div>
      </div>
   </section>

   <section id="test"> <!-- id 변경해서 사용하세요. -->
      <div class="content">    <!-- class 변경해서 사용하세요. -->
         <form name="loginform">
            <div class="loginform"> <!-- class 변경해서 사용하세요. -->
                  <input type="hidden" name="backurl" value = "<%=backurl%>" />
               <div>
                  <input class="txtln" type="text" name="member_id"  placeholder="아이디" />
               </div>
               <div>
                  <input class="txtln" type="password" name="member_password" placeholder="비밀번호" />
               </div>
               <div class="login">
                  <input class="btn" type="submit" id="btn-login" value="로그인" />
               </div>
               <hr>
               <div class="find">
                  <div class="find_id">아이디찾기</div>
                  <div class="find_pw">비밀번호찾기</div>
                  <div class="btn_join">회원가입</div>
               </div>
               <%
                  if (name == null) {
               %>
               <div class="extra">
                  <h4>다른서비스계정으로 로그인</h4>
                  <!--카카오 -->
                  <div class="logo kakao">
                     <img src="images/logo_kakao.png">
                  </div>
                  <!-- 구글 -->
                  <div id="gSignInWrapper">
                     <div id="customBtn" class="customGPlusSignIn">
                     <img src="images/logo_gogle.png">
                     </div>
                  </div>
                  <!-- 네이버 -->
                  <div class="logo naver">
                     <img src="images/logo_naver.PNG">
                  </div>
                  <script>
                     startApp();
                  </script>
                  <hr>
               </div>
               <%
                  } else {
               %>
               <h2>다른 서비스계정 로그인 성공하셨습니다!!</h2>
               <h3>'${name}' 님 환영합니다!</h3>
               <%
                  }
               %>
            </div>
         </form>
      </div>
   </section>

	<!-- 팝업창 -->
	<!-- 아이디찾기 -->
	<div class="check_id">
		<div class="id_back"></div>
		<div class="popup">
			<div class="head">
				<button type="button" class="close">X</button>
				<h3>아이디찾기</h3>
				<hr>
			</div>
			<div class="text">
				<h5>회원정보에 등록한 휴대폰번호를 입력하세요</h5>
				<input type="text" id="member_name" placeholder="이름" />
				<input type="text" id="member_phone" placeholder="휴대폰번호 (예시 01012345678)" /> 
				<input type="button" id="authbtn" class="phone" value="인증번호받기" /> 
                <h4>핸드폰 번호를 입력해주세요</h4>
                <input type="text" id="member_sns" placeholder="인증번호" /> 
                <input type="button"  id="smsbtn" class="ok" value="확인" />
                <span id = "timer"></span>
                <h4 id = "authsucess">인증번호가 일치합니다.</h4>
               <h4 id = "authfail">인증번호가 일치하지 않습니다.</h4>
               <input type="button" id="show-id" value="아이디 찾기" />
         </div>
      </div>
   </div>
   
   <!-- 아이디 보여주기 -->
   <div class="yourid">
      <button type="button" id="id-close1" class="btn-x">X</button>
      <h3>아이디찾기</h3>
      <hr>
      <h6>등록된 회원님의 아이디는 <span id="your-id">  </span> 입니다</h6>
      <button type="button" id="id-close2" class="btn">확인</button>
   </div>
   

	<!-- 비밀번호찾기 -->
	<div class="check_pw">
		<div class="pw_back"></div>
		<div class="popup2">
			<div class="head">
				<button type="button" class="close">X</button>
				<h4>비밀번호찾기</h4>
				<hr>
			</div>
			<div class="text">
				<h3>회원정보에 등록한 휴대폰번호를 입력하세요</h3>
				<input type="text" id="member_name2"  placeholder="이름" /> 
				<input type="text" id="member_id" placeholder="아이디" /> 
				<input type="text" id="member_phone2" placeholder="휴대폰번호 (예시 01012345678)" /> 
				<input type="button"  id="authbtn2" class="phone" value="인증번호받기" />  
				<input type="text" id="member_sns2" placeholder="인증번호" />
				<h5>핸드폰 번호를 입력해주세요</h5>
                <input type="button"  id="smsbtn2" class="ok" value="확인" />
                <span id = "timer2"></span>
                <h6 id = "authsucess2">인증번호가 일치합니다.</h6>
                <h6 id = "authfail2">인증번호가 일치하지 않습니다.</h6>
            <input type="button" id="change-pw" value="비밀번호 변경하기" />
         </div>
      </div>
   </div>

   
   <!-- 비밀번호 교체하기 -->
   <div class="changepass">
      <h2>비밀번호 변경하기</h2>
      <hr>
      <h3>변경하실 비밀번호를 입력해 주세요.</h3>
      <h4>8~16자 영문, 숫자, 특수문자의 조합으로 입력해주세요.</h4>
      <input type="password" name="member_password" id="member_password2" placeholder="새 비밀번호 " />
      <h5>조합을 확인해주세요.</h5>
      <input type="password" name="pw2" id="pw2" placeholder="비밀번호 확인" />
      <h6>비밀번호가 일치하지 않습니다.</h6>
      <input type="button" class="close3" id=update-pw  value="확인" />
   
   </div>
   <!-- 여기까지 작성하세요. 스크립트는 아래에 더 작성해도 무관함. -->

   <div id="footer"></div>
</body>
<script type="text/javascript">
      
   //랜덤함수 생성
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
   
      var random = randomnum();
      var phReg =/^[0-9]{10,11}$/; 
      
      $(document).ready(function(){
      
         var AuthTimer = new $ComTimer();
         
         //문자보내기 - 아이디찾기
         $("#authbtn").click(function(event){
        	 
        	 var phonechk = $(this).prev().val();
             if(phonechk == "" || !phReg.test(phonechk)){
                Swal.fire("","핸드폰 번호를 올바르게 입력하시기 바랍니다.","warning");
                return false;
             }
             
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
         
   
         //인증번호 확인 - 아이디찾기
         $(document).on("click","#smsbtn",function(){
            if($("#member_sns").val()==random){
               console.log("인증성공");
               AuthTimer.fnStop();
               AuthTimer.domId = "";
               document.getElementById('timer').innerHTML = "";
               $("#authbtn").attr('disabled', false);
               $(".text h4").css("display","none");
               $(".text #authsucess").css("display","block");
               $(".text #show-id").css("display","block");
               $(".text #change-pw").css("display","block");
               authchk = "1";
            }else{
               console.log("인증실패");
               $("#authbtn").attr('disabled', false);
               $(".text h4").css("display","none");
               $(".text #authfail").css("display","block");
               $(".text #show-id").css("display","none");
               $(".text #change-pw").css("display","none");
               
            }
          });
         
       //문자보내기 - 비밀번호찾기
         $("#authbtn2").click(function(event){
        	 
        	 var phonechk = $(this).prev().val();
             if(phonechk == "" || !phReg.test(phonechk)){
                Swal.fire("","핸드폰 번호를 올바르게 입력하시기 바랍니다.","warning");
                return false;
             }
             
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
             var phonenum = $("#member_phone2").val();
             
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
                     AuthTimer.domId = document.getElementById("timer2");
                     $("#authbtn2").attr('disabled', true);
                    },
                    error: function (e) {
                   console.error(e);
                }
             });
          }
            
         });   
         
       //인증번호 확인 - 비밀번호 찾기
         $(document).on("click","#smsbtn2",function(){
            if($("#member_sns2").val()==random){
               console.log("인증성공");
               AuthTimer.fnStop();
               AuthTimer.domId = "";
               document.getElementById('timer2').innerHTML = "";
               $("#authbtn2").attr('disabled', false);
               $(".text h5").css("display","none");
               $(".text #authsucess2").css("display","block");
               $(".text #authfail2").css("display","none");
               $(".text #change-pw").css("display","block");
               authchk = "1";
            }else{
               console.log("인증실패");
               $("#authbtn2").attr('disabled', false);
               $(".text h5").css("display","none");
               $(".text #authsucess2").css("display","none");
               $(".text #authfail2").css("display","block");
               $(".text #change-pw").css("display","none");
               
            }
          });  
         
       
        var pwReg = /^(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9])(?=.*[0-9]).{8,16}$/;
         
         //비밀번호체크V
          $(document).on("propertychange change keyup paste","#member_password2",function(){
             if(!pwReg.test($("#member_password2").val())){
                $(".changepass h5").css("display","block");
             } else {
                $(".changepass h5").css("display","none");
             }
             
           });
          
          //비밀번호 일치 체크V
               $(document).on("propertychange change keyup paste","#pw2",function(){
                  if($('#member_password2').val() != $('#pw2').val()) {
                      $(".changepass h6").css("display","block"); 
                  } else {
                      $(".changepass h6").css("display","none"); 
                  }
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
                      Swal.fire("","인증시간이 초과하였습니다. 다시 인증해주시기 바랍니다.","warning");
                  }
              }
              ,fnStop : function(){
                  clearInterval(this.timer);
              }
          }
          
        
          
</script>   

</html>