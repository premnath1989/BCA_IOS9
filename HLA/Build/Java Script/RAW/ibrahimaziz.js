// IBRAHIM AZIZ 
// BHIMBIM
// http://www.ibrahimaziz.biz
// built for InfoConnect Sdn Bhd - BCA Life Bless
// http://www.infoconnect.com.my


// INITIALIZATION

var directoryRoot = "..";
var boxTypeWithBottomLabel = "With bottom label";
var boxTypeWithoutLabel = "Without label";
var labelDay = "Hari";
var labelMonth = "Bulan";
var labelYear = "Tahun";
var sizeBox = 20;
var arrayHealthQuestionnaire = [];
var stringRadioButtonName;
var stringDetailSuffix = "Detail";
var stringCheckboxSuffix = "Checkbox";
var stringButtonPreviewPrefix = "ButtonPreview";
var boxTypeStraight = "Text";
var boxTypeDate = "Date";
var boxTypeTelephone = "Telephone";
var stringIDDay = "Day";
var stringIDMonth = "Month";
var stringIDYear = "Year";
var stringIDPrefix = "Prefix";
var stringIDInfix = "Infix";
var stringIDSuffix = "Suffix";
var stringIDLine = "Line";
var stringHealthSuffix = "Health";
var stringKres = "#";
var stringSeparatorDate = "/";
var stringSeparatorTelephone = "-";
var stateValidation = true;
var stringPageTypePDF = "PDF";
var stringPageTypeForm = "Form";
var stringPrefixText = "Text";
var stringPrefixRadioButton = "RadioButton";
var stringPrefixCheckbox = "Checkbox";
var stringPrefixDate = "Date";
var stringPrefixLabel = "Label";
var stringPrefixSelect = "Select";
var stringPopUpTypeGeneral = "general";
var stringPopUpTypeHealth = "health";
var stringPopUpTypeSPAJProposal = "spajproposal";
var stringInputTypeAutoPopulate = "autopopulate";
var stringTablePrefix = "Table";
var stringBodyPrefix = "Body";
var stringRowPrefix = "Row";
var stringCellPrefix = "Cell";
var stringNumberPrefix = "Number"; 
var arrayHealthTableHeader = ["DiseaseName", "SickFrom", "SickDuration", "DoctorName", "Hospital", "Address", "Telephone"];
var arraySPAJProposalTableHeader = ["CompanyName", "PolicyNumber", "PublishedDate", "BasicSumAssured", "Decision"];
var stringAreaPrefix = "Area";
var stringProspectiveInsuredPrefix = "ProspectiveInsured";
var stringPolicyHolderPrefix = "PolicyHolder";


// GENERATOR

function labelGenerator(labelID, labelAmount)
{
    $(labelID).css("width", (((sizeBox + 4) * labelAmount) - 10) - labelAmount + "px");
}

function spanGenerator(spanID, spanAmount)
{
    $(spanID).css("width", (((sizeBox + 4) * spanAmount) - 10) - spanAmount + "px");
}

function boxGenerator(tableID, boxAmount, boxType, boxLabel)
{
    $(tableID).append("<tbody></tbody>");
    $(tableID + " tbody").append("<tr></tr>");
    var stringTableID = tableID.substring(1, tableID.length);
    
    for (var i = 0; i < boxAmount; i++)
    {
        $(tableID + " tbody tr").append("<td id=" + stringTableID + i + "></td>");
    }
    
    if (boxType == boxTypeWithBottomLabel)
    {
        $(tableID).append("<tfoot><tr><td class='' colspan=" + boxAmount + ">" + boxLabel + "</td></tr></tfoot>");
    }
    else
    {

    }
}

function lineGenerator(lineID, lineAmount)
{
    $(lineID).css("width", ((sizeBox * lineAmount) + 2) + "px");
}

function headerGenerator(stringID)
{
	$(stringID).each(function(index)
	{
		var stringTableOriginalJavaScriptID = $(this).attr("id");
		var stringTableOriginalJQueryID = stringKres + stringTableOriginalJavaScriptID;
		var stringTableUpdatedJavaScriptID = $(this).attr("id") + index;
		var stringTableUpdatedJQueryID = stringKres + stringTableUpdatedJavaScriptID;

		$(this).attr("id", stringTableUpdatedJavaScriptID);

		boxGenerator(stringTableUpdatedJQueryID, 11, boxTypeWithoutLabel, null);
	});
}

function tableHealthGenerator(stringTableID, intRow)
{
	var stringInfixName = stringTableID.substring(stringTablePrefix.length, stringTableID.length);
	var stringTableJQueryID = stringKres + stringTableID;
	var stringRowJavaScriptID;
	var stringRowJQueryID;
	var stringCellJavaScriptID;
	var stringCellJQueryID;
	var stringMonthJavaScriptID;
	var stringMonthJQueryID;
	var stringYearJavaScriptID;
	var stringYearJQueryID;
	var stringBodyJavaScriptID = stringBodyPrefix + stringInfixName;
	var stringBodyJQueryID = stringKres + stringBodyJavaScriptID;
	
	$(stringTableJQueryID).append("<tbody id='" + stringBodyJavaScriptID + "'></tbody>");
	
	for (var i = 0; i < intRow; i++)
	{
		stringRowJavaScriptID = stringRowPrefix + stringInfixName + i;
		stringRowJQueryID = stringKres + stringRowJavaScriptID;
		
		$(stringTableJQueryID + " " + stringBodyJQueryID).append("<tr id='" + stringRowJavaScriptID + "'></tr>");
		
		stringCellJavaScriptID = stringCellPrefix + stringInfixName + stringNumberPrefix + i;
		stringCellJQueryID = stringKres + stringCellJavaScriptID;

		$(stringRowJQueryID).append("<td id='" + stringCellJavaScriptID + "'></td>");
		
		for (var j = 0; j < arrayHealthTableHeader.length - 1; j++)
		{
			stringCellJavaScriptID = stringCellPrefix + stringInfixName + arrayHealthTableHeader[j] + i;
			stringCellJQueryID = stringKres + stringCellJavaScriptID;
			stringMonthJavaScriptID = stringPrefixDate + stringInfixName + arrayHealthTableHeader[j] + stringIDMonth + i;
			stringMonthJQueryID = stringKres + stringMonthJavaScriptID;
			stringYearJavaScriptID = stringPrefixDate + stringInfixName + arrayHealthTableHeader[j] + stringIDYear + i;
			stringYearJQueryID = stringKres + stringYearJavaScriptID;
			
			$(stringRowJQueryID).append("<td id='" + stringCellJavaScriptID + "'></td>");
			
			if (j == 2)
			{
				$(stringRowJQueryID + " " + stringCellJQueryID).append("<label for='" + stringMonthJavaScriptID + "' class='Wrap Single PositionerCenter'>Bulan</label>");
				$(stringRowJQueryID + " " + stringCellJQueryID).append("<table id='" + stringMonthJavaScriptID + "' class='BoxSquare PositionerCenter'></table><br>");
				$(stringRowJQueryID + " " + stringCellJQueryID).append("<label for='" + stringYearJavaScriptID + "' class='Wrap Single PositionerCenter'>Tahun</label>");
				$(stringRowJQueryID + " " + stringCellJQueryID).append("<table id='" + stringYearJavaScriptID + "' class='BoxSquare PositionerCenter'></table>");
				
                boxGenerator(stringMonthJQueryID, 2, boxTypeWithoutLabel, null);
                boxGenerator(stringYearJQueryID, 2, boxTypeWithoutLabel, null);
			}
			else
			{
				
			}
		}
	}
}

function tableSPAJProposalGenerator(stringTableID, intRow)
{
	var stringInfixName = stringTableID.substring(stringTablePrefix.length, stringTableID.length);
	var stringTableJQueryID = stringKres + stringTableID;
	var stringRowJavaScriptID;
	var stringRowJQueryID;
	var stringCellJavaScriptID;
	var stringCellJQueryID;
	var stringBodyJavaScriptID = stringBodyPrefix + stringInfixName;
	var stringBodyJQueryID = stringKres + stringBodyJavaScriptID;
	
	$(stringTableJQueryID).append("<tbody id='" + stringBodyJavaScriptID + "'></tbody>");
	
	for (var i = 0; i < intRow; i++)
	{
		stringRowJavaScriptID = stringRowPrefix + stringInfixName + i;
		stringRowJQueryID = stringKres + stringRowJavaScriptID;
		
		$(stringTableJQueryID + " " + stringBodyJQueryID).append("<tr id='" + stringRowJavaScriptID + "'></tr>");
		
		stringCellJavaScriptID = stringCellPrefix + stringInfixName + stringNumberPrefix + i;
		stringCellJQueryID = stringKres + stringCellJavaScriptID;

		$(stringRowJQueryID).append("<td id='" + stringCellJavaScriptID + "'></td>");
		
		for (var j = 0; j < arraySPAJProposalTableHeader.length; j++)
		{
			stringCellJavaScriptID = stringCellPrefix + stringInfixName + arraySPAJProposalTableHeader[j] + i;
			stringCellJQueryID = stringKres + stringCellJavaScriptID;
			
			$(stringRowJQueryID).append("<td id='" + stringCellJavaScriptID + "'></td>");
		}
	}
}

//function setTableHealth(stringTableID, stringKey, stringValue)
//{
//    var stringTableJQueryID = stringKres + stringTableID;
//	var stringRowJQueryID = stringRowPrefix + stringTableID;
//    
//	for (var i = 0; i < 3; i++)
//	{
//		for (var j = 0; j < arrayTableHeader.length; j++)
//		{
//			if (stringKey.substring(stringKey.length - arrayTableHeader[j].length, stringKey.length) == arrayTableHeader[j])
//			{
//				$(stringTableJQueryID + " tbody" + " " + stringRowJQueryID + i + " td").each(function()
//				{
//					setTextGeneral($(this).attr("id"), stringValue);
//				});
//			}
//			else
//			{
//
//			}
//		}
//	}
//}

function radioButtonHealthQuestionnaireDefault()
{
    $("input:radio[name^='RadioButton']").each(function()
    {
        setRadioButtonGeneral($(this).attr("name"), "false");
    });
}

function buttonPreviewGenerator(stringRadioButtonName, booleanState)
{
    var stringButtonPreviewJQueryID = stringKres + stringButtonPreviewPrefix + stringRadioButtonName.substring(stringPrefixRadioButton.length, stringRadioButtonName.length);
    
    if (booleanState == true)
    {
        $(stringButtonPreviewJQueryID).css("display", "block");
    }
    else
    {
        $(stringButtonPreviewJQueryID).css("display", "none");
    }           
}

function buttonCancelGenerator(stringPopUpID, booleanState)
{
    var stringButtonCancelJQueryID = stringKres + stringPopUpID + " " + stringKres + "ButtonCancel";
    
    if (booleanState == true)
    {
        $(stringButtonCancelJQueryID).css("display", "block");
    }
    else
    {
        $(stringButtonCancelJQueryID).css("display", "none");
    }           
}

function popUpGeneralShow(stringName, booleanInputState)
{
    var stringID = "PopUpGeneral";
    var stringJQueryID = stringKres + stringID;
    var stringInfixName = stringName.substring(stringPrefixRadioButton.length, stringName.length);
    
    $(stringJQueryID).css("display", "block");
    
    if ($("#LabelDetail").text().length > 0)
    {
        
    }
    else
    {
        $("#LabelDetail").append($(stringKres + stringPrefixLabel + stringInfixName).text());
    }

    var stringDetailValue = arrayFind(arrayHealthQuestionnaire, stringPrefixText + stringInfixName + stringDetailSuffix);
    
    $("#TextDetail").val("");
    
    if (stringDetailValue == null || stringDetailValue == undefined)
    {
        
    }
    else
    {
        setTextForm("TextDetail", stringDetailValue);
    }
    
    buttonCancelGenerator(stringID, booleanInputState)
}

function popUpHealthShow(stringName, booleanInputState)
{
    var stringID = "PopUpHealth";
    var stringJQueryID = stringKres + stringID;
    var stringInfixName = stringName.substring(stringPrefixRadioButton.length, stringName.length);
    
    $(stringJQueryID).css("display", "block");
    
    $(stringJQueryID + " input:text").each(function()
    {
        $(stringKres + stringID).val("");
        
        var stringID = $(this).attr("id");
        var stringName = stringID.substring(stringPrefixText.length, stringID.length);
        var stringDetailKey = stringPrefixText + stringInfixName + stringName;
        var stringDetailValue = arrayFind(arrayHealthQuestionnaire, stringDetailKey);
        
        if (stringDetailValue == null || stringDetailValue == undefined)
        {
            
        }
        else
        {
            setTextForm(stringID, stringDetailValue);
        }
    });
    
    buttonCancelGenerator(stringID, booleanInputState)
}

function additionalQuestionGenerator()
{
    var stringDetailKey;
    var stirngInfixName;
    
    $("input:radio[name^='RadioButton']").each(function()
    {
        if ($(this).data("popup-type") == stringPopUpTypeGeneral)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
                if ($(this).val() == "true")
                {
                    
                    popUpGeneralShow($(this).attr("name"), true);
                }
                else
                {
                    $("#PopUpGeneral").css("display", "none");
                    $("#LabelDetail").empty();
                    buttonPreviewGenerator($(this).attr("name"), false);
                    
                    stringInfixName = $(this).attr("name").substring(stringPrefixRadioButton.length, $(this).attr("name").length);
                    stringDetailKey = stringPrefixText + stringInfixName + stringDetailSuffix;
                    arrayDelete(arrayHealthQuestionnaire, stringDetailKey);
                }

                stringRadioButtonName = $(this).attr("name");
            });
        }
        else if ($(this).data("popup-type") == stringPopUpTypeHealth)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
                if ($(this).val() == "true")
                {
                    popUpHealthShow($(this).attr("name"), true);
                }
                else
                {
                    $("#PopUpHealth").css("display", "none");
                    stringInfixName = $(this).attr("name").substring(stringPrefixRadioButton.length, $(this).attr("name").length);
                    
                    $("#PopUpHealth input[type=text]").each(function()
                    {
                        var stringID = $(this).attr("id");
                        var stringName = stringID.substring(stringPrefixText.length, stringID.length);
                        $(this).empty();
                        stringDetailKey = stringPrefixText + stringInfixName + stringName;
                        arrayDelete(arrayHealthQuestionnaire, stringDetailKey);
                    });
                    
                    buttonPreviewGenerator($(this).attr("name"), false);
                }
                
                stringRadioButtonName = $(this).attr("name");
            });
        }
        else if ($(this).data("popup-type") == stringPopUpTypeSPAJProposal)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
                if ($(this).val() == "true")
                {
                    $("#PopUpSPAJProposal").css("display", "block");
                    // $("#LabelAdditionalQuestion").append($("#Label" + radioButtonName).text());
                    // $("#TextAdditionalQuestion").empty();
                }
                else
                {
                    $("#PopUpSPAJProposal").css("display", "none");
                    // $("#LabelAdditionalQuestion").empty();
                }

                stringRadioButtonName = $(this).attr("name");
            });
        }
        else
        {
            
        }
    });
}

function arrayAdd(arrayObject, stringKey, stringValue)
{
    var booleanPushState = true;
    
    if (arrayObject.length > 0)
    {
        for (var i = 0; i < arrayObject.length; i++)
        {
            if (arrayObject[i].elementID == stringKey)
            {
                arrayObject[i].Value = stringValue;
                booleanPushState = false;
            }
            else
            {

            }
        }

        if (booleanPushState == true)
        {
            arrayObject.push({ elementID: stringKey, Value: stringValue });
        }
        else
        {

        }
    }
    else
    {
        arrayObject.push({ elementID: stringKey, Value: stringValue });
    }
}

function arrayDelete(arrayObject, stringKey)
{
    for (var i = 0; i < arrayObject.length; i++)
    {
        if (arrayObject[i].elementID === stringKey) 
        {
            arrayObject.splice(i,1);
            break;
        }
        else
        {
            
        }
    }
}

function arrayFind(arrayObject, stringKey)
{
    var stringValue = null;
    
    for (var i = 0; i < arrayObject.length; i++)
    {
        if (arrayObject[i].elementID === stringKey) 
        {
            stringValue = arrayObject[i].Value;
            break;
        }
        else
        {
            
        }
    }
    
    return stringValue;
}

function buttonPopUpGeneralGenerator()
{
    var stringRadioButtonKey;
    var stringRadioButtonValue;
    var stringDetailKey;
    var stringDetailValue;
    var stringPopUpJavaScriptID = "PopUpGeneral";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    var stringInputJavaScriptID = "TextDetail";
    var stringInputJQueryID = stringKres + stringInputJavaScriptID;
    
    $("input:button[id^='ButtonPreview']").each(function()
    {
        if ($(this).data("popup-type") == stringPopUpTypeGeneral)
        {
            var stringButtonPreviewJQueryID = stringKres + $(this).attr("id");
            var stringButtonPreviewName = $(this).attr("name");
            
            $(stringButtonPreviewJQueryID).click(function()
            {
                stringRadioButtonName = stringButtonPreviewName;
                popUpGeneralShow(stringButtonPreviewName, false);
            });
        }
        else
        {
            
        }
    });
    
    $(stringPopUpJQueryID + " #ButtonCancel").click(function()
    {
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        
        setRadioButtonGeneral(stringRadioButtonKey, "false");
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
        
        $(stringPopUpJQueryID).css("display", "none");
    });

    $(stringPopUpJQueryID + " #ButtonDone").click(function()
    {
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        stringDetailKey = stringPrefixText + stringRadioButtonName.substring(stringPrefixRadioButton.length, stringRadioButtonName.length) + stringDetailSuffix;
        stringDetailValue = getTextGeneral(stringInputJavaScriptID);
        
        if (validateTextGeneral(stringInputJQueryID) == true)
        {
            arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
            arrayAdd(arrayHealthQuestionnaire, stringDetailKey, stringDetailValue);
            buttonPreviewGenerator(stringRadioButtonKey, true);

            $(stringPopUpJQueryID).css("display", "none");
            $(stringInputJQueryID).empty();

            var stringObjectPreview = "";

            for (var i = 0; i < arrayHealthQuestionnaire.length; i++)
            {
                stringObjectPreview += "key : " + arrayHealthQuestionnaire[i].elementID + "\nvalue : " + arrayHealthQuestionnaire[i].Value + "\n";
            }

            alert(stringObjectPreview);
        }
        else
        {
            validationMessage("Harap lengkapi form terlebih dahulu !.", null);
        }
    });
}

function buttonPopUpHealthGenerator()
{
    var stringRadioButtonKey;
    var stringRadioButtonValue;
    var stringDetailKey;
    var stringDetailValue;
    var stringPopUpJavaScriptID = "PopUpHealth";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    var stringInfixName;
    var stringInputJavaScriptID;
    var stringInputJQueryID;
    
    $("input:button[id^='ButtonPreview']").each(function()
    {
        if ($(this).data("popup-type") == stringPopUpTypeHealth)
        {
            var stringButtonPreviewJavaScriptID = $(this).attr("id");
            var stringButtonPreviewJQueryID = stringKres + stringButtonPreviewJavaScriptID;
            var stringButtonPreviewName = $(this).attr("name");
            
            $(stringButtonPreviewJQueryID).click(function()
            {
                stringRadioButtonName = stringButtonPreviewName;
                popUpHealthShow(stringButtonPreviewName, false);
            });
        }
        else
        {
            
        }
    });
    
    $(stringPopUpJQueryID + " #ButtonCancel").click(function()
    {
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        
        setRadioButtonGeneral(stringRadioButtonKey, "false");
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
        
        $(stringPopUpJQueryID).css("display", "none");
    });

    $(stringPopUpJQueryID + " #ButtonDone").click(function()
    {
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
        stringInfixName = stringRadioButtonKey.substring(stringPrefixRadioButton.length, stringRadioButtonKey.length);
        
        $(stringPopUpJQueryID + " form input[type=text]").each(function()
        {
            stringInputJavaScriptID = $(this).attr("id");
            stringInputJQueryID = stringKres + stringInputJavaScriptID;
            stringDetailKey = stringPrefixText + stringInfixName + stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);
            stringDetailValue = getTextGeneral(stringInputJavaScriptID);

            if (validateTextGeneral(stringInputJQueryID) == true)
            {
                arrayAdd(arrayHealthQuestionnaire, stringDetailKey, stringDetailValue);
                buttonPreviewGenerator(stringRadioButtonKey, true);
            }
            else
            {
                validationMessage("Harap lengkapi form terlebih dahulu !.", null);
            }
        });

        $(stringPopUpJQueryID).css("display", "none");

        $(stringPopUpJQueryID + " form input[type=text]").each(function()
        {
            $(this).val("");
        });

        var stringObjectPreview = "";

        for (var i = 0; i < arrayHealthQuestionnaire.length; i++)
        {
            stringObjectPreview += "key : " + arrayHealthQuestionnaire[i].elementID + "\nvalue : " + arrayHealthQuestionnaire[i].Value + "\n";
        }

        alert(stringObjectPreview);
    });
}


// VALIDATE

function validateState(stateValidate)
{
    if (stateValidate == true)
    {
        if (stateValidation == true)
        {
            stateValidation = true;
        }
        else
        {
            
        }
    }
    else
    {
        if (stateValidation == true)
        {
            stateValidation = false;
        }
        else
        {

        }
    }
}

function validationMessage(stringMessageNegative, stringMessagePositive)
{
    if (stateValidation == false)
    {
        alert(stringMessageNegative);
        stateValidation = true;
    }
    else
    {
        if (stringMessageNegative == null)
        {

        }
        else
        {
            alert(stringMessagePositive)
        }
    }
}

function validateTextGeneral(textID)
{
    if ($(textID).val().length > 0)
    {
        validateState(true);
        return true;
    }
    else
    {
        validateState(false);
        return false;
    }
}

function validateRadioButtonGeneral(radioButtonName)
{
    if ($("input:radio[name=" + radioButtonName + "]:checked").val() != undefined)
    {
        validateState(true);
        return true;
    }
    else
    {
        validateState(false);
        return false;
    }
}

function validatePush(objectContent, stringKey, stringValue)
{
    if (stringValue == undefined | stringValue == "")
    {
        
    }
    else
    {
        objectContent.push({ elementID: stringKey, Value: stringValue });
    }
}


// SETTER

function setBoxGeneral(stringID, stringValue)
{
    var stringJQueryID = stringKres + stringID;
    
    for (var i = 0; i < stringValue.length; i++)
    {
        $(stringJQueryID + " tbody tr " + stringJQueryID + i).append(stringValue[i]);
    }
}

function setTextGeneral(stringID, stringValue)
{
    var stringJQueryID = stringKres + stringID;
    
    $(stringJQueryID).val(stringValue);
}

function setLineGeneral(stringID, stringValue)
{
    var stringJQueryID = stringKres + stringID;
    
    $(stringJQueryID).empty();
    $(stringJQueryID).append(stringValue);
}

function setRadioButtonGeneral(stringName, stringValue)
{
    var radioButton = $("input:radio[name=" + stringName + "]");
    
    radioButton.filter("[value='" + stringValue + "']").prop("checked", true);
}

function setSelectForm(stringID, stringValue)
{
    setTextGeneral(stringID, stringValue);
}

function setSelectPDF(stringID, stringValue)
{
    setBoxGeneral(stringID, stringValue);
}

function setCheckboxGeneral(stringName, stringValue)
{
    var radioButton = $("input:checkbox[name=" + stringName + "]");
    
    if (radioButton.is(":checked") == false) 
    {
        radioButton.filter("[value=" + stringValue + "]").prop("checked", true);
    }
    else
    {
        
    }
}

function setTextForm(stringID, stringValue)
{
    setTextGeneral(stringID, stringValue);
}

function setTextPDF(stringID, stringValue)
{
    if (stringValue.indexOf(stringSeparatorTelephone) > 0)
    {
        var arrayTelephoneString = stringValue.split(stringSeparatorTelephone);
        var arrayTelephoneID = [stringIDPrefix, stringIDInfix];
        
        for(var i = 0; i < arrayTelephoneString.length; i++)
        {
            setBoxGeneral(stringID + arrayTelephoneID[i], arrayTelephoneString[i]);
        } 
    }
    else
    {
        var stringJQueryID = stringKres + stringID;
        
        if ($(stringJQueryID).is("div") == true)
        {
            setLineGeneral(stringID, stringValue);
        }
        else if ($(stringJQueryID).is("td") == true)
        {
            setTextGeneral(stringID, stringValue);
        }
        else
        {
            setBoxGeneral(stringID, stringValue);
        }
    }
}

function setDateForm(stringID, stringValue)
{
    setTextGeneral(stringID, stringValue);
}

function setDatePDF(stringID, stringContent)
{
    var arrayDateID = [stringIDDay, stringIDMonth, stringIDYear];
    var arrayDateString = stringContent.split(stringSeparatorDate);
    
    for (var i = 0; i < arrayDateString.length; i++)
    {        
        setBoxGeneral(stringID + arrayDateID[i], arrayDateString[i]);
    }
}

function setAreaForm(stringID, stringValue)
{
    setTextGeneral(stringID, stringValue);
}

function setAreaPDF(stringID, stringValue)
{
    setBoxGeneral(stringID, stringValue);
}


// GETTER

function getBoxGeneral(stringID)
{
    var stringJQueryID = stringKres + stringID;
    var stringContent = "";
    
    $(stringJQueryID + " tbody tr td").each(function(index)
    {
        var stringText = $(this).text();
        
        if (stringText.length > 0)
        {
            stringContent += stringText;
        }
        else
        {
            
        }
    });
    
    return stringContent;
}

function getTextGeneral(stringID)
{
    var stringJQueryID = stringKres + stringID;
    
    return $(stringJQueryID).val();
}

function getRadioButtonGeneral(stringName)
{
    var stringRadioButtonValue;
    
    if (validateRadioButtonGeneral(stringName) == false)
    {
        // alert("Harap pilih radio button di bawah ini !.");
    }
    else
    {
        stringRadioButtonValue = $("input:radio[name=" + stringName + "]:checked").val()
    }
    
    return stringRadioButtonValue;
}

function getSelectForm(stringID)
{
    return getTextGeneral(stringID);
}

function getSelectPDF(stringID)
{
    return getBoxGeneral(stringID);
}

function getCheckboxGeneral(stringName)
{
    var stringCheckboxValue;
    
    if (validateCheckboxGeneral(stringName) == false)
    {
        // alert("Harap pilih radio button di bawah ini !.");
    }
    else
    {
        stringCheckboxValue = $("input:checkbox[name=" + stringName + "]:checked").val()
    }
    
    return stringCheckboxValue;
}

function getTextForm(stringID)
{
    return getTextGeneral(stringID);
}

//if (validateTextGeneral(stringID) == false)
//    {
//        // alert("Harap isi kolom di bawah ini !.");
//    }
//    else
//    {
//        
//    }

function getTextPDF(stringID)
{
    var stringTextValue = $(stringID).val();
    var stringJQueryID = stringKres + stringID;
    var stringContent = "";
    
    if (stringJQueryID.is("table") == true)
    {
        if ((stringJQueryID + "Prefix").length > 0)
        {
            stringContent += getBoxGeneral(stringJQueryID + "Prefix");
            stringContent += stringSeparatorTelephone;
            stringContent += getBoxGeneral(stringJQueryID + "Infix");
        }
        else
        {
            stringContent += getBoxGeneral(stringJQueryID);
        }
    }
    else if (stringJQueryID.is("td") == true)
    {
        stringContent = $(stringJQueryID).text();
    }
    else
    {
        stringContent = $(stringJQueryID).text();
    }
    
    return stringContent;
}
    
function getDateForm(stringID)
{
    return getTextGeneral(stringID);
}

function getDatePDF(stringID)
{
    return getBoxGeneral(stringID);
}

function getAreaForm(stringID)
{
    return getBoxGeneral(stringID);
}

function getAreaPDF(stringID)
{
    return getBoxGeneral(stringID);
}


// GET FROM DATABASE

function getFromDatabase(objectContent, stringPageType)
{    
    for (var i = 0; i < objectContent.length; i++)
    {        
        var stringKey = objectContent[i].elementID;
        var stringValue = objectContent[i].Value;               
        
        if (stringKey.substring(0, stringPrefixText.length) == stringPrefixText)
        {
//			for (var j = 0; j < arrayHealthTableHeader.length; j++)
//			{
//				if (stringKey.substring(stringKey.length - arrayHealthTableHeader[j].length, stringKey.length) == arrayHealthTableHeader[j])
//				{
//					var stringIndicatorPrefix = stringKey.substring(stringPrefixText.length, string.PrefixText.length + 3);
//					var stringIndicatorPolicyHolder = "Pol";
//					var stringIndicatorProspectiveInsured = "Pro";
//					
//					if (stringIndicatorPrefix == stringIndicatorPolicyHolder)
//					{
//						$("#TablePolicyHolderIllness tbody tr").each(function()
//						{
//                            var stringCellID = $(this).attr("id");
//                            var stringCellInfix = 
//                            
//							if ()
//						});
//					}
//					else
//					{
//						$("#TableProspectiveInsuredIllness tbody tr").each(function()
//						{
//							
//						});
//					}
//					
//					$(stringTableJQueryID + " tbody" + " " + stringRowJQueryID + i + " td").each(function()
//					{
//						setTextGeneral($(this).attr("id"), stringValue);
//					});
//					
//					alert(stringKey + " == " + arrayHealthTableHeader[j]);
//				}
//				else
//				{
//
//				}
//			}
			
			if (stringPageType == stringPageTypePDF)
			{
				setTextPDF(stringKey, stringValue);        
			}
			else
			{
				setTextForm(stringKey, stringValue);
			}
        }
        else if (stringKey.substring(0, stringPrefixRadioButton.length) == stringPrefixRadioButton)
        {            
            setRadioButtonGeneral(stringKey, stringValue);
        }
        else if (stringKey.substring(0, stringPrefixCheckbox.length) == stringPrefixCheckbox)
        {            
            setRadioCheckboxGeneral(stringKey, stringValue);
        }
        else if (stringKey.substring(0, stringPrefixSelect.length) == stringPrefixSelect)
        {            
            if (stringPageType == stringPageTypePDF)
            {
                setSelectPDF(stringKey, stringValue);
            }
            else
            {
                setSelectForm(stringKey, stringValue);
            }
        }
        else if (stringKey.substring(0, stringPrefixDate.length) == stringPrefixDate)
        {            
            if (stringPageType == stringPageTypePDF)
            {
                setDatePDF(stringKey, stringValue);
            }
            else
            {
                setDateForm(stringKey, stringValue);
            }
        }
        else if (stringKey.substring(0, stringAreaPrefix.length) == stringAreaPrefix)
        {            
            if (stringPageType == stringPageTypePDF)
            {
                setAreaPDF(stringKey, stringValue);
            }
            else
            {
                setAreaForm(stringKey, stringValue);
            }
        }
        else
        {
            
        }
    }
}


// SET TO DATABASE

function setToDatabase(stringPageType)
{
    var objectContent = [];
    
    $("input[type=text]").each(function()
    {
        var stringKey = $(this).attr("id");
        var stringValue;
        
        if (stringPageType == stringPageTypePDF)
        {
            stringValue = getTextPDF(stringKey);
        }
        else
        {
            stringValue = getTextForm(stringKey);
        }

        validatePush(objectContent, stringKey, stringValue);
    });
    
//    $("input[type=checkbox]").each(function()
//    {
//        stringValue = setCheckboxGeneral(stringKey);
//            
//        validatePush(objectContent, stringKey, stringValue);
//    });
    
    $("input[type=date]").each(function()
    {
        var stringKey = $(this).attr("id");
        var stringValue;
        
        if (stringPageType == stringPageTypePDF)
        {
            stringValue = getDatePDF(stringKey);
        }
        else
        {
            stringValue = getDateForm(stringKey);
        }

        validatePush(objectContent, stringKey, stringValue);
    });
    
    $("input[type=radio]").each(function()
    {
        var stringKey = $(this).attr("name");
        var stringValue;
        var booleanDuplicate = false;
        
        for (var i = 0; i < objectContent.length; i++)
        {
            if (objectContent[i].elementID == stringKey)
            {
                booleanDuplicate = true;
                i = objectContent.length;
            }
            else
            {
                booleanDuplicate = false;
            }
        }
        
        if (booleanDuplicate == true)
        {
            
        }
        else
        {
            stringValue = getRadioButtonGeneral(stringKey);

            validatePush(objectContent, stringKey, stringValue);
        }
    });
    
    $("select").each(function()
    {
        var stringKey = $(this).attr("id");
        var stringValue;
        
        if (stringPageType == stringPageTypePDF)
        {
            stringValue = getSelectPDF(stringKey);
        }
        else
        {
            stringValue = getSelectForm(stringKey);
        }
        
        validatePush(objectContent, stringKey, stringValue);
    });
    
    $("textarea").each(function()
    {
        var stringKey = $(this).attr("id");
        var stringValue;
        
        if (stringPageType == stringPageTypePDF)
        {
            stringValue = getAreaPDF(stringKey);
        }
        else
        {
            stringValue = getAreaForm(stringKey);
        }
        
        validatePush(objectContent, stringKey, stringValue);
    });
    
    return objectContent;
}

function JSONGenerator(objectContent) 
{
    var callInfo = {};
    callInfo.data = {};
    callInfo.data.SPAJAnswers = [];

    for (var i = 0; i < objectContent.length; i++)
    {
        callInfo.data.SPAJAnswers.push({ elementID : objectContent[i].elementID, Value : objectContent[i].Value, SPAJID : "1", CustomerID : "1" });
    }

    console.log(JSON.stringify(callInfo));
    
    return callInfo;
}


// MONITORING

function radioButtonMonitoring(radioButtonName)
{
    $("input:radio[name=" + radioButtonName + "]").change(function()
    {
        var stringValue;
        
        if ($(this).is(":checked"))
        {
            stringValue = $(this).val();
        }
        else
        {
            
        }
        
        return stringValue;
    });
}

function calculateAge(stringBirthdayID, stringAgeID)
{
    var stringBirthdayJQueryID = stringKres + stringBirthdayID;
    var stringAgeJQueryID = stringKres + stringAgeID;
    
    $(stringBirthdayJQueryID).change(function()
    {
        
        if ($(stringBirthdayJQueryID).val().length > 0)
        {
            var arrayBirthday = $(stringBirthdayJQueryID).val().split('/');
            var dateBirthday = new Date(arrayBirthday[2], arrayBirthday[1], arrayBirthday[0]);
            var dateToday = new Date();        
            var dateDifference = Math.ceil(dateToday.getTime() - dateBirthday.getTime()) / (1000 * 60 * 60 * 24 * 365);
            var intAge = parseInt(dateDifference);
            
            if (intAge == null || intAge == undefined)
            {
                $(stringAgeJQueryID).val("");
            }
            else
            {
                $(stringAgeJQueryID).val(intAge);
            }
        }
        else
        {

        }
    });
}

function autoPopulateState()
{
   var stringJQueryID;

   $("input[data-input-type='" + stringInputTypeAutoPopulate +
"']").each(function()
   {
       stringJQueryID = stringKres +$(this).attr("id");

       $(stringJQueryID).prop("readonly", true);
   });
}

function radioButtonOtherGenerator(stringRadioButtonName, stringTextID,
stringValue)
{
   $(stringTextID).prop("readonly", true);

   $("input:radio[name='" + stringRadioButtonName + "']").change(function()
   {
       if (getRadioButtonGeneral(stringRadioButtonName) == stringValue)
       {
           $(stringTextID).prop("readonly", false);
       }
       else
       {
           $(stringTextID).prop("readonly", true);
           $(stringTextID).val('');
       }
   });
}