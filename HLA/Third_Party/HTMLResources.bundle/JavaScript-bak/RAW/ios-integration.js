__functionIndexMap = {};

function calliOSFunction(functionName, successCallback, errorCallback, callInfo)
{
    var url = 'js-frame:';	
	
    callInfo.functionname = functionName;

	if (successCallback)
	{
		if (typeof successCallback == 'function')
		{
			var callbackFuncName = createCallbackFunction(functionName + '_' + 'successCallback', successCallback);
			callInfo.success = callbackFuncName;
		}
		else
		{
			callInfo.success = successCallback;
		}
    }

    if (errorCallback)
    {
        if (typeof errorCallback == 'function')
        {
            var callbackFuncName = createCallbackFunction(functionName + '_' + 'errorCallback', errorCallback);
            callInfo.error = callbackFuncName;
        }
        else
        {
            callInfo.error = errorCallback;
        }
    }

	url += JSON.stringify(callInfo);
	var iFrame = createIFrame(url);
	
	iFrame.parentNode.removeChild(iFrame);
}

function createCallbackFunction (funcName, callbackFunc)
{
    if (callbackFunc && callbackFunc.name != null && callbackFunc.name.length > 0)
    {
        return callbackFunc.name;
    }

    if (typeof window[funcName+0] != 'function')
    {
        window[funcName+0] = callbackFunc;
        __functionIndexMap[funcName] = 0;

        return funcName+0
    } 
    else
    {
        var maxIndex = __functionIndexMap[funcName];
        var callbackFuncStr = callbackFunc.toString();

        for (var i = 0; i <= maxIndex; i++)
        {
            var tmpName = funcName + i;
            if (window[tmpName].toString() == callbackFuncStr)
                return tmpName;
        }
        var newIndex = ++__functionIndexMap[funcName];
        window[funcName+newIndex] = callbackFunc;

        return funcName+newIndex;
    }
}

function createIFrame(src)
{
	var rootElm = document.documentElement;
	var newFrameElm = document.createElement('IFRAME');
	newFrameElm.setAttribute('src',src);
	rootElm.appendChild(newFrameElm);
	return newFrameElm;
}

function onSuccess (ret)
{
    if (ret)
    {
        var objectContent = JSON.parse(ret);
        var stringType = Object.keys(objectContent.result)[0];

        if (stringType == "readFromDB")
        {
            getFromDatabase(objectContent.result.readFromDB, stringPageTypeCurrent);
        }
        else
        {
            //alert("Not read from database method !.");
        }
    }
}

function onError (ret)
{
	if (ret)
	{
		var returnRet = JSON.parse(ret);
		// alert(returnRet.error);
    }
}

function readfromDB()
{    
    var callInfo = {};
    callInfo.data = {};
    callInfo.data.SPAJAnswers = {};
    callInfo.data.SPAJAnswers.columns = 'elementID,Value,SPAJID,CustomerID';
    callInfo.data.SPAJAnswers.where = '';
    calliOSFunction('readfromDB:',onSuccess,onError, callInfo);
}

function savetoDB() 
{
	var stringValue;
	var stringRadioButtonFlag = 0;
	var booleanValidateState = true;

	
	// QUICK FIX VALIDATION FOR FORM
	
	if (booleanValidateState == false)
	{
		
	}
	else
	{
		if (stringPageSectionCurrent != stringPageSectionBeneficiariesList)
		{
			$("input:text[required]").each(function()
			{
				stringValue = $(this).val();
				var $label = $("label[for='"+this.id+"']")

				if (stringValue == undefined || stringValue == null || stringValue == "")
				{	
					ReplaceHTMLNameOnValidate("", $label.text() + " " + "harap diisi.");
					// alert($label.text() + " " + "harap diisi.");
					booleanValidateState = false;
					return false;
				}
				else
				{

				}
			});
		}
		else
		{
			
		}
	}
	
	if (booleanValidateState == false)
	{
		
	}
	else
	{
		var booleanIncomeState = false;

		if (stringPageValidationCurrent == stringPageValidationIncome)
		{
			$("input:text[data-customvalidation='" + stringPageValidationIncome + "']").each(function()
			{
				if ($(this).val() > 0)
				{
					booleanIncomeState = true;
					return false;
				}
				else
				{

				}
			});

			if (booleanIncomeState == false)
			{
				booleanValidateState = false;
				ReplaceHTMLNameOnValidate("","Harap mengisi penghasilan kotor minimum satu jenis");
				// alert("Harap mengisi penghasilan kotor minimum satu jenis !.");
			}
			else
			{

			}
		}
		else
		{

		}
	}
	
	if (booleanValidateState == false)
	{
		
	}
	else
	{
		if (stringPageSectionCurrent != stringPageSectionBeneficiariesList)
		{
			$("input:radio[required]").each(function()
			{												
				stringValue = getRadioButtonGeneral($(this).attr("name"));						
				var $label = $("label[for='"+this.name+"']")				
				if (stringRadioButtonFlag != $(this).attr("name"))
				{
					if (stringValue == undefined)
					{
						// alert("invalid : " + $(this).attr("name") + " " + stringValue);
						ReplaceHTMLNameOnValidate("", $label.text() + " " + "harap dipilih.");

						booleanValidateState = false;
						return false;
					}				
					else
					{
						// alert("valid : " + $(this).attr("name") + " " + stringValue);
					}

					stringRadioButtonFlag = $(this).attr("name");
				}
				else
				{

				}
			});
		}
		else
		{
			
		}
	}

	
	// VALIDATION FOR BENEFICIARIES LIST
	
	if (stringPageSectionCurrent == stringPageSectionBeneficiariesList)
	{
		if (booleanValidateState == false)
		{
			
		}
		else
		{
			if (intSharePercentage != 100)
			{
				ReplaceHTMLNameOnValidate("","Jumlah share percentage harus 100 !.");
				//alert("Jumlah share percentage harus 100 !.");
				booleanValidateState = false;
				return false;
			}				
			else
			{
				
			}
		}
		
		if (booleanValidateState == false)
		{
			
		}
		else
		{
			var stringBeneficiariesListPrefix = stringPrefixText + stringBeneficiariesListInfix + "FullName";
			var stringBeneficiariesListFilter;
			var arrayBeneficiariesListTemporary = [];
			var booleanBeneficiariesList = false;
			
			for (var k = 0; k < arrayBeneficiariesList.length; k++)
			{
				stringBeneficiariesListFilter = arrayBeneficiariesList[k].elementID.substring(0, stringBeneficiariesListPrefix.length)
				
				if (stringBeneficiariesListFilter == stringBeneficiariesListPrefix)
				{
					booleanBeneficiariesList = true;
				}
				else
				{
					
				}
			}
			
			if (booleanBeneficiariesList == false)
			{
				ReplaceHTMLNameOnValidate("","Masukkan daftar penerima manfaat paling tidak satu !.");
				//alert("Jumlah share percentage harus 100 !.");
				booleanValidateState = false;
				return false;
			}				
			else
			{
				
			}
		}
	}
	else
	{
		
	}
	
	if (booleanValidateState == false)
	{
		
	}
	else
	{			
		var objectContent;    			
		
		if (stringPageSectionCurrent == stringPageSectionHealthQuestionnaire)
		{
			// HARDCODE QUICK FIX FOR INPUT TEXT
					
			var stringInfixHardcode= stringPageInfixTypeCurrent;

			var stringHeightJavaScriptID = stringPrefixText + stringInfixHardcode + "Height";
			var stringHeightJQueryID = stringKres + stringHeightJavaScriptID;
			var stringHeightValue = getTextForm(stringHeightJavaScriptID);
			var stringWeightJavaScriptID = stringPrefixText + stringInfixHardcode + "Weight";
			var stringWeightJQueryID = stringKres + stringHeightJavaScriptID;
			var stringWeightValue = getTextForm(stringWeightJavaScriptID);
			var stringBabyHeightJavaScriptID = stringPrefixText + stringInfixHardcode + "BabyHeight";
			var stringBabyHeightJQueryID = stringKres + stringHeightJavaScriptID;
			var stringBabyHeightValue = getTextForm(stringBabyHeightJavaScriptID);
			var stringBabyWeightJavaScriptID = stringPrefixText + stringInfixHardcode + "BabyWeight";
			var stringBabyWeightJQueryID = stringKres + stringHeightJavaScriptID;
			var stringBabyWeightValue = getTextForm(stringBabyWeightJavaScriptID);
			var stringPregnantWeekJavaScriptID = stringPrefixText + stringInfixHardcode + "PregnantWeek";
			var stringPregnantWeekJQueryID = stringKres + stringPregnantWeekJavaScriptID;
			var stringPregnantWeekValue = getTextForm(stringPregnantWeekJavaScriptID);
			var stringPregnantJavaScriptID = stringPrefixRadioButton + stringInfixHardcode + "Pregnant";
			var stringPregnantJQueryID = stringKres + stringPregnantJavaScriptID;
			var stringPregnantValue = getRadioButtonGeneral(stringPregnantJavaScriptID);
			var stringPregnancyJavaScriptID = stringPrefixRadioButton + stringInfixHardcode + "Pregnancy";
			var stringPregnancyJQueryID = stringKres + stringPregnancyJavaScriptID;
			var stringPregnancyValue = getRadioButtonGeneral(stringPregnancyJavaScriptID);
			var stringWeightChangeJavaScriptID = stringPrefixRadioButton + stringInfixHardcode + "WeightChange";
			var stringWeightChangeJQueryID = stringKres + stringWeightChangeJavaScriptID;
			var stringWeightChangeValue = getRadioButtonGeneral(stringWeightChangeJavaScriptID);

			setHardCode(arrayHealthQuestionnaire, stringHeightJavaScriptID, stringHeightValue);
			setHardCode(arrayHealthQuestionnaire, stringWeightJavaScriptID, stringWeightValue);
			setHardCode(arrayHealthQuestionnaire, stringBabyHeightJavaScriptID, stringBabyHeightValue);
			setHardCode(arrayHealthQuestionnaire, stringBabyWeightJavaScriptID, stringBabyWeightValue);
			setHardCode(arrayHealthQuestionnaire, stringPregnantWeekJavaScriptID, stringPregnantWeekValue);
			setHardCode(arrayHealthQuestionnaire, stringPregnantJavaScriptID, stringPregnantValue);
			setHardCode(arrayHealthQuestionnaire, stringPregnancyJavaScriptID, stringPregnancyValue);
			setHardCode(arrayHealthQuestionnaire, stringWeightChangeJavaScriptID, stringWeightChangeValue);

			objectContent = arrayHealthQuestionnaire;
			// previewArrayObject(arrayHealthQuestionnaire);
		}
		else if (stringPageSectionCurrent == stringPageSectionBeneficiariesList)
		{
			objectContent = arrayBeneficiariesList;
		}
		else
		{
			objectContent = setToDatabase(stringPageTypeCurrent);
		}

		var jsonToDatabase = JSONGenerator(objectContent);
		calliOSFunction('savetoDB:',onSuccess,onError, jsonToDatabase);

		arrayHealthQuestionnaire = [];
		arrayBeneficiariesList = [];
	}
}

function PrintData()
{
    savetoDB();
}

function AutoPopulate(jsonObject)
{        
    var objectContent = JSON.parse(jsonObject);
    var stringType = Object.keys(objectContent.result)[0];                
    
    if (stringType == "autopopulateFromDB")
    {
        getFromDatabase(objectContent.result.autopopulateFromDB, stringPageTypeCurrent);                
    }
    else
    {
        //alert("Not read from database method !.");
    }
}

function ReadData()
{
    readfromDB();
}

function ReplaceHTMLNameOnValidate(title, body)
{
	var callInfo = {};
	callInfo.data = {};
	callInfo.data.title = title;
	callInfo.data.body = body;

	//call the wrapper with the parameterized info
	calliOSFunction('showAlert:',onSuccess,onError, callInfo);
}