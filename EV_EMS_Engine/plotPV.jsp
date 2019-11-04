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

<%	
	return; 
}	
%>

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
   var year = 2012;
   var month = '<%= (String) request.getParameter("month") %>';
   var emsResultID = '<%= (String) request.getParameter("emsResultID") %>';
</script>

<body>
    <table style="width: 100%" border="0">
    	<tbody>
    	    <tr>
    			<td align="left" colspan="2">
					<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="month" style="font-weight:bold; font-family:Calibri; font-size:28px;"></span>
    			</td>
    		</tr>
			<tr>
				<td align="center" colspan="2" style="height:350px;" >
					<div id="container" style="max-width:1300px; height:300px; margin: 0 auto"></div>
				</td>
			</tr>
    		<tr>
    			<td align="center" style="width:50%; height:580px">
    				<div id="chartdiv" style="height: 450px; width: 550px; margin: 0 auto"></div>
    			</td>
    			<td align="center" style="width:50%;">
					<div id="gaugeChart" style="width:480px; height:350px;"></div>
				</td>
   			</tr>
		</tbody>
	</table>
</body>

<script type="text/javascript">
/** Global variables **/
Highcharts.setOptions({
    global: {
        useUTC: false
    }
});

/** Javascript begins from here **/
getData();

function getData() {
    var req = null;
    if (window.XMLHttpRequest) { req = new XMLHttpRequest(); }
    else { req = new ActiveXObject("Microsoft.XMLHTTP"); }
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResults&username=" + username + "&datatype=pv&month=" + month + "&emsResultID=" + emsResultID, true);
    req.onreadystatechange = function() {
        if (req.readyState === 4) {
            if (req.status === 200 || req.status == 0) {
				//alert(req.responseText);
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
	
	var iText = document.createElement('p');
	iText.className = "titles";
	document.getElementById('chartdiv').appendChild(iText);
	var iDiv = document.createElement('div');
	iDiv.id = 'heatmapview';
	iDiv.className = "plotBlockSmall";
	document.getElementById('chartdiv').appendChild(iDiv);
	showHeatmap(jData.hourlyPVData);

	showPVLineGraph(jData.quarterHourPVData);

	showGaugeChart(jData.quarterHourPVData, jData.Annual_Max_PV_Generation);
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
	
	$(function () {
	    $('#heatmapview').highcharts({
	        chart: {
	            type: 'heatmap',
	            marginTop: 40,
	            marginBottom: 40,
	            backgroundColor: 'rgba(255, 255, 255, 0.1)'
	        },
	        title: {
	            text: '<b>PV Variation by Day and Hour</b>',
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
	            	[0, '#FFFFF0'], //#0000FF
	                [0.5, '#FFFF00'],
	                [0.75, '#FFA500'],
	                [1, '#FF0000']    
	            	//[0, '#0000FF'],
	                //[0.5, '#FFFF00'],
	                //[1, '#FF0000']
	            ],
	            min: 0, // Math.min.apply(null, heatmapData),
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
	            name: '',
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

function showPVLineGraph(monthlyData) {
	
	var adjust = 0;

    Highcharts.chart('container', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>PV Power Generation</b>'
        },
        xAxis: {
            type: 'datetime',
        },
        yAxis: {
            title: {
                text: 'PV [kW]'
            },
	        min: 0
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
            name: 'PV',
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
        }]
    });
}

function showGaugeChart(quarterHourPVData, PV_Capacity) {
	
	var PV_Peak = 0;
    for (var index = 0; index < quarterHourPVData.length; index++) {
        if (quarterHourPVData[index] > PV_Peak) {
        	PV_Peak = quarterHourPVData[index];
        }
    }
	
    //PV_Capacity_Str = PV_Capacity_Str.replace('kW','');
 	var PV_Capacity = Number(PV_Capacity);
	   
	$(function () {
	    Highcharts.chart('gaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Peak PV Ratio Over Capacity</b>',
	        	//style: { fontSize: '24px' }
	        },
            legend: {
                enabled: true
            },
	        tooltip: {
	        	enabled: false,
	            borderWidth: 0,
	            backgroundColor: 'none',
	            shadow: false,
	            style: {
	                fontSize: '15px'
	            },
	            pointFormat: '<b>Peak PV</b><br><span style="font-size:1em; color: green; font-weight: bold">' + Math.round(PV_Peak) + ' kW</span>',
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
	            max: PV_Capacity,
	            lineWidth: 0,
	            stops: [
	                    [0.1, '#55BF3B'], // green
	                    [0.5, '#DDDF0D'], // yellow
	                    [0.9, '#DF5353'] // red
	                ],
	            tickPositions: [PV_Capacity],
	            labels: {
	            	distance: 30,
	        		enabled: true,
	        		x: 0, y: 0,
	        		format: '<b>PV Capacity</b><br>' + PV_Capacity + ' kW',
	        		style: {
	            		fontSize: 16
	        		}
	    		}
	        },],
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
	                y: PV_Peak
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -50,
	                format: '<span style="font-size:1.6em; font-weight:bold">Peak PV</span><br><span style="font-size:1.4em; color: green; font-weight: bold">' + Math.round(PV_Peak) + ' kW</span><br>'
	                + '<span style="font-size:1.2em; color: green; font-weight:bold">' + round1Fixed(PV_Peak*100/PV_Capacity) + ' % of annual peak</span>',
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

function round2Fixed(value) {
	value = +value;

	if (isNaN(value))
		return NaN;

	// Shift
	value = value.toString().split('e');
	value = Math
			.round(+(value[0] + 'e' + (value[1] ? (+value[1] + 2) : 2)));

	// Shift back
	value = value.toString().split('e');
	return (+(value[0] + 'e' + (value[1] ? (+value[1] - 2) : -2)))
			.toFixed(2);
}

function round1Fixed(value) {
	value = +value;

	if (isNaN(value))
		return NaN;

	// Shift
	value = value.toString().split('e');
	value = Math
			.round(+(value[0] + 'e' + (value[1] ? (+value[1] + 1) : 1)));

	// Shift back
	value = value.toString().split('e');
	return (+(value[0] + 'e' + (value[1] ? (+value[1] - 1) : -1)))
			.toFixed(1);
}
</script>
   
<style>
#heatmapview {
  width: 520px;
  height: 420px;
}
</style>

</html>
