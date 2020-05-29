<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
	int[] payArr = (int[])request.getAttribute("payArr"); 
	int[] pickArr = (int[])request.getAttribute("pickArr"); 
	int[] serviceArr = (int[])request.getAttribute("serviceArr"); 
	int[] deliveryArr = (int[])request.getAttribute("deliveryArr"); 
	int[] completeArr = (int[])request.getAttribute("completeArr"); 
	int[] cancleArr = (int[])request.getAttribute("cancleArr"); 
	
	String[] dateArr = (String[])request.getAttribute("dateArr");
	String[] weekArr = (String[])request.getAttribute("weekArr");

	int[] dailyArr = (int[])request.getAttribute("dailyArr"); 
	int[] weeklyArr = (int[])request.getAttribute("weeklyArr");
	
	int dailySum = (int)request.getAttribute("dailySum"); 
	int weeklySum = (int)request.getAttribute("weeklySum"); 
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰 관리자페이지</title>
	<link rel = "shortcut icon" href = "../favicon.ico">
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	<link rel="stylesheet" type="text/css" href="../css/adminorder.css"/>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	
	<!-- Chart.js -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js" integrity="sha256-nZaxPHA2uAaquixjSDX19TmIlbRNCOrf5HO1oHl5p70=" crossorigin="anonymous"></script>
	<script src="./utils.js"></script>

	
		<script type="text/javascript">
		$(document).ready(function() {
			//헤더, 푸터연결
			$("#admin").load("./admin.jsp")
		

			/* 최근 5일 주문 상태  */				
			var color = Chart.helpers.color;
			var barChartData = {
				labels: [],
				datasets: [{
					label: '결제완료',
					backgroundColor: color(window.chartColors.red).alpha(0.5).rgbString(),
					borderColor: window.chartColors.red,
					borderWidth: 1,
					data: []
				}, {
					label: '수거중',
					backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),
					borderColor: window.chartColors.blue,
					borderWidth: 1,
					data: []
				}, {
					label: '서비스중',
					backgroundColor: color(window.chartColors.yellow).alpha(0.5).rgbString(),
					borderColor: window.chartColors.yellow,
					borderWidth: 1,
					data: []
				}, {
					label: '배송중',
					backgroundColor: color(window.chartColors.green).alpha(0.5).rgbString(),
					borderColor: window.chartColors.green,
					borderWidth: 1,
					data: []
				}, {
					label: '배송완료',
					backgroundColor: color(window.chartColors.orange).alpha(0.5).rgbString(),
					borderColor: window.chartColors.orange,
					borderWidth: 1,
					data: []
				}, {
					label: '주문취소',
					backgroundColor: color(window.chartColors.grey).alpha(0.5).rgbString(),
					borderColor: window.chartColors.grey,
					borderWidth: 1,
					data: []
				}]

			};
			
			<% for(int i = 0; i < dateArr.length; i++) {%>
				barChartData.labels[<%=i%>] = '<%=dateArr[dateArr.length-i-1]%>';
				barChartData.datasets[0].data[<%=i%>] = '<%=payArr[dateArr.length-i-1]%>';				
				barChartData.datasets[1].data[<%=i%>] = '<%=pickArr[dateArr.length-i-1]%>';				
				barChartData.datasets[2].data[<%=i%>] = '<%=serviceArr[dateArr.length-i-1]%>';				
				barChartData.datasets[3].data[<%=i%>] = '<%=deliveryArr[dateArr.length-i-1]%>';				
				barChartData.datasets[4].data[<%=i%>] = '<%=completeArr[dateArr.length-i-1]%>';				
				barChartData.datasets[5].data[<%=i%>] = '<%=cancleArr[dateArr.length-i-1]%>';				
			<%}%>
						
			/*일주일 차트*/ 			
			var weekDataset = {
					label: '최근 5주 주문량',
					backgroundColor: window.chartColors.red,
					borderColor: window.chartColors.red,
					data: [<%=weeklyArr[4]%>, <%=weeklyArr[3]%>, <%=weeklyArr[2]%>, <%=weeklyArr[1]%>, <%=weeklyArr[0]%>],
					fill: false,
					lineTension:0.1
				};
			
			var dayDataset = {
					label: '최근 5일 주문량',
					backgroundColor: window.chartColors.blue,
					borderColor: window.chartColors.blue,
					data: [<%=dailyArr[4]%>, <%=dailyArr[3]%>, <%=dailyArr[2]%>, <%=dailyArr[1]%>, <%=dailyArr[0]%>],
					fill: false,
					lineTension:0.1
				};		
	

			var config = {
				type: 'line',
				data: {
					labels: [],
					datasets: []
				},
				options: {
					responsive: true,
					title: {
						display: true,
						text: '주간, 일간 주문량 ',
						fontSize : 15
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
								labelString: 'Month',
							}
						},
						y: {
							display: true,
							scaleLabel: {
								display: true,
								labelString: 'Value',
							}
						}, xAxes: [{
				            ticks: {
				                fontSize: 12
				            }
				        }], yAxes: [{
				            ticks: {
				                fontSize: 14
				            }
				        }]
					}
				}
			};
			
			getWeekDate(config);

			var ctx2 = "";
			var myLine = ""; 
			
			window.onload = function() {
				/*최근 5일 상태 차트*/
				var ctx = document.getElementById('canvas').getContext('2d');
				window.myBar = new Chart(ctx, {
					type: 'bar',
					data: barChartData,
					options: {
						responsive: true,
						legend: {
							position: 'top',
						},
						title: {
							display: true,
							text: '최근 5일 주문 상태',
							fontSize : 15
						},
						scales: {
							xAxes: [{
					            ticks: {
					                fontSize: 16
					            }
					        }], yAxes: [{
					            ticks: {
					                fontSize: 14
					            }
					        }]
						}
					}
				});
				
				/*최근 일주일, 하루 차트*/ 
				ctx2 = document.getElementById('canvas2').getContext('2d');
				config.data.datasets.push(weekDataset);
				myLine = new Chart(ctx2, config);		

			};
			
			
			// 일주일 버튼
			document.getElementById('weekDataset').addEventListener('click', function() {
				myLine.destroy(); 
				config.data.datasets = [];
				config.data.labels = []; 
				
				getWeekDate(config);
				
				config.data.datasets.push(weekDataset);
				myLine = new Chart(ctx2, config);		
			});
			
			// 하루 버튼 
			document.getElementById('dayDataset').addEventListener('click', function() {
				myLine.destroy(); 
				config.data.datasets.splice(0, 1);
				<% for(int i = 0; i < dateArr.length; i++) {%>
				config.data.labels[<%=i%>] = '<%=dateArr[dateArr.length-i-1]%>';
				<%}%>
				config.data.datasets.push(dayDataset);
				myLine = new Chart(ctx2, config);
			});
			
			
		});
		
		function getWeekDate(config) {
			<%for(int i = 0; i < weekArr.length; i+=2) {%>
			var arr = new Array(); 
			arr.push('<%=weekArr[weekArr.length-i-1]%>');
			arr.push('~');
			arr.push('<%=weekArr[weekArr.length-i-2]%>');	
			config.data.labels.push(arr); 
		<% }%>			
		}
		
	</script>
		
	</head>
	<body>
			<div id="admin"></div>
			<div class="content">
				<h1>기타주문관리</h1>
				<!-- chart.js : 최근 5일 주문 상태 -->
				<div id="recent5Days-div">
					<canvas id="canvas"></canvas>
				</div>
				
				<!-- 최근  일주일 혹은 하루 총 주문량-->
				<div id = "recentAll-div">					
					<div id = "recentAll-num">
						<div id = "recentAll5days-num">
							총 &nbsp;<span id = "dailySum" class = "sum"><%=dailySum %></span>&nbsp;건
							<br/>
							<span>5일 주문</span>							
						</div>
						
						<div id = "recentAll5weeks-num">
							총 &nbsp;<span  id = "dailySum" class = "sum"><%=weeklySum %></span>&nbsp;건
							<br/>
							<span>5주 주문</span>							
						</div>						
					</div>
					<div id = "recentAll-btn">
						<button id="weekDataset" class = "chartBtn">주별</button>
						<button id="dayDataset" class = "chartBtn">일별</button>
					</div>
							
					<canvas id="canvas2"></canvas>
			
				</div>

			</div> <!-- content div 끝 -->
		</div><!-- 지우지마세요 -->
	</body>
</html>
