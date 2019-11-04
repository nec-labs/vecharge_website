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

<%	return; } %>

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
var loadName = '<%= (String) request.getParameter("loadName") %>';
var tariffName = '<%= (String) request.getParameter("tariffName") %>';
var pvName = '<%= (String) request.getParameter("pvName") %>';
var pvCapacity = '<%= (String) request.getParameter("pvCapacity") %>';
var pvUtilFlag = '<%= (String) request.getParameter("pvUtilFlag") %>';
var drName = '<%= (String) request.getParameter("drName") %>';
var touFlag = '<%= (String) request.getParameter("touFlag") %>';
var bLifeFlag = '<%= (String) request.getParameter("bLifeFlag") %>';
</script>

<body style="background-color: rgba(255, 255, 255, 0.06); overflow: hidden">
	<br>
	<div style="font-family:Calibri; text-align:left;">
		&nbsp;&nbsp; <font size="6">Annual Summary</font> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	<font size="5"><input type="button" class="button button" value="Annual Bill Minimization Report" onclick=openNewTab()></font> &nbsp;&nbsp;
    	<font size="5"><input id="generateAnnualPVReport" style="display:none" type="button" class="button button" value="Annual PV Utilization Analysis Report" onclick=openNewTabPV()></font>
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
  				<td style="display:none; width:14%;">
					<h4 style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
				    	DR Program: &nbsp;&nbsp; 
				    </h4>
				</td> 
		    	<td style="width:14%;">
		    		<div style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
		    			Annual Battery Throughput:
		    		</div>
				</td>
				<td style="width:14%;">
		    		<div style="font-family: Georgia, Times, 'Times New Roman', serif; font-weight: bold;text-align:left; font-size: medium; margin-left: 5%">
		    			Total Battery Degradation:
		    		</div>
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
		    		&nbsp;&nbsp;&nbsp;&nbsp;<span id="total_energy_throughput" style="font-size:medium;"> </span>
				</td>
				<td>
		    		&nbsp;&nbsp;&nbsp;&nbsp;<span id="total_battery_degradation" style="font-size:medium;"> </span>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="7" style="height:430px">
					<div id="gaugeChart" style="width:480px; height:350px;"></div>
					
					<div id="paybackGaugeChart" style="width:480px; height:350px;"></div>
					
					<div id="pvUtilGaugeChart" style="width:480px; height:350px;"></div>
				</td>
			</tr>
		</tbody>
	</table>
    
</body>

<script>
getLogSummaryData();

// Called when the Output page is opened
function getLogSummaryData() {
	
	/*if (touFlag == "true") {
		document.getElementById("totalCostGaugeChart").style.display = "block";
		document.getElementById("gaugeChart").style.display = "none";
	} else {
		document.getElementById("totalCostGaugeChart").style.display = "none";
		document.getElementById("gaugeChart").style.display = "block";
	}*/
	
	if (pvName == "----" || pvName == "n/a" || pvUtilFlag == 0) {
		document.getElementById("gaugeChart").style.width = "50%";
		document.getElementById("paybackGaugeChart").style.width = "50%";
		document.getElementById("pvUtilGaugeChart").style.display = "none";
		document.getElementById("generateAnnualPVReport").style.display = "none";
	} else {
		document.getElementById("gaugeChart").style.width = "33%";		
		document.getElementById("paybackGaugeChart").style.width = "33%";
		document.getElementById("pvUtilGaugeChart").style.width = "33%";
		document.getElementById("generateAnnualPVReport").style.display = "block";
		document.getElementById("generateAnnualPVReport").style.display = "inline";
	}
	
	// Sending XML Http Request to backend java system
	var req;
	if (window.XMLHttpRequest) req = new XMLHttpRequest();
	else req = new ActiveXObject("Microsoft.XMLHTTP");
	req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=AnalyzeResults&uname=" + username + "&emsResultID=" + emsResultID, true);
	req.onreadystatechange = function () {
		if (req.readyState === 4) {
			if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				jData = JSON.parse(data);
				
				if (jData.isFailed == "true") {
					alert(jData.errorReason);
					return;
				}
				
				var annualDCBaseCost = jData.annualDCBaseCost;
				var annualDCSavings = jData.annualSavings;
				var annualSavingsVarPlus = jData.annualSavingsVarPlus;
				var annualSavingsVarMinus = jData.annualSavingsVarMinus;
				var annualTotalSavingsVarPlus = jData.annualTotalSavingsVarPlus;
				var annualTotalSavingsVarMinus = jData.annualTotalSavingsVarMinus;
				
				var totalBaseCost = jData.totalBaseCost;
				var annualTotalSaving = jData.annualTotalSaving;
				var paybackPeriod = jData.paybackPeriod;
				var totalEnergyThroughput = jData.totalEnergyThroughput;
				var annual_soc_average = Math.round(jData.annual_soc_average * 10)/10;
				
				var battery_life_length = "";
				if (jData.battery_life_length == 0) {
					battery_life_length = "Not Estimated";
				} else if (jData.battery_life_length == 11) {
					battery_life_length = "More than 10 years";
				} else {
					battery_life_length = Math.round(jData.battery_life_length * 10)/10 + " years";
				}
				
				var totalBatteryDegradation = "";
				if (jData.total_battery_degradation == 0) {
					totalBatteryDegradation = "Not Estimated";
				} else {
					totalBatteryDegradation = jData.total_battery_degradation + " %";
				}

				
				document.getElementById("battery_size").innerHTML = batterySize;
				document.getElementById("load_name").innerHTML = loadName;
				document.getElementById("tariff_name").innerHTML = tariffName;
				document.getElementById("pv_name").innerHTML = pvName + "<BR> (SF=" + pvCapacity + ", PVU=" + pvUtilFlag + ")";
				document.getElementById("dr_name").innerHTML = drName;
				document.getElementById("total_energy_throughput").innerHTML = totalEnergyThroughput + " kWh";
				document.getElementById("total_battery_degradation").innerHTML = totalBatteryDegradation;
				
				//showGaugeChart(annualDCBaseCost, annualDCSavings, annualSavingsVarPlus, annualSavingsVarMinus);
				showTotalCostGaugeChart(totalBaseCost, annualTotalSaving, annualDCBaseCost, annualDCSavings, annualSavingsVarPlus, annualSavingsVarMinus);
				showPaybackGaugeChart(paybackPeriod);
				
				showPVUtilGaugeChart(jData.annual_Esell_NoESS_kWh, jData.annual_Esell_ESS_kWh, jData.annual_PV_Utilization);
			}
		}
	}
	req.send(null);
}

//Called when clicking the Annual DC Minimization Report button
function openNewTab() {
	var url = 'plotAnnualSummary.jsp?emsResultID='+ emsResultID + "&batterySize=" + batterySize + "&loadName=" + loadName  + "&tariffName=" + tariffName + "&pvName=" + pvName + "&drName=" + drName + "&touFlag=" + touFlag + "&year=" + year;
	var win = window.open(url, '_blank');
	if (win) {
	    //Browser has allowed it to be opened
	    win.focus();
	} else {
	    //Browser has blocked it
	    alert('Please allow popups for this website');
	}
}

//Called when clicking the PV Utilization Analysis Report button
function openNewTabPV() {
	var url = 'plotAnnualPVSummary.jsp?emsResultID='+ emsResultID + "&batterySize=" + batterySize + "&loadName=" + loadName  + "&tariffName=" + tariffName + "&pvName=" + pvName + "&drName=" + drName + "&year=" + year;
	var win = window.open(url, '_blank');
	if (win) {
	    win.focus();
	} else {
	    alert('Please allow popups for this website');
	}
}

// Showing the gauge chart for annual savings
function showGaugeChart(annualDCBaseCost, annualSavings, annualSavingsVarPlus, annualSavingsVarMinus) {
	
	if (annualSavings < 0)
		annualSavings = 0;
	
    var maxValue1 = annualDCBaseCost - annualSavings;
    var maxValue2 = annualDCBaseCost;
    var SavingPercentage = Math.round(annualSavings*100/maxValue2);
    var SavingPercentageVarPlus = Math.round(annualSavingsVarPlus*100/maxValue2);
    var SavingPercentageVarMinus = Math.round(annualSavingsVarMinus*100/maxValue2);

    var sensText = '';
    if (annualSavingsVarPlus != null && annualSavingsVarMinus != null) {
        sensText = '&nbsp;&nbsp;&nbsp;&nbsp;<b>Potential Range: </b><span style="font-size:1.1em; color: green; font-weight: bold">' 
        + SavingPercentageVarMinus + '\% - ' + SavingPercentageVarPlus + '\%</span><br>';
    }
    
    var title = '';
    if (bLifeFlag == 'true') {
    	title = '(Average based on 10 years)'
    }

	$(function () {
	    Highcharts.chart('gaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Annual DC Costs and Savings</b><br>' + title,
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
	            pointFormat: '<b>EMS</b><br><span style="font-size:1.1em; color: green; font-weight: bold">\$' + maxValue1 + '</span>',
	            positioner: function (labelWidth, labelHeight) {
	                return {
	                    x: 30,
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
	        		enabled: false,
	        		x: 0, y: 0,
	        		format: '<b>Basecase</b><br> \${value}',
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
	                y: maxValue1
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -60,
	                format: '<b><span style="font-size:1.6em">Annual Savings</span></b><br><span style="font-size:1.8em; color: green; font-weight:bold">\$' + annualSavings + '</span>' 
	                + '<br>&nbsp;&nbsp;&nbsp;&nbsp;Saving Rate: <span style="font-size:1.13em; color: green;">' + SavingPercentage + '%</span><br>'
		            + sensText
		            + '&nbsp;&nbsp;&nbsp;&nbsp;<b>EMS: </b><span style="font-size:1.1em; color: green; font-weight: bold">\$' + maxValue1 + '</span>'
		            + '<br>&nbsp;&nbsp;&nbsp;&nbsp;<b>Basecase: </b><span style="font-size:1.1em; color: green; font-weight: bold">\$' + maxValue2 + '</span>',
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

// showing gauge chart about payback period
function showPaybackGaugeChart(paybackPeriod) {
	
    var maxValue1 = paybackPeriod;
    var maxValue2 = 10;
    var SavingPercentage = Math.round(maxValue1*100/maxValue2);
    
    var dispYear = Math.round(paybackPeriod*100 )/100;
    
    var subTitle = '(Based on First-Year Saving)';
    if (bLifeFlag == 'true') {
    	subTitle = '(Based on Savings for 10 years)';
    }
    
    if (dispYear > 10) {
    	dispYear = "More than 10";
    	maxValue1 = 10;
    }

	$(function () {
	    Highcharts.chart('paybackGaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Payback Period</b><br>' + subTitle,
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
	            pointFormat: '<b>EMS</b><br><span style="font-size:1.1em; color: green; font-weight: bold">' + paybackPeriod + ' years</span>',
	            positioner: function (labelWidth, labelHeight) {
	                return {
	                    x: 25,
	                    y: 50
	                };
	            }
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
	            max: 10,
	            lineWidth: 0,

	            tickPositions: [maxValue2],
	            labels: {
	            	distance: 30,
	        		enabled: false,
	        		x: 0, y: 0,
	        		format: '{value} years',
	        		style: {
	            		fontSize: 16
	        		}
	    		}
	        }],
	        plotOptions: {
	            solidgauge: {
	                borderWidth: '34px',
	                dataLabels: {
	                    y: 0,
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
	            	y: -40,
	                format: '<b><span style="font-size:1.2em"></span></b><br><span style="font-size:1.8em; color: green; font-weight: bold">' + dispYear + ' years</span>'
	                		+ '<br> out of 10 years',
	            },
	        }]
	    });
	});
}

// Showing gauge chart about PV Utilization 
function showPVUtilGaugeChart(Annual_Esell_NoESS_kWh, Annual_Esell_ESS_kWh, Annual_PV_Utilization) {
	
	var middleText = null;
	var middleVal = '';
	if (Annual_PV_Utilization == -1) {
		Annual_Esell_NoESS_kWh = 0;
		Annual_Esell_ESS_kWh = 0;
		middleText = "No Excess PV";
	} else {
		middleText = "PV Utilization: ";
		middleVal = Math.round(Annual_PV_Utilization) + " %";
	}
	
    var maxValue1 = Math.round(Annual_Esell_ESS_kWh); 
    var maxValue2 = Math.round(Annual_Esell_NoESS_kWh);
    var savingValue = maxValue2 - maxValue1;
    
    Annual_PV_Utilization = Math.round(Annual_PV_Utilization*10)/10;
    
    var SavingPercentage = Annual_PV_Utilization/1000;

	$(function () {
	    Highcharts.chart('pvUtilGaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Annual Excess PV Generation and Utilization</b>',
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
	        		enabled: false,
	        		x: 0, y: 0,
	        		format: '<b>Basecase</b><br>{value} kWh',
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
	                y: maxValue1
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -50,
	                format: '<b><span style="font-size:1.4em">Utilized PV by Battery</span></b><br>' 
	                	+ '<span style="font-size:1.8em; color: green; font-weight:bold">' + savingValue + ' kWh</span><br>&nbsp;&nbsp;&nbsp;&nbsp;' 
	                	+ middleText + '<span style="font-size:1.1em; color: green; font-weight:bold">' + middleVal + '</span><br>' 
	                	+ '&nbsp;&nbsp;&nbsp;&nbsp;<b>EMS: </b><span style="font-size:1.1em; color: green; font-weight: bold">' + maxValue1 + ' kWh</span>'
			            + '<br>&nbsp;&nbsp;&nbsp;&nbsp;<b>Basecase: </b><span style="font-size:1.1em; color: green; font-weight: bold">' + maxValue2 + ' kWh</span>'
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

/**
 * Functions below are not used for now.
 */
//To be used when TOU management is enabled in the tool
function showTOUGaugeChart(annualDCBaseCost, annualSavings) {
	
	if (annualSavings < 0)
		annualSavings = 0;
	
    var maxValue1 = annualDCBaseCost - annualSavings;
    var maxValue2 = annualDCBaseCost;
    var SavingPercentage = Math.round(annualSavings*100/maxValue2);

	$(function () {
	    Highcharts.chart('touGaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Annual Total Costs and Savings</b>',
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
	            pointFormat: '<b>EMS</b><br><span style="font-size:1.1em; color: green; font-weight: bold">\$' + maxValue1 + '</span>',
	            positioner: function (labelWidth, labelHeight) {
	                return {
	                    x: 30,
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
	            background: [{ 
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
	        		x: 0, y: 0,
	        		format: '<b>Basecase</b><br> \${value}',
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
	                y: maxValue1
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -50,
	                format: '<b><span style="font-size:1.6em">Annual Savings</span></b><br><span style="font-size:1.8em; color: green; font-weight:bold">\$' + annualSavings + '</span>' 
		            + '<br><span style="font-size:1.3em; color: green;">Saving Rate: ' + SavingPercentage + '%</span><br><br><br>',
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

//Used when TOU management was enabled, but not now
function showTotalCostGaugeChart(annualTotalBaseCost, annualTotalSavings, annualDCBaseCost, annualDCSavings, annualSavingsVarPlus, annualSavingsVarMinus) {
	
	console.log("Annual Total Basecost: " + annualTotalBaseCost);  
	console.log("Annual DC Basecost: " + annualDCBaseCost);
	console.log("Annual Total Saving: " + annualTotalSavings); //, annualTotalSavings, annualDCBaseCost, annualDCSavings, annualSavingsVarPlus, annualSavingsVarMinus);
	console.log("Annual DC Saving: " + annualDCSavings);
	
	var annualTOUSavings = "NA";
	
	if (touFlag == "true") {
		annualTOUSavings = annualTotalSavings - annualDCSavings;
		if (annualTOUSavings < 0) {
			annualTOUSavings = 0;
			annualTotalSavings = annualDCSavings;
		}
	} else {
		annualTotalSavings = annualDCSavings;
	}
	
	if (annualTotalSavings < 0)
		annualTotalSavings = 0;
	
    var maxValue1 = annualTotalBaseCost - annualTotalSavings;
    var maxValue2 = annualTotalBaseCost;
    var SavingPercentage = Math.round(annualTotalSavings*100/maxValue2);
    
    var SavingPercentageVarPlus = Math.round(annualSavingsVarPlus*100/maxValue2);
    var SavingPercentageVarMinus = Math.round(annualSavingsVarMinus*100/maxValue2);

    var sensText = '';
    if (annualSavingsVarPlus != null && annualSavingsVarMinus != null) {
        sensText = '&nbsp;&nbsp;&nbsp;&nbsp;<b>Potential Range: </b><span style="font-size:1.1em; color: green; font-weight: bold">' 
        + SavingPercentageVarMinus + '\% - ' + SavingPercentageVarPlus + '\%</span><br>';
    }

	$(function () {
	    Highcharts.chart('gaugeChart', {
	        chart: {
	            type: 'solidgauge',
	            backgroundColor: null,
	            marginTop: 50
	        },
	        title: {
	        	text: '<b>Annual Savings and Total Costs</b>',
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
	            pointFormat: '<b>EMS</b><br><span style="font-size:1.1em; color: green; font-weight: bold">\$' + maxValue1 + '</span>',
	            positioner: function (labelWidth, labelHeight) {
	                return {
	                    x: 30,
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
	        		enabled: false,
	        		x: 0, y: 0,
	        		format: '<b>Basecase</b><br> \${value}',
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
	                y: maxValue1
	            }],
	            dataLabels: {
	            	align: "center",
	            	y: -70,
	                format: 
                	'<b><span style="font-size:1.6em">Annual Savings</span></b>' 
                	+ '<br><span style="font-size:1.4em; color: green; font-weight:bold">DC: \$' + annualDCSavings + '</span>' 
                	+ '<br><span style="font-size:1.4em; color: green; font-weight:bold">TOU: \$' + annualTOUSavings + '</span>' 	                
	                + '<br>&nbsp;&nbsp;&nbsp;&nbsp;Saving Rate: <span style="font-size:1.13em; color: green;">' + SavingPercentage + '%</span><br>'
		            + sensText
		            + '&nbsp;&nbsp;&nbsp;&nbsp;<b>Cost by EMS: </b><span style="font-size:1.1em; color: green; font-weight: bold">\$' + maxValue1 + '</span>'
		            + '<br>&nbsp;&nbsp;&nbsp;&nbsp;<b>Basecost: </b><span style="font-size:1.1em; color: green; font-weight: bold">\$' + maxValue2 + '</span>',
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

// Not used now
function showSavingBarWithError(emsSaving, savingErrorPlus, savingErrorMinus) {
	Highcharts.chart('savingBar', {
	    chart: {
	        zoomType: 'xy',
	        backgroundColor: null
	    },
	    title: {
	        text: 'Annual DC Cost Saving'
	    },
	    xAxis: [{
	        categories: ['Basecase', 'EMS']
	    }],
	    yAxis: [{ // Primary yAxis
	        labels: {
	            format: '{value} °C',
	            style: {
	                color: Highcharts.getOptions().colors[1]
	            }
	        },
	        title: {
	            text: 'Saving',
	            style: {
	                color: Highcharts.getOptions().colors[1]
	            }
	        }
	    }, { // Secondary yAxis
	        title: {
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

	    series: [{
	        name: 'Saving',
	        type: 'column',
	        yAxis: 1,
	        data: [emsSaving],
	        tooltip: {
	            pointFormat: '<span style="font-weight: bold; color: {series.color}">{series.name}</span>: <b>\${point.y:.1f}</b> '
	        }
	    }, {
	        name: 'Saving error',
	        type: 'errorbar',
	        yAxis: 1,
	        data: [[savingErrorPlus, savingErrorMinus]],
	        tooltip: {
	            pointFormat: '(error range: \${point.low}-{point.high})<br/>'
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
#gaugeChart {
    float: left;
    width: 50%;
}
#paybackGaugeChart {
    float: right;
    width: 50%;
}
</style>

</html>
