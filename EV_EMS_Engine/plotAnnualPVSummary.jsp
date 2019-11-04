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
<title>PV Utilization Analysis Report</title>
   <script src="../js/jquery-1.11.3.js"></script>
   <script src="../js/jquery-ui.js"></script>
   <script src="../js/bootstrap.min.js"></script>
   <script src="../js/layout.js"></script>
   <script src="../js/necui.js"></script>
   <script src="../js/necui_charts.js"></script>
   
   <script src="https://code.highcharts.com/highcharts.js"></script>
   <script src="https://code.highcharts.com/modules/data.js"></script>
   <script src="https://code.highcharts.com/modules/heatmap.js"></script>
   <script src="https://code.highcharts.com/highcharts-more.js"></script>
   <script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
   
   <link href="http://amcharts.com/lib/3/plugins/export/export.css" rel="stylesheet" type="text/css">
   <link href="../css/necui.css" rel="stylesheet" />
</head>

<script>
   var username = '<%= (String) session.getAttribute("username") %>';
   var password = '<%= (String) session.getAttribute("password") %>';
   var ipAddress = '{{ ipAddress }}';
//   var year = '<%= (String) session.getAttribute("year") %>';
   var emsResultID = '<%= (String) request.getParameter("emsResultID") %>';
   var batterySize = '<%= (String) request.getParameter("batterySize") %>';
   var emsResultTariff = "E20S";
   var loadName = '<%= (String) request.getParameter("loadName") %>';
   var tariffName = '<%= (String) request.getParameter("tariffName") %>';
   var pvName = '<%= (String) request.getParameter("pvName") %>';
</script>

<body>
	
	<!-- 1st Page -->
	<br><br><br>
	<table style="width:1000px;" border=0>
		<thead>
	    <tr style="height:400px">
	        <td align="right" style="vertical-align: top;">
	            <img src="../image/NEC_logo.png" style="width:180px;height:50px;">
	        </td>
	    </tr>
	    </thead>
	    <tr class="separated" style="height:80px;">
	        <td>
	            <div style="font-family:Calibri; font-size:50px; font-weight:bold; text-align:left;">
	                &nbsp; Annual PV Utilization Analysis Report
	            </div>
	        </td>
	    </tr>
	    <tr style="height:600px; vertical-align:top;">
	        <td>
	        	<br>
				<table align="center" style="width:700px;" border=1>
					<col style="width:350px;"><col style="width:250px;"><col style="width:50px;">
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Battery Size: &nbsp; 
				            </div>
				        </td>
				        <td>
				        	<div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
					        	<span id="battery_size"></span> 
				        	</div>
				        </td>
				        <td>
				        	<div style="font-family:Calibri; font-size:20px; text-align:left; margin-left:5%">kWh</div>
				        </td>
				    </tr>
   				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                PCS Size: &nbsp;&nbsp; 
				            </div>
				        </td>
				        
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="pcs_size"></span></div>
				        </td>
				        <td><div style="font-family:Calibri; font-size:20px; text-align:left; margin-left:5%">kW</div></td>
				    </tr>
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Load ID: &nbsp;&nbsp;  
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="load_name" class="numberarea"></span></div>
				        </td>
				        <td></td>
				    </tr>
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Tariff ID: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="tariff_name" class="numberarea"> </span></div>
				        </td>
				        <td></td>				        
				    </tr>
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                PV ID: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="pv_name" class="numberarea"> </span></div>
				        </td>
				        <td></td>				        
				    </tr>
				    <tr>
				        <td>
				        
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Basecase Feed-In Energy: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_pv_base_generation" class="numberarea"> </span></div>
				        </td>
				        <td><div style="font-family:Calibri; font-size:20px; text-align:left; margin-left:5%">kWh</div></td>	
				    </tr>
				    <tr>
				        <td>
				        
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                EMS Feed-In Energy: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_pv_ems_generation" class="numberarea"> </span></div>
				        </td>
				        <td><div style="font-family:Calibri; font-size:20px; text-align:left; margin-left:5%">kWh</div></td>	
				    </tr>
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Feed-In PV Utilized by Battery: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_utilized_pv" class="numberarea"> </span></div>
				        </td>
				        <td><div style="font-family:Calibri; font-size:20px; text-align:left; margin-left:5%">kWh</div></td>
				    </tr>
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                % of Feed-In PV Utilized by Battery: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_pv_utilization" class="numberarea"> </span></div>
				        </td>
				        <td>%</td>
				    </tr>

   				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                % of Charge from PV over Total Charge: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="pv_charging_time_ratio" class="numberarea"> </span></div>
				        </td>
				        <td>%</td>
				    </tr>
				    
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Battery Throughput: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="total_energy_throughput" class="numberarea"> </span></div>
				        </td>
				        <td><div style="font-family:Calibri; font-size:20px; text-align:left; margin-left:5%">kWh</div></td>
				    </tr>
   				    <tr>
				        <td>
				            <div style="height:100px; font-family:Calibri; font-size:20px; text-align:left; margin-left: 5%">
				                Notes: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td></td>
				        <td></td>
				    </tr>
				</table>
	        </td>
	    </tr>
	</table>
	
	<footer>
		<div style="height:100px; font-family:Calibri; font-size:21px;">* Report created at <span id="datetime_toppage" class="numberarea"> </span></div>
	</footer>
	
	<!-- 2nd Page -->
	
	<br><br><br>
	<table align="left" style="width:1000px">
	    <tr class="separated" style="height:45px;">
			<td align="right">
				<img src="../image/NEC_logo.png" style="width:100px;height:30px;">
			</td>
		</tr>
		<tr>
			<td align="center">
				<h1 style="font-family:Calibri;">Tariff Data</h1>
				<!-- <h1 style="font-family:Calibri;">Appendix</h1> -->
			</td>
		</tr>
	</table>
	
	<br><br><br><br>
	<br><br><br>
	<h2 align="left" style="font-family:Calibri;"> Demand Charge for <span id="tariff_name2"></span></h2>
	<table style="font-family:Calibri; width:1000px;" border=1 bordercolor="black">
		<tr style="height:50px;">
			<th style="width:20%;" rowspan="2">Summer Season</th>
			<th style="width:24%;" rowspan="2">Demand Charge Rate [$/kW]</th>
			<th style="width:28%;" colspan="2">1st Time Window</th>
			<th style="width:28%;" colspan="2">2nd Time Window</th>
		</tr>
		<tr style="height:30px;">
			<th>Start</th>
			<th>End</th>
			<th>Start</th>
			<th>End</th>
		</tr>
		<tr style="height:30px;">
			<th>Any Time</th>
			<td><span id="anytime_rate_summer"></span></td>
			<td><span id="anytime_window1_start_summer"></span></td>
			<td><span id="anytime_window1_end_summer"></span></td>
			<td><span id="anytime_window2_start_summer"></span></td>
			<td><span id="anytime_window2_end_summer"></span></td>
		</tr>
		<tr style="height:30px;">
			<th>Partial Peak Time</th>
			<td><span id="partial_rate_summer"></span></td>
			<td><span id="partial_window1_start_summer"></span></td>
			<td><span id="partial_window1_end_summer"></span></td>
			<td><span id="partial_window2_start_summer"></span></td>
			<td><span id="partial_window2_end_summer"></span></td>
		</tr>
		<tr style="height:30px;">
			<th>Peak Time</th>
			<td><span id="peak_rate_summer"></span></td>
			<td><span id="peak_window1_start_summer"></span></td>
			<td><span id="peak_window1_end_summer"></span></td>
			<td><span id="peak_window2_start_summer"></span></td>
			<td><span id="peak_window2_end_summer"></span></td>
		</tr>
	</table>
	<br><br>
	<table style="font-family:Calibri; width:1000px;" border=1 bordercolor="black">
		<tr style="height:50px;">
			<th style="width:20%;" rowspan="2">Winter Season</th>
			<th style="width:24%;" rowspan="2">Demand Charge Rate [$/kW]</th>
			<th style="width:28%;" colspan="2">1st Time Window</th>
			<th style="width:28%;" colspan="2">2nd Time Window</th>
		</tr>
		<tr style="height:30px;">
			<th>Start</th>
			<th>End</th>
			<th>Start</th>
			<th>End</th>
		</tr>
		<tr style="height:30px;">
			<th>Any Time</th>
			<td><span id="anytime_rate_winter"></span></td>
			<td><span id="anytime_window1_start_winter"></span></td>
			<td><span id="anytime_window1_end_winter"></span></td>
			<td><span id="anytime_window2_start_winter"></span></td>
			<td><span id="anytime_window2_end_winter"></span></td>
		</tr>
		<tr style="height:30px;">
			<th>Partial Peak Time</th>
			<td><span id="partial_rate_winter"></span></td>
			<td><span id="partial_window1_start_winter"></span></td>
			<td><span id="partial_window1_end_winter"></span></td>
			<td><span id="partial_window2_start_winter"></span></td>
			<td><span id="partial_window2_end_winter"></span></td>
		</tr>
		<tr style="height:30px;">
			<th>Peak Time</th>
			<td><span id="peak_rate_winter"></span></td>
			<td><span id="peak_window1_start_winter"></span></td>
			<td><span id="peak_window1_end_winter"></span></td>
			<td><span id="peak_window2_start_winter"></span></td>
			<td><span id="peak_window2_end_winter"></span></td>
		</tr>
	</table>
	<br><br>
	<footer>
		<span id="datetime_tariff" class="numberarea" style="height:100px; font-family:Calibri; font-size:18px;"> </span>
	</footer>
	
	<!-- 3rd Page to 14th Page-->
	
<% 
for (int i = 1; i <= 12; i++) {
	String monthStr = "January";
	if (i == 1) {
		monthStr = "January";
	} else if (i == 2) {
		monthStr = "February";
	} else if (i == 3) {
		monthStr = "March";
	} else if (i == 4) {
		monthStr = "April";
	} else if (i == 5) {
		monthStr = "May";
	} else if (i == 6) {
		monthStr = "June";
	} else if (i == 7) {
		monthStr = "July";
	} else if (i == 8) {
		monthStr = "August";
	} else if (i == 9) {
		monthStr = "September";
	} else if (i == 10) {
		monthStr = "October";
	} else if (i == 11) {
		monthStr = "November";
	} else if (i == 12) {
		monthStr = "December";
	}
%>
	<br><br><br>
	<table >
		<tr>
			<td align="right" style="width:1000px">
				<img src="../image/NEC_logo.png" style="width:100px;height:30px;">
			</td>
		</tr>
	</table>
    <table border=3 bordercolor="blue">
    	<tbody>
			<tr>
				<td align="center" colspan="2" style="width:1000px" >
					<h2 style="font-family:Calibri;">Summary of <%= monthStr %> <span id= <%= "year" + i %> ></span>, Project Name: <%= (String) request.getParameter("loadName") %></h2>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<br>
					<div id= <%= "PVPowerTrend" + i %> style="max-width:1000px; height:270px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<br>
					<div id= <%= "FeedInPowerTrend" + i %> style="max-width:1000px; height:270px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<br>
					<div id= <%= "BatteryPowerTrend" + i %> style="max-width:1000px; height:270px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<br>
					<div id= <%= "ems_pv_util_pie" + i%> style="width:500px; height:300px;"></div>
					<br>
				</td>
				<td align="center">
					<br>
					<div id= <%= "battery_pv_util_pie" + i %> style="width:500px; height:300px;"></div>
					<br>
				</td>
			</tr>
		</tbody>
	</table>
    <footer>
    	<span id=<%="datetime" + i%> class="numberarea" style="height:100px; font-family:Calibri; font-size:18px;"> </span>
    </footer>
<% } %>

</body>

<script type="text/javascript">
/** Global variables **/
var index = 0;
var annualPVToBatteryTime = 0;
var annualChargingTime = 0;
var annualPVToBattery = 0;
var annualTotalCharge = 0;

/** Global variables **/
Highcharts.setOptions({
    global: {
        useUTC: false
    }
});

// Internet Explorer 6-11
var isIE = /*@cc_on!@*/false || !!document.documentMode;

/** Javascript begins from here **/
getLogSummaryData();
getData("all");
//getAllData();

function getLogSummaryData() {
	//alert(emsResultID);
	
	var req;
	if (window.XMLHttpRequest) req = new XMLHttpRequest();
	else req = new ActiveXObject("Microsoft.XMLHTTP");

	req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=AnalyzeResults&uname=" + username + "&emsResultID=" + emsResultID, true);
	req.onreadystatechange = function () {
		if (req.readyState === 4) {
			if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				jData = JSON.parse(data);
				
				//processJsonData(jData.EMSResultList);
				var annualPVBaseGen = jData.annual_Esell_NoESS_kWh;
				var annualUtilizedPV = annualPVBaseGen - jData.annual_Esell_ESS_kWh;
				
				var annualPVUtilization = "----";
				if (jData.annual_PV_Utilization != null) {
					annualPVUtilization = Math.round(jData.annual_PV_Utilization * 10)/10;					
				}
				var paybackPeriod = jData.paybackPeriod;
				var totalEnergyThroughput = jData.totalEnergyThroughput;
				
				var monthWithHighestAbsoluteSaving = jData.monthWithHighestAbsoluteSaving;
				var highestAbsoluteSavingOfTheMonth = jData.highestAbsoluteSavingOfTheMonth;
				var monthWithHighestPercentageSaving = jData.monthWithHighestPercentageSaving;
				var highestPercentageSavingOfTheMonth = jData.highestPercentageSavingOfTheMonth;
				var monthWithHighestBatteryThroughput = jData.monthWithHighestBatteryThroughput;
				var highestBatteryThroughputOfTheMonth = jData.highestBatteryThroughputOfTheMonth;
				
				
				var res = batterySize.split("/");
				var bsize = res[0].replace("kWh", "");
				var pcs = res[1].replace("kW", "");
				
				document.getElementById("datetime_toppage").innerHTML = new Date().toString();
				document.getElementById("datetime_tariff").innerHTML = new Date().toString();
				document.getElementById("datetime1").innerHTML = new Date().toString();
				document.getElementById("datetime2").innerHTML = new Date().toString();
				document.getElementById("datetime3").innerHTML = new Date().toString();
				document.getElementById("datetime4").innerHTML = new Date().toString();
				document.getElementById("datetime5").innerHTML = new Date().toString();
				document.getElementById("datetime6").innerHTML = new Date().toString();
				document.getElementById("datetime7").innerHTML = new Date().toString();
				document.getElementById("datetime8").innerHTML = new Date().toString();
				document.getElementById("datetime9").innerHTML = new Date().toString();
				document.getElementById("datetime10").innerHTML = new Date().toString();
				document.getElementById("datetime11").innerHTML = new Date().toString();
				document.getElementById("datetime12").innerHTML = new Date().toString();

				document.getElementById("battery_size").innerHTML = bsize;
				document.getElementById("pcs_size").innerHTML = pcs;
				document.getElementById("load_name").innerHTML = loadName;
				document.getElementById("tariff_name").innerHTML = tariffName;
				document.getElementById("pv_name").innerHTML = pvName;
				document.getElementById("tariff_name2").innerHTML = tariffName;
				document.getElementById("annual_pv_base_generation").innerHTML = numberWithCommas(Math.round(annualPVBaseGen));
				document.getElementById("annual_pv_ems_generation").innerHTML = numberWithCommas(Math.round(jData.annual_Esell_ESS_kWh));				
				document.getElementById("annual_utilized_pv").innerHTML = numberWithCommas(Math.round(annualUtilizedPV));
				document.getElementById("annual_pv_utilization").innerHTML = annualPVUtilization;
				//document.getElementById("payback_period").innerHTML = Math.round( paybackPeriod * 10 ) / 10;
				document.getElementById("total_energy_throughput").innerHTML = numberWithCommas(Math.round(totalEnergyThroughput));
				//document.getElementById("month_highest_saving").innerHTML = monthWithHighestAbsoluteSaving;
				//document.getElementById("month_highest_per_saving").innerHTML = monthWithHighestPercentageSaving;
				//document.getElementById("month_highest_battery").innerHTML = monthWithHighestBatteryThroughput;
			}
		}
	}
	req.send(null);
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function getAllData() {
	for (var i=1; i <= 12; i++) {
		getData(i);
	}
}

function getData(monthInput) {
    var req = null;
    if (window.XMLHttpRequest) { req = new XMLHttpRequest(); }
    else { req = new ActiveXObject("Microsoft.XMLHTTP"); }
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResults&username=" + username + "&datatype=savings&month=" + monthInput + "&emsResultID=" + emsResultID, true);
    req.onreadystatechange = function() {
        if (req.readyState === 4) {
            if (req.status === 200 || req.status == 0) {
				//alert(req.responseText);
				var data = req.responseText;
				var jData = JSON.parse(data);
				//year = jData.year;
				//dataPlot(monthInput, jData);
				
				for (var i = 0; i < jData.EMSResultsAllMonths.length; i++) {
					var monthlyJson = jData.EMSResultsAllMonths[i];
					dataPlot(i+1, monthlyJson);
					annualPVToBatteryTime += monthlyJson.PVToBatteryTimeIndex;
					annualChargingTime += monthlyJson.BatteryChargeTimeIndex;
					annualPVToBattery += monthlyJson.EnergyFromPVToBattery;
					annualTotalCharge += monthlyJson.TotalBatteryCharge;
				}				
				document.getElementById("pv_charging_time_ratio").innerHTML = Math.round((annualPVToBattery * 1000)/annualTotalCharge)/10;
            }
		}
    }
    req.send(null);
}

function dataPlot(monthNum, jData) {
	
	// Parsing Load Hourly Data
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
 	        values.push(Number(round2Fixed(value)));

            count ++;
    	} else {
    		 var value = jData.hourlyLoadData[i] - jData.hourlyGridData[i];
 	  		if (value < 0) {
 	  			value = 0;
 	  		}
 	        values.push(Number(round2Fixed(value)));
            
    		count = 0;
    		day ++;
    	}
    }
    
    document.getElementById("year" + monthNum).innerHTML = jData.year;

	showPVLineGraph(jData.year, monthNum, jData.quarterHourPVData);
	
	var pvToBatteryTimeIndex = showFeedInLineGraph(jData.year, monthNum, jData.quarterHourPVData, jData.quarterHourLoadData, jData.quarterHourGridData);
	
	showBatteryPowerLineGraph(jData.year, monthNum, jData.quarterHourBatteryData);
	
	var totalChargingTime = 0;
	var chargingTimeIndex = 0;
	for (var i = 0; i < jData.quarterHourBatteryData.length; i ++) {
		var batteryPower = jData.quarterHourBatteryData[i];
		if (batteryPower < 0) {
			chargingTimeIndex ++;
		}
	}
	//alert("pvToBatteryTimeIndex: " + pvToBatteryTimeIndex + ", chargingTimeIndex: " + chargingTimeIndex);
	//alert("rate: " + jData.PVToBatteryTimeRatio);
	
	var toLoadBasecase = 0;
	var toGridBasecase = 0;
	var totalPV = 0;
	for (var i = 0; i < jData.quarterHourPVData.length; i ++) {
		var pvVal = jData.quarterHourPVData[i]/4;
		var loadVal = jData.quarterHourLoadData[i]/4;
		if (pvVal > loadVal) {
			toGridBasecase += (pvVal - loadVal);
			toLoadBasecase += loadVal;
		} else {
			toLoadBasecase += pvVal;
		}
	}
	//showBasePVUtilPieChart(monthNum, toLoadBasecase, toGridBasecase);
	//showBatteryToPVUsagePieChart(monthNum, jData.BatteryChargeTimeIndex, jData.PVToBatteryTimeIndex);
	//PVToBatteryTimeRatio = PVToBatteryTimeIndex/BatteryChargeTimeIndex;
	showBatteryToPVUsageGaugeChart(monthNum, jData.TotalBatteryCharge, jData.EnergyFromPVToBattery);
	
	var toLoadEMS = 0;
	var toGridEMS = 0;
	var toBattery = 0;
	for (var i = 0; i < jData.quarterHourPVData.length; i ++) {
		var pvVal = jData.quarterHourPVData[i]/4;
		var loadVal = jData.quarterHourLoadData[i]/4;
		var gridVal = jData.quarterHourGridData[i]/4;
		if (pvVal > loadVal) {
			toGridEMS += -gridVal;
			toLoadEMS += loadVal;
			toBattery += pvVal - loadVal + gridVal;
		} else {
			toLoadEMS += pvVal;
		}
	}
	showEMSPVUtilPieChart(monthNum, toLoadEMS, toGridEMS, toBattery);

	
	//showSOCGraph(jData.year, monthNum, jData.quarterHourSOCData);
	//dynamicPeakLoad(monthNum, jData.hourlyLoadData, jData.hourlyGridData, values);
	//dynamicPeakLoad(monthNum, jData.quarterHourLoadData, jData.quarterHourGridData, values);
	//showStackedBar(monthNum, jData);
	
	showDCRates(monthNum, jData.currentMonthDCRate.AnyTimeDCRate, jData.currentMonthDCRate.PartialPeakTimeDCRate, jData.currentMonthDCRate.PeakTimeDCRate);
}

function showPVLineGraph(year, month, pvData) {
	
	var id = 'PVPowerTrend' + month;
	
	var adjust = 0;

	var chart = new Highcharts.chart(id, {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>PV Generation</b>',
            style: {
                display: 'none'
            }            
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: [{
        	opposite: true,
        	//min: 0,
            title: {
                text: 'Power [kW]'
            }
        },{ // Primary yAxis            
            min: 0,
            title: {
                text: '<b>PV GENERATION</b>'
            }
        }],
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
        },
        series: [{
            type: 'area',
            name: 'PV Generation',
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
                for (index = 0; index < pvData.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: pvData[index]
                    });
                }
                return data;
            }())
        }/*,{
            type: 'area',
            name: 'Grid Power',
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
                for (index = 0; index < gridData.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: gridData[index]
                    });
                }
                return data;
            }())
        }*/]
    });
}


function showFeedInLineGraph(year, month, pvData, loadData, gridData) {
	
	var id = 'FeedInPowerTrend' + month;
	
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
	
	var totalPVToBatteryTimeIndex = 0;
	for (var i = 0; i < PSell_NoESS.length; i++) {
		var delta = PSell_NoESS[i] - PSell_ESS[i];
		if (delta > 0.5) {
			totalPVToBatteryTimeIndex ++;
		}
	}
	
	var adjust = 0;

	var chart = new Highcharts.chart(id, {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Net Demand and Grid Power</b>',
            style: {
                display: 'none'
            }            
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: [{
        	opposite: true,
        	//min: 0,
            title: {
                text: 'Power [kW]'
            }
        },{ // Primary yAxis            
            min: 0,
            title: {
                text: '<b>FEED-IN POWER TO GRID</b>'
            }
        }],
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
        },
        series: [{
            type: 'area',
            name: 'Basecase',
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
                for (index = 0; index < loadData.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: PSell_NoESS[index]
                    });
                }
                return data;
            }())
        },{
            type: 'area',
            name: 'ESS',
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
                for (index = 0; index < gridData.length; index += 1) {
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
	
	return totalPVToBatteryTimeIndex;
}

function showBatteryPowerLineGraph(year, month, monthlyData) {
	
	var adjust = 0;
	
	var id = 'BatteryPowerTrend' + month;

    Highcharts.chart(id, {
        chart: {
        	type: 'area',
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Battery Power</b>',
            style: {
                display: 'none'
            }
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: [{
        	opposite: true,
            title: {
                text: 'Power [kW]'
            }
        },{ // Primary yAxis            
            min: 0,
            title: {
                text: '<b>BATTERY POWER</b>'
            }
        }],
        legend: {
            enabled: false
        },
        plotOptions: {
        	series: {
        		turboThreshold: 3000
        	},
            area: {
              stacking: 'normal',
              lineColor: "blue",
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
            name: 'Battery Power',
            data: (function() {
                var data = [];
                var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
                for (index = 0; index < monthlyData.length; index += 1) {
                    //timeL = timeL + 1000 * 60 * 60;
                    timeL = timeL + 1000 * 60 * 15;
                    data.push({
                        x: timeL,
                        y: monthlyData[index]
                    });
                }
                return data;
            }())
        }],
        zones: [{
          	color: '#1B8753',
            value: 0
          },{
          	color: '#FF0000'
          }]
    });
}

function showSOCGraph(year, month, monthlyData) {

	var adjust = 0;
	
	var id = 'SOCTrend' + month;
	var chart = new Highcharts.chart(id, {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>State of Charge</b>',
            style: {
                display: 'none'
            }
        },
        series: {
    		turboThreshold: 3000
    	},
        xAxis: {
            type: 'datetime'
        },
        yAxis: [{
        	opposite: true,
        	max: 100,
        	min: 0,
            title: {
                text: 'SOC [%]'
            }
        },{ // Primary yAxis            
            title: {
                text: '<b>STATE of CHARGE</b>'
            }
        }],
        legend: {
            enabled: false
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
                for (index = 0; index < monthlyData.length; index += 1) {
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
}

function dynamicPeakLoad(month, hourlyLoad, hourlyGrid, hourlySaving) {
	
	var id = '#peak_load' + month;

	$(function() {
        $(id).highcharts({
            chart: {
                type: 'column',
                backgroundColor: null,
                events: {
                    load: function() {
                        var maxValue1 = 0;
                        var maxValue2 = 0;
                        var series0 = this.series[0];
                        for (var index =0 ; index < hourlyGrid.length; index++) {
                            if (hourlyGrid[index] > maxValue1) {
                                maxValue1 = hourlyGrid[index];
                            }
                            if (hourlyLoad[index] > maxValue2) {
                                maxValue2 = hourlyLoad[index];
                            }
                        }
                        series0.setData([maxValue1, maxValue2]);
                    }
                }
            },
            title: {
                text: '<b>Peak Load</b>',
                style: {
                    display: 'none'
                }
            },
            legend: {
                enabled: false
            },
            xAxis: {
                categories: ['EMS', 'Basecase']
            },
            yAxis: {
                min: 0,
                title: {
                    text: '<b>PEAK LOAD (kW)</b>'
                }
            },
            credits: {
                enabled: false
            },
            series: [{
                name: 'Peak Load',
                data: [0, 0]
            }]
        });
    });
}

function showStackedBar(month, jData) {
	
	var id = '#SavingStackedBar' + month;
	
    $(function() {
        $(id).highcharts({
            chart: {
                type: 'column',
                backgroundColor: null,
            },
            title: {
                text: '<b>Demand Charge Savings</b>',
                style: {
                    display: 'none'
                }
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
                //max: 600,
                title: {
                    text: '<b>DEMAND CHARGE SAVINGS ($)</b>'
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
                headerFormat: '<b>{series.name}</b><br/>', //{point.x}
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
            }]
        });
    });
}

function showDCRates(month, anyTimeDCRate, partialPeakTimeDCRate, peakTimeDCRate) {
	
	if (month == 1) {
		document.getElementById("anytime_rate_winter").innerHTML = anyTimeDCRate.Value$kW;
		document.getElementById("anytime_window1_start_winter").innerHTML = anyTimeDCRate.firstTimeWindow_start;
		document.getElementById("anytime_window1_end_winter").innerHTML = anyTimeDCRate.firstTimeWindow_end;
		document.getElementById("anytime_window2_start_winter").innerHTML = anyTimeDCRate.secondTimeWindow_start;
		document.getElementById("anytime_window2_end_winter").innerHTML = anyTimeDCRate.secondTimeWindow_end;
		
		document.getElementById("partial_rate_winter").innerHTML = partialPeakTimeDCRate.Value$kW;
		document.getElementById("partial_window1_start_winter").innerHTML = partialPeakTimeDCRate.firstTimeWindow_start;
		document.getElementById("partial_window1_end_winter").innerHTML = partialPeakTimeDCRate.firstTimeWindow_end;
		document.getElementById("partial_window2_start_winter").innerHTML = partialPeakTimeDCRate.secondTimeWindow_start;
		document.getElementById("partial_window2_end_winter").innerHTML = partialPeakTimeDCRate.secondTimeWindow_end;
		
		document.getElementById("peak_rate_winter").innerHTML = peakTimeDCRate.Value$kW;
		document.getElementById("peak_window1_start_winter").innerHTML = peakTimeDCRate.firstTimeWindow_start;
		document.getElementById("peak_window1_end_winter").innerHTML = peakTimeDCRate.firstTimeWindow_end;
		document.getElementById("peak_window2_start_winter").innerHTML = peakTimeDCRate.secondTimeWindow_start;
		document.getElementById("peak_window2_end_winter").innerHTML = peakTimeDCRate.secondTimeWindow_end;
	}
	
	if (month == 8) {
		document.getElementById("anytime_rate_summer").innerHTML = anyTimeDCRate.Value$kW;
		document.getElementById("anytime_window1_start_summer").innerHTML = anyTimeDCRate.firstTimeWindow_start;
		document.getElementById("anytime_window1_end_summer").innerHTML = anyTimeDCRate.firstTimeWindow_end;
		document.getElementById("anytime_window2_start_summer").innerHTML = anyTimeDCRate.secondTimeWindow_start;
		document.getElementById("anytime_window2_end_summer").innerHTML = anyTimeDCRate.secondTimeWindow_end;
		
		document.getElementById("partial_rate_summer").innerHTML = partialPeakTimeDCRate.Value$kW;
		document.getElementById("partial_window1_start_summer").innerHTML = partialPeakTimeDCRate.firstTimeWindow_start;
		document.getElementById("partial_window1_end_summer").innerHTML = partialPeakTimeDCRate.firstTimeWindow_end;
		document.getElementById("partial_window2_start_summer").innerHTML = partialPeakTimeDCRate.secondTimeWindow_start;
		document.getElementById("partial_window2_end_summer").innerHTML = partialPeakTimeDCRate.secondTimeWindow_end;
		
		document.getElementById("peak_rate_summer").innerHTML = peakTimeDCRate.Value$kW;
		document.getElementById("peak_window1_start_summer").innerHTML = peakTimeDCRate.firstTimeWindow_start;
		document.getElementById("peak_window1_end_summer").innerHTML = peakTimeDCRate.firstTimeWindow_end;
		document.getElementById("peak_window2_start_summer").innerHTML = peakTimeDCRate.secondTimeWindow_start;
		document.getElementById("peak_window2_end_summer").innerHTML = peakTimeDCRate.secondTimeWindow_end;
	}
	

	
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
//			var coloring = colors[j];
//			if (values[0] == price) {
//				coloring = colors[0];
//			} else if (values[1] == price) {
//				coloring = colors[1];
//			}
			if (tou[i] == round2Fixed(peakTimeDCRate.Value$kW))
				coloring = '#ff9999';
			if (tou[i] == round2Fixed(partialPeakTimeDCRate.Value$kW))
				coloring = '#ffcccc';
			if (tou[i] == round2Fixed(anyTimeDCRate.Value$kW))
				coloring = '#ffe6e6';
		
			var point = {
					//label: {text: "$" + price},
					color: coloring, // Color value
		    	    from: from, // Start of the plot band
		    	    to: 23 // End of the plot band
	    	    };
			values.push(price);
			touPoints.push(point);
		}
	}
	
	// alert(values);
	var chart = new Highcharts.chart('savingview', {
	    chart: {
	    	backgroundColor: null,
	        type: 'column'
	    },
	    title: {
	        text: 'Energy Shaved by Hour'
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

function showBasePVUtilPieChart(month, toLoad, toGrid) {
	
	var id = 'base_pv_util_pie' + month;
	
	var asset_allocation_pie_chart = new Highcharts.Chart({
			chart : {
				renderTo : id,
				marginLeft : 0,
				width : null
			},
			title : {
				text : 'PV Usage',
				style : {
					fontSize : '17px',
					color : 'red',
					fontWeight : 'bold',
					fontFamily : 'Verdana'
				}
			},
			subtitle : {
				text : 'Basecase',
				style : {
					fontSize : '15px',
					color : 'red',
					fontFamily : 'Verdana',
					marginBottom : '10px'
				},
				y : 40
			},
			tooltip : {
				pointFormat : '{series.name}: <b>{point.percentage}%</b>',
				percentageDecimals : 0
			},
			plotOptions : {
				pie : {
					size : '70%',
					cursor : 'pointer',
					data : [ [ 'Load', toLoad ],
					         [ 'Grid', toGrid ] ]
				}
			},
			series : [
					{
						type : 'pie',
						name : 'Percentage',
						dataLabels : {
							verticalAlign : 'top',
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : -30,
							connectorColor : '#000000',
							formatter : function() {
								return Math.round(this.percentage) + ' %';
							}
						}
					},
					{
						type : 'pie',
						name : 'Percentage',
						dataLabels : {
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : 30,
							connectorColor : '#000000',
							formatter : function() {
								return '<b>' + this.point.name + '</b>:<br/> '
										+ Math.round(this.y) + ' kWh';
							}
						}
					} ],
			exporting : {
				enabled : false
			},
			credits : {
				enabled : false
			}
		});

		/*
		Highcharts.chart(id, {
		    chart: {
		    	width: 300,
		        plotBackgroundColor: null,
		        plotBorderWidth: null,
		        plotShadow: false,
		        type: 'pie'
		    },
		    title: {
		        text: 'PV Usage'
		    },
		    tooltip: {
		        pointFormat: '{series.name}: <b>{point.y}kWh</b>, <b>{point.percentage:.1f}%</b>'
		    },
		    plotOptions: {
		        pie: {
		        	//size: "90%",
		            allowPointSelect: true,
		            cursor: 'pointer',
		            dataLabels: {
		                enabled: true,
		                format: '<b>{point.name}</b>:<br>{point.y:.1f} kWh<br> {point.percentage:.1f} %',
		                style: {
		                    color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
		                }
		            }
		        }
		    },
		    series: [{
		        name: 'PV Usage',
		        colorByPoint: true,
		        data: [{
		            name: 'Grid',
		            y: 56.33,
		            color: 'orange',
		            dataLabels: {
		                enabled: true,
		                color: '#000000',
		                connectorWidth: 1,
		                distance: 30,
		                connectorColor: '#000000',
		                formatter: function() {
		                    return '<b>' + this.point.name + '</b>:<br/> ' + Math.round(this.percentage) + ' %';
		                }
		            }
		        }, {
		            name: 'Load',
		            y: 24.03,
		            color: 'blue'
		            //sliced: true
		            //selected: true
		        }]
		    }]
		});*/
	}
	
function showEMSPVUtilPieChart(month, toLoad, toGrid, toBattery) {
	
	var id = 'ems_pv_util_pie' + month;
	
	var asset_allocation_pie_chart = new Highcharts.Chart({
			chart : {
				renderTo : id,
				marginLeft : 0,
				width : null
			},
			title : {
				text : 'PV Usage Ratio',
				style : {
					fontSize : '17px',
					color : 'red',
					fontWeight : 'bold',
					fontFamily : 'Verdana'
				}
			},
			/*subtitle : {
				text : 'With EMS',
				style : {
					fontSize : '15px',
					color : 'red',
					fontFamily : 'Verdana',
					marginBottom : '10px'
				},
				y : 40
			},*/
			tooltip : {
				pointFormat : '{series.name}: <b>{point.percentage}%</b>',
				percentageDecimals : 0
			},
			plotOptions : {
				pie : {
					size : '70%',
					cursor : 'pointer',
					data : [ [ 'Load', toLoad ], [ 'Grid', toGrid ],
							[ 'Battery', toBattery ], ]
				}
			},
			series : [
					{
						type : 'pie',
						name : 'Percentage',
						y : 16.22453,
						dataLabels : {
							verticalAlign : 'top',
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : -30,
							connectorColor : '#000000',
							formatter : function() {
								return Math.round(this.percentage) + ' %';
							}
						}
					},
					{
						type : 'pie',
						name : 'Percentage',
						y : 26.22453,
						dataLabels : {
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : 30,
							connectorColor : '#000000',
							formatter : function() {
								return '<b>' + this.point.name + '</b>:<br/> '
										+ Math.round(this.y) + ' kWh';
							}
						}
					} ],
			exporting : {
				enabled : false
			},
			credits : {
				enabled : false
			}
		});
	}
function showBatteryToPVUsageGaugeChart(month, totalCharge, pvToBattery) {
	
	var id = 'battery_pv_util_pie' + month;
	
    var maxValue1 = Math.round(pvToBattery); 
    var maxValue2 = Math.round(totalCharge);

	$(function () {
	    Highcharts.chart(id, {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Charge from PV over Total Charge</b>',
	        	style: { color: 'red' }
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
	            pointFormat: '<b>EMS</b><br><span style="font-size:1.1em; color: green; font-weight: bold">' + maxValue1 + ' kWh</span>',
	            positioner: function (labelWidth, labelHeight) {
	                return {
	                    x: 20,
	                    y: 50
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
	            max: maxValue2,
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
	        		x: 0, y: -5,
	        		format: '<b>Total Charge</b><br>{value} kWh',
	        		style: {
	            		fontSize: 12
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
	                y: maxValue1
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -50,
	                format: '<b><span style="font-size:1.4em">Charge from PV</span></b><br><span style="font-size:1.4em; color: green; font-weight:bold">' + maxValue1 + ' kWh</span><br>' + 
	                	'<span align="center" style="font-size:1.6em; color: green; font-weight:bold;">' + Math.round(maxValue1*1000/maxValue2)/10 + '%</span>' 
		            + '<br><br><br>',
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

function showBatteryToPVUsagePieChart(month, totalChargingTime, pvToBatteryTime) {
	
	var id = 'battery_pv_util_pie' + month;
	
	var asset_allocation_pie_chart = new Highcharts.Chart({
			chart : {
				renderTo : id,
				marginLeft : 0,
				width : null
			},
			title : {
				text : 'PV Usage',
				style : {
					fontSize : '17px',
					color : 'red',
					fontWeight : 'bold',
					fontFamily : 'Verdana'
				}
			},
			subtitle : {
				text : 'Basecase',
				style : {
					fontSize : '15px',
					color : 'red',
					fontFamily : 'Verdana',
					marginBottom : '10px'
				},
				y : 40
			},
			tooltip : {
				pointFormat : '{series.name}: <b>{point.percentage}%</b>',
				percentageDecimals : 0
			},
			plotOptions : {
				pie : {
					size : '70%',
					cursor : 'pointer',
					data : [ [ 'Total Charge', totalChargingTime ],
					         [ 'Charge from PV', pvToBatteryTime ] ]
				}
			},
			series : [
					{
						type : 'pie',
						name : 'Percentage',
						dataLabels : {
							verticalAlign : 'top',
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : -30,
							connectorColor : '#000000',
							formatter : function() {
								return Math.round(this.percentage) + ' %';
							}
						}
					},
					{
						type : 'pie',
						name : 'Percentage',
						dataLabels : {
							enabled : true,
							color : '#000000',
							connectorWidth : 1,
							distance : 30,
							connectorColor : '#000000',
							formatter : function() {
								return '<b>' + this.point.name + '</b>:<br/> '
										+ Math.round(this.y) + ' minutes';
							}
						}
					} ],
			exporting : {
				enabled : false
			},
			credits : {
				enabled : false
			}
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

<style type="text/css" media="print">
@page {
    size: auto;   /* auto is the initial value */
    margin-top: 0;  /* this affects the margin in the printer settings */
    margin-bottom: 0;
}
@media print {
    footer {page-break-after: always;}
}
</style>

<style>
tr.separated td {
    /* set border style for separated rows */
    border-bottom: 2px solid blue;
}
table {
    /* make the border continuous (without gaps between columns) */
    border-collapse: collapse;
}
</style>

</html>
