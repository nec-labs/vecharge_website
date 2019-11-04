<!DOCTYPE html>
<html lang="en">

<head>
<title>NEC EMS Output</title>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<link rel="stylesheet" href="../css/MyStyleSheet.css">
<link rel="stylesheet" href="../css/Sidebarstyles.css">
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<link href="../css/half-slider.css" rel="stylesheet">
<link href="../css/login.css" rel="stylesheet">

<script src="https://code.jquery.com/jquery-1.10.2.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<script src="https://www.google.com/jsapi"></script>
<script src="../js/Sidebarscript.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/moment.js/2.10.3/moment.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.0.272/jspdf.debug.js"></script>

<style>
article, aside, figure, footer, header, hgroup, menu, nav, section { display: block; }*{margin:0;padding:0;}
ul{list-style:none;}
a{text-decoration:none;}
.product-pic{
	position:relative;
	background:#eee;
	width:130px;
	height:100px;
	overflow:hidden;
}
.grid-add-cart{
	position:absolute;
	top:220px;
	height:inherit;
	width:inherit;
	background:rgba(128, 128, 128, 0.50);
}
h3 { 
	display: block;
	font-size: 1em;
	margin-top: 1em;
	margin-bottom: 1em;
	margin-left: 3%;
	margin-right: 0;
	font-weight: bold;
}
table, th, td {
	border: 2px hidden black;
	alignment-adjust: central;
}
</style>
</head>

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
 
<script>
	var username = '<%= (String) session.getAttribute("username") %>';
	var password = '<%= (String) session.getAttribute("password") %>';
	var emsResultID = "demo";
	var emsResultTariff = "E20S";
	var batterySize = "425kWh/100kW";
	var loadName = "100_school";
	var pvName = "n/a";
	var pvCapacity = "n/a";
	var pvUtilFlag = 0;
	var drName = "n/a";
	var touFlag = false;
	var bLifeFlag = false;
	var loadIncrementVal = 0.0;	
	var ipAddress = '{{ ipAddress }}';
	var jData = null;
</script>

<body>
	<!---------- Header Information ---------->
	<div class="container" id="navmain">
    	<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        	<div class="container-fluid">
            	<div class="navbar-header">
            		<a class="navbar-brand active" href="/EMSOperationsEngine/LoginForm.jsp"><i class="fa fa-plug"></i> NEC EMS BTM Application</a>
            	</div>
				<!-- Insert loggedinnavbar.jsp -->
            	<ul class="nav navbar-nav" style="float: none !Important;">
					<li><a href="NECEMS_Main.jsp"><font size="4"><span class="glyphicon glyphicon-cog"></span>Input</font></a></li>
					<li><a href="SizingAnalysis.jsp"><font size="4"><span class="fa fa-database"></span>Sizing Analysis</font></a></li>
					<li><a href="LogPage.jsp"><font size="4" color="white"><span class="fa fa-bar-chart"></span>Output</font></a></li>
					<li><a href="FAQ.jsp"><font size="4"><i class="fa fa-question-circle"></i>FAQ</font></a></li>
					<li style="float: right; margin-right: 5%"><a href="/EMSOperationsEngine/LoginForm.jsp"><font size="4"><span class="glyphicon glyphicon-home"></span> Logout</font></a></li>
				</ul>
        	</div>
    	</nav>
	</div>
	<!---------- Header Information ---------->
	<br>
	<br>
	<!---------- Menu Information ---------->
	<div id='cssmenu'>
		<ul>
			<li id="logsummary">
				<a href='#'><span>Summary</span></a>
			</li>
			
			<li class='has-sub'>
				<a href='#'><span>Savings</span></a>
				<ul>
					<li id="plotSavingsJan"><a href='#'><span>January</span></a></li>
					<li id="plotSavingsFeb"><a href='#'><span>February</span></a></li>
					<li id="plotSavingsMar"><a href='#'><span>March</span></a></li>
					<li id="plotSavingsApr"><a href='#'><span>April</span></a></li>
					<li id="plotSavingsMay"><a href='#'><span>May</span></a></li>
					<li id="plotSavingsJun"><a href='#'><span>June</span></a></li>
					<li id="plotSavingsJul"><a href='#'><span>July</span></a></li>
					<li id="plotSavingsAug"><a href='#'><span>August</span></a></li>
					<li id="plotSavingsSep"><a href='#'><span>September</span></a></li>
					<li id="plotSavingsOct"><a href='#'><span>October</span></a></li>
					<li id="plotSavingsNov"><a href='#'><span>November</span></a></li>
					<li id="plotSavingsDec" class='last'><a href='#'><span>December</span></a></li>
				</ul>
			</li>					
	
			<li class='last has-sub'>
				<a href='#'><span>Battery</span></a>
				<ul>
					<li id="plotBatteryJan"><a href='#'><span>January</span></a></li>
					<li id="plotBatteryFeb"><a href='#'><span>February</span></a></li>
					<li id="plotBatteryMar"><a href='#'><span>March</span></a></li>
					<li id="plotBatteryApr"><a href='#'><span>April</span></a></li>
					<li id="plotBatteryMay"><a href='#'><span>May</span></a></li>
					<li id="plotBatteryJun"><a href='#'><span>June</span></a></li>
					<li id="plotBatteryJul"><a href='#'><span>July</span></a></li>
					<li id="plotBatteryAug"><a href='#'><span>August</span></a></li>
					<li id="plotBatterySep"><a href='#'><span>September</span></a></li>
					<li id="plotBatteryOct"><a href='#'><span>October</span></a></li>
					<li id="plotBatteryNov"><a href='#'><span>November</span></a></li>
					<li id="plotBatteryDec" class='last'><a href='#'><span>December</span></a></li>
				</ul>
			</li>
		
			<li class='has-sub'>
				<a href='#'><span>Load</span></a>
				<ul>
					<li id="plotLoadJan"><a href='#'><span>January</span></a></li>
					<li id="plotLoadFeb"><a href='#'><span>February</span></a></li>
					<li id="plotLoadMar"><a href='#'><span>March</span></a></li>
					<li id="plotLoadApr"><a href='#'><span>April</span></a></li>
					<li id="plotLoadMay"><a href='#'><span>May</span></a></li>
					<li id="plotLoadJun"><a href='#'><span>June</span></a></li>
					<li id="plotLoadJul"><a href='#'><span>July</span></a></li>
					<li id="plotLoadAug"><a href='#'><span>August</span></a></li>
					<li id="plotLoadSep"><a href='#'><span>September</span></a></li>
					<li id="plotLoadOct"><a href='#'><span>October</span></a></li>
					<li id="plotLoadNov"><a href='#'><span>November</span></a></li>
					<li id="plotLoadDec" class='last'><a href='#'><span>December</span></a></li>
				</ul>
			</li>

			<li class='has-sub' id="PVList" >
				<a href='#'><span>PV</span></a>
				<ul>
					<li id="plotPVJan"><a href='#'><span>January</span></a></li>
					<li id="plotPVFeb"><a href='#'><span>February</span></a></li>
					<li id="plotPVMar"><a href='#'><span>March</span></a></li>
					<li id="plotPVApr"><a href='#'><span>April</span></a></li>
					<li id="plotPVMay"><a href='#'><span>May</span></a></li>
					<li id="plotPVJun"><a href='#'><span>June</span></a></li>
					<li id="plotPVJul"><a href='#'><span>July</span></a></li>
					<li id="plotPVAug"><a href='#'><span>August</span></a></li>
					<li id="plotPVSep"><a href='#'><span>September</span></a></li>
					<li id="plotPVOct"><a href='#'><span>October</span></a></li>
					<li id="plotPVNov"><a href='#'><span>November</span></a></li>
					<li id="plotPVDec" class='last'><a href='#'><span>December</span></a></li>
				</ul>
			</li>
			
			<li id="PVUtilList" class='has-sub'>
				<a href='#'><span>PV Utilization</span></a>
				<ul>
					<li id="plotPVUtilJan"><a href='#'><span>January</span></a></li>
					<li id="plotPVUtilFeb"><a href='#'><span>February</span></a></li>
					<li id="plotPVUtilMar"><a href='#'><span>March</span></a></li>
					<li id="plotPVUtilApr"><a href='#'><span>April</span></a></li>
					<li id="plotPVUtilMay"><a href='#'><span>May</span></a></li>
					<li id="plotPVUtilJun"><a href='#'><span>June</span></a></li>
					<li id="plotPVUtilJul"><a href='#'><span>July</span></a></li>
					<li id="plotPVUtilAug"><a href='#'><span>August</span></a></li>
					<li id="plotPVUtilSep"><a href='#'><span>September</span></a></li>
					<li id="plotPVUtilOct"><a href='#'><span>October</span></a></li>
					<li id="plotPVUtilNov"><a href='#'><span>November</span></a></li>
					<li id="plotPVUtilDec" class='last'><a href='#'><span>December</span></a></li>
				</ul>
			</li>
			
			<li id="blifesummary">
				<a href='#'><span>Battery Life</span></a>
			</li>
			
		</ul>
	</div>
	<!---------- Menu Information ---------->
	<br>
	<br>

	<div id="parentTab" style="margin-left: 21%">
	
		<table style="width:85%">
			<tr>
				<td style="width:18%;"><div style="font-family:Calibri; font-size:20px; text-align:right;">&nbsp;&nbsp;Select EMS Result: </div></td>
				<td style="width:72%;"><div class="select-style" style="width:100%;"><select class="selectpicker" id="emsSelect" onchange="getValue()"></select></div></td>
				<td style="width:10%;"><font size="4"><input type="button" class="button button4" value="Delete Result" onclick=deleteSimulationResult()></font></td>
			</tr>
		</table>

	 	<iframe onload="iframeLoaded()" id="frame161" style="margin-left: 0%; margin-right: 0%; margin-top: 0%" width=100% height=550px scrolling="yes" frameborder="0" src="" >
		</iframe>
	</div>

	<footer>
		<div align="center">
        	<div class="footer">
				<h5>
					<img style="vertical-align:middle"src="../image/NECLA_logo.jpg" alt="NEC Labs Logo"  height="72" />
					<span><a href="http://www.nec-labs.com/research-departments/energy-management/energy-management-home">Energy Management Department, NEC Labs America</a> </span>
				</h5>
			</div>
		</div>
	</footer>
</body>

<script type="text/javascript">
$(document).ready(function() {
	getListOfEMSResults();
});

function getListOfEMSResults() {
	var req;
	if (window.XMLHttpRequest) req = new XMLHttpRequest();
	else req = new ActiveXObject("Microsoft.XMLHTTP");

	req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResultList&uname=" + username, true);
	req.onreadystatechange = function () {
		if (req.readyState === 4) {
			if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				jData = JSON.parse(data);
				processJsonData(jData.EMSResultList);
			}
		}
	}
	req.send(null);
}

function processJsonData(emsResultList) {
	
	var option = document.createElement("option");
	var select = document.getElementById("emsSelect");
	while (select.firstChild) {
		select.removeChild(select.firstChild);
	}
	
	var kWh = "";
	var kW = "";
	if (emsResultList.length != 0) {
		var emsResult = emsResultList[0];
		setGlobalVals(emsResult);
	} else {
		var option = document.createElement("option");
		var showText = "(Please run a simulation on the Input page first to obtain results.)";
		option.text = showText;
		option.value = "demo";
		select.appendChild(option);
		emsResultID = "demo";
		emsResultTariff = "E20S_OptionR";
		kWh = "85";
		kW = "100";
		batterySize = "85kWh/100kW";
		loadName = "100_school";
		pvName = "sce";
		pvCapacity = "100";
		pvUtilFlag = 1;
		drName = "n/a";
		touFlag = false;
		document.getElementById("blifesummary").style.display = "none";
	}
	
	for (var i =0; i < emsResultList.length; i++) {
		var emsResult = emsResultList[i];
		var option = document.createElement("option");
		var showText = "Load: " + emsResult.LoadName + ", Tariff: " + emsResult.TariffName + ", PV: " + emsResult.PVName + " (SF=" + emsResult.PVCapacity 
				+ ", PVU=" + emsResult.PVUtilizationFlag + ")" + ", BatterySize: " 
				+ emsResult.kWh + "kWh/" + emsResult.kW + "kW" + ", LTA: " + emsResult.isBatteryLifeAnalyzed + ", Load+: " + emsResult.LoadIncrementValue + "%"
				+ ", TOU: " + emsResult.TOUFlag;

		option.text = showText;
		option.value = emsResult._id['$oid'];
		select.appendChild(option);
	}
	
	updateLogSummary();
}

function setGlobalVals(emsResult) {
	
	emsResultID = emsResult._id['$oid'];
	emsResultTariff = emsResult.TariffName;
	kWh = emsResult.kWh;
	kW = emsResult.kW;
	batterySize = kWh + "kWh/" + kW + "kW";
	loadName = emsResult.LoadName;
	pvName = emsResult.PVName;
	pvCapacity = emsResult.PVCapacity;
	pvUtilFlag = emsResult.PVUtilizationFlag;
	drName = emsResult.DRName;
	touFlag = emsResult.TOUFlag;
	bLifeFlag = emsResult.isBatteryLifeAnalyzed;
	loadIncrementVal = emsResult.LoadIncrementValue;
	
	if (pvName != "----" && pvName != "n/a") {
		document.getElementById("PVList").style.display = "block";
		
		if (pvUtilFlag == 1) {
			document.getElementById("PVUtilList").style.display = "block";
		} else {
			document.getElementById("PVUtilList").style.display = "none";
		}
	} else {
		document.getElementById("PVList").style.display = "none";
		document.getElementById("PVUtilList").style.display = "none";
	}
	
	if (emsResult.isBatteryLifeAnalyzed == true) {
		document.getElementById("blifesummary").style.display = "block";
	} else {
		document.getElementById("blifesummary").style.display = "none";
	}

}

function getValue() {
	var val = document.getElementById("emsSelect").value;
	emsResultID = val;
	var kWh = "";
	var kW = "";
	if (jData != null) {
		for (var i=0; i < jData.EMSResultList.length; i++) {
			var emsResult = jData.EMSResultList[i];
			if (emsResult._id['$oid'] == emsResultID) {
				setGlobalVals(emsResult);
				break;
			}
		}
	} else {
		alert("jData is null");
	}
	updateLogSummary();
}

function deleteSimulationResult() {
	
	if (confirm('Are you sure you want to delete the selected EMS Result? It will be permanently removed from the system.')) {
		var val = document.getElementById("emsSelect").value;
		if (val == null || val == "" || val == "demo") {
			alert("No EMS result to delete!");
			return;
		}
		
		var req;
		if (window.XMLHttpRequest) req = new XMLHttpRequest();
		else req = new ActiveXObject("Microsoft.XMLHTTP");

		req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=DeleteEMSResult&uname=" + username + "&emsResultID=" + val + "&deleteScenario=false", true);
		req.onreadystatechange = function () {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {
					// Update the list of EMS results ...
					getListOfEMSResults();
				}
			}
		}
		req.send(null);
	} else {
	   alert("Nothing has been deleted.");
	}
}

function updateLogSummary() {
	document.getElementById("frame161").src = "logSummary.jsp?emsResultID=" + emsResultID + "&batterySize=" + batterySize 
			+ "&loadName=" + loadName  + "&tariffName=" + emsResultTariff + "&pvName=" + pvName + "&pvCapacity=" + pvCapacity + "&pvUtilFlag=" + pvUtilFlag + "&drName=" + drName  + "&touFlag=" + touFlag + "&bLifeFlag=" + bLifeFlag ;
}

//iframeLoaded();
function iframeLoaded() {
	var iFrameID = document.getElementById('frame161');
	if (iFrameID) {
		iFrameID.height = "";
		var len = iFrameID.contentWindow.document.body.scrollHeight + 50;
		iFrameID.height = len + "px";
	}
}

//Plot Cost Summary
$("#logsummary").click(function() {
	updateLogSummary();
});

//Plot Battery Lfie Summary
$("#blifesummary").click(function() {
	document.getElementById("frame161").src = "logSummary.jsp?emsResultID=" + emsResultID + "&batterySize=" + batterySize 
	+ "&loadName=" + loadName  + "&tariffName=" + emsResultTariff + "&pvName=" + pvName + "&pvCapacity=" + pvCapacity + "&pvUtilFlag=" + pvUtilFlag + "&drName=" + drName;
	
	document.getElementById("frame161").src = "batteryLifeSummary.jsp?month=1&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff + "&batterySize=" + batterySize 
	+ "&loadName=" + loadName  + "&tariffName=" + emsResultTariff + "&pvName=" + pvName + "&pvCapacity=" + pvCapacity + "&pvUtilFlag=" + pvUtilFlag + "&drName=" + drName;
});

// Plot Battery
$("#plotBatteryJan").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=1&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryFeb").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=2&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryMar").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=3&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryApr").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=4&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryMay").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=5&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryJun").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=6&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryJul").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=7&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryAug").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=8&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatterySep").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=9&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryOct").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=10&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryNov").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=11&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotBatteryDec").click(function() {
	document.getElementById("frame161").src = "plotBattery.jsp?month=12&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});

// Plot Load and Grid Power
$("#plotLoadJan").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=1&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadFeb").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=2&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadMar").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=3&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadApr").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=4&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadMay").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=5&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadJun").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=6&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadJul").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=7&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadAug").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=8&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadSep").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=9&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadOct").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=10&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadNov").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=11&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotLoadDec").click(function() {
	document.getElementById("frame161").src = "plotLoad.jsp?month=12&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});

// Plot Savings
$("#plotSavingsJan").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=1&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsFeb").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=2&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsMar").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=3&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});	
$("#plotSavingsApr").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=4&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsMay").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=5&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsJun").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=6&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsJul").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=7&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsAug").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=8&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsSep").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=9&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsOct").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=10&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsNov").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=11&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotSavingsDec").click(function() {
	document.getElementById("frame161").src = "plotSavings.jsp?month=12&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});

//Plot PV
$("#plotPVJan").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=1&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVFeb").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=2&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVMar").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=3&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});	
$("#plotPVApr").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=4&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVMay").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=5&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVJun").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=6&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVJul").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=7&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVAug").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=8&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVSep").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=9&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVOct").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=10&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVNov").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=11&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVDec").click(function() {
	document.getElementById("frame161").src = "plotPV.jsp?month=12&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});

//Plot PV Utilization
$("#plotPVUtilJan").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=1&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilFeb").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=2&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilMar").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=3&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});	
$("#plotPVUtilApr").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=4&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilMay").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=5&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilJun").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=6&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilJul").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=7&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilAug").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=8&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilSep").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=9&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilOct").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=10&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilNov").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=11&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});
$("#plotPVUtilDec").click(function() {
	document.getElementById("frame161").src = "plotPVUtil.jsp?month=12&emsResultID=" + emsResultID + "&emsResultTariff=" + emsResultTariff;
});


</script>

<style>
H3 {display: inline;}
div.inline { float:left; }
.select-style {
    border: 1px solid #ccc;
    width: 700px;
    border-radius: 3px;
    overflow: hidden;
    background: #fafafa url("img/icon-select.png") no-repeat 90% 50%;
}

.select-style select {
    padding: 5px 8px;
    width: 130%;
    border: none;
    box-shadow: none;
    background: transparent;
    background-image: none;
    -webkit-appearance: none;
}

.select-style select:focus {
    outline: none;
}
#parentTab {
    background-color: rgba(240,255,255, 0.95);
}
.button {
    background-color: #4CAF50; /* Green */
    border: none;
    color: white;
    padding: 7px 16px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 15px;
    margin: 3px 1px;
    cursor: pointer;
}
.button4 {background-color: #e7e7e7; color: black;} /* Gray */ 
</style>
      
</html>
