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
   <script src="../js/layout.js"></script>
   <script src="../js/necui.js"></script>
   <script src="../js/necui_charts.js"></script>
   
   <script src="https://code.highcharts.com/highcharts.js"></script>
   <script src="https://code.highcharts.com/modules/data.js"></script>
   <script src="https://code.highcharts.com/modules/heatmap.js"></script>
   <script src="https://code.highcharts.com/modules/exporting.js"></script>
   <script src="http://highcharts.github.io/export-csv/export-csv.js"></script>
   <script src="https://code.highcharts.com/highcharts-more.js"></script>
   <script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
   
   <link href="http://amcharts.com/lib/3/plugins/export/export.css" rel="stylesheet" type="text/css">
   <link href="../css/necui.css" rel="stylesheet" />
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
    <table style="width:100%;">
    	<tbody>
    	    <tr>
    			<td align="left" colspan="2">
					<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="month" style="font-weight:bold; font-family:Calibri; font-size:28px;"></span>
    			</td>
    		</tr>
    		<tr>
				<td align="center" colspan="2" style="height:350px" >
					<div id="lineGraph" style="max-width:1300px; height:300px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2" style="height:220px" >
					<div id="containerSOC" style="max-width:1300px; height:200px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" style="width:50%; height:380px;">
					<div id="gaugeChart" style="width:480px; height:350px;"></div>
				</td>
				<td align="center" style="width:50%;">
					<div id="pvUtilDist" style="width:550px; height:350px;"></div>
				</td>
			</tr>
		</tbody>
	</table>

</body>

<script type="text/javascript">

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
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResults&username=" + username + "&datatype=pvUtil&month=" + month + "&emsResultID=" + emsResultID, true);
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
	
	showLineGraph(jData.quarterHourPVData, jData.quarterHourLoadData, jData.quarterHourGridData);
	
	showSOCGraph(jData.quarterHourSOCData);	
	
	showGaugeChart(jData.Esell_NoESS_kWh, jData.Esell_ESS_kWh, jData.PV_Utilization);
	
	showPVUtilDistribution(jData.DailyPVUtilizationData);
}

function showLineGraph(pvData, loadData, gridData) {
	
	//alert(batteryData.length);
	//alert(loadData.length);
	//alert(gridData.length);
	
	var PSell_NoESS = [];
	var PSell_ESS = [];
	
	for (var i = 0; i < gridData.length; i++) {
		var pGrid = gridData[i];
		if (pGrid < 0) {
			PSell_ESS.push(-pGrid);
		} else {
			PSell_ESS.push(0);
		}
		
		var pLoad = loadData[i];
		var pPV = pvData[i];
		if (pPV > pLoad) {
			PSell_NoESS.push(pPV-pLoad);
		} else {
			PSell_NoESS.push(0);
		}
		
	}
	
	var adjust = 0;;

	var chart = new Highcharts.chart('lineGraph', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Feed-In Power to Grid</b>'
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
            min: 0,
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
            name: 'Before',
            color: {
                linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                stops: [
                    [0, 'orange'],
                    [1, '#f4d777']
                ]
            },
            data: (function() {
                var data = [];
            	var timeL = (new Date(year, month-1, 1, adjust, -15, 0)).getTime();
                for (var index = 0; index < PSell_NoESS.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: PSell_NoESS[index]
                    });
                }
                return data;
            }())
        }, {
            type: 'area',
            name: 'After',
            color: {
                linearGradient: { x1: 0, x2: 0, y1: 0, y2: 1 },
                stops: [
                    [0, '#1256e8'],
                    [1, '#a4c3f4']
                ]
            },
            data: (function() {
                var data = [];
            	var timeL = (new Date(year, month-1, 1, adjust, -15, 0)).getTime();
                for (var index = 0; index < PSell_ESS.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: PSell_ESS[index]
                    });
                }
                return data;
            }())
        }]
    });
    $('#preview').html(chart.getCSV());
}

function showSOCGraph(monthlyData) {

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

function showGaugeChart(Esell_NoESS_kWh, Esell_ESS_kWh, PV_Utilization) {
	
	if (PV_Utilization == -1) {
		Esell_NoESS_kWh = 0;
		Esell_ESS_kWh = 0;
		PV_Utilization = "No Excess PV";
	} else {
		PV_Utilization = round2Fixed(PV_Utilization) + " %";
	}
	
	$(function () {
	    Highcharts.chart('gaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Total PV Energy Exported to Grid</b><br>',
	        	//style: { fontSize: '24px' }
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
	            pointFormat: '<b>EMS</b><br><span style="font-size:1em; color: green; font-weight: bold">' + Esell_ESS_kWh + ' kWh</span>',
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
	            max: Esell_NoESS_kWh,
	            lineWidth: 0,
	            stops: [
	                    [0.1, '#55BF3B'], // green
	                    [0.5, '#DDDF0D'], // yellow
	                    [0.9, '#DF5353'] // red
	                ],
	            tickPositions: [Esell_NoESS_kWh],
	            labels: {
	            	distance: 30,
	        		enabled: true,
	        		x: 0, y: 0,
	        		format: '<b>Basecase</b><br>' + Esell_NoESS_kWh + ' kWh',
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
	                y: Esell_ESS_kWh
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -50,
	                format: '<b><span style="font-size:1.6em">&nbsp;PV Utilization</span></b><br>'
	                + '<span style="font-size:1.8em; color: green; font-weight:bold">&nbsp;&nbsp;&nbsp;' + PV_Utilization + '</span>',
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

function showPVUtilDistribution (chartData) {
	
    var values = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (var day = 0; day < chartData.length; day ++) {
    	var dayPVUtil = chartData[day];
    	if (0 <= dayPVUtil && dayPVUtil < 10)
    		values[0] = values[0] + 1;
    	else if (10 <= dayPVUtil && dayPVUtil < 20)
    		values[1] = values[1] + 1;
    	else if (20 <= dayPVUtil && dayPVUtil < 30)
    		values[2] = values[2] + 1;
    	else if (30 <= dayPVUtil && dayPVUtil < 40)
    		values[3] = values[3] + 1;
    	else if (40 <= dayPVUtil && dayPVUtil < 50)
    		values[4] = values[4] + 1;
    	else if (50 <= dayPVUtil && dayPVUtil < 60)
    		values[5] = values[5] + 1;
    	else if (60 <= dayPVUtil && dayPVUtil < 70)
    		values[6] = values[6] + 1;
    	else if (70 <= dayPVUtil && dayPVUtil < 80)
    		values[7] = values[7] + 1;
    	else if (80 <= dayPVUtil && dayPVUtil < 90)
    		values[8] = values[8] + 1;
    	else if (90 <= dayPVUtil && dayPVUtil <= 100)
    		values[9] = values[9] + 1;
    }
    
    var xAxis = ["0%-10%","10%-20%","20%-30%","30%-40%","40%-50%","50%-60%","60%-70%","70%-80%","80%-90%","90%-100%"];
    
	
	var chart = new Highcharts.chart('pvUtilDist', {
	    chart: {
	    	backgroundColor: null,
	        type: 'column'
	    },
	    title: {
	        text: '<b>PV Utilization Distribution</b>'
	    },
        legend: {
            enabled: false
        },
	    xAxis: {
	        categories: xAxis,
	        crosshair: true
	    },
	    yAxis: {
	        min: 0,
	        title: { text: 'Number of Days' }
	    },
	    tooltip: {
	        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
	        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
	            '<td style="padding:0"><b>{point.y} </b></td></tr>',
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
	        name: '# of Days',
	        data: values
	    }]
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
</script>
   
<style>
</style>

</html>
