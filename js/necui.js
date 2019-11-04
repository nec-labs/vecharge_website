// function to return all folders in a directory
//k var fso = new ActiveXObject("Scripting.FileSystemObject");

// all global variables will be defined under this variable
//var GlobalVars = {
//		"listOfBattConfig": {
//			"listOfkWh": [],
//			"listOfkW": [],
//			"price": []
//		},
//		"loads": {
//				"loadsAssoTariff":[],
//				"loadsAvg":[],
//				"loadsMax":[],
//				"loadsMin":[],
//				"loadsMaxToAvg": []
//		},
//		"listOfLoads": [],
//		"listOfTariffs": [],
//		"listOfCombinations":{
//				"has_perfect_case":[],
//				"batt_sizes_kWh":[],
//				"batt_sizes_kW":[],
//				"load_name":[],
//				"tariff_name":[],
//				"sel_batt_sizes_kWh":[],
//				"sel_batt_sizes_kW":[],
//				"operable":[]
//		},
//		"currentSavedResultPath": [],
//		"currentAnalyzeResultPath": [],
//		"commonSimuConfig":[],
//		"createdCSFile":[],
//		"listOfCombinationsSensAna":{
//				"has_perfect_case":[],
//				"batt_sizes_kWh":[],
//				"batt_sizes_kW":[],
//				"load_name":[],
//				"tariff":{
//					"loadsAssoTariff":[]
//				},
//				"sel_batt_sizes_kWh":[],
//				"sel_batt_sizes_kW":[],
//				"perfectCaseRunning":[],
//				"BattReserveSensRange":[],
//				"DCTRatioSensRange":[],
//				"DCTDaysSensRange":[],
//				"commonSimuConfig":[],
//				"createdCSFile":[]
//		},
//		"currentSavedSensPath":[]
//};


// local implementation of map(Number) which is not supported in this IE version
Array.prototype.map = Array.prototype.map || function(_x) {
    for(var o=[], i=0; i<this.length; i++) {
        o[i] = _x(this[i]);
    }
    return o;
};

// local implementation of Max and Min function for an array
Array.prototype.max = function() {
  return Math.max.apply(null, this);
};

Array.prototype.min = function() {
  return Math.min.apply(null, this);
};


//==========================================================================================================================================================
//  importing raw load data: reading from a single-columned CSV file which has kW load demand data
//==========================================================================================================================================================
function importRawLoadData() {

	// checking all fields of required data are given
	var importNewLoadName = document.getElementById("importLoadName").value.trim();
	if (importNewLoadName == '') {
		alert("Please enter the load name.");
		formreset(document.getElementById("importLoadName"));
		return false;
	}
	var importStartYearVal = document.getElementById("importStartYear").value.trim();
	if (!importStartYearVal.match(/^\d{4}$/)) {
		alert("Start year value should be a positive number in YYYY format.");
		formreset(document.getElementById("importStartYear"));
		return false;
	}
	var importStartMonthVal = document.getElementById("importStartMonth").value.trim();
	if (importStartMonthVal > 12 || importStartMonthVal < 1) {
		alert("Start month cannot be bigger than 12 or smaller than 1.");
		formreset(document.getElementById("importStartMonth"));
		return false;
	} else if (!importStartMonthVal.match(/^(0?[1-9]|[1-9][0-9])$/)) {
		alert("Start month should be a digit between 1 and 12.");
		formreset(document.getElementById("importStartMonth"));
		return false;
	}
	var importAssocTariff = document.getElementById("importAssiTariff").value.trim().toUpperCase();
	if (importAssocTariff == '') {
		alert("Please enter the assigned (default) tariff of the load.");
		formreset(document.getElementById("importAssiTariff"));
		return false;
	}

	var RawLoadPath = document.getElementById("importRawLF").value;
	if (RawLoadPath == '') {
		alert("Please enter the assigned (default) tariff of the load.");
		formreset(document.getElementById("importRawLF"));
		return false;
	}


	// check the load does not exist in the folder
	if ($.inArray(importNewLoadName , GlobalVars.listOfLoads) != -1) {
		alert(importNewLoadName + " load name already exist in the list above. If the load your are importing is new, please choose a different name.");
		formreset(document.getElementById("importLoadName"));
		return false;
	}

	// create subfolder in "load" folder
	WshShell = new ActiveXObject("WScript.Shell");
	strPath = WshShell.CurrentDirectory;
	var myObject = new ActiveXObject("Scripting.FileSystemObject");

	try {

		// reading the original load profile
		var fsoN = new ActiveXObject("Scripting.FileSystemObject");
		var fsoNh = fsoN.OpenTextFile(RawLoadPath, 1 , true);
		var line = fsoNh.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );
		line = line.slice(1,line.length).map(Number);
		fsoNh.Close();

		// adding new load to the globalVar list of loads
		GlobalVars.listOfLoads.push(importNewLoadName);

		// calculating the average of the load profile
		var sum = 0;
		for (i = 0 ; i < line.length ; i++) {
			sum += line[i];
		}

		// adding the tariff of the load to the list
		GlobalVars.loads.push({
			"loadsAssoTariff":importAssocTariff,
			"loadsAvg":Number((sum / line.length).toFixed(2)),
			"loadsMax":Math.max.apply(Math,line),
			"loadsMin":Math.min.apply(Math,line),
			"loadsMaxToAvg": Number((Math.max.apply(Math,line) / (sum / line.length)).toFixed(2))
		});

		// create  new subfolder now
		myObject.CreateFolder(strPath + "\\load\\" + importNewLoadName);

		// creating settings.csv file
		var fhNN = fsoN.OpenTextFile(strPath + "\\load\\" + importNewLoadName + "\\settings.csv", 2 , true);
		var settingsLines = 'StartYear,' + importStartYearVal + '\n' +
							'StartMonth,' + importStartMonthVal + '\n' +
							'avg,' + GlobalVars.loads[GlobalVars.loads.length - 1].loadsAvg + '\n' +
							'max,' + GlobalVars.loads[GlobalVars.loads.length - 1].loadsMax + '\n' +
							'min,' + GlobalVars.loads[GlobalVars.loads.length - 1].loadsMin + '\n' +
							'max to avg,' + GlobalVars.loads[GlobalVars.loads.length - 1].loadsMaxToAvg + '\n' +
							'Tariff,' + GlobalVars.loads[GlobalVars.loads.length - 1].loadsAssoTariff;
    	fhNN.WriteLine(settingsLines);
    	fhNN.Close();

    	// create monthly load profiles
    	var monthMat = ["jan" , "feb" , "mar" , "apr" , "may" , "jun" , "jul" , "aug" , "sep" , "oct" , "nov" , "dec"];
    	monthMat = monthMat.concat(monthMat.splice(0 , Number(importStartMonthVal) - 1));

    	var yearMat = Array.apply(null, Array(12 - Number(importStartMonthVal) + 1)).map(function(){return Number(importStartYearVal)});
    	if (Number(importStartMonthVal) != 1) {
    		var yearMat2 = Array.apply(null, Array(Number(importStartMonthVal) - 1)).map(function(){return Number(importStartYearVal) + 1});
    		yearMat = yearMat.concat(yearMat2);
    	}

    	// leap year ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)
    	var monthNumber = [31 , 28 , 31 , 30 , 31 , 30 , 31 , 31 , 30 , 31 , 30 , 31];
    	if (((Number(yearMat[$.inArray("feb",monthMat)]) % 4 == 0) && (Number(yearMat[$.inArray("feb",monthMat)]) % 100 != 0)) || (Number(yearMat[$.inArray("feb",monthMat)]) % 400 == 0)) {
    		monthNumber[1] = 29;
    	}
    	monthNumber = monthNumber.concat(monthNumber.splice(0 , Number(importStartMonthVal) - 1));


    	for (mon = 0 ; mon < 12 ; mon++) {
    		var lineMonthly = '';
    		for (day = 0 ; day < monthNumber[mon] ; day++) {
    			var dayValues = line.splice(0 , 24 * 4);

    			for (items = 0 ; items < 24 * 4 ; items++) {
    				if (items == 24 * 4 - 1) {
    					lineMonthly += dayValues[items];
    				} else {
    					lineMonthly += dayValues[items] + ",";
    				}
    			}
    			if (day != monthNumber[mon] - 1) {
    				lineMonthly += "\n";
    			}
    		}

    		// write in the CSV file
    		var fhNN = fsoN.OpenTextFile(strPath + "\\load\\" + importNewLoadName + "\\" + importNewLoadName + "_" + monthMat[mon] + "_" + yearMat[mon] + ".csv", 2 , true);
    		fhNN.WriteLine(lineMonthly);
        	fhNN.Close();
    	}

    	document.getElementById("help-block").innerHTML = "'" + importNewLoadName + "' profile is created successfully. You can see the CSV files in " +
    													  strPath + "\\load\\" + importNewLoadName + " folder";

    	window.setTimeout(function() {
    		document.getElementById("help-block").innerHTML = '';
		}, 5000);

    	// updaing the current list of loads/tariff in the UI
    	listAllLoadsTariffs();

	} catch(error) {
		alert(error.message);
		// Folder already exists. So do nothing
	}

};

//==========================================================================================================================================================
//  checking Battery Reserve, DCT Reduction, and DCT days for EMS run and sensitivity analysis
//==========================================================================================================================================================
function checkSensitiveParameters(valueinput,type,maxLimit,minLimit) {
	var val = valueinput.value;

	if (type == 1) { // type = 1 is for "RUN NEC EMS" button
		var patt1 = /^-?\d*\.?\d+$/;
		var patt2 = /^-?\d*\.\:?\d+$/; // /^[0-9.:]+$/;

		// check to have positive number
		if (!val.match(patt1)) {
			alert("Input must be a valid positive number.");
			formreset(valueinput);
			return false;
		} else if (val > maxLimit || val < minLimit) { // check to be within specified limits
			alert("Input cannot be bigger than maximum limit (" + maxLimit + ") or lower than minimum limit (" + minLimit + ").");
			formreset(valueinput);
			return false;
		}

	} else { // type == 2 is for "RUN SENSITIVITY ANALYSIS"

		// check to have only numbers and ":" in the input box
		if (!val.match(patt2)) {
			alert("Acceptable format for Tuning Parameters Study is begin:step:end (e.g., " + minLimit + ":10:" + maxLimit + ").");
			formreset(valueinput);
			return false;
		} else { // input format is correct, but lets check other parameters

			var beginStepEnd = val.split(":").map(Number);

			if (beginStepEnd.length == 3) {
				// check min and max limits
				if (beginStepEnd[0] < minLimit || beginStepEnd[2] > maxLimit) {
					alert("Input cannot be bigger than maximum limit (" + maxLimit + ") or lower than minimum limit (" + minLimit + ").");
					formreset(valueinput);
					return false;
				}

				// checking relations between begin, step, and end
				if (beginStepEnd[0] < beginStepEnd[2] && beginStepEnd[1] < 0) { // if begin < end, then step should be positive
					alert("Beginning of the range (" + beginStepEnd[0] + ") is lower than the end of the range (" + beginStepEnd[2] + "). So step value (" + beginStepEnd[1] + ") should be positive.");
					formreset(valueinput);
					return false;
				}

				if (beginStepEnd[0] > beginStepEnd[2] && beginStepEnd[1] > 0) {
					alert("Beginning of the range (" + beginStepEnd[0] + ") is higher than the end of the range (" + beginStepEnd[2] + "). So step value (" + beginStepEnd[1] + ") should be negative.");
					formreset(valueinput);
					return false;
				}

				if (beginStepEnd[1] == 0) {
					alert("Step value (" + beginStepEnd[1] + ") cannot be zero.");
					formreset(valueinput);
					return false;
				}
			} else if (beginStepEnd.length == 1) {
				if (val > maxLimit || val < minLimit) { // check to be within specified limits
					alert("Input cannot be bigger than maximum limit (" + maxLimit + ") or lower than minimum limit (" + minLimit + ").");
					formreset(valueinput);
					return false;
				}
			} else {
				alert("Please follow begin:step:end format for Tuning Parameters study.");
				formreset(valueinput);
				return false;
			}
		}
	}

	return true;
}



//==========================================================================================================================================================
//to check existing Perfect cases and create "CS_...csv" files sensitivity analysis run
//==========================================================================================================================================================
function existingPerfectCasesSensAnalysis() {

	var fsoN2 = new ActiveXObject("Scripting.FileSystemObject");
	var dailyResultsPath = GlobalVars.currentSavedResultPath + '/daily/CS_';

	//-------------------------------------------------------------------------------------------------
	// reseting all existing values
	GlobalVars.listOfCombinationsSensAna.has_perfect_case = [];
	GlobalVars.listOfCombinationsSensAna.commonSimuConfig = [];
	GlobalVars.listOfCombinationsSensAna.createdCSFile = [];
	GlobalVars.listOfCombinationsSensAna.perfectCaseRunning = false;


	/*alert(GlobalVars.listOfCombinationsSensAna.BattReserveSensRange.length);
	alert(GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange.length);
	alert(GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange.length);
	alert(GlobalVars.listOfCombinationsSensAna.tariff);*/
	//-------------------------------------------------------------------------------------------------
	// looping through all possible combinations of battConfig/load/tariff/CapReserve/DCTRatio/DCTDays
	var counter = 0;

	loop1:
	for (C_BattSize = 0 ; C_BattSize < GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh.length ; C_BattSize++) { // loop through all selected battery config
		for (C_LoadName = 0 ; C_LoadName < GlobalVars.listOfCombinationsSensAna.load_name.length ; C_LoadName++) {  // loop through all selected load profiles
			for (C_AssoTariff = 0 ; C_AssoTariff < GlobalVars.listOfCombinationsSensAna.tariff[C_LoadName].loadsAssoTariff.length ; C_AssoTariff++) { // loop through all associated tariff of each load
				for (Counter_BattReserve = 0; Counter_BattReserve < GlobalVars.listOfCombinationsSensAna.BattReserveSensRange.length ; Counter_BattReserve++) { // loop thorugh different reserve values
					for (Counter_DCTRatio = 0; Counter_DCTRatio < GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange.length ; Counter_DCTRatio++) { // loop through different DCT Ratio values
						for (Counter_DCTDays = 0; Counter_DCTDays < GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange.length ; Counter_DCTDays++) { // loop through different DCT days values

							var dailyResultsFullPath = (GlobalVars.currentSavedSensPath + '\\daily\\CS_' +
									   GlobalVars.listOfCombinationsSensAna.load_name[C_LoadName] + '_' +
									   GlobalVars.listOfCombinationsSensAna.tariff[C_LoadName].loadsAssoTariff[C_AssoTariff] + '_' +
									   GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh[C_BattSize] + 'kWh_' +
									   GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW[C_BattSize] + 'kW_' +
									   Number(document.getElementById("battMinSOC").value) + "_" +
									   Number(document.getElementById("battMaxSOC").value) + "_" +
									   Number(document.getElementById("roundTripEff").value) + "_" +
									   Number(document.getElementById("battDeg").value) + "_" +
									   Number(document.getElementById("battInitSOC").value) + "_" +
									   GlobalVars.listOfCombinationsSensAna.BattReserveSensRange[Counter_BattReserve] + "_" +
								       GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange[Counter_DCTRatio] + "_" +
									   GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange[Counter_DCTDays] + ".csv");

							dailyResultsFullPath = dailyResultsFullPath.replace(/\\/g,"/");

							// check if file exists
							try {

								var fhN2 = fsoN2.OpenTextFile(dailyResultsFullPath , 1);

								// if an error is not thrown, means that the absolute Perfect case for this combination exists
								GlobalVars.listOfCombinationsSensAna.commonSimuConfig.push(true);

								// Read the whole file
								var line = fhN2.ReadAll();
								fhN2.Close();

								// delete existing file
								fsoN2.DeleteFile(dailyResultsFullPath);

								// truncate lines related to prediction case
								if (line.indexOf('prediction') == -1) { // this file does not have Prediction case at all. it has only perfect case
									line = line.substring(0, line.length - 2);
								} else {
									line = line.substring(0, line.indexOf('prediction') - 2);
								}


								// re-write the old results for perfect case
								var fhNN = fsoN2.OpenTextFile(dailyResultsFullPath, 2 , true);
						    	fhNN.WriteLine(line);
						    	fhNN.Close();

								// Perfect case exists
								GlobalVars.listOfCombinationsSensAna.has_perfect_case.push(true && GlobalVars.listOfCombinationsSensAna.commonSimuConfig[counter]);

							} // END OF try

							catch(error) {
								//alert(error.message);
								// Perfect case does still might exist when prediction case and consequently the file name are partially different
								var fileSearch = 'CS_' +
										   GlobalVars.listOfCombinationsSensAna.load_name[C_LoadName] + '_' +
										   GlobalVars.listOfCombinationsSensAna.tariff[C_LoadName].loadsAssoTariff[C_AssoTariff] + '_' +
										   GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh[C_BattSize] + 'kWh_' +
										   GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW[C_BattSize] + 'kW_' +
										   Number(document.getElementById("battMinSOC").value) + "_" +
										   Number(document.getElementById("battMaxSOC").value) + "_" +
										   Number(document.getElementById("roundTripEff").value) + "_" +
										   Number(document.getElementById("battDeg").value) + "_";

								// finding all the files in the daily folder
								var fsoNN = new ActiveXObject("Scripting.FileSystemObject");
								var allFiles = fsoNN.GetFolder(GlobalVars.currentSavedSensPath + '\\daily');
								var fc = new Enumerator(allFiles.files); var eachFile, lines, linesN, perfectExist = false;

								for (; !fc.atEnd(); fc.moveNext()){
									eachFile = fc.item().Name;
									if (eachFile.indexOf(fileSearch) != -1) { // they are the same, the perfect case exists, we should make a copy of the file

										// update global vairable
										GlobalVars.listOfCombinationsSensAna.createdCSFile.push(dailyResultsFullPath);

										// read content of the existing perfect case which has different prediction case and file name
										fhN2 = fsoNN.OpenTextFile(fc.item(), 1);
										lines = fhN2.ReadAll();
										fhN2.Close();

										// open/create file for the new case (same perfect but different prediction case and file name)
										fhN2 = fsoNN.OpenTextFile(dailyResultsFullPath , 2 , true);
										linesN = 'Load_Name, ' + GlobalVars.listOfCombinationsSensAna.load_name[C_LoadName] + '\n' +
												 'Tariff_Name, ' + GlobalVars.listOfCombinationsSensAna.tariff[C_LoadName].loadsAssoTariff[C_AssoTariff] + '\n' +
												 'kWh, ' + GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh[C_BattSize] + '\n' +
												 'kW, ' + GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW[C_BattSize] + '\n' +
												 'Min_SOC, ' + Number(document.getElementById("battMinSOC").value) + "\n" +
												 'Max_SOC, ' + Number(document.getElementById("battMaxSOC").value) + "\n" +
												 'Batt_Eff, ' +Number( document.getElementById("roundTripEff").value) + "\n" +
												 'Batt_Aging_Cost, ' + Number(document.getElementById("battDeg").value) + "\n" +
												 'Init_SOC, ' + Number(document.getElementById("battInitSOC").value) + "\n" +
												 'Batt_Reserve, ' + GlobalVars.listOfCombinationsSensAna.BattReserveSensRange[Counter_BattReserve] + "\n" +
												 'DCT_Adj, ' + GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange[Counter_DCTRatio] + "\n" +
												 'DCT_Hor, ' + GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange[Counter_DCTDays] + "\n";

										if (lines.indexOf('prediction') == -1) { // this file does not have Prediction case at all. it has only perfect case
											fhN2.WriteLine(linesN + lines.substring(lines.indexOf('Analysis Type'), lines.length - 2));
										} else {
											fhN2.WriteLine(linesN + lines.substring(lines.indexOf('Analysis Type'), lines.indexOf('prediction') - 2));
										}

										fhN2.Close();

										perfectExist = true;
										break;

									}
								}

								/*alert("C_BattSize = " + C_BattSize);
								alert("Counter_BattReserve = " + Counter_BattReserve);
								alert("Counter_DCTRatio = " + Counter_DCTRatio);
								alert("Counter_DCTDays = " + Counter_DCTDays);
								alert(GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh[C_BattSize]);
								alert(GlobalVars.listOfCombinationsSensAna.BattReserveSensRange[Counter_BattReserve]);
								alert(GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange[Counter_DCTRatio]);
								alert(GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange[Counter_DCTDays]);*/

								if (perfectExist) {
									GlobalVars.listOfCombinationsSensAna.has_perfect_case.push(true);
									GlobalVars.listOfCombinationsSensAna.commonSimuConfig.push(true);

								} else { // no Perfect case (asbsolute or partial) exists for this combination. so we should run perfect case

									// global variable to let "RunSensAnalysis()" function know that the perfect case is called
									GlobalVars.listOfCombinationsSensAna.perfectCaseRunning = true;
//alert("no absolute or partial Perfect case");
									// create batch file with the case which does not have absolute or partial Perfect case
									createBatchFileSensAnalysis([GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh[C_BattSize]] ,
																[GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW[C_BattSize]] ,
																[GlobalVars.listOfCombinationsSensAna.load_name[C_LoadName]] ,
																[GlobalVars.listOfCombinationsSensAna.tariff[C_LoadName]] ,
																[GlobalVars.listOfCombinationsSensAna.BattReserveSensRange[Counter_BattReserve]] ,
																[GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange[Counter_DCTRatio]] ,
																[GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange[Counter_DCTDays]] ,
																GlobalVars.currentSavedSensPath ,
																false);

									// changing "ProgStatusPerfect.csv" status to "Running"
									var fsoProg = new ActiveXObject("Scripting.FileSystemObject");
									var fhProg = fsoProg.OpenTextFile("ProgStatusPerfect.csv", 2 , true);
									fhProg.WriteLine("Running");
									fhProg.Close();

									// running batch file for Perfect case only
									WshShell = new ActiveXObject("WScript.Shell");
									WshShell.Run("EMSexecute.bat", 1, false);

									GlobalVars.listOfCombinationsSensAna.has_perfect_case.push(true);
									GlobalVars.listOfCombinationsSensAna.commonSimuConfig.push(true);

									// leaving all nested loops
									break loop1;
								}
							} // END OF catch(error)

							counter++;

						} // END OF Counter_DCTDays

					} // END OF Counter_DCTRatio

				} // END OF Counter_BattReserve

			} // END OF for (C_AssoTariff = 0;C_AssoTariff < GlobalVars.loads[j].loadsAssoTariff.length; C_AssoTariff++)

		} // END OF for (C_LoadName = 0;C_LoadName < loadConfig.length; C_LoadName++) {

	} // END OF for (C_BattSize = 0; C_BattSize < batteryConfig.length; C_BattSize++)
};


//==========================================================================================================================================================
//we find all possible cases to form sensitivity analysis
//==========================================================================================================================================================
function findAllCasesSensAnalysis() {

	var fsoN2 = new ActiveXObject("Scripting.FileSystemObject");
	var dailyResultsPath = GlobalVars.currentSavedResultPath + '/daily/CS_';

	//-------------------------------------------------------------------------------------------------
	// reseting all existing values
	GlobalVars.listOfCombinationsSensAna.batt_sizes_kWh = [];
	GlobalVars.listOfCombinationsSensAna.batt_sizes_kW = [];
	GlobalVars.listOfCombinationsSensAna.load_name = [];
	GlobalVars.listOfCombinationsSensAna.tariff = [];
	//GlobalVars.listOfCombinationsSensAna.tariff.push({"loadsAssoTariff":[]});
	GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh = [];
	GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW = [];
	GlobalVars.listOfCombinationsSensAna.BattReserveSensRange = [];
	GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange = [];
	GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange = [];


	//-------------------------------------------------------------------------------------------------
	//create list of all existing battery sizes
	for (var i = 0 ; i < GlobalVars.listOfBattConfig.listOfkWh.length ; i++) {
		GlobalVars.listOfCombinationsSensAna.batt_sizes_kWh.push(GlobalVars.listOfBattConfig.listOfkWh[i]);
		GlobalVars.listOfCombinationsSensAna.batt_sizes_kW.push(GlobalVars.listOfBattConfig.listOfkW[i]);
	}

	//-------------------------------------------------------------------------------------------------
	// finding all elements with the name of "batteryConfig" and "loadConfig" in the UI
	var batteryConfig = document.getElementsByName("batteryConfig");
	var loadConfig = document.getElementsByName("loadConfig");

	//-------------------------------------------------------------------------------------------------
	// creating list of all selected combination of battery config/load/tariff
	var counting = 0;  // to count the number of scenarios and enforce only one scenario (battSize/load) for sensitivity analysis

	for (CBattSize = 0 ; CBattSize < batteryConfig.length ; CBattSize++) {
		for (CLoadConf = 0 ; CLoadConf < loadConfig.length ; CLoadConf++) {
			if (batteryConfig[CBattSize].checked && loadConfig[CLoadConf].checked) {
				GlobalVars.listOfCombinationsSensAna.tariff.push({"loadsAssoTariff":[]});
				for (CTariff = 0 ; CTariff < GlobalVars.loads[CLoadConf].loadsAssoTariff.length ; CTariff++) {

					// to enforce only one secnario of battery size and load
					if (counting != 0) {
						alert("Only one combination of battery size, load profile, and tariff is allowed for Tuning Parameters Study. Please try again.");
						return false;
					}

					GlobalVars.listOfCombinationsSensAna.load_name.push(loadConfig[CLoadConf].value);
					GlobalVars.listOfCombinationsSensAna.tariff[counting].loadsAssoTariff.push(GlobalVars.loads[CLoadConf].loadsAssoTariff[CTariff]); // it can now handle differnet number of tariff for the selected loads
					GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh.push(GlobalVars.listOfCombinationsSensAna.batt_sizes_kWh[CBattSize]);
					GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW.push(GlobalVars.listOfCombinationsSensAna.batt_sizes_kW[CBattSize]);

					counting++;

				} // END OF for (CTariff = 0;CTariff < GlobalVars.loads[j].loadsAssoTariff.length; CTariff++)

			} // END OF if (batteryConfig[i].checked && loadConfig[j].checked)

		} // END OF for (CLoadConf = 0;CLoadConf < loadConfig.length; CLoadConf++) {

	} // END OF for (CBattSize = 0; CBattSize < batteryConfig.length; CBattSize++)

	// propagate error if no battery size or load profile is not selected
	if (counting === 0) {
		alert("One combination of battery size, load profile, and tariff should be selected for Tuning Parameters Study. Please try again.");
		return false;
	}
	//alert(GlobalVars.listOfCombinationsSensAna.load_name);
	//alert(GlobalVars.listOfCombinationsSensAna.tariff[0].loadsAssoTariff);
	//alert(GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh);
	//alert(GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW);

	//-------------------------------------------------------------------------------------------------
	// creating list of all Battery Reserve, DCT Ratio, and DCT Days values for sensitivity analysis
	var tempRange = document.getElementById("battResCap").value.replace( /(?:[|])/g, "" ).replace( / /g, "" ).split( /:/ ).map(Number);
	if (tempRange.length == 1) { // if we have a single value instead of a list
		GlobalVars.listOfCombinationsSensAna.BattReserveSensRange.push(tempRange);
	} else {
		for (var i = tempRange[0] ; i <= tempRange[2] ; i+=tempRange[1] ) {
			GlobalVars.listOfCombinationsSensAna.BattReserveSensRange.push(i);
		}
	}

	//alert(GlobalVars.listOfCombinationsSensAna.BattReserveSensRange);


	var tempRange = document.getElementById("DCTAdjusRatio").value.replace( /(?:[|])/g, "" ).replace( / /g, "" ).split( /:/ ).map(Number);
	if (tempRange.length == 1) { // if we have a single value instead of a list
		GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange.push(tempRange);
	} else {
		for (var i = tempRange[0] ; i <= tempRange[2] ; i+=tempRange[1] ) {
			GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange.push(i);
		}
	}

	//alert(GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange);

	var tempRange = document.getElementById("DCTHorizon").value.replace( /(?:[|])/g, "" ).replace( / /g, "" ).split( /:/ ).map(Number);
	if (tempRange.length == 1) { // if we have a single value instead of a list
		GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange.push(tempRange);
	} else {
		for (var i = tempRange[0] ; i <= tempRange[2] ; i+=tempRange[1] ) {
			GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange.push(i);
		}
	}

	//alert(GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange);

	return true;
};


//==========================================================================================================================================================
// creating the batch file for Sensitivity Analysis
//==========================================================================================================================================================
function createBatchFileSensAnalysis(battConfigskWh , battConfigskW , loadConfigs , tariffConfigs , ReserveRange , DCTRatioRange , DCTDaysRange , SavePath , HasPerfect) {

	var count = 0; // to count total number of combinations created for simulation
	var total_runs = 0; // to count total number of executable calls created
	var Month_raw = ["jan" , "feb" , "mar" , "apr" , "may" , "jun" , "jul" , "aug" , "sep" , "oct" , "nov" , "dec"];

	var lines = "@echo off\n";


	var get_EMSresult_type = 0;
	if (document.getElementById("saveEMSresults").checked) {
		get_EMSresult_type = 1;
	}

//alert(ReserveRange[0]);
//alert(typeof ReserveRange[0]);
//alert(ReserveRange[1]);
//alert(DCTRatioRange[0]);
	var startMONTHN = -1000;
	var endMONTHN = -1000;
	var fsoN = new ActiveXObject("Scripting.FileSystemObject");
	//-------------------------------------------------------------------------------------------------
	for (C_BattConfig = 0; C_BattConfig < battConfigskWh.length ; C_BattConfig++) { // loop through selected battery configs
		for (C_LoadConfig = 0 ; C_LoadConfig < loadConfigs.length ; C_LoadConfig++) { // loop through selected load configs
			for (k = 0 ; k < tariffConfigs[C_LoadConfig].loadsAssoTariff.length ; k++) {  // loop through differnet tariff associated with the selected load
				for (C_Reserve = 0 ; C_Reserve < ReserveRange.length ; C_Reserve++) { // loop through different Battery Reserve range
					for (C_DCTRatio = 0; C_DCTRatio < DCTRatioRange.length ; C_DCTRatio++) { // loop through different DCT ratios
						for (C_DCTDays = 0; C_DCTDays < DCTDaysRange.length ; C_DCTDays++) { // loop through different DCT days

							// reading settings.csv file from selected combination
							var resultFileName = "load/" + loadConfigs[C_LoadConfig] + "/settings.csv";

							try { // check if the file exists in the folder
								var ForReading = 1;
								var fsoNh = fsoN.OpenTextFile(resultFileName, ForReading);
								var line = fsoNh.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );
								fsoNh.Close();

								startYEAR = line[1];
								startMONTHN = line[3];

								// check if required load and tariff files exist
								var mess = fileCheck(loadConfigs[C_LoadConfig] , tariffConfigs[C_LoadConfig].loadsAssoTariff[k] , Number(startYEAR) , Number(startMONTHN));

								if (mess != '') {
									alert(mess);
									continue;
								}

								if (startMONTHN == 1) {
									endMONTHN = 12;
								} else {
									endMONTHN = startMONTHN - 1;
								}

								if (count == 0) { // first iteration
									lines += "title Operation progress: 0%% is completed.\n" +
											 "cd bin\n";
								}


								lines +="CSCRIPT SLEEP.VBS 500\n" +
										"cd ../settings \n" +
										"if exist Config.csv del Config.csv \n" +
								        "@echo BattratedAh,"+ battConfigskWh[C_BattConfig] * 1000 / 48 +" >> Config.csv \n" +
									    "@echo BattratedVolt,48 >> Config.csv\n" +
									    "@echo BattMinSoC," + document.getElementById("battMinSOC").value + " >> Config.csv\n" +
									    "@echo BattMaxSoC," + document.getElementById("battMaxSOC").value + " >> Config.csv\n" +
									    "@echo BattInitSoC," + document.getElementById("battInitSOC").value + " >> Config.csv\n" +
									    "@echo BatteryMaxPower," + battConfigskW[C_BattConfig] + " >> Config.csv\n" +
									    "@echo BatteryReserveCapacity," + ReserveRange[C_Reserve] + " >> Config.csv\n" +
									    "@echo DCTAdjustmentRatio," + DCTRatioRange[C_DCTRatio] + " >> Config.csv\n" +
									    "@echo DCTHorizon," + DCTDaysRange[C_DCTDays] + " >> Config.csv\n" +
									    "@echo RoundTripEff," + document.getElementById("roundTripEff").value + " >> Config.csv\n" +
									    "@echo DegradationCost," + document.getElementById("battDeg").value + " >> Config.csv\n" +
									    "if exist Simulation_Config.csv del Simulation_Config.csv \n" +
									    "@echo LoadName," + loadConfigs[C_LoadConfig] + " >> Simulation_Config.csv \n" +
									    "@echo TariffName," + tariffConfigs[C_LoadConfig].loadsAssoTariff[k] + " >> Simulation_Config.csv \n" +
									    "@echo StartYear," + startYEAR + " >> Simulation_Config.csv \n" +
									    "@echo StartMonth," + startMONTHN + " >> Simulation_Config.csv \n" +
									    "@echo noOfMonth," + 12 + " >> Simulation_Config.csv \n" +
									    "@echo startMonthSimulation," + Month_raw[startMONTHN - 1] + " >> Simulation_Config.csv \n" +
									    "@echo endMonthSimulation," + Month_raw[endMONTHN - 1] + " >> Simulation_Config.csv \n" +
									    "@echo SummerType," + GlobalVars.tariffsSummerType[$.inArray(tariffConfigs[C_LoadConfig].loadsAssoTariff[k],GlobalVars.listOfTariffs)] + " >> Simulation_Config.csv \n" +
									    "@echo EMSresults," + get_EMSresult_type + " >> Simulation_Config.csv \n" +
									    "@echo CurrentResultPath," + SavePath + " >> Simulation_Config.csv \n";

								// check if Perfect cases already exists so not run it again;
								if (HasPerfect[count]) { // only run Prediction case
									/*if (count == 0) {
										lines += "\ncd .. \n" +
												 "if exist ProgStatus.csv del ProgStatus.csv \n@echo Running >> ProgStatus.csv \n\n" +
												 "cd bin \n";
										//lines += "cd bin \n";
									}*/

									lines += "cd ../bin \n" +
											 "CSCRIPT SLEEP.VBS 500\n" +
											 "MonthlyLayer_Prediction.exe \n" +
										     "title Operation progress: PERCENTAGE" + count + "0%% is completed. \n" +
											 "CSCRIPT SLEEP.VBS 500\n" +
										     "DailyLayer_Prediction.exe \n" +
											 "title Operation progress: PERCENTAGE" + count + "1%% is completed. \n\n";
									total_runs += 2;

								} else { // only run Perfect case
									lines += "cd ../bin \n" +
											 "CSCRIPT SLEEP.VBS 500\n" +
											 "MonthlyLayer_Perfect.exe \n" +
										     "title Operation progress: PERCENTAGE" + count + "0%% is completed. \n" +
											 "CSCRIPT SLEEP.VBS 500\n" +
										     "DailyLayer_Perfect.exe \n" +
										     "title Operation progress: PERCENTAGE" + count + "1%% is completed. \n\n" +
										     "cd .. \n" +
										     "if exist ProgStatusPerfect.csv del ProgStatusPerfect.csv \n@echo Done >> ProgStatusPerfect.csv \n";
									total_runs += 2;
								}

								count++;
							}
							catch (error) {
								//alert(error.message);
								alert("'settings.csv' file does not exist for " + loadConfigs[C_LoadConfig] + " load. Program will continue with other combinations, if selected.");
							}
						} // END OF C_DCTDays
					} // END OF C_DCTRatio
				} // END OF C_Reserve
			} // END OF tariffs associated with each load loop
		} // END OF selected loads loop
	} // END OF Battery sizes loop

	//-------------------------------------------------------------------------------------------------
	// to replace progress variables in the EMSresults.bat file with appropriate percentage numbers
	var each_run_progress = Number((100.0 / total_runs).toFixed(4));
	var run_progress = each_run_progress;


	for (i = 0; i < count; i++) {
		lines = lines.replace("PERCENTAGE" + i + "0" , run_progress.toFixed(4));
		run_progress = Number(run_progress) + Number(each_run_progress);
		lines = lines.replace("PERCENTAGE" + i + "1" , run_progress.toFixed(4));
		run_progress = Number(run_progress) + Number(each_run_progress);
	}

	if (HasPerfect[0]) {
		lines += "cd .. \nif exist ProgStatus.csv del ProgStatus.csv \n@echo Done >> ProgStatus.csv \n";
	}

	var fso1 = new ActiveXObject("Scripting.FileSystemObject");
	var fsoh1 = fso1.OpenTextFile("EMSexecute.bat", 2, true);
	fsoh1.WriteLine(lines);
	fsoh1.Close();
}


//==========================================================================================================================================================
// Run Sensitivity Analysis Function
//==========================================================================================================================================================
function RunSensAnalysis() {


	//-------------------------------------------------------------------------------------------------
	// checking given SOC values
	if (!SoCCheck(document.getElementById("battMinSOC")))
		return false;

	if (!SoCCheck(document.getElementById("battMaxSOC")))
		return false;

	// checking round-trip efficiency
	if (!roundTripEffCheck(document.getElementById("roundTripEff")))
		return false;

	// checking battery aging cost value
	if (!posvaluecheck(document.getElementById("battDeg")))
		return false;

	// checking battery initial SOC value
	if (!SoCCheck(document.getElementById("battInitSOC")))
		return false;

	// check battery reserve capacity value
	if (!checkSensitiveParameters(document.getElementById("battResCap") , 2 , 100 , 0))
		return false;

	// check battery reserve capacity value
	if (!checkSensitiveParameters(document.getElementById("DCTAdjusRatio") , 2 , 100 , -100))
		return false;

	// check battery reserve capacity value
	if (!checkSensitiveParameters(document.getElementById("DCTHorizon") , 2 , 31 , 1))
		return false;


	//-------------------------------------------------------------------------------------------------
	// find all possible cases to form sensitivity analysis
	if (!findAllCasesSensAnalysis()) {
		return false;
	}


	//-------------------------------------------------------------------------------------------------
	// Asking for a path to save results, create "daily" and "monthyl" folders if they don't exist
	WshShell = new ActiveXObject("WScript.Shell");
	strPath = WshShell.CurrentDirectory;
	SA = new ActiveXObject("Shell.Application");
	F = SA.BrowseForFolder(0, "Choose a folder to save results:", 0, "Desktop");

	if (F != null) {
		// show the selected path in the <p> tag
		document.getElementById("chosenPathSaveSensAnalysis").innerHTML = F.Self.Path;

		// create folders (daily)
		var myObject = new ActiveXObject("Scripting.FileSystemObject");
		var newFolder= '';
		try {
			newFolder = myObject.CreateFolder(F.Self.Path + "\\daily");

		} catch(error) {

			// Folder already exists. So do nothing
		}

		// create folders (monthly)
		newFolder= '';
		try {
			newFolder = myObject.CreateFolder(F.Self.Path + "/monthly");

		} catch(error) {

			// Folder already exists. So do nothing
		}

		// setting current path for results in the GlobalVars
		GlobalVars.currentSavedSensPath = F.Self.Path;


	} else {  // no path is selected by the user
		alert("It is required to specify a path where you want to save the simulation results. Please try again.");
		return false;
	}


	//-------------------------------------------------------------------------------------------------
	// to double check if user wants to run this simulation
	if (!confirm("Are you sure you want to run tunning analysis for this scenario?")) {
		return false;
	}


	//-------------------------------------------------------------------------------------------------
	// disable buttons on the UI during simulation
	document.getElementById("runSimulation").disabled = true;
	document.getElementById("analyseResults").disabled = true;
	document.getElementById("runSensitivity").disabled = true;
	document.getElementById("TuneRunSpin").style.display = "inline";


	//-------------------------------------------------------------------------------------------------
	//to check existing Perfect cases and create "CS_...csv" files sensitivity analysis run
	existingPerfectCasesSensAnalysis();

	if (GlobalVars.listOfCombinationsSensAna.perfectCaseRunning) { // it means that absolute or partial Perfect case did not exists and it is called to run

		checkEndofSimulation(2);

	} else {

		// create new batch file for all possible combination
		createBatchFileSensAnalysis([GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh] ,
									[GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW] ,
									[GlobalVars.listOfCombinationsSensAna.load_name] ,
									GlobalVars.listOfCombinationsSensAna.tariff ,
									GlobalVars.listOfCombinationsSensAna.BattReserveSensRange ,
									GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange ,
									GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange ,
									GlobalVars.currentSavedSensPath ,
									GlobalVars.listOfCombinationsSensAna.has_perfect_case);

		// changing "ProgStatusPerfect.csv" status to "Running"
		var fsoProg = new ActiveXObject("Scripting.FileSystemObject");
		var fhProg = fsoProg.OpenTextFile("ProgStatus.csv", 2 , true);
		fhProg.WriteLine("Running");
		fhProg.Close();


		//alert("no Perfect case runnng !!!");
		WshShell = new ActiveXObject("WScript.Shell");
		WshShell.Run("EMSexecute.bat", 1, false);
		checkEndofSimulation(1);
	}

};



//==========================================================================================================================================================
// to delete an entry from Battery_Config.csv
//==========================================================================================================================================================
function deleteBattConfig2(element) {

	if (!confirm("Are you sure you want to delete this battery configuration?")) {
		return false;
	}

	// reading the kWh/kW requested to be deleted
	/*var kWhSelected = $(element).prev().attr("value").match(/[\d\.]+/g)[0];
	var kWSelected = $(element).prev().attr("value").match(/[\d\.]+/g)[1];

	// removing from GlobalVars.listOfBattConfig
	for (i = 0 ; i < GlobalVars.listOfBattConfig.listOfkWh.length ; i++) {
		if (GlobalVars.listOfBattConfig.listOfkWh[i] == Number(kWhSelected) &&
			GlobalVars.listOfBattConfig.listOfkW[i] == Number(kWSelected)) {

			GlobalVars.listOfBattConfig.listOfkWh.splice(i , 1);
			GlobalVars.listOfBattConfig.listOfkW.splice(i , 1);
			GlobalVars.listOfBattConfig.price.splice(i , 1);
			break;
		}
	}


	// reading the Battery_Config.csv file to remove if exist
	var fsoN2 = new ActiveXObject("Scripting.FileSystemObject");

	try {
		//var fhN2 = fsoN2.OpenTextFile('settings/Battery_Config.csv' , 1 , true);
		var lines = fhN2.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).replace( / /g, "" ).split( /,/ );
		lines = lines.splice(2, lines.length).map(Number);
		fhN2.Close();

		// find out if the battery size exists in the csv file
		var sizeExists = false;
		for (i = 0; i < lines.length ; i+=3 ) {
			if (Number(kWhSelected) == lines[i] && Number(kWSelected) == lines[i + 1]) {
				lines.splice(i , 3);
				sizeExists = true;
			}
		}


		// delete existing file to write the new one with the removed item
		if (sizeExists) {
			fsoN2.DeleteFile('settings/Battery_Config.csv');

			// re-create Battery_Config.csv file
			var newLines = 'kWh, kW, price\n';
			for (i = 0 ; i < GlobalVars.listOfBattConfig.listOfkWh.length ; i++) {
				newLines += GlobalVars.listOfBattConfig.listOfkWh[i] + ', ' +
							GlobalVars.listOfBattConfig.listOfkW[i] + ', ' +
							GlobalVars.listOfBattConfig.price[i] + '\n';
			}
			var fhNN = fsoN2.OpenTextFile('settings/Battery_Config.csv', 2 , true);
			fhNN.WriteLine(newLines);
			fhNN.Close();
		//}

	}
	catch(error) {
		alert(error.message);
	}*/

	// remove from the UI
	$(element).closest(".config-label").remove();

};


// to check existing Perfect cases for all selected combinations for normal NEC EMS run
function existingPerfectCases(type) {

	var fsoN2 = new ActiveXObject("Scripting.FileSystemObject");
	var dailyResultsPath = GlobalVars.currentSavedResultPath + '/daily/CS_';

	GlobalVars.listOfCombinations.has_perfect_case = [];
	GlobalVars.listOfCombinations.batt_sizes_kWh = [];
	GlobalVars.listOfCombinations.batt_sizes_kW = [];
	GlobalVars.listOfCombinations.load_name = [];
	GlobalVars.listOfCombinations.tariff_name = [];
	GlobalVars.listOfCombinations.sel_batt_sizes_kWh = [];
	GlobalVars.listOfCombinations.sel_batt_sizes_kW = [];
	GlobalVars.commonSimuConfig = [];
	GlobalVars.createdCSFile = [];

	// reading battery configuration from Battery_Config.csv file
	//var allSizes = battConfigRead(2);

	//for (i = 0 ; i < allSizes[0].length ; i++) {
	for (i = 0 ; i < GlobalVars.listOfBattConfig.listOfkWh.length ; i++) {
		//GlobalVars.listOfCombinations.batt_sizes_kWh.push(allSizes[0][i]);
		GlobalVars.listOfCombinations.batt_sizes_kWh.push(GlobalVars.listOfBattConfig.listOfkWh[i]);
		//GlobalVars.listOfCombinations.batt_sizes_kW.push(allSizes[1][i].replace(/ /g,''));
		GlobalVars.listOfCombinations.batt_sizes_kW.push(GlobalVars.listOfBattConfig.listOfkW[i]);
	}

	//var batteryConfig = document.forms[0];
	var batteryConfig = document.getElementsByName("batteryConfig");
	var loadConfig = document.getElementsByName("loadConfig");
	var counter = 0;
	for (i = 0; i < batteryConfig.length; i++) {
		for (j = 0;j < loadConfig.length; j++) {
			for (k = 0;k < GlobalVars.loads[j].loadsAssoTariff.length; k++) {
				if (batteryConfig[i].checked && loadConfig[j].checked) {

					GlobalVars.listOfCombinations.load_name.push(loadConfig[j].value);
					GlobalVars.listOfCombinations.tariff_name.push(GlobalVars.loads[j].loadsAssoTariff[k]);
					//GlobalVars.listOfCombinations.sel_batt_sizes_kWh.push(Math.round(GlobalVars.listOfCombinations.batt_sizes_kWh[i] * 48 / 1000));
					GlobalVars.listOfCombinations.sel_batt_sizes_kWh.push(GlobalVars.listOfCombinations.batt_sizes_kWh[i]);
					GlobalVars.listOfCombinations.sel_batt_sizes_kW.push(GlobalVars.listOfCombinations.batt_sizes_kW[i]);

					if (type == "MustRunPerfect") { // has_perfect_case should be false since Perfect must be run
						GlobalVars.listOfCombinations.has_perfect_case.push(false);
					} else {
						var dailyResultsFullPath = (GlobalVars.currentSavedResultPath + '\\daily\\CS_' +
								   loadConfig[j].value + '_' +
								   GlobalVars.loads[j].loadsAssoTariff[k] + '_' +
								   GlobalVars.listOfCombinations.batt_sizes_kWh[i] + 'kWh_' +
								   GlobalVars.listOfCombinations.batt_sizes_kW[i] + 'kW_' +
								   Number(document.getElementById("battMinSOC").value) + "_" +
								   Number(document.getElementById("battMaxSOC").value) + "_" +
								   Number(document.getElementById("roundTripEff").value) + "_" +
								   Number(document.getElementById("battDeg").value) + "_" +
								   Number(document.getElementById("battInitSOC").value) + "_" +
								   Number(document.getElementById("battResCap").value) + "_" +
							       Number(document.getElementById("DCTAdjusRatio").value) + "_" +
								   Number(document.getElementById("DCTHorizon").value) + ".csv");

						dailyResultsFullPath = dailyResultsFullPath.replace(/\\/g,"/");
						// check if file exists
						try {

							var fhN2 = fsoN2.OpenTextFile(dailyResultsFullPath , 1);

							// read settings from the file
							SimSettingsT = fhN2.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );
							fhN2.Close();

							// to check if the two simulation settings are the same
							if ((Number(document.getElementById("battMinSOC").value) == Number(SimSettingsT[9])) &&
								(Number(document.getElementById("battMaxSOC").value) == Number(SimSettingsT[11])) &&
								(Number(document.getElementById("roundTripEff").value) == Number(SimSettingsT[13])) &&
								(Number(document.getElementById("battDeg").value) == Number(SimSettingsT[15]))) {

								GlobalVars.commonSimuConfig.push(true);
							} else {
								GlobalVars.commonSimuConfig.push(false);
							}

							if (type == 'Delete' && GlobalVars.commonSimuConfig[counter]) {
								// if file exists, we should truncate the rows belong to "Prediction" case
								var fhN2 = fsoN2.OpenTextFile(dailyResultsFullPath , 1);
								var line = fhN2.ReadAll();
								fhN2.Close();

								// delete existing file
								fsoN2.DeleteFile(dailyResultsFullPath);

								// truncate lines related to prediction case
								line = line.substring(0, line.indexOf('prediction') - 2);

								// re-write the old results for perfect case
								var fhNN = fsoN2.OpenTextFile(dailyResultsFullPath, 2 , true);
					    		fhNN.WriteLine(line);
					    		fhNN.Close();
							}

							// Perfect case exists
							GlobalVars.listOfCombinations.has_perfect_case.push(true && GlobalVars.commonSimuConfig[counter]);
							//alert(GlobalVars.listOfCombinations.has_perfect_case);
						}
						catch(error) {
							// Perfect case does still might exist when prediction case and consequently the file name are partially different
							var fileSearch = 'CS_' +
									   loadConfig[j].value + '_' +
									   GlobalVars.loads[j].loadsAssoTariff[k] + '_' +
									   GlobalVars.listOfCombinations.batt_sizes_kWh[i] + 'kWh_' +
									   GlobalVars.listOfCombinations.batt_sizes_kW[i] + 'kW_' +
									   Number(document.getElementById("battMinSOC").value) + "_" +
									   Number(document.getElementById("battMaxSOC").value) + "_" +
									   Number(document.getElementById("roundTripEff").value) + "_" +
									   Number(document.getElementById("battDeg").value) + "_";

							// finding all the files in the daily folder
							var fsoNN = new ActiveXObject("Scripting.FileSystemObject");
							var allFiles = fsoNN.GetFolder(GlobalVars.currentSavedResultPath + '\\daily');
							var fc = new Enumerator(allFiles.files); var eachFile, lines, linesN, perfectExist = false;
							for (; !fc.atEnd(); fc.moveNext()){
								eachFile = fc.item().Name;
								if (eachFile.indexOf(fileSearch) != -1) { // they are the same, the perfect case exists, we should make a copy of the file

									// update global vairable
									GlobalVars.createdCSFile.push(dailyResultsFullPath);

									// read content of the existing perfect case which has different prediction case and file name
									fhN2 = fsoNN.OpenTextFile(fc.item(), 1);
									lines = fhN2.ReadAll();
									fhN2.Close();

									// open/create file for the new case (same perfect but different prediction case and file name)
									fhN2 = fsoNN.OpenTextFile(dailyResultsFullPath , 2 , true);
									linesN = 'Load_Name, ' + loadConfig[j].value + '\n' +
											 'Tariff_Name, ' + GlobalVars.loads[j].loadsAssoTariff[k] + '\n' +
											 'kWh, ' + GlobalVars.listOfCombinations.batt_sizes_kWh[i] + '\n' +
											 'kW, ' + GlobalVars.listOfCombinations.batt_sizes_kW[i] + '\n' +
											 'Min_SOC, ' + Number(document.getElementById("battMinSOC").value) + "\n" +
											 'Max_SOC, ' + Number(document.getElementById("battMaxSOC").value) + "\n" +
											 'Batt_Eff, ' +Number( document.getElementById("roundTripEff").value) + "\n" +
											 'Batt_Aging_Cost, ' + Number(document.getElementById("battDeg").value) + "\n" +
											 'Init_SOC, ' + Number(document.getElementById("battInitSOC").value) + "\n" +
											 'Batt_Reserve, ' + Number(document.getElementById("battResCap").value) + "\n" +
											 'DCT_Adj, ' + Number(document.getElementById("DCTAdjusRatio").value) + "\n" +
											 'DCT_Hor, ' + Number(document.getElementById("DCTHorizon").value) + "\n";
									fhN2.WriteLine(linesN + lines.substring(lines.indexOf('Analysis Type'), lines.length));
									fhN2.Close();

									perfectExist = true;
									break;

								} //else { // current file does not have similar perfect case
								//	perfectExist= false;
								//}
							}

							if (perfectExist) {
								GlobalVars.listOfCombinations.has_perfect_case.push(true);
								GlobalVars.commonSimuConfig.push(true);
							} else {
								GlobalVars.listOfCombinations.has_perfect_case.push(false);
								GlobalVars.commonSimuConfig.push(false);
							}
						}
					}
					counter++;
				}
			}
		}
	}
}


// save new tariff settings for available loads
function saveAssoTariffs() {
	if (confirm('Are you sure you want to save new tariff settings? It will permanently change current settings.')) {
		//alert(loadsAssoTariff[0]);
    	for(i = 0 ; i < GlobalVars.listOfLoads.length; i++) {

    		// reading existing settings.csv file for each load
    		var fsoNN = new ActiveXObject("Scripting.FileSystemObject");
    		var loadSettingsFileName = ('load/' + GlobalVars.listOfLoads[i] + "/settings.csv");
    		var fhN = fsoNN.OpenTextFile(loadSettingsFileName, 1);
			var line = fhN.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );
			fhN.close();
			// deleting existing file to write a new one
			fsoNN.DeleteFile(loadSettingsFileName);

    		// creating new content
    		var lineN = line[0] + ',' + line[1] + '\n' + line[2] + ',' + line[3] + '\n';

    		for (j = 0 ; j < GlobalVars.loads[i].loadsAssoTariff.length; j++) {
    			if (j == GlobalVars.loads[i].loadsAssoTariff.length - 1) {
        			lineN += 'Tariff,' + GlobalVars.loads[i].loadsAssoTariff[j];
        		} else {
        			lineN += 'Tariff,' + GlobalVars.loads[i].loadsAssoTariff[j] + '\n';
        		}
    		}
    		//alert(lineN);
    		var fhNN = fsoNN.OpenTextFile(loadSettingsFileName, 2 , true);
    		fhNN.WriteLine(lineN);
    		fhNN.Close();

    	}
	} else {
	    //alert("Nothing has been saved.");
	}
}


// return battery configurations to 17 default configs
function saveNewBattConfig() {
	var lines = 'kWh, kW, price\n';

	//create contents for the Battery_Config.csv file
	for (i = 0; i < GlobalVars.listOfBattConfig.listOfkWh.length; i++) {
		if (i == GlobalVars.listOfBattConfig.listOfkWh.length - 1) {
			lines += GlobalVars.listOfBattConfig.listOfkWh[i] + ',' +
					GlobalVars.listOfBattConfig.listOfkW[i] + ',' +
					GlobalVars.listOfBattConfig.price[i];
		} else {
			lines += GlobalVars.listOfBattConfig.listOfkWh[i] + ',' +
					GlobalVars.listOfBattConfig.listOfkW[i] + ',' +
					GlobalVars.listOfBattConfig.price[i] + '\n';
		}
	}

	var fsoNN = new ActiveXObject("Scripting.FileSystemObject");
	var battConfigFileName = ("settings/Battery_Config.csv");
	try {
		fsoNN.DeleteFile(battConfigFileName);
	}
	catch (error) {

	}

	var fhNN = fsoNN.OpenTextFile(battConfigFileName, 2 , true);
	fhNN.WriteLine(lines);
	fhNN.Close();

	// to create dynamic battery configuration on the UI
	var div_list = $(".left-battConfig-container label").closest('label');

	for (i = 0; i < div_list.length; i += 1) {
	    div_list[i].parentNode.removeChild(div_list[i]);
	}


	// creating UI content from the existing battery configuration
	var dynamicBattConfig = '';
	for (i = 0 ; i < GlobalVars.listOfBattConfig.listOfkWh.length ; i++) {
		dynamicBattConfig += '<label class="config-label"><input type="checkbox" name="batteryConfig" value="' +
				GlobalVars.listOfBattConfig.listOfkWh[i] + ' kWh/' +
				GlobalVars.listOfBattConfig.listOfkW[i] + ' kW' +
				'">&nbsp; ' +
				GlobalVars.listOfBattConfig.listOfkWh[i] + ' kWh/' +
				GlobalVars.listOfBattConfig.listOfkW[i] + ' kW' +
				'<label class="delete-batt-config" onclick="deleteBattConfig(this);">X</label></label>';
	}
	$(dynamicBattConfig).insertBefore(".bottom-battConfig-container");

	alert("New batter yconfiguration(s) is(are) saved successfully.");
}


// add new item to the battery configuration list, "Battery_Config.csv" file
function addNewBattConfig() {
	// checking the inputs not to be empty
	//if (!posvaluecheck(document.getElementById("newkWh"))) {
	//	return false;
	//}
	posvaluecheck(document.getElementById("newkWh"));

	//if (!posvaluecheck(document.getElementById("newkW"))) {
	//	alert("23 here");
	//	return false;
	//}
	posvaluecheck(document.getElementById("newkW"));

	posvaluecheck(document.getElementById("newPrice"));


	var fsoN = new ActiveXObject("Scripting.FileSystemObject");
	var battConfigFileName = ("settings/Battery_Config.csv");

	// check if the new adding request already exists
	var existingConfig = false;
	for (i = 0 ; i < GlobalVars.listOfBattConfig.listOfkWh.length ; i++) {
		if (Number(document.getElementById("newkWh").value) == GlobalVars.listOfBattConfig.listOfkWh[i] &&
			Number(document.getElementById("newkW").value) == GlobalVars.listOfBattConfig.listOfkW[i]) {

			alert('Battery configuration already exists.');
			existingConfig = true;
		}
	}

	if (!existingConfig) {

		// to create dynamic battery configuration on the UI
		GlobalVars.listOfBattConfig.listOfkWh.push(Number(document.getElementById("newkWh").value));
		GlobalVars.listOfBattConfig.listOfkW.push(Number(document.getElementById("newkW").value));
		GlobalVars.listOfBattConfig.price.push(Number(document.getElementById("newPrice").value));
		var dynamicBattConfig = '';

		dynamicBattConfig += '<label class="config-label"><input type="checkbox" name="batteryConfig" value="' + document.getElementById("newkWh").value + "_" +
				document.getElementById("newkW").value + '">&nbsp; ' + document.getElementById("newkWh").value + ' kWh/' +
					document.getElementById("newkW").value +' kW<label class="delete-batt-config" onclick="deleteBattConfig(this);">X</label></label>';

		$(dynamicBattConfig).insertAfter($(".config-label").last());

	}
};


// reading battery configurations from Battery_Config.csv file
function battConfigRead() {

	var fsoN = new ActiveXObject("Scripting.FileSystemObject");
	var battConfigFileName = ("settings/Battery_Config.csv");
	GlobalVars.listOfBattConfig.listOfkWh = [];
	GlobalVars.listOfBattConfig.listOfkW = [];
	GlobalVars.listOfBattConfig.price = [];
	var batt_sizes_kWh = Math.round([1770.83 , 1770.83 , 3541.66 , 3541.66 , 3541.66 , 5312.5 , 5312.5 , 5312.5 , 7083.33 , 7083.33 , 7083.33 , 8854.17 , 8854.17 , 8854.17 , 10625 , 10625 , 10625] * 48 / 1000);
	var batt_sizes_kW = [30, 100 , 30 , 100 , 280 , 30 , 100 , 280 , 100 , 280 , 650 , 100 , 280 , 650 , 100 , 280 , 650];
	var batt_prices = [67500, 84600, 123900 , 135200 , 152900 , 173700 , 186100 , 202700 , 231300 , 249800 , 320106 , 270200 , 289800 , 369031 , 302500 , 327100 , 417956];

	var file_exist = true;

	//check if Battery_Config.csv file exist
	try {
		var fhN = fsoN.OpenTextFile(battConfigFileName, 1);
	}
	catch (error) {
		file_exist = false;
	}

	if (!file_exist) {

		GlobalVars.listOfBattConfig.listOfkWh.push(batt_sizes_kWh);
		GlobalVars.listOfBattConfig.listOfkW.push(batt_sizes_kW);
		GlobalVars.listOfBattConfig.price.push(batt_prices);

	} else {
		var ForReading = 1;
		var fhN = fsoN.OpenTextFile(battConfigFileName, ForReading);
		var line = fhN.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );

		for (i=3; i < line.length; i+=3) {

			GlobalVars.listOfBattConfig.listOfkWh.push(Number(line[i]));
			GlobalVars.listOfBattConfig.listOfkW.push(Number(line[i + 1]));
			GlobalVars.listOfBattConfig.price.push(Number(line[i + 2]));
		}

		fhN.Close();
	}
}



function findAllSubFolder(requestedFolder){

	WshShell = new ActiveXObject("WScript.Shell");
	strPath = WshShell.CurrentDirectory;

	var fsoN = new ActiveXObject("Scripting.FileSystemObject");
	var battConfigFileName = ("settings/Battery_Config.csv");

    var s = "";
    var f = fso.GetFolder(strPath + "\\" + requestedFolder);

    // recurse subfolders
    var subfolders = new Enumerator(f.SubFolders);
    var ind,str,i=0;
    if (requestedFolder == "load") {
    	GlobalVars.loads = [];
    	GlobalVars.listOfLoads = [];
		GlobalVars.loads.loadsAvg = [];
		GlobalVars.loads.loadsMax = [];
		GlobalVars.loads.loadsMin = [];
		GlobalVars.loads.loadsMaxToAvg = [];
    } else if (requestedFolder == "tariff") {
    	GlobalVars.listOfTariffs = [];
    	GlobalVars.tariffsSummerType = [];
    }

    for(; !subfolders.atEnd(); subfolders.moveNext()){
    	//alert(subfolders.item());
    	str = (subfolders.item()).path;
    	ind = str.lastIndexOf('\\');

    	if (requestedFolder == "load") {


    		try {

        		var fhN = fsoN.OpenTextFile(requestedFolder + "/" + str.slice(ind + 1 , str.length) + "/settings.csv" , 1);
        		var line = fhN.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );

        		GlobalVars.loads.push({"loadsAssoTariff":[]});
        		GlobalVars.listOfLoads.push(str.slice(ind + 1 , str.length));
        		GlobalVars.loads.loadsAvg.push(line[5]);
        		GlobalVars.loads.loadsMax.push(line[7]);
        		GlobalVars.loads.loadsMin.push(line[9]);
        		GlobalVars.loads.loadsMaxToAvg.push(line[11]);

        		//find existing tariffs, when = -1, no tariff exists
        		var existTariff = [];
        		for (k=0 ; k < line.length ; k++) {
        			if (line[k] == "Tariff") {
        				existTariff.push(k + 1);
        			}
        		}

        		// push each existing tariff to the array
        		if ( existTariff.length != 0) {
        			for (j = 0; j < existTariff.length; j++) {
        				GlobalVars.loads[i].loadsAssoTariff.push(line[existTariff[j]]);
        			}
        		}

        		fhN.Close();
        		i++;
    		}
    		catch (error) {
    			alert("'settings.csv' file does not exist in load/" + str.slice(ind + 1 , str.length) + " folder. ");
    		}

    	} else {
    		GlobalVars.listOfTariffs.push(str.slice(ind + 1 , str.length));

    		// find summer_type of each existing tariff
    		var tariffF = new ActiveXObject("Scripting.FileSystemObject");

    		try {
    			var tariffN = tariffF.OpenTextFile(requestedFolder + "/" + str.slice(ind + 1 , str.length) + "/settings.csv" , 1);
        		var line = tariffN.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );

        		GlobalVars.tariffsSummerType.push(line[1]);
        		//alert(GlobalVars.tariffsSummerType[i]);
        		//i++;
    		}
    		catch (error) {
    			alert("Summer type of " + str.slice(ind + 1 , str.length) + " tariff is unknown because 'settings.csv' file doesn't exist. summer6 will be used.");
    			GlobalVars.tariffsSummerType.push("summer6");
    			//alert(GlobalVars.tariffsSummerType[i]);
    			//i++;
    		}

    	}
    }
};


// This function implements "getElementsByClassName" in IE6 and below as this application is
document.getElementsByClassName = function(cl) {
  var retnode = [];
  var elem = this.getElementsByTagName('*');
  for (var i = 0; i < elem.length; i++) {
    if((' ' + elem[i].className + ' ').indexOf(' ' + cl + ' ') > -1) retnode.push(elem[i]);
  }
  return retnode;
};

// enabling/disabling advanced settings input boxes
//function advancedSettings(elem) {
//	var childrenAllText = document.getElementsByClassName("advSettings");
//	var selectedMode = true;
//	if (elem.checked) {
//		selectedMode = false;
//	}
//
//	for (i=0; i < childrenAllText.length; i++) {
//		childrenAllText[i].disabled = selectedMode;
//	}
//};

function WriteFile() {
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var fh = fso.OpenTextFile("Config.csv", 2, true);
	var lines;
	var val;
	val = document.getElementById("battCap").value;
	lines = "BattratedAh" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("battVol").value;
	lines = "BattVoltage" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("battMinSoC").value;
	lines = "BattMinSoC" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("battMaxSoC").value;
	lines = "BattMaxSoC" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("battInitSoC").value;
	lines = "BattInitSoC" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("battPower").value;
	lines = "BatteryMaxPower" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("battReserve").value;
	lines = "BatteryReserveCapacity" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("DCTAdj").value;
	lines = "DCTAdjustmentRatio" + "," + val;
	fh.WriteLine(lines);

	fh.Close();
	alert("System setttings successfully saved in Config.csv!")
};


function selectBatteryConfigSettings() {
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var lines;
	var batt_sizes_kWh = [];
	var batt_sizes_kW = [];

	// reading battery configuration from Battery_Config.csv file
	for (i = 0 ; i < GlobalVars.listOfBattConfig.listOfkWh.length ; i++) {
		//batt_sizes_kWh.push(allSizes[0][i]);
		batt_sizes_kWh.push(GlobalVars.listOfBattConfig.listOfkWh[i] * 1000 / 48);
		//batt_sizes_kW.push(allSizes[1][i]);
		batt_sizes_kW.push(GlobalVars.listOfBattConfig.listOfkW[i]);
	}

	//var batteryConfig = document.forms[0];
	var batteryConfig = document.getElementsByName("batteryConfig");
	var loadConfig = document.getElementsByName("loadConfig");
	var txt = "";
	var i;
	var count = 0; // to count total number of combinations created for simulation
	var total_runs = 0; // to count total number of executable calls created

	var Month_raw = ["jan" , "feb" , "mar" , "apr" , "may" , "jun" , "jul" , "aug" , "sep" , "oct" , "nov" , "dec"];


	var fh = fso.OpenTextFile("EMSexecute.bat", 2, true);
	var val;

	var lines = "@echo off\n";


	var get_EMSresult_type = 0;
	if (document.getElementById("saveEMSresults").checked) {
		get_EMSresult_type = 1;
	}

	var startMONTHN = -1000;
	var endMONTHN = -1000;
	var fsoNnn = new ActiveXObject("Scripting.FileSystemObject");
	//
	for (i = 0; i < batteryConfig.length; i++) {
		for (j = 0;j < loadConfig.length; j++) {
			for (k = 0;k < GlobalVars.loads[j].loadsAssoTariff.length; k++) {

				if (batteryConfig[i].checked && loadConfig[j].checked) {

					// reading settings.csv file from selected combination
					var resultFileName = "load/" + loadConfig[j].value + "/settings.csv";

					try {
						var ForReading = 1;
						var fhNnn = fsoNnn.OpenTextFile(resultFileName, ForReading);
						var line = fhNnn.ReadAll().replace( /(?:\r\n|\r|\n)/g, "," ).split( /,/ );

						startYEAR = line[1];
						startMONTHN = line[3];

						// check if required load and tariff files exist
						var mess = fileCheck(loadConfig[j].value,GlobalVars.loads[j].loadsAssoTariff[k],Number(startYEAR),Number(startMONTHN));

						if (mess != '') {
							alert(mess);
							continue;
						}

						if (startMONTHN == 1) {
							endMONTHN = 12;
						} else {
							endMONTHN = startMONTHN - 1;
						}

						fhNnn.Close();

						if (count == 0) { // first iteration
							val = batteryConfig[i].value;
							lines += 'cd settings\n' +
									 'title Operation progress: 0%% is completed.\n\n';

							lines +="if exist Config.csv del Config.csv \n" +
							        "@echo BattratedAh,"+ batt_sizes_kWh[i] +" >> Config.csv \n" +
								    "@echo BattratedVolt,48 >> Config.csv\n" +
								    "@echo BattMinSoC," + document.getElementById("battMinSOC").value + " >> Config.csv\n" +
								    "@echo BattMaxSoC," + document.getElementById("battMaxSOC").value + " >> Config.csv\n" +
								    "@echo BattInitSoC," + document.getElementById("battInitSOC").value + " >> Config.csv\n" +
								    "@echo BatteryMaxPower," + batt_sizes_kW[i] + " >> Config.csv\n" +
								    "@echo BatteryReserveCapacity," + document.getElementById("battResCap").value + " >> Config.csv\n" +
								    "@echo DCTAdjustmentRatio," + document.getElementById("DCTAdjusRatio").value + " >> Config.csv\n" +
								    "@echo DCTHorizon," + document.getElementById("DCTHorizon").value + " >> Config.csv\n" +
								    "@echo RoundTripEff," + document.getElementById("roundTripEff").value + " >> Config.csv\n" +
								    "@echo DegradationCost," + document.getElementById("battDeg").value + " >> Config.csv\n" +
								    "if exist Simulation_Config.csv del Simulation_Config.csv \n" +
								    "@echo LoadName," + loadConfig[j].value + " >> Simulation_Config.csv \n" +
								    "@echo TariffName," + GlobalVars.loads[j].loadsAssoTariff[k] + " >> Simulation_Config.csv \n" +
								    "@echo StartYear," + startYEAR + " >> Simulation_Config.csv \n" +
								    "@echo StartMonth," + startMONTHN + " >> Simulation_Config.csv \n" +
								    "@echo noOfMonth," + 12 + " >> Simulation_Config.csv \n" +
								    "@echo startMonthSimulation," + Month_raw[startMONTHN - 1] + " >> Simulation_Config.csv \n" +
								    "@echo endMonthSimulation," + Month_raw[endMONTHN - 1] + " >> Simulation_Config.csv \n" +
								    "@echo SummerType," + GlobalVars.tariffsSummerType[$.inArray(GlobalVars.loads[j].loadsAssoTariff[k],GlobalVars.listOfTariffs)] + " >> Simulation_Config.csv \n" +
								    "@echo EMSresults," + get_EMSresult_type + " >> Simulation_Config.csv \n" +
								    "@echo CurrentResultPath," + GlobalVars.currentSavedResultPath + ">> Simulation_Config.csv \n" +
								    "cd ../bin \n";

							// check if Perfect cases already exists so not to run again;
							if (GlobalVars.listOfCombinations.has_perfect_case[count] && document.getElementById("existingPerfectCase").checked) {
								lines += "MonthlyLayer_Prediction.exe \n" +
									     "title Operation progress: PERCENTAGE00%% is completed. \n" +
									     "DailyLayer_Prediction.exe \n" +
										 "title Operation progress: PERCENTAGE01%% is completed. \n\n";
								total_runs += 2;

							} else {
								lines += "MonthlyLayer_Perfect.exe \n" +
									     "title Operation progress: PERCENTAGE00%% is completed. \n" +
									     "DailyLayer_Perfect.exe \n" +
									     "title Operation progress: PERCENTAGE01%% is completed. \n" +
									     "MonthlyLayer_Prediction.exe \n" +
									     "title Operation progress: PERCENTAGE02%% is completed. \n" +
									     "DailyLayer_Prediction.exe \n" +
										 "title Operation progress: PERCENTAGE03%% is completed. \n\n";
								total_runs += 4;
							}



						} else {
							val = batteryConfig[i].value;
							lines += "cd ../settings\n";

							lines +="if exist Config.csv del Config.csv \n" +
							        "@echo BattratedAh,"+ batt_sizes_kWh[i] +" >> Config.csv \n" +
								    "@echo BattratedVolt,48 >> Config.csv\n" +
								    "@echo BattMinSoC," + document.getElementById("battMinSOC").value + " >> Config.csv\n" +
  								    "@echo BattMaxSoC," + document.getElementById("battMaxSOC").value + " >> Config.csv\n" +
	  							    "@echo BattInitSoC," + document.getElementById("battInitSOC").value + " >> Config.csv\n" +
								    "@echo BatteryMaxPower," + batt_sizes_kW[i] + " >> Config.csv\n" +
								    "@echo BatteryReserveCapacity," + document.getElementById("battResCap").value + " >> Config.csv\n" +
								    "@echo DCTAdjustmentRatio," + document.getElementById("DCTAdjusRatio").value + " >> Config.csv\n" +
								    "@echo DCTHorizon," + document.getElementById("DCTHorizon").value + " >> Config.csv\n" +
								    "@echo RoundTripEff," + document.getElementById("roundTripEff").value + " >> Config.csv\n" +
								    "@echo DegradationCost," + document.getElementById("battDeg").value + " >> Config.csv\n" +
								    "if exist Simulation_Config.csv del Simulation_Config.csv \n" +
								    "@echo LoadName," + loadConfig[j].value + " >> Simulation_Config.csv \n" +
								    "@echo TariffName," + GlobalVars.loads[j].loadsAssoTariff[k] + " >> Simulation_Config.csv \n" +
								    "@echo StartYear," + startYEAR + " >> Simulation_Config.csv \n" +
								    "@echo StartMonth," + startMONTHN + " >> Simulation_Config.csv \n" +
								    "@echo noOfMonth," + 12 + " >> Simulation_Config.csv \n" +
								    "@echo startMonthSimulation," + Month_raw[startMONTHN - 1] + " >> Simulation_Config.csv \n" +
								    "@echo endMonthSimulation," + Month_raw[endMONTHN - 1] + " >> Simulation_Config.csv \n" +
								    "@echo SummerType," + GlobalVars.tariffsSummerType[$.inArray(GlobalVars.loads[j].loadsAssoTariff[k],GlobalVars.listOfTariffs)] + " >> Simulation_Config.csv \n" +
								    "@echo EMSresults," + get_EMSresult_type + " >> Simulation_Config.csv \n" +
								    "@echo CurrentResultPath," + GlobalVars.currentSavedResultPath + ">> Simulation_Config.csv \n" +
								    "cd ../bin \n";

							// check if Perfect cases already exists so not to run again
							if (GlobalVars.listOfCombinations.has_perfect_case[count]  && document.getElementById("existingPerfectCase").checked) {
							    lines += "MonthlyLayer_Prediction.exe \n" +
							    		 "title Operation progress: PERCENTAGE" + count + "0%% is completed. \n" +
							    		 "DailyLayer_Prediction.exe \n" +
							    		 "title Operation progress: PERCENTAGE" + count + "1%% is completed. \n\n";
							    total_runs += 2;

							} else {
								lines += "MonthlyLayer_Perfect.exe \n" +
							    		 "title Operation progress: PERCENTAGE" + count + "0%% is completed. \n" +
							    		 "DailyLayer_Perfect.exe \n" +
							    		 "title Operation progress: PERCENTAGE" + count + "1%% is completed. \n" +
							    		 "MonthlyLayer_Prediction.exe \n" +
							    		 "title Operation progress: PERCENTAGE" + count + "2%% is completed. \n" +
							    		 "DailyLayer_Prediction.exe \n" +
							    		 "title Operation progress: PERCENTAGE" + count + "3%% is completed. \n\n";
							    total_runs += 4;
							}
						}
						count++;
					}
					catch (error) {
						//alert(error.message);
						alert("'settings.csv' file does not exist for " + loadConfig[j].value + " load. Program will continue with other combinations, if selected.");
					}
				}
			}
		}

	}


	// to replace progress variables in the EMSresults.bat file with appropriate percentage numbers
	var each_run_progress = Math.floor(1000.0 / total_runs) / 10;
	var run_progress = each_run_progress;

	for (i = 0; i < count; i++) {
		if (GlobalVars.listOfCombinations.has_perfect_case[i]) {
			lines = lines.replace("PERCENTAGE" + i + "0" , run_progress.toFixed(1));
			run_progress += each_run_progress;
			lines = lines.replace("PERCENTAGE" + i + "1" , run_progress.toFixed(1));
			run_progress += each_run_progress;
		} else {
			lines = lines.replace("PERCENTAGE" + i + "0" , run_progress.toFixed(1));
			run_progress += each_run_progress;
			lines = lines.replace("PERCENTAGE" + i + "1" , run_progress.toFixed(1));
			run_progress += each_run_progress;
			lines = lines.replace("PERCENTAGE" + i + "2" , run_progress.toFixed(1));
			run_progress += each_run_progress;
			lines = lines.replace("PERCENTAGE" + i + "3" , run_progress.toFixed(1));
			run_progress += each_run_progress;
		}

	}
	//lines = lines.replace(/max=0/,'max=' + (count*4));

	fh.WriteLine(lines + "cd .. \nif exist ProgStatus.csv del ProgStatus.csv \n@echo Done >> ProgStatus.csv \n");
	fh.Close();
}


function floatFormat(number, n) {
	var _pow = Math.pow(10, n);
	return Math.round(number * _pow) / _pow;
}


function SaveFileSetting() {

	var lines;
	var DCFile;
	var HistoricalloadFile;
	var OperationloadFile;
	var TOUfile;
	var TimeWindowFile;
	var flg;
	flg = true;

	var nodelist = document.getElementById("inputPlot");
	var len = nodelist.childNodes.length;
	if (len >= 1) {
		for (var ii = 0; ii < len; ii++)
			nodelist.removeChild(nodelist.childNodes[0]);
	}

	DCFile = document.getElementById("myDCFile").value;
	HistoricalloadFile = document.getElementById("HistoricalLoadFile").value;
	OperationloadFile = document.getElementById("OperationLoadFile").value;
	TOUfile = document.getElementById("myTOUFile").value;
	TimeWindowFile = document.getElementById("myTimeWindowFile").value;

	if (DCFile == "") {
		alert("Please select DC rate file");
		return;
	}
	if (HistoricalloadFile == "") {
		alert("Please select historical load profile file");
		return;
	}
	if (OperationloadFile == "") {
		alert("Please select operation load profile file");
		return;
	}
	if (TOUfile == "") {
		alert("Please select Grid Tariff setting file");
		return;
	}
	if (TimeWindowFile == "") {
		alert("Please select Time Window file");
		return;
	}

	var cnt = 0;
	var NegFlg = false;
	var LenFlg = false;
	var forig = new ActiveXObject("Scripting.FileSystemObject");
	var ftarget = new ActiveXObject("Scripting.FileSystemObject");
	var line;
	var arr;
	var len;

	// reading and copying DC file
	var f1 = forig.OpenTextFile(DCFile, 1, true);
	var f2 = ftarget.OpenTextFile("DemandChargeRates.csv", 2, true);
	while (!f1.AtEndOfStream) {
		line = f1.ReadLine();
		f2.WriteLine(line);
		cnt += 1;
		arr = line.split(",");
		len = arr.length;
		if (len > 2) {
			LenFlg = true;
			break;
		}
		if (Number(arr[1]) < 0) {
			NegFlg = true;
			break;
		}
	}
	f1.Close();
	f2.close();

	if (NegFlg) {
		alert("DC Rate Error: Contain negative value!");
		flg = false;
	}
	if (LenFlg) {
		alert("DC Rate Error: Contain more than 2 column data!");
		flg = false;
	}
	if (cnt != 3) {
		alert("DC Rate Error: The number of input data point should be 3!");
		flg = false;

	}
	// reading and copying historical load file
	cnt = 0;
	NegFlg = false;
	LenFlg = false;
	f1 = forig.OpenTextFile(HistoricalloadFile, 1, true);
	f2 = ftarget.OpenTextFile("MonthlyLayerLoad.csv", 2, true);
	while (!f1.AtEndOfStream) {
		line = f1.ReadLine();
		f2.WriteLine(line);
		cnt += 1;
		arr = line.split(",");
		if (Number(arr[1]) < 0)
			NegFlg = true;
	}
	f1.Close();
	f2.close();

	/* if (cnt != 1440) {
	    alert("Load profile Format Error: The number of input data point should be 1440 and 1 min interval!");
	    flg = false;
	} */

	if (NegFlg) {
		alert("Load profile Format Error: Contain negative value!");
		flg = false;
	}

	// reading and copying operation load file
	cnt = 0;
	NegFlg = false;
	LenFlg = false;
	f1 = forig.OpenTextFile(OperationloadFile, 1, true);
	f2 = ftarget.OpenTextFile("DailyLayerLoad.csv", 2, true);
	while (!f1.AtEndOfStream) {
		line = f1.ReadLine();
		f2.WriteLine(line);
		cnt += 1;
		arr = line.split(",");
		if (Number(arr[1]) < 0)
			NegFlg = true;
	}
	f1.Close();
	f2.close();

	/* if (cnt != 1440) {
	    alert("Load profile Format Error: The number of input data point should be 1440 and 1 min interval!");
	    flg = false;
	} */

	if (NegFlg) {
		alert("Load profile Format Error: Contain negative value!");
		flg = false;
	}

	// reading and copying TOU file

	cnt = 0;
	NegFlg = false;
	LenFlg = false;
	f1 = forig.OpenTextFile(TOUfile, 1, true);
	f2 = ftarget.OpenTextFile("TOU.csv", 2, true);
	while (!f1.AtEndOfStream) {
		line = f1.ReadLine();
		f2.WriteLine(line);
		cnt += 1;
		arr = line.split(",");
		if (Number(arr[1]) < 0)
			NegFlg = true;
	}
	f1.Close();
	f2.close();

	if (cnt != 48) {
		alert("Grid Tariff profile Format Error: The number of input data point should be 48 and 30 min interval!");
		flg = false;
	}
	if (NegFlg) {
		alert("Load profile Format Error: Contain negative value!");
		flg = false;
	}

	// reading and copying Time Window file

	cnt = 0;
	NegFlg = false;
	LenFlg = false;
	f1 = forig.OpenTextFile(TimeWindowFile, 1, true);
	f2 = ftarget.OpenTextFile("TimeWindow.csv", 2, true);
	while (!f1.AtEndOfStream) {
		line = f1.ReadLine();
		f2.WriteLine(line);
		cnt += 1;
		arr = line.split(",");
		if (Number(arr[1]) < 0)
			NegFlg = true;
	}
	f1.Close();
	f2.close();

	if (cnt != 48) {
		alert("Time Window profile Format Error: The number of input data point should be 48 and 30 min interval!");
		flg = false;
	}
	if (NegFlg) {
		alert("Time Window Format Error: Contain negative value!");
		flg = false;
	}

	// reading and creating historical date file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var fh = fso.OpenTextFile("HistoricalDate.csv", 2, true);
	var lines;
	var val;
	val = document.getElementById("historicalyear").value;
	lines = "year" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("historicalmonth").value;
	lines = "month" + "," + val;
	fh.WriteLine(lines);
	fh.Close();

	// reading and creating operation date file
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var fh = fso.OpenTextFile("OperationDate.csv", 2, true);
	var lines;
	var val;
	val = document.getElementById("operationyear").value;
	lines = "year" + "," + val;
	fh.WriteLine(lines);

	val = document.getElementById("operationmonth").value;
	lines = "month" + "," + val;
	fh.WriteLine(lines);
	fh.Close();

	////////////////////////////////////////////
	if (flg)
		alert("Files successfully copied!");
	else
		alert("Files upload failed! Please try again!");

}

function DCextCheck(fileinput) {

	var ext = fileinput.value.match(/\.(.+)$/)[1];
	switch (ext) {
	case 'csv':
		//document.getElementById("DCfilename").innerHTML = fileinput.value;
		break;
	default:
		alert('Only CSV file is supported! Please reselect!');
		document.getElementById("DCfilename").innerHTML = "not CSV file!";
		this.value = "";
	}

}

function TimeWindowextCheck(fileinput) {

	var ext = fileinput.value.match(/\.(.+)$/)[1];
	switch (ext) {
	case 'csv':
		//document.getElementById("DCfilename").innerHTML = fileinput.value;
		break;
	default:
		alert('Only CSV file is supported! Please reselect!');
		document.getElementById("TimeWindowfilename").innerHTML = "not CSV file!";
		this.value = "";
	}

}

function loadextCheck(fileinput) {

	var ext = fileinput.value.match(/\.(.+)$/)[1];
	switch (ext) {
	case 'csv':
		//document.getElementById("operationloadfilename").innerHTML = fileinput.value;
		break;
	default:
		alert('Only CSV file is supported! Please reselect!');
		document.getElementById("operationloadfilename").innerHTML = "not CSV file!";
		this.value = "";
	}
	switch (ext) {
	case 'csv':
		//document.getElementById("historicalloadfilename").innerHTML = fileinput.value;
		break;
	default:
		alert('Only CSV file is supported! Please reselect!');
		document.getElementById("historicalloadfilename").innerHTML = "not CSV file!";
		this.value = "";
	}

}
function TOUextCheck(fileinput) {

	var ext = fileinput.value.match(/\.(.+)$/)[1];
	switch (ext) {
	case 'csv':
		//document.getElementById("TOUfilename").innerHTML = fileinput.value;
		break;
	default:
		alert('Only CSV file is supported! Please reselect!');
		document.getElementById("TOUfilename").innerHTML = "not CSV file!";
		this.value = "";
	}

}
//function posvaluecheck(valueinput) {
//	var val = valueinput.value;
//	var patt2 = /^[0-9.]+$/;
//	var patt1 = /[.]/g;
//
//	if (!val.match(patt2)) {
//		alert("Input must be a valid positive number.");
//		formreset(valueinput);
//		return false;
//	}
//
//	var res = val.match(patt1);
//	if (res) {
//		if (res.length > 1) {
//			alert("Input must be a valid positive number.");
//			formreset(valueinput);
//			return false;
//		}
//	}
//
//	return true;
//}

function formreset(valueinput) {
	/*if (valueinput.id == "battCap")
		valueinput.value = 5312.5;
	else if (valueinput.id == "battVol")
		vallueinput.value = 48;
	else if (valueinput.id == "battMinSoC")
		valueinput.value = 5;
	else if (valueinput.id == "battMaxSoC")
		valueinput.value = 100;
	else if (valueinput.id == "battPower")
		valueinput.value = 125;
	else if (valueinput.id == "battInitSoC")
		valueinput.value = 50;
	else if (valueinput.id == "battReserve")
		valueinput.value = 35;
	else if (valueinput.id == "DCTAdj")
		valueinput.value = 10;
	//else if (valueinput.id == "peakShavLimit")
	//valueinput.value = 2500;
	//else if (valueinput.id == "PVCap")
	//valueinput.value = 6;
	//else if (valueinput.id == "loadCap")
	//valueinput.value = 5;
	else
		valueinput.value = null;
	return;*/
	//valueinput.value = '';
	valueinput.select();

}


function SoCCheck(valueinput) {
	if (!posvaluecheck(valueinput))
		return false;

	if (valueinput.value > 100) {
		alert("The input SoC limit should be between 0 and 100!")
		formreset(valueinput);
		return false;

	}
	var minSoC = document.getElementById("battMinSoC").value;
	var MaxSoC = document.getElementById("battMaxSoC").value;
	var InitSoC = document.getElementById("battInitSoC").value;
	if (Number(minSoC) >= Number(MaxSoC)) {
		alert("Minimum SoC setting should be smaller than Maximum SoC setting!");
		formreset(valueinput);
		return false;
	}
	if (Number(InitSoC) > Number(MaxSoC) || Number(InitSoC) < Number(minSoC)) {
		alert("Initial SoC is not within the acceptable range!");
		formreset(valueinput);
		return false;
	}

	return true;

}

function DCTHorizonCheck(valueinput) {
	if (!posvaluecheck(valueinput))
		return false;

	if (valueinput.value > 31) {
		alert("The DCT horizon should be between 15 and 31 days!")
		formreset(valueinput);
		return;

	}
}

function roundTripEffCheck(valueinput) {
	//posvaluecheck(valueinput);
	if (!posvaluecheck(valueinput))
		return false;

	if (valueinput.value > 100) {
		alert("Battery round-trip efficiency should be smaller than 100!")
		formreset(valueinput);
		return false;
	}

	return true;
}

function CapMultiCheck(valueinput) {
	//posvaluecheck(valueinput);
	if (!posvaluecheck(valueinput))
		return false;

	if (valueinput.value > 1000) {
		alert("The input norminal capacity should be between 0 and 1000!")
		formreset(valueinput);
		return;

	}
}

function fileCheck(load_name,tariff_name,start_year,start_month) {

	var orig_month = [ "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" ];
	var year = [];
	var month = [];
	var message = '';

	// checking load profile existence
	var load_file, no_month = 12;
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	for (i = 0; i < no_month; i++) {
		if (i + 1 <= (no_month - start_month + 1)) {
			year.push(start_year);
		} else {
			year.push(start_year + 1);
		}

		if ((start_month + i) <= no_month) {
			month.push(orig_month[start_month - 1 + i]);
		} else {
			month.push(orig_month[i - no_month + start_month - 1]);
		}

		load_file = "load/" + load_name + "/" + load_name + "_" + month[i]
				+ "_" + year[i] + ".csv";

		try {
			var newsome = fso.OpenTextFile(load_file , 1);
			newsome.Close();
		}
		catch (error) {
			//alert("System Configuration File (" + load_file + ") doesn't exist");
			message += "Required load file (" + load_file + ") doesn't exist. It is not possible to run current case.\n";
		}

	}


	//checking tariff .csv files existence
	var tariff_file = [];
	tariff_file[0] = "tariff/" + tariff_name + "/" + tariff_name
			+ "_DemandChargeRates_Summer_Spring.csv";
	tariff_file[1] = "tariff/" + tariff_name + "/" + tariff_name
			+ "_DemandChargeRates_Winter_Fall.csv";
	//tariff_file[2] = "tariff/" + tariff_name + "/" + tariff_name
	//		+ "_TimeWindows_Summer_Spring.csv";
	//tariff_file[3] = "tariff/" + tariff_name + "/" + tariff_name
	//		+ "_TimeWindows_Winter_Fall.csv";
	tariff_file[2] = "tariff/" + tariff_name + "/" + tariff_name
			+ "_TOU_Summer_Spring.csv";
	tariff_file[3] = "tariff/" + tariff_name + "/" + tariff_name
			+ "_TOU_Winter_Fall.csv";
	for (i = 0; i < 4; i++) {
		try {
			var newsome = fso.OpenTextFile(tariff_file[i] , 1);
			newsome.Close();
		}
		catch (error) {
			//alert("System Configuration File (" + tariff_file[i] + ") doesn't exist");
			message += "Required tariff file (" + tariff_file[i] + ") doesn't exist. It is not possible to run current case.\n";
		}
	}

	return message;
}

var statusFlg;

function RunFile() {

	// check to have at least one size selected
	if (checkSelectedItems("batteryConfig")) {
		alert("Simulation is terminated because no battery configuration is selected in Step 1");
		return false;
	}

	// check to have at least one load selected
	if (checkSelectedItems("loadConfig")) {
		alert("Simulation is terminated because no load profile is selected in Step 1.");
		return false;
	}

	// checking given SOC values
	if (!SoCCheck(document.getElementById("battMinSOC")))
		return false;

	if (!SoCCheck(document.getElementById("battMaxSOC")))
		return false;

	// checking round-trip efficiency
	if (!roundTripEffCheck(document.getElementById("roundTripEff")))
		return false;

	// checking battery aging cost value
	if (!posvaluecheck(document.getElementById("battDeg")))
		return false;

	// checking battery initial SOC value
	if (!SoCCheck(document.getElementById("battInitSOC")))
		return false;

	// check battery reserve capacity value
	if (!checkSensitiveParameters(document.getElementById("battResCap") , 1 , 90 , 0))
		return false;

	// check battery reserve capacity value
	if (!checkSensitiveParameters(document.getElementById("DCTAdjusRatio") , 1 , 100 , -100))
		return false;

	// check battery reserve capacity value
	if (!checkSensitiveParameters(document.getElementById("DCTHorizon") , 1 , 31 , 1))
		return false;

	// check to have at least one tariff selected
	//if (checkSelectedItems("tariffConfig")) {
	//	alert("Simulation is terminated because no tariff profile is selected in Step 1.");
	//	return false;
	//}

	alert("hello world");

	//var WshShell = new XMLHttpRequest();
	WshShell = new ActiveXObject("WScript.Shell");
	strPath = WshShell.CurrentDirectory;
	SA = new ActiveXObject("Shell.Application");
	F = SA.BrowseForFolder(0, "Choose a folder to save results:", 0, "Desktop");

//	var F = "TestCase";
	if (F != null) {
		
		// show the selected path in the <p> tag
		document.getElementById("chosenPathSaveResults").innerHTML = F.Self.Path;

		// create folders (daily)
		var myObject = new ActiveXObject("Scripting.FileSystemObject");
		var newFolder= '';
		try {
			newFolder = myObject.CreateFolder(F.Self.Path + "\\daily");

		} catch(error) {

			// Folder already exists. So do nothing
			//if (confirm("'daily' folder already exists. Do you want to overwrite?")) {
			//	var existingFolder = myObject.GetFolder(F.Self.Path + "/daily");
			//	existingFolder.Delete();

			//	newFolder = myObject.CreateFolder(F.Self.Path + "/daily");
			//} else {
			//	alert("Simulation has been stopped. Push 'RUN NEC EMS' button and select another folder to save results.");
			//	return false;
			//}
		}

		// create folders (monthly)
		newFolder= '';
		try {
			newFolder = myObject.CreateFolder(F.Self.Path + "/monthly");

		} catch(error) {

			// Folder already exists. So do nothing
			//if (confirm("'monthly' folder already exists. Do you want to overwrite?")) {
			//	var existingFolder = myObject.GetFolder(F.Self.Path + "/monthly");
			//	existingFolder.Delete();

			//	newFolder = myObject.CreateFolder(F.Self.Path + "/monthly");
			//} else {
			//	alert("Simulation has been stopped. Push 'RUN NEC EMS' button and select another folder to save results.");
			//	return false;
			//}
		}

		// setting current path for results in the GlobalVars
		GlobalVars.currentSavedResultPath = F.Self.Path;


	} else {  // no path is selected by the user
		alert("It is required to specify a path where you want to save the simulation results. Please try again.");
		//document.getElementById("chosenPathSaveResults").innerHTML = "";
		return false;
	}




	// check if Perfect cases exists (only when "Use existing Perfect cases" is checked)
	var message = '';
	if (document.getElementById("existingPerfectCase").checked) {
		existingPerfectCases('NoDelete');

		//var message_has = 'Perfect scenario will not be ran for the following cases since they are already exist: \n';
		var message_header = 'Perfect scenario will be run for the following case(s): \n';
		var message_hasnot = '';

		for (i = 0 ; i < GlobalVars.listOfCombinations.has_perfect_case.length ; i++) {
			//alert(GlobalVars.listOfCombinations.has_perfect_case[i]);
			if (!GlobalVars.listOfCombinations.has_perfect_case[i]) {
				//alert(GlobalVars.listOfCombinations.sel_batt_sizes_kWh[i]);
				//alert(GlobalVars.listOfCombinations.sel_batt_sizes_kW[i]);
				message_hasnot += '    Battery size: ' + GlobalVars.listOfCombinations.sel_batt_sizes_kWh[i] + 'kWh/' +
                    	  								 GlobalVars.listOfCombinations.sel_batt_sizes_kW[i] + 'kW, Load name: ' +
					  	  								 GlobalVars.listOfCombinations.load_name[i] + ', Tariff name: ' +
					  	  								 GlobalVars.listOfCombinations.tariff_name[i] + '\n';
			}
		}

		if (message_hasnot == '') {
			message = 'Perfect scenarios exist for all selected case(s). \n';
		} else {
			message = message_header + message_hasnot;
		}

		if (!confirm(message)) {
			// delete if any CS file created as a result of Perfect case exisiting
			if (GlobalVars.createdCSFile.length != 0){
				for (i = 0; i < GlobalVars.createdCSFile.length; i++) {
					var myObject = new ActiveXObject("Scripting.FileSystemObject");
					myObject.DeleteFile(GlobalVars.createdCSFile[i]);
				}
			}
			return false;
		} else {
			// delete "prediction" from Cost_Summary files
			existingPerfectCases('Delete');
		}
	}
	else { // user did not ask for stop running Perfect cases if exist
		existingPerfectCases('MustRunPerfect');
	}

	selectBatteryConfigSettings();


	statusFlg = 0;
	//var flg = fileCheck();
	//alert(flg);
	//if (!flg)
	//	return;


	var fso = new ActiveXObject("Scripting.FileSystemObject");
	fso.DeleteFile("ProgStatus.csv");

	var f = fso.OpenTextFile("ProgStatus.csv", 2, true);
	f.WriteLine("Running");
	f.Close();

	WshShell = new ActiveXObject("WScript.Shell");
	WshShell.Run("EMSexecute.bat", 1, false);

	document.getElementById("runSimulation").disabled = true;
	document.getElementById("analyseResults").disabled = true;
	document.getElementById("runSensitivity").disabled = true;
	document.getElementById("EMSRunSpin").style.display = "inline";

	checkEndofSimulation(1);

	/** If C++ app uses ProgStatus.csv to indicate the completion of EMS **/
	// document.getElementById("resDisplay").disabled = true;
	// ProgCheck();
	PlotReset();
}


// function for disabling "RUN NEC EMS" and "ANALYZE RESULTS" while simulation is running
var updateRes;
function checkEndofSimulation(type) {
	// resetting the previous timer
	window.clearTimeout(updateRes);

	// reading the ProgStatus.csv file
	var fsoCheck = new ActiveXObject("Scripting.FileSystemObject");
	var fCheck = [];
	var linesCheck = '';

	if (type == 1) {  // major simulation is called

		fCheck = fsoCheck.OpenTextFile("ProgStatus.csv", 1, true);
		linesCheck = fCheck.ReadAll();

	} else { // this is for Sensitivity Analysis when abosulte and partial Perfect case doesn't exist

		fCheck = fsoCheck.OpenTextFile("ProgStatusPerfect.csv", 1, true);
		linesCheck = fCheck.ReadAll();

	}
	fCheck.Close();

	//alert(lines);
	if (linesCheck.replace( /(?:\r\n|\r|\n)/g, "" ).replace(/ /g,"") == 'Running') {
		updateRes = window.setTimeout(function() {
			checkEndofSimulation(type);
		}, 100);

	} else {

		if (type == 2) {

			// create required CS files for all combinations
			existingPerfectCasesSensAnalysis();

			if (GlobalVars.listOfCombinationsSensAna.perfectCaseRunning) { // it means that absolute or partial Perfect case did not exists and it is called to run

				// create a pause to check on
				updateRes = window.setTimeout(function() {
					checkEndofSimulation(2);
				}, 100);


			} else {

				// create new batch file for all possible combination
				createBatchFileSensAnalysis([GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kWh] ,
											[GlobalVars.listOfCombinationsSensAna.sel_batt_sizes_kW] ,
											[GlobalVars.listOfCombinationsSensAna.load_name] ,
											GlobalVars.listOfCombinationsSensAna.tariff ,
											GlobalVars.listOfCombinationsSensAna.BattReserveSensRange ,
											GlobalVars.listOfCombinationsSensAna.DCTRatioSensRange ,
											GlobalVars.listOfCombinationsSensAna.DCTDaysSensRange ,
											GlobalVars.currentSavedSensPath ,
											GlobalVars.listOfCombinationsSensAna.has_perfect_case);

				// changing "ProgStatusPerfect.csv" status to "Running"
				var fsoProg = new ActiveXObject("Scripting.FileSystemObject");
				var fhProg = fsoProg.OpenTextFile("ProgStatus.csv", 2 , true);
				fhProg.WriteLine("Running");
				fhProg.Close();

				//alert("no Perfect case runnng !!!");
				WshShell = new ActiveXObject("WScript.Shell");
				WshShell.Run("EMSexecute.bat", 1, false);
				checkEndofSimulation(1);
			}

		} else {
			document.getElementById("runSimulation").disabled = false;
			document.getElementById("analyseResults").disabled = false;
			document.getElementById("runSensitivity").disabled = false;

			document.getElementById("EMSRunSpin").style.display = "none";
			document.getElementById("TuneRunSpin").style.display = "none";
		}

	}
}



//check to have at least one size, one load, and one tariff is selected
function checkSelectedItems(selectedType) {
	var allInputs = document.getElementsByName(selectedType);
	var counter=0;
	for (i = 0; i < allInputs.length; i++) {
		if (allInputs[i].checked) {
			counter++;
		}
	}

	if (counter == 0)
		return true;
	else
		return false;
}



function ProgCheck() {
	// alert("Progress check" + statusFlg);
	if (statusFlg == 0) {
		setTimeout(ProgCheck, 2000);
	} else {
		document.getElementById("resDisplay").disabled = false;

		//var flg = readResfile();
		alert("The EMS results are ready. Please click ANALYZE RESULTS button and switch to the OUTPUT tab for viewing!");

	}

	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if (!fso.FileExists("ProgStatus.csv")) {
		return;
	}

	var f = fso.OpenTextFile("ProgStatus.csv", 1, true);
	var cnt = 0;
	var len;
	while (!f.AtEndOfStream) {

		var line = f.ReadLine();
		var arr = line.split(",");
		len = arr.length;
		if (len < 1)
			continue;
		statusFlg = Number(arr[1]);
		//alert(arr[1]);
		cnt += 1;

	}

	f.Close();
}

//// selecting all battery configurations
//function selectAll(typeSelected) {
//	var allInputs = document.getElementsByTagName("input");
//	for (i = 0; i < allInputs.length; i++) {
//		if (allInputs[i].name == "batteryConfig" && typeSelected == "battery") {
//			allInputs[i].checked = true;
//		} else if (allInputs[i].name == "loadConfig" && typeSelected == "load") {
//			allInputs[i].checked = true;
//		} else if (allInputs[i].name == "tariffConfig" && typeSelected == "tariff") {
//			allInputs[i].checked = true;
//		} else if (allInputs[i].name == "pvConfig" && typeSelected == "pv") {
//			allInputs[i].checked = true;
//		}
//	}
//}
//
//// deselecting all battery configurations
//function deselectAll(typeSelected) {
//	var allInputs = document.getElementsByTagName("input");
//	for (i = 0; i < allInputs.length; i++) {
//		if (allInputs[i].name == "batteryConfig" && typeSelected == "battery") {
//			allInputs[i].checked = false;
//		} else if (allInputs[i].name == "loadConfig" && typeSelected == "load") {
//			allInputs[i].checked = false;
//		} else if (allInputs[i].name == "tariffConfig" && typeSelected == "tariff") {
//			allInputs[i].checked = false;
//		} else if (allInputs[i].name == "pvConfig" && typeSelected == "pv") {
//			allInputs[i].checked = false;
//		}
//	}
//}

function checkSel1(valueinput) {

	if (valueinput.checked)
		document.getElementById("sel2").checked = false;
	else
		document.getElementById("sel2").checked = true;

	var flg = valueinput.checked;

	document.getElementById("pvselect").disabled = !flg;
	document.getElementById("TOUselect").disabled = !flg;
	document.getElementById("loadselect").disabled = !flg;
	document.getElementById("PVCap").disabled = !flg;
	document.getElementById("loadCap").disabled = !flg;
	document.getElementById("defaultSubmit").disabled = !flg;

	document.getElementById("myPVFile").disabled = flg;
	document.getElementById("HistoricalLoadFile").disabled = flg;
	document.getElementById("myTOUFile").disabled = flg;
	document.getElementById("fileSubmit").disabled = flg;

}

function checkSel2(valueinput) {
	if (valueinput.checked)
		document.getElementById("sel1").checked = false;
	else
		document.getElementById("sel1").checked = true;

	var flg = valueinput.checked;
	{
		document.getElementById("pvselect").disabled = flg;
		document.getElementById("TOUselect").disabled = flg;
		document.getElementById("loadselect").disabled = flg;
		document.getElementById("PVCap").disabled = flg;
		document.getElementById("loadCap").disabled = flg;
		document.getElementById("defaultSubmit").disabled = flg;

		document.getElementById("myPVFile").disabled = !flg;
		document.getElementById("HistoricalLoadFile").disabled = !flg;
		document.getElementById("myTOUFile").disabled = !flg;
		document.getElementById("fileSubmit").disabled = !flg;
	}
};