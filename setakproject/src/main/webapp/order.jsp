<%@page import="com.spring.member.*"%>
<%@ page language = "java" contentType = "text/html; charset = UTF-8" pageEncoding = "UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ page import = "com.spring.setak.WashingVO" %>
<%@ page import = "com.spring.setak.MendingVO" %>
<%@ page import = "com.spring.setak.KeepVO" %>
<%@ page import = "com.spring.setak.*" %>

<%@ page import = "java.util.ArrayList" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
   ArrayList<WashingVO> washingList = (ArrayList<WashingVO>)request.getAttribute("washingList");
   ArrayList<MendingVO> mendingList = (ArrayList<MendingVO>)request.getAttribute("mendingList");
   ArrayList<KeepVO> keepList = (ArrayList<KeepVO>)request.getAttribute("keepList");

   MemberVO memberVO = (MemberVO) request.getAttribute("memberVO");
   String member_phone1 = (String) request.getAttribute("member_phone1");
   String member_phone2 = (String) request.getAttribute("member_phone2");
   String member_phone3 = (String) request.getAttribute("member_phone3");
   String member_addr1 = (String) request.getAttribute("member_addr1");
   String member_addr2 = (String) request.getAttribute("member_addr2");
   String zipcode = (String) request.getAttribute("zipcode");
   
   int havePoint = (int)request.getAttribute("havePoint"); 
   int haveCoupon = (int)request.getAttribute("haveCoupon"); 
   
   ArrayList<CouponVO> couponList = (ArrayList<CouponVO>)request.getAttribute("couponList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰</title>
	<link rel = "shortcut icon" href = "favicon.ico">
   <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">
   <link rel="stylesheet" type="text/css" href="./css/default.css"/>
   <link rel="stylesheet" type="text/css" href="./css/order.css"/>
   
   <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
   <script type="text/javascript" src="https://service.iamport.kr/js/iamport.payment-1.1.2.js"></script>
   
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
   
   <!-- 우편번호 api -->
   <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>   
   
   <!-- 아코디언 -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
   
    <script type="text/javascript">

	$(document).ready(function() {
	
	var member_id = "<%=session.getAttribute("member_id")%>"; 
	
	// 헤더, 푸터 
    $("#header").load("header.jsp")
    $("#footer").load("footer.jsp") 
    
    getTotal();
	
	// 모바일 이미지 
	var windowWidth = $(window).width();
	if (windowWidth <= 769) {
		$('.arrow-img').attr("src","images/m_order2.png")
	}
        
   // 직접 입력 버튼 클릭시 빈 칸 만들기 스크립트
   $("#init_addr").on("click", function() {
      $("#address_human").val('');
      $("#order_phone1").val('');
      $("#order_phone2").val('');
      $("#order_phone3").val('');
      $("#postcode").val('');
      $("#address").val('');
      $("#detailAddress").val('');
      $("#request").val('');
   });
   
   // 나의 주소록 > 신규등록 
   $("#new-addr-btn").on("click", function() {
      $('#new-addr-div').css('display', 'block');    
   });
   
   $("#new-addr-close").on("click", function() {
      newAddrInit();
   });
   

   // 나의 주소록 > 주소 선택
   $(document).on('click', '.addr-choice', function(event) {
      var select_id = $(this);
      var tr = select_id.parent();
      var address_num = tr.attr("id").replace("addr", "");
      
      $.ajax({
         url : '/setak/searchAddr.do',
         type : 'post',
         data : {'address_num':address_num},
         dataType : 'json',
         contentType : 'application/x-www-form-urlencoded;charset=utf-8',
         success:function(data) {
            
            var human = data.address_human;
            var phone = data.address_phone;
                 var phone1, phone2, phone3 = ''; 
           
              phone1 = phone.substring(0, 3);
              
               if(phone.length == 11) {
                 phone2 = phone.substring(3, 7);
                 phone3 = phone.substring(7);
               } else {
                  phone2 = phone.substring(3, 6);
                  phone3 = phone.substring(6);                       
               }
                   
            var zipcode = data.address_zipcode;
            var loc = data.address_loc;
                var locSplit = loc.split('!');
             var addr1 = locSplit[0];
             var addr2 = locSplit[1];
             
              if(addr2 == null) {
                 addr2 = '';
              }               
               
            $("#address_human").val(human);
            $("#order_phone1").val(phone1);
            $("#order_phone2").val(phone2);
            $("#order_phone3").val(phone3);
            $("#postcode").val(zipcode);
            $("#address").val(addr1);
            $("#detailAddress").val(addr2);
            
            layerDeliPopup('close');
            
         },            
            // 문제 발생한 경우
            error:function(request,status,error) {
               // ajax를 통한 작업 송신 실패 
               alert("ajax 통신 실패  ");
               alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
      }); 
      
      event.preventDefault(); 
   })

   // 나의 주소록 > 주소 수정 : 폼 채워지기 
   $(document).on('click', '.modiAddrBtn', function(event) {
       var select_btn = $(this);
        var tr = select_btn.parent().parent(); 
        var address_num = tr.attr("id").replace("addr", "");
        
        var modiDiv = $("#modiDiv");
        modiDiv.css('display', 'table-row');
        modiDiv.insertAfter(tr); 
        
      $.ajax({
         url : '/setak/searchAddr.do',
         type : 'post',
         data : {'address_num':address_num},
         dataType : 'json',
         contentType : 'application/x-www-form-urlencoded;charset=utf-8',
         success:function(data) {
            
            var name = data.address_name; 
            var human = data.address_human;
            var phone = data.address_phone;
                 var phone1, phone2, phone3 = ''; 
           
              phone1 = phone.substring(0, 3);
              
               if(phone.length == 11) {
                 phone2 = phone.substring(3, 7);
                 phone3 = phone.substring(7);
               } else {
                  phone2 = phone.substring(3, 6);
                  phone3 = phone.substring(6);                       
               }
                   
            var zipcode = data.address_zipcode;
            var loc = data.address_loc;
                var locSplit = loc.split('!');
             var addr1 = locSplit[0];
             var addr2 = locSplit[1];
             
              if(addr2 == null) {
                 addr2 = '';
              }           
              
            $("#modiAddrName").val(name);
            $("#modiName").val(human);
            $("#postcode3").val(zipcode);
            $("#address3").val(addr1);
            $("#detailAddress3").val(addr2);
            $("#modiPhone1").val(phone1);
            $("#modiPhone2").val(phone2);
            $("#modiPhone3").val(phone3);
            
         },
            // 문제 발생한 경우
            error:function(request,status,error) {
               // ajax를 통한 작업 송신 실패 
               alert("ajax 통신 실패  ");
               alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
      }); 
        
      event.preventDefault(); 
    });
   
   // 나의 주소록 > 주소 수정 
   $(document).on('click', '#modiAddrSubmit', function(event) {
      
      var num = $("#modiDiv").prev().attr("id").replace("addr", "");
      
      var addrName = $("#modiAddrName").val();
      var name = $("#modiName").val();
      
      var phone1 = $("#modiPhone1").val();
      var phone2 = $("#modiPhone2").val();
      var phone3 = $("#modiPhone3").val();
      var phone = phone1 + phone2 + phone3; 
      
      var postcode = $("#postcode3").val();
      var address = $("#address3").val();
      var detailAddress = $("#detailAddress3").val();
         
      var addr = address + '!' + detailAddress; 
      
      if(addrName == '' || name == '' || phone1 == '' || phone2 == '' || phone3 == ''
         || postcode == '' || address == '' || detailAddress == '') {

    	 Swal.fire("","빠짐없이 입력해주세요.",'info');
         return; 
      }
      
      var params = {
            'address_num' : num,
            'address_name' : addrName,
            'address_human' : name, 
            'address_phone' : phone,
            'address_zipcode' : postcode,
            'address_loc' : addr
      };   
      
      $.ajax({
            url : '/setak/AddrModifyAction.do', // url
            type : 'POST',
            data : params, // 서버로 보낼 데이터
            contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
            dataType : 'json',
            success: function(retVal) {
               if(retVal.res=="OK") {    
                  
                 selectAddress();
                 Swal.fire("","주소가 정상적으로 수정 되었습니다.","success");  
              	 modiClose();
              
               }
               else { // 실패했다면
                  alert("Update Fail");
               }
            },
            error:function() {
               alert("Update ajax 통신 실패");
            }         
      });
      
      
   });
   
   // 나의 주소록 > 주소 삭제
   $(document).on('click', '.delAddrBtn', function(event) {
       var select_btn = $(this);
        var tr = select_btn.parent().parent(); 
        var address_num = tr.attr("id").replace("addr", "");
        Swal.fire({
        	  text: "이 주소를 삭제하시겠습니까?",
        	  icon: 'warning',
        	  showCancelButton: true,
        	  confirmButtonColor: '#3085d6',
        	  cancelButtonColor: '#d33',
        	  confirmButtonText: '네, 삭제하겠습니다.',
        	  cancelButtonText: '삭제하지않겠습니다.'
        	}).then((result) => {
        	  if (result.value) {
		          $.ajax({
		             url : '/setak/deleteAddr.do',
		             type : 'post',
		             data : {'address_num':address_num},
		             dataType : 'json',
		             contentType : 'application/x-www-form-urlencoded;charset=utf-8',
		             success:function(data) {
		                
		                selectAddress();
		                Swal.fire("","주소가 성공적으로 삭제되었습니다.","success");
		             },            
		                // 문제 발생한 경우
		                error:function(request,status,error) {
		                   // ajax를 통한 작업 송신 실패 
		                   alert("ajax 통신 실패  ");
		                   alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		                }
		          }); 
		          
		          event.preventDefault(); 
       	  }
       	});
    });
    
   // 적립금  > 한글 금지
   $("input:text[numberOnly]").on("keyup", function() { 
      $(this).val($(this).val().replace(/[^0-9]/g,"")); 
   });
   
   // 적립금 사용
   var finalPrice = parseInt($("#final_price").text().slice(0,-1).replace(",",""));
   
   $('input#usePoint').on('keyup',function(){
      var usePoint = parseInt($("#usePoint").val());
      var havePoint = parseInt($("#havePoint").text().replace(",",""));
      
      var totalPrice = parseInt($("#total_price").text().slice(0,-1).replace(",",""));
      var couponSalePrice = parseInt($("#coupon_sale_price").text().slice(0,-1).replace(",",""));
          
      if($("input#usePoint").val() == '') {
         usePoint = 0; 
      }

      if(usePoint > havePoint) {
         finalPrice += usePoint; 
         Swal.fire("","사용 가능한 최대 포인트는 " + havePoint + "Point 입니다.","info");
         usePoint = havePoint; 
         $("#usePoint").val(havePoint);
      }
      
      if(usePoint > finalPrice) {
    	 Swal.fire("","결제 금액 이상 사용 할 수 없습니다.","warning");
         $("#usePoint").val('0');
         $("#point_price").text('0원');
         
         var pointPirice = parseInt($("#point_price").text().slice(0,-1).replace(",",""));

         var asw = finalPrice + couponSalePrice + pointPirice;
         $("#final_price").html(numberFormat(asw+'원'));
         
         return;
      }
      
      if(usePoint != 0) {
         $("#point_price").html('-'+numberFormat(usePoint+'원'));
      } else {
         $("#point_price").text('0원');
      }
      
      
      var pointPirice = parseInt($("#point_price").text().slice(0,-1).replace(",",""));
      	var delivery_price = 0;
      	if (totalPrice <= 30000){
    	 	 delivery_price = 2500;
      	} else{
    		  delivery_price = 0;
      	}
      
      var asw = totalPrice + couponSalePrice + pointPirice + delivery_price;
      $("#final_price").html(numberFormat(asw+'원'));
      
      
   });
   
   // 쿠폰 레이아웃 > 쿠폰 선택
   $("input:checkbox[name='checkCoupon']").change(function() {
	   
       var select_btn = $(this);
       var salePrice = parseInt(select_btn.val()) * (-1);
       
       var orderPrice = parseInt($('#product_price').text().replace(",",""));
       var deliPrice = parseInt($('#delivery_price').text().replace(",","").slice(0, -1));
       var couponSalePrice = parseInt($('#coupon_price').text().replace(",",""));
       var pointPrice = parseInt($("#mileage_price").text().slice(0,-1).replace(",",""));
                     
       if(select_btn.is(":checked")) {         
       	   couponSalePrice += salePrice; 
        } else {         
           couponSalePrice -= salePrice; 
        }
       
       var finalPrice = orderPrice + deliPrice + couponSalePrice + pointPrice;
       
       if(finalPrice < 0) {
           Swal.fire("","결제 금액보다 할인 금액이 더 큽니다.","warning");
           select_btn.attr('checked', false);
           return;    
          }
       
       $("#coupon_price").html(numberFormat(couponSalePrice+'원'));
       $("#discount_price").html(numberFormat(finalPrice+'원'));
       
   }); 
   
   // 쿠폰 레이아웃 > 쿠폰 적용 선택
   $("#coupon-btn").on("click", function (){
         var na = $("ul > p").attr('id');
         if(na == 'notAble') {
            layerPopup('close');
            return;
         }
         
         if($('input:checkbox[name="checkCoupon"]:checked').length == 0) {
            
        	Swal.fire("","쿠폰을 선택해주세요.","info");
            return; 
         }

      
         var discountPrice = $("#discount_price").text().slice(0,-1);   
         var couponPrice = $("#coupon_price").text().slice(0,-1);   
         
            jQuery('#layer-div').attr('style','display:none');
            $("body").css("overflow","scroll");
         
         $("#final_price").text(discountPrice + '원');
         $("#coupon_sale_price").text(couponPrice + '원');

   });
   
   
   
   // 결제 : 아임포트 스크립트 >> 
   $(".pay_btn").on("click", function(){
      
      var human = $("#address_human").val();
      var phone1 = $("#order_phone1").val();
      var phone2 = $("#order_phone2").val();
      var phone3 = $("#order_phone3").val();
      var postcode = $("#postcode").val();
      var address = $("#address").val();
      var detailAddress = $("#detailAddress").val();
      var request = $("#request").val(); 
      
      var phone = phone1 + phone2 + phone3;
      var addr = address + '!' + detailAddress; 
      
      var usePoint = $("#usePoint").val(); 
      
      var checkbox = $("input[name=checkCoupon]:checked");
      var useCoupon = []; 
      
       checkbox.each(function(){
          var seq = $(this).attr('id');
          console.log(seq); 
          useCoupon.push(seq);               
       });
       
       var defaultAddrChk = 0;
	
      // 기본 배송지 설정
	  if($("#saveAddr").prop("checked")){
		  console.log("기본 배송지 설정 체크"); 
		  defaultAddrChk = 1; 
	  }
      
      // 배송지 정보 입력 받기 
      if(human == '' || phone1 == '' || phone2 == '' || phone3 == '' ||
            postcode == '' || address == '') {
    	  Swal.fire("","배송지 정보를 모두 입력해주세요.","warning");
         return; 
      }
      
      // 결제 금액 받아오기 
      var final_price = $('#final_price').text().slice(0,-1).replace(",","");
      
        var IMP = window.IMP; // 생략가능
        IMP.init('imp04669035'); // 'iamport' 대신 부여받은 "가맹점 식별코드"를 사용
        var msg;
        
        var muid = 'merchant_' + new Date().getTime();
        
        IMP.request_pay({
            pg : 'inicis',
            pay_method : 'card',
            merchant_uid : muid,
            name : '세탁곰 결제',
            amount : final_price,
            buyer_email : '<%=memberVO.getMember_email()%>',
            buyer_name : '<%=memberVO.getMember_name()%>', 
            buyer_tel : '<%=memberVO.getMember_phone()%>',
            buyer_addr : '<%=memberVO.getMember_loc()%>',
            buyer_postcode : '<%=memberVO.getMember_zipcode()%>'
        }, function(rsp) {
            if ( rsp.success ) {
                //[1] 서버단에서 결제정보 조회를 위해 jQuery ajax로 imp_uid 전달하기
                jQuery.ajax({
                    url: "/setak/insertOrder.do", //cross-domain error가 발생하지 않도록 주의해주세요. 결제 완료 이후
                    type: 'POST',
                  	traditional : true,
                    dataType: 'json',
                    data: {
                        imp_uid : rsp.imp_uid,
                        'member_id' : member_id, 
                        'order_price' : final_price,
                        'order_payment' : 'card',
                        'order_phone' : phone,
                        'order_cancel' : '0',
                        'order_status' : '결제완료',
                        'order_name' : human,
                        'order_address' : addr,
                        'order_request' : request, 
                        'order_zipcode' : postcode,
                        'order_muid' : muid,
                        'usePoint' : usePoint,
                        'useCoupon' : useCoupon,
                        'defaultAddrChk' : defaultAddrChk
                        //기타 필요한 데이터가 있으면 추가 전달
                    },
                    success : function(data) {
                       var num = data.order_num;
                        location.href='<%=request.getContextPath()%>/orderSuccess.do?order_num='+num;
                    }
                });
                
            } else {
                //실패시 이동할 페이지
                Swal.fire({
					text: "결제에 실패하였습니다.",
					icon: "error",
				}) .then(function(){
					location.href='/setak/order.do?type=pay';
				});
            }
        });
        
    });
   
});

   //우편번호 api
    function execDaumPostcode(type) {

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
                    if(type == 'origin') {
                       document.getElementById("extraAddress").value = extraAddr;   
                    } else if(type == 'new') {
                       document.getElementById("extraAddress2").value = extraAddr;
                    } else {
                       document.getElementById("extraAddress3").value = extraAddr;
                    }
                
                } else {
                   if(type == 'origin') {
                      document.getElementById("extraAddress").value = '';   
                   } else if(type == 'new') {
                      document.getElementById("extraAddress2").value = '';
                   } else {
                       document.getElementById("extraAddress3").value = extraAddr;
                    }
                    
                }
                
                if(type == 'origin') {
                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById("address").value = addr;
                    // 커서를 상세주소 필드로 이동한다.
                    document.getElementById("detailAddress").focus();                   
                } else if(type == 'new') {
                    document.getElementById('postcode2').value = data.zonecode;
                    document.getElementById("address2").value = addr;
                    // 커서를 상세주소 필드로 이동한다.
                    document.getElementById("detailAddress2").focus();                        
                } else {
                    document.getElementById('postcode3').value = data.zonecode;
                    document.getElementById("address3").value = addr;
                    // 커서를 상세주소 필드로 이동한다.
                    document.getElementById("detailAddress3").focus();                       
                }

            }
        }).open();
    }
   
   // 나의주소록 레이어 스크립트
    function layerDeliPopup(type) {

        if(type == 'open') {
           
            // 팝업창을 연다.            
            jQuery('#layer-div2').attr('style','display:block');
            jQuery('#popup-div2').attr('style','display:block');
            
            // 스크롤 없애기
            $("body").css("overflow","hidden");
            
            // 페이지를 가리기위한 레이어 영역의 높이를 페이지 전체의 높이와 같게 한다.
            jQuery('#layer-div2').height(jQuery(document).height());
            
           selectAddress();
           
        }
       
        else if(type == 'close') {
           
            // 팝업창을 닫는다.
            jQuery('#layer-div2').attr('style','display:none');
            newAddrInit();
            modiClose(); 
            $("body").css("overflow","scroll");
            
        }
    }
	
	// 나의 주소록 목록
	function selectAddress() {
		
		$('#addrTable tbody').empty();
		
		var member_id = "<%=session.getAttribute("member_id")%>"; 
		var parmas = {'member_id': member_id }; 
		

        $.ajax({
            url : '/setak/getAddrList.do', // url
            type:'post',
            data : parmas,
            dataType:'json', 
            contentType : 'application/x-www-form-urlencoded;charset=utf-8',

            success:function(data) {
                $.each(data, function(index, item) {
                   var output = '';
                   
                   var num = item.address_num; 
                   var name = item.address_name;
                   var human = item.address_human; 
                   var phone = item.address_phone;
                   var phone1, phone2, phone3 = ''; 
                   
                  phone1 = phone.substring(0, 3);
                  
                   if(phone.length == 11) {
                     phone2 = phone.substring(3, 7);
                     phone3 = phone.substring(7);
                   } else {
                      phone2 = phone.substring(3, 6);
                      phone3 = phone.substring(6);                       
                   }
                   var itemPhone = phone1 + '-' + phone2 + '-' + phone3;
                   
                   var zipcode = item.address_zipcode;
                   var loc = item.address_loc;
                   var locSplit = loc.split('!');
                   var addr1 = locSplit[0];
                   var addr2 = locSplit[1];
                   
                   if(addr2 == null) {
                      addr2 = '';
                   }
                   var addr = addr1 + ' ' + addr2 + ' (' + zipcode + ')';
                   
                   output += '<tr id = "addr'+num+'" class = "addrRow">';
                   output += '<td>'+name+'</td>';
                   output += '<td>'+human+'</td>';
                   output += '<td class = "addr-choice">'+addr+'</td>';
                   output += '<td>'+itemPhone+'</td>';
                output += '<td> <input id="modiBtn'+num+'" type="button" class="modiAddrBtn" value="수정" /> ';
                output += '<input id = "delBtn'+num+'" type="button" class="delAddrBtn" value="삭제" /></td>';
                    output += '</tr>';
                    
                   $('#addrTable tbody').append(output);                 
                });
                
               newAddrModiForm();
            },
            
            // 문제 발생한 경우
            error:function(request,status,error) {
               // ajax를 통한 작업 송신 실패 
               alert("ajax 통신 실패  ");
               alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
        
   }
   
   // 나의주소록 추가
   function insertAddress() {

		var member_id = "<%=session.getAttribute("member_id")%>"; 
		
		var addrName = $("#newAddrName").val();
		var name = $("#newName").val();
		
		var newPhone1 = $("#newPhone1").val();
		var newPhone2 = $("#newPhone2").val();
		var newPhone3 = $("#newPhone3").val();
		var phone = newPhone1 + newPhone2 + newPhone3;
		
		var postcode = $("#postcode2").val();

      var address = $("#address2").val();
      var detailAddress = $("#detailAddress2").val();
      var addr = address + '!' + detailAddress;
      
      if(addrName == '' || name == '' || newPhone1 == '' || newPhone2 == '' || newPhone3 == ''
         || postcode == '' || address == '') {
    	 Swal.fire("","전부 입력해주세요.","warning");
         return; 
      }
      
      var params = {
            'member_id' : member_id,
            'address_name' : addrName,
            'address_human' : name, 
            'address_phone' : phone,
            'address_zipcode' : postcode,
            'address_loc' : addr
      };      
      
      $.ajax({
            url : '/setak/AddrAddAction.do', // url
            type : 'POST',
            data : params, // 서버로 보낼 데이터
            contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
            dataType : 'json',
            success: function(retVal) {
               if(retVal.res=="OK") {    
                  
                 selectAddress();
                 Swal.fire("","주소가 정상적으로 추가 되었습니다.","success");          
              	 newAddrInit();
              
               }
               else { // 실패했다면
                 if(retVal.res == "CNTFAIL") {
                	 Swal.fire("",retVal.message,"warning");
                 }
               }
            },
            error:function() {
               alert("insert ajax 통신 실패");
            }         
      });
      
   }
   
   // 신규 배송지 수정 폼 추가 함수 
   function newAddrModiForm() {
      
      var output = '';
      
      output += '<tr id="modiDiv">';
      output += '<td colspan= "5">';
      output += '<h3>수정하기</h3>';
      output += '<button class = "modiCloseBtn" onclick = "modiClose()"><i class="fas fa-times"></i></button>';
      output += '<div class = "modi-form-div">';
      output += '<form id = "modi-addr-form" method = "post">';
      output += '<table class = "modi-addr-table">';
      output += '<tr>';
      output += '<td class = "new-left">배송지</td>';
      output += '<td><input id = "modiAddrName" type = "text" class = "txtInp"/></td>';
      output += '</tr>';
      output += '<tr>';
      output += '<td class = "new-left">이름</td>';
      output += '<td><input id = "modiName" type = "text" class = "txtInp"/></td>';
      output += '</tr>';
      output += '<tr>';
      output += '<td class = "new-left">주소</td>';
      output += '<td>';
      output += '<input id="postcode3" class="txtInp" type="text" style="width: 60px;" /> ';
      output += '<input type="button" onclick="execDaumPostcode(\'modi\')" value="우편번호 찾기" />';
      output += ' <br /><input id="address3" class="txtInp" type="text" style="width: 270px;" readonly /> ';
      output += '<input id="detailAddress3" class="txtInp" type="text" style="width: 270px;" /> '
      output += '<input id="extraAddress3" type="hidden" placeholder="참고항목">';
      output += '</td>';
      output += '</tr>';
      output += '<tr>';
      output += '<td class = "new-left">연락처</td>'
      output += '<td>';
      output += '<input id = "modiPhone1" class = "txtInp" type = "text" maxlength = "3" style = "width : 30px;" numberOnly/>';
      output += '-';
      output += '<input id = "modiPhone2" class = "txtInp" type = "text" maxlength = "4" style = "width : 40px;" numberOnly/>';
      output += '-';
      output += '<input id = "modiPhone3" class = "txtInp" type = "text" maxlength = "3" style = "width : 40px;" numberOnly/>';
      output += '</td>';
      output += '</tr>';
      output += '<tr>';
      output += '<td colspan = "2">';
      output += '<input type = "button" id = "modiAddrSubmit" class = "btnBlue" value = "확인" />';
      output += '</td>';
      output += '</tr>'; 
      output += '</table>';
      output += '</form>';
      output += '</div>';
      output += '</td>';
      output += '</tr>'; 
      
      $("#addrTable tbody").append(output); 
   }

   
   // 신규 배송지 초기화 함수 
   function newAddrInit() {
      
        jQuery('#new-addr-div').attr('style','display:none');
        
      $('#newAddrName').val('');
      $('#newName').val('');
      $('#postcode2').val('');
      $('#address2').val('');
      $('#detailAddress2').val('');
      $('#extraAddress2').val('');
      $('#newPhone1').val('');
      $('#newPhone2').val('');
      $('#newPhone3').val('');
   }

   // 주소록 수정창 닫기 
   function modiClose() {
        var modiDiv = $("#modiDiv");
        
		$('#modiAddrName').val('');
		$('#modiName').val('');
		$('#postcode3').val('');
		$('#address3').val('');
		$('#detailAddress3').val('');
		$('#extraAddress3').val('');
		$('#modiPhone1').val('');
		$('#modiPhone2').val('');
		$('#modiPhone3').val('');
		
        modiDiv.css('display', 'none'); 		
	}
	
	// 쿠폰 레이어 스크립트 
    function layerPopup(type) {

        if(type == 'open') {
           
            // 팝업창을 연다.

            jQuery('#layer-div').attr('style','display:block');
            jQuery('#popup-div').attr('style','display:block');
            
            // 스크롤 없애기
            $("body").css("overflow","hidden");
            
            // 페이지를 가리기위한 레이어 영역의 높이를 페이지 전체의 높이와 같게 한다.
            jQuery('#layer-div').height(jQuery(document).height());
            
            var orderPrice = parseInt($('#order_price').text().replace(",",""));            
            $('#product_price').html(numberFormat(orderPrice+'원'));
            
            var deliPrice = parseInt($('#delivery_price').text().replace(",","").slice(0, -1));            
            $('#deli_price').html(numberFormat(deliPrice+'원'));
            
            var couponSalePrice = parseInt($('#coupon_sale_price').text().replace(",",""));
            $('#coupon_price').html(numberFormat(couponSalePrice+'원'));
            
            var pointPrice = parseInt($("#point_price").text().slice(0,-1).replace(",",""));
            $("#mileage_price").html(numberFormat(pointPrice+'원'));
            
            var finalPrice = parseInt($('#final_price').text().replace(",",""));
            $('#discount_price').html(numberFormat(finalPrice+'원'));
            

        }
       
        else if(type == 'close') {
           
            // 팝업창을 닫는다.
            jQuery('#layer-div').attr('style','display:none');
            $("body").css("overflow","scroll");
            
            $('input:checkbox[name="checkCoupon"]').each(function() {
               if(this.checked) {
                  this.checked = false; 
               }
            })         

        }
    }
   
   // 총 주문 금액 구하는 함수
    function getTotal() {
         var total = 0; 
          $('.product_price').each(function() {
             var price = parseInt($(this).text().slice(0, -1)); 
             total += price; 
          });
                    
          if(total < 30000) {
              $("#delivery_price").text("2,500원");
            $("#final_price").html(numberFormat(total+2500+'원'));
              
           } else {
               $("#final_price").html(numberFormat(total+'원'));
           }
                    
          
          $("#order_price").html(numberFormat(total+'원'));
     }
   
   // 콤마      
    function numberFormat(inputNumber) {
         return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }
      
   
   
   
</script>
</head>
<body>
   <div id="header"></div>
    
   <!-- 여기서 부터 작성하세요. 아래는 예시입니다. -->
   <section id="order"> <!-- id 변경해서 사용하세요. -->
      <div class="content"> <!-- 변경하시면 안됩니다. -->
         <div class="title-text"> <!-- 변경하시면 안됩니다. -->
            <h2>주문결제</h2>
         </div>
         
         <div class = "div-1000">
           <img class = "arrow-img" src = "images/order2.png" />
           
         <div class = "order-div">
            <p class = "notice">※ 취소는 마이페이지 > 주문/배송 현황에서 신청 당일 밤 10시 전까지만 가능합니다.</p>
            
            <h3>주문리스트 확인</h3>
            <table class = "order_list_table">
               <thead>
                  <tr>
                     <th>구분</th>
                     <th>종류</th>
                     <th>수량</th>
                     <th>비고</th>
                     <th>금액</th>
                  </tr>
               </thead>
               <tbody align = "center">         
                  <% if(washingList.size() != 0) {
                  for(int i = 0; i < washingList.size(); i++) {
                  WashingVO wvo = washingList.get(i);%>      
                    <tr>
                           <td>세탁</td>
                           <td><%=wvo.getWash_kind() %></td>
                           <td><%=wvo.getWash_count() %>장</td>
                           <td class = "product_price"><%=wvo.getWash_price() %>원</td>
                           <td><%=wvo.getWash_method() %></td>
                        </tr>   
                        <% } } else { %>
                        <tr></tr>
                        <%} %>
                  <% if(mendingList.size() != 0) {
                  for(int i = 0; i < mendingList.size(); i++) {
                  MendingVO mvo = mendingList.get(i);%>      
                    <tr>
                           <%if(mvo.getRepair_wash() == 0) { %>
                           <td>수선</td>
                           <%} else { %>
                           <td>세탁-수선</td>
                           <%} %>
                           <td><%=mvo.getRepair_cate()%></td>
                           <td><%=mvo.getRepair_count()%>장</td>
                           <td class = "product_price"><%=mvo.getRepair_price()%>원</td>
                           <td><%=mvo.getRepair_kind()%> <span class = "repairCode">[텍코드 : <%=mvo.getRepair_code()%>]</span></td>
                        </tr>   
                        <% } } else { %>
                        <tr></tr>
                        <%} %>
                        
                  <% if(keepList.size() != 0) {
					// 가장 상단만 받아옴 
						for(int i = 0; i < keepList.size(); i++) {
						KeepVO kvo = keepList.get(i);%>		     
                    <tr>
                           <%if(kvo.getKeep_wash() == 0) { %>
                           <td>보관</td>
                           <% } else { %>
                           <td>세탁-보관</td>
                           <% } %>
                           <td></td>
                           <td><%=kvo.getKeep_box()%>박스</td>
                           <td class = "product_price"><%=kvo.getKeep_price()%>원</td>
                           <td><%=kvo.getKeep_month()%>개월</td>
                        </tr>   
                        <%} } else { %>
                        <tr></tr>
                        <%} %>
               
               </tbody>
            </table>
         </div>
         
         <div class = "delivery-div">
            <form action="">
               <table class = "delivery_info_table">
                  <thead>
                     <tr>
                        <th colspan = "2"><h3>배송지 정보</h3></th>
                     </tr>
                  </thead>
                  
                  <tbody>
                     <tr>
                        <td class = "left_col">배송지 선택</td>
                        <td class = "right_col">
                           <input id = "default_addr" type = "radio" name = "delivery_info" checked value = "" /> <label for = "default_addr">기본배송지</label>
                           <input id = "init_addr" type = "radio" name = "delivery_info" value = "" /> <label for = "init_addr">직접입력</label>  
                           
                           <input type = "button" class = "addr-btn btnBlue" onclick = "layerDeliPopup('open')" value = "나의 주소록" />
                        </td>
                     </tr>
                     
                     <tr>
                        <td class = "left_col">받는 사람</td>
                        <td class = "right_col"><input id = "address_human" class = "txtInp" type = "text" value = "<%=memberVO.getMember_name()%>"></td>
                     </tr> 
                     
                     <tr>
                        <td class = "left_col">휴대폰 번호</td>
                        <td class = "right_col">
                           <input id = "order_phone1" class = "txtInp" type = "text" maxlength = "3" style = "width : 30px;" numberOnly value = "<%=member_phone1%>"/> 
                           -
                           <input id = "order_phone2" class = "txtInp" type = "text" maxlength = "4" style = "width : 40px;" numberOnly value = "<%=member_phone2%>"/>
                           -
                           <input id = "order_phone3" class = "txtInp" type = "text" maxlength = "4" style = "width : 40px;" numberOnly value = "<%=member_phone3%>"/>
                        </td>
                     </tr>
                     
                     <tr>
                        <td class = "left_col">배송지 주소</td>
                        <td class = "right_col">
                           <input id = "postcode" class = "txtInp" type = "text"  value = "<%=zipcode%>"/> 
                           <input type = "button" onclick="execDaumPostcode('origin')" value = "우편번호 찾기">
                           <label id = "saveAddrLabel" for = "saveAddr"><input id = "saveAddr" type="checkbox"/>기본 배송지로 저장</label>
                           <br/>
                           <input id = "address" class = "txtInp" type = "text" readonly value = "<%=member_addr1%>"/> &nbsp;
                           <input id= "detailAddress" class = "txtInp" type = "text" placeholder = "상세 주소를 입력해주세요."  value = "<%=member_addr2%>"/>
                           <input id="extraAddress" type="hidden" placeholder="참고항목">
                           
                        </td>
                     </tr>
                     
                     <tr>
                        <td class = "left_col">배송 요청 사항</td>
                        <td class = "right_col">
                           <input id = "request" class = "txtInp" type = "text" placeholder = "배송 시 요청사항을 입력해주세요."  maxlength = "60"/>
                        </td>
                     </tr>                  
                  </tbody>
               </table>
            </form>
         </div>
         
         <!-- 결게 관련 div -->
            <div class="pay-div">
               <div class="discount-div">
                  <div class="pay_title">
                     <h3>할인 정보</h3>
                  </div>

                  <form action="">
                     <table class="discount_table">
                        <tbody>
                           <tr>
                              <td class="left_col first_row">쿠폰</td>
                              <td class="first_row right_col"><input type="button"
                                 onclick="layerPopup('open')" value="쿠폰적용" /></td>
                           </tr>

                           <tr>
                              <td class="left_col">적립금</td>
                              <td class="right_col"><input id="usePoint"
                                 class="txtInp usePoint" type="text" 
                                 style="width: 75px;" numberOnly/> <span style="font-size: 0.85rem;">Point</span>
                                 &nbsp;
                                 <p class="myPoint">
                                    (보유 적립금 : <b><span id="havePoint"><fmt:formatNumber type="number" maxFractionDigits="3" value="<%=havePoint %>" /></span></b>원)
                                 </p></td>
                           </tr>
                        </tbody>
                     </table>
                  </form>

               </div>

               <div class="price-div">
                  <div class="pay_title">
                     <h3>결제 금액</h3>
                  </div>
                  <div class="pay_content">
                     <table id="price_table" class="price_table">
                        <tbody>
                           <tr>
                              <td class="left_col first_row">총 주문금액</td>
                              <td id="total_price" class="first_row"><span id = "order_price"></span></td>
                           </tr>
                           <tr>
                              <td class="left_col">배송비</td>
                              <td><span id = "delivery_price">0원</span></td>
                           <tr>
                           <tr>
                              <td class="left_col">쿠폰할인</td>
                              <td class="txtBlue"><span id="coupon_sale_price">0원</span>
                              </td>
                           </tr>
                           <tr>
                              <td class="left_col">적립금</td>
                              <td class="txtBlue"><span id="point_price">0원</span></td>
                           <tr>
                           <tr>
                              <td class="left_col td_final">최종 결제액</td>
                              <td class="txtBlue"><span id="final_price"></span></td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
            </div>


            <div class="pay_btnDiv">
               <button class="pay_btn">결제하기</button>
            </div>

</section>
   
   <!-- 나의 주소록 레이어 -->
   <section id = "address">
      <div id = "layer-div2" class = "layer-card">
         <div id = "popup-div2">
            <div class = "popup-title">
               <h2>나의 주소록</h2>
               <button class = "popup-close" onclick = "layerDeliPopup('close')"><i class="fas fa-times"></i></button>
            </div>
            
            <div class = "addr-notice">
               <p>※ 해당 주소를 클릭하면 주문서에 자동입력 됩니다.</p>
               <p>※ 신규등록을 원하시면 신규등록 버튼을 클릭하여 주세요.</p>
               <p>※ 주소록에는 최대 5개의 주소등록이 가능합니다. </p>
               <button id = "new-addr-btn" class = "btnBlue">신규등록</button>             
            </div>
            
               <div id = "new-addr-div">
                  <h3>신규등록 <button id = "new-addr-close"><i class="fas fa-times"></i></button> </h3>
                  
                  <hr>
                  <form id = "new-addr-form" method = "post">
                     <table class = "new-addr-table">
                        <tr>
                           <td class = "new-left">배송지</td>
                           <td><input id = "newAddrName" type = "text" class = "txtInp" name = "address_name" /></td>
                        </tr>
                        <tr>
                           <td class = "new-left">이름</td>
                           <td><input id = "newName" type = "text" class = "txtInp" name = "address_human" /></td>
                        </tr>
                        <tr>
                           <td class = "new-left">주소</td>
                        <td>
                           <input id="postcode2" class="txtInp" type="text" style="width: 60px;" /> 
                           <input type="button" onclick="execDaumPostcode('new')" value="우편번호 찾기"> <br /> 
                           <input id="address2" class="txtInp" type="text" style="width: 270px;" readonly /> 
                           <input id="detailAddress2" class="txtInp" type="text" placeholder="상세 주소를 입력해주세요." style="width: 270px;" /> 
                           <input id="extraAddress2" type="hidden" placeholder="참고항목">
                        </td>
                     </tr>
                     <tr>
                        <td class = "new-left">연락처</td>
                        <td>
                           <input id = "newPhone1" class = "txtInp" type = "text" maxlength = "3" style = "width : 30px;" numberOnly/> 
                           -
                           <input id = "newPhone2" class = "txtInp" type = "text" maxlength = "4" style = "width : 40px;" numberOnly/>
                           -
                           <input id = "newPhone3" class = "txtInp" type = "text" maxlength = "4" style = "width : 40px;" numberOnly/>
                        </td>
                     </tr>
                     <tr>
                        <td colspan = "2">
                           <input id = "addrInputBtn" type = "button" class = "btnBlue" onclick="insertAddress();" value = "확인" />
                        </td>
                     </tr>                  
                  </table>
               </form>
               </div>
            
            <div class = "addr-content">
               <table id = "addrTable" class = "addr-table">
                  <thead>
                     <tr>
                        <th>배송지</th>
                        <th>이름</th>
                        <th>주소</th>
                        <th>연락처</th>
                        <th>관리</th>
                     </tr>
                  </thead>
                  <tbody>

                  </tbody>
               </table>
            </div>
            
            
         </div>
      </div>
   </section>

   <!-- 쿠폰 팝업 레이어 -->
   <section id = "coupon">
      <div id = "layer-div" class="layer-card">
         <div id = "popup-div">
            <div class="popup-title">
               <h2>쿠폰적용</h2>
               <button class = "popup-close" onclick = "layerPopup('close')"><i class="fas fa-times"></i></button>
            </div>
            <div class="popup-content1">
               <h3>쿠폰할인</h3>
               <ul>
                  <%
                     if(haveCoupon == 0) {
                  %>
                     <p>보유 쿠폰이 없음</p>
                  <%
                     } else {
                        for(int i = 0; i < couponList.size(); i++) {
                           CouponVO coupon = (CouponVO)couponList.get(i);
                            if(keepList.size() != 0) {

                              KeepVO kvo = keepList.get(0);
                              if(kvo.getKeep_wash() == 1) {
                                 %>
                                 <li><input type="checkbox" name="checkCoupon" value = "9500" id = "<%=coupon.getCoupon_seq()%>"/><label for = "<%=coupon.getCoupon_seq()%>"><%=coupon.getCoupon_name() %></label></li>
                              <% } else { %> 
                                 <li><input type="checkbox" name="checkCoupon" value = "10000" id = "<%=coupon.getCoupon_seq()%>"/><label for = "<%=coupon.getCoupon_seq()%>"><%=coupon.getCoupon_name() %></label></li>
                              <%} 
                              } 
                        }
                        
                        if(keepList.size() == 0) {
                     %>
                        <p id = "notAble">사용 가능한 쿠폰이 없음</p>
                  <% }
                  }%>
               </ul>
            </div>
            
            <div class="popup-content2">
               <div class = "popup-table-div">
                  <table class = "popup-table">
                     <tr>
                        <td class = "pLeft_col">상품금액</td>
                        <td class = "pRight_col"><span id = "product_price"></span></td>
                     </tr>
                     <tr>
                        <td class = "pLeft_col">배송비</td>
                        <td class = "pRight_col"><span id = "deli_price"></span></td>
                     </tr>
                     <tr>
                        <td class = "pLeft_col">쿠폰 할인금액</td>
                        <td class = "pRight_col txtBlue"><span id = "coupon_price"></span></td>
                     </tr>
                     <tr>
                        <td class = "pLeft_col">적립금 할인금액</td>
                        <td class = "pRight_col txtBlue"><span id = "mileage_price"></span></td>
                     </tr>
                     <tr>
                        <td colspan = "2">
                        <hr/>
                        </td>
                     </tr>
                     <tr>
                        <td class = "pLeft_col pFinal">할인적용금액</td>
                        <td class = "pRight_col pFinal txtBlue"><span id = "discount_price"></span></td>
                     </tr>
                  </table>
               </div>
               
               <input type = "button" id = "coupon-btn" value = "쿠폰적용" /> 
               <!--  <button id = "coupon-btn" onclick = "couponApply()">쿠폰적용</button> -->            
            </div>
         </div>
      </div>
   </section>
   
   <div id="footer"></div>
</body>

</html>