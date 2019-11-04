<%
if (request.getParameter("psw") != null) {
	String password = request.getParameter("psw");
	String username = request.getParameter("uname");
	session.setAttribute("password", password);
	session.setAttribute("username", username);
}
String pass = null;
if (session.getAttribute("password") != null)
	pass = (String) session.getAttribute("password");	
if (pass == null)
	pass = "";
if (!pass.equals("nec12345")) {
%>

<body>
	<font size="4">Incorrect Password!! </font> <br> <br>
	<font size="4">Back to </font>
	<button type="button" onclick="location.href='../LoginForm.jsp'">
		<font size="3">EMS Login Page</font>
	</button>
</body>

<%	return; 
}	%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="utf-8" />
<title></title>
   <script src="../js/jquery-1.11.3.js"></script>
   <script src="../js/jquery-ui.js"></script>
   <script src="../js/bootstrap.min.js"></script>
   <script src="https://code.highcharts.com/highcharts.js"></script>
   <script src="https://code.highcharts.com/modules/data.js"></script>
   <script src="https://code.highcharts.com/modules/heatmap.js"></script>
   <script src="https://code.highcharts.com/modules/exporting.js"></script>
   <script src="https://code.highcharts.com/highcharts-more.js"></script>
   <script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
   <script src="http://highcharts.github.io/export-csv/export-csv.js"></script>
</head>

<script>
   var username = '<%= (String) session.getAttribute("username") %>';
   var password = '<%= (String) session.getAttribute("password") %>';
   var ipAddress = '{{ ipAddress }}';
   var year = 2012; // set as default
   var month = '<%= (String) request.getParameter("month") %>';
   var emsResultID = '<%= (String) request.getParameter("emsResultID") %>';
</script>

<body>

    <table style="width: 100%">
    	<tbody>
    		<tr>
    			<td align="left" colspan="2">
					<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="month" style="font-weight:bold; font-family:Calibri; font-size:28px;"></span>
    			</td>
    		</tr>
    		<tr>
    			<td style="align:right;" style="width:50%;">
    				<div id="chartdiv" style="height: 450px; width: 550px; margin: 0 auto"></div>
    			</td>
				<td align="left" style="width:50%;">
					<div id="chartdiv2" style="height: 380px; width: 550px; margin: 0 auto"></div>
				</td>
    		</tr>
    		<tr>
				<td align="center" colspan="2">
					<div id="lineGraph" style="max-width:1300px; height:300px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2" style="height:220px;">
					<div id="containerSOC" style="max-width:1300px; height:200px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" style="height:380px; width:50%;">
					<div id="savingview" style="height: 450px; width: 550px; margin: 0 auto"></div>	
					<!-- <div id="gaugeChart" style="width:480px; height:350px;"></div>  -->
				</td>
				<td align="center" style="width:50%;">
					<div id="savingPieChart" style="width:340px; height:300px;"></div>
				</td>
			</tr>
		</tbody>
	</table>
</body>

<script type="text/javascript">
// UTC is not enabled 
Highcharts.setOptions({
    global: {
        useUTC: false
    }
});

// Called when the page is opened
getData();
function getData() {
    var req = null;
    if (window.XMLHttpRequest) { req = new XMLHttpRequest(); }
    else { req = new ActiveXObject("Microsoft.XMLHTTP"); }
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResults&username=" + username + "&datatype=savings&month=" + month + "&emsResultID=" + emsResultID, true);
    req.onreadystatechange = function() {
        if (req.readyState === 4) {
            if (req.status === 200 || req.status == 0) {

            	var data = req.responseText;
				var jData = JSON.parse(data);
				if(jData.isFailed == "true") {
					alert(jData.errorReason);
					return;
				}
				year = jData.year;
				dataPlot(jData);
            }
		}
    }
    req.send(null);
}

// Ploting returned data from DB to UI
function dataPlot(jData) {
	
	var monthString = "Not Defined";
	if (month == "1")
		monthString = "January";
	else if (month == "2")
		monthString = "February";
	else if (month == "3")
		monthString = "March";	
	else if (month == "4")
		monthString = "April";	
	else if (month == "5")
		monthString = "May";	
	else if (month == "6")
		monthString = "June";	
	else if (month == "7")
		monthString = "July";	
	else if (month == "8")
		monthString = "August";	
	else if (month == "9")
		monthString = "September";	
	else if (month == "10")
		monthString = "October";	
	else if (month == "11")
		monthString = "November";	
	else if (month == "12")
		monthString = "December";
		
	document.getElementById("month").innerHTML = monthString; // + " " + year;
	
	// Parsing Load Hourly Data
	var heatmapData = "Date,Time,Temperature\n";
	var count = 0;
	var day = 2;
	var values = [];
	var charData2 = [];

    for (var i = 0; i < jData.hourlyLoadData.length; i++) {
 	  	if (count < 23) {
 	        var value = jData.hourlyLoadData[i] - jData.hourlyGridData[i];
 	  		if (value < 0) {
 	  			value = 0;
 	  		}
 	        heatmapData += "2012-" + String(month) + "-" + String(day) + "," ;
 	        heatmapData += String(count) + ",";
 	        heatmapData += value + "\n";
 	        values.push(Number(round2Fixed(value)));

            count ++;
    	} else {
    		 var value = jData.hourlyLoadData[i] - jData.hourlyGridData[i];
 	  		if (value < 0) {
 	  			value = 0;
 	  		}
            heatmapData += "2012-" + String(month) + "-" + String(day) + "," ;
            heatmapData += String(count) + ",";
            heatmapData += value + "\n";
 	        values.push(Number(round2Fixed(value)));
            
    		count = 0;
    		day ++;
    	}
    }
    
    count = 0;
    var values24 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	for (var i = 0; i < values.length; i++) {
		values24[count] += values[i];
		if (count < 23) {
			count ++;
		} else {
			count = 0;
		}
	}

	for (var i = 0; i < 24; i++) {		
		charData2.push({
			"method" : String(i) + ":00",
			"perfectcost" : round2Fixed(values24[i]),
			"color": "blue"
		});
	}    

	var iText = document.createElement('p');
	iText.className = "titles";
	document.getElementById('chartdiv').appendChild(iText);
	var iDiv = document.createElement('div');
	iDiv.id = 'heatmapview';
	iDiv.className = "plotBlockSmall";
	document.getElementById('chartdiv').appendChild(iDiv);
	showHeatmap(values);

	showBestDayLineGraph(jData.quarterHourPVData, jData.quarterHourLoadData, jData.quarterHourGridData);
	
	var anytimeDCValue = Number(jData.currentMonthDCRate.AnyTimeDCRate.Value$kW);

	showLineGraph(jData.quarterHourPVData, jData.quarterHourLoadData, jData.quarterHourGridData, jData.quarterHourLoadDataVarPlus, jData.quarterHourGridDataVarPlus, jData.quarterHourLoadDataVarMinus, jData.quarterHourGridDataVarMinus);
	
	showSOCGraph(jData.quarterHourSOCData, jData.quarterHourSOCDataVarPlus, jData.quarterHourSOCDataVarMinus);	
	
	//showGaugeChart(jData.quarterHourPVData, jData.quarterHourLoadData, jData.quarterHourGridData);
	//savingBarChart(values24, jData.hourlyTariffData, jData.currentMonthDCRate.AnyTimeDCRate, jData.currentMonthDCRate.PartialPeakTimeDCRate, jData.currentMonthDCRate.PeakTimeDCRate);

	savingBarChartWithTOU(values24, jData.currentMonthTOU);

	//showStackedBar(jData);
	showSavingPieChart(jData.totalSaving, jData.annualTotalSaving);
}

function showHeatmap(heatmapData) {
	
	var yCategories = [];
	var data = []; 
	var count =0;
	
	var weekday = new Array(7);
	weekday[0] =  "Sun";
	weekday[1] = "Mon";
	weekday[2] = "Tue";
	weekday[3] = "Wed";
	weekday[4] = "Thu";
	weekday[5] = "Fri";
	weekday[6] = "Sat";
	
	for (var y =0; y < heatmapData.length/24; y ++) {
		var d = new Date(year, month-1, y+1);
		
		var n = weekday[d.getDay()];
		var str = month + "/" + String(y+1) + " " + n;
		yCategories.push(str);
		
		for (var x=0; x<24; x++) {
			data.push([x, y, heatmapData[count]]);
			count ++;
		}
	}
	
	var chart = new Highcharts.chart('heatmapview', {

	        chart: {
	            type: 'heatmap',
	            marginTop: 40,
	            marginBottom: 40,
	            backgroundColor: 'rgba(255, 255, 255, 0.1)'
	        },
	        title: {
	            text: '<b>Demand Shaved by Day and Hour</b><br>',
	            align: 'center'
	        },
	        xAxis: {
	            categories: ['0:00', '1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00']
	        },
	        yAxis: {
	            categories: yCategories,
	            title: null
	        },
	        colorAxis: {
	            stops: [
	            	[0, '#DEFADE'], //#0000FF FFFFF0
	                [0.5, '#FFFF00'],
	                [0.75, '#FFA500'],
	                [1, '#FF0000']
	            ],
	            min: Math.min.apply(null, heatmapData),
	            max: Math.max.apply(null, heatmapData),
	            reversed: false,
	            labels: {
	                format: '{value}kW'
	            }
	        },
	        legend: {
	            align: 'right',
	            layout: 'vertical',
	            margin: 10,
	            verticalAlign: 'top',
	            y: 25,
	            symbolHeight: 320
	        },
	        tooltip: {
	            formatter: function () {
	                return '<b>' + this.point.value + ' kW</b> <br>at <b>' + this.series.xAxis.categories[this.point.x] + '</b> on <b>' +
	                    this.series.yAxis.categories[this.point.y] + '</b>';
	            }
	        },
	        series: [{
	            name: 'Sales per employee',
	            borderWidth: 0,
	            data: data,
	            dataLabels: {
	                enabled: false,
	                color: 'black',
	                style: {
	                    textShadow: 'none'
	                }
	            }
	        }]

	});
	$('#preview').html(chart.getCSV());
}

function showLineGraph(pvData, loadData, gridData, loadDataPlus, gridDataPlus, loadDataMinus, gridDataMinus) {
	
	var adjust = 0;
	
	var netDemand = [];
	var netDemandPlus = [];
	var netDemandMinus = [];

	for (var i = 0; i < loadData.length; i ++) {
		netDemand.push(loadData[i] - pvData[i]);
		netDemandPlus.push(loadDataPlus[i] - pvData[i]);		
		netDemandMinus.push(loadDataMinus[i] - pvData[i]);		

	}
	
	var seriesData = [{
        //type: 'area',
        name: 'Before',
        color: 'blue', 
        marker: {
            enabled: false
        },
        data: (function() {
            var data = [];
        	var timeL = (new Date(year, month-1, 1, adjust, -15, 0)).getTime();
            for (var index = 0; index < loadData.length; index += 1) {
                timeL = timeL + 1000 * 60 * 15;
                data.push({
                    x: timeL,
                    y: netDemand[index]
                });
            }
            return data;
        }())
    },{
        type: 'line',
        name: 'After',
        marker: {
            enabled: false
        },
        color: '#ff8000',
        data: (function() {
            var data = [];
        	var timeL = (new Date(year, month-1, 1, adjust, -15, 0)).getTime();
        	for (var index = 0; index < gridData.length; index += 1) {
                timeL = timeL + 1000 * 60 * 15;
                data.push({
                    x: timeL,
                    y: gridData[index]
                });
            }
            return data;
        }())
    }];
	
	if (loadDataPlus != null && loadDataPlus.length != 0) {
		seriesData.push({
	        name: 'Range',
	        data: (function() {
	            var data = [];
	            var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
	            for (var index = 0; index < netDemandPlus.length; index += 1) {
	                timeL = timeL + 1000 * 60 * 15;
	                data.push([
	                    timeL,
	                    netDemandPlus[index],
	                    netDemandMinus[index],
	                ]);
	            }
	            return data;
	        }()),
	        type: 'arearange',
	        lineWidth: 0,
	        linkedTo: ':previous',
	        color: Highcharts.getOptions().colors[0],
	        fillOpacity: 0.3,
	        zIndex: 0,
	        marker: {
	            enabled: false
	        }
	    });
		seriesData.push({
	        name: 'Range',
	        data: (function() {
	            var data = [];
	            var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
	            for (var index = 0; index < gridDataPlus.length; index += 1) {
	                timeL = timeL + 1000 * 60 * 15;
	                data.push([
	                    timeL,
	                    gridDataPlus[index],
	                    gridDataMinus[index],
	                ]);
	            }
	            return data;
	        }()),
	        type: 'arearange',
	        lineWidth: 0,
	        linkedTo: ':previous',
	        color: Highcharts.getOptions().colors[1],
	        fillOpacity: 0.3,
	        zIndex: 0,
	        marker: {
	            enabled: false
	        }
	    });
	}
	
	var chart = new Highcharts.chart('lineGraph', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Demand Profile</b>'
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
            //min: 0,
        	title: {
                text: 'Power [kW]'
            }
        },
        events: {
            redraw: function(){
                console.log(this.xAxis);
                console.log(this.yAxis);
            }
        },
        legend: {
            enabled: true
        },
        plotOptions: {
        	series: {
        		turboThreshold: 3000
        	},
        	area: {
                stacking: 'normal',
                //lineColor: "blue",
                lineWidth: 1,
                marker: {
                  enabled: true,
                  symbol: 'circle',
                  radius: 0
                }
              }
        },
        series: seriesData
    });
    $('#preview').html(chart.getCSV());
}

function showBestDayLineGraph(pvData, loadData, gridData) {
	
	var id = 'chartdiv2';
	
	var adjust = 0;
	
    var day = 1;
    var hour = 0;
    var minute = 0;
    
    var netDemand = [];
	for (var i = 0; i < loadData.length; i ++) {
		netDemand.push(loadData[i] - pvData[i]);		
	}
	
    var maxValue1 = 0;
    var maxValue2 = 0;
    for (var index = 0; index < gridData.length; index++) {
    	
        if (gridData[index] > maxValue1) {
            maxValue1 = gridData[index];
        }
        if (netDemand[index] > maxValue2) {
            maxValue2 = netDemand[index];
            day = Math.floor(index / 96) + 1;
        	hour = Math.floor((index - ((day-1) * 96))/4);
        	minute = (index - ((day-1) * 96) - (hour * 4)) * 15;
        }
    }
    
    if (maxValue1 > maxValue2) {
    	maxValue1 = maxValue2;
    }
    
	var chart = new Highcharts.chart(id, {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Typical Demand Profile</b>',
            style: {
                display: 'inline'
            }            
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: [{
        	opposite: false,
        	//min: 0,
            title: {
                text: 'Power [kW]'
            }
        }
        //,{ // Primary yAxis            
        //    min: 0,
        //    title: {
        //        text: '<b>NET DEMAND of BEST SAVING DAY</b>'
        //    }
        //}
        ],
        events: {
            redraw: function(){
                console.log(this.xAxis);
                console.log(this.yAxis);
            }
        },
        legend: {
            enabled: true
        },
        plotOptions: {
        	series: {
        		turboThreshold: 3000
        	},
            area: {
                stacking: 'normal',
                //lineColor: "blue",
                lineWidth: 1,
                marker: {
                  enabled: true,
                  symbol: 'circle',
                  radius: 0
                }
              }
        },
        series: [{
            type: 'area',
            name: 'Before',
            color: {
                linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                stops: [
                    [0, '#b3ccff'],
                    [1, '#b3ccff']
                ]
            },
            data: (function() {
                var data = [];
            	var timeL = (new Date(year, month-1, day, 0, -15, 0)).getTime();
                for (var index = ((day - 1) * 96); index < ((day - 1) * 96) + 96; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: netDemand[index]
                    });
                }
                return data;
            }())
        },{
            type: 'line',
            name: 'After',
            marker: {
                enabled: true,
                symbol: 'circle',
                radius: 0
              },
            color: '#ff8000',
            data: (function() {
                var data = [];
            	var timeL = (new Date(year, month-1, day, 0, -15, 0)).getTime();
                for (var index = ((day - 1) * 96); index < ((day - 1) * 96) + 96; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: gridData[index]
                    });
                }
                return data;
            }())
        }]
    });
}

function showSOCGraph(monthlyData, dataPlus, dataMinus) {
	
	var adjust = 0;

    Highcharts.chart('containerSOC', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>DSS State of Charge</b>'
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
        	max: 100,
        	min: 0,
            title: {
                text: 'SOC [%]'
            }
        },
        legend: {
            enabled: true
        },
        plotOptions: {
        	series: {
        		turboThreshold: 3000
        	},
            area: {
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: null
            }
        },

        series: [{
            //type: 'area',
            name: 'SOC',
            color: "blue",
            lineWidth: 1.5,
            marker: {
                enabled: false
            },
            data: (function() {
                var data = [];
                var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
                for (var index = 0; index < monthlyData.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: monthlyData[index]
                    });
                }
                return data;
            }())
        }, {
            name: 'Range',
            data: (function() {
                var data = [];
                var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
                for (var index = 0; index < dataPlus.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push([
                        timeL,
                        dataPlus[index],
                        dataMinus[index],
                    ]);
                }
                return data;
            }()),
            type: 'arearange',
            lineWidth: 0,
            linkedTo: ':previous',
            color: Highcharts.getOptions().colors[0],
            fillOpacity: 0.3,
            zIndex: 0,
            marker: {
                enabled: false
            }
        }]
    });
}

//Not in Use
function showSOCGraph2(monthlyData) {

	var adjust = 0;
	
	var chart = new Highcharts.chart('containerSOC', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>DSS State of Charge</b>'
        },        	series: {
    		turboThreshold: 3000
    	},
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
        	max: 100,
        	min: 0,
            title: {
                text: 'SOC [%]'
            }
        },
        legend: {
            enabled: true
        },
        plotOptions: {
        	series: {
        		turboThreshold: 3000
        	},
            area: {
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: null
            }
        },

        series: [{
            type: 'area',
            name: 'SOC',
            data: (function() {
                var data = [];
                var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
                for (var index = 0; index < monthlyData.length; index += 1) {
                    //timeL = timeL + 1000 * 60 * 60;
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: monthlyData[index]
                    });
                }
                return data;
            }())
        }]
    });
    $('#preview').html(chart.getCSV());
}

function showTOUTrend(hourlyTariffData, hourlyLoadData, hourlyGridData) {

	var adjust = 0;
	var noStorageTotalTouCosts = [];
	var val1 = 0;
    for (var i = 0; i < hourlyLoadData.length; i ++) {
    	val1 += hourlyLoadData[i] * hourlyTariffData[i];
        noStorageTotalTouCosts.push(Math.round(val1 * 10)/10);
    }
    
	var emsTotalTouCosts = [];
	var val2 = 0;
    for (var i = 0; i < hourlyGridData.length; i ++) {
    	val2 += hourlyGridData[i] * hourlyTariffData[i];
        emsTotalTouCosts.push(Math.round(val2 * 10)/10);
    }
	
	var chart = new Highcharts.chart('touTrend', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Total TOU Cost Trend</b>'
        },        	series: {
    		turboThreshold: 3000
    	},
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
        	//max: 100,
        	min: 0,
            title: {
                text: 'Total TOU Cost[$]'
            }
        },
        legend: {
            enabled: true
        },

        series: [{
            type: 'area',
            name: 'No Storage',
            data: (function() {
                var data = [];
                var timeL = (new Date(year, month - 1, 1, adjust, -60, 0)).getTime();
                for (var index = 0; index < noStorageTotalTouCosts.length; index ++) {
                    timeL = timeL + 1000 * 60 * 60;
                    //timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: noStorageTotalTouCosts[index]
                    });
                }
                return data;
            }())
        }, {
            type: 'area',
            name: 'EMS',
            color: {
                linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                stops: [
                    [0, 'orange'],
                    [1, '#f4d777']
                ]
            },
            data: (function() {
                var data = [];
                var timeL = (new Date(year, month - 1, 1, adjust, -60, 0)).getTime();
                for (var index = 0; index < emsTotalTouCosts.length; index ++) {
                    timeL = timeL + 1000 * 60 * 60;
                    //timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: emsTotalTouCosts[index]
                    });
                }
                return data;
            }())
        }]
    });
    $('#preview').html(chart.getCSV());
}

function savingBarChart(charData, tou, anyTimeDCRate, partialPeakTimeDCRate, peakTimeDCRate) {
	
	tou = [];
	
	//TODO modify when showing DC rates
	var anytimeDCValue = Number(anyTimeDCRate.Value$kW);
	var partialDCValue = Number(anyTimeDCRate.Value$kW) + Number(partialPeakTimeDCRate.Value$kW);
	var peakDCValue = Number(anyTimeDCRate.Value$kW) + Number(peakTimeDCRate.Value$kW);
	
	for(var i = 0; i<24; i++) {
		tou.push(round2Fixed(anyTimeDCRate.Value$kW));
	}
	
	if (peakTimeDCRate.Value$kW == "0.0") {
		//alert("no peak");
	} else {
		//alert(Number(peakTimeDCRate.firstTimeWindow_start.split(":")[0]));
		//alert(Number(peakTimeDCRate.firstTimeWindow_end.split(":")[0]));
		var peakStart = Number(peakTimeDCRate.firstTimeWindow_start.split(":")[0]);
		var peakEnd = Number(peakTimeDCRate.firstTimeWindow_end.split(":")[0]);
		
		for (var index = peakStart; index < peakEnd; index++) {
			tou[index] = round2Fixed(peakTimeDCRate.Value$kW);
		}
		
		if(peakTimeDCRate.secondTimeWindow_start == "0:00" || peakTimeDCRate.secondTimeWindow_start == "00:00") {
			// There is no second peak time
		} else { // There is second peak time
			var secondPeakStart = Number(peakTimeDCRate.secondTimeWindow_start.split(":")[0]);
			var secondPeakEnd = Number(peakTimeDCRate.secondTimeWindow_end.split(":")[0]);
			
			for (var index = secondPeakStart; index < secondPeakEnd; index++) {
				tou[index] = round2Fixed(peakTimeDCRate.Value$kW);
			}
		}
	}
	
	if (partialPeakTimeDCRate.Value$kW == "0.0") {
		//alert("no partial peak");
	} else {
		var peakStart = Number(partialPeakTimeDCRate.firstTimeWindow_start.split(":")[0]);
		var peakEnd = Number(partialPeakTimeDCRate.firstTimeWindow_end.split(":")[0]);
		
		for (var index = peakStart; index < peakEnd; index++) {
			tou[index] = round2Fixed(partialPeakTimeDCRate.Value$kW);
		}
		
		if(partialPeakTimeDCRate.secondTimeWindow_start == "0:00" || partialPeakTimeDCRate.secondTimeWindow_start == "00:00") {
			// There is no second peak time
		} else { // There is second peak time
			var secondPeakStart = Number(partialPeakTimeDCRate.secondTimeWindow_start.split(":")[0]);
			var secondPeakEnd = Number(partialPeakTimeDCRate.secondTimeWindow_end.split(":")[0]);
			
			for (var index = secondPeakStart; index < secondPeakEnd; index++) {
				tou[index] = round2Fixed(partialPeakTimeDCRate.Value$kW);
			}
		}
	}
	
	var colors = ['#ffe6e6', '#ffcccc', '#ff9999', 'orange'];
	var values = [];
	var touPoints = [];
	var price = tou[0];
	var from = 0;
	var to = 0;
	var j =0;
	var coloring = '#ffe6e6';
	for (var i = 0; i < 24; i++) {
		if (price != tou[i]) {
			
			if (price == round2Fixed(peakTimeDCRate.Value$kW)) {
				//alert("peakTimeDCRate");
				coloring = '#ff9999';
			}
			if (price == round2Fixed(partialPeakTimeDCRate.Value$kW)) {
				//alert("partialPeakTimeDCRate");
				coloring = '#ffcccc';
			}
			if (price == round2Fixed(anyTimeDCRate.Value$kW)) {
				//alert("anyTimeDCRate");
				coloring = '#ffe6e6';
			}

			to = i;
			
			values.push(price);
			
//			var coloring = colors[j];
//			if (values[0] == price) {
//				coloring = colors[0];
//			} else if (values[1] == price) {
//				coloring = colors[1];
//			}
			
			var point = {
				//label: {text: "$" + price},
				color: coloring, // Color value
	    	    from: from, // Start of the plot band
	    	    to: to // End of the plot band
    	    };
			j++;
			from = to;
			price = tou[i];
			touPoints.push(point);
		}
		
		if (i==23) {
			if (tou[i] == round2Fixed(peakTimeDCRate.Value$kW))
				coloring = '#ff9999';
			if (tou[i] == round2Fixed(partialPeakTimeDCRate.Value$kW))
				coloring = '#ffcccc';
			if (tou[i] == round2Fixed(anyTimeDCRate.Value$kW))
				coloring = '#ffe6e6';
		
			var point = {
					color: coloring, // Color value
		    	    from: from, // Start of the plot band
		    	    to: 23 // End of the plot band
	    	    };
			values.push(price);
			touPoints.push(point);
		}
	}
	
	var chart = new Highcharts.chart('savingview', {
	    chart: {
	    	backgroundColor: null,
	        type: 'column'
	    },
	    title: {
	        text: '<b>Energy Shaved by Hour</b>'
	    },
	    //subtitle: {
	    //    text: 'Source: WorldClimate.com'
	    //},
        legend: {
            enabled: false
        },
	    xAxis: {
	        categories: ['0:00', '1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', 
	            '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'],
	    	plotBands: touPoints,
	        crosshair: true
	    },
	    yAxis: {
	        min: 0,
	        title: { text: 'Energy Shaved (kWh)' }
	    },
	    tooltip: {
	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
	            '<td style="padding:0"><b>{point.y:.1f} kWh</b></td></tr>',
	        footerFormat: '</table>',
	        shared: true,
	        useHTML: true
	    },
	    plotOptions: {
	        column: {
	            pointPadding: -0.2,
	            borderWidth: 0
	        }
	    },
	    series: [{
	        name: 'Energy Shaved',
	        data: charData
	    }]
	});
	$('#preview').html(chart.getCSV());
}


function savingBarChartWithTOU(charData, currentMonthTOU) {
	
	// Creating allTOU and touValues
	// touInfo includes infoPair
	var allTOU = [];
	var touValues = [];
	var touInfo = [];
	var prevVal = -1;
	var j = 0;
	for(var i = 0; i < currentMonthTOU.Values.length; i++) {
		if (i % 2 == 0) {
			var val = currentMonthTOU.Values[i];
			allTOU.push(val);
			
			if (!touValues.includes(val)) {
				touValues.push(val);
			} 
			
			if (val != prevVal) {
				var infoPair = {
						"index": j,
						"value": val
				}
				touInfo.push(infoPair);
				prevVal = val;
			}
			j++;
		}
	}
	//console.log(allTOU);
	//console.log(touInfo);
	
	// Creating colorMapping: {color, value}
	var colorMapping = [];
	var touValueCategories = touValues.sort();
	var colors = ['#ffe6e6', '#ffcccc', '#ff9999', 'orange'];
	for (var i = 0; i < touValueCategories.length; i++) {
		var mapping = {
				"color": colors[i],
				"value": touValueCategories[i]
		}
		colorMapping.push(mapping);
	}
	//console.log(colorMapping);
	
	// Update touInfo with from and to values
	var updatedTouInfo = [];
	var from = 0;
	var to = touInfo[1].index - 1;
	for (var i = 0; i < touInfo.length; i++) {
		if (i+1 < touInfo.length) {
			
			to = touInfo.index;
			var info = {
				"from": touInfo[i].index,
				"to": touInfo[i+1].index,
				"value": touInfo[i].value
			};
			updatedTouInfo.push(info);			
		} else if (i+1 == touInfo.length) {
			var info = {
				"from": touInfo[i].index,
				"to": 23,
				"value": touInfo[i].value
			};
			updatedTouInfo.push(info);						
		}
	}
	//console.log(updatedTouInfo);
	
	var touPoints = [];
	for (var i = 0; i < updatedTouInfo.length; i++) {
		for (var j = 0; j < colorMapping.length; j++) {
			if (updatedTouInfo[i].value == colorMapping[j].value) {
				var point = {
					//label: {text: "$" + updatedTouInfo[i].value},
					color: colorMapping[j].color, // Color value
		    	    from: updatedTouInfo[i].from, // Start of the plot band
		    	    to: updatedTouInfo[i].to // End of the plot band
	    	    };
				touPoints.push(point);
			}
		}
	}
	console.log(touPoints)
	
	var chart = new Highcharts.chart('savingview', {
	    chart: {
	    	backgroundColor: null,
	        type: 'column'
	    },
	    title: {
	        text: '<b>Energy Shaved by Hour</b>'
	    },
	    //subtitle: {text: 'Source: WorldClimate.com'},
        legend: {
            enabled: false
        },
	    xAxis: {
	        categories: ['0:00', '1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', 
	            '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'],
	    	plotBands: touPoints,
	        crosshair: true
	    },
	    yAxis: {
	        min: 0,
	        title: { text: 'Energy Shaved (kWh)' }
	    },
	    tooltip: {
	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
	            '<td style="padding:0"><b>{point.y:.1f} kWh</b></td></tr>',
	        footerFormat: '</table>',
	        shared: true,
	        useHTML: true
	    },
	    plotOptions: {
	        column: {
	            pointPadding: -0.2,
	            borderWidth: 0
	        }
	    },
	    series: [{
	        name: 'Energy Shaved',
	        data: charData
	    }]
	});
	$('#preview').html(chart.getCSV());
}


function savingBarChartWithoutTariffData(charData) {
	
	var chart = new Highcharts.chart('savingview', {
	    chart: {
	    	backgroundColor: null,
	        type: 'column'
	    },
	    title: {
	        text: '<b>Energy Shaved by Hour</b>'
	    },
	    //subtitle: {
	    //    text: 'Source: WorldClimate.com'
	    //},
        legend: {
            enabled: false
        },
	    xAxis: {
	        categories: ['0:00', '1:00', '2:00', '3:00', '4:00', '5:00', '6:00', '7:00', '8:00', '9:00', '10:00', '11:00', 
	            '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'],
	        crosshair: true
	    },
	    yAxis: {
	        min: 0,
	        title: { text: 'Energy Shaved (kWh)' }
	    },
	    tooltip: {
	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
	            '<td style="padding:0"><b>{point.y:.1f} kWh</b></td></tr>',
	        footerFormat: '</table>',
	        shared: true,
	        useHTML: true
	    },
	    plotOptions: {
	        column: {
	            pointPadding: -0.2,
	            borderWidth: 0
	        }
	    },
	    series: [{
	        name: 'Energy Shaved',
	        data: charData
	    }]
	});
	$('#preview').html(chart.getCSV());
}


function showGaugeChart(pvData, loadData, gridData) {
	
    var maxValue1 = 0;
    var maxValue2 = 0;
    var netDemand = [];
	for (var i = 0; i < loadData.length; i ++) {
		netDemand.push(loadData[i] - pvData[i]);		
	}
    
    for (var index = 0; index < gridData.length; index++) {
    	
        if (gridData[index] > maxValue1) {
            maxValue1 = gridData[index];
        }
        if (netDemand[index] > maxValue2) {
            maxValue2 = netDemand[index];
        }
    }
    
    if (maxValue1 > maxValue2) {
    	maxValue1 = maxValue2;
    }
    
    var rate = maxValue1/maxValue2;
    var saving = Math.round((maxValue2- maxValue1)*100)/100;
    var savingPercentage = Math.round((saving/maxValue2)*1000)/10;
    
	$(function () {
	    Highcharts.chart('gaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Peak Demand</b>',
	        },
            legend: {
                enabled: true
            },
	        tooltip: {
	        	enabled: true,
	            borderWidth: 0,
	            backgroundColor: 'none',
	            shadow: false,
	            style: {
	                fontSize: '15px'
	            },
	            pointFormat: '<b>EMS</b><br><span style="font-size:1.0em; color: green; font-weight: bold">' + maxValue1 + ' kW</span>',
	            positioner: function (labelWidth, labelHeight) {
	                return {
	                    x: 345,
	                    y: 70
	                };
	            }
	        },
	        credits: {
	            enabled: false
	        },
	        pane: {
	            startAngle: 0,
	            startAngle: -160,
	            endAngle: 160,
	            background: [{ // Track for Move
	                outerRadius: '112%',
	                innerRadius: '88%',
	                backgroundColor: Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0.3).get(),
	                borderWidth: 0,
	                shape: 'arc'
	            }]
	        },
	        yAxis: [{
	            min: 0,
	            max: Math.round(maxValue2*10)/10,
	            lineWidth: 0,
	            stops: [
	                    [0.1, '#55BF3B'], // green
	                    [0.5, '#DDDF0D'], // yellow
	                    [0.9, '#DF5353'] // red
	                ],
	            tickPositions: [maxValue2],
	            labels: {
	            	distance: 30,
	        		enabled: true,
	        		x: 0, y: 0,
	        		format: '<b>Basecase</b><br> {value} kW',
	        		style: {
	            		fontSize: 16
	        		}
	    		}
	        }],
	        plotOptions: {
	            solidgauge: {
	                borderWidth: '34px',
	                dataLabels: {
	                    y: 5,
	                    borderWidth: 0,
	                    useHTML: true
	                },
	                linecap: 'round',
	                stickyTracking: false
	            }
	        },
	        series: [{
	            name: 'Basecase',
	            borderColor: {
	                linearGradient: { x1: 1, x2: 0, y1: 1, y2: 1},
	                stops: [
		            	[0.0, '#DF5353'], // green
		                [0.5, '#DDDF0D'], // yellow
		                [0.8, '#55BF3B'] // red
	                ]
	            },
	            
	            data: [{
	                color: Highcharts.getOptions().colors[0],
	                radius: '100%',
	                innerRadius: '100%',
	                category: "EMS",
	                y: maxValue1
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -50,
	                format: '<b><span style="font-size:1.4em">Peak Demand Reduction</span></b><br>'
	                + '<span style="font-size:1.6em; color: green; font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + saving + ' kW</span>' 
		            + '<br><span style="font-size:1.3em; color: green;">' + savingPercentage + '% less than Basecase</span>',
	            },
	            tooltip: {	            	
		            positioner: function (labelWidth, labelHeight) {
		                return {
		                    x: 330 - labelWidth,
		                    y: 150
		                };
		            }
	            }
	        }]
	    });
	});
}

function showStackedBar(jData) {
	
    $(function() {
        $('#savingStackedBar').highcharts({
            chart: {
            	zoomType: 'xy',
                type: 'column',
                backgroundColor: null,
            },
            title: {
                text: '<b>Demand Charge Savings</b>'
            },
            legend: {
                align: 'right',
                x: -30,
                verticalAlign: 'top',
                y: 25,
                floating: true,
                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
                borderColor: '#CCC',
                borderWidth: 1,
                shadow: false,
                enabled: false
            },
            xAxis: {
                categories: ['']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Saving ($)'
                },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                    }
                }
            },
            tooltip: {
                headerFormat: '<b>{series.name}</b><br/>', 
                pointFormat: 'Saving: $ {point.y}<br/>Total: $ {point.stackTotal}'
            },
            credits: {
                enabled: false
            },
            plotOptions: {
                column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: false,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                    }
                }
            },
            series: [{
                name: 'Max Peak',
                data: [Number(round2Fixed(jData.maxSavings))]
            },{
                name: 'Partial',
                data: [Number(round2Fixed(jData.partialSavings))]
            },{
                name: 'Anytime',
                data: [Number(round2Fixed(jData.anytimeSavings))]
            }, {
    	        name: 'Saving error',
    	        type: 'errorbar',
    	        data: [[Number(round2Fixed(jData.totalSavingVarMinus)), Number(round2Fixed(jData.totalSavingVarPlus))]],
    	        tooltip: {
    	            pointFormat: '(error range: \${point.low}-{point.high})<br/>'
    	        }
    	    }]
        });
    });
}

function showSavingPieChart(monthlyTotalSaving, annualTotalSaving) {
	
	//console.log(monthlyTotalSaving + ", " + annualTotalSaving)
	
	var id = 'savingPieChart';
	
	Highcharts.chart(id, {
	    chart: {
	    	backgroundColor: null,
	        plotBackgroundColor: null,
	        plotBorderWidth: null,
	        plotShadow: false,
	        type: 'pie'
	    },
	    title: {
	        text: 'Saving of the month over the year'
	    },
	    tooltip: {
	        pointFormat: '{series.name}: <b>\${point.y:.1f}</b> (<b>{point.percentage:.1f}%</b>)'
	    },
	    plotOptions: {
	        pie: {
	            allowPointSelect: true,
	            cursor: 'pointer',
	            dataLabels: {
	                enabled: true,
	                format: '<b>{point.name}</b>: <br> <b>\${point.y:.1f}</b> <br>({point.percentage:.1f}%)'
	            }
	        }
	    },
	    series: [{
	        name: 'Saving',
	        colorByPoint: true,
	        data: [{
	            name: 'This Month',
	            y: monthlyTotalSaving,
	            sliced: true,
	            selected: true
	        }, {
	            name: 'Other Months',
	            y: annualTotalSaving - monthlyTotalSaving
	        }]
	    }]
	});
}

function round2Fixed(value) {

	value = +value;
	if (isNaN(value)) return NaN;

	// Shift
	value = value.toString().split('e');
	value = Math.round(+(value[0] + 'e' + (value[1] ? (+value[1] + 2) : 2)));

	// Shift back
	value = value.toString().split('e');
	return (+(value[0] + 'e' + (value[1] ? (+value[1] - 2) : -2))).toFixed(2);
}
</script>

<style>
#heatmapview {
  width: 520px;
  height: 420px;
}
#heatmapSOCview {
  width: 520px;
  height: 420px;
}
#savingview {
  width: 530px;
  height: 420px;
}
</style>

</html>
