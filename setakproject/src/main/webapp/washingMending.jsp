<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "com.spring.setak.*" %>
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<%
	ArrayList<WashingVO> list = (ArrayList<WashingVO>)request.getAttribute("list");
	String wash_tprice = request.getParameter("wash_tprice");

	String member_id = null;

	if(session.getAttribute("member_id")== null){
		out.println("<script>");
		out.println("alert('로그인 후 이용 가능합니다.')");
		out.println("location.href='login.do'");
		out.println("</script>");
	}
%>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel="shortcut icon" href="favicon.ico">
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="./css/default.css"/>
	<link rel="stylesheet" type="text/css" href="./css/mending.css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#header").load("./header.jsp")
			$("#footer").load("./footer.jsp")
			
			//세탁, 수선, 보관 탭 눌렀을 때
			$(".tab").on("click", function(event) {
				if($(this).hasClass("nonono")){
					event.preventDefault();
					Swal.fire("","해당되는 세탁물이 없습니다.","warning");
				}else{
					$(".tab").removeClass("active");
					$(".hash").empty();
					$(".size_input p input").val('');
					$(".details form")[0].reset();
					$(".details form")[1].reset();
					$(".details form")[2].reset();
					maxAppend = 0;
					$(".tab-content").removeClass("show");
					$(this).addClass("active");
					$($(this).attr("href")).addClass("show");
					llength ="";
					rlength ="";
					tlength ="";
					details_text = "";
					filename="";
					data = new FormData();
				}
			});
			
			//세탁, 수선, 보관 탭 눌렀을 때 위로 올라가는 제이쿼리
			var windowWidth = $(window).width();
			if (windowWidth > 769) {
				$('.tab-list a').click(function() {
					if($(this).hasClass("nonono")){
						
					}else{
						$('html, body').animate({
							scrollTop : $($.attr(this, 'href')).offset().top - 200
						}, 500);
						return false;
					}
				});
			} else {
				$('.tab-list a').click(function() {
					event.preventDefault();
				});
				$('.step img').attr("src","images/ms2.png");
	            //모바일에서는 여기서 치수 입력
	            $('.left_length').removeAttr("disabled");
	            $('.right_length').removeAttr("disabled");
	            $('.total_length').removeAttr("disabled");
			}
			
			//치수 입력 시 폼에도 값 넘기기
			var llength ="";
			var rlength ="";
			var tlength ="";
			var details_text = "";
			
			$("#left input").keyup(function(){
		        $('.left_length').val($(this).val());
		        llength= $(this).val();
		    });
			$("#right input").keyup(function(){
		        $('.right_length').val($(this).val());
		        rlength= $(this).val();
		    });
			$("#length input").keyup(function(){
		        $('.total_length').val($(this).val());
		        tlength= $(this).val();
		    });

			$(".details_text").keyup(function(){
				details_text = $(this).val();
		    });
			
			//태그 기능, 계산기능
			var maxAppend = 0;
			var tprice = parseInt(0);
			var kind;			
			var kind_str = new Array();
			
			$(".mending-list").on("click", function() {
				if (maxAppend >= 10){
					Swal.fire("","최대 10개 선택 가능합니다.","info");
					return;
				}
				kind = $.attr(this, 'value');
				var kind_price = $($(this).children('.price')).text();
				$(".hash").append("<p class='hashvl'>&nbsp;"+kind+"&nbsp;<span>X</span><span style='display:none;'>,"+ kind_price +",</span></p>");
	            maxAppend++;
			});
			$(document).on('click','.hashvl',function(event) {
				$(this).remove();
				maxAppend--;
			});
			
			//사진 업로드 ajax - 클라우드로 저장됨.
			var filecontent;
	 		var filename;
	 		var data = new FormData();
	 		
	 		$(document).on("change",".fileupload",function(){
	 			filecontent = $(this)[0].files[0];
	 			filename = Date.now() + "_" + $(this)[0].files[0].name;
	 			data.append("files", filecontent);
	 			data.append("filename", filename);
	 		}); 
	 		function photo(){
	 			if(filecontent != null){
	 				data.append("purpose", "mending");
	 				
	 				$.ajax({
	 					type: "POST",
	 		            enctype: 'multipart/form-data',
	 		            url: "/setak/testImage.do",
	 		            data: data,
	 		            processData: false,
	 		            contentType: false,
	 		            cache: false,
	 		            dataType: 'text',
	 		            success: function (data) {
	 					},
	 	                error: function (e) {
	 	                	alert("실패실패실패!!")
	 	                	console.log(e);
	 					}
	 				});
	 			}
	 			else{
	 				event.preventDefault();
	 			}
	 			filecontent = null;
	 			data = new FormData();
	 			$(".fileupload").val("");
			};
			
			//추가 버튼 눌렀을 때
			$(".add_button").on("click", function() {
				var sortation = document.getElementsByClassName('active');
				var str = "";
				
				if(maxAppend==0){
					Swal.fire("","선택 된 수선내용이 없습니다.","info");
					return;
				}

				var hashvl = ($(".hash").html()).split('&nbsp;');
				var pricevl = ($(".hash").html()).split(',');
				
				var kind_str = "";
				var price_str ="";
				for(var i=1; i<maxAppend*2-1; i+=2 ){
					kind_str +=hashvl[i] + ",";	//이건 수선할 내용
					price_str +=pricevl[i] + ",";	//이건 수선할내용에 대한 각 가격들
					tprice += parseInt(pricevl[i]);	//토탈 가격
	            };
	            kind_str +=hashvl[i];
	            price_str +=pricevl[i];
	            tprice += parseInt(pricevl[i]);
	            
				str += '<tr>';
				str += '<td><input type="checkbox" name="check" value="yes" checked></td>';
				str += '<td>'+sortation[0].innerHTML+'</td>';
				str += '<td style="display:none;"><input type="hidden" name="repair_cate" value="'+sortation[0].innerHTML+'">';
				str += '<input type="hidden" name="repair_kind" value="'+kind_str+'">';
				str += '<input type="hidden" name="repair_var1" value="'+llength*(-1)+'">';
				str += '<input type="hidden" name="repair_var2" value="'+rlength*(-1)+'">';
				str += '<input type="hidden" name="repair_var3" value="'+tlength*(-1)+'">';
				str += '<textarea name="repair_content">'+details_text+'</textarea></td>';
				str += '<td>';
				str += '<select name="repair_code">';
				str += '<option value="가">가</option>';
				str += '<option value="나">나</option>';
				str += '<option value="다">다</option>';
				str += '<option value="라">라</option>';
				str += '<option value="마">마</option>';
				str += '<option value="바">바</option>';
				str += '<option value="사">사</option>';
				str += '<option value="아">아</option>';
				str += '<option value="자">자</option>';
				str += '<option value="차">차</option>';
				str += '<option value="카">카</option>';
				str += '<option value="타">타</option>';
				str += '<option value="파">파</option>';
				str += '<option value="하">하</option>';
				str += '<option value="고">고</option>';
				str += '<option value="노">노</option>';
				str += '<option value="도">도</option>';
				str += '<option value="로">로</option>';
				str += '<option value="모">모</option>';
				str += '<option value="보">보</option>';
				str += '<option value="소">소</option>';
				str += '<option value="오">오</option>';
				str += '<option value="조">조</option>';
				str += '<option value="초">초</option>';
				str += '<option value="코">코</option>';
				str += '<option value="토">토</option>';
				str += '</select>';
				str += '</td>';
				str += '<td><input type="text" maxlength="3" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" name="repair_count" value="1" id="" class="count">';
				str += '<div><a class="bt_up">▲</a><a class="bt_down">▼</a></div>';
				str += '</td>';
				str += '<td name="'+tprice+'" class="tprice">'+tprice+'원';
				str += '</td>';
				str += '<input class="repair_price" type="hidden" name="repair_price" value="'+price_str+'">';
				str += '<td><input type="hidden" name="repair_file" id="repair_file" value="'+filename+'"></td>';
				str += '<input class="price_str" type="hidden" name="'+price_str+'">';
				str += '</tr>';		
				
	    		photo();
	            
				$(".mending_order_title").after(str);
				$(".hash").empty();
				$(".size_input p input").val('');
				$(".details form")[0].reset();
				$(".details form")[1].reset();
				$(".details form")[2].reset();
				filecontent = null;
	            filename = "";
				maxAppend = 0;
				tprice = parseInt(0);
				sumprice();
			});
			
			//총 합계
			sumprice = function() {
				var sum = 0;
				var tr = $(".mending_order").children().children();
				var pricearr = new Array();
				tr.each(function(i) {
					pricearr.push(tr.eq(i).children().eq(5).text())
				});
				//tr이 지금 두개라 구분창 말고 값가진 애들만 받기위해 한번 더 돌림 i를 1로.
				for(var i = 1; i<pricearr.length;i++){
					sum += parseInt(pricearr[i].split('원')[0]);
				}
				
				$(".mtot_price").html(numberFormat(sum));
				$(".tot_price").html(numberFormat(sum+(parseInt(<%=wash_tprice%>))));
				$(".mending_tprice").val(sum);
			}
			
			//수량
			$(document).on('click','.bt_up',function(event) {
				var n = $('.bt_up').index(this);
				var num = $(".count:eq(" + n + ")").val();
				num = $(".count:eq(" + n + ")").val(num * 1 + 1);
				
				$.pricefun(n);
			});
			$(document).on('click','.bt_down',function(event) {
				var n = $('.bt_down').index(this);
				var num = $(".count:eq(" + n + ")").val();
				if (num == 1) {
					Swal.fire("","최저 수량은 1개입니다.","info");
				} else {
					num = $(".count:eq(" + n + ")").val(num * 1 - 1);
				}
				
				$.pricefun(n);
			});
			
			//수량에 따른 값변경
			$.pricefun = function(n){
				var num = parseInt($(".count:eq(" + n + ")").val());
				var price =$(".price_str:eq(" + n + ")").attr('name');	//수량 몇개를 올려도 name은 안변하니까 해둔것.
				var countprice = parseInt($(".tprice:eq(" + n + ")").attr('name')); //같은이유. 초기값 그대로
				$(".tprice:eq(" + n + ")").html((num*countprice) + "원");	

				var price_split = price.split(",");
				var re_price ="";
				for(var i=0; i<price_split.length-1; i++){
					re_price += num*price_split[i] + ",";
				}
				re_price +=num*price_split[i];
				
				$(".repair_price:eq("+n+")").val(re_price);
				sumprice(); 
			};
			$(document).on("propertychange change keyup paste",".count", function(){
				var n = $('.count').index(this);
				$.pricefun(n);
			});
			
			//전체선택, 전체선택해제
			$("#allcheck").click(function(){
		        if($("#allcheck").prop("checked")){
		            $("input[name=check]").prop("checked",true);
		        }else{
		            $("input[name=check]").prop("checked",false);
		        }
		    })
		    //선택 삭제
		    $(".chkdelete").click(function(){
				var checkbox = $("input[name=check]:checked");
				checkbox.each(function(){
					var tr = checkbox.parent().parent();
					tr.remove();
				}) 
				sumprice();
			});
			
			/* 숫자 3자리마다 쉼표 넣어줌 */
			numberFormat = function(inputNumber) {
				   return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
			}
			$(".wtot_price").html(numberFormat(parseInt(<%=wash_tprice%>)));
			$('.tot_price').html(numberFormat(parseInt(<%=wash_tprice%>)));
			
			//다음 클릭 시
			$(document).on('click','.gocart',function(event) {
				//택 겹칠시
				function checkDupl() {
	               var temp = [];
	               var obj = $('select[name="repair_code"]');
	               var x = 0;
	                 
	               // 현재 옵션값 임시 배열에 저장
	               $(obj).each(function(i) {
	                  temp[i] = $(this).val();
	                });
	               // 임시 배열값 과 옵션값이 같으면 임시 변수값 증가
	               $(temp).each(function(i) {
	                    $(obj).each(function() {
	                        if(temp[i] == $(this).val() ) {
		                        x++;
	                        }
	                    });
	                });
	  
	               if(x > temp.length) {
	            	   Swal.fire("",'동일한 택이 존재합니다.',"info");
	                   event.preventDefault();
	               }
	            }
		        checkDupl();
			});

			//세탁물중에 해당사항없으면 탭 비활성화
			<% 
			String[] sol = new String[list.size()];
			for (int j = 0; j < list.size(); j++) {
				sol[j] =  list.get(j).getWash_cate();
			}
			boolean sol_top = Arrays.asList(sol).contains("상의");
			boolean sol_bot = Arrays.asList(sol).contains("하의");
			boolean sol_out = Arrays.asList(sol).contains("아우터");
			
			if(sol_top == false){//상의가 없다.
			%>
				$(".tab").removeClass("active");
				$(".tab-content").removeClass("show");
				
				$(".tab:nth-child(1)").addClass("nonono");
			<%	
				if(sol_bot == false && sol_out == true){	//상의가 없는데 하의도없다 근데 아우터는 있다.
			%>
					$(".tab:nth-child(2)").addClass("nonono");
					$(".tab:nth-child(3)").addClass("active");
					$($(".tab:nth-child(3)").attr("href")).addClass("show");
			<%
				} else if(sol_bot == true && sol_out == false){	//상의가 없는데 하의는 있고, 아우터가 없다.
			%>	
					$(".tab:nth-child(3)").addClass("nonono");
					$(".tab:nth-child(2)").addClass("active");
					$($(".tab:nth-child(2)").attr("href")).addClass("show");
			<%
				} else if(sol_bot == false && sol_out == false){	//싹다 없다
			%>
					$(".tab:nth-child(2)").addClass("nonono");
					$(".tab:nth-child(3)").addClass("nonono");
					$($(".tab:nth-child(4)").attr("href")).addClass("show");
			<%
				} else { //상의빼고 다 있다.
			%>
					$(".tab:nth-child(2)").addClass("active");
					$($(".tab:nth-child(2)").attr("href")).addClass("show");
			<%
				}
			
			} else if(sol_bot == false){ //하의가 없다. 상의랑 아우터는 있다.
			%>
				$(".tab:nth-child(2)").addClass("nonono");
			<%
				if(sol_out == false){ //하의가 없는데 아우터도 없다. 상의는 있다.
			%>
					$(".tab:nth-child(3)").addClass("nonono");
			<%
				}
			
			} else if(sol_out == false){ // 아우터가 없다. 상의랑 하의는 있다.
			%>
				$(".tab:nth-child(3)").addClass("nonono");
			<%
			}
			%>
		});
		//한글, 영어 금지
		function onlyNumber(event) {
			event = event || window.event;
			var keyID = (event.which) ? event.which : event.keyCode;
			if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105)
					|| keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
				return;
			else
				return false;
		}
		function removeChar(event) {
			event = event || window.event;
			var keyID = (event.which) ? event.which : event.keyCode;
			if (keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
				return;
			else
				event.target.value = event.target.value.replace(/[^0-9]/g, "");
		}
	</script>
</head>
<body>
	<div id="header"></div>

	<section id="mending">
		<div class="content">
			<div class="title-text">
				<h2>세탁 서비스</h2>
			</div>
			<div class="mending">
				<div class="step"><img src="images/s2.png" alt="step2_수선"></div>
				<p>※ 세탁 신청이 들어간 세탁물에 대해서만 수선이 가능한 페이지입니다. 수선만 맡기실 옷들은 수선서비스 페이지를 이용해주세요.</p>
				<div class="tabs">
					<div class="tab-list">
						<a href="#one" id="tab" class="tab active">상의</a>
						<a href="#two" id="tab" class="tab">하의</a>
						<a href="#three" id="tab" class="tab">아우터</a>
						<a href="#four" id="tab" class="tab" style="display:none;"></a>
					</div>
				</div>

				<div id="one" class="tab-content show">
					<ul class="top">
						<li class="mending-list" value="소매줄임">소매줄임<br><span>원</span><span class="price">5000</span></li>
						<li class="mending-list" value="기장줄임">기장줄임<br><span>원</span><span class="price">5000</span></li>
						<li class="mending-list" value="단추수선">단추수선<br><span>원</span><span class="price">2000</span></li>
						<li class="mending-list" value="튿어짐">튿어짐<br><span>원</span><span class="price">7000</span></li>
					</ul>
					<ul class="top">
						<li class="mending-list" value="지퍼수선">지퍼수선<br><span>원</span><span class="price">16000</span></li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
					<ul class="details">
						<li><img src="images/top.png" alt="상의"></li>
						<li>
							<div class="top_size_input">
								<div class="size_input">
									<p id="left">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
									<p id="right">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
									<p id="length">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
								</div>
							</div>
							<form id  ="fileUploadForm" enctype="multipart/form-data">
								<div class="hash">
								</div>
								<p>※ 왼쪽 소매 줄임 : - <input type="text" class="left_length" value="" disabled>cm</p>
								<p>※ 오른쪽 소매 줄임 : - <input type="text" class="right_length"value="" disabled>cm</p>
								<p>※ 총기장(기장 줄임) : - <input type="text" class="total_length" value="" disabled>cm</p>
								<p>※ <input type="file" class="fileupload" name="file" accept="image/*" style="width:92%; display:inline;"></p>
                        		<textarea class="details_text" placeholder="추가 요청사항이 있다면 알려주세요."></textarea>
								<a class="add_button" href="javascript:">추가</a>
							</form>
						</li>
					</ul>
					<p>※ 단추 수선은 헐렁이거나 떨어진 단추를 달아드리는 상품이며, 단추가 없을 시 유사한 단추로 달아드립니다. 수선하실 단추 수량만큼 추가해 주세요.<br><br><br></p>
				</div>
				
				<div id="two" class="tab-content">
					<ul class="top">
						<li class="mending-list" value="허리줄임">허리줄임<br><span>원</span><span class="price">5000</span></li>
						<li class="mending-list" value="기장줄임">기장줄임<br><span>원</span><span class="price">5000</span></li>
						<li class="mending-list" value="단추수선">단추수선<br><span>원</span><span class="price">2000</span></li>
						<li class="mending-list" value="튿어짐">튿어짐<br><span>원</span><span class="price">7000</span></li>
					</ul>
					<ul class="top">
						<li class="mending-list" value="지퍼수선">지퍼수선<br><span>원</span><span class="price">12000</span></li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
					<ul class="details">
						<li><img src="images/bottom.png" alt="하의"></li>
						<li>
							<div class="bottom_size_input">
								<div class="size_input">
									<p id="left">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
									<p id="right">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
									<p id="length">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
								</div>
							</div>
							<form>
								<div class="hash">
								</div>
								<p>※ 왼쪽 기장 줄임 : - <input type="text" class="left_length" value="" disabled>cm</p>
								<p>※ 오른쪽 기장 줄임 : - <input type="text" class="right_length" value="" disabled>cm</p>
								<p>※ 허리 줄임 : - <input type="text" class="total_length" value="" disabled>cm</p>
								<p>※ <input type="file" class="fileupload" name="file" accept="image/*" style="width:92%; display:inline;"></p>
                        		<textarea class="details_text" placeholder="추가 요청사항이 있다면 알려주세요."></textarea>
								<a class="add_button" href="javascript:">추가</a>
							</form>
						</li>
					</ul>
					<p>※ 단추 수선은 헐렁이거나 떨어진 단추를 달아드리는 상품이며, 단추가 없을 시 유사한 단추로 달아드립니다. 수선할 단추 수량만큼 눌러주세요.<br><br><br></p>
				</div>
				
				<div id="three" class="tab-content">
					<ul class="top">
						<li class="mending-list" value="소매줄임">소매줄임<br><span>원</span><span class="price">5000</span></li>
						<li class="mending-list" value="기장줄임">기장줄임<br><span>원</span><span class="price">5000</span></li>
						<li class="mending-list" value="단추수선">단추수선<br><span>원</span><span class="price">2000</span></li>
						<li class="mending-list" value="튿어짐">튿어짐<br><span>원</span><span class="price">10000</span></li>
					</ul>
					<ul class="top">
						<li class="mending-list" value="지퍼수선">지퍼수선<br><span>원</span><span class="price">20000</span></li>
						<li></li>
						<li></li>
						<li></li>
					</ul>
					<ul class="details">
						<li><img src="images/outer.png" alt="아우터"></li>
						<li>
							<div class="outer_size_input">
								<div class="size_input">
									<p id="left">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
									<p id="right">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
									<p id="length">- <input type="text" maxlength="2" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)"></p>
								</div>
							</div>
							<form>
								<div class="hash">
								</div>
								<p>※ 왼쪽 소매 줄임 : - <input type="text" class="left_length" value="" disabled>cm</p>
								<p>※ 오른쪽 소매 줄임 : - <input type="text" class="right_length" value="" disabled>cm</p>
								<p>※총기장(기장 줄임) : - <input type="text" class="total_length" value="" disabled>cm</p>
								<p>※ <input type="file" class="fileupload" name="file" accept="image/*" style="width:92%; display:inline;"></p>
                        		<textarea class="details_text" placeholder="추가 요청사항이 있다면 알려주세요."></textarea>
								<a class="add_button" href="javascript:">추가</a>
							</form>
						</li>
					</ul>
					<p>※ 단추 수선은 헐렁이거나 떨어진 단추를 달아드리는 상품이며, 단추가 없을 시 유사한 단추로 달아드립니다. 수선하실 단추 수량만큼 추가해 주세요.<br><br><br></p>
				</div>
				
				<div id="four" class="tab-content">
					<ul class="top">
						<li>※수선 가능한 세탁물이 없습니다.</li>
					</ul>
				</div>
				
				<p>※ 받으신 웰컴키트 안 '택'에  선택하신 택 코드를 동일하게 적어서 보내주세요.</p>
				<form name="washingMendingform" action="./washingKeepform.do" method="post" enctype="multipart/form-data">
					<table class="mending_order">
						<tr class="mending_order_title">
							<td width="5%"><input type="checkbox" id = "allcheck" checked></td>
							<td style="width:20%;">구분</td>
							<td style="width:25%;">택코드</td>
							<td style="width:25%;">수량</td>
							<td style="width:25%;">합계</td>
						</tr>
					</table>
					<%
						for (int i = 0; i < list.size(); i++) {
					%>
					<input type= "hidden" name="wash_cate" value="<%=list.get(i).getWash_cate()%>">
					<input type= "hidden" name="wash_kind" value="<%=list.get(i).getWash_kind()%>">
					<input type= "hidden" name="wash_method" value="<%=list.get(i).getWash_method()%>">
					<input type= "hidden" name="wash_count" value="<%=list.get(i).getWash_count()%>">
					<input type= "hidden" name="wash_price" value="<%=list.get(i).getWash_price()%>">
					<%
						}
					%>
					<div class="total_price">
						<p>세탁비 <span class="wtot_price">0</span>원 + 수선비 <span class="mtot_price">0</span>원 = 합계 : <span class="tot_price">0</span>원</p>
						<p>수선비 : <span class="mtot_price">0</span>원</p>
						<input type="hidden" name="wash_tprice" value="<%=wash_tprice %>" class="wash_tprice">
						<input type="hidden" name="mending_tprice" value="0" class="mending_tprice">
					</div>
					<div class="total-button">
						<a><input type="submit" value="다음" class="gocart"></a>
						<a><input type="button" value="이전" onclick="history.back(); return false;"></a>
						<input type="button" value="선택삭제" class="chkdelete">
					</div>
				</form>
			</div>
		</div>
	</section>
	
	<div id="footer"></div>
</body>
</html>