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
		alert(returnRet.error);
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
    var objectContent;
    
    if (arrayHealthQuestionnaire.length > 0)
    {
        //alert("no getter !, arrayHealthQuestionnaire length : " + arrayHealthQuestionnaire.length);
        objectContent = arrayHealthQuestionnaire;
    }
    else
    {
        //alert("with getter !, arrayHealthQuestionnaire length : " + arrayHealthQuestionnaire.length);
        objectContent = setToDatabase(stringPageTypeCurrent);
    }
    
    var jsonToDatabase = JSONGenerator(objectContent);
    
    calliOSFunction('savetoDB:',onSuccess,onError, jsonToDatabase);    
}

function PrintData()
{
    savetoDB();
}

function AutoPopulate(jsonObject)
{        
    var objectContent = JSON.parse(jsonObject);
    var stringType = Object.keys(objectContent.result)[0];        
    
    calculateAge("DatePolicyHolderBirthday", "TextPolicyHolderAge");
    
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