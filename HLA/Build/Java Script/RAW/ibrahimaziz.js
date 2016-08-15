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
var arrayAdditionalQuestion = [];
var stringKey;
var stringRadioButtonSuffix = "RadioButton";
var stringAdditionalQuestionSuffix = "AdditionalQuestion";
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
var stringPrefixSelect = "Select";


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

function additionalQuestionGenerator(radioButtonName)
{
    $("input:radio[name=" + radioButtonName + "]").change(function()
    {
        if($(this).val() == "true")
        {
            $("#PopUpAdditionalQuestion").css("display", "block");
            $("#LabelAdditionalQuestion").append($("#Label" + radioButtonName).text());
            $("#TextAdditionalQuestion").empty();
        }
        else
        {
            $("#PopUpAdditionalQuestion").css("display", "none");
            $("#LabelAdditionalQuestion").empty();
        }
        
        stringKey = radioButtonName;
    });
}

function buttonAdditionalQuestionGenerator(popUpID, textID)
{
    $("#ButtonAdditionalQuestionCancel").click(function()
    {
        $(popUpID).css("display", "none");
    });

    $("#ButtonAdditionalQuestionDone").click(function()
    {
        var booleanPushState = true;
        var stringTextKey = stringKey + stringAdditionalQuestionSuffix;
        var stringTextValue = $(textID).val();

        if (validateTextGeneral(textID) == true)
        {
            if (arrayAdditionalQuestion.length > 0)
            {
                for (var i = 0; i < arrayAdditionalQuestion.length; i++)
                {
                    if (arrayAdditionalQuestion[i].key == stringTextKey)
                    {
                        arrayAdditionalQuestion[i].value = stringTextValue;
                        booleanPushState = false;
                    }
                    else
                    {

                    }
                }

                if (booleanPushState == true)
                {
                    arrayAdditionalQuestion.push({ key: stringTextKey, value: stringTextValue });
                }
                else
                {

                }
            }
            else
            {
                arrayAdditionalQuestion.push({ key: stringTextKey, value: stringTextValue });
            }

            $(popUpID).css("display", "none");
            $(textID).empty();

            var stringObjectPreview = "";

            for (var i = 0; i < arrayAdditionalQuestion.length; i++)
            {
                stringObjectPreview += "key : " + arrayAdditionalQuestion[i].key + "\nvalue : " + arrayAdditionalQuestion[i].value + "\n";
            }

            alert(stringObjectPreview);
        }
        else
        {
            validationMessage("Harap lengkapi form terlebih dahulu !.", null);
        }
    });
}

//function inputSetter(stringKey, stringValue)
//{
//    if (suffixGetter(stringKey) == stringRadioButtonSuffix)
//    {
//        radioButtonSetter(stringKey.substring(stringKey.length - stringRadioButtonSuffix.length, stringKey.length), stringValue);
//    }
//    else if (suffixGetter(stringValue) == stringRadioButtonSuffix)
//    {
//        checkboxSetter(stringKey.substring(stringKey.length - stringRadioButtonSuffix.length, stringKey.length), stringValue)
//    }
//    else
//    {
//        $("#" + stringKey).val(stringValue);
//    }
//}


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
//        if (arrayAdditionalQuestion.length > 0)
//        {
//            for (var i = 0; i < arrayAdditionalQuestion.length; i++)
//            {
//                if (arrayAdditionalQuestion[i].key == stringName)
//                {
//                    arrayAdditionalQuestion[i].value = stringRadioButtonValue;
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
//                arrayAdditionalQuestion.push({ key: stringName, value: stringRadioButtonValue});
//            }
//            else
//            {
//
//            }
//        }
//        else
//        {
//            arrayAdditionalQuestion.push({ key: stringName, value: stringRadioButtonValue});
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
//        if (arrayAdditionalQuestion.length > 0)
//        {
//            for (var i = 0; i < arrayAdditionalQuestion.length; i++)
//            {
//                if (arrayAdditionalQuestion[i].key == stringTextKey)
//                {
//                    arrayAdditionalQuestion[i].value = stringTextValue;
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
//                arrayAdditionalQuestion.push({ key: stringTextKey, value: stringTextValue});
//            }
//            else
//            {
//
//            }
//        }
//        else
//        {
//            arrayAdditionalQuestion.push({ key: stringTextKey, value: stringTextValue});
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
        var stringKey = objectContent[i].key;
        var stringValue = objectContent[i].value;
        
        if (stringKey.substring(0, 4) == stringPrefixText)
        {
            if (stringPageType == stringPageTypePDF)
            {
                setTextForm(stringKey, stringValue);
            }
            else
            {
                setTextPDF(stringKey, stringValue);
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
                setSelectForm(stringKey, stringValue);
            }
            else
            {
                setSelectPDF(stringKey, stringValue);
            }
        }
        else if (stringKey.substring(0, 4) == stringPrefixDate)
        {
            if (stringPageType == stringPageTypePDF)
            {
                setDateForm(stringKey, stringValue);
            }
            else
            {
                setDatePDF(stringKey, stringValue);
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
    
    $("input").each(function()
    {
        var stringKey = $(this).attr("id");
        var stringValue;
        
        if ($(this).attr("type") == "text")
        {
            if (stringPageType == stringPageTypePDF)
            {
                stringValue = getTextForm(stringKey);
            }
            else
            {
                stringValue = getTextPDF(stringKey);
            }
            
            objectContent.push({ key: stringKey, value: stringValue });
        }
        else if ($(this).attr("type") == "radio")
        {
            stringValue = getRadioButtonGeneral(stringKey);
            
            objectContent.push({ key: stringKey, value: stringValue });
        }
        else if ($(this).attr("type") == "checkbox")
        {
            stringValue = setCheckboxGeneral(stringKey);
            
            objectContent.push({ key: stringKey, value: stringValue });
        }
        else if ($(this).attr("type") == "date")
        {
            if (stringPageType == stringPageTypePDF)
            {
                getDateForm(stringKey, stringValue);
            }
            else
            {
                getDatePDF(stringKey, stringValue);
            }
            
            objectContent.push({ key: stringKey, value: stringValue });
        }
        else
        {
            
        }
    });
    
    $("select").each(function()
    {
        var stringID = $(this).attr("id");
        
        if (stringPageType == stringPageTypePDF)
        {
            getSelectPDF(stringID);
        }
        else
        {
            getSelectForm(stringID);
        }
        
        objectContent.push({ key: stringKey, value: stringValue });
    });
    
    return objectContent;
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