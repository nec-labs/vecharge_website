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
<title>Bill Minimization Report</title>
   <script src="../js/jquery-1.11.3.js"></script>
   <script src="../js/jquery-ui.js"></script>
   <script src="../js/bootstrap.min.js"></script>
   <script src="../js/layout.js"></script>
   <script src="../js/necui.js"></script>
   <script src="../js/necui_charts.js"></script>
   
   <script src="https://code.highcharts.com/highcharts.js"></script>
   <script src="https://code.highcharts.com/modules/data.js"></script>
   <script src="https://code.highcharts.com/modules/heatmap.js"></script>
   
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
   var touFlag = '<%= (String) request.getParameter("touFlag") %>';
</script>

<body>
	
	<!-- 1st Page -->
	<br><br><br>
	<table style="width:1000px;" border=0>
		<thead>
	    <tr style="height:250px">
	        <td align="right" style="vertical-align: top;">
	            <img src="../image/NEC_logo.png" style="width:180px;height:50px;">
	        </td>
	    </tr>
	    </thead>
	    <tr class="separated" style="height:80px;">
	        <td>
	            <div style="font-family:Calibri; font-size:50px; font-weight:bold; text-align:left;">
	                &nbsp; Bill Minimization Report
	            </div>
	        </td>
	    </tr>
	    <tr style="height:600px; vertical-align:top;">
	        <td>
	        	<br>
				<table align="center" style="width:600px;" border=1>
					<col style="width:320px;"><col style="width:170px;"><col style="width:60px;">
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

				    <tr id="annual_total_cost_sec">
				        <td>
				        
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Annual Total Base Cost: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_total_base_cost" class="numberarea"> </span></div>
				        </td>
				        <td></td>	
				    </tr>
				    <tr id="annual_total_cost_saving_sec">
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Annual Total Savings: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_total_savings" class="numberarea"> </span></div>
				        </td>
				        <td></td>
				    </tr>
				    
				    <tr style="display:none">
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                (Average) Annual DC Base Cost: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_dc_base_cost" class="numberarea"> </span></div>
				        </td>
				        <td></td>	
				    </tr>
				    <tr style="display:none">
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                (Average) Annual DC Savings: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="annual_savings" class="numberarea"> </span></div>
				        </td>
				        <td></td>
				    </tr>
				    <tr style="display:none">
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Potential Saving Range: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="potential_saving_range" class="numberarea"> </span></div>
				        </td>
				        <td></td>
				    </tr>
				    
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                Annual PV Utilization: &nbsp;&nbsp; 
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
				                Payback Period: &nbsp;&nbsp; 
				            </div>
				        </td>
				        <td>
				        <div style="font-family:Calibri; font-size:20px; text-align:right; margin-right:5%">
				        	<span id="payback_period" class="numberarea"> </span></div>
				        </td>
				        <td><div style="font-family:Calibri; font-size:20px; text-align:left; margin-left:5%">Years</div></td>
				    </tr>
				    <tr>
				        <td>
				            <div style="font-family:Calibri; font-size:20px; text-align:right; margin-left: 5%">
				                (Average) Battery Throughput: &nbsp;&nbsp; 
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
				    <!-- 
				    <tr>
				        <td>
				
				            <br>
				            <div style="font-family:Calibri; font-size:30px; text-align:left; margin-left:5%; display:none">
				                Month with Highest Absolute Saving: &nbsp;&nbsp; <span id="month_highest_saving" class="numberarea"> </span>
				            </div>
				        </td>
				    </tr>
				    <tr>
				        <td>
				
				            <br>
				            <div style="font-family:Calibri; font-size:30px; text-align:left; margin-left:5%; display:none">
				                Month with Highest % Saving: &nbsp;&nbsp; <span id="month_highest_per_saving" class="numberarea"> </span>
				            </div>
				        </td>
				    </tr>
				    <tr>
				        <td>
				
				            <br>
				            <div style="font-family:Calibri; font-size:30px; text-align:left; margin-left:5%; display:none">
				                Month with Highest Battery Throughput: &nbsp;&nbsp; <span id="month_highest_battery" class="numberarea"> </span>
				            </div>
				        </td>
				    </tr> 
				    -->
				</table>
				
				<table>
					<tr style="height:450px">
		  				<td align="center" style="width:50%;">
							<div id="monthlySavings" style="width:550px; height:350px;"></div>
						</td>
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
	<table align="left" style="height:580px"; width: 1000px">
		<tr class="separated" style="height: 45px;">
			<td align="right"><img src="../image/NEC_logo.png"
				style="width: 100px; height: 30px;"></td>
		</tr>
		<tr>
			<td align="center">
				<h1 style="font-family: Calibri;">Annual Monthly Max Demands and Savings</h1>
			</td>
		</tr>
		<tr>
			<td align="center">
				<table align="center" style="width: 1000px;" border=1>
					<tr >
						<th>
							<div
								style="font-family: Calibri; text-align: center; margin-left: 5%">
								Month</div>
						</th>
						<!-- <th colspan="3">
							<div
								style="font-family: Calibri; text-align: center; margin-left: 5%">
								Basecase Max kW <br> (Anytime, Partial, Peak)
							</div>
						</th>
						<th colspan="3">
							<div
								style="font-family: Calibri; text-align: center; margin-left: 5%">
								EMS Max kW <br> (Anytime, Partial, Peak)
							</div>
						</th>-->
						<th>
							<div
								style="font-family: Calibri; text-align: center; margin-left: 5%">
								Demand Peak Date&Time</div>
						</th> 
						<th>
							<div
								style="font-family: Calibri; text-align: center; margin-left: 5%">
								Basecost ($) 
							</div>
						</th>
						<th>
							<div
								style="font-family: Calibri; text-align: center; margin-left: 5%">
								EMS Cost ($) 
							</div>
						</th>
						<th>
							<div
								style="font-family: Calibri; text-align: center; margin-left: 5%">
								Savings ($) 
							</div>
						</th>
					</tr>
<% 
for (int i = 1; i <= 12; i++) {
	String monthStr = "Jan";
	if (i == 1) {
		monthStr = "Jan";
	} else if (i == 2) {
		monthStr = "Feb";
	} else if (i == 3) {
		monthStr = "Mar";
	} else if (i == 4) {
		monthStr = "Apr";
	} else if (i == 5) {
		monthStr = "May";
	} else if (i == 6) {
		monthStr = "Jun";
	} else if (i == 7) {
		monthStr = "Jul";
	} else if (i == 8) {
		monthStr = "Aug";
	} else if (i == 9) {
		monthStr = "Sep";
	} else if (i == 10) {
		monthStr = "Oct";
	} else if (i == 11) {
		monthStr = "Nov";
	} else if (i == 12) {
		monthStr = "Dec";
	}
%>
					<tr style="height:30px">
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-left: 5%">
								<%= monthStr %>
								&nbsp;
							</div>
						</td>
						<!-- <td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "base_anytime" + i %>></span>
							</div>
						</td>
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "base_partial" + i %>></span>
							</div>
						</td>
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "base_peak" + i %>></span>
							</div>
						</td>
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "ems_anytime" + i %>></span>
							</div>
						</td>
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "ems_partial" + i %>></span>
							</div>
						</td>
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "ems_peak" + i %>></span>
							</div>
						</td> -->
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "peak_datetime" + i %>></span>
							</div>
						</td> 
						<!--  <td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "saving_anytime" + i %>></span>
							</div>
						</td> -->
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "monthly_basecost" + i %>></span>
							</div>
						</td>
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "monthly_ems_cost" + i %>></span>
							</div>
						</td>
						<td>
							<div
								style="font-family: Calibri; text-align: right; margin-right: 5%">
								<span id=<%= "monthly_ems_saving" + i %>></span>
							</div>
						</td>
					</tr>
					<% } %>
				</table>
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<td align="center">
				<h1 style="font-family: Calibri;">Tariff Data</h1>
				<div align="left" style="font-family: Calibri; font-size: 25px">
					<b>Demand Charge for <span id="tariff_name2"></span></b>
				</div>
			</td>
		</tr>
		<tr>
			<td align="center">
				<table style="font-family: Calibri; width: 1000px;" border=1
					bordercolor="black">
					<tr style="height: 50px;">
						<th style="width: 20%;" rowspan="2">Summer Season</th>
						<th style="width: 24%;" rowspan="2">Demand Charge Rate [$/kW]</th>
						<th style="width: 28%;" colspan="2">1st Time Window</th>
						<th style="width: 28%;" colspan="2">2nd Time Window</th>
					</tr>
					<tr style="height: 30px;">
						<th>Start</th>
						<th>End</th>
						<th>Start</th>
						<th>End</th>
					</tr>
					<tr style="height: 30px;">
						<th>Any Time</th>
						<td><span id="anytime_rate_summer"></span></td>
						<td><span id="anytime_window1_start_summer"></span></td>
						<td><span id="anytime_window1_end_summer"></span></td>
						<td><span id="anytime_window2_start_summer"></span></td>
						<td><span id="anytime_window2_end_summer"></span></td>
					</tr>
					<tr style="height: 30px;">
						<th>Partial Peak Time</th>
						<td><span id="partial_rate_summer"></span></td>
						<td><span id="partial_window1_start_summer"></span></td>
						<td><span id="partial_window1_end_summer"></span></td>
						<td><span id="partial_window2_start_summer"></span></td>
						<td><span id="partial_window2_end_summer"></span></td>
					</tr>
					<tr style="height: 30px;">
						<th>Peak Time</th>
						<td><span id="peak_rate_summer"></span></td>
						<td><span id="peak_window1_start_summer"></span></td>
						<td><span id="peak_window1_end_summer"></span></td>
						<td><span id="peak_window2_start_summer"></span></td>
						<td><span id="peak_window2_end_summer"></span></td>
					</tr>
				</table> 
				<br> <br>
				<table style="font-family: Calibri; width: 1000px;" border=1 bordercolor="black">
					<tr style="height: 50px;">
						<th style="width: 20%;" rowspan="2">Winter Season</th>
						<th style="width: 24%;" rowspan="2">Demand Charge Rate [$/kW]</th>
						<th style="width: 28%;" colspan="2">1st Time Window</th>
						<th style="width: 28%;" colspan="2">2nd Time Window</th>
					</tr>
					<tr style="height: 30px;">
						<th>Start</th>
						<th>End</th>
						<th>Start</th>
						<th>End</th>
					</tr>
					<tr style="height: 30px;">
						<th>Any Time</th>
						<td><span id="anytime_rate_winter"></span></td>
						<td><span id="anytime_window1_start_winter"></span></td>
						<td><span id="anytime_window1_end_winter"></span></td>
						<td><span id="anytime_window2_start_winter"></span></td>
						<td><span id="anytime_window2_end_winter"></span></td>
					</tr>
					<tr style="height: 30px;">
						<th>Partial Peak Time</th>
						<td><span id="partial_rate_winter"></span></td>
						<td><span id="partial_window1_start_winter"></span></td>
						<td><span id="partial_window1_end_winter"></span></td>
						<td><span id="partial_window2_start_winter"></span></td>
						<td><span id="partial_window2_end_winter"></span></td>
					</tr>
					<tr style="height: 30px;">
						<th>Peak Time</th>
						<td><span id="peak_rate_winter"></span></td>
						<td><span id="peak_window1_start_winter"></span></td>
						<td><span id="peak_window1_end_winter"></span></td>
						<td><span id="peak_window2_start_winter"></span></td>
						<td><span id="peak_window2_end_winter"></span></td>
					</tr>
				</table>
			</td>
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
					<h2 style="font-family:Calibri;"><%= monthStr %> <span id= <%= "year" + i %> ></span></h2>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<br>
					<div id= <%= "LoadGridPowerTrend" + i %> style="max-width:1000px; height:320px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<br>
					<div id= <%= "BestDayTrend" + i %> style="max-width:1000px; height:300px; margin: 0 auto"></div>
				</td>
			</tr>
			<!-- 
			<tr>
				<td align="center" colspan="2">
					<br>
					<div id= <%= "BatteryPowerTrend" + i %> style="max-width:1000px; height:300px; margin: 0 auto"></div>
				</td>
			</tr>
			-->
			<tr>
				<td align="center" colspan="2">
					<br>
					<div id= <%= "SOCTrend" + i %> style="max-width:1000px; height:230px; margin: 0 auto"></div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<br>
					<div id= <%= "peak_load" + i%> style="width:400px; height:250px;"></div>
					<div id= <%= "peak_time" + i%> style="font-family:Calibri;" ></div> <br>
				</td>
				<td align="center">
					<br>
					<div id= <%= "savingPieChart" + i %> style="width:400px; height:250px;"></div>
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
//UTC is not enabled 
Highcharts.setOptions({
    global: {
        useUTC: false
    }
});

//Called when the page is opened
var annualTotalSaving = 0;
getLogSummaryData();
getData("all");

function getLogSummaryData() {
	var req;
	if (window.XMLHttpRequest) req = new XMLHttpRequest();
	else req = new ActiveXObject("Microsoft.XMLHTTP");

	req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=AnalyzeResults&uname=" + username + "&emsResultID=" + emsResultID, true);
	req.onreadystatechange = function () {
		if (req.readyState === 4) {
			if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				jData = JSON.parse(data);
				
				var annualTotalBaseCost = jData.totalBaseCost;
				var annualTotalSavings = jData.annualTotalSaving;
				annualTotalSaving = jData.annualTotalSaving;
				
				var annualDCBaseCost = jData.annualDCBaseCost;
				var annualSavings = jData.annualSavings;
				
				var annualSavingsP = jData.annualSavingsVarPlus;
				var annualSavingsM = jData.annualSavingsVarMinus;
				
				var annualPVUtilization = "NA";
				if (jData.annual_PV_Utilization != null && jData.annual_PV_Utilization > 0) {
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
				
				
				//if (touFlag == "true") {
					document.getElementById("annual_total_base_cost").innerHTML = "$" + numberWithCommas(annualTotalBaseCost);
					document.getElementById("annual_total_savings").innerHTML = "$" + numberWithCommas(annualTotalSavings);
				//} else {
				//	document.getElementById("annual_total_cost_sec").style.display = "none";
				//	document.getElementById("annual_total_cost_saving_sec").style.display = "none";
				//}
			
				document.getElementById("annual_dc_base_cost").innerHTML = "$" + numberWithCommas(annualDCBaseCost);
				document.getElementById("annual_savings").innerHTML = "$" + numberWithCommas(annualSavings);
				
				if (!annualSavingsM || !annualSavingsP) {
					document.getElementById("potential_saving_range").innerHTML = "NA";
				} else {
					document.getElementById("potential_saving_range").innerHTML = "$" + numberWithCommas(annualSavingsM) + " - $" + numberWithCommas(annualSavingsP);
				}
				document.getElementById("annual_pv_utilization").innerHTML = annualPVUtilization;
				document.getElementById("payback_period").innerHTML = Math.round( paybackPeriod * 10 ) / 10;
				document.getElementById("total_energy_throughput").innerHTML = numberWithCommas(Math.round(totalEnergyThroughput));
				//document.getElementById("month_highest_saving").innerHTML = monthWithHighestAbsoluteSaving;
				//document.getElementById("month_highest_per_saving").innerHTML = monthWithHighestPercentageSaving;
				//document.getElementById("month_highest_battery").innerHTML = monthWithHighestBatteryThroughput;
			}
		}
	}
	req.send(null);
}

function getData(monthInput) {
    var req = null;
    if (window.XMLHttpRequest) { req = new XMLHttpRequest(); }
    else { req = new ActiveXObject("Microsoft.XMLHTTP"); }
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResults&username=" + username + "&datatype=savings&month=" + monthInput + "&emsResultID=" + emsResultID, true);
    req.onreadystatechange = function() {
        if (req.readyState === 4) {
            if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				var jData = JSON.parse(data);
				
				var chartData = [];
				for (var i = 0; i < jData.EMSResultsAllMonths.length; i++) {
					var monthlyJson = jData.EMSResultsAllMonths[i];
					//console.log(monthlyJson);
					//var total = Number(round2Fixed(monthlyJson.maxSavings + monthlyJson.partialSavings + monthlyJson.anytimeSavings));
					var totalSaving = Number(round2Fixed(monthlyJson.totalSaving));
					chartData.push(totalSaving);
					dataPlot(i+1, monthlyJson);
				}
				showMonthlySavingBarChart(chartData);
            }
		}
    }
    req.send(null);
}

function dataPlot(monthNum, jData, totalSaving) {
	
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
    
//    document.getElementById("base_anytime" + monthNum).innerHTML = round2Fixed(jData.basecase_kW_anytime);
//    document.getElementById("base_partial" + monthNum).innerHTML = round2Fixed(jData.basecase_kW_partial);
//    document.getElementById("base_peak" + monthNum).innerHTML = round2Fixed(jData.basecase_kW_peak);
//    document.getElementById("ems_anytime" + monthNum).innerHTML = round2Fixed(jData.ems_kW_anytime);
//    document.getElementById("ems_partial" + monthNum).innerHTML = round2Fixed(jData.ems_kW_partial);
//    document.getElementById("ems_peak" + monthNum).innerHTML = round2Fixed(jData.ems_kW_peak);
//    document.getElementById("saving_anytime" + monthNum).innerHTML = round2Fixed(jData.anytimeSavings);
//    document.getElementById("saving_partial" + monthNum).innerHTML = round2Fixed(jData.partialSavings);
//    document.getElementById("saving_peak" + monthNum).innerHTML = round2Fixed(jData.maxSavings);
    document.getElementById("monthly_basecost" + monthNum).innerHTML = round2Fixed(jData.totalBasecost);
    document.getElementById("monthly_ems_cost" + monthNum).innerHTML = round2Fixed(jData.totalEMSCost);
    document.getElementById("monthly_ems_saving" + monthNum).innerHTML = round2Fixed(jData.totalSaving);
    document.getElementById("year" + monthNum).innerHTML = jData.year;

	showLineGraph(jData.year, monthNum, jData.quarterHourPVData, jData.quarterHourLoadData, jData.quarterHourGridData);
	
	showBestDayLineGraph(jData.year, monthNum, jData.quarterHourPVData, jData.quarterHourLoadData, jData.quarterHourGridData);
	
	showSOCGraph(jData.year, monthNum, jData.quarterHourSOCData);
	
	dynamicPeakLoad(monthNum, jData.quarterHourLoadData, jData.quarterHourGridData, jData.quarterHourPVData);
	
	//showStackedBar(monthNum, jData);
	showSavingPieChart(monthNum, jData.totalSaving);
	
	showDCRates(monthNum, jData.currentMonthDCRate.AnyTimeDCRate, jData.currentMonthDCRate.PartialPeakTimeDCRate, jData.currentMonthDCRate.PeakTimeDCRate);
}

function showMonthlySavingBarChart (chartData) {
	
    var xAxis = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
	
	var chart = new Highcharts.chart('monthlySavings', {
	    chart: {
	    	backgroundColor: null,
	        type: 'column'
	    },
	    title: {
	        text: '<b>Annual Monthly Saving Summary</b>'
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
	        title: { text: 'SAVING ($)' }
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
	        name: 'Saving',
	        data: chartData
	    }]
	});
}

function showLineGraph(year, month, pvData, loadData, gridData) {
	
	var id = 'LoadGridPowerTrend' + month;
	
	var netDemand = [];
	for (var i = 0; i < loadData.length; i ++) {
		netDemand.push(loadData[i] - pvData[i]);		
	}
	
	var adjust = 0;
	var chart = new Highcharts.chart(id, {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Net Demand</b>',
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
                text: '<b>NET DEMAND</b>'
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
            area: {
                stacking: 'normal',
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
                enabled: true,
                symbol: 'circle',
                radius: 0
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
        }]
    });
}

function showBestDayLineGraph(year, month, pvData, loadData, gridData) {
	
	var id = 'BestDayTrend' + month;
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
            text: '<b>Net Demand</b>',
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
                text: '<b>NET DEMAND of BEST SAVING DAY</b>'
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
                for (var index = 0; index < monthlyData.length; index += 1) {
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
            text: '<b>DSS State of Charge</b>',
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
                text: '<b>DSS STATE of CHARGE</b>'
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
}

function dynamicPeakLoad(month, loadData, gridData, pvData) {
	
	var id = '#peak_load' + month;
	
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
    

	$(function() {
        $(id).highcharts({
            chart: {
                type: 'column',
                backgroundColor: null,
                events: {
                    load: function() {
                    	var series0 = this.series[0];
                        series0.setData([maxValue1, maxValue2]);
                    }
                }
            },
            title: {
                text: '<b>Peak Net Load</b>',
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
                    text: '<b>PEAK NET LOAD (kW)</b>'
                }
            },
            plotOptions: {
            	column: {
                    dataLabels: {
                        enabled: true
                    },
                    enableMouseTracking: false
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
	
    if (minute < 10)
    	minute = "0" + minute;
    
    var dispTime = month + "/" + day + " " + hour + ":" + minute;
    var peakTimeID = "peak_time" + month;
    document.getElementById(peakTimeID).innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Peak Time at " + dispTime;
    document.getElementById("peak_datetime" + month).innerHTML = dispTime;
}

function showStackedBar(month, jData) {
	
	var id = '#SavingStackedBar' + month;
	var total = Number(round2Fixed(jData.maxSavings + jData.partialSavings + jData.anytimeSavings));
	
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
                    format: 'Total: $' + total,
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
                    pointWidth: 95,
                    dataLabels: {
                    	x: 105,
                        align: 'left',
                        enabled: false,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
                    }
                    //enableMouseTracking: false
                }
            },
            series: [{
                name: 'Max Peak',
                data: [Number(round2Fixed(jData.maxSavings))],
                dataLabels: {
                	x: 92,
                    align: 'left',
                    enabled: true,
                    format: 'Max Peak:<br>$' + Number(round2Fixed(jData.maxSavings)),
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'blue'
                }
            },{
                name: 'Partial',
                data: [Number(round2Fixed(jData.partialSavings))],
                dataLabels: {
                	x: -92,
                    align: 'right',
                    enabled: true,
                    format: 'Partial:<br>$' + Number(round2Fixed(jData.partialSavings)),
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'black'
                }
            },{
                name: 'Anytime',
                data: [Number(round2Fixed(jData.anytimeSavings))],
                dataLabels: {
                	x: 92,
                    align: 'left',
                    enabled: true,
                    format: 'Anytime:<br>$' + Number(round2Fixed(jData.anytimeSavings)),
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'green'
                }
            }]
        });
    });
}

function showSavingPieChart(month, monthlyTotalSaving) {
	
	//console.log(monthlyTotalSaving + ", " + annualTotalSaving)
	
	var id = 'savingPieChart' + month;
	
	Highcharts.chart(id, {
	    chart: {
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

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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
