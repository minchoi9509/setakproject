<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "com.spring.community.FaqVO" %>
<%      
   ArrayList<FaqVO> faqlist = (ArrayList<FaqVO>) request.getAttribute("faqdata");      
%>  

<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <title>세탁곰 관리자페이지</title>
   <link rel="shortcut icon" href="favicon.ico">
   <link rel="stylesheet" type="text/css" href="../css/admin.css"/>
   <link rel="stylesheet" type="text/css" href="../css/admin_faq.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
   <script src="https://kit.fontawesome.com/4b95560b7c.js" crossorigin="anonymous"></script>
   <script type="text/javascript">
      $(document).ready(function() {         
         //수+삭모달팝업 오픈
          $(".open").on('click', function(){
             var fnum = $(this).prev().attr("value");
             console.log("fnum="+fnum);  
             var a = $(this).parent().parent().children('#f-stan');             
             var fcate = a.text();
             console.log("fcate="+fcate);  
             var ftitle = a.next().text();
             console.log("ftitle="+ftitle);  
             var fcon = a.next().next().text();
             console.log("fcon="+fcon);              
             $("#ad-faq-setting").show();   
             $(".dim").show();   
            
             
             $("#ad-faq-setting-btn2").on('click', function(){  
            	 if(!$("#ad-faq-form").hasClass("active")){
            		$('#u-faq-op').prev().prev().show(); 
            		$("#ad-faq-setting-btn2").text("수정취소");
            		$("#ad-faq-setting-btn3").text("삭제");
                	$("#ad-faq-form").addClass("active");
                	$("#ad-faq-form").attr('action', "./admin_faqUpdate.do");       	
                	$('#ad-faq-submit').before('<tr id="u-faq-op" ><td colspan="2"><span><input type="hidden" id="u-faq_num" name="faq_num" value="" readonly="readonly"></span></td></tr>');
                	$('#u-faq-op').children().hide();
                	$("span #u-faq_num").val(fnum);
                	$("tr #u-faq-cate").val(fcate);               
                	$('tr #u-faq-title').val(ftitle);
                	$('tr #u-faq-con').val(fcon); 
                	$('#u-faq-op').prev().prev().show();
                	$('#u-faq-submit').attr('disabled', false ); 
                }
                else{
                	$('#u-faq-op').prev().prev().show();
                	$("#ad-faq-setting-btn2").text("수정");
                	$("#ad-faq-setting-btn3").text("삭제");
                	$("#ad-faq-form").removeClass("active");
                	$('#u-faq-op').detach();
                	$("span #u-faq_num").val("");
                	$("tr #u-faq-cate").val("");               
                	$('tr #u-faq-title').val("");
                	$('tr #u-faq-con').val("");
                	$('#u-faq-submit').attr('disabled', true);
                }
            
             });
          
             $("#ad-faq-setting-btn3").on('click', function(){
            	 if(!$("#ad-faq-form").hasClass("active")){   	 
	            	$("#ad-faq-setting-btn3").text("삭제취소");
	            	$("#ad-faq-setting-btn2").text("수정");
	            	$("#ad-faq-form").addClass("active");
	                $("#ad-faq-form").attr('action', "./admin_faqDelete.do");
	                $('#ad-faq-submit').before('<tr id="u-faq-op" ><td colspan="2"><span><input type="hidden" id="u-faq_num" name="faq_num" value="" readonly="readonly"></span></td></tr>');
	            	$('#u-faq-op').children().hide();
	            	$("span #u-faq_num").val(fnum);
	            	$("tr #u-faq-cate").val("");               
                	$('tr #u-faq-title').val("");
                	$('tr #u-faq-con').val("");
                	$('#u-faq-op').prev().prev().hide();
	            	$('tr #u-faq-con').val("삭제합니다");
	            	$('#u-faq-submit').attr('disabled',  false); 
            	 }
            	 else{
            		 $('#u-faq-op').prev().prev().show();
            		 $("#ad-faq-setting-btn3").text("삭제");
            		 $("#ad-faq-setting-btn2").text("수정");
                 	 $("#ad-faq-form").removeClass("active");
                 	 $('#u-faq-op').detach();
                	 $("span #u-faq_num").val("");
                	 $('tr #u-faq-con').val("");                	
                	 $('#u-faq-submit').attr('disabled', true);
            	 }	            	
	            	
             });
 
             
             
          });
          
          $(".close").on('click', function(){
             $(this).parent().hide();   
             $(".dim").hide();
             location.reload();
         });
         
          //추가 모달
          $(".open2").on('click', function(){       
             $("#ad-faq-insert").show();   
             $(".dim2").show();   
          })
          $(".close2").on('click', function(){
              $(this).parent().hide();   
              $(".dim2").hide();
              location.reload();
          });
          
          
         $("#admin").load("./admin.jsp")
         $(function (){   
             tab('#admin-faq-tab', 0); //"아뒤: 탭" 의 1번째 li를 디폴트로 선택              
            function tab(e, num){ 
             //위에 선언한것 과 유사하게 '함수tab'은 변수 e 와 num 을 사용하는데 
             // e에는 '#tab',num 에는 숫자 가 들어 갈것 같은데 -> ()
               var num = num || 0;//(or)
                var menu = $(e).children(); // 메뉴는 #tab의 자손이다
                var con = $(e+'_con').children(); // 컨텐츠는 #tab_con의 자손이다
                var select = $(menu).eq(num); // 셀렉트는 메뉴의(num)번쨰 값을 가져와라.
                var i = num; //i 는 num으로선언
                select.addClass('on'); //셀렉트 객체에 'on'이라는 클래스 값을 추가할수 있다//카테고리 부분에 파란색 영역으로 바뀌는 부분
                con.eq(num).show();
                menu.click(function(){
                   if(select!==null)
                   {
                      select.removeClass("on"); //.tab li.on
                        con.eq(i).hide();
                    }
                   select = $(this);   
                    i = $(this).index();//현재 내가 누른 바로 그 셀렛트의 순서 .index() 메서드는 일치하는 요소들중 선택한 요소가 몇번째 순번을 가지고 있는지 알 수 있는메서드 이다.
                    select.addClass('on');
                    con.eq(i).show();
                });
              }
          });
      
      });
   </script>
</head>
<body>
   <div id="admin"></div>
   <div class="content">
   <!-- 여기서부터 작업하세요. -->
   <h1><a href="./admin_faq.do">FAQ관리 </a> <small class="open2"> FAQ 작성하기</small></h1>
   
   <div class="admin-faq-body">   
      
   <ul id="admin-faq-tab">
       <li class="">기본정보</li><li class="">이용정보</li><li class="">수거/배송</li>
       <li class="">세탁</li><li class="">요금/결제</li><li class="">보관</li>        
   </ul>         
   
   <div id="admin-faq-tab_con">      
   <table id=faq-table>   
      <thead id=faq-thead ><tr>
         <th width="35px">번호</th>
         <th width="70px">분류</th>
         <th width="200px">제목</th>
         <th width="600px">내용</th>
         <th colspan="2">작성일</th></tr>
      </thead>
      <%for(int i = 0; i<faqlist.size(); i++){ FaqVO vo = (FaqVO)faqlist.get(i);  %>
         <%if (vo.getFaq_cate().equals("기본정보")){%>
      <tbody><tr>
         <td><%=i+1%></td> 
         <td id="f-stan"><%=vo.getFaq_cate() %></td> 
         <td><%=vo.getFaq_title() %></td> 
         <td><%=vo.getFaq_content() %></td> 
         <td><%=vo.getFaq_date() %></td> 
         <td><input type="hidden" name="faq_num" id="faq_num" value="<%=vo.getFaq_num()%>">
            <input type="button" class="open" name="setting-button" value="설정"></td></tr>      
      </tbody><%} %><%} %>
   </table>
   
   <table id=faq-table>   
      <thead id=faq-thead ><tr>
         <th width="35px">번호</th>
         <th width="70px">분류</th>
         <th width="200px">제목</th>
         <th width="600px">내용</th>
         <th colspan="2">작성일</th></tr>
      </thead>
      <%for(int i = 0; i<faqlist.size(); i++){ FaqVO vo = (FaqVO)faqlist.get(i);  %>   
         <%if (vo.getFaq_cate().equals("이용정보")){%>
      <tbody><tr>
         <td><%=i+1%></td> 
         <td id="f-stan"><%=vo.getFaq_cate() %></td> 
         <td><%=vo.getFaq_title() %></td> 
         <td><%=vo.getFaq_content() %></td> 
         <td><%=vo.getFaq_date() %></td> 
         <td><input type="hidden" name="faq_num" id="faq_num" value="<%=vo.getFaq_num()%>" >
            <input type="button" class="open" name="setting-button" value="설정"></td></tr>      
                
      </tbody><%} %><%} %>
   </table>
   
   <table id=faq-table>   
      <thead id=faq-thead ><tr>
         <th width="35px">번호</th>
         <th width="70px">분류</th>
         <th width="200px">제목</th>
         <th width="600px">내용</th>
         <th colspan="2">작성일</th></tr>
      </thead>
      <%for(int i = 0; i<faqlist.size(); i++){ FaqVO vo = (FaqVO)faqlist.get(i);  %>   
         <%if (vo.getFaq_cate().equals("수거/배송")){%>
      <tbody><tr>
         <td><%=i+1%></td> 
         <td id="f-stan"><%=vo.getFaq_cate() %></td> 
         <td><%=vo.getFaq_title() %></td> 
         <td><%=vo.getFaq_content() %></td> 
         <td><%=vo.getFaq_date() %></td> 
         <td><input type="hidden" name="faq_num" id="faq_num" value="<%=vo.getFaq_num()%>">
            <input type="button" class="open" name="setting-button" value="설정"></td></tr>      
      </tbody><%} %><%} %>
   </table>
   
   <table id=faq-table>   
      <thead id=faq-thead ><tr>
         <th width="35px">번호</th>
         <th width="70px">분류</th>
         <th width="200px">제목</th>
         <th width="600px">내용</th>
         <th colspan="2">작성일</th></tr>
      </thead>
      <%for(int i = 0; i<faqlist.size(); i++){ FaqVO vo = (FaqVO)faqlist.get(i);  %>   
         <%if (vo.getFaq_cate().equals("세탁")){%>
      <tbody><tr>
         <td><%=i+1%></td> 
         <td id="f-stan"><%=vo.getFaq_cate() %></td> 
         <td><%=vo.getFaq_title() %></td> 
         <td><%=vo.getFaq_content() %></td> 
         <td><%=vo.getFaq_date() %></td> 
         <td><input type="hidden" name="faq_num" id="faq_num" value="<%=vo.getFaq_num()%>">
             <input type="button" class="open" name="setting-button" value="설정"></td></tr>      
      </tbody><%} %><%} %>
   </table>
   
   <table id=faq-table>   
      <thead id=faq-thead ><tr>
         <th width="35px">번호</th>
         <th width="70px">분류</th>
         <th width="200px">제목</th>
         <th width="600px">내용</th>
         <th colspan="2">작성일</th></tr>
      </thead>
      <%for(int i = 0; i<faqlist.size(); i++){ FaqVO vo = (FaqVO)faqlist.get(i);  %>   
         <%if (vo.getFaq_cate().equals("요금/결제")){%>
      <tbody><tr>
         <td><%=i+1%></td> 
         <td id="f-stan"><%=vo.getFaq_cate() %></td> 
         <td><%=vo.getFaq_title() %></td> 
         <td><%=vo.getFaq_content() %></td> 
         <td><%=vo.getFaq_date() %></td> 
         <td><input type="hidden" name="faq_num" id="faq_num" value="<%=vo.getFaq_num()%>">
            <input type="button" class="open" name="setting-button" value="설정"></td></tr>      
      </tbody><%} %><%} %>
   </table>
   
   <table id=faq-table>   
      <thead id=faq-thead ><tr>
         <th width="35px">번호</th>
         <th width="70px">분류</th>
         <th width="200px">제목</th>
         <th width="600px">내용</th>
         <th colspan="2">작성일</th></tr>
      </thead>
      <%for(int i = 0; i<faqlist.size(); i++){ FaqVO vo = (FaqVO)faqlist.get(i);  %>   
         <%if (vo.getFaq_cate().equals("보관")){%>
      <tbody><tr>
         <td><%=i+1%></td> 
         <td id="f-stan"><%=vo.getFaq_cate() %></td> 
         <td><%=vo.getFaq_title() %></td> 
         <td><%=vo.getFaq_content() %></td> 
         <td><%=vo.getFaq_date() %></td> 
         <td><input type="hidden" name="faq_num" id="faq_num" value="<%=vo.getFaq_num()%>">
            <input type="button" class="open" name="setting-button" value="설정"></td></tr>      
      </tbody><%} %><%} %>
   </table>
   </div><br><br><br><br><br><br><br><br>


<div id="ad-faq-insert">
<h2>FAQ 추가 </h2>
   <form action="./admin_faqInsert.do" method="post" name="ad-faq-insertform" id="ad-faq-insertform" onsubmit="return ruchk();">
   	<table >   
      <thead><tr>
         <th width="10%">번호</th>
         <th width="20%">분류</th>
         <th width="70%" colspan="3">제목</th>
         </tr>
      </thead>
      <tbody>
      <tr>         
         <td width="10%">(자동)</td> 
         <td width="20%">
         <select name="faq_cate">
         	<option value="기본정보" selected="selected">기본정보</option>
         	<option value="이용정보">이용정보</option>
         	<option value="수거/배송">수거/배송</option>
         	<option value="세탁">세탁</option>
         	<option value="요금/결제">요금/결제</option>
         	<option value="보관">보관</option>            	       	
         </select></td> 
         <td width="70%"  colspan="3"><input type="text" name="faq_title" maxlength="50" style="width:450px;"></td> 
       </tr>
       <tr>   
        <th width="80%" colspan="4">내용</th>
        <th width="20%">작성일</th>
      </tr>      
       <tr>   
         <td colspan="4"><textarea name="faq_content" rows="40" cols="60"></textarea></td> 
         <td>(자동)</td>
      </tr>      
      <tr>         
         <td colspan="5"><input type="submit" value="추가"></td>
      </tr>      
      </tbody>
   </table>   
   </form>   
<a class="close2"><i class="fas fa-times" aria-hidden="true" style="color:#444; font-size:30px;"></i></a>
</div>
<div class="dim2"></div>
   
   
   
<div id="ad-faq-setting">
<h2>관리자 설정 </h2>
<div>
	<button id="ad-faq-setting-btn2">수정</button>   
	<button id="ad-faq-setting-btn3">삭제</button>   
</div>
<form action="" id="ad-faq-form" class="ad-faq-form" method="post" enctype="multipart/form-data" name="ad-faq-form" >   
<table id="ad-faq-table">
   <tr><td>
      <select id="u-faq-cate" name="faq_cate">
         <option value="">카테고리</option>
         <option value="기본정보">기본정보</option>
         <option value="이용정보">이용정보</option>
         <option value="수거/배송">수거/배송</option>
         <option value="세탁">세탁</option>
         <option value="요금/결제">요금/결제</option>
         <option value="보관">보관</option>            
      </select></td> 
      <td>제목 :&nbsp;<input name="faq_title" id="u-faq-title" type="text"></td></tr>
    <tr><td colspan="2" ><p>내용 &nbsp;</p><textarea name="faq_content" id="u-faq-con"></textarea></td></tr>                 
   <tr id="ad-faq-submit"><td colspan="2">
      <input id="u-faq-submit" type="submit" name="submit" value="확인" disabled="disabled">      
      <input id="cbtn" type="button" value="취소" onclick="location.reload();"/></td>    
   </tr>
</table>
</form>
<a class="close"><i class="fas fa-times" aria-hidden="true" style="color:#444; font-size:30px;"></i></a>
</div>

<div class="dim"></div>

   </div>

   </div> <!-- class="content" -->
<!--</div> 여기까지 작업 하세요 -->   
</body>
</html>