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
var stringHealthSuffix = "Health"
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

function additionalQuestionGenerator()
{
    $("input[type=radio]").each(function()
    {
        // console.log("radioButtonName : " + $(this).attr("name") + ", data type : " + $(this).data("popup-type"));
        
        if ($(this).data("popup-type") == stringPopUpTypeGeneral)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
                if ($(this).val() == "true")
                {
                    $("#PopUpGeneral").css("display", "block");
                    $("#LabelDetail").append($(stringKres + stringPrefixLabel + $(this).attr("name").substring(11, $(this).attr("name").length)).text());
                    $("#TextDetail").empty();
                }
                else
                {
                    $("#PopUpGeneral").css("display", "none");
                    $("#LabelDetail").empty();
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
                    $("#PopUpHealth").css("display", "block");
                    $("#TextAdditionalQuestion").empty();
                }
                else
                {
                    $("#PopUpHealth").css("display", "none");
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

function buttonPopUpGeneralGenerator()
{
    var stringRadioButtonKey;
    var stringRadioButtonValue;
    var stringDetailKey;
    var stringDetailValue;
    
    $("#PopUpGeneral #ButtonCancel").click(function()
    {
        setRadioButtonGeneral(stringRadioButtonKey, "false");
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        stringDetailkey = stringRadioButtonName + stringDetailSuffix;
        stringDetailValue = $("#TextDetail").val();
        
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
        $("#PopUpGeneral").css("display", "none");
    });

    $("#PopUpGeneral #ButtonDone").click(function()
    {
        alert("general");
        
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        stringDetailKey = stringRadioButtonName + stringDetailSuffix;
        stringDetailValue = $("#TextDetail").val();
        
        if (validateTextGeneral("#TextDetail") == true)
        {
            arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
            arrayAdd(arrayHealthQuestionnaire, stringDetailKey, stringDetailValue);

            $("#PopUpGeneral").css("display", "none");
            $("#TextDetail").empty();

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
    
    $("#PopUpHealth #ButtonCancel").click(function()
    {
        setRadioButtonGeneral(stringRadioButtonKey, "false");
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
        
//        $("#PopUpHealth form input[type=text]").each(function()
//        {
//            stringKey = $(this).attr("id") + stringHealthSuffix;
//            stringValue = getTextGeneral(stringKey);
//
//            if (validateTextGeneral("#TextDetail") == true)
//            {
//                arrayAdd(arrayHealthQuestionnaire, stringKey, stringValue);
//            }
//            else
//            {
//                validationMessage("Harap lengkapi form terlebih dahulu !.", null);
//            }
//        });
        
        $("#PopUpHealth").css("display", "none");
    });

    $("#PopUpHealth #ButtonDone").click(function()
    {
        alert("health");
        
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);

        $("#PopUpHealth form input[type=text]").each(function()
        {
            stringKey = $(this).attr("id") + stringHealthSuffix;
            stringValue = getTextGeneral($(this).attr("id"));

            if (validateTextGeneral("#TextDetail") == true)
            {
                arrayAdd(arrayHealthQuestionnaire, stringKey, stringValue);
            }
            else
            {
                validationMessage("Harap lengkapi form terlebih dahulu !.", null);
            }
        });

        $("#PopUpHealth").css("display", "none");

        $("#PopUpHealth form input[type=text]").each(function()
        {
            $(this).empty();
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
    
    if (radioButton.is(":checked") == false) 
    {
        radioButton.filter("[value=" + stringValue + "]").prop("checked", true);
    }
    else
    {
        
    }
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

//var booleanPushState = true;
//        
//        if (arrayHealthQuestionnaire.length > 0)
//        {
//            for (var i = 0; i < arrayHealthQuestionnaire.length; i++)
//            {
//                if (arrayHealthQuestionnaire[i].key == stringName)
//                {
//                    arrayHealthQuestionnaire[i].value = stringRadioButtonValue;
//                    booleanPushState = false;
//                }
//                else
//                {
//
//                }
//            }
//
//            if (booleanPushState == true)
//            {
//                arrayHealthQuestionnaire.push({ key: stringName, value: stringRadioButtonValue});
//            }
//            else
//            {
//
//            }
//        }
//        else
//        {
//            arrayHealthQuestionnaire.push({ key: stringName, value: stringRadioButtonValue});
//        }

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

//var booleanPushState = true;
//         
//        if (arrayHealthQuestionnaire.length > 0)
//        {
//            for (var i = 0; i < arrayHealthQuestionnaire.length; i++)
//            {
//                if (arrayHealthQuestionnaire[i].key == stringTextKey)
//                {
//                    arrayHealthQuestionnaire[i].value = stringTextValue;
//                    booleanPushState = false;
//                }
//                else
//                {
//                    
//                }
//            }
//
//            if (booleanPushState == true)
//            {
//                arrayHealthQuestionnaire.push({ key: stringTextKey, value: stringTextValue});
//            }
//            else
//            {
//
//            }
//        }
//        else
//        {
//            arrayHealthQuestionnaire.push({ key: stringTextKey, value: stringTextValue});
//        }

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


// GET FROM DATABASE

function getFromDatabase(objectContent, stringPageType)
{    
    for (var i = 0; i < objectContent.length; i++)
    {        
        var stringKey = objectContent[i].elementID;
        var stringValue = objectContent[i].Value;               
        
        if (stringKey.substring(0, 4) == stringPrefixText)
        {            
            if (stringPageType == stringPageTypePDF)
            {
                setTextPDF(stringKey, stringValue);        
            }
            else
            {
                setTextForm(stringKey, stringValue);
            }
        }
        else if (stringKey.substring(0, 11) == stringPrefixRadioButton)
        {            
            setRadioButtonGeneral(stringKey, stringValue);
        }
        else if (stringKey.substring(0, 8) == stringPrefixCheckbox)
        {            
            setRadioCheckboxGeneral(stringKey, stringValue);
        }
        else if (stringKey.substring(0, 6) == stringPrefixSelect)
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
        else if (stringKey.substring(0, 4) == stringPrefixDate)
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

function test1()
{
    alert("1");
}