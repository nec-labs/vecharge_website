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
   <script src="https://code.highcharts.com/highcharts.js"></script>
   <script src="https://code.highcharts.com/modules/data.js"></script>
   <script src="https://code.highcharts.com/modules/heatmap.js"></script>
   <script src="https://code.highcharts.com/modules/exporting.js"></script>
   <script src="https://code.highcharts.com/highcharts-more.js"></script>
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
	<br>
    <table style="width: 100%">
    	<tbody>
    		<tr>
    			<td align="left" colspan="2">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="month" style="font-weight:bold; font-family:Calibri; font-size:28px;"></span>
    			</td>
    		</tr>
    		<tr style="display:none;">
				<td align="left" style="width:5%;">
					<div id="socControllability" style="font-family:Calibri; font-size:20px; display:inline-block;">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<b>SOC Controllability:</b>&nbsp;
					</div>
					<div id="colorCell" style="width:25px; height:25px; display:inline-block;"></div>
				</td>
			</tr>
			<tr>
				<td align="center" colspan="2" style="height:350px" >
					<div id="container" style="max-width:1300px; height:300px; margin: 0 auto"></div>
				</td>
			</tr>
    		<tr>
    			<td align="center" style="width:50%; height:580px;">
    				<div id="chartdiv" style="height: 450px; width: 550px; margin: 0 auto"></div>
    			</td>
    			<td align="center" style="width:50%;">
					<div id="peak_load" style="width:300px; height:250px;"></div>
					<div id="peak_time" style="font-weight:bold; font-family:Calibri; font-size:18px;">time</div>
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
    req.open("GET", "/EMSOperationsEngine/btmEMS.do?domain=EMSResults&username=" + username + "&datatype=load&month=" + month + "&emsResultID=" + emsResultID, true);
    req.onreadystatechange = function() {
        if (req.readyState === 4) {
            if (req.status === 200 || req.status == 0) {

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
	
	var maxLoad = Math.max.apply(null, jData.hourlyLoadData);
	var minLoad = Math.min.apply(null, jData.hourlyLoadData);
	var R = maxLoad - minLoad;
	var r = R/10;
	
	var distribution = [0,0,0,0,0,0,0,0,0,1];
	for (var i=0; i < jData.hourlyLoadData.length; i++) {
		var load = jData.hourlyLoadData[i];
		for (var j = 0; j < 10; j++) {
			if (minLoad + (r * j) <= load && load < minLoad + (r * (j+1)) ) {
				distribution[j]++;
			}
		}
	}
	
	var maxIndex = 0;
	var maxValue = 0;
	for (var index = 0; index < distribution.length; index++ ) {
		if (distribution[index] > maxValue) {
			maxValue = distribution[index];
			maxIndex = index;
		}
	}

	var colors = ["#00FF00", "#33ff00", "#66ff00", "#99ff00", "#ccff00", "#FFFF00", "#FFCC00", "#ff9900", "#ff6600", "#FF0000"];
	var div = document.getElementById('colorCell');
	div.style.backgroundColor = colors[maxIndex];
	
	// Parsing Load Hourly Data
	var heatmapData = "Date,Time,Temperature\n";
	var count = 0;
	var day = 2;
    for (var i = 0; i < jData.hourlyLoadData.length; i++) {
 	  	if (count < 23) {
 	        var load = jData.hourlyLoadData[i];
 	        heatmapData += "2012-" + String(month) + "-" + String(day) + "," ;
 	        heatmapData += String(count) + ",";
 	        heatmapData += load + "\n";

            count ++;
    	} else {
            var load = jData.hourlyLoadData[i];
            heatmapData += "2012-" + String(month) + "-" + String(day) + "," ;
            heatmapData += String(count) + ",";
            heatmapData += load + "\n";
            
    		count = 0;
    		day ++;
    	}
   }

	var iText = document.createElement('p');
	iText.className = "titles";
	document.getElementById('chartdiv').appendChild(iText);
	var iDiv = document.createElement('div');
	iDiv.id = 'heatmapview';
	iDiv.className = "plotBlockSmall";
	document.getElementById('chartdiv').appendChild(iDiv);
	showHeatmap(jData.hourlyLoadData);

	if (jData.isPythonRunning == "true") {
		showLineGraphWithOutlierDetection(jData.quarterHourLoadData, jData.outlierScores, jData.quarterHourLoadDataVarPlus, jData.quarterHourLoadDataVarMinus);
	} else {
		showLineGraph(jData.quarterHourLoadData, jData.quarterHourLoadDataVarPlus, jData.quarterHourLoadDataVarMinus);
	}
	
	dynamicPeakLoad(jData.quarterHourLoadData);
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
	            text: '<b>Load Variation by Day and Hour</b>',
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

function showLineGraph(monthlyData, dataPlus, dataMinus) {
	
//	if (dataPlus != null && dataPlus.length != 0) {
//		alert("data exists: " + dataPlus.length)
//	} 
	
	var adjust = 0;
	
    Highcharts.chart('container', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Load Profile</b>'
        },
        xAxis: {
            type: 'datetime',
        },
        yAxis: {
            title: {
                text: 'Load [kW]'
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
            //type: 'line',
            name: 'Load',
            color: "blue",
            lineWidth: 0.5,
            marker: {
                enabled: false
            },
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
        }, {
            name: 'Range',
            data: (function() {
                var data = [];
                var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
                for (var index = 0; index < dataPlus.length; index += 1) {
                    timeL = timeL + 1000 * 60 * 15;
                    data.push([
                        timeL,
                        dataPlus[index],
                        dataMinus[index],
                    ]);
                }
                return data;
            }()),
            type: 'arearange',
            lineWidth: 0,
            linkedTo: ':previous',
            color: Highcharts.getOptions().colors[0],
            fillOpacity: 0.3,
            zIndex: 0,
            marker: {
                enabled: false
            }
        }]
    });
}

function showLineGraphWithOutlierDetection(monthlyData, scores) {
	
	var beta = 0.995;
	var alpha1 = 1.1;
	var alpha2 = 1.8;
	
	var adjust = 0;
	
	var outlier = [];
	var load = 0;
	var score = 0;
	var timeL = (new Date(year, month - 1, 1, adjust, -15, 0)).getTime();
	var arg_r = -1;
	var r_max = Math.max.apply(null, scores);

	var red_case = 0;
	var yellow_case = 0;
	
	for (var i = 0; i < 100; i++) {
		
		var r = r_max - (r_max * i * 0.01);
		var numerator = 0;
		var prob = 0;
		for (var j = 0; j < monthlyData.length; j++) {		
			var Rxy = scores[j];
       		if (Rxy < r) {
        	    numerator += 1;
		   		prob = numerator / scores.length;
        	}
		}
	    if (prob < beta) {
	        arg_r = r;
	        break;
	    }
	}

	if (arg_r == -1)
        arg_r = Math.max.apply(null, scores);

    var e_xy1 = alpha1 * arg_r;
    var e_xy2 = alpha2 * arg_r;
	
	for (var j = 0; j < monthlyData.length; j++) {
		timeL = timeL + 1000 * 60 * 15;
		var score = scores[j];
        if (score > e_xy2) {
        	red_case ++;
			load = monthlyData[j];
			outlier.push( {
				x: timeL,
				y: load,
				z: score
			});			
		} else if (e_xy1 < score && score < e_xy2) {
			yellow_case ++;
			load = monthlyData[j];
			outlier.push( {
				x: timeL,
				y: load,
				z: score
			});	
		}
	}
	
    Highcharts.chart('container', {
        chart: {
            backgroundColor: null,
            zoomType: 'x'
        },
        title: {
            text: '<b>Load Profile</b>'
        },
        xAxis: {
            type: 'datetime',
        },
        yAxis: [{
            title: {
                text: 'Load [kW]'
            }, 
            min: 0
        },{ // Primary yAxis
            opposite: true,
            min: 0,
            labels: {
                format: '{value}°C',
                style: {
                    color: '#89A54E'
                }
            },
            title: {
                text: 'Outlier Score',
                style: {
                    color: '#89A54E'
                }
            }
        }],

        legend: {
            enabled: true
        },
        plotOptions: {
        	bubble: {
        		minSize: 5,
                maxSize: 20
         	},
        	series: {
        		turboThreshold: 3000
        	},
            area: {
                fillColor: {
                    linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
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
            name: 'Load',
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
        },{
            type: 'bubble',
            name: 'Possible Outlier',
            data: outlier,
            visible: true,
            tooltip: {
                pointFormat: ''
            },
            marker: {
                fillColor: {
                    radialGradient: { cx: 0.4, cy: 0.3, r: 0.7 },
                    stops: [
                        [0, 'rgba(255,255,255,0.5)'],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[1]).setOpacity(0.5).get('rgba')]
                    ]
                }
            }
        }]
    });
}

function dynamicPeakLoad(loadData) {
	
	var timeL = (new Date(year, month - 1, 1, 0, -15, 0)).getTime();
	var maxTime = null;
    var day = 1;
    var hour = 0;
    var minute = 0;
	
    $(function() {
        $('#peak_load').highcharts({
            chart: {
                type: 'column',
                backgroundColor: null,
                events: {
                    load: function() {
                    	var maxValue = 0;
                        var series0 = this.series[0];

                        for (var index = 0; index < loadData.length; index++) {
                        	
                        	timeL = timeL + 1000 * 60 * 15;
                        	
                        	var y0 = loadData[index];
                            if (loadData[index] > maxValue) {
                            	maxTime = timeL;
                            	maxValue = loadData[index];
                            	
                            	day = Math.floor(index / 96) + 1;
                            	hour = Math.floor((index - ((day-1) * 96))/4);
                            	minute = (index - ((day-1) * 96) - (hour * 4)) * 15;
                            	
                            	
                            }
                        }
                        series0.setData([maxValue]);
                    }
                }
            },
            title: {
                text: '<b>Peak Load</b>'
            },
            legend: {
                enabled: false
            },
            xAxis: {
                categories: ['Basecase'] //['With Battery']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Peak Load (kW)'
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
    
    var dispTime = month + "/" + day + "/" + year + " " + hour + ":" + minute;
    document.getElementById("peak_time").innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Peak Occured @" + dispTime;
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
#heatmapview {
  width: 520px;
  height: 420px;
}

#heatmapOutlierView {
  width: 520px;
  height: 420px;
}

#savingview {
  width: 530px;
  height: 420px;
}

#savingview {
  width: 530px;
}
</style>

</html>
