<!DOCTYPE html>
<html lang="en">
<head>
<title>NEC EMS Data Analysis</title>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=7" />
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Custom CSS -->
<link href="../css/half-slider.css" rel="stylesheet">
<link href="../css/jquery-ui.css" rel="stylesheet" />
<link href="../css/bootstrap.css" rel="stylesheet" type="text/css">
<link href="../css/necui.css" rel="stylesheet" />
<link href="../css/login.css" rel="stylesheet">
<link rel="stylesheet" href="../css/MyStyleSheet.css">
<link rel="stylesheet" href="../css/Sidebarstyles.css">

<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css">
<link rel="stylesheet" href="../css/Sidebarstyles.css">
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">


<script src="../js/jquery-1.11.3.js"></script>
<script src="../js/jquery-ui.js"></script>
<script src="../js/bootstrap.min.js"></script>

<script src="http://code.highcharts.com/highcharts.js"></script>
<script src="http://code.highcharts.com/highcharts-3d.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>

</head>

<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" session="true"%>

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

<%	return;
} %>
<!---------- Login Credential End ---------->

<script>
	var username = '<%=(String) session.getAttribute("username")%>';
	var password = '<%=(String) session.getAttribute("password")%>';
	var ipAddress = '{{ ipAddress }}';
	var emsResultList = null;
	var selectionList = [];
</script>

<body>
	<!--header information-->
	<div class="container" id="navmain">
    	<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        	<div class="container-fluid">
            	<div class="navbar-header">
            		<a class="navbar-brand active" href="/EMSOperationsEngine/LoginForm.jsp"><i class="fa fa-plug"></i> NEC EMS BTM Application</a>
            	</div>
				<!-- Insert loggedinnavbar.jsp -->
            	<ul class="nav navbar-nav" style="float: none !Important;">
					<li><a href="NECEMS_Main.jsp"><font size="4"><span class="glyphicon glyphicon-cog"></span>Input</font></a></li>
					<li><a href="SizingAnalysis.jsp"><font size="4" color="white"><span class="fa fa-database"></span>Sizing Analysis</font></a></li>
					<li><a href="LogPage.jsp"><font size="4" ><span class="fa fa-bar-chart"></span>Output</font></a></li>
					<li><a href="FAQ.jsp"><font size="4"><i class="fa fa-question-circle"></i>FAQ</font></a></li>
					<li style="float: right; margin-right: 5%"><a href="/EMSOperationsEngine/LoginForm.jsp"><font size="4"><span class="glyphicon glyphicon-home"></span> Logout</font></a></li>
				</ul>
        	</div>
    	</nav>
	</div>
		<br>
	<br>
	<br>
	<br>

	<div class="container" id="parentTab" style="width: 90%;">
        <div align="center">
        	<table>
				<tr>
					<td style="width:200x;"><div style="font-family:Calibri; font-size:20px; text-align:right;">&nbsp;&nbsp;&nbsp;&nbsp;Select Scenario: &nbsp;&nbsp;</div></td>
					<td><div class="select-style"><select class="selectpicker" id="emsSelect" onchange="getValue()"></select></div></td>
					<td><font size="4">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" class="button button4" value="Delete Scenario" onclick=deleteSimulationResult()></font></td>
				</tr>
			</table>
        </div>
        
        <iframe onload="iframeLoaded()" id="frame161" style="margin-left: 0%; margin-right: 0%; margin-top: 0%" width=100% height=550px scrolling="yes" frameborder="0" src="" >
		</iframe>
	
		<!-- <div id="container" style="height: 800px"></div> -->
	</div>
	
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
	
</body>

<script>
/** Javascript begins from here **/
getListOfEMSResults();
function getListOfEMSResults() {
	var req;
	if (window.XMLHttpRequest) req = new XMLHttpRequest();
	else req = new ActiveXObject("Microsoft.XMLHTTP");

	req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResultList&uname=" + username, true);
	req.onreadystatechange = function () {
		if (req.readyState === 4) {
			if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				var jData = JSON.parse(data);
				emsResultList = jData.EMSResultList;
				
				var csObjList = [];
				for (var i =0; i < emsResultList.length; i++) {
					var emsResult = emsResultList[i];
					if (emsResult.isBatteryLifeAnalyzed == false) {
						csObjList.push(emsResult);
					}
				}
				
				processJsonData(csObjList);
			}
		}
	}
	req.send(null);
}

function processJsonData(emsResults) {
	
	selectionList = [];
	var option = document.createElement("option");
	var select = document.getElementById("emsSelect");
	while (select.firstChild) {
		select.removeChild(select.firstChild);
	}
	
	var kWh = "";
	var kW = "";
	
	for (var i =0; i < emsResults.length; i++) {
		var emsResult = emsResults[i];
		var flag = true;
		for (var j =0; j < selectionList.length; j++) {
			var loadName = selectionList[j].LoadName.replace(/\s+/g, '');
			var tariffName = selectionList[j].TariffName.replace(/\s+/g, '');
			var pvName = selectionList[j].PVName.replace(/\s+/g, '');
			var scalingFactor = selectionList[j].PVCapacity.replace(/\s+/g, '');
			var pvUtilFlag = selectionList[j].PVUtilizationFlag;
			var drName = selectionList[j].DRName.replace(/\s+/g, '');
			if (emsResult.LoadName == loadName && emsResult.TariffName == tariffName && emsResult.PVName == pvName && emsResult.PVCapacity == scalingFactor && emsResult.PVUtilizationFlag == pvUtilFlag && emsResult.DRName == drName) {
				flag = false;
				break;
			}
		}
		if (flag == true) {
			selectionList.push(emsResult);
		}
	}
	
	var emsResultID = "";
	var loadName = "";
	var tariffName = "";
	var pvName = "";
	var pvUtilFlag = 1;
	var scalingFactor = "";
	var drName = "";
	
	if (selectionList.length != 0) {
		var emsResult = selectionList[0];
		emsResultID = emsResult._id['$oid'];
		loadName = emsResult.LoadName;
		tariffName = emsResult.TariffName;
		pvName = emsResult.PVName;
		pvUtilFlag = emsResult.PVUtilizationFlag;
		scalingFactor = emsResult.PVCapacity;
		drName = emsResult.DRName;
	} else {
		var option = document.createElement("option");
		var showText = "(Please run a simulation on the Input page first to obtain results.)";
		option.text = showText;
		select.appendChild(option);
		alert("Please run a simulation on the Input page first to obtain results.");
		return;
	}
	
	for (var j =0; j < selectionList.length; j++) {
		var option = document.createElement("option");
		var showText = "Load Name: " + selectionList[j].LoadName + ", Tariff: " + selectionList[j].TariffName + ", PV: " + selectionList[j].PVName + " (SF=" + selectionList[j].PVCapacity + ", PVUtil=" + selectionList[j].PVUtilizationFlag + ")";
		option.text = showText;
		option.value = selectionList[j]._id['$oid'];		
		select.appendChild(option);
	}
	
	updateLogSummary(emsResultID, loadName, tariffName, pvName, scalingFactor, pvUtilFlag, drName);
}

function getValue() {
	var val = document.getElementById("emsSelect").value;
	var emsResultID = val;
	var loadName = "";
	var tariffName = "";
	var pvName = "";
	var scalingFactor = 0;
	var drName = "";
	var pvUtilFlag = 0;
	if (emsResultList != null) {
		for (var i = 0; i < emsResultList.length; i++) {
			var emsResult = emsResultList[i];
			if (emsResult._id['$oid'] == emsResultID) {
				loadName = emsResult.LoadName;
				tariffName = emsResult.TariffName;
				pvName = emsResult.PVName;
				scalingFactor = emsResult.PVCapacity;
				pvUtilFlag = emsResult.PVUtilizationFlag;
				drName = emsResult.DRName;
				break;
			}
		}
	} else {
		alert("emsResultList is null");
	}
	
	updateLogSummary(emsResult._id['$oid'], loadName, tariffName, pvName, scalingFactor, pvUtilFlag, drName);
}

function iframeLoaded() {
	var iFrameID = document.getElementById('frame161');
	if (iFrameID) {
		iFrameID.height = "";
		var len = iFrameID.contentWindow.document.body.scrollHeight + 50;
		iFrameID.height = len + "px";
	}
}

function updateLogSummary(emsResultID, loadName, tariffName, pvName, scalingFactor, pvUtilFlag, drName) {
	document.getElementById("frame161").src = "plot3DChart.jsp?username=" + username + "&emsResultID=" + emsResultID + "&loadName=" + loadName + "&tariffName=" + tariffName + "&pvName=" + pvName + "&SF=" + scalingFactor + "&pvUtilFlag=" + pvUtilFlag + "&drName=" + drName;
}

function deleteSimulationResult() {
	
	if (confirm('Are you sure you want to delete all the results of the selected scenario? It will permanently remove all the results related to the load, tariff, PV, and DR of the selected scenario!')) {
		var val = document.getElementById("emsSelect").value;
		if (val == null || val == "" || val == "demo") {
			alert("No EMS result to delete!");
			return;
		}
		
		var req;
		if (window.XMLHttpRequest) req = new XMLHttpRequest();
		else req = new ActiveXObject("Microsoft.XMLHTTP");

		req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=DeleteEMSResult&uname=" + username + "&emsResultID=" + val + "&deleteScenario=true", true);
		req.onreadystatechange = function () {
			if (req.readyState === 4) {
				if (req.status === 200 || req.status == 0) {
					getListOfEMSResults();
				}
			}
		}
		req.send(null);
	} else {
	   alert("Nothing has been deleted.");
	}
}

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
    background-color: rgba(240,255,255, 0.96);
}
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
.button4 {background-color: #e7e7e7; color: black;} /* Gray */ 
</style>

</html>