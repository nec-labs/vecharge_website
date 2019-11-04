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
   <script src="../js/jquery-1.11.3.js"></script>
   <script src="../js/jquery-ui.js"></script>
   <script src="../js/bootstrap.min.js"></script>
   <script src="https://code.highcharts.com/highcharts.js"></script>
   <script src="https://code.highcharts.com/modules/data.js"></script>
   <script src="https://code.highcharts.com/modules/heatmap.js"></script>
   <script src="https://code.highcharts.com/modules/exporting.js"></script>
   <script src="https://code.highcharts.com/highcharts-more.js"></script>
   <script src="http://highcharts.github.io/export-csv/export-csv.js"></script>
</head>

<script>
   var username = '<%= (String) session.getAttribute("username") %>';
   var password = '<%= (String) session.getAttribute("password") %>';
   var ipAddress = '{{ ipAddress }}';
   var year = 2012;
   var month = '<%= (String) request.getParameter("month") %>';
   var emsResultID = '<%= (String) request.getParameter("emsResultID") %>';
   var emsResultTariff = '<%= (String) request.getParameter("emsResultTariff") %>';
</script>

<body>
    <table style="width:100%">
    	<tbody>
    	    <tr>
    			<td align="left" colspan="2">
					<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="month" style="font-weight:bold; font-family:Calibri; font-size:28px;"></span><br><br>
    			</td>
    		</tr>
			<tr>
				<td align="center" colspan="2">
					<div id="container" style="max-width:1300px; height:300px; margin:0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<div id="containerSOC" style="max-width:1300px; height:220px; margin:0 auto"></div>
				</td>
			</tr>
    		<tr>
    			<td style="align:center;" style="width:50%; height:480px">
    				<div id="chartdiv" style="height: 450px; width: 550px; margin:0 auto"></div>
    			</td>
				<td align="center" style="width:50%;">
					<div id="chartdiv2" style="height: 450px; width: 550px; margin:0 auto"></div>
				</td>
    		</tr>
		</tbody>
	</table>
</body>

<script type="text/javascript">
//UTC is not enabled 
Highcharts.setOptions({
    global: {
        useUTC: false
    }
});

//Called when the page is called
getData();
function getData() {
    var req = null;
    if (window.XMLHttpRequest) { req = new XMLHttpRequest(); }
    else { req = new ActiveXObject("Microsoft.XMLHTTP"); }
    
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResults&username=" + username + "&datatype=battery&month=" + month + "&emsResultID=" + emsResultID, true);
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

//Ploting returned data from DB to UI
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
		
	document.getElementById("month").innerHTML = monthString; 
	
	// Parsing Load Hourly Data
	var heatmapData = "Date,Time,Temperature\n";
	var count = 0;
	var day = 2;
    for (var i = 0; i < jData.hourlyBatteryData.length; i++) {
 	  	if (count < 23) {
 	        var load = jData.hourlyBatteryData[i];
 	        heatmapData += "2012-" + String(month) + "-" + String(day) + "," ;
 	        heatmapData += String(count) + ",";
 	        heatmapData += load + "\n";

            count ++;
    	} else {
            var load = jData.hourlyBatteryData[i];
            heatmapData += "2012-" + String(month) + "-" + String(day) + "," ;
            heatmapData += String(count) + ",";
            heatmapData += load + "\n";
            
    		count = 0;
    		day ++;
    	}
    }
    
	var heatmapSOCData = "Date,Time,Temperature\n";
	count = 0;
	day = 2;
    for (var i = 0; i < jData.hourlySOCData.length; i++) {
 	  	if (count < 23) {
 	        var soc = jData.hourlySOCData[i];
 	        heatmapSOCData += "2012-" + String(month) + "-" + String(day) + "," ;
 	        heatmapSOCData += String(count) + ",";
 	        heatmapSOCData += soc + "\n";
            count ++;
    	} else {
            var soc = jData.hourlySOCData[i];
            heatmapSOCData += "2012-" + String(month) + "-" + String(day) + "," ;
            heatmapSOCData += String(count) + ",";
            heatmapSOCData += soc + "\n";
    		count = 0;
    		day ++;
    	}
    }

	var iText = document.createElement('p');
	iText.className = "titles";
	document.getElementById('chartdiv').appendChild(iText);
	var iDiv = document.createElement('div');
	iDiv.id = 'heatmapview';
	iDiv.className = "plotBlockSmall";
	document.getElementById('chartdiv').appendChild(iDiv);
	
	showHeatmap(jData.hourlyBatteryData);
	
	var iText = document.createElement('p');
	iText.className = "titles";
	document.getElementById('chartdiv2').appendChild(iText);
	var iDiv = document.createElement('div');
	iDiv.id = 'heatmapSOCview';
	iDiv.className = "plotBlockSmall";
	document.getElementById('chartdiv2').appendChild(iDiv);
	showHeatmapSOC(jData.hourlySOCData);

	showBatteryPowerLineGraph(jData.quarterHourBatteryData, jData.quarterHourBatteryDataVarPlus, jData.quarterHourBatteryDataVarMinus);

	showSOCLineGraph(jData.quarterHourSOCData, jData.quarterHourSOCDataVarPlus, jData.quarterHourSOCDataVarMinus);
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
	
	var maxColorVal = 0;
	if (Math.abs(Math.min.apply(null, heatmapData)) > Math.abs(Math.max.apply(null, heatmapData))) {
		maxColorVal = Math.abs(Math.min.apply(null, heatmapData));
	} else {
		maxColorVal = Math.abs(Math.max.apply(null, heatmapData));
	}
	
	$(function () {
	    $('#heatmapview').highcharts({
	        chart: {
	            type: 'heatmap',
	            marginTop: 40,
	            marginBottom: 40,
	            backgroundColor: 'rgba(255, 255, 255, 0.1)'
	        },
	        title: {
	            text: '<b>DSS Power Variation by Day and Hour</b><br>',
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
	            	[0, '#0000FF'],
	                [0.5, '#FFFF00'],
	                [1, '#FF0000']
	            ],
	            min: - maxColorVal, // Math.min.apply(null, heatmapData),
	            max: maxColorVal, // Math.max.apply(null, heatmapData),
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
	});
}

function showHeatmapSOC(heatmapData) {
	
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
	
	$(function () {
	    $('#heatmapSOCview').highcharts({
	        chart: {
	            type: 'heatmap',
	            marginTop: 40,
	            marginBottom: 40,
	            backgroundColor: 'rgba(255, 255, 255, 0.1)'
	        },
	        title: {
	            text: '<b>DSS SOC Variation by Day and Hour</b>',
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
		            [0, '#FF0000'],
		            [0.5, '#FFA500'],
		            [0.75, '#FFFF00'],
		            [1, '#FFFFF0']
	            ],
	            min: 0,
	            max: 100,
	            reversed: false,
	            labels: {
	                format: '{value}%'
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
	                return '<b>' + this.point.value + ' %</b> <br>at <b>' + this.series.xAxis.categories[this.point.x] + '</b> on <b>' +
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
	});
}

function showBatteryPowerLineGraph(monthlyData, dataPlus, dataMinus) {
	
	var adjust = 0;

    Highcharts.chart('container', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>DSS Power</b>'
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
            title: {
                text: 'Power [kW]'
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
              lineWidth: 0,
              marker: {
                enabled: true,
                symbol: 'circle',
                radius: 0
              }
            }
        },
        series: [{
            name: 'DSS Power',
            color: "blue",
            lineWidth: 1.0,
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
        }],
        zones: [{
          	color: '#1B8753',
            value: 0
          },{
          	color: '#FF0000'
          }]
    });
}

function showSOCLineGraph(monthlyData, dataPlus, dataMinus) {
	
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
</style>

</html>
