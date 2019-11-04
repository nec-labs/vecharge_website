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
<style>
h3 { 
	display: block;
    font-size: 1em;
    margin-top: 1em;
    margin-bottom: 1em;
    margin-left: 3%;
    margin-right: 0;
    font-weight: bold;
}
</style>
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<link rel="stylesheet" href="../css/MyStyleSheet.css">
<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<script src="https://www.google.com/jsapi"></script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/data.js"></script>
<script src="https://code.highcharts.com/highcharts-more.js"></script>
<script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="http://highcharts.github.io/export-csv/export-csv.js"></script>

<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
</head>

<script>
var username = '<%= (String) session.getAttribute("username") %>';
var password = '<%= (String) session.getAttribute("password") %>';
var ipAddress = '{{ ipAddress }}';
var year = 2012;
var month = '<%= (String) request.getParameter("month") %>';
var emsResultID = '<%= (String) request.getParameter("emsResultID") %>';
var batterySize = '<%= (String) request.getParameter("batterySize") %>';
</script>

<body style="background-color: rgba(255, 255, 255, 0.06); overflow: hidden">
	<br>
	<div style="font-family:Calibri; text-align:left;">
		&nbsp;&nbsp; <font size="6">Battery Life Analysis Summary</font> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	</div>
	<br>
   	<table style="width:100%;" border=1>
		<tbody>
			<tr>
				<td style="width:14%;">
					<div style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
						Battery Size: &nbsp;&nbsp;  
					</div>
				</td>
				<td style="width:16%;">
					<h4 style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
				    	Load ID: &nbsp;&nbsp; 
				    </h4>
				</td>
				<td style="width:14%;">
					<div style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
						Tariff ID: &nbsp;&nbsp; 
					</div>
		    	</td>
		    	<td style="width:14%;">
					<h4 style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
				    	PV Info: &nbsp;&nbsp; 
				    </h4>
				</td>
   				<td style="width:14%;">
					<h4 style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
				    	Load Increment %: &nbsp;&nbsp; 
				    </h4>
				</td> 
			</tr>
			<tr>
				<td style="height:60px">
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="battery_size" style="font-size:medium;" > </span>  
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="load_name" style="font-size:medium;"> </span> 
				</td>
				<td>
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="tariff_name" style="font-size:medium;"> </span> &nbsp;&nbsp;&nbsp;&nbsp;
		    	</td>
		    	<td>
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="pv_name" style="font-size:medium;"> </span> &nbsp;&nbsp;&nbsp;&nbsp;
		    	</td>
		    	<td style="display:none">
					&nbsp;&nbsp;&nbsp;&nbsp;<span id="dr_name" style="font-size:medium;"> </span> &nbsp;&nbsp;&nbsp;&nbsp;
		    	</td>
 		    	<td>
		    		&nbsp;&nbsp;&nbsp;&nbsp;<span id="load_increment_value" style="font-size:medium;"> </span>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="5" style="height:430px">
					<div id="battery_life" style="width:800px; height:500px;"></div>
				</td>
			</tr>
		</tbody>
	</table>
    
</body>

<script>
//Called when the page is opened
getLogSummaryData();
function getLogSummaryData() {
	var req;
	if (window.XMLHttpRequest) req = new XMLHttpRequest();
	else req = new ActiveXObject("Microsoft.XMLHTTP");

	req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=BatteryLifeAnalysis&uname=" + username + "&emsResultID=" + emsResultID, true);
	req.onreadystatechange = function () {
		if (req.readyState === 4) {
			if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				jData = JSON.parse(data);
				
				document.getElementById("battery_size").innerHTML = batterySize;
				document.getElementById("load_name").innerHTML = jData.LoadName;
				document.getElementById("tariff_name").innerHTML = jData.TariffName;
				document.getElementById("pv_name").innerHTML = jData.PVName + "<BR> (SF=" + jData.PVCapacity + ", PVU=" + jData.PVUtilizationFlag + ")";
				document.getElementById("load_increment_value").innerHTML = jData.LoadIncrementValue + " %";

				showBatteryLife(jData, jData.BattratedVolt, jData.CFMData, jData.WarrantyData);
			}
		}
	}
	req.send(null);
}

function showBatteryLife(jData, volt, cfmData, warrData) {
	
	var capData = [];
	var capDataWarr = [];
	var savData = [];
	
	for (var i=1; i < cfmData.length; i++) {
		var jsonObj = cfmData[i];
		val = ((jsonObj.EOYCapacity * volt) / (jData.kWh * 10) ) ;
		capData.push(Math.round(val));
		savData.push(Math.round(jsonObj.AnnualSaving));
	}
	
	for (var i=1; i < warrData.length; i++) {
		var jsonObj = warrData[i];
		val = ((jsonObj.EOYCapacity * volt) / (jData.kWh * 10) ) ;
		if (jsonObj.isAADEExceeded == true) {
			var element = {
	            y: Math.round(val),
	            marker: {
	                symbol: 'url(../image/x_mark.png)',
	                width: 20,
	                height: 20
	            }
	        }
			
			capDataWarr.push(element);
		} else {
			capDataWarr.push(Math.round(val));
		}
	}

	Highcharts.chart('battery_life', {
	    chart: {
	        zoomType: 'xy',
	        backgroundColor: null
	    },
	    title: {
	        text: 'Battery Life Transition and Annual Savings',
	    },
	    subtitle: {
	        text: 'Battery Size: ' + jData.kWh + 'kWh/' + jData.kW + 'kW, Load: ' + jData.LoadName + ', Tariff: ' + jData.TariffName + ', PV Info: ' + jData.PVName + ' (SF=' + jData.PVCapacity + ', PVU=' + jData.PVUtilizationFlag + ')' + ', Load+: ' + jData.LoadIncrementValue + '%'    	
	    },
	    xAxis: [{
	        categories: ['1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year', '6th Year', '7th Year', '8th Year', '9th Year', '10th Year'],
	        crosshair: true
	    }],
	    yAxis: [{ // Primary yAxis
	        min: 0,
	        max: 100,
	    	labels: {
	            format: '{value} %',
	            style: {
	                color: Highcharts.getOptions().colors[1]
	            }
	        },
	        title: {
	            text: 'Battery Capacity',
	            style: {
	                color: Highcharts.getOptions().colors[1]
	            }
	        }
	    }, { // Secondary yAxis
	        min: 0,
	        title: {
	            text: 'Saving',
	            style: {
	                color: Highcharts.getOptions().colors[0]
	            }
	        },
	        labels: {
	            format: '\${value}',
	            style: {
	                color: Highcharts.getOptions().colors[0]
	            }
	        },
	        opposite: true
	    }],
	    tooltip: {
	        shared: true
	    },
	    legend: {
	        backgroundColor: null
	    },
	    series: [{
	        name: 'Annual Saving',
	        type: 'column',
	        yAxis: 1,
	        data: savData,
	        tooltip: {
	            valuePrefix: '\$'
	        }

	    }, {
	        name: 'EOY Capacity with Fading Model',
	        type: 'spline',
	        color: "#00e600",
	        data: capData,
	        tooltip: {
	            valueSuffix: '%'
	        }
	    }, {
	        name: 'Warranty EOY Capacity',
	        type: 'spline',
	        color: "red",
	        data: capDataWarr,
	        tooltip: {
	            valueSuffix: '%'
	        }
	    }]
	});
}
</script>

<style>
td, th {border: 2px solid black;}
H3 {display: inline;}
.button {
    background-color: #4CAF50; /* Green */
    border: none;
    color: white;
    padding: 7px 16px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 18px;
    margin: 3px 1px;
    cursor: pointer;
}
</style>

</html>