<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<%
   int[] subArr = (int[])request.getAttribute("subArr"); 
   int[] sub2Arr = (int[])request.getAttribute("sub2Arr"); 

   int[] allArr = (int[])request.getAttribute("allArr"); 
   int[] shirtsArr = (int[])request.getAttribute("shirtsArr"); 
   int[] dryArr = (int[])request.getAttribute("dryArr"); 
   int[] washArr = (int[])request.getAttribute("washArr"); 
   int[] washDryArr = (int[])request.getAttribute("washDryArr"); 

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
   
   <!-- toast ui -->
    <link rel="stylesheet" type="text/css" href="./chart/tui-chart.css" />
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/codemirror.css'/>
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/addon/lint/lint.css'/>
    <link rel='stylesheet' type='text/css' href='https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.43.0/theme/neo.css'/>
    <link rel='stylesheet' type='text/css' href='./chart/example.css'/>
    
    <script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/core-js/2.5.7/core.js'></script>
   <script type='text/javascript' src='https://uicdn.toast.com/tui.code-snippet/v1.5.0/tui-code-snippet.min.js'></script>
   <script type='text/javascript' src='https://uicdn.toast.com/tui.chart/latest/raphael.js'></script>
   <script src='./chart/tui-chart.js'></script>
    
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
   
   <!-- Chart.js -->
   <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js" integrity="sha256-nZaxPHA2uAaquixjSDX19TmIlbRNCOrf5HO1oHl5p70=" crossorigin="anonymous"></script>
   <script src="./utils.js"></script>
   
      <script type="text/javascript" class='code-js' id='code-js'>
      $(document).ready(function() {
         //헤더, 푸터연결
         $("#admin").load("./admin.jsp")
         
         // 정기구독 일 별 신청자 및 유형별 차트
         var today = new Date();
         var yesterday = new Date(Date.parse(today) - 1 * 1000 * 60 * 60 * 24);
          var dayago2 = new Date(Date.parse(today) - 2 * 1000 * 60 * 60 * 24);
         var dayago3 = new Date(Date.parse(today) - 3 * 1000 * 60 * 60 * 24);
         var dayago4 = new Date(Date.parse(today) - 4 * 1000 * 60 * 60 * 24); 
         
         var barChartData = {
            labels: [timeSt(dayago4), timeSt(dayago3), timeSt(dayago2), timeSt(yesterday), timeSt(today)],
            datasets: [{
               label: '올인원',
               backgroundColor: window.chartColors.red,
               data: [
                  <%=allArr[4]%>, <%=allArr[3]%>, <%=allArr[2]%>, <%=allArr[1]%>, <%=allArr[0]%>
               ]
            }, {
               label: '와이셔츠',
               backgroundColor: window.chartColors.orange,
               data: [
                  <%=shirtsArr[4]%>, <%=shirtsArr[3]%>, <%=shirtsArr[2]%>, <%=shirtsArr[1]%>, <%=shirtsArr[0]%>
               ]
            }, {
               label: '드라이',
               backgroundColor: window.chartColors.yellow,
               data: [
                  <%=dryArr[4]%>, <%=dryArr[3]%>, <%=dryArr[2]%>, <%=dryArr[1]%>, <%=dryArr[0]%>
               ]
            }, {
               label: '물빨래',
               backgroundColor: window.chartColors.green,
               data: [
                  <%=washArr[4]%>, <%=washArr[3]%>, <%=washArr[2]%>, <%=washArr[1]%>, <%=washArr[0]%>
               ]
            }, {
               label: '물빨래&드라이',
               backgroundColor: window.chartColors.blue,
               data: [
                  <%=washDryArr[4]%>, <%=washDryArr[3]%>, <%=washDryArr[2]%>, <%=washDryArr[1]%>, <%=washDryArr[0]%>
               ]
            }]
   
         };

         window.onload = function() {
            
            var ctx2 = document.getElementById('canvas').getContext('2d');
            window.myBar = new Chart(ctx2, {
               type: 'bar',
               data: barChartData,
               options: {
                  title: {
                     display: true,
                     text: '일별 정기구독 신청 및 유형 비율'
                  },
                  tooltips: {
                     mode: 'index',
                     intersect: false
                  },
                  responsive: true,
                  scales: {
                     xAxes: [{
                        stacked: true,
                     }],
                     yAxes: [{
                        stacked: true
                     }]
                  }
               }
            });
         };
         
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
                 title: ''
             },
             series: {
                 pie1: {
                     radiusRange: ['57%'],
                     labelAlign: 'center',
                     showLegend: true
                 },
                 pie2: {
                     radiusRange: ['70%', '100%'],
                     labelAlign: 'outer',
                     showLegend: true
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
      });
      
      //Date 개체를 입력받아 yyyy-MM-dd 형식으로 반환
      function timeSt(dt) {
          var d = new Date(dt);
          var MM = d.getMonth()+1;
          var dd = d.getDate();

          return (addzero(MM) + '/' + addzero(dd));
      }
      
      //Date 개체를 입력받아 yy-MM-dd 형식으로 반환
      function timeSt2(dt) {
          var d = new Date(dt);
          var yy = d.getFullYear().toString().substring(2,4);
          var MM = d.getMonth()+1;
          var dd = d.getDate();

          return (yy + '/' + addzero(MM) + '/' + addzero(dd));
      }

      //10보다 작으면 앞에 0을 붙임
      function addzero(n) {
          return n < 10 ? "0" + n : n;
      }      
         
   </script>
      
   </head>
   <body>
         <div id="admin"></div>
         <div class="content" style = "width : 100%; margin-left: 0px; margin-right : 0px;">
         
            <h1 style = "margin-left: 240px;">기타정기구독관리</h1>
            
         <!-- 전체 차트 div 시작 -->
         <div id = "all-sub-chart-div" style = "display: inline-block; margin-left : 20%;" >
              <div id='chart-area' style = 'display: inline-block;'></div>
            <div style = "display: inline-block">
               <canvas id="canvas" style = "width: 600px;height: 500px;"></canvas>
            </div>
         </div>
         <!-- 전체 차트 div 끝-->
         
         </div> <!-- content div 끝 -->
      </div><!-- 지우지마세요 -->
   </body>

   
</html>