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
   <script src="http://code.highcharts.com/highcharts-3d.js"></script>
   <script src="http://highcharts.github.io/export-csv/export-csv.js"></script>
</head>

<script>
	var username = '<%= (String) session.getAttribute("username") %>';
	var password = '<%= (String) session.getAttribute("password") %>';
	var ipAddress = '{{ ipAddress }}';
	var year = 2012;
	
	var emsResultID = '<%= (String) request.getParameter("emsResultID") %>';
	var loadName = '<%= (String) request.getParameter("loadName") %>';
	var tariffName = '<%= (String) request.getParameter("tariffName") %>';;
	var pvName = '<%= (String) request.getParameter("pvName") %>';
	var pvUtilFlag = '<%= (String) request.getParameter("pvUtilFlag") %>';
	var drName = '<%= (String) request.getParameter("drName") %>';
	var scalingFactor = '<%= (String) request.getParameter("SF") %>';
	var selectionList = [];
</script>

<body>
    <table style="width:100%">
    	<tbody>
			<tr>
				<td align="center" colspan="3">
					<div id="container" style="max-width:1300px; width:1300px; height:800px; margin:0 auto"></div>
				</td>
			</tr>
    		 <tr>
				<td align="right">
					<div id="socControllability" style="font-family:Calibri; font-size:20px; display:inline-block;">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<b>Low payback:</b>&nbsp;
					</div>
					<div id="colorCell" style="background-color:rgb(0,255,0); width:25px; height:25px; display:inline-block;"></div>
				</td>
				<td align="center" style="width:350px;"></td>
				<td align="left" >
					<div id="socControllability" style="font-family:Calibri; font-size:20px; display:inline-block;">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<b>High payback:</b>&nbsp;
					</div>
					<div id="colorCell" style="background-color:rgb(255,0,0); width:25px; height:25px; display:inline-block;"></div>
				</td>
			</tr>
		</tbody>
	</table>
</body>

<script type="text/javascript">
//Called when the page is opened
getData();
function getData() {
    var req = null;
    if (window.XMLHttpRequest) { req = new XMLHttpRequest(); }
    else { req = new ActiveXObject("Microsoft.XMLHTTP"); }
    
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=SizingResults&emsResultID=" + emsResultID + "&username=" + username + "&loadName=" + loadName + "&tariffName=" + tariffName + "&pvName=" + pvName + "&SF=" + scalingFactor + "&pvUtilFlag=" + pvUtilFlag + "&drName=" + drName, true);
    req.onreadystatechange = function() {
        if (req.readyState === 4) {
            if (req.status === 200 || req.status == 0) {
				var data = req.responseText;
				var jDataSizing = JSON.parse(data);
				
				if(jDataSizing.isFailed == "true") {
					alert(jDataSizing.errorReason);
					return;
				}
				
				year = jDataSizing.year;
				var select = document.getElementById("container");
				while (select.firstChild) {
					select.removeChild(select.firstChild);
				}
				show3DChart(jDataSizing.listOf3DData);
            }
		}
    }
    req.send(null);
}

// Showing 3D chart
function show3DChart(chartData3D) {

    var maxPaybackVal = 0;
    var minPaybackVal = 10000000;
    for (var i = 0; i < chartData3D.length; i++) {
    	var data = chartData3D[i];
    	if (maxPaybackVal < data[3]) {
    		maxPaybackVal = data[3];
    	}
    	if (minPaybackVal > data[3]) {
    		minPaybackVal = data[3];
    	}
    }
    
    var circleColor = 'rgb(255, 0, 0)'; //red
    var chartData = [];
    for (var i = 0; i < chartData3D.length; i++) {
    	
    	var seriesData = chartData3D[i];
    	var per = (seriesData[3] - minPaybackVal) / (maxPaybackVal - (minPaybackVal - 0.1));
    	var redColor = 255 - 255 * per;
    	var greenColor = 255 - 255 * (1 - per);
    	circleColor = 'rgb(' + Math.round(greenColor) + ', ' + Math.round(redColor) + ', 0)';
    	console.log(circleColor);
		
    	chartData.push({
    		showInLegend: false,
    		name: seriesData[3],
    		color: Highcharts.Color(circleColor).brighten(-0.2).get('rgb'), 
    			
    			/*
                radialGradient: {
                    cx: 0.4, cy: 0.3, r: 0.5
                },
                stops: [
                    [0, 'white'],
                    [1, Highcharts.Color(circleColor).brighten(-0.2).get('rgb')]
                ]*/
            
            marker: {
            	symbol: 'circle',
            	radius: 15
            },
            data: [[seriesData[0], seriesData[1], seriesData[2]]]
        });
    }
    
    $(function() {
        // Set up the chart
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: 'container',
                backgroundColor: null,
                margin: 100,
                type: 'scatter',
                options3d: {
                    enabled: true,
                    alpha: 10,
                    beta: 30,
                    depth: 500,
                    viewDistance: 5,

                    frame: {
                        bottom: {
                            size: 1,
                            color: 'rgba(0,0,0,0.02)'
                        },
                        back: {
                            size: 1,
                            color: 'rgba(0,0,0,0.04)'
                        },
                        side: {
                            size: 1,
                            color: 'rgba(0,0,0,0.06)'
                        }
                    }
                }
            },
            title: {
            	y: 70,
                text: '<div style="font-family:Calibri; font-size:22px; text-align:center;">' 
                + '<b>Annual Demand Charge Savings with Different Battery Sizes</b></div>'
            },
            subtitle: {
            	y: 100,
            	text: '<div style="font-family:Calibri; font-size:15px; text-align:center;">' 
            	+ '3D rotatable bubble chart. The bubble color represents payback period where better payback is colored with green whereas worse payback is red.</div>'
            },
            plotOptions: {
                scatter: {
                    width: 10,
                    height: 10,
                    depth: 10,
                    marker: {
                        symbol: 'circle'
                    },
                    tooltip: {
                        pointFormat: "abc"
                    }
                }
            },
            xAxis: {
                title: {
                    text: '<span style="font-size:1.5em; color: black; font-weight: bold">Capacities (kWh)</span>'
                },
                min: 0,
                gridLineWidth: 1,
                labels: {
                    enabled: true,
                    format: "<b>{value}</b>"
                }
            },
            yAxis: {
                min: 0,
                uniqueNames: true,
                title: {
                    text: '<span style="font-size:1.5em; color: black; font-weight: bold">Savings ($)</span>'
                },
                labels: {
                    enabled: true,
                    format: "<b>\${value}</b>"
                }
            },
            zAxis: {
                title: {
                    text: '<span style="font-size:1.5em; color: black; font-weight: bold">PCS (kW)</span>'
                },
                min: 0,
                labels: {
                    enabled: true,
                    format: "<b>{value}</b>"
                }
            },
	        colorAxis: {
				categories: ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1', '0'],
	            stops: [
		            	[0, 'rgb(0,255,0)'],
		                [0.3, 'rgb(65,190,0)'],
		                [0.6, 'rgb(125,125,0)'],
		                [0.8, 'rgb(190,65,0)'],
		                [1, 'rgb(255,0,0)']
		            //[0, 'rgb(255,0,0)'],
	                //[0.3, 'rgb(190,65,0)'],
	                //[0.6, 'rgb(125,125,0)'],
	                //[0.8, 'rgb(65,190,0)'],
	                //[1, 'rgb(0,255,0)']
	            ],

	            reversed: false,
                labels: {
                    enabled: false,
                }
	        },
	        tooltip: {
	            formatter: function () {
	                return 'Capacity: <b>' + this.x + ' </b>kWh <br>PCS: <b>' + this.point.z + '</b> kW <br>Saving: <b>$' +
	                    this.y + '</b> <br> Payback: <b>' + this.series.name + '<b> years';
	            }
	        },
            legend: {
                enabled: true,
                symbolWidth: 600
            },
            series: chartData
        });


        // Add mouse events for rotation
        $(chart.container).bind('mousedown.hc touchstart.hc', function(e) {
            e = chart.pointer.normalize(e);

            var posX = e.pageX,
                posY = e.pageY,
                alpha = chart.options.chart.options3d.alpha,
                beta = chart.options.chart.options3d.beta,
                newAlpha,
                newBeta,
                sensitivity = 5; // lower is more sensitive

            $(document).bind({
                'mousemove.hc touchdrag.hc': function(e) {
                    // Run beta
                    newBeta = beta + (posX - e.pageX) / sensitivity;
                    newBeta = Math.min(100, Math.max(-100, newBeta));
                    chart.options.chart.options3d.beta = newBeta;

                    // Run alpha
                    newAlpha = alpha + (e.pageY - posY) / sensitivity;
                    newAlpha = Math.min(100, Math.max(-100, newAlpha));
                    chart.options.chart.options3d.alpha = newAlpha;

                    chart.redraw(false);
                },
                'mouseup touchend': function() {
                    $(document).unbind('.hc');
                }
            });
        });
    });
}

// Not used as we show the 3D besed on the annual savings now
function show3DChartSizeBasedOnPayback(chartData3D) {

    var maxPaybackVal = 0;
    for (var i = 0; i < chartData3D.length; i++) {
    	var data = chartData3D[i];
    	if (maxPaybackVal < data[3]) {
    		maxPaybackVal = data[3];
    	}
    }
    
    var chartData = [];
    for (var i = 0; i < chartData3D.length; i++) {
    	var seriesData = chartData3D[i];
    	chartData.push({
    		name: seriesData[0] + 'kWh/' + seriesData[2] + 'kW',
            marker: {
            	symbol: 'circle',
            	radius: 30 * (((maxPaybackVal-seriesData[3]) + 2)/maxPaybackVal)
            },
            data: [[seriesData[0], seriesData[1], seriesData[2]]]
        });
    }

    $(function() {
        // Give the points a 3D feel by adding a radial gradient
        Highcharts.getOptions().colors = $.map(Highcharts.getOptions().colors, function(color) {
        	//alert(color);
            return {
                radialGradient: {
                    cx: 0.4, cy: 0.3, r: 0.5
                },
                stops: [
                    [0, color],
                    [1, Highcharts.Color(color).brighten(-0.2).get('rgb')]
                ]
            };
        });

        // Set up the chart
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: 'container',
                backgroundColor: null,
                margin: 100,
                type: 'scatter',
                options3d: {
                    enabled: true,
                    alpha: 10,
                    beta: 30,
                    depth: 500,
                    viewDistance: 5,

                    frame: {
                        bottom: {
                            size: 1,
                            color: 'rgba(0,0,0,0.02)'
                        },
                        back: {
                            size: 1,
                            color: 'rgba(0,0,0,0.04)'
                        },
                        side: {
                            size: 1,
                            color: 'rgba(0,0,0,0.06)'
                        }
                    }
                }
            },
            title: {
                text: '',
            },
            plotOptions: {
                scatter: {
                    width: 10,
                    height: 10,
                    depth: 10,
                    marker: {
                        symbol: 'circle'
                    },
                    tooltip: {
                        pointFormat: "abc"
                    }
                }
            },
            xAxis: { //importance
                title: {
                    text: '<span style="font-size:1.5em; color: green; font-weight: bold">Capacities (kWh)</span>'
                },
                min: 0,
                gridLineWidth: 1,
                labels: {
                    enabled: true,
                    format: "{value}"
                }
            },
            yAxis: { //fun
                min: 0,
                uniqueNames: true,
                title: {
                    text: '<span style="font-size:1.5em; color: green; font-weight: bold">Savings ($)</span>'
                },
                labels: {
                    enabled: true,
                    format: "\${value}"
                }
            },

            zAxis: {
                title: {
                    text: '<span style="font-size:1.5em; color: green; font-weight: bold">PCS (kW)</span>'
                },
                min: 0,
                labels: {
                    enabled: true,
                    format: "{value}"
                }
            },
            legend: {
                enabled: true
            },
            series: chartData
        });

        // Add mouse events for rotation
        $(chart.container).bind('mousedown.hc touchstart.hc', function(e) {
            e = chart.pointer.normalize(e);

            var posX = e.pageX,
                posY = e.pageY,
                alpha = chart.options.chart.options3d.alpha,
                beta = chart.options.chart.options3d.beta,
                newAlpha,
                newBeta,
                sensitivity = 5; // lower is more sensitive

            $(document).bind({
                'mousemove.hc touchdrag.hc': function(e) {
                    // Run beta
                    newBeta = beta + (posX - e.pageX) / sensitivity;
                    newBeta = Math.min(100, Math.max(-100, newBeta));
                    chart.options.chart.options3d.beta = newBeta;

                    // Run alpha
                    newAlpha = alpha + (e.pageY - posY) / sensitivity;
                    newAlpha = Math.min(100, Math.max(-100, newAlpha));
                    chart.options.chart.options3d.alpha = newAlpha;

                    chart.redraw(false);
                },
                'mouseup touchend': function() {
                    $(document).unbind('.hc');
                }
            });
        });
    });
}
</script>

</html>