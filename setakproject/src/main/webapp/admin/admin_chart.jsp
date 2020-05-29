<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
	int[] washArr = (int[])request.getAttribute("washArr");
	int[] repairArr = (int[])request.getAttribute("repairArr");
	int[] keepArr = (int[])request.getAttribute("keepArr");

    int month_num = (int)request.getAttribute("month_num");
	String[] monthArr = (String[])request.getAttribute("monthArr");
	
	int[] washMonthArr = (int[])request.getAttribute("washMonthArr");
	int[] repairMonthArr = (int[])request.getAttribute("repairMonthArr");
	int[] keepMonthArr = (int[])request.getAttribute("keepMonthArr");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>세탁곰 관리자페이지</title>
	<link rel="shortcut icon" href="../favicon.ico">
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	
	<!-- Chart.js -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js" integrity="sha256-nZaxPHA2uAaquixjSDX19TmIlbRNCOrf5HO1oHl5p70=" crossorigin="anonymous"></script>
	<script src="./utils.js"></script>
	
	<!-- toast chart -->
	<link rel="stylesheet" type="text/css" href="./chart/tui-chart.css" />
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/codemirror.css'/>
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/addon/lint/lint.css'/>
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/theme/neo.css'/>
    <link rel='stylesheet' type='text/css' href='./chart/example.css'/>
    
    <script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/core-js/2.5.7/core.js'></script>
	<script type='text/javascript' src='https://uicdn.toast.com/tui.code-snippet/v1.5.0/tui-code-snippet.min.js'></script>
	<script type='text/javascript' src='https://uicdn.toast.com/tui.chart/latest/raphael.js'></script>
	<script src='./chart/tui-chart.js'></script>
	
	<style>
	.content h3 {
		margin: 30px 0 -20px 0;
	}
	#jschart{
		width:75%;
	}
	
	.content h4 {
		font-size:1.21rem;
		margin: 10px auto;
	}
	
	</style>	
</head>

<body>
	<div id="admin"></div>
	<div class="content">
		<h3>하루 단위 세수보 그래프</h3>
		<div id="jschart">
			<canvas id="canvas"></canvas>
		</div>
		<h4> 월 단위 세수보 그래프</h4>
		 <div id="chart-area"></div>
	</div><!-- 지우지마세요 -->
	
	<script type="text/javascript" class='code-js' id='code-js'>
	
		//헤더, 푸터연결
		$("#admin").load("./admin.jsp")
		
		/*일별 주문 상태 변화 그래프*/
			//x축 날짜
			var today = new Date();
			var yesterday = new Date(Date.parse(today) - 1 * 1000 * 60 * 60 * 24);
 			var dayago2 = new Date(Date.parse(today) - 2 * 1000 * 60 * 60 * 24);
			var dayago3 = new Date(Date.parse(today) - 3 * 1000 * 60 * 60 * 24);
			var dayago4 = new Date(Date.parse(today) - 4 * 1000 * 60 * 60 * 24); 
			
			//데이터
			var config = {
				type: 'bar',
				data: {
					labels: [timeSt(dayago4), timeSt(dayago3), timeSt(dayago2), timeSt(yesterday), timeSt(today)],
					datasets: [{
						label: '세탁량',
						fill: false,
						backgroundColor: window.chartColors.blue,
						borderColor: window.chartColors.blue,
						data: [<%=washArr[4]%>,<%=washArr[3]%>,<%=washArr[2]%>,<%=washArr[1]%>,<%=washArr[0]%>],
					}, {
						label: '수선량',
						fill: false,
						backgroundColor: window.chartColors.yellow,
						borderColor: window.chartColors.yellow,
						data: [<%=repairArr[4]%>,<%=repairArr[3]%>,<%=repairArr[2]%>,<%=repairArr[1]%>,<%=repairArr[0]%>],
					}, {
						label: '보관량',
						fill: false,
						backgroundColor: window.chartColors.red,
						borderColor: window.chartColors.red,
						data: [<%=keepArr[4]%>,<%=keepArr[3]%>,<%=keepArr[2]%>,<%=keepArr[1]%>,<%=keepArr[0]%>],
					}]
				},
				options: {
					responsive: true,
					title: {
						display: true,
						text: ' '
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
			
		
		window.onload = function() {
			var ctx = document.getElementById('canvas').getContext('2d');
			window.myLine = new Chart(ctx, config);
		};
		
		
		/*한달별 주문 상태 변화 그래프*/
		var container = document.getElementById('chart-area');
		var data = {
		   categories: ['1월', '2월', '3월'],
		    series: [
		        {
		            name: '세탁량',
					data: [<%=washMonthArr[0]%>,<%=washMonthArr[1]%>,<%=washMonthArr[2]%>]
		        },
		        {
		            name: '수선량',
					data: [<%=repairMonthArr[0]%>,<%=repairMonthArr[1]%>,<%=repairMonthArr[2]%>]
		        },
		        {
		            name: '보관량',
					data: [<%=keepMonthArr[0]%>,<%=keepMonthArr[1]%>,<%=keepMonthArr[2]%>]
		        }
		    ]
		};
		
		var data2 = {
			categories : [],
			series : [ 
		        {
		            name: '세탁량',
					data: []
		        },
		        {
		            name: '수선량',
					data: []
		        },
		        {
		            name: '보관량',
					data: []
		        }
			]
		};

		<% for(int i = 0; i < month_num; i++) { %>
			data2.categories.push('<%=monthArr[i]%>');
			data2.series[0].data.push(<%=washMonthArr[i]%>);
			data2.series[1].data.push(<%=repairMonthArr[i]%>);
			data2.series[2].data.push(<%=keepMonthArr[i]%>);
		<%}%>	

		var options = {
		    chart: {
		        width: 1500,
		        height: 300,
		        title: ' ',
		        'format': '1'
		    },
		    yAxis: {
		        title: '달'
		    },
		    xAxis: {
		        title: '양',
		        max: 500
		    },
		    series: {
		        stackType: 'normal'
		    }
		};
		var theme = {
		    series: {
		        colors: [
		            '#2a4175', '#289399', '#289399', '#617178'
		        ]
		    }
		};


		tui.chart.barChart(container, data2, options);
			
		//Date 개체를 입력받아 yyyy-MM-dd 형식으로 반환
		function timeSt(dt) {
		    var d = new Date(dt);
		    var MM = d.getMonth()+1;
		    var dd = d.getDate();

		    return (addzero(MM) + '/' + addzero(dd));
		}
		
		//10보다 작으면 앞에 0을 붙임
		function addzero(n) {
		    return n < 10 ? "0" + n : n;
		}		
	</script>
</body>

</html>