<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*, com.spring.community.QnaVO, com.spring.order.OrderVO, com.spring.admin_order.FullCalendar" %>   
<%
	int memberCnt= (int)request.getAttribute("memberCnt"); 
	int orderSum= (int)request.getAttribute("orderSum"); 
	int subPercent= (int)request.getAttribute("subPercent"); 
	int orderAllPrice = (int)request.getAttribute("orderAllPrice"); 

	String temp = (String)request.getAttribute("temp");
	String tempText = (String)request.getAttribute("tempText");
	
	int[] subArr = (int[])request.getAttribute("subArr");
	int[] sub2Arr = (int[])request.getAttribute("sub2Arr"); 
	
	int[] washArr = (int[])request.getAttribute("washArr");
	int[] repairArr = (int[])request.getAttribute("repairArr");
	int[] keepArr = (int[])request.getAttribute("keepArr");
	
	ArrayList<QnaVO> qnaList = (ArrayList<QnaVO>)request.getAttribute("qnaList");
	ArrayList<HashMap<String, Object>> subList = (ArrayList<HashMap<String, Object>>)request.getAttribute("subList");
	
	ArrayList<OrderVO> orderList = (ArrayList<OrderVO>)request.getAttribute("orderList");
	int orderCnt = (int)request.getAttribute("orderCnt");
	
	// 주희 언니 차트
	int num = (int)request.getAttribute("num");
	String[] dateArr2 = (String[])request.getAttribute("dateArr2");

	int[] ssbResultArr = (int[])request.getAttribute("ssbResultArr");
	int[] subResultArr = (int[])request.getAttribute("subResultArr");
	
	int[] totalArr = (int[])request.getAttribute("totalArr");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰 관리자페이지</title>
	<link rel = "shortcut icon" href = "../favicon.ico">
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	<link rel="stylesheet" type="text/css" href="../css/admin_main.css"/><!-- 여기 본인이 지정한 css로 바꿔야함 -->

	<!-- toast ui -->
    <link rel="stylesheet" type="text/css" href="./chart/tui-chart.css" />
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/addon/lint/lint.css'/>
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/theme/neo.css'/>

    <script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/core-js/2.5.7/core.js'></script>
	<script type='text/javascript' src='https://uicdn.toast.com/tui.code-snippet/v1.5.0/tui-code-snippet.min.js'></script>
	<script type='text/javascript' src='https://uicdn.toast.com/tui.chart/latest/raphael.js'></script>
	<script src='./chart/tui-chart.js'></script>
	
	<!-- Chart.js -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js" integrity="sha256-nZaxPHA2uAaquixjSDX19TmIlbRNCOrf5HO1oHl5p70=" crossorigin="anonymous"></script>
	<script src="./utils.js"></script>
	
	<!-- fullCallender -->
	<link href='./chart/core/main.css' rel='stylesheet' />
	<link href='./chart/list/main.css' rel='stylesheet' />
	<script src='./chart/core/main.js'></script>
	<script src='./chart/list/main.js'></script>
	<script src='./chart/locales/ko.js'></script>
	
	<!-- Resources -->
	<script src="https://www.amcharts.com/lib/4/core.js"></script>
	<script src="https://www.amcharts.com/lib/4/charts.js"></script>
	<script src="https://www.amcharts.com/lib/4/themes/animated.js"></script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.1/css/all.css" integrity="sha384-5sAR7xN1Nv6T6+dT2mhtzEpVJvfS3NScPQTrOxhwjIuvcA67KV2R5Jz6kr4abQsz" crossorigin="anonymous">

	<!-- datepicker -->
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	
	<script type="text/javascript" class='code-js' id='code-js'>
	
	fullCalendar(); 
	
		$(document).ready(function() {
			
			//헤더, 푸터연결
			$("#admin").load("./admin.jsp")
			
			var allPrice = <%=orderAllPrice%>;
			$('#price-span').text(numberFormat(allPrice));
			
			//datePicker
			$.datepicker.setDefaults({
                dateFormat: 'yy-mm-dd' //Input Display Format 변경
                ,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
                ,showMonthAfterYear:true //년도 먼저 나오고, 뒤에 월 표시
                ,changeYear: true //콤보박스에서 년 선택 가능
                ,changeMonth: true //콤보박스에서 월 선택 가능                
                ,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
                ,buttonImage: "https://img.icons8.com/ultraviolet/20/000000/planner.png" //버튼 이미지 경로
                ,buttonImageOnly: true //기본 버튼의 회색 부분을 없애고, 이미지만 보이게 함
                ,buttonText: "선택" //버튼에 마우스 갖다 댔을 때 표시되는 텍스트                
                ,yearSuffix: "년" //달력의 년도 부분 뒤에 붙는 텍스트
                ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'] //달력의 월 부분 텍스트
                ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip 텍스트
                ,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 부분 텍스트
                ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 부분 Tooltip 텍스트
                ,minDate: "-2Y" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
            });
			
            //input을 datepicker로 선언
            $("#datepicker").datepicker({
            	onClose: function(selectedDate) {    
                    $("#datepicker2").datepicker("setDate", selectedDate);
                    $("#datepicker2").datepicker("option", "minDate", selectedDate);
                    $("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;");  
                }
            });                    
            
           
            $("#datepicker2").datepicker();
           
			$("img.ui-datepicker-trigger").attr("style", "margin-left:2px; vertical-align:middle; cursor: Pointer;"); 
			
			
			// 정기구독 차트 연결 부분
			var container = document.getElementById('chart-area');
			var data = {
			    categories: ['정기구독유형'],
			    seriesAlias: {
			        pie1: 'pie',
			        pie2: 'pie'
			    },
			    series: {
			        pie1: [
			            {
			                name: '올인원',
			                data: <%=subArr[0]%>
			            },
			            {
			                name: '와이셔츠',
			                data: <%=subArr[1]%>
			            },
			            {
			                name: '드라이',
			                data: <%=subArr[2]%>
			            },
			            {
			                name: '물빨래',
			                data: <%=subArr[3]%>
			            },
			            {
			                name: '물빨래&드라이',
			                data: <%=subArr[4]%>
			            }
			        ],
			        pie2: [
			            {
			                name: '올인원59',
			                data: <%=sub2Arr[0]%>
			            },
			            {
			                name: '올인원74',
			                data: <%=sub2Arr[1]%>
			            },
			            {
			                name: '올인원89',
			                data: <%=sub2Arr[2]%>
			            },
			            {
			                name: '올인원104',
			                data: <%=sub2Arr[3]%>
			            }, {
			                name: '올인원119',
			                data: <%=sub2Arr[4]%>
			            },
			            {
			                name: '올인원134',
			                data: <%=sub2Arr[5]%>
			            },
			            {
			                name: '와이29',
			                data: <%=sub2Arr[6]%>
			            },
			            {
			                name: '와이44',
			                data: <%=sub2Arr[7]%>
			            },
			            {
			                name: '와이55',
			                data: <%=sub2Arr[8]%>
			            },
			            {
			                name: '드라이44',
			                data: <%=sub2Arr[9]%>
			            },
			            {
			                name: '드라이59',
			                data: <%=sub2Arr[10]%>
			            },
			            {
			                name: '드라이74',
			                data: <%=sub2Arr[11]%>
			            },
			            {
			                name: '물빨래34',
			                data: <%=sub2Arr[12]%>
			            },
			            {
			                name: '물빨래49',
			                data: <%=sub2Arr[13]%>
			            },
			            {
			                name: '물빨래64',
			                data: <%=sub2Arr[14]%>
			            },
			            {
			                name: '물빨래79',
			                data: <%=sub2Arr[15]%>
			            },
			            {
			                name: '물빨래84',
			                data: <%=sub2Arr[16]%>
			            },
			            {
			                name: '물빨래99',
			                data: <%=sub2Arr[17]%>
			            },
			            {
			                name: '물드44',
			                data: <%=sub2Arr[18]%>
			            },
			            {
			                name: '물드59',
			                data: <%=sub2Arr[19]%>
			            },
			            {
			                name: '물드74',
			                data: <%=sub2Arr[20]%>
			            },
			            {
			                name: '물드89',
			                data: <%=sub2Arr[21]%>
			            }
			        ]
			    }
			};
			var options = {
			    chart: {
			        width: 200,
			        height: 270,
			    },
			    series: {
			        pie1: {
			            radiusRange: ['57%'],
			            labelAlign: 'center',
			            showLegend: false
			        },
			        pie2: {
			            radiusRange: ['70%', '100%'],
			            labelAlign: 'outer',
			            showLegend: false
			        }
			    },
			    legend: {
			        visible: false
			    },
			    tooltip: {
			        suffix: '%'
			    },
			    theme: 'newTheme'
			};

			tui.chart.registerTheme('newTheme', {
			    series: {
			        pie1: {
			            colors: ['#00a9ff', '#ffb840', '#ff5a46', '#00bd9f', '#785fff', '#f28b8c', '#989486', '#516f7d', '#29dbe3', '#dddddd'],
			            label: {
			                color: '#fff',
			                fontFamily: 'sans-serif'
			            }
			        },
			        pie2: {
			            colors: [
			                '#33baff', '#66ccff','#81BEF7', '#2E9AFE','#0080FF', '#81DAF5',
			                '#ffc666', '#ffd48c', '#FFDB9F',
			                '#ff7b6b', '#ff9c90','#F5A9A9',
			                '#33cab2', '#72CD8F', '#66BE8B', '#419B66', '#198D49', '#75B791',
			                '#937fff', '#B669DF', '#CEB2DE','#BC8ED5'
			                ],
			            label: {
			                color: '#fff',
			                fontFamily: 'sans-serif'
			            }
			        }
			    }
			});

			tui.chart.comboChart(container, data, options);	
			
			// 주문 상세 수정
			$('#eventBtn').on("click", function() {
				
			    var start = $("input[name=start]").val().replace(/-/gi, "/");
				start = start.substring(2, start.length);
				var end = $("input[name=end]").val().replace(/-/gi, "/");
				end = end.substring(2, end.length);
								
				var param = {
						'title' : $("input[name=title]").val(),
						'start' : start,
						'end' : end
				}			
								
					$.ajax({
						url:'/setak/admin/addEvent.do', 
						type:'POST',
						data:param,
						dataType:'text', //리턴 데이터 타입
						contentType:'application/x-www-form-urlencoded; charset=utf-8',
						success:function(data) {	
							alert(data);
							layerPopup('close'); 
						},
						error: function() {
							alert("ajax통신 실패");
					    }
					});	
				
			});
									
		});

		// 주희언니 세수보 차트
		var today = new Date();
		var yesterday = new Date(Date.parse(today) - 1 * 1000 * 60 * 60 * 24);
		var dayago2 = new Date(Date.parse(today) - 2 * 1000 * 60 * 60 * 24);
		var dayago3 = new Date(Date.parse(today) - 3 * 1000 * 60 * 60 * 24);
		var dayago4 = new Date(Date.parse(today) - 4 * 1000 * 60 * 60 * 24); 
		
		/*데이터*/
		var config = {
			type: 'bar',
			data: {
				labels: [timeSt(dayago4), timeSt(dayago3), timeSt(dayago2), timeSt(yesterday), timeSt(today)],
				datasets: [{
					label: '세탁량',
					fill: false,
					backgroundColor: window.chartColors.red,
					borderColor: window.chartColors.red,
					data: [<%=washArr[4]%>,<%=washArr[3]%>,<%=washArr[2]%>,<%=washArr[1]%>,<%=washArr[0]%>],
				}, {
					label: '수선량',
					fill: false,
					backgroundColor: window.chartColors.blue,
					borderColor: window.chartColors.blue,
					data: [<%=repairArr[4]%>,<%=repairArr[3]%>,<%=repairArr[2]%>,<%=repairArr[1]%>,<%=repairArr[0]%>],
				}, {
					label: '보관량',
					fill: false,
					backgroundColor: window.chartColors.yellow,
					borderColor: window.chartColors.yellow,
					data: [<%=keepArr[4]%>,<%=keepArr[3]%>,<%=keepArr[2]%>,<%=keepArr[1]%>,<%=keepArr[0]%>],
				}]
			},
			options: {
				responsive: true,
				title: {
					display: true,
					text: '일별 주문 상태 변화'
				},
				tooltips: {
					mode: 'index',
					intersect: false,
				},
				hover: {
					mode: 'nearest',
					intersect: true
				},
				scales: {
					x: {
						display: true,
						scaleLabel: {
							display: true,
							labelString: 'Month'
						}
					},
					y: {
						display: true,
						scaleLabel: {
							display: true,
							labelString: 'Value'
						}
					}
				}
			}
		};
		
		function getEvents() {
			
			var events;
			$.ajax({
	   			url: '/setak/admin/getEvent.do', 
	   			type: 'post',
	   			dataType: 'json', 
	   		  	async : false,
	   			contentType : 'application/x-www-form-urlencoded;charset=utf-8',
	   			success: function(data) {
	   			
	   			 $.each(data, function(index, item) {
	   				item.start = timeSt2(new Date(item.start)); 
	   				item.end = timeSt2(new Date(item.end));
	   			 });   				
	   			
	   			 events = data; 	   				
	   			} 
	   		}); 
			
   			return events;

		}
		
		function updateEvent(info) {
			var id = info.event.id; 
			var start = info.event.start;
			var send = info.event.end;
			
			var msg = id + ' ' + start;
			return msg; 
		}
		

		function fullCalendar() {
			
			  document.addEventListener('DOMContentLoaded', function() {
				    var calendarEl = document.getElementById('calendar');
				    var events = getEvents(); 
				    		
				    var calendar = new FullCalendar.Calendar(calendarEl, {
				      plugins: [ 'list' ],
				
				      header: {
				        left: 'prev,next today',
				        center: 'title',
				        right: 'listDay,listWeek,dayGridMonth'
				      },
				
				      // customize the button names,
				      // otherwise they'd all just say "list"
				      views: {
				        listDay: { buttonText: '일별'},
				        listWeek: { buttonText: '주별'}
				      },
				      locale: 'ko',		
				      defaultView: 'listDay',
				      defaultDate: timeSt2(today),
				      navLinks: true, // can click day/week names to navigate views
				      editable: true,
				      eventLimit: true, // allow "more" link when too many events
				      events: events,
				      eventClick: function(info) {
				    	    
				    	  	if(confirm("수정하시겠습니까?")) {
				    	  		var msg = updateEvent(info);
				    	  		alert(msg);			
				    	  	}else {
				    	  		info.revert(); 
				    	  	}
				    	  }
				    });
				
				    calendar.render();
				  });
			  
					
		}
		
		/* 매출 그래프 */
		am4core.ready(function() {
		// Themes begin
		am4core.useTheme(am4themes_animated);
		// Themes end
		
		// Create chart instance
		var chart = am4core.create("chartdiv", am4charts.XYChart);
		
		chart.colors.step = 4; 
		chart.maskBullets = false;
		
		chart.data = [
	            <% for (int i = 0; i< num; i++) { %>
	            {
			    "date" : "<%=dateArr2[i] %>",
			    "distance": <%=subResultArr[i] %>,
			    "distance2": <%=ssbResultArr[i] %>,
			    "latitude": <%=totalArr[i] %>,
			},
	        <% } %>
	        {
			}];
		
		// Create axes
		var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
		dateAxis.renderer.minGridDistance = 50;
		dateAxis.renderer.grid.template.disabled = true; //칸
		dateAxis.renderer.fullWidthTooltip = true;
		
		var distanceAxis = chart.yAxes.push(new am4charts.ValueAxis());
		distanceAxis.title.text = " "; // y축 글자
				
		var latitudeAxis = chart.yAxes.push(new am4charts.ValueAxis());
		latitudeAxis.renderer.grid.template.disabled = true;
		latitudeAxis.renderer.labels.template.disabled = true;
		latitudeAxis.syncWithAxis = latitudeAxis;
		
		// 정기결제
		var distanceSeries = chart.series.push(new am4charts.ColumnSeries());
		distanceSeries.dataFields.valueY = "distance";
		distanceSeries.dataFields.dateX = "date";
		distanceSeries.yAxis = distanceAxis;
		distanceSeries.tooltipText = "{valueY}원";
		distanceSeries.name = "정기결제";
		distanceSeries.columns.template.fillOpacity = 0.7;
		distanceSeries.columns.template.propertyFields.strokeDasharray = "dashLength";
		distanceSeries.columns.template.propertyFields.fillOpacity = "alpha";
		distanceSeries.showOnInit = true;
		
		var distanceState = distanceSeries.columns.template.states.create("hover");
		distanceState.properties.fillOpacity = 0.9;
		
		// 세수보
		var distanceSeries2 = chart.series.push(new am4charts.ColumnSeries());
		distanceSeries2.dataFields.valueY = "distance2";
		distanceSeries2.dataFields.dateX = "date";
		distanceSeries2.yAxis = distanceAxis;
		distanceSeries2.tooltipText = "{valueY}원";
		distanceSeries2.name = "세수보";
		distanceSeries2.columns.template.fillOpacity = 0.7;
		distanceSeries2.columns.template.propertyFields.strokeDasharray = "dashLength";
		distanceSeries2.columns.template.propertyFields.fillOpacity = "alpha";
		distanceSeries2.showOnInit = true;
		
		var distanceState2 = distanceSeries.columns.template.states.create("hover");
		distanceState2.properties.fillOpacity = 0.9;
		
		
		//  총 수익금액
		var latitudeSeries = chart.series.push(new am4charts.LineSeries());
		latitudeSeries.dataFields.valueY = "latitude";
		latitudeSeries.dataFields.dateX = "date";
		latitudeSeries.yAxis = distanceAxis;
		latitudeSeries.name = "총 수익금액";
		latitudeSeries.strokeWidth = 2;
		latitudeSeries.propertyFields.strokeDasharray = "dashLength";
		latitudeSeries.tooltipText = "총 {valueY}원";
		latitudeSeries.showOnInit = true;
		
		var latitudeBullet = latitudeSeries.bullets.push(new am4charts.CircleBullet());
		latitudeBullet.circle.strokeWidth = 2;
		
		var latitudeState = latitudeBullet.states.create("hover");
		latitudeState.properties.scale = 1.2;
		
		
		var latitudeLabel = latitudeSeries.bullets.push(new am4charts.LabelBullet());
		latitudeLabel.label.horizontalCenter = "left";
		latitudeLabel.label.dx = 4;
		
		// Add legend
		chart.legend = new am4charts.Legend();
		
		// Add cursor
		chart.cursor = new am4charts.XYCursor();
		chart.cursor.fullWidthLineX = true;
		chart.cursor.lineX.strokeOpacity = 0;
		chart.cursor.lineX.fillOpacity = 0.1;
		
		}); // end am4core.ready()
		/*매출 그래프 소스 끝*/
		   
		window.onload = function() {
			var ctx = document.getElementById('canvas').getContext('2d');
			window.myLine = new Chart(ctx, config);
		};
		
		// 콤마      
		function numberFormat(inputNumber) {
			return inputNumber.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		      
		
		//Date 개체를 입력받아 yyyy-MM-dd 형식으로 반환
		function timeSt(dt) {
		    var d = new Date(dt);
		    var MM = d.getMonth()+1;
		    var dd = d.getDate();

		    return (addzero(MM) + '/' + addzero(dd));
		}
		
		function timeSt2(dt) {
		    var d = new Date(dt);
		    var yy = d.getFullYear();
		    var MM = d.getMonth()+1;
		    var dd = d.getDate();
	        var hh = d.getHours();
	        var mm = d.getMinutes();

		    return (addzero(yy) + '-' + addzero(MM) + '-' + addzero(dd) + 'T'
		    		+ addzero(hh) + ':' + addzero(mm));
		}
		
		//10보다 작으면 앞에 0을 붙임
		function addzero(n) {
		    return n < 10 ? "0" + n : n;
		}
		
		// 레이어 스크립트 
	    function layerPopup(type) {

	        if(type == 'open') {
	           
	            jQuery('#layer-div').attr('style','display:block');
	            jQuery('#popup-div').attr('style','display:block');
	            
	            // 스크롤 없애기
	            $("body").css("overflow","hidden");
	           
	        }
	       
	        else if(type == 'close') {
	        	
	        	$("#datepicker").val('');
	        	$("#datepicker2").val(''); 
	           
	            // 팝업창을 닫는다.
	            jQuery('#layer-div').attr('style','display:none');
	            $("body").css("overflow","scroll"); 

	        }
	    }		
	</script>
</head>
<body>
<div id="admin"></div>
<div class="content">
	<!-- 여기서부터 작업하세요. -->
	<!-- 대시보드 타이틀 Div 시작 -->
	<div id = "title-div">
		<div class = "title-num">
			<div class = "title-icon">
				<img src="https://img.icons8.com/dusk/50/000000/groups.png">
			</div>
			<div class = "title-content">
				<strong>신규 가입자</strong>
				<span>최근 1주일</span>
				<div class = "count-number-div">
					<span class = "count-number"><%=memberCnt %></span>
					<span class = "count-txt">명</span>
				</div>
			</div>
		</div>
		<div class = "title-num">
			<div class = "title-icon">
				<img src="https://img.icons8.com/dusk/50/000000/purchase-order.png">
			</div>
			<div class = "title-content">
				<strong>신규 주문</strong>
				<span>최근 5일</span>
				<div class = "ccount-number-div">
					<span class = "count-number"><%=orderSum %></span>
					<span class = "count-txt">건</span>
				</div>
			</div>
		</div>
		<div class = "title-num">
			<div class = "title-icon">
				<img src="https://img.icons8.com/dusk/50/000000/discount-ticket.png">
			</div>
			<div class = "title-content">
				<strong>정기구독 회원</strong>
				<span>전체 회원 수 대비</span>
				<div class = "count-number-div">
					<span class = "count-number"><%=subPercent %></span>
					<span class = "count-txt">%</span>
				</div>
			</div>
		</div>
		<div class = "title-num">
			<div class = "title-icon">
				<% 
					String[] weatherArr = tempText.split(",");
					String weather = weatherArr[0];
								
					if(weather.equals("맑음")) {
				%>
						<img src="https://img.icons8.com/dusk/50/000000/summer.png">
				<%} else if(weather.equals("흐림")){ %>
						<img src="https://img.icons8.com/dusk/50/000000/partly-cloudy-day.png">
				<% } else if(weather.contains("비")) {%>
						<img src="https://img.icons8.com/dusk/50/000000/rain.png">
				<% } else if(weather.contains("눈")) {%>
						<img src="https://img.icons8.com/dusk/50/000000/snow-storm.png">
				<%} else if(weather.contains("안개")) {%>
						<img src="https://img.icons8.com/dusk/50/000000/foggy-night-1.png">
				<%} else if(weather.contains("구름")) {%>
						<img src="https://img.icons8.com/dusk/50/000000/cloud.png">
				<%} else {%>
						<img src="https://img.icons8.com/dusk/50/000000/temperature-sensitive.png">
				<%} %>
			</div>
			<div class = "title-content">
				<strong>오늘의 날씨</strong>
				<span>서울 강남구 기준</span>
				<div class = "count-number-div">
					<span class = "count-number"><%=temp %></span>
					<span class = "count-txt">℃</span>
				</div>
			</div>
		</div>
		<div class = "title-num">
			<div class = "title-icon">
				<img src="https://img.icons8.com/dusk/50/000000/receive-cash.png">
			</div>
			<div class = "title-content">
				<strong>오늘의 매출액</strong>
				<span>단일 서비스 합산</span>
				<div class = "count-number-div">
					<span id = "price-span" class = "count-number" style = "font-size : 2.5rem;"></span>
					<span class = "count-txt">원</span>
				</div>
			</div>
		</div>
	</div>
	<!-- 대시보드 타이틀 Div 끝 -->

	<!-- 대시보드 내용 Div 시작 -->
	<div id = "content-div">	
		<!-- 대시보드 상단 3개 ul 시작 -->	
		<ul class = "body-ul">
			<li>
				<div class = "body-header">
					<h3>오늘의 일정</h3>
					<div class = "body-tool">
						<span><img style = "cursor : pointer; "src="https://img.icons8.com/metro/16/000000/plus.png" onclick="layerPopup('open')"/></span>				
					</div>
				</div>
				<div class = "body-content">
					<div id="calendar"></div>
				</div>
			</li>
			<li>
				<div class = "body-header">
					<h3>정기구독</h3>
					<div class = "body-tool">
					<span><img src="https://img.icons8.com/small/16/000000/questions.png"></span>
					<p class="arrow_box">
						회원들에게 인기 있는 정기구독 유형을 확인 할 수 있습니다. 정기구독관리 - 차트 메뉴에서 더 자세한 내용을 확인 할 수 있습니다. 
					</p>
					<a href = "./subscribeChart.do"><img src="https://img.icons8.com/small/16/000000/poll-topic.png"></a>
					</div>
				</div>
				<div class = "body-content">
				<ul style = "width : 100%;">
					<li style = "width : 50%">
					<div id = "chart-area"></div>
					</li>
					<li style="float: right;margin-right: 0px;width: 50%;">
					<div id = "top-sub">
						<p>TOP5</p>
						<table id = "top-table">
							<tbody>
								<%for(int i = 0; i < subList.size(); i++) { %>
									<tr>
										<td><%=subList.get(i).get("SUBRANK") %></td>
										<td><%=subList.get(i).get("SUBSNAME") %></td>
										<td><%=subList.get(i).get("SUBSCNT") %>명</td>
									</tr>
								<%} %>
							</tbody>
						</table>
					</div>
					</li>
				</ul>
				</div>
			</li>
			<li>
				<div class = "body-header">
					<h3>세수보</h3>
					<div class = "body-tool">
					<span><img src="https://img.icons8.com/small/16/000000/questions.png"></span>
					<p class="arrow_box">
						최근 5일간의 세탁, 수선, 보관양을 확인 하실 수 있습니다. 주문관리 - 차트 메뉴에서 더 자세한 내용을 확인 할 수 있습니다. 
					</p>
					<a href = "./adminChart.do"><img src="https://img.icons8.com/small/16/000000/poll-topic.png"></a>
					</div>
				</div>
				<div class = "body-content">
					<div style="width:100%;">
						<canvas id="canvas"></canvas>
					</div>
				</div>
			</li>
		</ul>
		<!-- 대시보드 상단 3개 ul 끝 -->
		
		<!-- 대시보드 하단 3개 ul 시작 -->
		<ul class = "body-ul">
			<li>
				<div class = "body-header">
					<h3>미답변 Q&A</h3>
					<div class = "body-tool">
					</div>
				</div>
				<div class = "body-content">
					<table id = "qnaTable">
						<tbody>
								<%for(int i = 0; i < qnaList.size(); i ++) { 
									QnaVO qvo = qnaList.get(i);
									String qnaDate = qvo.getQna_date(); 
									String[] dateArr = qnaDate.split(" ");
									String date = dateArr[0].replace("-","/").substring(2, dateArr[0].length());
								%>
							<tr>
								<td><span class = "qnaKind"><%=qvo.getQna_type() %></span></td>
								<td><span class = "qnaTitle"><a href = "./admin_qna.do"><%=qvo.getQna_title() %></a></span></td>
								<td><span class = "qnaDate"><%=date %></span></td>
							</tr>
								<%} %>
						</tbody>
					</table>
				</div>
			</li>
			<li>
				<div class = "body-header">
					<h3>매출</h3>
					<div class = "body-tool">
					<span><img src="https://img.icons8.com/small/16/000000/questions.png"></span>
					<p class="arrow_box">
						정기구독 결제 금액과 세탁, 수선, 보관 각각의 주문 금액의 합을 확인 하실 수 있습니다. 차트를 드래그하면 더 자세한 숫자를 확인 하실 수 있습니다. 
					</p>
					<a href = "./adminChart2.do"><img src="https://img.icons8.com/small/16/000000/poll-topic.png"></a>
					</div>
				</div>
				<div class = "body-content">
					<div id="chartdiv" style = "height: 100%;"></div>
				</div>
			</li>
			<li>
				<div class = "body-header">
					<h3>주문관리</h3>
					<div class = "body-tool">
					<span><img src="https://img.icons8.com/small/16/000000/questions.png"></span>
					<p class="arrow_box">
						결제완료 상태의 주문을 확인 할 수 있습니다. 주문관리 - 전체 메뉴에서 더 자세한 내용 확인 및 수정이 가능합니다. 
					</p>
					<a href = "./order.do"><img src="https://img.icons8.com/windows/16/000000/web.png"></a>
					</div>
				</div>
				<div class = "body-content">
					<div id = "order-text-div">
						<p class = "order-text">현재 처리해야 할 주문이 <span><%=orderCnt %></span>건 있습니다.</p>
					</div>
					<div id = "order-table-div">
						<table id = "order-table">
							<thead>
								<tr>
									<th>주문번호</th>
									<th>결제금액</th>
									<th>주문날짜</th>
								</tr>
							</thead>
							<tbody>
								<%for(int i = 0; i < orderList.size(); i ++) {
									OrderVO ovo = orderList.get(i); 
									String[] dateArr = ovo.getOrder_date().split(" ");
									String date = dateArr[0]; %>
								<tr class = "orderTable" onClick = "location.href='./order.do'">
									<td><%=ovo.getOrder_num() %></td>
									<td><%=ovo.getOrder_price() %>원</td>
									<td><%=date %></td>
								</tr>
								<%} %>
							</tbody>
						</table>
					</div>
				</div>
			</li>
		</ul>
		<!-- 대시보드 하단 3개 ul 끝-->
	</div>
	
   <!-- 팝업 레이어 -->
   <section id = "calendar">
      <div id = "layer-div" class="layer-card">
         <div id = "popup-div">
            <div class="popup-title">
               <h2>일정추가</h2>
               <button class = "popup-close" onclick = "layerPopup('close')"><i class="fas fa-times"></i></button>
            </div>
            <div class="popup-content">
            	<form id = "addEventForm" method = "post">
            		<table class = "event-table">
            			<tr>
            				<td>일정</td>
            				<td><input type = "text" class = "txtInp" name = "title" />
            			</tr>
            			<tr>
            				<td>날짜</td>
            				<td>
								<input id = "datepicker" name = "start" class = "txtDate" type = "text" size = "10px" readonly/>
								~
								<input id = "datepicker2" name = "end" class = "txtDate" type = "text" size = "10px" readonly/>
            				</td>
            			</tr>
            		</table>
            		
            		<input id = "eventBtn" type = "button" value = "확인" />
            	</form>
            </div>
         </div>
      </div>
   </section>
   
	<!-- 대시보드 내용 Div 끝 -->
</div><!-- 지우지마세요 -->
</body>
</html>
