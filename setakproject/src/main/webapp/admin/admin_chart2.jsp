<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
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
	<link rel="shortcut icon" href="../favicon.ico">
	<link rel="stylesheet" type="text/css" href="../css/admin.css"/>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	
	<!-- Resources -->
	<script src="https://www.amcharts.com/lib/4/core.js"></script>
	<script src="https://www.amcharts.com/lib/4/charts.js"></script>
	<script src="https://www.amcharts.com/lib/4/themes/animated.js"></script>

	
	<style>
	.content h3 {
		padding: 30px 0 30px 0;
	}
	#chartdiv {
 	 width: 80%;
 	 height: 400px;
	}	
	</style>	
</head>

<body>
	<div id="admin"></div>
	<div class="content">
		<h3>수익 그래프</h3>
		<div id="chartdiv"></div>
	</div><!-- 지우지마세요 -->
	
		<script type="text/javascript">
		
		$("#admin").load("./admin.jsp")
		
		am4core.ready(function() {
		
		// Themes begin
		am4core.useTheme(am4themes_animated);
		// Themes end
		
		// Create chart instance
		var chart = am4core.create("chartdiv", am4charts.XYChart);
		
		chart.colors.step = 4; 
		chart.maskBullets = false;
		
		// Add data
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
		
		//distanceAxis.renderer.grid.template.disabled = true;
		
		
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
		latitudeLabel.label.dx = 10;
		
		// Add legend
		chart.legend = new am4charts.Legend();
		
		// Add cursor
		chart.cursor = new am4charts.XYCursor();
		chart.cursor.fullWidthLineX = true;
		chart.cursor.lineX.strokeOpacity = 0;
		chart.cursor.lineX.fillOpacity = 0.1;
		
		}); // end am4core.ready()
		</script>
</body>

</html>