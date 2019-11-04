<!DOCTYPE html>
<html lang="en">
<head>
<title>NEC EMS Simulation App</title>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=7" />
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<link rel="stylesheet" href="../css/MyStyleSheet.css">
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<script src="https://netdna.bootstrapcdn.com/twitter-bootstrap/2.0.4/js/bootstrap-dropdown.js"></script>

<!-- Custom CSS -->
<link href="../css/half-slider.css" rel="stylesheet">
<link href="../css/login.css" rel="stylesheet">
<link href="../css/jquery-ui.css" rel="stylesheet" />
<link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="../css/necui.css" rel="stylesheet" />

<script src="../js/jquery-1.11.3.js"></script>
<script src="../js/jquery-ui.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/layout.js"></script>
<script src="../js/necui.js"></script>
<script src="../js/necui_charts.js"></script>

</head>

<%@page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" session="true"%>

<!-- Login Credential Part -->
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
	<font size="4">Incorrect Password!! </font>
	<br>
	<br>
	<font size="4">Back to </font>
	<button type="button" onclick="location.href='../LoginForm.jsp'">
		<font size="3">EMS Login Page</font>
	</button>
</body>

<%
	return;
	}
%>
<!---------- Login Credential End ---------->


<%
	//OperationsEngineMainModule oem = OperationsEngineMainModule.getInstance();
%>

<script>
	var username = '<%=(String) session.getAttribute("username")%>';
	var password = '<%=(String) session.getAttribute("password")%>';
	var ipAddress = '{{ ipAddress }}';
</script>

<body class="bg_body"> <!-- background="../image/NEC_Bat.png">  --> 
	<!--header information -->
	<div class="container" id="navmain" >
		<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<a class="navbar-brand active"
						href="/EMSOperationsEngine/LoginForm.jsp"><i
						class="fa fa-plug"></i> NEC EMS BTM Application</a>
				</div>
				<!-- Insert loggedinnavbar.jsp -->
				<ul class="nav navbar-nav" style="float: none !Important;">
					<li><a href="NECEMS_Main.jsp"><font size="4" color="white"><span class="glyphicon glyphicon-cog"></span>Input</font></a></li>
					<li><a href="SizingAnalysis.jsp"><font size="4"><span class="fa fa-database"></span>Sizing Analysis</font></a></li>
					<li><a href="LogPage.jsp"><font size="4"><span class="fa fa-bar-chart"></span>Output</font></a></li>
					<li><a href="FAQ.jsp"><font size="4"><i
								class="fa fa-question-circle"></i>FAQ</font></a></li>
					<li style="float: right; margin-right: 5%"><a
						href="/EMSOperationsEngine/LoginForm.jsp"><font size="4"><span
								class="glyphicon glyphicon-home"></span> Logout</font></a></li>
				</ul>
			</div>
		</nav>
	</div>

	<br>
	<br>
	<br>
	<br>

	<div class="container" id="parentTab" style="width: 90%;">
		<div id="username"></div>

		<div class="section-container">
			<h3 class="section-title" style="margin-top: 0;">
				<span class="label"> System Configuration</span>
			</h3>

			<table style="width: 97%;">
				<tr>
					<td style="width: 80%; vertical-align: top;">
						<h3>
							<b> &nbsp;&nbsp; Battery Setting </b>
						</h3> &nbsp;&nbsp; * Select one or more battery used in simulation
						<form action="form_action.asp">
							<div style="padding: 20px 15px;"
								class="left-battConfig-container"></div>
						</form>
					</td>
					<td style="width: 20%; vertical-align: bottom;">
						<div style="display: block; width: 100%; text-align: left;">
							<button type="button" class="button button4"
								onclick="selectAll('battery');">Select All</button>
							<button type="button" class="button button4"
								onclick="deselectAll('battery');">Deselect All</button>
						</div>
						<table style="position: relative; width: 100%;">
							<tr>
								<td style="width: 140px; text-align: left;">
									<p>kWh size:</p>
								</td>
								<td style="text-align: left;"><input style="width: 60px;"
									class="addNewBattConfig" type="text" id="newkWh"
									name="kWh size" value="80" onchange="posvaluecheck(this);">
								</td>
							</tr>
							<tr>
								<td>
									<p>kW size:</p>
								</td>
								<td><input style="width: 60px;" class="addNewBattConfig"
									type="text" id="newkW" value="50" name="kW size"
									onchange="posvaluecheck(this);"></td>
							</tr>
							<tr>
								<td>
									<p>Battery price ($):</p>
								</td>
								<td>
									<input style="width: 60px;" class="addNewBattConfig"
									type="text" id="newPrice" name="Battery price" value="50000"
									onchange="posvaluecheck(this);">
								</td>
							</tr>
							<tr>
								<td colspan="2" style="text-align: left;">
									<button type="button" class="button button2"
										onclick="addNewBattConfig('battery');">Add New Battery Configuration</button>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
			<div style="position: relative; border: 1px solid #aaa; padding: 5px 20px; margin-top: 40px; width: 94%; margin-left: 1.5%;">
				<label style="position: absolute; display: block; top: -13px; left: 40px; background: #ccc; padding: 3px 10px">
					<input type="checkbox" name="advancedSettings" value="" onclick="advancedSettings(this)">
						&nbsp; Advanced Battery Settings
				</label>
				<br>
				<table id="advancedBatterySettingTable" class="sel"
					style="display: none">
					<tr style="display: none;">
						<td>
							<p>Load Name:</p>
						</td>
						<!-- theater/SDGE_AL -->
						<td><input type="text" id="loadName" value="site1"></td>
						<td>
							<p>Tariff Name:</p>
						</td>
						<td><input type="text" id="tariffName" value="E20S">
						</td>
					</tr>
					<tr style="display: none;">
						<td>
							<p>Start Year:</p>
						</td>
						<td><input type="text" id="startYear" value="2014"
							onchange="posvaluecheck(this);"></td>
						<td>
							<p>Start Month:</p>
						</td>
						<td><input type="text" id="startMonth" value="1"
							onchange="posvaluecheck(this);"></td>
					</tr>
					<tr>
						<td style="text-align: right;">
							<p>Minimum Battery SOC (%):</p>
						</td>
						<td><input class="advSettings" type="text" id="battMinSOC"
							value="0" onchange="SoCCheck(this);" disabled>
							<div class="help-button" value="Minimum battery state of charge">?</div>
						</td>
						<td style="text-align: right;">
							<p>Maximum Battery SOC (%):</p>
						</td>
						<td><input class="advSettings" type="text" id="battMaxSOC"
							value="100" onchange="SoCCheck(this);" disabled>
							<div class="help-button" value="Highest battery state of charge">?</div>
						</td>
					</tr>
					<tr>
						<td style="text-align: right;">
							<p>Battery Round-Trip Efficiency (%):</p>
						</td>
						<td><input class="advSettings" type="text" id="roundTripEff"
							value="98" onchange="roundTripEffCheck(this);" disabled>
							<div class="help-button" value="Battery Round-Trip Efficiency ">?</div>
						</td>
						<td style="text-align: right;">
							<p>Battery Aging Cost ($/kWh throughput):</p>
						</td>
						<td><input class="advSettings" type="text" id="battDeg"
							value="0" onchange="posvaluecheck(this);" disabled>
							<div class="help-button" value="Battery Aging Cost">?</div></td>
					</tr>
					<tr style="display:none">
						<td style="text-align: right;">
							<p>Battery Initial SOC (%):</p>
						</td>
						<td><input class="advSettings" type="text" id="battInitSOC"
							value="100" onchange="SoCCheck(this);" disabled>
							<div class="help-button"
								value="Initial battery state of charge at the beginning of each month">?</div>
						</td>
					</tr>
					<tr>
						<td style="text-align: right;">
							<p>Battery Reserve Capacity (%):</p>
						</td>
						<td><input class="advSettings" type="text" id="battResCap"
							value="15" onchange="" disabled>
							<div class="help-button"
								value="Percentage of battery energy capacity used for handling load uncertainty (Please refer to design document for further details) <br/><br/> For Sensitivity Analysis, you can specify a range with this format: begin:step:end (e.g., 0:10:90)">?</div>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr style="display:none">
						<td style="text-align: right;">
							<p>DCT Reduction (%):</p>
						</td>
						<td><input class="advSettings" type="text" id="DCTAdjusRatio"
							value="10" onchange="" disabled>
							<div class="help-button"
								value="Higher numbers result in lower demand charge thresholds (DCTs). Maximum daily DCTs are reduced by this percentage of DCT range (difference between daily maximum and minimum DCTs) and then used as monthly DCT in the daily layer (Please refer to design document for further details)  <br/><br/> For Sensitivity Analysis, you can specify a range with this format: begin:step:end (e.g., -100:10:100). Negative values mean increase in DCT and vice versa.">?</div>
						</td>
						<td style="text-align: right;">
							<p>No. of days from past for DCT calculation:</p>
						</td>
						<td><input class="advSettings" type="text" id="DCTHorizon"
							value="15" onchange="" disabled>
							<div class="help-button"
								value="Number of days in each month to be used for DCT calculations (Please refer to design document for further details) <br/><br/> For Tuning Parameters, you can specify a range with this format: begin:step:end (e.g., 1:5:31)">?</div>
						</td>
					</tr>
				</table>
				<!-- Turning parameters: BRC 5:10:95. DCT Reduction: -100:10:100, # of Days 5:5:30 -->
			</div>
			
			<br>
			<hr>
			
			<h3>
				<b> &nbsp;&nbsp; Tariff Setting</b>
			</h3>
			<table id="tariff-list" style="width: 97%;">
				<tr>
					<td style="vertical-align: top;">
						&nbsp;&nbsp; * Select one or more tariff(s) that will be used in simulation
						<form action="form_action.asp"
							style="position: relative; left: 20px; width: 100%;">
							<div style="padding: 20px 15px;" class="tariff-setting"></div>
						</form>
					</td>
				</tr>
				<tr>
					<td>
						<div style="display:block; width:500px; height:40px; text-align:center; margin-left:30%;">
							<button type="button" class="button button4" onclick="selectAll('tariff')">Select All</button>
							<button type="button" class="button button4" onclick="deselectAll('tariff')">Deselect All</button>
							<button type="button" class="button button2" data-toggle="modal"
								data-target="#importRawTariffData">&nbsp;&nbsp;Import New Tariff Data&nbsp;&nbsp;</button>
						</div>
					</td>
				</tr>
			</table>

			<div id="isDCContractBased" style="display:none; position: relative; border: 1px solid #aaa; padding: 5px 20px; margin-top: 40px; width: 94%; margin-left: 1.5%;">
				<label style="position: absolute; display: block; top: -13px; left: 40px; background: #ccc; padding: 3px 10px">
					<input type="checkbox" id="is_dc_based_on_apac_rates" value="" onclick="isDCBasedOnAPACRates(this)">
						&nbsp; Is Demand Charge Contract-Based?
				</label> <br>
				<table id="dcContractTable" class="sel" style="display: none">
					<tr>
						<td style="text-align: right;  width:400px">
							<p>Number Of Months for Contract Calculation:</p>
						</td>
						<td>&nbsp;&nbsp;
							<input class="apacSettings" type="text" id="number_of_months_for_contract_calculation"
								name="Number Of Months for Contract Calculation" value="12" onchange="posvaluecheck(this);" disabled>
							<div class="help-button" value="Number of months that EMS checks to pick up the maximum demand peak">?</div>
						</td>
						<td style="text-align:right; width:400px">
							<p>DC Rate for Contract Electricity (USD/kW):</p>
						</td>
						<td>&nbsp;&nbsp;<input class="apacSettings" type="text" id="dc_rate_apac"
							name="DC Rate APAC" value="16.84" onchange="posvaluecheck(this);" disabled>
							<div class="help-button" value="Please convert the rate into USD">?</div>
						</td>
					</tr>
					<tr style="display: none">
						<td style="text-align: right;">
							<p>Contract Electricity with Storage (kW):</p>
						</td>
						<td>&nbsp;&nbsp;
							<input class="apacSettings" type="text" id="storage_contract" name="Contract Electricity with Storage"
							value="0" onchange="posvaluecheck(this);" disabled>
							<div class="help-button" value="Threshold used in simulation to curtail peaks over this value">?</div>
						</td>
						<td style="text-align: right;">
							<p>Contract Electricity without Storage (kW):</p>
						</td>
						<td>&nbsp;&nbsp;
							<input class="apacSettings" type="text" id="no_storage_contract" name="Contract Electricity without Storage" value="0" onchange="posvaluecheck(this);" disabled>
							<div class="help-button" value="Max demand if battery is not used">?</div>
						</td>
					</tr>
				</table>
			</div>
			<br>

			<hr>
			
			<h3> <b> &nbsp;&nbsp; Load Setting </b> </h3>
			&nbsp;&nbsp; * Select one or more load(s) that will be used in simulation
			<table>
				<tr>
					<td style="vertical-align: top;">
						<form action="form_action.asp"
							style="position: relative; left: 20px; width: 100%;">
							<div style="padding: 20px 15px;" class="load-setting"></div>
						</form>
					</td>
				</tr>
				<tr>
					<td>
						<div style="text-align: center; clear: both;">
							<div style="display: block; width: 550px; height: 40px; text-align: center; margin-bottom: 1%; margin-left: 40%;">
								<button type="button" class="button button4" onclick="selectAll('load')">Select All</button>
								<button type="button" class="button button4" onclick="deselectAll('load')">Deselect All</button>
								<button type="button" class="button button2" data-toggle="modal"
									data-target="#importRawData">&nbsp;&nbsp;Import New Load Data&nbsp;&nbsp;</button>
								&nbsp;&nbsp;<input type="checkbox" id="is_load_var_enabled" value="">&nbsp; <b>Sensitivity Analysis</b>
							</div>
						</div>
					</td>
				</tr>
			</table>

			<hr>
			<br>

			<h3 style="display:inline"> <b> &nbsp;&nbsp; PV Profile Selection </b> </h3>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			<input type="checkbox" id="is_pv_used" value="" onclick="isPVUsed(this)">&nbsp;
			Select PV option and profile 

			<div id="pvTable" style="display: none">
				<br><br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				<input type="checkbox" id="is_pv_util_enabled" value="">&nbsp;
				Enable PV Utilization Mode
			
				<table style="width: 97%;">
					<tr>
						<td style="width: 80%; vertical-align: top;">
							<form action="form_action.asp">
								<div style="padding: 20px 15px;" class="pvConfig-container"></div>
							</form>
						</td>
					</tr>
					<tr>
						<td>
							<div style="text-align: center; clear: both;">
								<div style="display: block; width: 600px; height: 8px; text-align: center; margin-bottom: 3%; margin-left: 30%;">
									<button type="button" class="button button4" onclick="selectAll('pv');">Select All</button>
									<button type="button" class="button button4" onclick="deselectAll('pv');">Deselect All</button>
									&nbsp;&nbsp; PV Scaling Factor: <input style="width: 60px;" class="pvCapacityClass" type="text" id="pvCapacity" name="PV Capacity" value="1" onchange="posvaluecheck(this);">
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div style="text-align: center; clear: both;">
								<div style="display: block; width: 600px; height: 8px; text-align: center; margin-bottom: 1%; margin-left: 30%;">
									<button type="button" class="button button2" data-toggle="modal" data-target="#importRawPVData">&nbsp;&nbsp;Import New PV Data with CSV File&nbsp;&nbsp;</button>
									<button type="button" class="button button2" data-toggle="modal" data-target="#importPVWattsPVData">&nbsp;&nbsp;Import New PV Data with PVWatts&nbsp;&nbsp;</button>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<!-- 	
			<br>
			<br>
			<hr>

			<h3> <b> &nbsp;&nbsp; Demand Response Setting </b> </h3>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			<input type="checkbox" id="is_dr_used" value="" onclick="isDRUsed(this)">&nbsp;
			PG&E Peak Day Pricing (PDP) Demand Response (Non-PV customers only)
			<!-- 
			<div id="drTable" style="display: none">
				<table style="width: 97%;">
					<tr>
						<td style="width: 80%; vertical-align: top;">
							<form action="form_action.asp">
								<div style="padding: 20px 15px;" class="pvConfig-container"></div>
							</form>
						</td>
					</tr>
					<tr>
						<td>
							<div style="text-align: center; clear: both;">
								<div style="display: block; width: 600px; height: 8px; text-align: center; margin-bottom: 3%; margin-left: 30%;">
									<button type="button" class="button button4" onclick="selectAll('pv');">Select All</button>
									<button type="button" class="button button4" onclick="deselectAll('pv');">Deselect All</button>
									&nbsp;&nbsp; PV Scaling Factor: <input style="width: 60px;" class="pvCapacityClass" type="text" id="pvCapacity" name="PV Capacity" value="1" onchange="posvaluecheck(this);">
								</div>
							</div>
						</td>
					</tr>

					<tr>
						<td>
							<div style="text-align: center; clear: both;">
								<div style="display: block; width: 600px; height: 8px; text-align: center; margin-bottom: 1%; margin-left: 30%;">
									<button type="button" class="button button2" data-toggle="modal" data-target="#importRawPVData">&nbsp;&nbsp;Import New PV Data with CSV File&nbsp;&nbsp;</button>
									<button type="button" class="button button2" data-toggle="modal" data-target="#importPVWattsPVData">&nbsp;&nbsp;Import New PV Data with PVWatts&nbsp;&nbsp;</button>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
	-->		
			<br> <br> 
			<hr>
			<br>

			<div>
				<h3 style="display:inline"> <b> &nbsp;&nbsp; Life Time Analysis </b> </h3> 
				&nbsp;&nbsp;&nbsp;&nbsp; (Life time assumed to be 10 years) <br><br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				<input type="checkbox" id="is_blife_analysis_enabled" value="">&nbsp;
				Check if you want to analyze the selected battery life. Only select one battery, tariff, load profile, and/or PV profile. 			
				<br> <br>
				
				<!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
				<select id="blife_analysis_option" style="height:30px; display:none;">
					<option value="warranty_fading_models">Both Warranty and Capacity Fading Estimation</option>
					<option value="warranty_model">Warranty-Based Estimation</option>
					<option value="fading_model">Capacity Fading Estimation</option>
				</select>
				
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				Increase the load by <input style="width: 60px;" type="text" id="loadIncrease" value="0.0" onchange="posvaluecheck(this);">% every year.
				<br>
				<br>
				<hr>
			</div>
			
			<div>
				<h3> <b> &nbsp;&nbsp; TOU Management Setting </b> </h3>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				<input type="checkbox" id="is_tou_enabled" value="">&nbsp;
				Check if you want to activate TOU management. 
				<br> <br>
				<hr>
			</div>
			

			<div style="position: relative; border: 1px solid #aaa; padding: 5px 20px; margin-top: 30px; width: 94%; margin-left: 1.5%;">
				<label
					style="position: absolute; display: block; top: -13px; left: 40px; background: #ccc; padding: 3px 10px">
					&nbsp; Select to download load and tariff (Optional) </label> <br>
				<table>
					<tr>
						<td><b>Choose a load to download:</b>&nbsp;</td>
						<td height="50px"><div id="load-select-insert"></div></td>
						<td style="width: 10px"></td>
						<td>
							<form method="get" action="/EMSOperationsEngine/btmEMS.do">
								<input type="hidden" id="domain" value="DownloadResult"
									name="domain"> <input type="hidden" id="uname" value=""
									name="uname"> <input type="hidden"
									id="download-loadname" value="" name="loadname"> <input
									class="form-control" type="submit" value="download">
							</form>
						</td>
						<td style="width: 80px"></td>
						<td align="right"><b>Choose a tariff to download:</b>&nbsp;</td>
						<td><div id="tariff-select-insert"></div></td>
						<td style="width: 10px"></td>
						<td>
							<form method="get" action="/EMSOperationsEngine/btmEMS.do">
								<input type="hidden" id="domain" value="DownloadResult"
									name="domain"> <input type="hidden" id="uname1"
									value="" name="uname"> <input type="hidden"
									id="download-tariffname" value="" name="tariffname"> <input
									class="form-control" type="submit" value="download">
							</form>
						</td>
					</tr>
				</table>
			</div>
			<br>
		</div>

		<!--
		<div class="section-container">
			<h3 class="section-title" style="margin-top: 0;">
				<span class="label">Optional: Download Load or Tariff</span>
			</h3>
			<div class="btn-special">
				<table>
					<tr>
						<td><b>Choose a load to download:</b>&nbsp;</td>
						<td width="250" height="50"><div id="load-select-insert"></div>
						</td>
						<td>
							<form method="get" action="/EMSOperationsEngine/btmEMS.do">
								<input type="hidden" id="domain" value="DownloadResult"
									name="domain"> <input type="hidden" id="uname" value=""
									name="uname"> <input type="hidden"
									id="download-loadname" value="" name="loadname"> <input
									class="form-control" type="submit" value="download">
							</form>
						</td>
					</tr>
					<tr>
						<td><b>Choose a tariff to download:</b>&nbsp;</td>
						<td width="250"><div id="tariff-select-insert"></div></td>
						<td>
							<form method="get" action="/EMSOperationsEngine/btmEMS.do">
								<input type="hidden" id="domain" value="DownloadResult"
									name="domain"> <input type="hidden" id="uname1"
									value="" name="uname"> <input type="hidden"
									id="download-tariffname" value="" name="tariffname"> <input
									class="form-control" type="submit" value="download">
							</form>
						</td>
					</tr>
				</table>
			</div>
		</div>
		-->

		<!-- Invisible to User-->
		<div class="section-container" style="display: none;">
			<!-- <h3><span class="label label-success">Step 2: Uploading Input Files </span></h3> -->
			<h3 class="section-title" style="margin-top: 0;">
				<span class="label">Simulation Configuration for Battery</span>
			</h3>
			<table class="sel" style="display:none;">
				<tr style="height: 20px;">
					<td>&nbsp;</td>
				</tr>
				<tr rowspan="2" style="margin-bottom: 20px;">
					<td colspan="2" valign="top"
						style="padding-bottom: 1em; padding-left: 1em;"><label
						class="help-button-small"
						value="Only check if you need minute-by-minute simulation results (Large data is generated!)"><input
							id="saveEMSresults" type="checkbox" name="simulationConfig1"
							value="saveEMSresults" checked>&nbsp; Save EMS detailed
							results in Daily Layer</label><br></td>
				</tr>
			</table>
		</div>
		<!-- Invisible Part End -->

		<br>
		<div class="row clearfix" style="margin-left: 10px;">
			<button id="runSimulation" type="button" class="btn2 btn-default"
				onclick="RunFileJson(0);">
				Run EMS<img id="EMSRunSpin2" src="../image/spin.gif" height="20"
					width="20" style="margin-left: 10px;" />
			</button>
			&nbsp;
			<button id="StopRun" type="button" class="btn2 btn-default"
				onclick="terminateEMS();">Stop Run
			</button>
			&nbsp;
			<button id="AddRun" type="button" class="btn2 btn-default"
				onclick="RunFileJson(1);">Add Run
			</button>
		</div>

		<div class="section-container">
			<h3 class="section-title" style="margin-top: 0;">
				<span class="label">EMS Simulation Status Log</span>
			</h3>
			<div class="btn-special">
				<table>
					<tbody>
						<tr>
							<td>Simulation Start Time:</td>
							<td style="width: 200px;">
								<div id=simStartTime></div>
							</td>
							<td rowspan="2" style="width: 500px;">
								<b>- EMS Simulation Overall Progress</b>
								<div id="myProgress">
									<div id="myBar">0%</div>
								</div>
							</td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td>Simulation Complete Time: &nbsp;</td>
							<td>
								<div id=simEndTime></div>
							</td>
							<td>Number of Requests in Simulation Queue:&nbsp;</td>
							<td><span id="numOfRequests"></span> </td>
						</tr>
					</tbody>
				</table>
				<br> * Combination of Battery Sizes, Loads, Tariff, and PV for simulation
				<div
					style="top: 0; left: 0; height: 30px; width: 100%; background: #ccc; z-index: 9999; color: white; padding: 7px; padding-top: 7px;">
					<table width="100%">
						<tbody>
							<tr>
								<td width="55%">&nbsp;&nbsp;Battery Size [Load, Tariff, PV (Scaling Factor, PV Util enabled?), LifeTime Analyzed?, Load Plus %]</td>
								<td width="15%">Start Time</td>
								<td width="15%">Completion Time</td>
								<td width="15%">Interrupted</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div
					style="position: relative; padding: 10px 15px; width: 100%; height: 250px; overflow-y: scroll; overflow-x: hidden; border: 1px solid #ccc;">
					<div class="status-log-setting"></div>
				</div>
			</div>
		</div>
		<br>

		<div>
			
				<button id="delete_account" type="button" onclick="deleteUserAccount();">
					Delete User Account</font></a>
			
		</div>

	</div>

	<!-- ********** Invisible to User ********** -->
	<div id=tabs-2 style="display: none">
		<p align='right'>
			<a href="/EMSOperationsEngine/LoginForm.jsp"><button>Logout</button></a>
		</p>
		<h2>EMS Output</h2>

		<div class="section-container">
			<h3 class="section-title" style="margin-top: 0;">
				<span class="label">Show Results</span>
			</h3>
			<div class="btn-special">
				<h3>Battery View</h3>
				<hr>
				<p>Choose Category, Load Name, and Tariff Name from the
					following menus.</p>
				<form name="myform" method="POST">
					<table>
						<tr>
							<td>
								<!-- <select id="category-select" name="parentDDM" onchange="getDDMvals()"> </select>  -->
							<td>
								<div id="category-option"></div>
							</td>
							<td><select id="load-select" name="dropDownItems1"
								onchange="getDDMvals2()"></select></td>
							<td><select id="tariff-select" name="dropDownItems2"></select></td>
						</tr>
					</table>
				</form>
				<button id="resDisplay" type="button" class="btn2"
					onclick="graphicsPlot()">Display</button>
				<button type="button" class="btn2" onclick="PlotReset()">Reset</button>
				<br>
				<h3 id="ErrNote1"></h3>
				<div id="batSetting1"></div>
				<table class="sel">
					<tr>
						<td class="sel"><div id="costNotes"></div>
						<td>
					</tr>
					<tr>
						<td class="sel"><div id="costPlot"></div>
						<td>
					</tr>
					<tr>
						<td class="sel"><div id="costPredictionSavingPlot"></div>
						<td>
					</tr>
					<tr>
						<td class="sel"><div id="totalPowerPlot"></div>
						<td>
					</tr>
					<tr>
						<td class="sel"><div id="cycleSavings"></div>
						<td>
					</tr>
				</table>
				<h3>Load View</h3>
				<hr>
				<div id="costFlotB"></div>
				<p>Choose Category, Battery Size, and Tariff Name from the
					following menus.</p>
				<form name="myform2" method="POST">
					<!-- <select id="category-select2" name="parentDDM2" onchange="getDDMvals3()"><option></option></select> -->
					<table>
						<tr>
							<td>
								<div id="category-option2"></div>
							</td>
							<td><select id="battery-select" name="batteryDropDownItems"
								onchange="getDDMvals4()"></select></td>
							<td><select id="tariff-select2" name="tariffDropDownItems"></select>
							</td>
						</tr>
					</table>
				</form>
				<button id="resDisplay2" type="button" class="btn2"
					onclick="graphicsPlot2()">Display</button>
				<button type="button" class="btn2" onclick="PlotReset2()">Reset</button>
				<br>
				<h3 id="ErrNote"></h3>
				<div id="batSetting2"></div>
				<table class="sel">
					<tr>
						<td class="sel">
							<div id="costPercentagePlotBattery"></div>
						<td>
					</tr>
					<tr>
						<td class="sel">
							<div id="costPredictionSavingPlot2"></div>
						<td>
					</tr>
					<tr>
						<td class="sel">
							<div id="totalPowerPlot2"></div>
						<td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	<!-- ********** Invisible to User End ********** -->
	<!-- </div> -->

	<footer>
		<div class="footer">
			<h5>
				<img style="vertical-align: middle" src="../image/NECLA_logo.jpg"
					alt="NEC Labs Logo" height="72" /> <span><a
					href="http://www.nec-labs.com/research-departments/energy-management/energy-management-home">Energy
						Management Department, NEC Labs America</a> </span>
			</h5>
		</div>
	</footer>

	<!-- Modal to show the Tuning Study results -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel"
		style="width: 85% !important; margin-left: 7.5% !important;">
		<!-- <div class="modal-dialog" role="document"> -->
		<div class="modal-content">
			<div class="modal-header text-center">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title" id="myModalLabel">
					<strong>Results of Tuning Parameters Study</strong>
				</h3>
				<h5 class="modal-subtitle"></h5>
			</div>
			<div class="modal-body">...</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
		<!--      </div> -->
	</div>

	<!-- Modal to import raw load data -->
	<div class="modal fade" id="importRawData" tabindex="-1" role="dialog"
		aria-labelledby="importRawDataLabel"
		style="width: 50% !important; margin-left: 25% !important;">
		<div class="modal-content">
			<div class="modal-header text-center">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title" id="importRawDataLabel">
					<strong>Import New Load Data</strong>
				</h3>
				<h5 class="modal-subtitle" style="color: #C31E24;">Please note
					that the data file should be in CSV format with one column with 12
					months of load data in kW</h5>

				<table align="center">
					<tbody>
						<tr height="40px">
							<td align="right"><label for="importLoadName">Load
									Name: &nbsp;&nbsp;</label></td>
							<td align="left"><input type="text"
								class="import-input-control" id="importLoadName"
								placeholder="Load name ..." value="load_name">
								<div class="help-button"
									value="Enter the name of the load. This name will be shown in the list of load generated above.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><label for="importStartYear">Start
									Year: &nbsp;&nbsp;</label></td>
							<td align="left"><input type="text"
								class="import-input-control" id="importStartYear"
								placeholder="Start year ..." value="2012">
								<div class="help-button"
									value="Enter the start year of the load data as YYYY: e.g., 2012.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><label for="importStartMonth">Start
									Month:&nbsp;&nbsp;</label></td>
							<td align="left"><input type="text"
								class="import-input-control" id="importStartMonth"
								placeholder="Start month ..." value="1">
								<div class="help-button"
									value="Enter the starting month of the load data in numeric format: e.g., January = 1">?</div>
							</td>
						</tr>
						<tr height="40px" style="display:none">
							<td align="right"><label for="importAssiTariff">Assigned
									Tariff:&nbsp;&nbsp;</label></td>
							<td align="left" ><input type="text"
								class="import-input-control" id="importAssiTariff"
								placeholder="Assigned tariff ..." value="E20S">
								<div class="help-button"
									value="Enter the default tariff assigned to the load: e.g., E20S">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><label for="selectInterval">Data
									Interval:&nbsp;&nbsp;</label></td>
							<td align="left"><select id="selectInterval">
									<option value="15">15 Minutes</option>
									<option value="30">30 Minutes</option>
									<option value="60">1 Hour</option>
							</select></td>
						</tr>
						<tr height="40px">
							<td align="right"><label for="importRawLF">Locate Load Profile:&nbsp;&nbsp;</label></td>
							<td align="left"><input class="import-input-control"
								type="file" id="importRawLF" enctype="multipart/form-data">
							</td>
						</tr>
					</tbody>
				</table>

				<div class="import-row">
					<p class="help-block" id="help-block"></p>
				</div>

				<div class="import-row">
					<button onclick="importRawLoadData();" type="button"
						class="btn btn-success"
						style="margin-top: 20px; margin-right: 3px;">Import Data</button>
					<button type="button" class="btn btn-default" data-dismiss="modal"
						style="margin-top: 20px;">Close</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Modal to import raw tariff data -->
	<div class="modal fade" id="importRawTariffData" tabindex="-1"
		role="dialog" aria-labelledby="importRawDataLabel"
		style="width: 50% !important; margin-left: 25% !important;">
		<div class="modal-content">
			<div class="modal-header text-center">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title" id="importRawDataLabel">
					<strong>Import New Tariff Data</strong>
				</h3>
				<table align="center">
					<tr height="40px">
						<td align="right"><b>Tariff Name: &nbsp;&nbsp;</b></td>
						<td align="left"><input type="text"
							class="import-input-control" id="importTariffName"
							value="tariff_name">
							<div class="help-button"
								value="Enter the name of the tariff. This name will be shown in the list of tariff generated above.">?</div>
						</td>
					</tr>
					<tr height="40px">
						<td align="right"><label for="">Summer Months:&nbsp;&nbsp;</label></td>
						<td align="left"><select id="selectSummerType">
								<option value="summer6">May to October (6 months)</option>
								<option value="summer4">June to September (4 months)</option>
								<option value="summer3">July to September (3 months)</option>
						</select></td>
					</tr>
					<!-- 
					<tr height="40px">
						<td align="right"><b>City (Optional): &nbsp;&nbsp;</b></td>
						<td align="left">
							<input type="text" class="import-input-control" id="importLocationCity"
								value="">
							<div class="help-button"
								value="Enter the city name of the tariff used (Optional).">?</div>
						</td>
					</tr>
					<tr height="40px">
						<td align="right"><b>State (Optional): &nbsp;&nbsp;</b></td>
						<td align="left">
							<input type="text" class="import-input-control" id="importLocationState"
								value="">
							<div class="help-button"
								value="Enter the state of the tariff used (Optional).">?</div>
						</td>
					</tr>
					-->
				</table>
				<br>
				<h4>Demand Charge Rates for Spring and Summer</h4>
				<table align="center">
					<tbody>
						<tr>
							<th></th>
							<th>DC Rate ($/kW) &nbsp;&nbsp;</th>
							<th>1st Time Window Start &nbsp;&nbsp;</th>
							<th>1st Time Window End &nbsp;&nbsp;</th>
							<th>2nd Time Window Start &nbsp;&nbsp;</th>
							<th>2nd Time Window End</th>
						</tr>
						<tr height="40px">
							<td align="right"><b>Any (Off-Peak) Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="importAnytimeDCRate" size="5px" value="0.0">
								<div class="help-button" value="Enter the anytime demand charge rate here.">?</div></td>
							<td><input type="text" id="anytimeFirstWindowStart" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div></td>
							<td><input type="text" id="anytimeFirstWindowEnd" size="6px" value="24:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div></td>
							<td><input type="text" id="anytimeSecondWindowStart" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div></td>
							<td><input type="text" id="anytimeSecondWindowEnd" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div></td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Partial Peak Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="importPartialPeakTimeDCRate"
								size="5px" value="0.0">
								<div class="help-button"
									value="Enter the partial peak-time demand charge rate here. Leave it as 0.0 if there is no partial peak-time DC rate.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeFirstWindowStart"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the first partial peak starts. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeFirstWindowEnd"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the first partial peak ends. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeSecondWindowStart"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the second partial peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeSecondWindowEnd"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the second partial peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Peak Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="importPeakTimeDCRate" size="5px" value="0.0">
								<div class="help-button"
									value="Enter the peak-time demand charge rate here. Leave it as 0.0 if there is no peak-time DC rate.">?</div>
							</td>
							<td><input type="text" id="peakTimeFirstWindowStart"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the first peak starts. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td><input type="text" id="peakTimeFirstWindowEnd"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the first peak ends. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td><input type="text" id="peakTimeSecondWindowStart"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the second peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td><input type="text" id="peakTimeSecondWindowEnd"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the second peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
					</tbody>
				</table>
				<br>
				<h4>Demand Charge Rates for Fall and Winter</h4>
				<table align="center">
					<tbody>
						<tr>
							<th></th>
							<th>DC Rate ($/kW) &nbsp;&nbsp;</th>
							<th>1st Time Window Start &nbsp;&nbsp;</th>
							<th>1st Time Window End &nbsp;&nbsp;</th>
							<th>2nd Time Window Start &nbsp;&nbsp;</th>
							<th>2nd Time Window End</th>
						</tr>
						<tr height="40px">
							<td align="right"><b>Any (Off-Peak) Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="importAnytimeDCRateWinter"
								size="5px" value="0.0">
								<div class="help-button"
									value="Enter the anytime demand charge rate here.">?</div></td>
							<td><input type="text" id="anytimeFirstWindowStartWinter"
								size="6px" value="0:00">
								<div class="help-button"
									value="The time window of anytime DC Rate is fixed.">?</div></td>
							<td><input type="text" id="anytimeFirstWindowEndWinter"
								size="6px" value="24:00">
								<div class="help-button"
									value="The time window of anytime DC Rate is fixed.">?</div></td>
							<td><input type="text" id="anytimeSecondWindowStartWinter"
								size="6px" value="0:00">
								<div class="help-button"
									value="The time window of anytime DC Rate is fixed.">?</div></td>
							<td><input type="text" id="anytimeSecondWindowEndWinter"
								size="6px" value="0:00">
								<div class="help-button"
									value="The time window of anytime DC Rate is fixed.">?</div></td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Partial Peak Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="importPartialPeakTimeDCRateWinter" size="5px" value="0.0">
								<div class="help-button" value="Enter the partial peak-time demand charge rate here. Leave it as 0.0 if there is no partial peak-time DC rate.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeFirstWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first partial peak starts. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeFirstWindowEndWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first partial peak ends. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeSecondWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second partial peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td><input type="text" id="partialPeakTimeSecondWindowEndWinter" size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the second partial peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Peak Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="importPeakTimeDCRateWinter"
								size="5px" value="0.0">
								<div class="help-button"
									value="Enter the peak-time demand charge rate here. Leave it as 0.0 if there is no peak-time DC rate.">?</div>
							</td>
							<td><input type="text" id="peakTimeFirstWindowStartWinter"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the first peak starts. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td><input type="text" id="peakTimeFirstWindowEndWinter"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the first peak ends. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td><input type="text" id="peakTimeSecondWindowStartWinter"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the second peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td><input type="text" id="peakTimeSecondWindowEndWinter"
								size="6px" value="0:00">
								<div class="help-button"
									value="Enter what time the second peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
					</tbody>
				</table>
				<br>
				<h4>Upload TOU files (Optional)</h4>
				<h5 class="modal-subtitle" style="color: #C31E24;">Please note
					that each data file should be in one-column CSV format with
					30-minute interval $ values (48 rows)</h5>
				<table align="center">
					<tr height="40px">
						<td align="right"><label for="importRawSummerTOU">Locate
								Spring - Summer TOU Profile:&nbsp;&nbsp;</label></td>
						<td align="left"><input class="import-input-control"
							type="file" id="importRawSummerTOU" enctype="multipart/form-data">
						</td>
					</tr>
					<tr height="40px">
						<td align="right"><label for="importRawWinterTOU">Locate
								Fall - Winder TOU Profile:&nbsp;&nbsp;</label></td>
						<td align="left"><input class="import-input-control"
							type="file" id="importRawWinterTOU" enctype="multipart/form-data">
						</td>
					</tr>
				</table>

				<div class="import-row">
					<p class="help-block" id="help-block-tariff"></p>
				</div>

				<div class="import-row">
					<button onclick="importRawTariffData();" type="button" class="btn btn-success" 
						style="margin-top: 20px; margin-right: 3px;">
						Import Tariff Data</button>
					<button type="button" class="btn btn-default" data-dismiss="modal"
						style="margin-top: 20px;">Close</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal to EDIT raw tariff data -->
	<div class="modal fade" id="editTariffData" tabindex="-1" role="dialog" aria-labelledby="importRawDataLabel" style="width: 50% !important; margin-left: 25% !important;">
		<div class="modal-content">
			<div class="modal-header text-center">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title" id="editRawDataLabel">
					<span id="titleEditTariffData"><strong>Edit Tariff Data</strong></span>
				</h3>
				<div id="editTariffName" style="display:none;"></div>
				<h4>Demand Charge Rates for Spring and Summer</h4>
				<table align="center">
					<tbody>
						<tr>
							<th></th>
							<th>DC Rate ($/kW) &nbsp;&nbsp;</th>
							<th>1st Time Window Start &nbsp;&nbsp;</th>
							<th>1st Time Window End &nbsp;&nbsp;</th>
							<th>2nd Time Window Start &nbsp;&nbsp;</th>
							<th>2nd Time Window End</th>
						</tr>
						<tr height="40px">
							<td align="right"><b>Any (Off-Peak) Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="editAnytimeDCRate" size="5px" value="0.0">
								<div class="help-button" value="Enter the anytime demand charge rate here.">?</div>
							</td>
							<td><input type="text" id="editAnytimeFirstWindowStart" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
							<td><input type="text" id="editAnytimeFirstWindowEnd" size="6px" value="24:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
							<td><input type="text" id="editAnytimeSecondWindowStart" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
							<td><input type="text" id="editAnytimeSecondWindowEnd" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Partial Peak Time: &nbsp;&nbsp;</b></td>
							<td>
								<input type="text" id="editPartialPeakTimeDCRate" size="5px" value="0.0">
								<div class="help-button" value="Enter the partial peak-time demand charge rate here. Leave it as 0.0 if there is no partial peak-time DC rate.">?</div>
							</td>
							<td>
								<input type="text" id="editPartialPeakTimeFirstWindowStart" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first partial peak starts. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td>
								<input type="text" id="editPartialPeakTimeFirstWindowEnd" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first partial peak ends. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td>
								<input type="text" id="editPartialPeakTimeSecondWindowStart" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second partial peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td>
								<input type="text" id="editPartialPeakTimeSecondWindowEnd" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second partial peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Peak Time: &nbsp;&nbsp;</b></td>
							<td>
								<input type="text" id="editPeakTimeDCRate" size="5px" value="0.0">
								<div class="help-button" value="Enter the peak-time demand charge rate here. Leave it as 0.0 if there is no peak-time DC rate.">?</div>
							</td>
							<td>
								<input type="text" id="editPeakTimeFirstWindowStart" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first peak starts. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td>
								<input type="text" id="editPeakTimeFirstWindowEnd" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first peak ends. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td>
								<input type="text" id="editPeakTimeSecondWindowStart" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td>
								<input type="text" id="editPeakTimeSecondWindowEnd" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
					</tbody>
				</table>
				<br>
				<h4>Demand Charge Rates for Fall and Winter</h4>
				<table align="center">
					<tbody>
						<tr>
							<th></th>
							<th>DC Rate ($/kW) &nbsp;&nbsp;</th>
							<th>1st Time Window Start &nbsp;&nbsp;</th>
							<th>1st Time Window End &nbsp;&nbsp;</th>
							<th>2nd Time Window Start &nbsp;&nbsp;</th>
							<th>2nd Time Window End</th>
						</tr>
						<tr height="40px">
							<td align="right"><b>Any (Off-Peak) Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="editAnytimeDCRateWinter" size="5px" value="0.0">
								<div class="help-button" value="Enter the anytime demand charge rate here.">?</div>
							</td>
							<td><input type="text" id="editAnytimeFirstWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
							<td><input type="text" id="editAnytimeFirstWindowEndWinter" size="6px" value="24:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
							<td><input type="text" id="editAnytimeSecondWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
							<td><input type="text" id="editAnytimeSecondWindowEndWinter" size="6px" value="0:00">
								<div class="help-button" value="The time window of anytime DC Rate is fixed.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Partial Peak Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="editPartialPeakTimeDCRateWinter" size="5px" value="0.0">
								<div class="help-button" value="Enter the partial peak-time demand charge rate here. Leave it as 0.0 if there is no partial peak-time DC rate.">?</div>
							</td>
							<td><input type="text" id="editPartialPeakTimeFirstWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first partial peak starts. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td><input type="text" id="editPartialPeakTimeFirstWindowEndWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first partial peak ends. Leave it as 0:00 if there is no partial peak.">?</div>
							</td>
							<td><input type="text" id="editPartialPeakTimeSecondWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second partial peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td><input type="text" id="editPartialPeakTimeSecondWindowEndWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second partial peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Peak Time: &nbsp;&nbsp;</b></td>
							<td><input type="text" id="editPeakTimeDCRateWinter" size="5px" value="0.0">
								<div class="help-button" value="Enter the peak-time demand charge rate here. Leave it as 0.0 if there is no peak-time DC rate.">?</div>
							</td>
							<td><input type="text" id="editPeakTimeFirstWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first peak starts. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td><input type="text" id="editPeakTimeFirstWindowEndWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the first peak ends. Leave it as 0:00 if there is no peak time.">?</div>
							</td>
							<td><input type="text" id="editPeakTimeSecondWindowStartWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second peak happens. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
							<td><input type="text" id="editPeakTimeSecondWindowEndWinter" size="6px" value="0:00">
								<div class="help-button" value="Enter what time the second peak ends. Leave it as 0:00 if there is no second peak.">?</div>
							</td>
						</tr>
					</tbody>
				</table>

				<div class="import-row">
					<p class="help-block" id="edit-help-block-tariff"></p>
				</div>

				<div class="import-row">
					<button onclick="saveTariffData();" type="button" class="btn btn-success" style="margin-top: 20px; margin-right: 3px;">
						Save Tariff Data</button>
					<button type="button" class="btn btn-default" data-dismiss="modal" style="margin-top: 20px;">Close</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal to import raw PV data -->
	<div class="modal fade" id="importRawPVData" tabindex="-1" role="dialog" aria-labelledby="importRawDataLabel" style="width: 50% !important; margin-left: 25% !important;">
		<div class="modal-content">
			<div class="modal-header text-center">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title" id="importRawDataLabel"><strong>Import New PV Data with CSV File</strong></h3>
				<h5 class="modal-subtitle" style="color: #C31E24;">
					Please note that the data file should be in CSV format with one column with 12 months of PV data in kW. <br>
					If the PV Data is associated with a load data in the Load Setting list, the Start Month below must be the same.
				</h5>

				<table align="center">
					<tbody>
						<tr height="40px">
							<td align="right"><b>PV Name: &nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importPVName" value="pv_name">
								<div class="help-button" value="Enter the name of the PV. This name will be shown in the list of PV Settings.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Start Year: &nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importStartYearPV" value="2012">
								<div class="help-button" value="Enter the start year of the PV data as YYYY: e.g., 2012.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Start Month:&nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importStartMonthPV" value="1">
								<div class="help-button" value="Enter the starting month of the PV data in numeric format: e.g., January = 1">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Data Interval:&nbsp;&nbsp;</b></td>
							<td align="left">
								<select id="selectIntervalPV">
									<option value="15">15 Minutes</option>
									<option value="30">30 Minutes</option>
									<option value="60">1 Hour</option>
								</select>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Rated Capacity (Optional):&nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importPVCapacityOpt" value="">
								<div class="help-button" value="Enter the capacity of the PV generation.">?</div>
							</td>
						</tr>						
						<tr height="40px">
							<td align="right"><b>Latitude (Optional):&nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importLatitudePVOpt" value=" ">
								<div class="help-button" value="Enter the latitude of the location from which you want to obtain PV data. Latitude needs to be between -90 to 90.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Longitude (Optional):&nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importLongitudePVOpt" value=" ">
								<div class="help-button" value="Enter the longitude of the location from which you want to obtain PV data. Longitude needs to be between -180 to 180.">?</div>
							</td>
						</tr>
						
						<tr height="40px">
							<td align="right"><label for="importRawPV">Locate PV Profile:&nbsp;&nbsp;</label></td>
							<td align="left"><input class="import-input-control" type="file" id="importRawPV" enctype="multipart/form-data"></td>
						</tr>
					</tbody>
				</table>

				<div class="import-row">
					<p class="help-block" id="help-block-pv"></p>
				</div>

				<div class="import-row">
					<button onclick="importRawPVData();" type="button" class="btn btn-success" style="margin-top: 20px; margin-right: 3px;">Import Data</button>
					<button type="button" class="btn btn-default" data-dismiss="modal" style="margin-top: 20px;">Close</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modal to import PVWatts PV data -->
	<div class="modal fade" id="importPVWattsPVData" tabindex="-1" role="dialog" aria-labelledby="importRawDataLabel" style="width: 50% !important; margin-left: 25% !important;">
		<div class="modal-content">
			<div class="modal-header text-center">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h3 class="modal-title" id="importRawDataLabel"><strong>Import New PV Data with PVWatts</strong></h3>
				<h5 class="modal-subtitle" style="color: #C31E24;">
					Obtain Hourly <b>AC PV Data</b> from PVWatts provided by NREL API for 12 months in kW. <br>
				</h5>

				<table align="center">
					<tbody>
						<tr height="40px">
							<td align="right"><b>PV Name: &nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importPVNamePVWatts" value="pv_name">
								<div class="help-button" value="Enter the name of the PV. This name will be shown in the list of PV Settings.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Latitude: &nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importLatitudePV" value="37.33">
								<div class="help-button" value="Enter the latitude of the location from which you want to obtain PV data. Latitude needs to be between -90 to 90.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>Longitude:&nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="importLongitudePV" value="-121.88">
								<div class="help-button" value="Enter the longitude of the location from which you want to obtain PV data. Longitude needs to be between -180 to 180.">?</div>
							</td>
						</tr>
						<tr height="40px">
							<td align="right"><b>AC PV Capacity (kW):&nbsp;&nbsp;</b></td>
							<td align="left">
								<input type="text" class="import-input-control" id="nominalPVCapacity" value="100">
								<div class="help-button" value="Enter the nominal PV capacity with kW.">?</div>
							</td>
						</tr>
					</tbody>
				</table>
				
				<h4>Reference of Latitude and Longitude for Major Cities in the U.S.</h4>
				<table align="center" >
					<thead>
						<tr>
							<th  align="right">City Name:&nbsp;&nbsp;</th>
							<th>Latitude&nbsp;&nbsp;</th>
							<th>Longitude</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td align="right">Los Angeles (CA):</td>
							<td>34.05</td>
							<td>-118.24</td>
						</tr>
						<tr>
							<td align="right">San Francisco (CA):</td>
							<td>37.77</td>
							<td>-122.42</td>
						</tr>
						<tr>
							<td align="right">San Jose (CA):</td>
							<td>37.33</td>
							<td>-121.88</td>
						</tr>
						<tr>
							<td align="right">Portland (OR):</td>
							<td>45.52</td>
							<td>-122.67</td>
						</tr>
						<tr>
							<td align="right">Seattle (WA):</td>
							<td>47.6</td>
							<td>-122.33</td>
						</tr>
						<tr>
							<td align="right">Houston (TX):</td>
							<td>29.76</td>
							<td>-95.37</td>
						</tr>
						<tr>
							<td align="right">Boston (MA):</td>
							<td>42.35</td>
							<td>-71.06</td>
						</tr>
						<tr>
							<td align="right">New York (NY):</td>
							<td>40.71</td>
							<td>-74.01</td>
						</tr>
					</tbody>
				</table>

				<div class="import-row">
					<p class="help-block" id="help-block-pvwatts"></p>
				</div>

				<div class="import-row">
					<button onclick="importPVWattsData();" type="button" class="btn btn-success" style="margin-top: 20px; margin-right: 3px;">Import Data</button>
					<button type="button" class="btn btn-default" data-dismiss="modal" style="margin-top: 20px;">Close</button>
				</div>
			</div>
		</div>
	</div>
</body>

<script>
	/** GLOBAL_VARS_SECTION **/
	var resultFolders = [];

	// Internet Explorer 6-11
	var isIE = /*@cc_on!@*/false || !!document.documentMode;

	// Flag to check if the EMS is running or not.
	var emsRunningOrDone;

	//all global variables will be defined under this variable
	var GlobalVars = {
		"listOfBattConfig" : {
			"listOfkWh" : [],
			"listOfkW" : [],
			"price" : []
		},
		"loads" : {
			"loadName" : [],
			"startYear" : [],
			"startMonth" : [],
			"loadsAssoTariff" : [],
			"loadsAvg" : [],
			"loadsMax" : [],
			"loadsMin" : [],
			"loadsMaxToAvg" : []
		},
		"listOfLoads" : [],
		"tariffs": [],
//		"tariffs" : {
//			"tariffName" : [],
//			"AnyTimeDemandChargeRateSummer" : [],
//			"PartialPeakTimeDemandChargeRateSummer" : [],
//			"PeakTimeDemandChargeRateSummer" : [],
//			"AnyTimeDemandChargeRateWinter" : [],
//			"PartialPeakTimeDemandChargeRateWinter" : [],
//			"PeakTimeDemandChargeRateWinter" : [],
//			"summerType" : []
//		},
		"listOfTariffs" : [],
		"PVs" : {
			"pvName" : [],
			"startYear" : [],
			"startMonth" : [],
			"PVsAvg" : [],
			"PVsMax" : [],
			"PVsMin" : [],
			"PVsMaxToAvg" : []
		},
		"listOfPVs" : [],
		"listOfCombinations" : {
			"has_perfect_case" : [],
			"batt_sizes_kWh" : [],
			"batt_sizes_kW" : [],
			"load_name" : [],
			"tariff_name" : [],
			"sel_batt_sizes_kWh" : [],
			"sel_batt_sizes_kW" : [],
			"operable" : []
		},
		"currentSavedResultPath" : [],
		"currentAnalyzeResultPath" : [],
		"commonSimuConfig" : [],
		"createdCSFile" : [],
		"listOfCombinationsSensAna" : {
			"has_perfect_case" : [],
			"batt_sizes_kWh" : [],
			"batt_sizes_kW" : [],
			"load_name" : [],
			"tariff" : {
				"loadsAssoTariff" : []
			},
			"sel_batt_sizes_kWh" : [],
			"sel_batt_sizes_kW" : [],
			"perfectCaseRunning" : [],
			"BattReserveSensRange" : [],
			"DCTRatioSensRange" : [],
			"DCTDaysSensRange" : [],
			"commonSimuConfig" : [],
			"createdCSFile" : []
		},
		"currentSavedSensPath" : []
	};

	/** JQUERY_SECTION **/
	$(function() {
	    $("#tabs2").tabs();
	    //$( document ).tooltip();

	    // to get current mouse position on the screen
	    var currentMousePos = {
	        x: -1,
	        y: -1
	    };
	    $(document).mousemove(function(event) {
	        currentMousePos.x = event.pageX;
	        currentMousePos.y = event.pageY;
	    });

	    // showing help
	    $(document).on("mousemove", ".help-button, .help-button-small",
	        function() {
	            $("body").append("<div class='my-help'></div>");
	            $(".my-help").stop(true, true).css({
	                top: currentMousePos.y + 20,
	                left: currentMousePos.x + 20
	            }).html($(this).attr("value"));

	            $(".my-help").stop(true, true).animate({
	                opacity: 1
	            }, 500, function() {});
	        });
	    $(document).on("mouseout", ".help-button, .help-button-small",
	        function() {
	            $(".my-help").stop(true, true).animate({
	                opacity: 0
	            }, 200, function() {
	                $(".my-help").remove();
	            });
	        });

	    // showing help for loads
	    $(document).on("mousemove", ".help-button-load",
	        function() {
	            var loadNumbers = $(this).attr("value").substr(1,
	                    $(this).attr("value").length - 2)
	                .split(/,/);
	            $("body").append("<div class='my-help'></div>");
	            $(".my-help")
	                .stop(true, true)
	                .css({
	                    top: currentMousePos.y + 20,
	                    left: currentMousePos.x + 20
	                })
	                .html(
	                    'Start Year: <span class="load-numbers">' + loadNumbers[5] +
	                    '</span> &nbsp;Start Month: <span class="load-numbers">' + loadNumbers[0] +
	                    '</span> <br>Annual Average Load: <span class="load-numbers">' + loadNumbers[1] +
	                    '</span> kW<br/>Annual Maximum Load: <span class="load-numbers">' + loadNumbers[2] +
	                    '</span> kW<br/>Annual Minimum Load: <span class="load-numbers">' + loadNumbers[3] +
	                    '</span> kW<br/>Maximum to Average Ratio: <span class="load-numbers">' + loadNumbers[4] +
	                    '</span>');
	            $(".my-help").stop(true, true).animate({
	                opacity: 1
	            }, 500, function() {});
	        });
	    
	    $(document).on("mouseout", ".help-button, .help-button-load",
	        function() {
	            $(".my-help").stop(true, true).animate({
	                opacity: 0
	            }, 200, function() {
	                $(".my-help").remove();
	            });
	        });

	    // showing tooltip
	    $(document).on("mousemove", ".tariff-label, .tariff-selector",
	        function() {
	            $("body").append("<div class='my-tooltip'></div>");
	            $(".my-tooltip").stop(true, true).css({
	                top: currentMousePos.y + 20,
	                left: currentMousePos.x + 20
	            }).html($(this).attr("mytitle"));
	            $(".my-tooltip").stop(true, true).animate({
	                opacity: 1
	            }, 500, function() {});
	        });
	    $(document).on("mouseout", ".tariff-label, .tariff-selector",
	        function() {
	            $(".my-tooltip").stop(true, true).animate({
	                opacity: 0
	            }, 200, function() {
	                $(".my-tooltip").remove();
	            });
	        });

	    // showing help for PVs
	    $(document).on("mousemove", ".help-button-pv", function() {
	        var pvValues = $(this).attr("value").substr(1, $(this).attr("value").length - 2).split(/,/);
	        $("body").append("<div class='my-help'></div>");
	        $(".my-help").stop(true, true).css({
	            top: currentMousePos.y + 20,
	            left: currentMousePos.x + 20
	        }).html('Start Month: <span class="load-numbers">' + pvValues[0] +
        		'</span> <br>Annual Average PV: <span class="load-numbers">' + pvValues[1] +
	            '</span> kW<br/>Annual Maximum PV: <span class="load-numbers">' + pvValues[2] +
	            '</span> kW<br/>Annual Minimum PV: <span class="load-numbers">' + pvValues[3] +
	            '</span> kW<br/>Maximum to Average Ratio: <span class="load-numbers">' + pvValues[4] + '</span>');
	        $(".my-help").stop(true, true).animate({
	            opacity: 1
	        }, 500, function() {});
	    });
	    $(document).on("mouseout", ".help-button, .help-button-pv", function() {
	        $(".my-help").stop(true, true).animate({
	            opacity: 0
	        }, 200, function() {
	            $(".my-help").remove();
	        });
	    });
	    
	    // showing help for PVs
	    $(document).on("mousemove", ".help-button-tariff", function() {
	        var dcValues = $(this).attr("value").substr(1, $(this).attr("value").length - 2).split(/,/);
	        $("body").append("<div class='my-help-tariff'></div>");
	        $(".my-help-tariff").stop(true, true).css({
	            top: currentMousePos.y + 20,
	            left: currentMousePos.x + 20
	        }).html('<b>DC Rates for Spring & Summer</b> <br>' + 
	        		'Any Time: <span class="load-numbers">$' + dcValues[0] + '</span><br>' + 
	        		'Partial Peak Time: <span class="load-numbers">$' + dcValues[1] + '</span><br>' + 
	        		'Peak Time: <span class="load-numbers">$' + dcValues[2] + '</span><br>' + 
	        		'<b>DC Rates for Fall & Winter</b> <br> ' + 
	        		'Any (Off-Peak) Time: <span class="load-numbers">$' + dcValues[3] + '</span><br>' + 
	        		'Partial Peak Time: <span class="load-numbers">$' + dcValues[4] + '</span><br>' +
	        		'Peak Time: <span class="load-numbers">$' + dcValues[5] + '</span><br>' +
	        		'<b>TOU Summer: </b><span class="load-numbers">$' + dcValues[6] + ' - $' + dcValues[7] + '</span><br>' +
	        		'<b>TOU Winter: </b><span class="load-numbers">$' + dcValues[8] + ' - $' + dcValues[9] + '</span>'
	        );
	        $(".my-help-tariff").stop(true, true).animate({opacity: 1}, 500, function() {});
	    });
	    $(document).on("mouseout", ".help-button, .help-button-tariff", function() {
	        $(".my-help-tariff").stop(true, true).animate({opacity: 0}, 200, function() {
	            $(".my-help-tariff").remove();
	        });
	    });

	});

	// Executed when opening the Input page
	$(document).ready(function() {

		document.getElementById("uname").value = username;
		getSessionUsername();

		// Getting battery, load, tariff, and folder data to show on UI 
		// to create dynamic battery configuration on the UI
		// to create dynamic load checkboxes and tariff selections on the UI
		getAllConfigData();

		// Previously used even if the EMS is not running.
		// getProgStatus();
	});

	// assign click event to tariff label
	$(document).on('click', '.tariff-label',
	    function() {
	        var selectedLoad = $(this).attr("value"); //$(this).val();
	        var selectedTariff = $(this).attr("name");
	        var indexSel;
	        indexSel = jQuery.inArray(selectedTariff,
	            GlobalVars.loads[selectedLoad].loadsAssoTariff);
	        GlobalVars.loads[selectedLoad].loadsAssoTariff.splice(indexSel,
	            1);

	        $(this).remove();
	    });

	// assign click event to tariff selector
	$(document).on('change', '.tariff-selector',
	    function() {
	        var selectedLoad = $(this).attr("name");
	        var selectedOption = $(this).val();
	        var newContent = '';

	        // do not allow adding more than three unique tariffs
	        if (GlobalVars.loads[selectedLoad].loadsAssoTariff.length >= 3) {
	            alert("You are not allowed to select more than three tariffs.");
	        } else {
	            // Check if tariff already exists in the list for that load
	            if (jQuery
	                .inArray(
	                    selectedOption,
	                    GlobalVars.loads[selectedLoad].loadsAssoTariff) != -1) {
	                alert(selectedOption +
	                    " tariff is already selected.");
	            } else {
	                newContent += '<div mytitle="click to remove!" class="tariff-label" value="' +
	                    selectedLoad +
	                    '" name="' +
	                    selectedOption +
	                    '">' +
	                    selectedOption +
	                    '&nbsp;&nbsp;&nbsp; <span class="tariff-cross">X</span></div>';
	                $(newContent).insertBefore($(this));
	                GlobalVars.loads[selectedLoad].loadsAssoTariff
	                    .push(selectedOption);
	            }
	        }
	        //alert(GlobalVars.loads[selectedLoad].loadsAssoTariff);
	        //alert(loadsAssoTariff[selectedLoad][loadsAssoTariff[selectedLoad].length - 1]);
	    });	

	var progressPercentage = 0;

	// Progress Bart
	function move() {
		var elem = document.getElementById("myBar");
		var width = 10;
		var id = setInterval(frame, 1000);
		function frame() {
			if (width >= 100) {
				clearInterval(id);
			} else {
				width = Math.round(progressPercentage);
				if (width < 50)
					elem.style.backgroundColor = "red";
				if (50 <= width && width <= 75)
					elem.style.backgroundColor = "blue";
				if (75 <= width && width <= 100)
					elem.style.backgroundColor = "green";

				elem.style.width = width + '%';
				elem.innerHTML = width * 1 + '%';
			}
		}
	}

	//==========================================================================================================================================================
	//  importing raw load data: reading from a single-columned CSV file which has kW load demand data
	//==========================================================================================================================================================
	function importRawLoadData() {

		// checking all fields of required data are given
		var importNewLoadName = document.getElementById("importLoadName").value
				.trim();

		importNewLoadName = importNewLoadName.replace(/ /g, "_");

		if (importNewLoadName == '') {
			alert("Please enter the load name.");
			formreset(document.getElementById("importLoadName"));
			return false;
		}
		
		if (importNewLoadName.includes("var_plus") || importNewLoadName.includes("var_minus")) {
			alert('Please do not put "var_plus" or "var_minus" in the load name.');
			formreset(document.getElementById("importLoadName"));
			return false;
		}
		
		if (importNewLoadName.length > 20) {
			alert("The load name should be less than 21 characters.");
			formreset(document.getElementById("importLoadName"));
			return false;
		}

		if (importNewLoadName.indexOf('!') > -1
				|| importNewLoadName.indexOf(',') > -1
				|| importNewLoadName.indexOf('.') > -1
				|| importNewLoadName.indexOf('#') > -1
				|| importNewLoadName.indexOf('$') > -1
				|| importNewLoadName.indexOf('%') > -1
				|| importNewLoadName.indexOf('^') > -1
				|| importNewLoadName.indexOf('&') > -1
				|| importNewLoadName.indexOf('*') > -1
				|| importNewLoadName.indexOf('+') > -1
				|| importNewLoadName.indexOf('/') > -1
				|| importNewLoadName.indexOf('\\') > -1
				|| importNewLoadName.indexOf('"') > -1
				|| importNewLoadName.indexOf('=') > -1
				|| importNewLoadName.indexOf('|') > -1
				|| importNewLoadName.indexOf(':') > -1
				|| importNewLoadName.indexOf(';') > -1
				|| importNewLoadName.indexOf('?') > -1
				|| importNewLoadName.indexOf('~') > -1
				|| importNewLoadName.indexOf('`') > -1
				|| importNewLoadName.indexOf('[') > -1
				|| importNewLoadName.indexOf(']') > -1
				|| importNewLoadName.indexOf('{') > -1
				|| importNewLoadName.indexOf('}') > -1
				|| importNewLoadName.indexOf('@') > -1) {
			alert("The load name contains wrong character. Please remove or replace the character.");
			return false;
		}

		var importStartYearVal = document.getElementById("importStartYear").value
				.trim();
		if (!importStartYearVal.match(/^\d{4}$/)) {
			alert("Start year value should be a positive number in YYYY format.");
			formreset(document.getElementById("importStartYear"));
			return false;
		}
		
		var importStartMonthVal = document.getElementById("importStartMonth").value
				.trim();
		if (importStartMonthVal > 12 || importStartMonthVal < 1) {
			alert("Start month cannot be bigger than 12 or smaller than 1.");
			formreset(document.getElementById("importStartMonth"));
			return false;
		} else if (!importStartMonthVal.match(/^(0?[1-9]|[1-9][0-9])$/)) {
			alert("Start month should be a digit between 1 and 12.");
			formreset(document.getElementById("importStartMonth"));
			return false;
		}
		
		/* 
		var importAssocTariff = document.getElementById("importAssiTariff").value
				.trim().toUpperCase();
		if (importAssocTariff == '') {
			alert("Please enter the assigned (default) tariff of the load.");
			formreset(document.getElementById("importAssiTariff"));
			return false;
		}
		*/

		var RawLoadPath = document.getElementById("importRawLF").value;
		if (RawLoadPath == '') {
			alert("Please enter the assigned (default) tariff of the load.");
			formreset(document.getElementById("importRawLF"));
			return false;
		}

		// check the load does not exist in the folder
		if ($.inArray(importNewLoadName, GlobalVars.listOfLoads) != -1) {
			alert(importNewLoadName
					+ " load name already exist in the list above. If the load your are importing is new, please choose a different name.");
			formreset(document.getElementById("importLoadName"));
			return false;
		}

		var e = document.getElementById("selectInterval");
		var dataIntervalMinutes = e.options[e.selectedIndex].value;
		//alert(dataIntervalMinutes);

		//var importedHourlyData = document.getElementById("importedHourlyData");

		// adding new load to the globalVar list of loads
		// GlobalVars.listOfLoads.push(importNewLoadName);

		var x = document.getElementById("importRawLF");
		var txt = "";
		if ('files' in x) {
			if (x.files.length == 0) {
				alert("Select one or more files.");
			} else {
				for (var i = 0; i < x.files.length; i++) {
					txt += "<br><strong>" + (i + 1) + ". file</strong><br>";
					var file = x.files[i];
					if ('name' in file) {
						txt += "name: " + file.name + "<br>";
					}
					if ('size' in file) {
						txt += "size: " + file.size + " bytes <br>";
					}

					var xhr;
					if (window.XMLHttpRequest) {
						xhr = new XMLHttpRequest();
					} else {
						xhr = new ActiveXObject("Microsoft.XMLHTTP");
					}
					if (xhr.upload && file.type == "application/vnd.ms-excel") { // && file.size <= $id("MAX_FILE_SIZE").value) {

						//var isHourly = 'false';
						//if (importedHourlyData.checked)
						//    isHourly = 'true';

						xhr.open("POST",
								"/EMSOperationsEngine/btmEMS.do?domain=RawLoadData&uname="
										+ username + "&loadname="
										+ importNewLoadName + "&startYear="
										+ importStartYearVal + "&startMonth="
										+ importStartMonthVal // + "&tariff=" + importAssocTariff
										+ "&dataIntervalMinutes="
										+ dataIntervalMinutes, true);
						// xhr.setRequestHeader("X_FILENAME", file.name);
						xhr.onreadystatechange = function() {
							if (xhr.readyState === 4) {
								if (xhr.status === 200 || xhr.status == 0) {
									// adding the tariff of the load to the list
									var jData = JSON.parse(xhr.responseText);

									if (jData.isProcessed == "true") {

										GlobalVars.listOfLoads
												.push(importNewLoadName);

										var aveg = Number(jData.aveg);
										var max = Number(jData.max);
										var min = Number(jData.min);
										var maxtoavg = Number(jData.maxtoavg)
										//alert(aveg + ', ' + max + ', ' + min + ', ' + maxtoavg);
										GlobalVars.loads
												.push({
													//"loadsAssoTariff" : importAssocTariff,
													"loadsAvg" : aveg,
													"loadsMax" : max,
													"loadsMin" : min,
													"loadsMaxToAvg" : maxtoavg
												});

										document.getElementById("help-block").innerHTML = "'"
												+ importNewLoadName
												+ "' profile is created successfully.";

										window.setTimeout(function() { document.getElementById("help-block").innerHTML = ''; }, 5000);

										getAllConfigData();
									} else {
										alert(jData.reason);
									}
								}
							}
						}
						var formData = new FormData();
						formData.append('file', file);
						xhr.send(formData);
					}
				}
			}
		} else {
			if (x.value == "") {
				alert("Select one or more files.");
			} else {
				alert("The files property is not supported by your browser!");
				txt += "<br>The path of the selected file: " + x.value; // If the browser does not support the files property, it will return the path of the selected file instead.
			}
			return;
		}

	};
	
	function importRawPVData() {

		// checking all fields of required data are given
		var importNewPVName = document.getElementById("importPVName").value.trim();

		importNewPVName = importNewPVName.replace(/ /g, "_");

		if (importNewPVName == '') {
			alert("Please enter the PV name.");
			formreset(document.getElementById("importPVName"));
			return false;
		}
		
		if (importNewPVName.length > 20) {
			alert("The PV name should be less than 21 characters.");
			formreset(document.getElementById("importPVName"));
			return false;
		}

		if (importNewPVName.indexOf('!') > -1
				|| importNewPVName.indexOf(',') > -1
				|| importNewPVName.indexOf('.') > -1
				|| importNewPVName.indexOf('#') > -1
				|| importNewPVName.indexOf('$') > -1
				|| importNewPVName.indexOf('%') > -1
				|| importNewPVName.indexOf('^') > -1
				|| importNewPVName.indexOf('&') > -1
				|| importNewPVName.indexOf('*') > -1
				|| importNewPVName.indexOf('+') > -1
				|| importNewPVName.indexOf('/') > -1
				|| importNewPVName.indexOf('\\') > -1
				|| importNewPVName.indexOf('"') > -1
				|| importNewPVName.indexOf('=') > -1
				|| importNewPVName.indexOf('|') > -1
				|| importNewPVName.indexOf(':') > -1
				|| importNewPVName.indexOf(';') > -1
				|| importNewPVName.indexOf('?') > -1
				|| importNewPVName.indexOf('~') > -1
				|| importNewPVName.indexOf('`') > -1
				|| importNewPVName.indexOf('[') > -1
				|| importNewPVName.indexOf(']') > -1
				|| importNewPVName.indexOf('{') > -1
				|| importNewPVName.indexOf('}') > -1
				|| importNewPVName.indexOf('@') > -1) {
			alert("The load name contains wrong character. Please remove or replace the character.");
			return false;
		}

		var importStartYearVal = document.getElementById("importStartYearPV").value.trim();
		if (!importStartYearVal.match(/^\d{4}$/)) {
			alert("Start year value should be a positive number in YYYY format.");
			formreset(document.getElementById("importStartYearPV"));
			return false;
		}
		var importStartMonthVal = document.getElementById("importStartMonthPV").value.trim();
		if (importStartMonthVal > 12 || importStartMonthVal < 1) {
			alert("Start month cannot be bigger than 12 or smaller than 1.");
			formreset(document.getElementById("importStartMonthPV"));
			return false;
		} else if (!importStartMonthVal.match(/^(0?[1-9]|[1-9][0-9])$/)) {
			alert("Start month should be a digit between 1 and 12.");
			formreset(document.getElementById("importStartMonthPV"));
			return false;
		}
		
		var importLatitudePV = document.getElementById("importLatitudePVOpt").value.trim();
		if (importLatitudePV != '') {
			if(isNaN(importLatitudePV)){
				alert("The latitude should be a valid number.");
				formreset(document.getElementById("importLatitudePVOpt"));
				return false;
			} else {
				if (-180 > importLatitudePV || importLatitudePV > 180) {
					alert("The latitude should be between -180 to 180.");
					formreset(document.getElementById("importLatitudePVOpt"));
					return false;
				}
			}
		}
		
		var importPVCapacityOpt = document.getElementById("importPVCapacityOpt").value.trim();
		if (importPVCapacityOpt != '') {
			if(isNaN(importPVCapacityOpt)){
				alert("The capacity value should be a valid number.");
				formreset(document.getElementById("importPVCapacityOpt"));
				return false;
			} else {
				if (importPVCapacityOpt <= 0) {
					alert("The capacity should be more than 0.");
					formreset(document.getElementById("importPVCapacityOpt"));
					return false;
				}
			}
		}
		
		var importLongitudePV = document.getElementById("importLongitudePVOpt").value.trim();
		if (importLongitudePV != '') {
			if(isNaN(importLongitudePV)){
				alert("The longitude should be a valid number.");
				formreset(document.getElementById("importLongitudePVOpt"));
				return false;
			} else {
				if (-180 > importLongitudePV || importLongitudePV > 180) {
					alert("The longitude should be between -180 to 180.");
					formreset(document.getElementById("importLongitudePVOpt"));
					return false;
				}
			}
		}

		var RawPVPath = document.getElementById("importRawPV").value;
		if (RawPVPath == '') {
			alert("Please enter the location of raw PV CSV File.");
			formreset(document.getElementById("importRawPV"));
			return false;
		}

		// check the load does not exist in the folder
		if ($.inArray(importNewPVName, GlobalVars.listOfPVs) != -1) {
			alert(importNewPVName
					+ " The PV name already exists in the list above. If the PV you are importing is new, please choose a different name.");
			formreset(document.getElementById("importPVName"));
			return false;
		}

		var e = document.getElementById("selectIntervalPV");
		var dataIntervalMinutes = e.options[e.selectedIndex].value;

		var x = document.getElementById("importRawPV");
		var txt = "";
		if ('files' in x) {
			if (x.files.length == 0) {
				alert("Select one or more files.");
			} else {
				for (var i = 0; i < x.files.length; i++) {
					txt += "<br><strong>" + (i + 1) + ". file</strong><br>";
					var file = x.files[i];
					if ('name' in file) {
						txt += "name: " + file.name + "<br>";
					}
					if ('size' in file) {
						txt += "size: " + file.size + " bytes <br>";
					}

					var xhr;
					if (window.XMLHttpRequest) {
						xhr = new XMLHttpRequest();
					} else {
						xhr = new ActiveXObject("Microsoft.XMLHTTP");
					}
					if (xhr.upload && file.type == "application/vnd.ms-excel") { // && file.size <= $id("MAX_FILE_SIZE").value) {

						xhr.open("POST", "/EMSOperationsEngine/btmEMS.do?domain=RawPVData&uname="
										+ username + "&pvName="
										+ importNewPVName + "&startYear="
										+ importStartYearVal + "&startMonth="
										+ importStartMonthVal + "&dataIntervalMinutes="
										+ dataIntervalMinutes + "&lat="
										+ importLatitudePV + "&lon="
										+ importLongitudePV + "&capacity="
										+ importPVCapacityOpt, true);
						xhr.onreadystatechange = function() {
							if (xhr.readyState === 4) {
								if (xhr.status === 200 || xhr.status == 0) {
									
									var jData = JSON.parse(xhr.responseText);

									if (jData.isProcessed == "true") {
										getAllConfigData();
										document.getElementById("help-block-pv").innerHTML = "'"
												+ importNewPVName + "' profile is created successfully.";
										window.setTimeout( function() { document.getElementById("help-block-pv").innerHTML = ''; }, 5000);
									} else {
										alert(jData.reason);
									}
								}
							}
						}
						var formData = new FormData();
						formData.append('file', file);
						xhr.send(formData);
					}
				}
			}
		} else {
			if (x.value == "") {
				alert("Select one or more files.");
			} else {
				alert("The files property is not supported by your browser!");
				txt += "<br>The path of the selected file: " + x.value; // If the browser does not support the files property, it will return the path of the selected file instead.
			}
			return;
		}
	};

	function importPVWattsData() {

		// checking all fields of required data are given
		var importNewPVName = document.getElementById("importPVNamePVWatts").value.trim();

		importNewPVName = importNewPVName.replace(/ /g, "_");

		if (importNewPVName == '') {
			alert("Please enter the PV name.");
			formreset(document.getElementById("importPVNamePVWatts"));
			return false;
		}
		
		if (importNewPVName.length > 20) {
			alert("The PV name should be less than 21 characters.");
			formreset(document.getElementById("importPVNamePVWatts"));
			return false;
		}

		if (importNewPVName.indexOf('!') > -1
				|| importNewPVName.indexOf(',') > -1
				|| importNewPVName.indexOf('.') > -1
				|| importNewPVName.indexOf('#') > -1
				|| importNewPVName.indexOf('$') > -1
				|| importNewPVName.indexOf('%') > -1
				|| importNewPVName.indexOf('^') > -1
				|| importNewPVName.indexOf('&') > -1
				|| importNewPVName.indexOf('*') > -1
				|| importNewPVName.indexOf('+') > -1
				|| importNewPVName.indexOf('/') > -1
				|| importNewPVName.indexOf('\\') > -1
				|| importNewPVName.indexOf('"') > -1
				|| importNewPVName.indexOf('=') > -1
				|| importNewPVName.indexOf('|') > -1
				|| importNewPVName.indexOf(':') > -1
				|| importNewPVName.indexOf(';') > -1
				|| importNewPVName.indexOf('?') > -1
				|| importNewPVName.indexOf('~') > -1
				|| importNewPVName.indexOf('`') > -1
				|| importNewPVName.indexOf('[') > -1
				|| importNewPVName.indexOf(']') > -1
				|| importNewPVName.indexOf('{') > -1
				|| importNewPVName.indexOf('}') > -1
				|| importNewPVName.indexOf('@') > -1) {
			alert("The load name contains wrong character. Please remove or replace the character.");
			return false;
		}

		var importLatitudePV = document.getElementById("importLatitudePV").value.trim();
		if (importLatitudePV == '') {
			alert("Please enter the latitude info.");
			formreset(document.getElementById("importLatitudePV"));
			return false;
		}
		if(isNaN(importLatitudePV)){
			alert("The latitude should be a valid number.");
			formreset(document.getElementById("importLatitudePV"));
			return false;
		} else {
			if (-180 > importLatitudePV || importLatitudePV > 180) {
				alert("The latitude should be between -180 to 180.");
				formreset(document.getElementById("importLatitudePV"));
				return false;
			}
		}
		
		var importLongitudePV = document.getElementById("importLongitudePV").value.trim();
		if (importLongitudePV == '') {
			alert("Please enter the longitude info.");
			formreset(document.getElementById("importLongitudePV"));
			return false;
		}
		if(isNaN(importLongitudePV)){
			alert("The longitude should be a valid number.");
			formreset(document.getElementById("importLongitudePV"));
			return false;
		} else {
			if (-180 > importLongitudePV || importLongitudePV > 180) {
				alert("The longitude should be between -180 to 180.");
				formreset(document.getElementById("importLongitudePV"));
				return false;
			}
		}

		var nominalPVCapacity = document.getElementById("nominalPVCapacity").value.trim();
		if (nominalPVCapacity == '') {
			alert("Please enter the PV capacity value.");
			formreset(document.getElementById("nominalPVCapacity"));
			return false;
		}
		if(isNaN(nominalPVCapacity)){
			alert("The PV Capacity should be a valid number.");
			formreset(document.getElementById("nominalPVCapacity"));
			return false;
		} else {
			if (0.05 > nominalPVCapacity || nominalPVCapacity > 500000) {
				alert("The PV capacity should be between 0.05 to 500,000.");
				formreset(document.getElementById("nominalPVCapacity"));
				return false;
			}
		}

		// check the PV data does not exist in the folder
		if ($.inArray(importNewPVName, GlobalVars.listOfPVs) != -1) {
			alert(importNewPVName
					+ " The PV name already exists in the list above. If the PV you are importing is new, please choose a different name.");
			formreset(document.getElementById("importPVName"));
			return false;
		}
		
		var req;
		if (window.XMLHttpRequest) req = new XMLHttpRequest();
		else req = new ActiveXObject("Microsoft.XMLHTTP");
		req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=PVWatts&uname=" + username 
				+ "&pvName=" + importNewPVName + "&latitude=" + importLatitudePV + "&longitude=" 
				+ importLongitudePV + "&pvCapacity=" + nominalPVCapacity, true);
		req.onreadystatechange = function() {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {
					var jData = JSON.parse(req.responseText);
					if (jData.isProcessed == "false") {
						alert(jData.reason + " Request was not processed.");
					} else {
						getAllConfigData();
						document.getElementById("help-block-pvwatts").innerHTML = "'"
								+ importNewPVName + "' profile is created successfully.";
						window.setTimeout( function() { document.getElementById("help-block-pvwatts").innerHTML = ''; }, 5000);
					}
				}
			}
		}
		req.send(null);

	};

	function isNumber(evt) {
	    evt = (evt) ? evt : window.event;
	    var charCode = (evt.which) ? evt.which : evt.keyCode;
	    if (charCode >= 48 && charCode <= 57) {
	    	alert("Please enter only number in latitude.");
	        return false;
	    }
	    return true;
	}
	
	function importRawTariffData() {

		// checking all fields of required data are given
		var importNewTariffName = document.getElementById("importTariffName").value
				.trim();
		importNewTariffName = importNewTariffName.replace(/ /g, "_");

		if (importNewTariffName == '') {
			alert("Please enter the tariff name.");
			formreset(document.getElementById("importTariffName"));
			return false;
		}
		
		if (importNewTariffName.length > 20) {
			alert("The tariff name should be less than 21 characters.");
			formreset(document.getElementById("importNewTariffName"));
			return false;
		}

		if (importNewTariffName.indexOf('!') > -1
				|| importNewTariffName.indexOf(',') > -1
				|| importNewTariffName.indexOf('.') > -1
				|| importNewTariffName.indexOf('#') > -1
				|| importNewTariffName.indexOf('$') > -1
				|| importNewTariffName.indexOf('%') > -1
				|| importNewTariffName.indexOf('^') > -1
				|| importNewTariffName.indexOf('&') > -1
				|| importNewTariffName.indexOf('*') > -1
				|| importNewTariffName.indexOf('+') > -1
				|| importNewTariffName.indexOf('/') > -1
				|| importNewTariffName.indexOf('\\') > -1
				|| importNewTariffName.indexOf('"') > -1
				|| importNewTariffName.indexOf('=') > -1
				|| importNewTariffName.indexOf('|') > -1
				|| importNewTariffName.indexOf(':') > -1
				|| importNewTariffName.indexOf(';') > -1
				|| importNewTariffName.indexOf('?') > -1
				|| importNewTariffName.indexOf('~') > -1
				|| importNewTariffName.indexOf('`') > -1
				|| importNewTariffName.indexOf('[') > -1
				|| importNewTariffName.indexOf(']') > -1
				|| importNewTariffName.indexOf('{') > -1
				|| importNewTariffName.indexOf('}') > -1
				|| importNewTariffName.indexOf('@') > -1) {
			alert("The tariff name contains wrong character. Please remove or replace the character.");
			return false;
		}

		var summerType = document.getElementById("selectSummerType");
		var importSummerType = summerType.options[summerType.selectedIndex].value;
		//alert(dataIntervalMinutes);

		/*var importSummerType = document.getElementById("importSummerType").value.trim();
		if (importSummerType == '') {
			alert("Please enter the summer type.");
			formreset(document.getElementById("importSummerType"));
			return false;
		}

		var RawSummerTOUPath = document.getElementById("importRawSummerTOU").value;
		if (RawSummerTOUPath == '') {
			alert("Please select the summer TOU file");
			formreset(document.getElementById("importRawSummerTOU"));
			return false;
		}

		var RawWinterTOUPath = document.getElementById("importRawWinterTOU").value;
		if (RawWinterTOUPath == '') {
			alert("Please select the winter TOU file");
			formreset(document.getElementById("importRawWinterTOU"));
			return false;
		}*/

		var params = "";

		var a10 = document.getElementById("importAnytimeDCRate").value;
		var a11 = document.getElementById("anytimeFirstWindowStart").value;
		var a12 = document.getElementById("anytimeFirstWindowEnd").value;
		var a13 = document.getElementById("anytimeSecondWindowStart").value;
		var a14 = document.getElementById("anytimeSecondWindowEnd").value;
		params += "&a10=" + a10 + "&a11=" + a11 + "&a12=" + a12 + "&a13=" + a13
				+ "&a14=" + a14;

		var a20 = document.getElementById("importPartialPeakTimeDCRate").value;
		var a21 = document.getElementById("partialPeakTimeFirstWindowStart").value;
		var a22 = document.getElementById("partialPeakTimeFirstWindowEnd").value;
		var a23 = document.getElementById("partialPeakTimeSecondWindowStart").value;
		var a24 = document.getElementById("partialPeakTimeSecondWindowEnd").value;
		params += "&a20=" + a20 + "&a21=" + a21 + "&a22=" + a22 + "&a23=" + a23
				+ "&a24=" + a24;

		var a30 = document.getElementById("importPeakTimeDCRate").value;
		var a31 = document.getElementById("peakTimeFirstWindowStart").value;
		var a32 = document.getElementById("peakTimeFirstWindowEnd").value;
		var a33 = document.getElementById("peakTimeSecondWindowStart").value;
		var a34 = document.getElementById("peakTimeSecondWindowEnd").value;
		params += "&a30=" + a30 + "&a31=" + a31 + "&a32=" + a32 + "&a33=" + a33
				+ "&a34=" + a34;

		var b10 = document.getElementById("importAnytimeDCRateWinter").value;
		var b11 = document.getElementById("anytimeFirstWindowStartWinter").value;
		var b12 = document.getElementById("anytimeFirstWindowEndWinter").value;
		var b13 = document.getElementById("anytimeSecondWindowStartWinter").value;
		var b14 = document.getElementById("anytimeSecondWindowEndWinter").value;
		params += "&b10=" + b10 + "&b11=" + b11 + "&b12=" + b12 + "&b13=" + b13
				+ "&b14=" + b14;

		var b20 = document.getElementById("importPartialPeakTimeDCRateWinter").value;
		var b21 = document
				.getElementById("partialPeakTimeFirstWindowStartWinter").value;
		var b22 = document
				.getElementById("partialPeakTimeFirstWindowEndWinter").value;
		var b23 = document
				.getElementById("partialPeakTimeSecondWindowStartWinter").value;
		var b24 = document
				.getElementById("partialPeakTimeSecondWindowEndWinter").value;
		params += "&b20=" + b20 + "&b21=" + b21 + "&b22=" + b22 + "&b23=" + b23
				+ "&b24=" + b24;

		var b30 = document.getElementById("importPeakTimeDCRateWinter").value;
		var b31 = document.getElementById("peakTimeFirstWindowStartWinter").value;
		var b32 = document.getElementById("peakTimeFirstWindowEndWinter").value;
		var b33 = document.getElementById("peakTimeSecondWindowStartWinter").value;
		var b34 = document.getElementById("peakTimeSecondWindowEndWinter").value;
		params += "&b30=" + b30 + "&b31=" + b31 + "&b32=" + b32 + "&b33=" + b33
				+ "&b34=" + b34;

		// check the load does not exist in the folder
		if ($.inArray(importNewTariffName, GlobalVars.listOfTariffs) != -1) {
			alert(importNewTariffName
					+ " tariff name already exist in the list above. If the tariff your are importing is new, please choose a different name.");
			formreset(document.getElementById("importTariffName"));
			return false;
		}

		var x = document.getElementById("importRawSummerTOU");
		var y = document.getElementById("importRawWinterTOU");

		var xfile = null;
		var yfile = null;
		if ('files' in x && 'files' in y) {
			if (x.files.length == 0) {
				//alert("Select a file for Summer TOU.");
			} else {
				xfile = x.files[0];
			}
			if (y.files.length == 0) {
				//alert("Select a file for Winter TOU.");
			} else {
				yfile = y.files[0];
			}
		} else {
			//alert("Select TOU file(s)");
		}

		var xhr;
		if (window.XMLHttpRequest) {
			xhr = new XMLHttpRequest();
		} else {
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		}
		if (xhr.upload) { 
				//&& xfile.type == "application/vnd.ms-excel"
				//&& yfile.type == "application/vnd.ms-excel") { // && file.size <= $id("MAX_FILE_SIZE").value) {

			xhr.open("POST",
					"/EMSOperationsEngine/btmEMS.do?domain=RawTariffData&uname="
							+ username + "&tariffName=" + importNewTariffName
							+ "&summerType=" + importSummerType + params, true);
			xhr.onreadystatechange = function() {
				if (xhr.readyState === 4) {
					if (xhr.status === 200 || xhr.status == 0) {

						var jData = JSON.parse(xhr.responseText);

						if (jData.isProcessed == "true") {
							// adding new tariff to the globalVar list of tariffs
							GlobalVars.listOfTariffs.push(importNewTariffName);
							GlobalVars.tariffsSummerType.push(summerType);

							var summerType = jData.SummerType;
							document.getElementById("help-block-tariff").innerHTML = "'"
									+ importNewTariffName
									+ "' profile is created successfully.";
							window
									.setTimeout(
											function() {
												document
														.getElementById("help-block-tariff").innerHTML = '';
											}, 5000);

							// updaing the current list of loads/tariff in the UI
							getAllConfigData();
						} else {
							alert(jData.reason);
						}
					}
				}
			}

			var formData = new FormData();
			formData.append('summerTOUfile', xfile);
			formData.append('winterTOUfile', yfile);
			xhr.send(formData);
		}
	}

	function saveTariffData() {
		
		var editTariffName = document.getElementById("editTariffName").value;
		// alert(editTariffName);

//		var summerType = document.getElementById("selectSummerType");
//		var importSummerType = summerType.options[summerType.selectedIndex].value;
		//alert(dataIntervalMinutes);

		var params = "";

		var a10 = document.getElementById("editAnytimeDCRate").value;
		var a11 = document.getElementById("editAnytimeFirstWindowStart").value;
		var a12 = document.getElementById("editAnytimeFirstWindowEnd").value;
		var a13 = document.getElementById("editAnytimeSecondWindowStart").value;
		var a14 = document.getElementById("editAnytimeSecondWindowEnd").value;
		params += "&a10=" + a10 + "&a11=" + a11 + "&a12=" + a12 + "&a13=" + a13 + "&a14=" + a14;

		var a20 = document.getElementById("editPartialPeakTimeDCRate").value;
		var a21 = document.getElementById("editPartialPeakTimeFirstWindowStart").value;
		var a22 = document.getElementById("editPartialPeakTimeFirstWindowEnd").value;
		var a23 = document.getElementById("editPartialPeakTimeSecondWindowStart").value;
		var a24 = document.getElementById("editPartialPeakTimeSecondWindowEnd").value;
		params += "&a20=" + a20 + "&a21=" + a21 + "&a22=" + a22 + "&a23=" + a23 + "&a24=" + a24;

		var a30 = document.getElementById("editPeakTimeDCRate").value;
		var a31 = document.getElementById("editPeakTimeFirstWindowStart").value;
		var a32 = document.getElementById("editPeakTimeFirstWindowEnd").value;
		var a33 = document.getElementById("editPeakTimeSecondWindowStart").value;
		var a34 = document.getElementById("editPeakTimeSecondWindowEnd").value;
		params += "&a30=" + a30 + "&a31=" + a31 + "&a32=" + a32 + "&a33=" + a33 + "&a34=" + a34;

		var b10 = document.getElementById("editAnytimeDCRateWinter").value;
		var b11 = document.getElementById("editAnytimeFirstWindowStartWinter").value;
		var b12 = document.getElementById("editAnytimeFirstWindowEndWinter").value;
		var b13 = document.getElementById("editAnytimeSecondWindowStartWinter").value;
		var b14 = document.getElementById("editAnytimeSecondWindowEndWinter").value;
		params += "&b10=" + b10 + "&b11=" + b11 + "&b12=" + b12 + "&b13=" + b13 + "&b14=" + b14;

		var b20 = document.getElementById("editPartialPeakTimeDCRateWinter").value;
		var b21 = document.getElementById("editPartialPeakTimeFirstWindowStartWinter").value;
		var b22 = document.getElementById("editPartialPeakTimeFirstWindowEndWinter").value;
		var b23 = document.getElementById("editPartialPeakTimeSecondWindowStartWinter").value;
		var b24 = document.getElementById("editPartialPeakTimeSecondWindowEndWinter").value;
		params += "&b20=" + b20 + "&b21=" + b21 + "&b22=" + b22 + "&b23=" + b23 + "&b24=" + b24;

		var b30 = document.getElementById("editPeakTimeDCRateWinter").value;
		var b31 = document.getElementById("editPeakTimeFirstWindowStartWinter").value;
		var b32 = document.getElementById("editPeakTimeFirstWindowEndWinter").value;
		var b33 = document.getElementById("editPeakTimeSecondWindowStartWinter").value;
		var b34 = document.getElementById("editPeakTimeSecondWindowEndWinter").value;
		params += "&b30=" + b30 + "&b31=" + b31 + "&b32=" + b32 + "&b33=" + b33 + "&b34=" + b34;

		// check the load does not exist in the folder
//		if ($.inArray(importNewTariffName, GlobalVars.listOfTariffs) != -1) {
//			alert(importNewTariffName + " tariff name already exist in the list above. If the tariff your are importing is new, please choose a different name.");
//			formreset(document.getElementById("importTariffName"));
//			return false;
//		}

		var xhr = null;
		if (window.XMLHttpRequest) xhr = new XMLHttpRequest();
		else xhr = new ActiveXObject("Microsoft.XMLHTTP");
		
		xhr.open("POST", "/EMSOperationsEngine/btmEMS.do?domain=EditTariffData&uname="
						+ username + "&tariffName=" + editTariffName + params, true);
		// "&summerType=" + importSummerType + 

		xhr.onreadystatechange = function() {
			if (xhr.readyState === 4) {
				if (xhr.status === 200 || xhr.status == 0) {
					var jData = JSON.parse(xhr.responseText);
					if (jData.isProcessed == "true") {
						// adding new tariff to the globalVar list of tariffs
						//GlobalVars.listOfTariffs.push(importNewTariffName);
						//GlobalVars.tariffsSummerType.push(summerType);

						// Updaing the current list of loads, tariff, PVs, batteries in the UI
						getAllConfigData();

						document.getElementById("edit-help-block-tariff").innerHTML = "'" + editTariffName + "' profile is saved successfully.";
						window.setTimeout( function() { document.getElementById("edit-help-block-tariff").innerHTML = ''; }, 5000);
					} else {
						alert(jData.reason);
					}
				}
			}
		}
		var formData = new FormData();
		//formData.append('summerTOUfile', xfile);
		//formData.append('winterTOUfile', yfile);
		xhr.send(formData);
	}

	/** Getting Updated data from Python by sending XMLHttpRequest **/
	function getProgStatus() {
		var req;
		if (window.XMLHttpRequest)
			req = new XMLHttpRequest();
		else
			req = new ActiveXObject("Microsoft.XMLHTTP");

		req.open("GET",
				"/EMSOperationsEngine/btmEMS.do?domain=ProgStatus&uname="
						+ username, true);
		req.onreadystatechange = function() {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {

					//alert(req.responseText);
					var str = req.responseText;
					var jData = JSON.parse(str);
					var percentage = jData.Percentage;
					emsRunningOrDone = jData.Status;
					showStatusLog(jData);

					if (emsRunningOrDone == "Done") {
						progressPercentage = 0;
						document.getElementById("runSimulation").disabled = false;
						document.getElementById("StopRun").disabled = true;
						document.getElementById("AddRun").disabled = true;
						document.getElementById("StopRun").style.color = "red";
						document.getElementById("AddRun").style.color = "red";
						document.getElementById("EMSRunSpin2").style.display = "none";
						//document.getElementById("runStatus").innerHTML = "<b>Execution Status: EMS NOT running</b>";
						//document.getElementById("runSensitivity").disabled = false;
						//document.getElementById("TuneRunSpin").style.display = "none";
					} else {
						progressPercentage = Number(percentage);
						var folderPath = jData.FolderPath;

						var type = Number(jData.RunType);
						if (type == 0) {
							document.getElementById("EMSRunSpin2").style.display = "inline";
						}
						if (type == 1) {
							document.getElementById("TuneRunSpin").style.display = "inline";
						}

						document.getElementById("StopRun").disabled = false;
						document.getElementById("AddRun").disabled = false;
						document.getElementById("runSimulation").disabled = true;
						document.getElementById("runSimulation").style.color = "blue";
						//document.getElementById("StopRun").style.color = "lightblue";
						//document.getElementById("runSensitivity").disabled = true;
						// create a pause to check on progress of EMS simulation
						window.setTimeout(function() {
							getProgStatus();
						}, 2000);
					}
				}
			}
		}
		req.send(null);
	}

	function getSessionUsername() {
		var iText = document.createElement('p');
		iText.innerHTML = "Logged in as : <b>" + username + "</b>";
		document.getElementById('username').appendChild(iText);
	}

	function getAllConfigData() {
		
		move();

		// Battery Setting
		GlobalVars.listOfBattConfig.listOfkWh = [];
		GlobalVars.listOfBattConfig.listOfkW = [];
		GlobalVars.listOfBattConfig.price = [];

		// Load Setting
		GlobalVars.loads = [];
		GlobalVars.listOfLoads = [];
		GlobalVars.loads.loadName = [];
		GlobalVars.loads.startYear = [];
		GlobalVars.loads.startMonth = [];
		GlobalVars.loads.loadsAvg = [];
		GlobalVars.loads.loadsMax = [];
		GlobalVars.loads.loadsMin = [];
		GlobalVars.loads.loadsMaxToAvg = [];

		// Tariff Setting
		GlobalVars.tariffs = [];
		GlobalVars.listOfTariffs = [];
//		GlobalVars.tariffs.tariffName = [];
//		GlobalVars.tariffs.AnyTimeDemandChargeRateSummer = [];
//		GlobalVars.tariffs.PartialPeakTimeDemandChargeRateSummer = [];
//		GlobalVars.tariffs.PeakTimeDemandChargeRateSummer = [];
//		GlobalVars.tariffs.AnyTimeDemandChargeRateWinter = [];
//		GlobalVars.tariffs.PartialPeakTimeDemandChargeRateWinter = [];
//		GlobalVars.tariffs.PeakTimeDemandChargeRateWinter = [];
//		GlobalVars.tariffs.summerType = [];
		GlobalVars.tariffsSummerType = [];

		// PV Setting
		GlobalVars.PVs = [];
		GlobalVars.listOfPVs = [];
		GlobalVars.PVs.pvName = [];
		GlobalVars.PVs.startYear = [];
		GlobalVars.PVs.startMonth = [];
		GlobalVars.PVs.PVsAvg = [];
		GlobalVars.PVs.PVsMax = [];
		GlobalVars.PVs.PVsMin = [];
		GlobalVars.PVs.PVsMaxToAvg = [];

		var req = null;
		if (window.XMLHttpRequest) {
			req = new XMLHttpRequest();
		} else {
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}

		req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=AllConfigData&username=" + username, true);
		req.onreadystatechange = function() {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {

					var text = req.responseText;
					var line = text.replace(/(?:\r\n|\r|\n)/g, ",").split(/,/);
					var jData = JSON.parse(text);

					// Parsing Battery Configs
					for (var i = 0; i < jData.BatterySettings.length; i++) {
						var battery = jData.BatterySettings[i];

						GlobalVars.listOfBattConfig.listOfkWh.push(battery.kWh);
						GlobalVars.listOfBattConfig.listOfkW.push(battery.kW);
						GlobalVars.listOfBattConfig.price.push(battery.price);
					}

					showBatteries();

					// Parsing Load Settings
					for (var i = 0; i < jData.LoadSettings.length; ++i) {
						var load = jData.LoadSettings[i];

						GlobalVars.loads.push({
							"loadsAssoTariff" : []
						});

						GlobalVars.listOfLoads.push(load.loadName);
						GlobalVars.loads.loadName.push(load.loadName);
						GlobalVars.loads.startYear.push(load.startYear);
						GlobalVars.loads.startMonth.push(load.startMonth);
						GlobalVars.loads.loadsAvg.push(load.loadsAvg);
						GlobalVars.loads.loadsMax.push(load.loadsMax);
						GlobalVars.loads.loadsMin.push(load.loadsMin);
						GlobalVars.loads.loadsMaxToAvg.push(load.loadsMaxToAvg);

						//for (var k = 0; k < load.tariffs.length; k++) {
						//	GlobalVars.loads[i].loadsAssoTariff.push(load.tariffs[k]);
						//}
					}

					// Parsing Tariff Setgings
					for (var i = 0; i < jData.TariffSettings.length; ++i) {
						var tariff = jData.TariffSettings[i];
						GlobalVars.listOfTariffs.push(tariff.tariffName);
						//console.log(tariff);
						GlobalVars.tariffs.push(tariff);
						//alert(GlobalVars.tariffs[i].dcRatesSummer.AnyTimeDemandChargeRate.Value$kW);
//						GlobalVars.tariffs.tariffName.push(tariff.tariffName);
//						GlobalVars.tariffs.AnyTimeDemandChargeRateSummer.push(tariff.AnyTimeDemandChargeRateSummer);
//						GlobalVars.tariffs.PartialPeakTimeDemandChargeRateSummer.push(tariff.PartialPeakTimeDemandChargeRateSummer);
//						GlobalVars.tariffs.PeakTimeDemandChargeRateSummer.push(tariff.PeakTimeDemandChargeRateSummer);
//						GlobalVars.tariffs.AnyTimeDemandChargeRateWinter.push(tariff.AnyTimeDemandChargeRateWinter);
//						GlobalVars.tariffs.PartialPeakTimeDemandChargeRateWinter.push(tariff.PartialPeakTimeDemandChargeRateWinter);
//						GlobalVars.tariffs.PeakTimeDemandChargeRateWinter.push(tariff.PeakTimeDemandChargeRateWinter);
//						GlobalVars.tariffs.summerType.push(tariff.summerType);
						
						GlobalVars.tariffsSummerType.push(tariff.summerType);
					}

					// Parsing PV Setgings
					if (jData.PVSettings != null) {
						for (var i = 0; i < jData.PVSettings.length; ++i) {
							var pv = jData.PVSettings[i];
							GlobalVars.listOfPVs.push(pv.pvName);
							GlobalVars.PVs.pvName.push(pv.pvName);
							GlobalVars.PVs.startYear.push(pv.startYear);
							GlobalVars.PVs.startMonth.push(pv.startMonth);
							GlobalVars.PVs.PVsAvg.push(pv.PVsAvg);
							GlobalVars.PVs.PVsMax.push(pv.PVsMax);
							GlobalVars.PVs.PVsMin.push(pv.PVsMin);
							GlobalVars.PVs.PVsMaxToAvg.push(pv.PVsMaxToAvg);
							//GlobalVars.tariffsSummerType.push(tariff.summerType);
						}
					}

					showTariffs();
					showLoads();
					showPVs();

					// Parsing Result Folders
					/* for (var i = 0; i < jData.ResultFolders.length; i++) {
						var folder = jData.ResultFolders[i];
						resultFolders.push({
							"folderName" : folder.folderName
						//"createdDateTime": "dateTime"
						});
					}*/
					updateSelectSection([]);

					getProgStatus();
				}
			}
		}
		req.send(null);
	}

	// selecting all battery configurations
	function selectAll(typeSelected) {
		var allInputs = document.getElementsByTagName("input");
		for (var i = 0; i < allInputs.length; i++) {
			if (allInputs[i].name == "batteryConfig"
					&& typeSelected == "battery") {
				allInputs[i].checked = true;
			} else if (allInputs[i].name == "loadConfig"
					&& typeSelected == "load") {
				allInputs[i].checked = true;
			} else if (allInputs[i].name == "tariffConfig"
					&& typeSelected == "tariff") {
				allInputs[i].checked = true;
			} else if (allInputs[i].name == "pvConfig" && typeSelected == "pv") {
				allInputs[i].checked = true;
			}
		}
	}

	// deselecting all battery configurations
	function deselectAll(typeSelected) {
		var allInputs = document.getElementsByTagName("input");
		for (var i = 0; i < allInputs.length; i++) {
			if (allInputs[i].name == "batteryConfig"
					&& typeSelected == "battery") {
				allInputs[i].checked = false;
			} else if (allInputs[i].name == "loadConfig"
					&& typeSelected == "load") {
				allInputs[i].checked = false;
			} else if (allInputs[i].name == "tariffConfig"
					&& typeSelected == "tariff") {
				allInputs[i].checked = false;
			} else if (allInputs[i].name == "pvConfig" && typeSelected == "pv") {
				allInputs[i].checked = false;
			}
		}
	}

	function showStatusLog(jData) {

		//alert(jData.SimCombos[0].Score);

		var dynamicContentRight = '';
		var simCombos = jData.SimCombos;
		document.getElementById("simStartTime").innerHTML = "<b>"
				+ jData.SimulationStartTime + "</b>";
		document.getElementById("simEndTime").innerHTML = "<b>"
				+ jData.SimulationEndTime + "</b>";
		document.getElementById("numOfRequests").innerHTML = "<b>"
				+ jData.numOfRequestsInSimulationQueue; + "</b>";
		document.getElementById("numOfRequests").value = jData.numOfRequestsInSimulationQueue;
		
		dynamicContentRight += '<table width="100%">';
		for (var i = 0; i < simCombos.length; i++) {
			var myProgressID = "myProgress_" + simCombos[i].SimulationID;
			
			var runType =  "Normal";
			if (simCombos[i].RunType == "0") {
				runType = "Normal";
			} else if (simCombos[i].RunType == "1") {
				runType = "PV";
			} else if (simCombos[i].RunType == "2") {
				runType = "Ratchet";
			} else if (simCombos[i].RunType == "3") {
				runType = "DR";
			} else {
				runType = "Not Defined";
			}

			if (simCombos[i].Score == null)
				simCombos[i].Score = 100;

			var pvUtilFlag = "Y";
			if (simCombos[i].PVUtilizationFlag == 0) {
				pvUtilFlag = "N";
			}
			
			dynamicContentRight += '<tr height="35">';
			dynamicContentRight += '<td width="55%"> <b>'
					+ simCombos[i].kWh + 'kWh/'
					+ simCombos[i].kW + 'kW [ '
					+ simCombos[i].LoadName + ', ' + simCombos[i].TariffName
					+ ', ' + simCombos[i].PVName + ' (' + simCombos[i].PVCapacity + ', ' + pvUtilFlag + ')' // + simCombos[i].DRName
					+ ', ' + simCombos[i].isBatteryLifeAnalyzed + ', ' + simCombos[i].LoadIncrementValue + '% ]</b> </td>';
			dynamicContentRight += '<td width="15%"> <b>'
					+ simCombos[i].StartTime + '</b> </td>';
			dynamicContentRight += '<td width="15%"> &nbsp;&nbsp;<b>'
					+ simCombos[i].EndTime + '</b></td>';
			dynamicContentRight += '<td width="15%"> &nbsp;&nbsp;&nbsp;&nbsp;<b>'
					+ simCombos[i].InterruptedTime + '</b></td>';
			dynamicContentRight += '</tr>';
		}

		dynamicContentRight += '</table>';
		$(".status-log-setting").empty().append(dynamicContentRight);
	}

	function showLoads() {

		// to create dynamic tariff associated with each load on the UI
		var dynamicContentRight = '';
		for (var i = 0; i < GlobalVars.loads.length; i++) {
			dynamicContentRight += '<div class="load-config-list"><label class="config-label" ><label class="help-button-load" value="[' 
	            + GlobalVars.loads.startMonth[i] +
	        ',' + GlobalVars.loads.loadsAvg[i] +
            ',' + GlobalVars.loads.loadsMax[i] +
            ',' + GlobalVars.loads.loadsMin[i] +
            ',' + GlobalVars.loads.loadsMaxToAvg[i] +
            ',' + GlobalVars.loads.startYear[i] +
            ']"><input type="checkbox" name="loadConfig" value="' + GlobalVars.listOfLoads[i] + '">&nbsp; '
					+ GlobalVars.listOfLoads[i]
					+ '</label>'
            		+ '<label class="delete-batt-config" id="' + GlobalVars.listOfLoads[i]
					+ '" title="click to remove!" onclick="deleteOneLoad(this);">X</label>'
					+ '</div>';
			$(".load-setting").empty().append(dynamicContentRight);
		}
	}

	function showTariffs() {
		// to create dynamic tariff associated with each load on the UI
		var dynamicContentRight = '';

		for (var i = 0; i < GlobalVars.listOfTariffs.length; i++) {
			//TODO tariffConfig
			dynamicContentRight += '<div class="tariff-config-list"><label class="config-label" >'
			+ '<label class="help-button-tariff" value="[' 
	            + GlobalVars.tariffs[i].dcRatesSummer.AnyTimeDemandChargeRate.Value$kW +
		        ',' + GlobalVars.tariffs[i].dcRatesSummer.PartialPeakTimeDemandChargeRate.Value$kW +
	            ',' + GlobalVars.tariffs[i].dcRatesSummer.PeakTimeDemandChargeRate.Value$kW +
	            ',' + GlobalVars.tariffs[i].dcRatesWinter.AnyTimeDemandChargeRate.Value$kW +
	            ',' + GlobalVars.tariffs[i].dcRatesWinter.PartialPeakTimeDemandChargeRate.Value$kW +
	            ',' + GlobalVars.tariffs[i].dcRatesWinter.PeakTimeDemandChargeRate.Value$kW +
	            ',' + GlobalVars.tariffs[i].touSummer.MinValue +
	            ',' + GlobalVars.tariffs[i].touSummer.MaxValue +
	            ',' + GlobalVars.tariffs[i].touWinter.MinValue +
	            ',' + GlobalVars.tariffs[i].touWinter.MaxValue +
	            ']">'
			     + '<input type="checkbox" name="tariffConfig" value="' 
					+ GlobalVars.listOfTariffs[i] + '">&nbsp; <b>'
					+ GlobalVars.listOfTariffs[i] + '</b></label>'
					
					+ '<label class="delete-batt-config" data-toggle="modal" data-target="#editTariffData" id="' + GlobalVars.listOfTariffs[i]
					+ '" title="click to edit!" onclick="editTariffConfig(this);">Edit</label>'
					
					+ '<label class="delete-batt-config" id="' + GlobalVars.listOfTariffs[i]
					+ '" title="click to remove!" onclick="deleteTariffConfig(this);">X</label>'
				+ '</div>';
		}
		$(".tariff-setting").empty().append(dynamicContentRight);
	}

	function showPVs() {
		var dynamicPVConfig = '';
		
		for (var i = 0; i < GlobalVars.listOfPVs.length; i++) {
			dynamicPVConfig += '<div class="pv-config-list"><label class="config-label" ><label class="help-button-pv" value="[' 
	            + GlobalVars.PVs.startMonth[i] +
	        ',' + GlobalVars.PVs.PVsAvg[i] +
            ',' + GlobalVars.PVs.PVsMax[i] +
            ',' + GlobalVars.PVs.PVsMin[i] +
            ',' + GlobalVars.PVs.PVsMaxToAvg[i] +
            ']"><input type="checkbox" name="pvConfig" value="' 
					+ GlobalVars.listOfPVs[i] + '" disabled>&nbsp; <b>'
					+ GlobalVars.listOfPVs[i]
					+ '</b></label>'
					+ '<label class="delete-batt-config" id="' + GlobalVars.listOfPVs[i]
					+ '" title = "click to remove!" onclick="deletePVConfig(this);">X</label>'
					+ '</div>';
		}
		$(".pvConfig-container").empty().append(dynamicPVConfig);
	}
	

	function showBatteries() {
		var dynamicBattConfig = '';
		dynamicBattConfig += '<table><tr>';
		for (var i = 0; i < GlobalVars.listOfBattConfig.listOfkWh.length; i++) {
			var priceInfo = "Battery Price: $"
					+ GlobalVars.listOfBattConfig.price[i];

			dynamicBattConfig += '<div class="batt-config-list"><label class="config-label" title = "' + priceInfo + '">'
					+ '<input type="checkbox" name="batteryConfig" value="' + GlobalVars.listOfBattConfig.listOfkWh[i] + ' kWh/' + GlobalVars.listOfBattConfig.listOfkW[i] + ' kW' + '">&nbsp; '
					+ GlobalVars.listOfBattConfig.listOfkWh[i]
					+ ' kWh/'
					+ GlobalVars.listOfBattConfig.listOfkW[i]
					+ ' kW'
					+ '<label class="delete-batt-config" title = "click to remove!" onclick="deleteBattConfig(this);">X</label>'
					+ '</label></div>';
		}
		dynamicBattConfig += '</tr></table>';
		$(".left-battConfig-container").empty().append(dynamicBattConfig);
	}

	// add new item to the battery configuration list, "Battery_Config.csv" file
	function addNewBattConfig() {
		// checking the inputs not to be empty
		posvaluecheck(document.getElementById("newkWh"));
		posvaluecheck(document.getElementById("newkW"));
		posvaluecheck(document.getElementById("newPrice"));

		// check if the new adding request already exists
		var existingConfig = false;
		for (var i = 0; i < GlobalVars.listOfBattConfig.listOfkWh.length; i++) {
			if (Number(document.getElementById("newkWh").value) == GlobalVars.listOfBattConfig.listOfkWh[i]
					&& Number(document.getElementById("newkW").value) == GlobalVars.listOfBattConfig.listOfkW[i]) {
				alert('Battery configuration already exists.');
				existingConfig = true;
			}
		}

		if (!existingConfig) {
			// to create dynamic battery configuration on the UI
			GlobalVars.listOfBattConfig.listOfkWh.push(Number(document
					.getElementById("newkWh").value));
			GlobalVars.listOfBattConfig.listOfkW.push(Number(document
					.getElementById("newkW").value));
			GlobalVars.listOfBattConfig.price.push(Number(document
					.getElementById("newPrice").value));

			showBatteries();
		}

		saveNewBattConfig();
	}

	// return battery configurations to 17 default configs
	function saveNewBattConfig() {
		var lines = 'kWh, kW, price\n';

		//create contents for the Battery_Config.csv file
		for (var i = 0; i < GlobalVars.listOfBattConfig.listOfkWh.length; i++) {
			if (i == GlobalVars.listOfBattConfig.listOfkWh.length - 1) {
				lines += GlobalVars.listOfBattConfig.listOfkWh[i] + ','
						+ GlobalVars.listOfBattConfig.listOfkW[i] + ','
						+ GlobalVars.listOfBattConfig.price[i];
			} else {
				lines += GlobalVars.listOfBattConfig.listOfkWh[i] + ','
						+ GlobalVars.listOfBattConfig.listOfkW[i] + ','
						+ GlobalVars.listOfBattConfig.price[i] + '\n';
			}
		}
		sendNewBatteryConfigData(lines);

		// to create dynamic battery configuration on the UI
		var div_list = $(".left-battConfig-container label").closest('label');

		for (i = 0; i < div_list.length; i += 1) {
			div_list[i].parentNode.removeChild(div_list[i]);
		}
		showBatteries();

		//alert("New batter configuration(s) is(are) saved successfully.");
	}

	function sendNewBatteryConfigData(line) {

		var req = null;
		if (window.XMLHttpRequest) {
			req = new XMLHttpRequest();
		} else {
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}

		req.open("Post",
				"/EMSOperationsEngine/btmEMS.do?domain=SaveNewBatteryConfig&username="
						+ username, true);
		//req.open("Post", "/sendBattConfig", true);
		req.onreadystatechange = function() {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {
					var text = req.responseText;
				}
			}
		}
		req.send(line);
	}

	function downloadResults() {
		var folder = document.getElementById("folder-select3").value;
		document.getElementById("folder").value = folder;
		document.getElementById("uname2").value = username;
	}

	function downloadLoadProfile() {
		var value = document.getElementById("load-download").value;
		document.getElementById("download-loadname").value = value;
		document.getElementById("uname").value = username;
	}

	function downloadTariffProfile() {
		var value = document.getElementById("tariff-download").value;
		document.getElementById("download-tariffname").value = value;
		document.getElementById("uname1").value = username;
	}

	function deleteBattConfig(element) {

		if (!confirm("Are you sure you want to delete this battery configuration?")) {
			return false;
		}

		// reading the kWh/kW requested to be deleted
		var kWhSelected = $(element).prev().attr("value").match(/[\d\.]+/g)[0];
		var kWSelected = $(element).prev().attr("value").match(/[\d\.]+/g)[1];

		// removing from GlobalVars.listOfBattConfig
		for (var i = 0; i < GlobalVars.listOfBattConfig.listOfkWh.length; i++) {
			if (GlobalVars.listOfBattConfig.listOfkWh[i] == Number(kWhSelected)
					&& GlobalVars.listOfBattConfig.listOfkW[i] == Number(kWSelected)) {

				GlobalVars.listOfBattConfig.listOfkWh.splice(i, 1);
				GlobalVars.listOfBattConfig.listOfkW.splice(i, 1);
				GlobalVars.listOfBattConfig.price.splice(i, 1);
				break;
			}
		}

		// remove from the UI
		$(element).closest(".config-label").remove();

		saveNewBattConfig()
	}
	
	function deleteUserAccount() {
		if (!confirm("Are you sure you want to delete your account? All the data in the account will also be deleted.")) {
			return false;
		}
		
		var req = null;
	    if (window.XMLHttpRequest) { req = new XMLHttpRequest(); }
	    else { req = new ActiveXObject("Microsoft.XMLHTTP"); }
	    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=DeleteUserAccount&username=" + username, true);
	    req.onreadystatechange = function() {
	        if (req.readyState === 4) {
	            if (req.status === 200 || req.status == 0) {
	        		document.write('Your account has been deleted. Go back to <a href="../LoginForm.jsp">Login Page</a>');
	            }
			}
	    }
	    req.send(null);
	}

	function editTariffConfig(element) {

		// reading the tariff name requested to be editted
		var deletedTariff = element.id;
		var index = 0;
		for (var i = 0; i < GlobalVars.tariffs.length; i ++) {
			if (GlobalVars.tariffs[i].tariffName == deletedTariff) {
				index = i;
				//alert(GlobalVars.tariffs[index].tariffName);
				break;
			}
		}
		
		document.getElementById("titleEditTariffData").innerHTML = "Edit Tariff Data of <b>" + GlobalVars.tariffs[index].tariffName + "</b><br>";
		document.getElementById("editTariffName").value = GlobalVars.tariffs[index].tariffName;
		
		// Summer DC Rates
		document.getElementById("editAnytimeDCRate").value = GlobalVars.tariffs[index].dcRatesSummer.AnyTimeDemandChargeRate.Value$kW;
		document.getElementById("editAnytimeFirstWindowStart").value = GlobalVars.tariffs[index].dcRatesSummer.AnyTimeDemandChargeRate.firstTimeWindow_start;
		document.getElementById("editAnytimeFirstWindowEnd").value = GlobalVars.tariffs[index].dcRatesSummer.AnyTimeDemandChargeRate.firstTimeWindow_end;
		document.getElementById("editAnytimeSecondWindowStart").value = GlobalVars.tariffs[index].dcRatesSummer.AnyTimeDemandChargeRate.secondTimeWindow_start;
		document.getElementById("editAnytimeSecondWindowEnd").value = GlobalVars.tariffs[index].dcRatesSummer.AnyTimeDemandChargeRate.secondTimeWindow_end;
		
		document.getElementById("editPartialPeakTimeDCRate").value = GlobalVars.tariffs[index].dcRatesSummer.PartialPeakTimeDemandChargeRate.Value$kW;
		document.getElementById("editPartialPeakTimeFirstWindowStart").value = GlobalVars.tariffs[index].dcRatesSummer.PartialPeakTimeDemandChargeRate.firstTimeWindow_start;
		document.getElementById("editPartialPeakTimeFirstWindowEnd").value = GlobalVars.tariffs[index].dcRatesSummer.PartialPeakTimeDemandChargeRate.firstTimeWindow_end;
		document.getElementById("editPartialPeakTimeSecondWindowStart").value = GlobalVars.tariffs[index].dcRatesSummer.PartialPeakTimeDemandChargeRate.secondTimeWindow_start;
		document.getElementById("editPartialPeakTimeSecondWindowEnd").value = GlobalVars.tariffs[index].dcRatesSummer.PartialPeakTimeDemandChargeRate.secondTimeWindow_end;

		document.getElementById("editPeakTimeDCRate").value = GlobalVars.tariffs[index].dcRatesSummer.PeakTimeDemandChargeRate.Value$kW;
		document.getElementById("editPeakTimeFirstWindowStart").value = GlobalVars.tariffs[index].dcRatesSummer.PeakTimeDemandChargeRate.firstTimeWindow_start;
		document.getElementById("editPeakTimeFirstWindowEnd").value = GlobalVars.tariffs[index].dcRatesSummer.PeakTimeDemandChargeRate.firstTimeWindow_end;
		document.getElementById("editPeakTimeSecondWindowStart").value = GlobalVars.tariffs[index].dcRatesSummer.PeakTimeDemandChargeRate.secondTimeWindow_start;
		document.getElementById("editPeakTimeSecondWindowEnd").value = GlobalVars.tariffs[index].dcRatesSummer.PeakTimeDemandChargeRate.secondTimeWindow_end;

		// Winter DC Rates
		document.getElementById("editAnytimeDCRateWinter").value = GlobalVars.tariffs[index].dcRatesWinter.AnyTimeDemandChargeRate.Value$kW;
		document.getElementById("editAnytimeFirstWindowStartWinter").value = GlobalVars.tariffs[index].dcRatesWinter.AnyTimeDemandChargeRate.firstTimeWindow_start;
		document.getElementById("editAnytimeFirstWindowEndWinter").value = GlobalVars.tariffs[index].dcRatesWinter.AnyTimeDemandChargeRate.firstTimeWindow_end;
		document.getElementById("editAnytimeSecondWindowStartWinter").value = GlobalVars.tariffs[index].dcRatesWinter.AnyTimeDemandChargeRate.secondTimeWindow_start;
		document.getElementById("editAnytimeSecondWindowEndWinter").value = GlobalVars.tariffs[index].dcRatesWinter.AnyTimeDemandChargeRate.secondTimeWindow_end;
		
		document.getElementById("editPartialPeakTimeDCRateWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PartialPeakTimeDemandChargeRate.Value$kW;
		document.getElementById("editPartialPeakTimeFirstWindowStartWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PartialPeakTimeDemandChargeRate.firstTimeWindow_start;
		document.getElementById("editPartialPeakTimeFirstWindowEndWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PartialPeakTimeDemandChargeRate.firstTimeWindow_end;
		document.getElementById("editPartialPeakTimeSecondWindowStartWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PartialPeakTimeDemandChargeRate.secondTimeWindow_start;
		document.getElementById("editPartialPeakTimeSecondWindowEndWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PartialPeakTimeDemandChargeRate.secondTimeWindow_end;

		document.getElementById("editPeakTimeDCRateWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PeakTimeDemandChargeRate.Value$kW;
		document.getElementById("editPeakTimeFirstWindowStartWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PeakTimeDemandChargeRate.firstTimeWindow_start;
		document.getElementById("editPeakTimeFirstWindowEndWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PeakTimeDemandChargeRate.firstTimeWindow_end;
		document.getElementById("editPeakTimeSecondWindowStartWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PeakTimeDemandChargeRate.secondTimeWindow_start;
		document.getElementById("editPeakTimeSecondWindowEndWinter").value = GlobalVars.tariffs[index].dcRatesWinter.PeakTimeDemandChargeRate.secondTimeWindow_end;
	}
	
	function deleteTariffConfig(element) {

		if (!confirm("Are you sure you want to delete this tariff?")) {
			return false;
		}

		// reading the kWh/kW requested to be deleted
		var deletedTariff = element.id;

		var arrayOfObjects = [];
		arrayOfObjects.push(deletedTariff)

		var json = {
			"deletedTariffs" : arrayOfObjects
		};
		var domain = "DeleteTariff";
		sendJSONwithPOST(domain, json);
	};

	function deletePVConfig(element) {

		if (!confirm("Are you sure you want to delete this PV?")) {
			return false;
		}

		// reading the kWh/kW requested to be deleted
		var deletedPV = element.id;

		var arrayOfObjects = [];
		arrayOfObjects.push(deletedPV)

		var json = {
			"deletedPVs" : arrayOfObjects
		};
		var domain = "DeletePV";
		sendJSONwithPOST(domain, json);
	};

	function deleteOneLoad(element) {

		// check to have at least one load selected
		var load = element.id;

		// to double check if user wants to run this simulation
		if (!confirm("Are you sure you want to delete the selected load?")) {
			return false;
		}

		var arrayOfObjects = [];
		arrayOfObjects.push(load)

		var json = {
			"deletedLoads" : arrayOfObjects
		};
		var domain = "DeleteLoad";
		sendJSONwithPOST(domain, json);
	}

	function deleteLoad() {

		// check to have at least one load selected
		if (checkSelectedItems("loadConfig")) {
			alert("No load has been selected.");
			return false;
		}

		// to double check if user wants to run this simulation
		if (!confirm("Are you sure you want to delete the selected load(s)?")) {
			return false;
		}

		var arrayOfObjects = [];
		var loadConfig = document.getElementsByName("loadConfig");
		for (var j = 0; j < loadConfig.length; j++) {
			if (loadConfig[j].checked) {
				arrayOfObjects.push(loadConfig[j].value)
			}
		}

		var json = {
			"deletedLoads" : arrayOfObjects
		};
		var domain = "DeleteLoad";
		sendJSONwithPOST(domain, json);
	}

	function RunFileJson(type) {
		
		if (type == 1) {
			var numOfRequests = document.getElementById("numOfRequests").value;
			if (numOfRequests >= 5) {
				alert("Number of simulation requests cannot be more than five.");
				return false;
			}
		}

		// check to have at least one size selected
		if (checkSelectedItems("batteryConfig")) {
			alert("Simulation is terminated because no battery size is selected in System Configuration");
			return false;
		}

		// check to have at least one load selected
		if (checkSelectedItems("loadConfig")) {
			alert("Simulation is terminated because no load profile is selected in System Configuration.");
			return false;
		}

		// check to have at least one tariff selected
		if (checkSelectedItems("tariffConfig")) {
			alert("Simulation is terminated because no tariff profile is selected in System Configuration.");
			return false;
		}

		// check to have at least one PV selected
		if (document.getElementById("is_pv_used").checked) {
			if (checkSelectedItems("pvConfig")) {
				alert("Simulation is terminated because no PV profile is selected in System Configuration.");
				return false;
			}
		}
		
		// check if battery life analysis is enabled
		if (document.getElementById("is_blife_analysis_enabled").checked) {
			
			var batteryInputs = document.getElementsByName("batteryConfig");
			var loadInputs = document.getElementsByName("loadConfig");
			var tariffInputs = document.getElementsByName("tariffConfig");

			var bcounter = 0;
			var lcounter = 0;
			var tcounter = 0;
			var pcounter = 0;
			for (var i = 0; i < batteryInputs.length; i++) {
				if (batteryInputs[i].checked) {
					bcounter++;
				}
			}
			for (var i = 0; i < loadInputs.length; i++) {
				if (loadInputs[i].checked) {
					lcounter++;
				}
			}
			for (var i = 0; i < tariffInputs.length; i++) {
				if (tariffInputs[i].checked) {
					tcounter++;
				}
			}
			
			//PV
			if (document.getElementById("is_pv_used").checked) {
				var pvInputs = document.getElementsByName("pvConfig");
				for (var i = 0; i < pvInputs.length; i++) {
					if (pvInputs[i].checked) {
						pcounter++;
					}
				}
			} else {
				pcounter = 1;
			}
			
			// Nonsensitivity
			if (document.getElementById("is_load_var_enabled").checked) {
				alert("You cannot check sensitivity analysis when battery life analysis is checked.");
				return false;
			}

			if (bcounter == 1 && lcounter == 1 && tcounter == 1 && pcounter == 1) {
			}
			else {
				alert("You have to select only one battery, one load, and one tariff (and one PV if applicable).");
				return false;
			}
		}

		if (!posvaluecheck(document.getElementById("pvCapacity")))
			return false;

		if (checkValues() == false)
			return false;

		// browze and specify folder and create daily and monthly folders
		GlobalVars.currentSavedResultPath = "results";
		sendSimlationInfo(type);
	}

	function checkValues() {

		// check battery reserve capacity value
		if (!checkSensitiveParameters(document.getElementById("battResCap"), 1,
				90, 0))
			return false;

		// check battery reserve capacity value
		if (!checkSensitiveParameters(document.getElementById("DCTAdjusRatio"),
				1, 100, -100))
			return false;

		// check battery reserve capacity value
		if (!checkSensitiveParameters(document.getElementById("DCTHorizon"), 1,
				31, 1))
			return false;
	}

	function posvaluecheck(valueinput) {
		var val = valueinput.value;
		var patt2 = /^[0-9.]+$/;
		var patt1 = /[.]/g;

		if (!val.match(patt2)) {
			alert("Input must be a valid positive number for "
					+ valueinput.name);
			formreset(valueinput);
			return false;
		}

		var res = val.match(patt1);
		if (res) {
			if (res.length > 1) {
				alert("Input must be a valid positive number for "
						+ valueinput.name);
				formreset(valueinput);
				return false;
			}
		}

		return true;
	}

	function sendSimlationInfo(type) {

		var arrayOfObjects = [];
		var runType = "0";

		var lines;
		var batt_sizes_kWh = [];
		var batt_sizes_kW = [];

		// reading battery configuration from Battery_Config.csv file
		for (var i = 0; i < GlobalVars.listOfBattConfig.listOfkWh.length; i++) {
			batt_sizes_kWh.push(GlobalVars.listOfBattConfig.listOfkWh[i] * 1000 / 48);
			batt_sizes_kW.push(GlobalVars.listOfBattConfig.listOfkW[i]);
		}

		//var batteryConfig = document.forms[0];
		var batteryConfig = document.getElementsByName("batteryConfig");
		var loadConfig = document.getElementsByName("loadConfig");
		var tariffConfig = document.getElementsByName("tariffConfig");
		var pvConfig = document.getElementsByName("pvConfig");
		
		var txt = "";
		var i;
		var count = 0; // to count total number of combinations created for simulation
		var total_runs = 0; // to count total number of executable calls created

		var Month_raw = [ "jan", "feb", "mar", "apr", "may", "jun", "jul",
				"aug", "sep", "oct", "nov", "dec" ];

		var val;
		var lines = "@echo off\n";

		var get_EMSresult_type = 0;
		if (document.getElementById("saveEMSresults").checked) {
			get_EMSresult_type = 1;
		}
		
		// check if DR is selected
		var isDRUsed = false;
		var drName = "n/a";
		/*if (document.getElementById("is_dr_used").checked) {
			isDRUsed = "true";
			runType = "3";
		} else {
			isDRUsed = "false";
		}*/
		
		var isPVUsed = false;
		if (document.getElementById("is_pv_used").checked) {
			isPVUsed = true;
		} else {
			isPVUsed = false;
		}
		
		var isLoadVarEnabled = false;
		if (document.getElementById("is_load_var_enabled").checked) {
			isLoadVarEnabled = true;
		} else {
			isLoadVarEnabled = false;
		}
		
		var isBatteryLifeAnalysisEnabled = false;
		var blifeAnalysisModel = "n/a";
		var loadIncrementValue = 0.0;
		if (document.getElementById("is_blife_analysis_enabled").checked) {
			isBatteryLifeAnalysisEnabled = true;
			blifeAnalysisModel = document.getElementById("blife_analysis_option").value;
			loadIncrementValue = document.getElementById("loadIncrease").value;
		} else {
			isBatteryLifeAnalysisEnabled = false;
		}
		
		var isTOUEnabled = false;
		if (document.getElementById("is_tou_enabled").checked) {
			isTOUEnabled = true;
		} else {
			isTOUEnabled = false;
		}

		var startYEAR = -1000;
		var startMONTHN = -1000;
		var endMONTHN = -1000;

		for (var i = 0; i < batteryConfig.length; i++) {
			for (var j = 0; j < loadConfig.length; j++) {
				for (var k = 0; k < tariffConfig.length; k++) {
					if (document.getElementById("is_pv_used").checked) {

						runType = "1";
						
						var pvUtilFlag = 0;
						if (document.getElementById("is_pv_util_enabled").checked) 
							pvUtilFlag = 1;

						for (var m = 0; m < pvConfig.length; m++) {
							if (batteryConfig[i].checked
									&& loadConfig[j].checked
									&& tariffConfig[k].checked
									&& pvConfig[m].checked) {
								
								
								var simInfo;
								var config;
								var simConfig;

								var pvName = pvConfig[m].value;
								var pvCapacity = document
										.getElementById("pvCapacity").value;

								for (var l = 0; l < GlobalVars.loads.length; l++) {
									if (GlobalVars.loads.loadName[l] == loadConfig[j].value) {
										startYEAR = GlobalVars.loads.startYear[l];
										startMONTHN = GlobalVars.loads.startMonth[l];
									}
								}
								
								var pvStartMonth = -1;
								for (var pvIndex = 0; pvIndex < GlobalVars.PVs.pvName.length; pvIndex++) {
									if (GlobalVars.PVs.pvName[pvIndex] == pvConfig[m].value) {
										pvStartMonth = GlobalVars.PVs.startMonth[pvIndex];
									}
								}
								
								if (pvStartMonth != startMONTHN) {
									alert("The start month of PV [" + pvConfig[m].value + "] does not match with the start month of the load [" + loadConfig[j].value + "]. The start month of PV and Load must be the same.");
									return;
								}


								// check if required load and tariff files exist
								if (startMONTHN == 1) {
									endMONTHN = 12;
								} else {
									endMONTHN = startMONTHN - 1;
								}

								config = {
									"BattratedAh" : batt_sizes_kWh[i],
									"BattratedVolt" : 48,
									"BattMinSoC" : document
											.getElementById("battMinSOC").value,
									"BattMaxSoC" : document
											.getElementById("battMaxSOC").value,
									"BattInitSoC" : document
											.getElementById("battInitSOC").value,
									"BatteryMaxPower" : batt_sizes_kW[i],
									"BatteryReserveCapacity" : document
											.getElementById("battResCap").value,
									"DCTAdjustmentRatio" : document
											.getElementById("DCTAdjusRatio").value,
									"DCTHorizon" : document
											.getElementById("DCTHorizon").value,
									"RoundTripEff" : document.getElementById("roundTripEff").value,
									"DegradationCost" : document
											.getElementById("battDeg").value
								};
								simConfig = {
									"LoadName" : loadConfig[j].value,
									"TariffName" : tariffConfig[k].value,
									"StartYear" : startYEAR,
									"StartMonth" : startMONTHN,
									"noOfMonth" : 12,
									"startMonthSimulation" : Month_raw[startMONTHN - 1],
									"endMonthSimulation" : Month_raw[endMONTHN - 1],
									"SummerType" : GlobalVars.tariffsSummerType[$
											.inArray(tariffConfig[k].value,
													GlobalVars.listOfTariffs)],
									"EMSresults" : get_EMSresult_type,
									"CurrentResultPath" : GlobalVars.currentSavedResultPath,
									"isPVUsed" : "true",
									"isDRUsed" : isDRUsed,
									"PVName" : pvName,
									"PVCapacity" : pvCapacity,
									"PVUtilizationFlag" : pvUtilFlag,
									"DRName" : drName,
									"TOUFlag" : isTOUEnabled,
									"isBatteryLifeAnalyzed" : isBatteryLifeAnalysisEnabled,
									"BatteryLifeAnalysisModel": blifeAnalysisModel,
									"LoadIncrementValue" : loadIncrementValue
									//"Monthly_method" : "1"
								};

								var date = new Date();
								var simulation = {
									"SimulationID" : "sim_"
											+ Math
													.round(Math.random() * 100000000000),
									"Config" : config,
									"Simulation_Config" : simConfig
								};
								arrayOfObjects.push(simulation);
							}
						}
					} else {
						if (batteryConfig[i].checked && loadConfig[j].checked
								&& tariffConfig[k].checked) {

							var simInfo;
							var config;
							var simConfig;

							for (var l = 0; l < GlobalVars.loads.length; l++) {
								if (GlobalVars.loads.loadName[l] == loadConfig[j].value) {
									startYEAR = GlobalVars.loads.startYear[l];
									startMONTHN = GlobalVars.loads.startMonth[l];
								}
							}

							// check if required load and tariff files exist
							if (startMONTHN == 1) {
								endMONTHN = 12;
							} else {
								endMONTHN = startMONTHN - 1;
							}

							config = {
								"BattratedAh" : batt_sizes_kWh[i],
								"BattratedVolt" : 48,
								"BattMinSoC" : document
										.getElementById("battMinSOC").value,
								"BattMaxSoC" : document
										.getElementById("battMaxSOC").value,
								"BattInitSoC" : document
										.getElementById("battInitSOC").value,
								"BatteryMaxPower" : batt_sizes_kW[i],
								"BatteryReserveCapacity" : document
										.getElementById("battResCap").value,
								"DCTAdjustmentRatio" : document
										.getElementById("DCTAdjusRatio").value,
								"DCTHorizon" : document
										.getElementById("DCTHorizon").value,
								"RoundTripEff" : document
										.getElementById("roundTripEff").value,
								"DegradationCost" : document
										.getElementById("battDeg").value
							}
							simConfig = {
								"LoadName" : loadConfig[j].value,
								"TariffName" : tariffConfig[k].value,
								"StartYear" : startYEAR,
								"StartMonth" : startMONTHN,
								"noOfMonth" : 12,
								"startMonthSimulation" : Month_raw[startMONTHN - 1],
								"endMonthSimulation" : Month_raw[endMONTHN - 1],
								"SummerType" : GlobalVars.tariffsSummerType[$
										.inArray(tariffConfig[k].value,
												GlobalVars.listOfTariffs)],
								"EMSresults" : get_EMSresult_type,
								"CurrentResultPath" : GlobalVars.currentSavedResultPath,
								"isPVUsed" : "false",
								"isDRUsed" : isDRUsed,
								"PVName" : "n/a",
								"PVCapacity" : "n/a",
								"PVUtilizationFlag" : 0,
								"DRName" : drName,
								"TOUFlag" : isTOUEnabled,
								"isBatteryLifeAnalyzed" : isBatteryLifeAnalysisEnabled,
								"BatteryLifeAnalysisModel": blifeAnalysisModel,
								"LoadIncrementValue" : loadIncrementValue
							}

							var date = new Date();
							var simulation = {
								"SimulationID" : "sim_"
										+ Math
												.round(Math.random() * 100000000000),
								"Config" : config,
								"Simulation_Config" : simConfig
							};
							arrayOfObjects.push(simulation);
						}
					}
				}
			}
		}

		var simConfigAPAC = {
			"isDCAPACTariffRule" : "false",
			"NumberOfMonths" : "12",
			"DCRateAPAC" : "16.84",
			"StorageContract" : "0",
			"NoStorageContract" : "273.1"
		};
		
		var is_dc_based_on_apac_rates = document.getElementById("is_dc_based_on_apac_rates");
		if (is_dc_based_on_apac_rates.checked) {
			//alert("is_dc_based_on_apac_rates is checked");
			runType = "2";
			simConfigAPAC = {
				"isDCAPACTariffRule" : "true",
				"NumberOfMonths" : document
						.getElementById("number_of_months_for_contract_calculation").value,
				"DCRateAPAC" : document.getElementById("dc_rate_apac").value,
				"StorageContract" : document.getElementById("storage_contract").value,
				"NoStorageContract" : document.getElementById("no_storage_contract").value
			};
		}

		var jsonObj = {
			"JSONRequestID" : "JSON_"
					+ Math.round(Math.random() * 100000000000),
			"username" : username,
			"runType" : runType,
			"isLoadVariationEnabled" : isLoadVarEnabled,
			"isBatteryLifeAnalysisEnabled" : isBatteryLifeAnalysisEnabled,
			"BatteryLifeAnalysisModel": blifeAnalysisModel,
			"loadIncrease" : loadIncrementValue,
			"isTOUEnabled" : isTOUEnabled,
			"isPVUsed" : isPVUsed,
			"isDRUsed" : isDRUsed,
			"simInfo" : arrayOfObjects,
			"simConfigAPAC" : simConfigAPAC
		};

		if (type == 0) {
			sendJSONwithPOST("RunEMS", jsonObj);			
		} else if (type == 1) {
			sendJSONwithPOST("AddRun", jsonObj);						
		} else {
			alert("Type of Run is not categorized.");
		}
	}

	function sendJSONwithPOST(domain, jsonObj) {

		// Sending and receiving data in JSON format using POST mothod
		var xhr = new XMLHttpRequest();
		var url = "/EMSOperationsEngine/btmEMS.do" + "?domain=" + domain
				+ "&username=" + username;
		xhr.open("POST", url, true);
		xhr.setRequestHeader("Content-type", "application/json");
		xhr.onreadystatechange = function() {
			if (xhr.readyState == 4 && xhr.status == 200) {
				if (domain == "DeleteTariff" || domain == "DeleteLoad" || domain == "DeletePV") {
					
					var jData = JSON.parse(xhr.responseText);

					if (jData.isProcessed == "true") {
						getAllConfigData();
						alert("Deleting load/tariff/pv complete!");
					} else {
						alert(jData.reason);
					}
				
					//getAllConfigData();
					//alert("Deleting load/tariff/pv complete!");
				} else if (domain == "RunEMS") {
					alert("Simulation has started!");
					getProgStatus();
				} else if (domain == "AddRun") {
					alert("Simulation Request has been added to the queue!");
				}
			}
		}
		var data = JSON.stringify(jsonObj);
		xhr.send(data);
	}

	function terminateEMS() {
		var req = null;
		if (window.XMLHttpRequest)
			req = new XMLHttpRequest();
		else
			req = new ActiveXObject("Microsoft.XMLHTTP");
		req.open("POST", "/EMSOperationsEngine/btmEMS.do?domain=StopEMS&uname="
				+ username, true);
		req.onreadystatechange = function() {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {
					var value = req.responseText;
					//if (value == '200')
					alert("The simulation has successfully terminated.");
					//else alert("Failed to terminate the simulation");
				}
			}
		}
		req.send(null);
	}
	
	function addRun() {
		var req = null;
		if (window.XMLHttpRequest) req = new XMLHttpRequest();
		else req = new ActiveXObject("Microsoft.XMLHTTP");
		req.open("POST", "/EMSOperationsEngine/btmEMS.do?domain=AddRun&uname="
				+ username, true);
		req.onreadystatechange = function() {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {
					var value = req.responseText;
					alert("The simulation request has successfully been added.");
					//else alert("Failed to terminate the simulation");
				}
			}
		}
		req.send(null);
	}

	// defining trim() function in IE7
	if (typeof String.prototype.trim !== 'function') {
		String.prototype.trim = function() {
			return this.replace(/^\s+|\s+$/g, '');
		}
	}

	// enabling/disabling advanced settings input boxes
	function isDCBasedOnAPACRates(elem) {

		var childrenAllText = document.getElementsByClassName("apacSettings");
		var selectedMode = true;
		if (elem.checked) {
			selectedMode = false;
			deselectAll("tariff");
			var tariffConfig = document.getElementsByName("tariffConfig");
			tariffConfig[0].checked = true;

			for (var i = 0; i < tariffConfig.length; i++) {
				if (tariffConfig[i].value == "E20S") {
					deselectAll("tariff");	
					tariffConfig[i].checked = true;
				}
				if (tariffConfig[i].value == "ratchet") {
					deselectAll("tariff");
					tariffConfig[i].checked = true;
					break;
				}
			}
			document.getElementById("dcContractTable").style.display = "block";
			document.getElementById("tariff-list").style.display = "none";
		} else {
			document.getElementById("dcContractTable").style.display = "none";
			deselectAll("tariff");
			document.getElementById("tariff-list").style.display = "block";
		}

		for (var i = 0; i < childrenAllText.length; i++) {
			childrenAllText[i].disabled = selectedMode;
		}
	};

	function isPVUsed(elem) {
		//var childrenAllText = document.getElementsByClassName("pvSettings");
		var childrenAllText = document.getElementsByName("pvConfig");
		var selectedMode = true;
		if (elem.checked) {
			selectedMode = false;
			document.getElementById("pvTable").style.display = "inline";
			//document.getElementById("is_dr_used").checked = false;
			//document.getElementById("is_dr_used").disabled = true;
		} else {
			document.getElementById("pvTable").style.display = "none";
			document.getElementById("is_pv_util_enabled").checked = false;
			//document.getElementById("is_dr_used").disabled = false;
		}

		for (var i = 0; i < childrenAllText.length; i++) {
			childrenAllText[i].disabled = selectedMode;
		}
	}
	
	function isDRUsed(elem) {
		//var childrenAllText = document.getElementsByName("drConfig");
		//var selectedMode = true;
		if (elem.checked) {
			
			document.getElementById("is_pv_used").checked = false;
			document.getElementById("is_pv_used").disabled = true;
			
			//selectedMode = false;
			//document.getElementById("pvTable").style.display = "none";
			//document.getElementById("drTable").style.display = "inline";
		} else {
			document.getElementById("is_pv_used").disabled = false;
			//document.getElementById("drTable").style.display = "none";
		}

		for (var i = 0; i < childrenAllText.length; i++) {
			childrenAllText[i].disabled = selectedMode;
		}
	}

	function advancedSettings(elem) {
		var childrenAllText = document.getElementsByClassName("advSettings");
		var selectedMode = true;
		if (elem.checked) {
			selectedMode = false;
			document.getElementById("advancedBatterySettingTable").style.display = "inline";
		} else {
			document.getElementById("advancedBatterySettingTable").style.display = "none";
		}

		for (var i = 0; i < childrenAllText.length; i++) {
			childrenAllText[i].disabled = selectedMode;
		}
	};
</script>

<script>
	var cost_annual_summary = [];
	var categories = [];
	var type = 0;

	function outputTabAction() {
		getData();
	}

	function getData() {
		var req;
		if (window.XMLHttpRequest) {
			req = new XMLHttpRequest();
		} else {
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}
		//	req.open("GET", "/getCostAnnualSummary?uname=" + username, true);
		req.open("GET",
				"/EMSOperationsEngine/btmEMS.do?domain=CostAnnualSummary&uname="
						+ username, true);
		req.onreadystatechange = function() {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {
					convertCSVtoArray(req.responseText);
					updateSelectSection();
				}
			}
		}
		req.send(null);
	}

	function convertCSVtoArray(str) {
		if (str.slice(-1) == "\n") {
			str = str.slice(0, -1);
		}
		var tmp = str.split("\n"); // Produce of array split by line
		for (var i = 0; i < tmp.length; ++i) {
			if (i != 0) {
				cost_annual_summary[i - 1] = tmp[i].split(',');
			}
		}
		for (var i = 0; i < cost_annual_summary.length; ++i) {
			for (var j = 0; j < cost_annual_summary[i].length; ++j) {
				cost_annual_summary[i][j] = String(cost_annual_summary[i][j])
						.replace(/\s+/g, '');
			}
		}
	}

	function updateSelectSection() {

		SelectionReset();

		// for output menu for load view
		var iText = document.createElement('p');
		var iText2 = document.createElement('p');
		var str, str2;
		var categorySelect = document.getElementById("category-option");
		var categorySelect2 = document.getElementById("category-option2");

		var insert1 = "(Select Category)";
		str = "<select id='category-select' name='parentDDM' onchange='getDDMvals()'><option value=''>"
				+ insert1 + "</option>";
		str2 = "<select id='category-select2' name='parentDDM2' onchange='getDDMvals3()'><option value=''>"
				+ insert1 + "</option>";

		categories = [];
		for (var i = 0; i < cost_annual_summary.length; i++) {
			if (i == 0) {
				var newCategory = {
					'categoryID' : cost_annual_summary[i][20],
					'Min_SOC' : cost_annual_summary[i][5],
					'Max_SOC' : cost_annual_summary[i][6],
					'Batt_Eff' : cost_annual_summary[i][7],
					'Batt_Aging_Cost' : cost_annual_summary[i][8],
					'Init_SOC' : cost_annual_summary[i][9],
					'Batt_Reserve' : cost_annual_summary[i][10],
					'DCT_Adj' : cost_annual_summary[i][11],
					'DCT_Hor' : cost_annual_summary[i][12]
				}
				categories.push(newCategory);
			}

			var flag = true;
			for (var j = 0; j < categories.length; j++) {
				var category = categories[j];
				if (category['categoryID'] == cost_annual_summary[i][20]) {
					flag = false;
					break;
				}
			}
			if (flag == true) {
				var newCategory = {
					'categoryID' : cost_annual_summary[i][20],
					'Min_SOC' : cost_annual_summary[i][5],
					'Max_SOC' : cost_annual_summary[i][6],
					'Batt_Eff' : cost_annual_summary[i][7],
					'Batt_Aging_Cost' : cost_annual_summary[i][8],
					'Init_SOC' : cost_annual_summary[i][9],
					'Batt_Reserve' : cost_annual_summary[i][10],
					'DCT_Adj' : cost_annual_summary[i][11],
					'DCT_Hor' : cost_annual_summary[i][12]
				}
				categories.push(newCategory);
			}
		}

		for (var i = 0; i < categories.length; i++) {
			var category = categories[i];
			var categoryID = category['categoryID'];
			var insert2 = "Min SOC: " + category['Min_SOC'] + ", Max SOC: "
					+ category['Max_SOC'] + ", Battery Eff: "
					+ category['Batt_Eff'] + ", Battery Aging Cost: "
					+ category['Batt_Aging_Cost'] + ", Initial SOC: "
					+ category['Init_SOC'] + ", Battery Reserve: "
					+ category['Batt_Reserve'] + ", DCT Adj: "
					+ category['DCT_Adj'] + ", DCT Hor: " + category['DCT_Hor'];
			str += "<option title='" + insert2 + "' value=" + categoryID + "> "
					+ categoryID + "</option>";
			str2 += "<option title='" + insert2 + "' value=" + categoryID + "> "
					+ categoryID + "</option>";
		}

		str += "</select>";
		str2 += "</select>";
		iText.innerHTML = str;
		iText2.innerHTML = str2;

		categorySelect.appendChild(iText);
		categorySelect2.appendChild(iText2);
	}

	function updateSelectSection(resultFolders) {

		var nodelist = document.getElementById("load-select-insert");
		var len = nodelist.childNodes.length;
		if (len >= 1) {
			for (var i = 0; i < len; i++)
				nodelist.removeChild(nodelist.childNodes[0]);
		}

		nodelist = document.getElementById("tariff-select-insert");
		var len = nodelist.childNodes.length;
		if (len >= 1) {
			for (var i = 0; i < len; i++)
				nodelist.removeChild(nodelist.childNodes[0]);
		}

		// for output menu for load view
		document.getElementById("download-loadname").value = GlobalVars.listOfLoads[0];
		var iText4 = document.createElement('p');
		var loadSelect = document.getElementById("load-select-insert");
		
		var str4 = "<select id='load-download' onchange='downloadLoadProfile()'>";
		//str4 += "<option title='Select Loadname' value='NotSelected'>--- Select Load ---</option>";
		for (var i = 0; i < GlobalVars.loads.length; i++) {
			str4 += "<option title='" + insert1 + "' value=" + GlobalVars.listOfLoads[i] + "> "
					+ GlobalVars.listOfLoads[i] + "</option>";
		}
		str4 += "</select>";
		iText4.innerHTML = str4;
		loadSelect.appendChild(iText4);

		// for output menu for load view
		var insert1 = "";
		document.getElementById("uname1").value = username;
		document.getElementById("download-tariffname").value = GlobalVars.listOfTariffs[0];
		var iText5 = document.createElement('p');
		var tariffSelect = document.getElementById("tariff-select-insert");
		var str5 = "<select id='tariff-download' onchange='downloadTariffProfile()'>";
		for (var i = 0; i < GlobalVars.listOfTariffs.length; i++) {
			str5 += "<option title='" + insert1 + "' value=" + GlobalVars.listOfTariffs[i] + "> "
					+ GlobalVars.listOfTariffs[i] + "</option>";
		}
		str5 += "</select>";
		iText5.innerHTML = str5;
		tariffSelect.appendChild(iText5);

	}

	function graphicsPlot() {

		PlotReset();

		var x = document.getElementById("load-select").value;
		var y = document.getElementById("tariff-select").value;
		//TODO
		if (document.getElementById("category-select") == null) {
			alert("Please analyze results first!");
			return;
		}
		var z = document.getElementById("category-select").value;

		var load_tariff_cost_summary = [];
		for (var i = 0; i < cost_annual_summary.length; ++i) {
			if (x == cost_annual_summary[i][0]
					&& y == cost_annual_summary[i][1]
					&& z == cost_annual_summary[i][20]) {
				load_tariff_cost_summary.push(cost_annual_summary[i]); //alert(cost_annual_summary[i]);
			}
		}

		var category;
		for (var i = 0; i < categories.length; ++i) {
			if (categories[i]['categoryID'] == z) {
				category = categories[i];
				break;
			}
		}

		var charData1 = [];
		var charData2 = [];
		var charData3 = [];
		var charData4 = [];
		var seriesData = [];
		var annualDCBaseCost = -1;

		for (var i = 0; i < load_tariff_cost_summary.length; ++i) {

			annualDCBaseCost = load_tariff_cost_summary[i][13];

			var color = returnColorBatterySize(load_tariff_cost_summary[i][3]);

			charData1.push({
				"method" : load_tariff_cost_summary[i][3] + "/"
						+ load_tariff_cost_summary[i][4],
				"cost" : roundNumber(load_tariff_cost_summary[i][8], 3),
				"color" : color
			});

			charData2
					.push({
						"method" : load_tariff_cost_summary[i][3] + "/"
								+ load_tariff_cost_summary[i][4],
						"perfectcost" : roundNumber(
								load_tariff_cost_summary[i][14], 3),
						"predictioncost" : roundNumber(
								load_tariff_cost_summary[i][15], 3),
						"percentage" : roundNumber(
								load_tariff_cost_summary[i][16], 3),
						"color" : color
					});

			charData3.push({
				"method" : load_tariff_cost_summary[i][3] + "/"
						+ load_tariff_cost_summary[i][4],
				"cost" : roundNumber(load_tariff_cost_summary[i][19], 3), //roundNumber(load_tariff_cost_summary[i][9]/(load_tariff_cost_summary[i][3]*2), 3),
				"color" : color
			});

			charData4.push([ roundNumber(load_tariff_cost_summary[i][10], 2),
					roundNumber(load_tariff_cost_summary[i][7], 3),
					Number(load_tariff_cost_summary[i][3]) ]);

			seriesData.push({
				name : load_tariff_cost_summary[i][2],
				//color : 'rgba(255, 0, ' + i*10 + ', 0.8)', //'red',
				data : [ [ roundNumber(load_tariff_cost_summary[i][19], 2),
						roundNumber(load_tariff_cost_summary[i][15], 3) ] ]
			});
		}

		var iText = document.createElement('p');
		var str;
		document.getElementById('batSetting1').appendChild(iText);
		str = "<table border='1'>"
				+ "<tr><td><p>Minimum Battery SOC (%): </p></td><td style='width:50px'><p>"
				+ category['Min_SOC']
				+ "</p></td> <td><p>Maximum Battery SOC (%): </p></td><td style='width:50px'><p>"
				+ category['Max_SOC']
				+ "</p></td></tr>"
				+ "<tr><td><p>Battery Round-Trip Efficiency (%): </p></td><td style='width:50px'><p>"
				+ category['Batt_Eff']
				+ "</p></td> <td><p>Battery Aging Cost ($/kWh throughput): </p></td><td style='width:50px'><p>"
				+ category['Batt_Aging_Cost']
				+ "</p></td></tr>"
				+ "<tr><td><p>Battery Initial SOC (%): </p></td><td style='width:50px'><p>"
				+ category['Init_SOC']
				+ "</p></td> <td><p>Battery Reserve Capacity (%): </p></td><td style='width:50px'><p>"
				+ category['Batt_Reserve']
				+ "</p></td></tr>"
				+ "<tr><td><p>DCT Adjustment Ratio (%): </p></td><td style='width:50px'><p>"
				+ category['DCT_Adj']
				+ "</p></td> <td><p>No. of days from past for DCT correction: </p></td><td style='width:50px'><p>"
				+ category['DCT_Hor'] + "</p></td></tr>" + "</table>"
		iText.innerHTML = str;

		if (annualDCBaseCost != -1) {
			var iText = document.createElement('p');
			var str;
			document.getElementById('costNotes').appendChild(iText);
			str = "<b>- Annual Demand Charge Base Cost: $" + annualDCBaseCost
					+ "</b>"
			iText.className = "titles";
			iText.innerHTML = str;
		}

		if (charData2.length != 0) {
			var iText = document.createElement('p');
			iText.className = "titles";
			iText.innerHTML = "- Annual DC Saving (Prediction Scenario)";
			document.getElementById('costPredictionSavingPlot').appendChild(
					iText);
			var iDiv = document.createElement('div');
			iDiv.id = 'batteryview2';
			iDiv.className = "plotBlockSmall";
			document.getElementById('costPredictionSavingPlot').appendChild(
					iDiv);
			costcompPlot2(charData2);
		}
		if (charData3.length != 0) {
			var iText = document.createElement('p');
			iText.className = "titles";
			iText.innerHTML = "- Annual Battery Usage Cost (Prediction Scenario)";
			document.getElementById('totalPowerPlot').appendChild(iText);
			var iDiv = document.createElement('div');
			iDiv.id = 'batteryview3';
			iDiv.className = "plotBlockSmall";
			document.getElementById('totalPowerPlot').appendChild(iDiv);
			costcompPlot3(charData3);
		}

		if (seriesData.length != 0) {
			var iText = document.createElement('p');
			iText.className = "titles";
			iText.innerHTML = "- Annual Cycles vs DC Saving (Prediction Scenario)";
			document.getElementById('cycleSavings').appendChild(iText);
			var iDiv = document.createElement('div');
			iDiv.id = 'cycleview';
			iDiv.className = "plotBlockSmall";
			document.getElementById('cycleSavings').appendChild(iDiv);
			cycleviewPlot(seriesData);
		}
	}

	function graphicsPlot2() {

		PlotReset2();

		var x = document.getElementById("battery-select").value;
		var y = document.getElementById("tariff-select2").value;

		if (document.getElementById("category-select2") == null) {
			alert("Please analyze results first!");
			return;
		}
		var z = document.getElementById("category-select2").value;

		if (x == "" || y == "" || z == "") {
			alert("Error: please select parameters!");
			return;
		}

		var load_tariff_cost_summary = [];
		for (var i = 0; i < cost_annual_summary.length; ++i) {
			if (x == cost_annual_summary[i][2]
					&& y == cost_annual_summary[i][1]
					&& z == cost_annual_summary[i][20]) {
				load_tariff_cost_summary.push(cost_annual_summary[i]);
			}
		}

		var category;
		for (var i = 0; i < categories.length; ++i) {
			if (categories[i]['categoryID'] == z) {
				category = categories[i];
				break;
			}
		}

		var charData1 = [];
		var charData2 = [];
		var charData3 = [];
		for (var i = 0; i < load_tariff_cost_summary.length; ++i) {

			var color = "#87CEFA";

			charData1.push({
				"method" : load_tariff_cost_summary[i][0],
				"cost" : roundNumber(load_tariff_cost_summary[i][8], 3),
				"color" : color
			});

			charData2
					.push({
						"method" : load_tariff_cost_summary[i][0],
						"perfectcost" : roundNumber(
								load_tariff_cost_summary[i][14], 3),
						"predictioncost" : roundNumber(
								load_tariff_cost_summary[i][15], 3),
						"percentage" : roundNumber(
								load_tariff_cost_summary[i][16], 3),
						"color" : color
					});

			charData3.push({
				"method" : load_tariff_cost_summary[i][0],
				"cost" : roundNumber(load_tariff_cost_summary[i][19], 3),
				"color" : color
			});
		}

		var iText = document.createElement('p');
		var str;
		document.getElementById('batSetting2').appendChild(iText);
		str = "<table border='1'>"
				+ "<tr><td><p>Minimum Battery SOC (%): </p></td><td style='width:50px'><p>"
				+ category['Min_SOC']
				+ "</p></td> <td><p>Maximum Battery SOC (%): </p></td><td style='width:50px'><p>"
				+ category['Max_SOC']
				+ "</p></td></tr>"
				+ "<tr><td><p>Battery Round-Trip Efficiency (%): </p></td><td style='width:50px'><p>"
				+ category['Batt_Eff']
				+ "</p></td> <td><p>Battery Aging Cost ($/kWh throughput): </p></td><td style='width:50px'><p>"
				+ category['Batt_Aging_Cost']
				+ "</p></td></tr>"
				+ "<tr><td><p>Battery Initial SOC (%): </p></td><td style='width:50px'><p>"
				+ category['Init_SOC']
				+ "</p></td> <td><p>Battery Reserve Capacity (%): </p></td><td style='width:50px'><p>"
				+ category['Batt_Reserve']
				+ "</p></td></tr>"
				+ "<tr><td><p>DCT Adjustment Ratio (%): </p></td><td style='width:50px'><p>"
				+ category['DCT_Adj']
				+ "</p></td> <td><p>No. of days from past for DCT correction: </p></td><td style='width:50px'><p>"
				+ category['DCT_Hor'] + "</p></td></tr>" + "</table>"
		//iText.className = "titles";
		iText.innerHTML = str;

		var iText = document.createElement('p');
		iText.className = "titles";
		iText.innerHTML = "- Annual DC Saving (Prediction Scenario)";
		document.getElementById('costPredictionSavingPlot2').appendChild(iText);
		var iDiv = document.createElement('div');
		iDiv.id = 'loadview2';
		iDiv.className = "plotBlockSmall";
		document.getElementById('costPredictionSavingPlot2').appendChild(iDiv);
		loadviewPlot2(charData2);

		var iText = document.createElement('p');
		iText.className = "titles";
		iText.innerHTML = "- Annual Battery Usage Cost (Prediction Scenario)";
		document.getElementById('totalPowerPlot2').appendChild(iText);
		var iDiv = document.createElement('div');
		iDiv.id = 'loadview3';
		iDiv.className = "plotBlockSmall";
		document.getElementById('totalPowerPlot2').appendChild(iDiv);
		loadviewPlot3(charData3);

		return;
	}
</script>

<style>

#myProgress {
	width: 90%;
	background-color: #ddd;
}

#myBar {
	width: 0%;
	height: 30px;
	background-color: #4CAF50;
	text-align: center;
	line-height: 30px;
	color: white;
}

.my-help-tariff {
	position: absolute;
	top: 110%;
	left:0;
	background: #dfdfdf;
	border:1px solid #aaa;
	z-index:99999;
	opacity:0;
	max-width:200px;
	width:200px;
	font-size: 12px;
	padding: 7px;
}

.batt-config-list {
	width: 180px;
	display: inline-block;
}

.load-config-list {
	width: 240px;
	display: inline-block;
}

.tariff-config-list {
	width: 250px;
	display: inline-block;
}

.pv-config-list {
	width: 250px;
	display: inline-block;
}

.tariff-label {
	position: relative;
	display: block;
	*zoom: 1;
	padding: 3px 5px;
	margin-bottom: 5px;
}

.delete-tariff-config {
	background: #ccc;
	color: black;
	display: none;
	position: inline;
	margin-left: 10px;
	padding: 1px 4px;
	margin-top: -10px;
	font-size: 12px;
	display: none;
}

.tariff-label:hover .delete-tariff-config {
	display: inline;
}

.delete-load-config {
	background: #ccc;
	color: black;
	display: none;
	position: inline;
	margin-left: 10px;
	padding: 1px 4px;
	margin-top: -10px;
	font-size: 12px;
	display: none;
}

.load-label:hover .delete-load-config {
	display: inline;
}

.delete-load-config:hover {
	cursor: pointer;
	background: red;
	color: white;
}

.button {
	background-color: #4CAF50; /* Green */
	border: none;
	color: white;
	padding: 7px 16px;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	font-size: 13px;
	margin: 3px 1px;
	cursor: pointer;
}

.button2 {
	background-color: #008CBA;
} /* Blue */
.button3 {
	background-color: #f44336;
} /* Red */
.button4 {
	background-color: #e7e7e7;
	color: black;
} /* Gray */
.button5 {
	background-color: #555555;
} /* Black */
.section-container {
	background-color: rgba(255, 255, 255, 0.9);
}

#selectInterval {
	width: 184px;
	height: 30px;
}

#selectIntervalPV {
	width: 184px;
	height: 30px;
}

#selectSummerType {
	width: 260px;
	height: 30px;
}

.apacSettings {
	width: 80px;
}

hr {
	border: 0;
	clear: both;
	display: block;
	width: 99%;
	border-color: green;
	background-color: green;
	height: 1px;
}
</style>

</html>

