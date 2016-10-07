// IBRAHIM AZIZ 
// BHIMBIM
// http://www.ibrahimaziz.biz
// built for InfoConnect Sdn Bhd - BCA Life Bless
// http://www.infoconnect.com.my


// INITIALIZATION

var directoryRoot = "..";
var boxTypeWithBottomLabel = "With bottom label";
var boxTypeWithoutLabel = "Without label";
var labelDay = "Tanggal";
var labelMonth = "Bulan";
var labelYear = "Tahun";
var labelDate = "Tanggal";
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
var arrayHealthTableHeader = ["DiseaseName", "DiseaseSickFrom", "DiseaseSickDuration", "DiseaseDoctorName", "DiseaseHospital", "DiseaseAddress", "DiseaseTelephone"];
var arraySPAJProposalTableHeader = ["CompanyName", "PolicyNumber", "Published", "BasicSumAssured", "Decision"];
var stringAreaPrefix = "Area";
var stringProspectiveInsuredPrefix = "ProspectiveInsured";
var stringPolicyHolderPrefix = "PolicyHolder";
var arrayCountryList = [];
var stringButtonPrefix = "Button";
var stringHandphoneSuffix = "Handphone";
var boxTypeWithBottomNote = "With bottom note";
var arrayBeneficiariesList = [];
var intBeneficiariesListID = 1;
var stringBeneficiariesListInfix = "BeneficiariesList";
var stringPageSectionForm = "Form";
var stringPageSectionHealthQuestionnaire = "Health Questionnaire";
var stringPageSectionBeneficiariesList = "Beneficiaries List";
var stringButtonViewPrefix = "ButtonView";
var stringButtonDeletePrefix = "ButtonDelete";
var stringSharePercentage = 0;
var arrayBeneficiariesListTableHeader = ["FullName", stringIDDay, stringIDMonth, stringIDYear, "Sex", "Relationship", "Nationality"];
var arrayBeneficiariesListPopUpHeader = ["FullName", "Birthday", "Sex", "Relationship", "Nationality"];
var intSharePercentage = 0;
var stringSharePercentageSuffix = "SharePercentage";
var stringSPAJProposalInfix = "SPAJProposal";
var intSPAJProposalID = 1;
var intSPAJProposalRecentID = null;
var stringPopUpTypeHardCopy = "hardcopy";
var stringIndicatorPolicyHolder = "Pol";
var stringIndicatorProspectiveInsured = "Pro";
var stringPopUpTypeCardiac = "PopUpCardiac";
var stringPopUpTypeChestPain = "PopUpChestPain";
var stringPopUpTypeHipertensi = "PopUpHipertensi";
var stringPrefixEmail = "Email";
var stringPrefixNumber = "Number";
var stringStateRequired = "required";
var intBeneficiariesListRecentID = null;
var stringPageValidationIncome = "income";
var stringPrefixArea = "Area";
var stringPageTypeHealthQuestionnairePDF = "HealthQuestionnairePDF";
var stringAmandmentSuffix = "Amandment";
var stringPageTypeAmandment = "Amandment";
var stringStateNotChecked = "Not Checked";
var stringStateNotSelected = "Not Selected";
var stringNationality;
var arrayRelationshipWithProspectiveInsured = [];
var arrayNationality = [];
var stringIllnessSuffix = "Illness";


// GENERATOR

function labelGenerator(labelID, labelAmount)
{
    $(labelID).css("width", (((sizeBox + 4) * labelAmount) - 10) - labelAmount + "px");
}

function labelGeneratorForHealthQuestionnaire(labelID, labelAmount)
{
    $(labelID).css("width", ((sizeBox + 3) * labelAmount) + "px");
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
	else if (boxType == boxTypeWithBottomNote)
	{
		$(tableID).append("<tfoot><tr><td class='Note' colspan=" + boxAmount + ">" + boxLabel + "</td></tr></tfoot>");
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

function setHeader(stringValue)
{
	$(".HeaderGeneral table").each(function(index)
	{
		setBoxGeneral($(this).attr("id"), stringValue);
	});
}

function footerGenerator(stringDetail, intTotalPage)
{
	$(".SpanFooterDetail").each(function(indexPage)
	{
		$(this).text(stringDetail + " Hal " + (indexPage + 1) + " / " + intTotalPage);
	})
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
			
			if (j == 1)
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

function tablePDFSPAJProposalGenerator(stringTableID, intRow)
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

function tablePDFBeneficiariesListGenerator(stringTableID, intRow)
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
		
		for (var j = 0; j < arrayBeneficiariesListTableHeader.length; j++)
		{
			stringCellJavaScriptID = stringCellPrefix + stringInfixName + arrayBeneficiariesListTableHeader[j] + i;
			stringCellJQueryID = stringKres + stringCellJavaScriptID;
			
			$(stringRowJQueryID).append("<td id='" + stringCellJavaScriptID + "'></td>");
		}
	}
}

function radioButtonHealthQuestionnaireDefault()
{
    $("input:radio[name^='RadioButton']").each(function()
    {
        setRadioButtonGeneral($(this).attr("name"), "false");
    });
}


// BUTTON GENERATOR

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





// POP UP SHOW

function popUpGeneralShow(stringTriggerName, booleanInputState)
{
    var stringPopUpJavaScriptID = "PopUpGeneral";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    var stringRadioButtonNameWithoutPrefix = stringTriggerName.substring(stringPrefixRadioButton.length, stringTriggerName.length);
    
    $(stringPopUpJQueryID).css("display", "block");
    
    $("#LabelDetail").text("");
    
    if ($("#LabelDetail").text().length > 0)
    {
        
    }
    else
    {
        $("#LabelDetail").append($(stringKres + stringPrefixLabel + stringRadioButtonNameWithoutPrefix).text());
    }

    areaPopUpSetter(stringPopUpJavaScriptID, stringRadioButtonNameWithoutPrefix, arrayHealthQuestionnaire);
    buttonCancelGenerator(stringPopUpJavaScriptID, booleanInputState)
}

function popUpHealthShow(stringTriggerName, booleanInputState)
{
    var stringPopUpJavaScriptID = "PopUpHealth";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    var stringRadioButtonNameWithoutPrefix = stringTriggerName.substring(stringPrefixRadioButton.length, stringTriggerName.length);
    
    $(stringPopUpJQueryID).css("display", "block");
    
    textPopUpSetter(stringPopUpJavaScriptID, stringRadioButtonNameWithoutPrefix, arrayHealthQuestionnaire);
    
    buttonCancelGenerator(stringPopUpJavaScriptID, booleanInputState);
}

function releasePrefix(stringKey)
{
	if (stringKey.substring(0, stringPrefixText.length) == stringPrefixText)
	{
		return stringKey.substring(stringPrefixText.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringPrefixRadioButton.length) == stringPrefixRadioButton)
	{
		return stringKey.substring(stringPrefixRadioButton.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringPrefixSelect.length) == stringPrefixSelect)
	{
		return stringKey.substring(stringPrefixSelect.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringPrefixDate.length) == stringPrefixDate)
	{
		return stringKey.substring(stringPrefixDate.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringPrefixArea.length) == stringPrefixArea)
	{
		return stringKey.substring(stringPrefixArea.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringPrefixCheckbox.length) == stringPrefixCheckbox)
	{
		return stringKey.substring(stringPrefixCheckbox.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringPrefixNumber.length) == stringPrefixNumber)
	{
		return stringKey.substring(stringPrefixNumber.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringPrefixEmail.length) == stringPrefixEmail)
	{
		return stringKey.substring(stringPrefixEmail.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringTablePrefix.length) == stringTablePrefix)
	{
		return stringKey.substring(stringTablePrefix.length, stringKey.length);
	}
	else
	{
		
	}
}

function setKeyPrefix(stringInputJavaScriptID, stringInputInfix)
{
	if (stringInputJavaScriptID.substring(0, stringPrefixText.length) == stringPrefixText)
	{
		return stringPrefixText + stringInputInfix;
	}
	else if (stringInputJavaScriptID.substring(0, stringPrefixDate.length) == stringPrefixDate)
	{
		return stringPrefixDate + stringInputInfix;
	}
	else if (stringInputJavaScriptID.substring(0, stringPrefixRadioButton.length) == stringPrefixRadioButton)
	{
		return stringPrefixRadioButton + stringInputInfix;
	}
	else if (stringInputJavaScriptID.substring(0, stringPrefixCheckbox.length) == stringPrefixCheckbox)
	{
		return stringPrefixCheckbox + stringInputInfix;
	}
	else if (stringInputJavaScriptID.substring(0, stringPrefixSelect.length) == stringPrefixSelect)
	{
		return stringPrefixSelect + stringInputInfix;
	}
	else if (stringInputJavaScriptID.substring(0, stringPrefixArea.length) == stringPrefixArea)
	{
		return stringPrefixArea + stringInputInfix;
	}
	else if (stringInputJavaScriptID.substring(0, stringPrefixNumber.length) == stringPrefixNumber)
	{
		return stringPrefixNumber + stringInputInfix;
	}
	else if (stringInputJavaScriptID.substring(0, stringPrefixEmail.length) == stringPrefixEmail)
	{
		return stringPrefixEmail + stringInputInfix;
	}
	else
	{
		
	}
}

function popUpSPAJProposalShow(stringKeyID, stringPopUpJavaScriptID, arrayContent)
{
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    $(stringPopUpJQueryID).css("display", "block");
	
	// INPUT SETTER
	
	$(stringPopUpJQueryID + " input:text").each(function()
    {
        var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		$(stringInputJQueryID).val("");
		var stringInputSuffix = releasePrefix(stringInputJavaScriptID);
        var stringKey = setKeyPrefix(stringInputJavaScriptID, stringPageInfixTypeCurrent + "SPAJProposal" + stringInputSuffix + stringKeyID);
        var stringValue = arrayFind(arrayContent, stringKey);
		
        if (stringValue == null || stringValue == undefined)
        {
            
        }
        else
        {
            setTextForm(stringInputJavaScriptID, stringValue);
        }
    });
}

function popUpBeneficiariesListShow(stringKeyID)
{
    var stringPopUpJavaScriptID = "PopUpBeneficiariesList";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    
    $(stringPopUpJQueryID).css("display", "block");
    
	// INPUT SETTER
	
	$(stringPopUpJQueryID + " input:text").each(function()
    {
        var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		$(stringInputJQueryID).val("");
		var stringInputIDWithoutPrefix;
        var stringKey;
		
		if (stringInputJavaScriptID.substring(0, stringPrefixDate.length) == stringPrefixDate)
		{
			stringInputIDWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixDate.length, stringInputJavaScriptID.length);
			stringKey = stringPrefixDate + stringBeneficiariesListInfix + stringInputIDWithoutPrefix + stringKeyID;
		}
		else
		{
			stringInputIDWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);
			stringKey = stringPrefixText + stringBeneficiariesListInfix + stringInputIDWithoutPrefix + stringKeyID;
		}
		
        var stringValue = arrayFind(arrayBeneficiariesList, stringKey);
		
        if (stringValue == null || stringValue == undefined)
        {
            
        }
        else
        {
            setTextForm(stringInputJavaScriptID, stringValue);
        }
    });
	
	$(stringPopUpJQueryID + " input:radio").each(function()
    {
        var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		var stringInputName = $(this).attr("name");
		setRadioButtonGeneral(stringInputName, null);
        var stringInputNamePrefix = releasePrefix(stringInputName);
        var stringKey = stringPrefixRadioButton + stringBeneficiariesListInfix + stringInputNamePrefix + stringKeyID;
        var stringValue = arrayFind(arrayBeneficiariesList, stringKey);
		
        if (stringValue == null || stringValue == undefined)
        {
            
        }
        else
        {
            setRadioButtonGeneral(stringInputName, stringValue);
        }
    });
	
	$(stringPopUpJQueryID + " select").each(function()
    {
        var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		
        var stringInputIDWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixSelect.length, stringInputJavaScriptID.length);
        var stringKey = stringPrefixSelect + stringBeneficiariesListInfix + stringInputIDWithoutPrefix + stringKeyID;
        var stringValue = arrayFind(arrayBeneficiariesList, stringKey);

        if (stringValue == null || stringValue == undefined)
        {
            
        }
        else
        {
            setSelectForm(stringInputJavaScriptID, stringValue);
        }
    });
}


// POP UP GENERATOR

function beneficiariesListGenerator(stringButtonJavaScriptID)
{
	var stringButtonJQueryID = stringKres + stringButtonJavaScriptID;
	var stringButtonIDWithoutPrefix = stringButtonJavaScriptID.substring(stringButtonPrefix.length, stringButtonJavaScriptID.length);
	
	$(stringButtonJQueryID).click(function()
	{
		if (arrayBeneficiariesList.length >= 10 && parseInt(intSharePercentage, 10) >= 100)
		{
			ReplaceHTMLNameOnValidate("","Maksimal 10 penerima manfaat atau share percentage sudah mencapai 100 !.");
			//alert("Maksimal 10 penerima manfaat atau share percentage sudah mencapai 100 !.");
		}
		else
		{
			popUpBeneficiariesListShow(null);
		}
	})
}

function SPAJProposalGenerator(stringButtonJavaScriptID)
{
	var stringButtonJQueryID = stringKres + stringButtonJavaScriptID;
	
	$(stringButtonJQueryID).click(function()
	{
		popUpSPAJProposalShow(null, "PopUpSPAJProposal", arrayHealthQuestionnaire);
	})
}

function additionalQuestionGenerator()
{
    var stringDetailKey;
    var stirngInfixName;
	
    $("#ButtonAddSPAJProposal").css("display", "none");
	
    $("input:radio[name^='RadioButton']").each(function()
    {
        if ($(this).data("popup-type") == stringPopUpTypeGeneral)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
				stringInfixName = $(this).attr("name").substring(stringPrefixRadioButton.length, $(this).attr("name").length);
				
                if ($(this).val() == "true")
                {
                    popUpGeneralShow($(this).attr("name"), true);
                }
                else
                {
                    $("#PopUpGeneral").css("display", "none");
                    $("#LabelDetail").empty();
                    buttonPreviewGenerator($(this).attr("name"), false);
                    
                    stringDetailKey = stringPrefixText + stringInfixName + stringDetailSuffix;
                    arrayDelete(arrayHealthQuestionnaire, stringDetailKey);
                }

				arrayAdd(arrayHealthQuestionnaire, $(this).attr("name"), getRadioButtonGeneral($(this).attr("name")));
				
				stringRadioButtonName = $(this).attr("name");
            });
        }
        else if ($(this).data("popup-type") == stringPopUpTypeHealth)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
				stringInfixName = releasePrefix($(this).attr("name"));
				
                if ($(this).val() == "true")
                {
                    popUpHealthShow($(this).attr("name"), true);
					
					if (stringInfixName.substring(0, 3) == "Pol")
					{
						setRadioButtonGeneral("RadioButtonPolicyHolderMedicalTreatment", true);
					}
					else
					{
						setRadioButtonGeneral("RadioButtonProspectiveInsuredMedicalTreatment", true);
					}
                }
                else
                {
                    $("#PopUpHealth").css("display", "none");
                    
                    $("#PopUpHealth input[type=text]").each(function()
                    {
                        var stringID = $(this).attr("id");
                        var stringName = releasePrefix(stringID);
                        $(this).val("");
                        stringDetailKey = stringPrefixText + stringInfixName + stringName;
                        arrayDelete(arrayHealthQuestionnaire, stringDetailKey);
                    });
                    
                    buttonPreviewGenerator($(this).attr("name"), false);
                }
                
				arrayAdd(arrayHealthQuestionnaire, $(this).attr("name"), getRadioButtonGeneral($(this).attr("name")));
				
                stringRadioButtonName = $(this).attr("name");
            });
        }
        else if ($(this).data("popup-type") == stringPopUpTypeSPAJProposal)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
				var stringInfix = releasePrefix($(this).attr("name"));
				
                if ($(this).val() == "true")
                {
                    popUpSPAJProposalShow(null, "PopUpSPAJProposal", arrayHealthQuestionnaire);
					$("#ButtonAddSPAJProposal").css("display", "block");
                }
                else
                {
                	var arrayInputTemporary = [];

					$("#PopUpSPAJProposal input[type=text]").each(function()
                    {
                        var stringID = $(this).attr("id");
                        var stringSuffix = releasePrefix(stringID);
                        
                        $(this).val("");
                        stringDetailKey = setKeyPrefix(stringID, stringInfix + stringSuffix);

						for (var k = 0; k < arrayHealthQuestionnaire.length; k++)
						{
							if (stringDetailKey == arrayHealthQuestionnaire[k].elementID.substring(0, stringDetailKey.length))
							{
								arrayAdd(arrayInputTemporary, arrayHealthQuestionnaire[k].elementID)
							}
							else
							{
								
							}
						}
                    });
					
					for (var i = 0; i < arrayInputTemporary.length; i++)
					{
						arrayDelete(arrayHealthQuestionnaire, arrayInputTemporary[i].elementID);
					}

                    $("#ButtonAddSPAJProposal").css("display", "none");
					tableSPAJProposalGenerator("SPAJProposalList", arrayHealthQuestionnaire);
					previewArrayObject(arrayHealthQuestionnaire);
                }

				arrayAdd(arrayHealthQuestionnaire, $(this).attr("name"), getRadioButtonGeneral($(this).attr("name")));
                stringRadioButtonName = $(this).attr("name");
            });
        }
		else if ($(this).data("popup-type") == stringPopUpTypeHardCopy)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
				stringInfixName = releasePrefix($(this).attr("name"));
				
                if ($(this).val() == "true")
                {
					var stringIndicator = $(this).data("question-title");
					ReplaceHTMLNameOnValidate("","Harap mengisi form kuesioner " + stringIndicator + " melalui hard copy.");
                    // alert("Harap mengisi form kuesioner nomor 6 melalui hard copy.");
					
					if (stringInfixName.substring(0, 3) == "Pol")
					{
						setRadioButtonGeneral("RadioButtonPolicyHolderHealthDissorder", true);
					}
					else
					{
						setRadioButtonGeneral("RadioButtonProspectiveInsuredHealthDissorder", true);
					}
                }
                else
                {
					
                }
				
				arrayAdd(arrayHealthQuestionnaire, $(this).attr("name"), getRadioButtonGeneral($(this).attr("name")));

                stringRadioButtonName = $(this).attr("name");
				// previewArrayObject(arrayHealthQuestionnaire);
            });
        }
		/* else if ($(this).data("popup-type") == stringPopUpTypeCardiac)
        {
            $("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
				stringInfixName = releasePrefix($(this).attr("name"));
				
                if ($(this).val() == "true")
                {
                    $(stringKres + $(this).data("popup-type")).css("display", "block");
                }
                else
                {
					
                }

				arrayAdd(arrayHealthQuestionnaire, $(this).attr("name"), getRadioButtonGeneral($(this).attr("name")));
                stringRadioButtonName = $(this).attr("name");
            });
        } */
		else if ($(this).data("custom-radiobutton") == "input")
		{
			$("input:radio[name='" + $(this).attr("name") + "']").change(function()
            {
				arrayAdd(arrayHealthQuestionnaire, $(this).attr("name"), getRadioButtonGeneral($(this).attr("name")));
                stringRadioButtonName = $(this).attr("name");
				// previewArrayObject(arrayHealthQuestionnaire);
            });
		}
        else
        {
            
        }
    });
}

function setHardCode(arrayContent, stringKey, stringValue)
{
	if (stringValue == null || stringValue == undefined || stringValue == "")
	{
		
	}
	else
	{
		arrayAdd(arrayContent, stringKey, stringValue);
	}
}


// ARRAY ACTION

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

function arrayOptionFind(arrayObject, stringKey)
{
    var stringValue = null;
    
    for (var i = 0; i < arrayObject.length; i++)
    {
        if (arrayObject[i].value === stringKey) 
        {
            stringValue = arrayObject[i].text;
            break;
        }
        else
        {
            
        }
    }
    
    return stringValue;
}

function arrayTransfer(arrayTemporary, arrayContent)
{
	for (var i = 0; i < arrayTemporary.length; i++)
	{
		arrayAdd(arrayContent, arrayTemporary[i].elementID, arrayTemporary[i].Value);
	}
}

// POP UP SETTER

function textPopUpSetter(stringPopUpJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{
	var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
	
	$(stringPopUpJQueryID + " input:text").each(function()
    {
        var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		$(stringInputJQueryID).val("");
		
        var stringInputNameWithoutPrefix = releasePrefix(stringInputJavaScriptID);
        var stringKey = getPrefix(stringInputJavaScriptID) + stringParentNameWithoutPrefix + stringInputNameWithoutPrefix;
        var stringValue = arrayFind(arrayContent, stringKey);
        
        if (stringValue == null || stringValue == undefined)
        {
            
        }
        else
        {
            setTextForm(stringInputJavaScriptID, stringValue);
        }
    });
}

function textPopUpGetter(stringPopUpJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{
	var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
	
	$(stringPopUpJQueryID + " form input[type=text]").each(function()
	{
		var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		$(stringInputJQueryID).val("");
		
		var stringInputNameWithoutPrefix = releasePrefix(stringInputJavaScriptID);
        var stringKey = getPrefix(stringInputJavaScriptID) + stringParentNameWithoutPrefix + stringInputNameWithoutPrefix;
        var stringValue = arrayFind(arrayContent, stringKey);
		
		if (validateTextGeneral(stringInputJQueryID) == true)
		{
			arrayAdd(arrayContent, stringKey, stringValue);
		}
		else
		{
			validationMessage("Harap lengkapi form terlebih dahulu !.", null);
		}
	});
}

// POP UP SETTER

function areaPopUpSetter(stringPopUpJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{
	var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
	
	$(stringPopUpJQueryID + " textarea").each(function()
    {
        var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		$(stringInputJQueryID).val("");
		
        var stringInputNameWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);
        var stringKey = stringPrefixArea + stringParentNameWithoutPrefix + stringInputNameWithoutPrefix;
        var stringValue = arrayFind(arrayContent, stringKey);
        
        if (stringValue == null || stringValue == undefined)
        {
            
        }
        else
        {
            setTextForm(stringInputJavaScriptID, stringValue);
        }
    });
}

function areaPopUpGetter(stringPopUpJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{
	var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
	
	$(stringPopUpJQueryID + " form textarea").each(function()
	{
		var stringInputJavaScriptID = $(this).attr("id");
		var stringInputJQueryID = stringKres + stringInputJavaScriptID;
		$(stringInputJQueryID).val("");
		
		var stringInputNameWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);
        var stringKey = stringPrefixArea + stringParentNameWithoutPrefix + stringInputNameWithoutPrefix;
        var stringValue = arrayFind(arrayContent, stringKey);
		
		if (validateTextGeneral(stringInputJQueryID) == true)
		{
			arrayAdd(arrayContent, stringKey, stringValue);
		}
		else
		{
			validationMessage("Harap lengkapi form terlebih dahulu !.", null);
		}
	});
}


function buttonPopUpGeneralGenerator()
{
    var stringRadioButtonKey;
    var stringRadioButtonValue;
    var stringDetailKey;
    var stringDetailValue;
    var stringPopUpJavaScriptID = "PopUpGeneral";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    var stringInputJavaScriptID = "AreaAmandmentDetail";
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
        
        setRadioButtonGeneral(stringRadioButtonKey, null);
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
        
        $(stringPopUpJQueryID).css("display", "none");
    });

    $(stringPopUpJQueryID + " #ButtonDone").click(function()
    {
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        stringDetailKey = stringPrefixArea + stringRadioButtonName.substring(stringPrefixRadioButton.length, stringRadioButtonName.length) + stringAmandmentSuffix + stringDetailSuffix;
        stringDetailValue = getTextGeneral(stringInputJavaScriptID);
        
        if (validateTextGeneral(stringInputJQueryID) == true)
        {
            arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
            arrayAdd(arrayHealthQuestionnaire, stringDetailKey, stringDetailValue);
            buttonPreviewGenerator(stringRadioButtonKey, true);

            $(stringPopUpJQueryID).css("display", "none");
            $(stringInputJQueryID).val("");
			// previewArrayObject(arrayHealthQuestionnaire);
        }
        else
        {
            validationMessage("Harap lengkapi form terlebih dahulu !.", null);
        }
    });
}

function previewArrayObject(arrayContent)
{
	var stringObjectPreview = "";

	for (var i = 0; i < arrayContent.length; i++)
	{
		stringObjectPreview += "key : " + arrayContent[i].elementID + "\nvalue : " + arrayContent[i].Value + "\n";
	}

	alert(stringObjectPreview);
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
        
        setRadioButtonGeneral(stringRadioButtonKey, null);
        arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
        
        $(stringPopUpJQueryID).css("display", "none");
    });

    $(stringPopUpJQueryID + " #ButtonDone").click(function()
    {
        stringRadioButtonKey = stringRadioButtonName;
        stringRadioButtonValue = getRadioButtonGeneral(stringRadioButtonName);
        stringInfixName = stringRadioButtonKey.substring(stringPrefixRadioButton.length, stringRadioButtonKey.length);
        stateValidation = true;
		
        $(stringPopUpJQueryID + " form input[type=text]").each(function()
        {
            stringInputJavaScriptID = $(this).attr("id");
            stringInputJQueryID = stringKres + stringInputJavaScriptID;
            stringDetailKey = getPrefix(stringInputJavaScriptID) + stringInfixName + stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);

            if (validateTextGeneral(stringInputJQueryID) == false)
            {
				validationMessage("Harap lengkapi form terlebih dahulu !.", null);
				return false;
            }
            else
            {
				stringDetailValue = getTextGeneral(stringInputJavaScriptID);
                arrayAdd(arrayHealthQuestionnaire, stringDetailKey, stringDetailValue);
                buttonPreviewGenerator(stringRadioButtonKey, true);
            }
        });

		if (stateValidation == false)
		{
			
		}
		else
		{
			arrayAdd(arrayHealthQuestionnaire, stringRadioButtonKey, stringRadioButtonValue);
			$(stringPopUpJQueryID).css("display", "none");

			$(stringPopUpJQueryID + " form input[type=text]").each(function()
			{
				$(this).val("");
			});
		}
        
        // previewArrayObject(arrayHealthQuestionnaire);
    });
}

function buttonViewBeneficiariesList(stringButtonViewJavaScriptID, stringButtonViewName)
{
	intBeneficiariesListRecentID = stringButtonViewName;
	popUpBeneficiariesListShow(stringButtonViewName);
}

function buttonViewSPAJProposal(stringButtonViewJavaScriptID, stringButtonViewName)
{
	intSPAJProposalRecentID = stringButtonViewName;
	popUpSPAJProposalShow(stringButtonViewName, "PopUpSPAJProposal", arrayHealthQuestionnaire);
}

function buttonDeleteBeneficiariesList(stringButtonViewJavaScriptID, stringButtonViewName)
{
	var stringButtonViewJQueryID = stringKres + stringButtonViewJavaScriptID;
	var arrayTemporary = [];

	for (var i = 0; i < arrayBeneficiariesList.length; i++)
	{
		var stringKeyForDelete = arrayBeneficiariesList[i].elementID.substring(arrayBeneficiariesList[i].elementID.length - stringButtonViewName.length, arrayBeneficiariesList[i].elementID.length);

		if (stringKeyForDelete == stringButtonViewName)
		{
			arrayAdd(arrayTemporary, arrayBeneficiariesList[i].elementID,arrayBeneficiariesList[i].Value );
		}
		else
		{

		}
	}
	
	for (var i = 0; i < arrayTemporary.length; i++)
	{
		arrayDelete(arrayBeneficiariesList, arrayTemporary[i].elementID);
	}

	var stringSharePercentagePrefix  = stringPrefixText + stringBeneficiariesListInfix + stringSharePercentageSuffix;
	var intSharePercentageTemporary = 0;
	var stringSharePercentageFilter;
	var arraySharePercentageTemporary = [];

	for (var k = 0; k < arrayBeneficiariesList.length; k++)
	{
		stringSharePercentageFilter = arrayBeneficiariesList[k].elementID.substring(0, stringSharePercentagePrefix.length);

		if (stringSharePercentageFilter == stringSharePercentagePrefix)
		{
			arrayAdd(arraySharePercentageTemporary, arrayBeneficiariesList[k].elementID, arrayBeneficiariesList[k].Value);
		}
		else
		{

		}
	}

	// previewArrayObject(arrayBeneficiariesList);
	
	for (var l = 0; l < arraySharePercentageTemporary.length; l++)
	{
		intSharePercentageTemporary += parseInt(arraySharePercentageTemporary[l].Value, 10);
	}

	intSharePercentage = parseInt(intSharePercentageTemporary, 10);
	setTextForm(stringPrefixText + stringBeneficiariesListInfix + stringSharePercentageSuffix, intSharePercentage);

	tableBeneficiariesListGenerator("TableBeneficiariesList", arrayBeneficiariesList);
}

function buttonDeleteSPAJProposal(stringButtonViewJavaScriptID, stringButtonViewName)
{
	var stringButtonViewJQueryID = stringKres + stringButtonViewJavaScriptID;
	var arrayTemporary = [];
	var stringKey;
	var stringValue;
	var stringKeyWithoutPrefix;
	var stringKeyWithoutInfix;
	var stringKeySuffix;
	var stringKeyForDelete;
	var stringKeyInfix;

	for (var i = 0; i < arrayHealthQuestionnaire.length; i++)
	{
		stringKey = arrayHealthQuestionnaire[i].elementID;
		stringValue = arrayHealthQuestionnaire[i].Value;
		stringKeyWithoutPrefix = releasePrefix(stringKey);
		stringKeyInfix = getInfix(stringKeyWithoutPrefix);
		stringKeyWithoutInfix = releaseInfix(stringKeyWithoutPrefix);
		stringKeySuffix = stringKeyWithoutInfix.substring(stringSPAJProposalInfix.length, stringKeyWithoutInfix.length - stringButtonViewName.length);

		if (stringKeyInfix == stringPageInfixTypeCurrent)
		{
			for (var j = 0; j < arraySPAJProposalTableHeader.length; j++)
			{
				if (stringKeySuffix == arraySPAJProposalTableHeader[j])
				{
					stringKeyForDelete = stringKeyWithoutInfix.substring(stringKeyWithoutInfix.length - stringButtonViewName.length, stringKeyWithoutInfix.length);

					if (stringKeyForDelete == stringButtonViewName)
					{
						arrayAdd(arrayTemporary, stringKey);
					}
					else
					{

					}
				}
				else
				{

				}
			}
		}
		else
		{

		}
	}

	for (var i = 0; i < arrayTemporary.length; i++)
	{
		arrayDelete(arrayHealthQuestionnaire, arrayTemporary[i].elementID);
	}
	
	previewArrayObject(arrayHealthQuestionnaire);

	tableSPAJProposalGenerator("SPAJProposalList", arrayHealthQuestionnaire);
}

function getLastID(arrayContent, stringKeyFilter)
{
	var stringFilter;
	var stringKey;
	var stringKeyWithoutPrefix;
	var intTemporaryID = 0;
	var intKeyID;
	
	for (var i = 0; i < arrayContent.length; i++)
	{
		stringFilter = arrayContent[i].elementID.substring(0, stringKeyFilter.length);
		
		if (stringKeyFilter == stringFilter)
		{
			stringKey = arrayContent[i].elementID;
			intKeyID = stringKey.substring(stringKeyFilter.length, stringKey.length);
			
			if (intTemporaryID < intKeyID)
			{
				intTemporaryID = intKeyID;
			}
			else
			{
				
			}
		}
		else
		{
			
		}
	}
	
	return intTemporaryID;
}

function buttonPopUpBeneficiariesListGenerator()
{
    var stringKey;
    var stringValue;
    var stringPopUpJavaScriptID = "PopUpBeneficiariesList";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    var stringInputJavaScriptID;
    var stringInputJQueryID;
	var stringInputIDWithoutPrefix;
	
    $(stringPopUpJQueryID + " #ButtonCancel").click(function()
    {
        $(stringPopUpJQueryID).css("display", "none");
    });

    $(stringPopUpJQueryID + " #ButtonDone").click(function()
    {
		if (intBeneficiariesListID < 11 && intSharePercentage <= 100)
		{
			var stringSharePercentageJavaScriptID = stringPrefixText + stringSharePercentageSuffix;
			var stringSharePercentageJQueryID = stringKres + stringSharePercentageJavaScriptID;
			var intCurrentSharePercentage;
			var intID;
			var arrayInputTemporary = [];
			
			intBeneficiariesListID = getLastID(arrayBeneficiariesList, stringPrefixText + stringBeneficiariesListInfix + arrayBeneficiariesListPopUpHeader[0]);
			
			if (intBeneficiariesListRecentID == null)
			{
				intID = parseInt(intBeneficiariesListID, 10) + parseInt(1, 10);
			}
			else
			{
				intID = intBeneficiariesListRecentID;
			}
			
			if (validateTextGeneral(stringSharePercentageJQueryID) == true)
			{
				if (intBeneficiariesListRecentID == null)
				{
					intCurrentSharePercentage = parseInt(intSharePercentage, 10) + parseInt(getTextForm(stringSharePercentageJavaScriptID), 10);
				}
				else
				{
					intCurrentSharePercentage = parseInt(intSharePercentage, 10) + parseInt(getTextForm(stringSharePercentageJavaScriptID), 10) - parseInt(arrayFind(arrayBeneficiariesList, stringPrefixText + stringBeneficiariesListInfix + stringSharePercentageSuffix + intBeneficiariesListRecentID), 10);
				}
				
				if (intCurrentSharePercentage <= 100)
				{
					stateValidation = true;
					
					if (stateValidation == false)
					{
						
					}
					else
					{
						$(stringPopUpJQueryID + " form input[type=text]").each(function()
						{
							stringInputJavaScriptID = $(this).attr("id");
							stringInputJQueryID = stringKres + stringInputJavaScriptID;

							if (stringInputJavaScriptID.substring(0, stringPrefixDate.length) == stringPrefixDate)
							{
								stringInputIDWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixDate.length, stringInputJavaScriptID.length);
								stringKey = stringPrefixDate + stringBeneficiariesListInfix + stringInputIDWithoutPrefix + intID;
							}
							else
							{
								stringInputIDWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);
								stringKey = stringPrefixText + stringBeneficiariesListInfix + stringInputIDWithoutPrefix + intID;
							}

							if (validateTextGeneral(stringInputJQueryID) == false)
							{
								validationMessage("Harap lengkapi form terlebih dahulu !.", null);
								return false;
							}
							else
							{
								stringValue = getTextGeneral(stringInputJavaScriptID);
								arrayAdd(arrayInputTemporary, stringKey, stringValue);
							}
						});
					}
					
					if (stateValidation == false)
					{
						
					}
					else
					{
						$(stringPopUpJQueryID + " form select").each(function()
						{
							stringInputJavaScriptID = $(this).attr("id");
							stringInputJQueryID = stringKres + stringInputJavaScriptID;
							stringInputIDWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixSelect.length, stringInputJavaScriptID.length);

							stringKey = stringPrefixSelect + stringBeneficiariesListInfix + stringInputIDWithoutPrefix + intID;

							if (validateSelectGeneral(stringInputJQueryID) == false)
							{
								validationMessage("Harap lengkapi form terlebih dahulu !.", null);
								return false;
							}
							else
							{
								stringValue = getSelectForm(stringInputJavaScriptID);
								arrayAdd(arrayInputTemporary, stringKey, stringValue);
							}
						});
					}
					
					if (stateValidation == false)
					{
						
					}
					else
					{
						var stringRadioButtonFlag = 0;
					
						$(stringPopUpJQueryID + " form input:radio").each(function()
						{
							stringInputName = $(this).attr("name");
							stringInputJavaScriptID = $(this).attr("id");
							stringInputJQueryID = stringKres + stringInputJavaScriptID;
							stringInputNameWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixRadioButton.length, stringInputName.length);

							stringKey = stringPrefixRadioButton + stringBeneficiariesListInfix + stringInputNameWithoutPrefix + intID;

							if (stringRadioButtonFlag != stringInputName)
							{
								if (validateRadioButtonGeneral(stringInputName) == false)
								{
									validationMessage("Harap lengkapi form terlebih dahulu !.", null);
									return false;
								}
								else
								{
									stringValue = getRadioButtonGeneral(stringInputName);
									arrayAdd(arrayInputTemporary, stringKey, stringValue);
									stringRadioButtonFlag = stringInputName;
								}
							}
							else
							{

							}
						});
					}
					
					if (stateValidation == false)
					{
						
					}
					else
					{
						arrayTransfer(arrayInputTemporary, arrayBeneficiariesList);
						// intBeneficiariesListID ++;
						// intBeneficiariesListRecentID = 0;
						
						var stringSharePercentagePrefix  = stringPrefixText + stringBeneficiariesListInfix + stringSharePercentageSuffix;
						var intSharePercentageTemporary = 0;
						var stringSharePercentageFilter;
						var arraySharePercentageTemporary = [];
						
						for (var k = 0; k < arrayBeneficiariesList.length; k++)
						{
							stringSharePercentageFilter = arrayBeneficiariesList[k].elementID.substring(0, stringSharePercentagePrefix.length);
							
							if (stringSharePercentageFilter == stringSharePercentagePrefix)
							{
								arrayAdd(arraySharePercentageTemporary, arrayBeneficiariesList[k].elementID, arrayBeneficiariesList[k].Value);
							}
							else
							{
								
							}
						}
						
						for (var l = 0; l < arraySharePercentageTemporary.length; l++)
						{
							intSharePercentageTemporary += parseInt(arraySharePercentageTemporary[l].Value, 10);
						}
						
						intSharePercentage = parseInt(intSharePercentageTemporary, 10);
						setTextForm(stringPrefixText + stringBeneficiariesListInfix + stringSharePercentageSuffix, intSharePercentage);

						$(stringPopUpJQueryID).css("display", "none");

						$(stringPopUpJQueryID + " form input[type=text]").each(function()
						{
							$(this).val("");
						});

						$(stringPopUpJQueryID + " form select").each(function()
						{
							$(stringKres + $(this).attr("id") + " :nth-child(1)").prop("selected", true);
						});

						$(stringPopUpJQueryID + " form input:radio").each(function()
						{
							$(this).prop("checked", false);
						});

						tableBeneficiariesListGenerator("TableBeneficiariesList", arrayBeneficiariesList);
						// previewArrayObject(arrayBeneficiariesList);
					}
				}
				else
				{
					ReplaceHTMLNameOnValidate("","Share percentage melebihi 100 persen !.");
					//alert("Share percentage melebihi 100 persen !.");
				}
			}
			else
			{
				validationMessage("Harap lengkapi form terlebih dahulu !.", null);
				return false;
			}
		}
		else
		{
			
		}
		
		intBeneficiariesListRecentID = null;
    });
}

function buttonPopUpSPAJProposalGenerator()
{
    var stringKey;
    var stringValue;
    var stringPopUpJavaScriptID = "PopUpSPAJProposal";
    var stringPopUpJQueryID = stringKres + stringPopUpJavaScriptID;
    var stringInputJavaScriptID;
    var stringInputJQueryID;
	var stringInputSuffix;
	var stringTriggerInfix;
	
    $(stringPopUpJQueryID + " #ButtonCancel").click(function()
    {
        $(stringPopUpJQueryID).css("display", "none");
    });

    $(stringPopUpJQueryID + " #ButtonDone").click(function()
    {
		var intID;
		var arrayInputTemporary = [];
		stringTriggerInfix = stringPageInfixTypeCurrent + stringSPAJProposalInfix;

		intSPAJProposalID = getLastID(arrayHealthQuestionnaire, stringPrefixText + stringTriggerInfix + arraySPAJProposalTableHeader[0]);
		
		if (intSPAJProposalRecentID == null)
		{
			intID = parseInt(intSPAJProposalID, 10) + parseInt(1, 10);
		}
		else
		{
			intID = intSPAJProposalRecentID;
		}
		
		stateValidation = true;
		
		$(stringPopUpJQueryID + " form input[type=text]").each(function()
		{
			stringInputJavaScriptID = $(this).attr("id");
			stringInputJQueryID = stringKres + stringInputJavaScriptID;
			stringInputSuffix = releasePrefix(stringInputJavaScriptID);
        	stringKey = setKeyPrefix(stringInputJavaScriptID, stringTriggerInfix + stringInputSuffix + intID);
			
			if (validateTextGeneral(stringInputJQueryID) == false)
			{
				validationMessage("Harap lengkapi form terlebih dahulu !.", null);
				return false;
			}
			else
			{
				stringValue = getTextGeneral(stringInputJavaScriptID);
				arrayAdd(arrayInputTemporary, stringKey, stringValue);
				alert(stringKey + " " + stringValue);
			}
		});
		
		if (stateValidation == false)
		{
			
		}
		else
		{
			var stringRadioButtonSPAJProposal = stringPrefixRadioButton + stringPageInfixTypeCurrent + stringSPAJProposalInfix;

			arrayAdd(arrayHealthQuestionnaire, stringRadioButtonSPAJProposal, getRadioButtonGeneral(stringRadioButtonSPAJProposal));
			arrayTransfer(arrayInputTemporary, arrayHealthQuestionnaire);
			
			$(stringPopUpJQueryID).css("display", "none");
			// $("#ButtonAddSPAJProposal").css("display", "block");
			intSPAJProposalRecentID = null;

			$(stringPopUpJQueryID + " form input[type=text]").each(function()
			{
				$(this).val("");
			});

			tableSPAJProposalGenerator("SPAJProposalList", arrayHealthQuestionnaire);
			previewArrayObject(arrayHealthQuestionnaire);
		}
    });
}

function tableBeneficiariesListGenerator(stringTableJavaScriptID, arrayContent)
{
	var stringTableJQueryID = stringKres + stringTableJavaScriptID;
	var stringContentName;
	var stringContentBirthday;
	var stringContentRelation;
	var stringNameIDSuffix = arrayBeneficiariesListPopUpHeader[0];
	var stringBirthdayIDSuffix = arrayBeneficiariesListPopUpHeader[2];
	var stringRelationshipIDSuffix = arrayBeneficiariesListPopUpHeader[4];
	var stringKeyName = stringPrefixText + stringBeneficiariesListInfix + stringNameIDSuffix;
	var stringKeyBirthday = stringPrefixDate + stringBeneficiariesListInfix + stringBirthdayIDSuffix;
	var stringKeyRelationship = stringPrefixSelect + stringBeneficiariesListInfix + stringRelationshipIDSuffix;
	var stringKeyID;
	var stringFlag = 0;
	
	$(stringTableJQueryID + " tbody").empty();
	
	for (var i = 0; i < arrayContent.length; i++)
	{
		stringKeyID = arrayContent[i].elementID.substring(stringKeyName.length, arrayContent[i].elementID.length);
		stringKeyName = stringPrefixText + stringBeneficiariesListInfix + stringNameIDSuffix + stringKeyID;
		stringKeyBirthday = stringPrefixDate + stringBeneficiariesListInfix + stringBirthdayIDSuffix + stringKeyID;
		stringKeyRelationship = stringPrefixSelect + stringBeneficiariesListInfix + stringRelationshipIDSuffix + stringKeyID;
		stringContentName = arrayFind(arrayContent, stringKeyName);
		stringContentBirthday = arrayFind(arrayContent, stringKeyBirthday);
		stringContentRelationship = arrayFind(arrayContent, stringKeyRelationship);
		stringContentRelationship = arrayOptionFind(arrayRelationshipWithProspectiveInsured, stringContentRelationship);

		if (stringFlag == 0 || stringFlag != stringKeyID)
		{
			if (stringContentName == null || stringContentName == undefined)
			{

			}
			else
			{
				$(stringTableJQueryID + " tbody").append
				(
					"<tr>" + 
						"<td>" + stringContentName + "</td>" + 
						"<td>" + stringContentBirthday + "</td>" + 
						"<td>" + stringContentRelationship + "</td>" + 
						"<td><input type='button' id='" + stringButtonViewPrefix + stringKeyID + "' class='ButtonPrimary ButtonView' value='View' name='" + stringKeyID + "' onclick='buttonViewBeneficiariesList(this.id, this.name)'/></td>" + 
						"<td><input type='button' id='" + stringButtonDeletePrefix + stringKeyID + "' class='ButtonPrimary ButtonDelete' value='Delete' name='" + stringKeyID + "' onclick='buttonDeleteBeneficiariesList(this.id, this.name)'/></td>" + 
					"</tr>"
				);
				
				stringFlag = stringKeyID;
			}
		}
		else
		{
			
		}
	}
}

function initiateArrayRelationshipWithProspectiveInsured(objectContent)
{
	objectContent.push({ value: stringStateNotSelected, text: "Please Select" });
	objectContent.push({ value: "self", text: "Diri Sendiri" });
	objectContent.push({ value: "parent", text: "Orang Tua" });
	objectContent.push({ value: "child", text: "Anak" });
	objectContent.push({ value: "spouse", text: "Pasangan" });
	objectContent.push({ value: "brother", text: "Saudara Laki-Laki" });
	objectContent.push({ value: "sister", text: "Saudara Perempuan" });
	objectContent.push({ value: "grandparent", text: "Kakek / Nenek" });
	objectContent.push({ value: "grandchildren", text: "Cucu" });
	objectContent.push({ value: "aunt", text: "Bibi" });
	objectContent.push({ value: "uncle", text: "Paman" });
	objectContent.push({ value: "nephew", text: "Keponakan Laki-Laki" });
	objectContent.push({ value: "niece", text: "Keponakan Perempuan" });
	objectContent.push({ value: "employee", text: "Pekerja" });
	objectContent.push({ value: "employer", text: "Pemberi Kerja" });
	objectContent.push({ value: "other", text: "Lainnya" });
	objectContent.push({ value: "heir", text: "Ahli Waris" });
	objectContent.push({ value: "guardian", text: "Wali" });
	objectContent.push({ value: "creditordebitor", text: "Kreditor / Debitor" });
	objectContent.push({ value: "charity", text: "Amal" });
	objectContent.push({ value: "heirlaw", text: "Ahli Waris Hukum" });
}

function generateSelectOption(stringSelectJavaScriptID, arrayOption)
{
	var stringSelectJQueryID = stringKres + stringSelectJavaScriptID;
	
	for (var i = 0; i < arrayOption.length; i++)
	{
		$(stringSelectJQueryID).append("<option value='" + arrayOption[i].value + "'>" + arrayOption[i].text + "</option>");
	}
}

function tableSPAJProposalGenerator(stringContainerJavaScriptID, arrayContent)
{
	var stringContainerJQueryID = stringKres + stringContainerJavaScriptID;
	var stringInputIDSuffix = arraySPAJProposalTableHeader[0];
	var stringKeyID;
	var stringKey;
	var stringValue;
	var stringFlag = 0;
	var stringKeyWithoutPrefix;
	var stringKeyWithoutInfix;
	var stringKeySuffix;
	var stringKeyInfix;
	
	$(stringContainerJQueryID).empty();
	
	for (var i = 0; i < arrayContent.length; i++)
	{
		stringKey = arrayContent[i].elementID;
		stringValue = arrayContent[i].Value;
		stringKeyWithoutPrefix = releasePrefix(stringKey);
		stringKeyWithoutInfix = releaseInfix(stringKeyWithoutPrefix);
		stringKeyInfix = getInfix(stringKeyWithoutPrefix);
		stringKeySuffix = stringKeyWithoutInfix.substring(stringSPAJProposalInfix.length, stringSPAJProposalInfix.length + stringInputIDSuffix.length);
		
		if (stringKeyInfix == stringPageInfixTypeCurrent)
		{
			if (stringKeySuffix == stringInputIDSuffix)
			{
				stringKeyID = stringKeyWithoutInfix.substring(stringSPAJProposalInfix.length + stringInputIDSuffix.length, stringKeyWithoutInfix.length);
				$(stringContainerJQueryID).append
				(
					"<div style='display: block; margin-bottom: -15px;'>" + 
					"<input type='button' id='" + "ButtonPreview" + stringKeyID + "' class='ButtonView PositionerLeft' style='min-width: 200px; text-align: left;' value='View " + stringValue + "' name='" + stringKeyID + "' onclick='buttonViewSPAJProposal(this.id, this.name)'/>" + 
					"<input type='button' id='" + "ButtonDelete" + stringKeyID + "' class='ButtonDelete PositionerLeft' value='Delete' name='" + stringKeyID + "' onclick='buttonDeleteSPAJProposal(this.id, this.name)'/><br/>" + 
					"</div><br>"
				);
			}
			else
			{

			}
		}
		else
		{

		}
	}
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
    	stateValidation = false;
    }
}

function validationMessage(stringMessageNegative, stringMessagePositive)
{
    if (stateValidation == false)
    {
		ReplaceHTMLNameOnValidate("", stringMessageNegative);
        //alert(stringMessageNegative);
    }
    else
    {
        if (stringMessageNegative == null)
        {

        }
        else
        {
			ReplaceHTMLNameOnValidate("", stringMessagePositive);
            //alert(stringMessagePositive)
        }
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

function arrayValidatePush(objectContent, stringKey, stringValue)
{
    if (stringValue == undefined || stringValue == "" || stringValue === null)
    {
        
    }
    else
    {
        arrayAdd(objectContent, stringKey, stringValue);
    }
}

function validateTextGeneral(stringInputJQueryID)
{
	var stringInputValue = $(stringInputJQueryID).val();
	
	if (stringInputValue == undefined || stringInputValue == null || stringInputValue == "")
    {
        validateState(false);
        return false;
    }
    else
    {
		if (stringInputValue.length > 0)
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

function validateSpecificRadioButtonGeneral(stringLayoutJavaScriptID, radioButtonName)
{
	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	var stringValue = $(stringLayoutJQueryID + " input:radio[name=" + radioButtonName + "]:checked").val();
	
    if (stringValue == undefined || stringValue == null || stringValue == "")
    {
        validateState(false);
        return false;
    }
    else
    {
		validateState(true);
        return true;
    }
}

/* function validateCheckboxGeneral(stringInputJQueryID)
{
    if ($(stringInputJQueryID).val() != undefined)
    {
        validateState(true);
        return true;
    }
    else
    {
        validateState(false);
        return false;
    }
} */

function validateSelectGeneral(stringInputJQueryID)
{
	var stringInputValue = $(stringInputJQueryID).val();
	
    if (stringInputValue == "null")
    {
        validateState(false);
        return false;
    }
    else
    {
		validateState(true);
        return true;
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
    if (stringValue != null)
	{
		var radioButton = $("input:radio[name=" + stringName + "]");
    	radioButton.filter("[value='" + stringValue + "']").prop("checked", true);
	}
	else
	{
		$("input:radio[name='" + stringName + "']").each(function()
		{
			$(this).prop("checked", false);
		});
	}
}

function setSpecificRadioButtonGeneral(stringLayoutJavaScriptID, stringName, stringValue)
{
	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	
    if (stringValue != null)
	{
		var radioButton = $(stringLayoutJQueryID + " input:radio[name=" + stringName + "]");
    	radioButton.filter("[value='" + stringValue + "']").prop("checked", true);
	}
	else
	{
		$("input:radio[name='" + stringName + "']").each(function()
		{
			$(this).prop("checked", false);
		});
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

function setCheckboxGeneral(stringCheckboxJavaScriptID, stringValue)
{
	var stringCheckboxJQueryID = stringKres + stringCheckboxJavaScriptID;
	
	if (stringValue == stringStateNotChecked)
	{
		$(stringCheckboxJQueryID).prop("checked", false);
	}
	else
	{
		$(stringCheckboxJQueryID + "[value='" + stringValue + "']").prop("checked", true);
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
		var stringHandphoneSuffixID = stringID.substring(stringID.length - stringHandphoneSuffix.length - 1, stringID.length - 1);
		
		if (stringHandphoneSuffixID != stringHandphoneSuffix)
		{
			var arrayTelephoneString = stringValue.split(stringSeparatorTelephone);
			var arrayTelephoneID = [stringIDPrefix, stringIDInfix];
			var booleanPrefix = $.isNumeric(arrayTelephoneString[0].substring(arrayTelephoneString[0].length - 1, arrayTelephoneString[0]));
			var booleanSuffix = $.isNumeric(arrayTelephoneString[1].substring(0, 1));
			
			if (booleanPrefix == true && booleanSuffix == true)
			{
				for(var i = 0; i < arrayTelephoneString.length; i++)
				{
					setBoxGeneral(stringID + arrayTelephoneID[i], arrayTelephoneString[i]);
				}
			}
			else
			{
				setBoxGeneral(stringID, stringValue);
			}
		}
		else
		{
			setBoxGeneral(stringID, stringValue);
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
		else if ($(stringJQueryID).is("input[type='text']") == true)
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
		if ($(stringKres + stringID + arrayDateID[i]).is("table") == true)
		{
			setBoxGeneral(stringID + arrayDateID[i], arrayDateString[i]);	
		}
		else
		{
			setLineGeneral(stringID + arrayDateID[i], arrayDateString[i]);	
		}			
	}			
}

function setAreaForm(stringID, stringValue)
{
    setTextGeneral(stringID, stringValue);
}

function setAreaPDF(stringID, stringValue)
{
	var stringJQueryID = stringKres + stringID;
        
	if ($(stringJQueryID).is("div") == true)
	{
		setLineGeneral(stringID, stringValue);
	}
	else if ($(stringJQueryID).is("input[type='text']") == true)
	{
		setTextGeneral(stringID, stringValue);
	}
	else if ($(stringJQueryID).is("textarea") == true)
	{
		setTextGeneral(stringID, stringValue);
	}
	else
	{
		setBoxGeneral(stringID, stringValue);
	}
}

function setNumberForm(stringID, stringValue)
{
    setTextGeneral(stringID, stringValue);
}

function setNumberPDF(stringID, stringValue)
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
	else if ($(stringJQueryID).is("input[type='number']") == true)
	{
		setTextGeneral(stringID, stringValue);
	}
	else
	{
		setBoxGeneral(stringID, stringValue);
	}
}

function setEmailForm(stringID, stringValue)
{
    setTextGeneral(stringID, stringValue);
}

function setEmailPDF(stringID, stringValue)
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
	else if ($(stringJQueryID).is("input[type='email']") == true)
	{
		setTextGeneral(stringID, stringValue);
	}
	else
	{
		setBoxGeneral(stringID, stringValue);
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

function getRadioButtonGeneral(stringName)
{
    var stringRadioButtonValue;
    
    stringRadioButtonValue = $("input:radio[name=" + stringName + "]:checked").val();
    
    return stringRadioButtonValue;
}

function getSpecificRadioButtonGeneral(stringLayoutJavaScriptID, stringName)
{
    var stringRadioButtonValue;
    
    stringRadioButtonValue = $(stringLayoutJavaScriptID + " input:radio[name=" + stringName + "]:checked").val();
    
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

function getCheckboxGeneral(stringID)
{
	var stringInputJQueryID = stringKres + stringID;
    var stringCheckboxValue;
    
    if ($(stringInputJQueryID).is(":checked") == true)
    {
		stringCheckboxValue = $(stringInputJQueryID).val();
	}
    else
    {
        stringCheckboxValue = stringStateNotChecked;
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
    return getTextGeneral(stringID);
}

function getAreaPDF(stringID)
{
    return getBoxGeneral(stringID);
}

function getNumberForm(stringID)
{
    return getTextGeneral(stringID);
}

function getNumberPDF(stringID)
{
    return getBoxGeneral(stringID);
}

function getEmailForm(stringID)
{
    return getTextGeneral(stringID);
}

function getEmailPDF(stringID)
{
    return getBoxGeneral(stringID);
}


// TABLE FUNCTION

function numberGenerator(stringNameInfix, indexRow)
{
	var stringCellNumberJQueryID = stringKres + stringCellPrefix + stringNameInfix + stringNumberPrefix + indexRow;
										
	if ($(stringCellNumberJQueryID).text() == "" || $(stringCellNumberJQueryID).text() == undefined || $(stringCellNumberJQueryID).text() == null)
	{
		$(stringCellNumberJQueryID).append(indexRow + 1);
	}
	else
	{

	}
}


// GET FROM DATABASE

function getFromDatabase(objectContent, stringPageType)
{
    for (var i = 0; i < objectContent.length; i++)
    {        
        var stringKey = objectContent[i].elementID;
        var stringValue = objectContent[i].Value;               
        
		// GENERAL INPUT TYPE
		
        if (stringKey.substring(0, stringPrefixText.length) == stringPrefixText)
        {
			if (stringPageType == stringPageTypePDF)
			{
				// FOR TABLE HEALTH
				
				for (var j = 0; j < arrayHealthTableHeader.length; j++)
				{
					if (stringKey.substring(stringKey.length - arrayHealthTableHeader[j].length, stringKey.length) == arrayHealthTableHeader[j])
					{
						var stringIndicatorPrefix = stringKey.substring(stringPrefixText.length, stringPrefixText.length + 3);
						var stringTableJQueryID;
						var stringInfix;

						if (stringIndicatorPrefix == stringIndicatorPolicyHolder)
						{
							stringTableJQueryID = stringKres + stringTablePrefix + stringPolicyHolderPrefix + stringIllnessSuffix;
							stringInfix = stringPolicyHolderPrefix;
						}
						else
						{
							stringTableJQueryID = stringKres + stringTablePrefix + stringProspectiveInsuredPrefix + stringIllnessSuffix;
							stringInfix = stringProspectiveInsuredPrefix;
						}

						$(stringTableJQueryID + " tbody tr").each(function(indexRow)
						{
							var stringRowJavaScriptID = $(this).attr("id");
							var stringRowJQueryID = stringKres + stringRowJavaScriptID;
							var stringCellJavaScriptID = stringCellPrefix + stringInfix + stringIllnessSuffix + arrayHealthTableHeader[j];
							var stringCellJQueryID = stringKres + stringCellJavaScriptID + indexRow;
							var stringCellSuffix = stringCellJavaScriptID;
							var booleanBreak = false;
							
							if (stringCellSuffix.substring(stringCellSuffix.length - arrayHealthTableHeader[j].length, stringCellSuffix.length) == arrayHealthTableHeader[j])
							{
								if (j == 1)
								{
									var stringDate = stringValue.split(stringSeparatorDate);
									var stringDay = stringDate[0];
									var stringMonth = stringDate[1];
									var stringYear = stringDate[2];
									stringDate = [stringMonth, stringYear.substring(2, 4)];

									$(stringCellJQueryID + " table").each(function(indexTable)
									{
										var stringBoxID = $(this).attr("id");
										var stringBoxValue = getBoxGeneral(stringBoxID);
										
										if (stringBoxValue == null || stringBoxValue == undefined || stringBoxValue == "")
										{
											setBoxGeneral(stringBoxID, stringDate[indexTable]);
											booleanBreak = true;
										}
										else
										{
											
										}
									});
									
									if (booleanBreak == true)
									{
										return false;
									}
									else
									{
										
									}
								}
								else
								{
									if ($(stringCellJQueryID).text() == "" || $(stringCellJQueryID).text() == undefined || $(stringCellJQueryID).text() == null)
									{
										$(stringCellJQueryID).append(stringValue);
										
										// FOR NUMBER
										
										numberGenerator(stringInfix + stringIllnessSuffix, indexRow);
										
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
						});
					}
					else
					{

					}
				}
				
				
				// BENEFICIARIES LIST
				
				var stringIDWithoutPrefix = stringKey.substring(stringPrefixText.length, stringKey.length);
				var stringIndicatorPrefix = stringIDWithoutPrefix.substring(0, 3);
				
				if (stringIndicatorPrefix == "Ben")
				{	
					var stringIDWithoutInfix = stringIDWithoutPrefix.substring(stringBeneficiariesListInfix.length, stringIDWithoutPrefix.length - 1);
					var stringTableJQueryID = stringKres + stringTablePrefix + stringBeneficiariesListInfix;
					
					for (var j = 0; j < arrayBeneficiariesListTableHeader.length; j++)
					{
						$(stringTableJQueryID + " tbody tr").each(function(indexRow)
						{
							var stringRowJavaScriptID = $(this).attr("id");
							var stringRowJQueryID = stringKres + stringRowJavaScriptID;
							var stringCellJavaScriptID = stringCellPrefix + stringBeneficiariesListInfix + arrayBeneficiariesListTableHeader[j];
							var stringCellJQueryID = stringKres + stringCellJavaScriptID + indexRow;
							var stringCellSuffix = stringCellJavaScriptID;
							
							if (stringIDWithoutInfix == arrayBeneficiariesListTableHeader[j])
							{
								if ($(stringCellJQueryID).text() == "" || $(stringCellJQueryID).text() == undefined || $(stringCellJQueryID).text() == null)
								{
									$(stringCellJQueryID).append(stringValue);

									// FOR NUMBER
										
									numberGenerator(stringBeneficiariesListInfix, indexRow);
									
									return false;
								}
								else
								{

								}
							}
							else
							{

							}
						});
					}
				}
				else
				{

				}
				
				// FOR TABLE SPAJ PROPOSAL
				
				var stringInfix;
				
				if (stringIndicatorPrefix == stringIndicatorPolicyHolder)
				{
					stringTableJQueryID = stringKres + "TablePolicyHolderSPAJProposal";
					stringInfix = stringPolicyHolderPrefix;
				}
				else
				{
					stringTableJQueryID = stringKres + "TableProspectiveInsuredSPAJProposal";
					stringInfix = stringProspectiveInsuredPrefix;
				}
				
				var stringIDWithoutInfix = stringIDWithoutPrefix.substring(stringInfix.length + stringSPAJProposalInfix.length, stringIDWithoutPrefix.length - 1);
				
				for (var j = 0; j < arraySPAJProposalTableHeader.length; j++)
				{
					$(stringTableJQueryID + " tbody tr").each(function(indexRow)
					{
						var stringRowJavaScriptID = $(this).attr("id");
						var stringRowJQueryID = stringKres + stringRowJavaScriptID;
						var stringCellJavaScriptID = stringCellPrefix + stringInfix + stringSPAJProposalInfix + arraySPAJProposalTableHeader[j];
						var stringCellJQueryID = stringKres + stringCellJavaScriptID + indexRow;
						var stringCellSuffix = stringCellJavaScriptID;
						
						if (stringIDWithoutInfix == arraySPAJProposalTableHeader[j])
						{
							if ($(stringCellJQueryID).text() == "" || $(stringCellJQueryID).text() == undefined || $(stringCellJQueryID).text() == null)
							{
								$(stringCellJQueryID).append(stringValue);

								// FOR NUMBER

								numberGenerator(stringInfix + stringSPAJProposalInfix, indexRow);

								return false;
							}
							else
							{

							}
						}
						else
						{

						}
					});
				}
				
				setTextPDF(stringKey, stringValue);        
			}
			else
			{
				setTextForm(stringKey, stringValue);
			}
        }
        else if (stringKey.substring(0, stringPrefixRadioButton.length) == stringPrefixRadioButton)
        {
			// BENEFICIARIES LIST
				
			var stringIDWithoutPrefix = stringKey.substring(stringPrefixRadioButton.length, stringKey.length);
			var stringIndicatorPrefix = stringIDWithoutPrefix.substring(0, 3);

			if (stringIndicatorPrefix == "Ben")
			{
				var stringIDWithoutInfix = stringIDWithoutPrefix.substring(stringBeneficiariesListInfix.length, stringIDWithoutPrefix.length - 1);
				var stringTableJQueryID = stringKres + stringTablePrefix + stringBeneficiariesListInfix;

				for (var j = 0; j < arrayBeneficiariesListTableHeader.length; j++)
				{
					$(stringTableJQueryID + " tbody tr").each(function(indexRow)
					{
						var stringRowJavaScriptID = $(this).attr("id");
						var stringRowJQueryID = stringKres + stringRowJavaScriptID;
						var stringCellJavaScriptID = stringCellPrefix + stringBeneficiariesListInfix + arrayBeneficiariesListTableHeader[j];
						var stringCellJQueryID = stringKres + stringCellJavaScriptID + indexRow;
						var stringCellSuffix = stringCellJavaScriptID;

						if (stringIDWithoutInfix == arrayBeneficiariesListTableHeader[j])
						{
							if ($(stringCellJQueryID).text() == "" || $(stringCellJQueryID).text() == undefined || $(stringCellJQueryID).text() == null)
							{
								if (j == 4)
								{
									if (stringValue == "female")
									{
										$(stringCellJQueryID).append("Wanita");
									}
									else
									{
										$(stringCellJQueryID).append("Pria");
									}
								}
								else
								{
									$(stringCellJQueryID).append(stringValue);
								}

								return false;
							}
							else
							{

							}
						}
						else
						{

						}
					});
				}
			}
			else
			{

			}
			
            setRadioButtonGeneral(stringKey, stringValue);
        }
        else if (stringKey.substring(0, stringPrefixCheckbox.length) == stringPrefixCheckbox)
        {            
            setCheckboxGeneral(stringKey, stringValue);
        }
        else if (stringKey.substring(0, stringPrefixSelect.length) == stringPrefixSelect)
        {            
            if (stringPageType == stringPageTypePDF)
            {
				// BENEFICIARIES LIST
				
				var stringIDWithoutPrefix = stringKey.substring(stringPrefixSelect.length, stringKey.length);
				var stringIndicatorPrefix = stringIDWithoutPrefix.substring(0, 3);
				
				if (stringIndicatorPrefix == "Ben")
				{
					var stringIDWithoutInfix = stringIDWithoutPrefix.substring(stringBeneficiariesListInfix.length, stringIDWithoutPrefix.length - 1);
					var stringTableJQueryID = stringKres + stringTablePrefix + stringBeneficiariesListInfix;
					
					for (var j = 0; j < arrayBeneficiariesListTableHeader.length; j++)
					{
						$(stringTableJQueryID + " tbody tr").each(function(indexRow)
						{
							var stringRowJavaScriptID = $(this).attr("id");
							var stringRowJQueryID = stringKres + stringRowJavaScriptID;
							var stringCellJavaScriptID = stringCellPrefix + stringBeneficiariesListInfix + arrayBeneficiariesListTableHeader[j];
							var stringCellJQueryID = stringKres + stringCellJavaScriptID + indexRow;
							var stringCellSuffix = stringCellJavaScriptID;
							
							if (stringIDWithoutInfix == arrayBeneficiariesListTableHeader[j])
							{
								if ($(stringCellJQueryID).text() == "" || $(stringCellJQueryID).text() == undefined || $(stringCellJQueryID).text() == null)
								{
									if (j == 5)
									{
										$(stringCellJQueryID).append(arrayOptionFind(arrayRelationshipWithProspectiveInsured, stringValue));
									}
									else
									{
										$(stringCellJQueryID).append(stringValue);
									}
									
									return false;
								}
								else
								{

								}
							}
							else
							{

							}
						});
					}
				}
				else
				{
				
				}
				
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
				// BENEFICIARIES LIST
				
				var stringIDWithoutPrefix = stringKey.substring(stringPrefixDate.length, stringKey.length);
				var stringIndicatorPrefix = stringIDWithoutPrefix.substring(0, 3);
				
				if (stringIndicatorPrefix == "Ben")
				{
					var stringIDWithoutInfix = stringIDWithoutPrefix.substring(stringBeneficiariesListInfix.length, stringIDWithoutPrefix.length - 1);
					var stringTableJQueryID = stringKres + stringTablePrefix + stringBeneficiariesListInfix;
						
					if (stringIDWithoutInfix == "Birthday")
					{
						$(stringTableJQueryID + " tbody tr").each(function(indexRow)
						{
							var stringRowJavaScriptID = $(this).attr("id");
							var stringRowJQueryID = stringKres + stringRowJavaScriptID;
							var arrayBirthdayTableHeader = [stringIDDay, stringIDMonth, stringIDYear];

							for (var k = 0; k < arrayBirthdayTableHeader.length; k++)
							{
								var stringCellJavaScriptID = stringCellPrefix + stringBeneficiariesListInfix + arrayBirthdayTableHeader[k];
								var stringCellJQueryID = stringKres + stringCellJavaScriptID + indexRow;
								var arrayDate = stringValue.split(stringSeparatorDate);
								
								if ($(stringCellJQueryID).text() == "" || $(stringCellJQueryID).text() == undefined || $(stringCellJQueryID).text() == null)
								{
									$(stringCellJQueryID).append(arrayDate[k]);
									
									if (k == arrayBirthdayTableHeader.length - 1)
									{
										return false;
									}
									else
									{
										
									}
								}
								else
								{

								}
							}
						});
					}
					else
					{

					}
				}
				else
				{
				
				}
				
				// FOR TABLE SPAJ PROPOSAL
				
				var stringInfix;
				
				if (stringIndicatorPrefix == stringIndicatorPolicyHolder)
				{
					stringTableJQueryID = stringKres + "TablePolicyHolderSPAJProposal";
					stringInfix = stringPolicyHolderPrefix;
				}
				else
				{
					stringTableJQueryID = stringKres + "TableProspectiveInsuredSPAJProposal";
					stringInfix = stringProspectiveInsuredPrefix;
				}
				
				var stringIDWithoutInfix = stringIDWithoutPrefix.substring(stringInfix.length + stringSPAJProposalInfix.length, stringIDWithoutPrefix.length - 1);
				
				for (var j = 0; j < arraySPAJProposalTableHeader.length; j++)
				{
					$(stringTableJQueryID + " tbody tr").each(function(indexRow)
					{
						var stringRowJavaScriptID = $(this).attr("id");
						var stringRowJQueryID = stringKres + stringRowJavaScriptID;
						var stringCellJavaScriptID = stringCellPrefix + stringInfix + stringSPAJProposalInfix + arraySPAJProposalTableHeader[j];
						var stringCellJQueryID = stringKres + stringCellJavaScriptID + indexRow;
						var stringCellSuffix = stringCellJavaScriptID;
						
						if (stringIDWithoutInfix == arraySPAJProposalTableHeader[j])
						{
							if ($(stringCellJQueryID).text() == "" || $(stringCellJQueryID).text() == undefined || $(stringCellJQueryID).text() == null)
							{
								$(stringCellJQueryID).append(stringValue);

								// FOR NUMBER

								numberGenerator(stringInfix + stringSPAJProposalInfix, indexRow);

								return false;
							}
							else
							{

							}
						}
						else
						{

						}
					});
				}
				
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
		else if (stringKey.substring(0, stringNumberPrefix.length) == stringNumberPrefix)
        {            
            if (stringPageType == stringPageTypePDF)
            {
                setNumberPDF(stringKey, stringValue);
            }
            else
            {
                setNumberForm(stringKey, stringValue);
            }
        }
        else
        {
            
        }				
    }
	
	
	// SET TABLE AND ARRAY
	
	if (stringPageType == stringPageTypePDF)
	{

	}
	else
	{
		// FOR BENEFICIARIES LIST
		
		if (stringPageSectionCurrent == stringPageSectionBeneficiariesList)
		{
			arrayBeneficiariesList = objectContent;
			tableBeneficiariesListGenerator(stringTablePrefix + stringBeneficiariesListInfix, arrayBeneficiariesList);

			var stringSharePercentagePrefix  = stringPrefixText + stringBeneficiariesListInfix + stringSharePercentageSuffix;
			var intSharePercentageTemporary = 0;
			var stringSharePercentageFilter;
			var arraySharePercentageTemporary = [];
			
			for (var k = 0; k < arrayBeneficiariesList.length; k++)
			{
				stringSharePercentageFilter = arrayBeneficiariesList[k].elementID.substring(0, stringSharePercentagePrefix.length);

				if (stringSharePercentageFilter == stringSharePercentagePrefix)
				{
					arrayAdd(arraySharePercentageTemporary, arrayBeneficiariesList[k].elementID, arrayBeneficiariesList[k].Value);
				}
				else
				{

				}
			}

			for (var l = 0; l < arraySharePercentageTemporary.length; l++)
			{
				intSharePercentageTemporary += parseInt(arraySharePercentageTemporary[l].Value, 10);
			}

			intSharePercentage = parseInt(intSharePercentageTemporary, 10);
			setTextForm(stringPrefixText + stringBeneficiariesListInfix + stringSharePercentageSuffix, intSharePercentage);
		}
		else if (stringPageSectionCurrent == stringPageSectionHealthQuestionnaire)
		{
			arrayHealthQuestionnaire = objectContent;
			
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Activity', arrayHealthQuestionnaire, ['Area' + stringPageInfixTypeCurrent + 'Activity' + 'AmandmentDetail']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'SmokeActivity', arrayHealthQuestionnaire, ['Number' + stringPageInfixTypeCurrent + 'SmokeActivity' + 'Amount']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Junkie', arrayHealthQuestionnaire, ['RadioButton' + stringPageInfixTypeCurrent + 'Alcohol' + 'ALConsume']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Cell', arrayHealthQuestionnaire, ['Date' + stringPageInfixTypeCurrent + 'Tumor' + 'FirstDiagnose']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Cardiac', arrayHealthQuestionnaire, ['Date' + stringPageInfixTypeCurrent + 'ChestPain' + 'FirstAttack', 'Date' + stringPageInfixTypeCurrent + 'Hypertension' + 'FirstTime']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Digest', arrayHealthQuestionnaire, ['RadioButton' + stringPageInfixTypeCurrent + 'DigestDetail' + 'Problem']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Gland', arrayHealthQuestionnaire, ['Date' + stringPageInfixTypeCurrent + 'Thyroid' + 'THFirstGot']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Liver', arrayHealthQuestionnaire, ['Date' + stringPageInfixTypeCurrent + 'Diabetes' + 'FirstKnown']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Motion', arrayHealthQuestionnaire, ['RadioButton' + stringPageInfixTypeCurrent + 'Backbone' + 'BBDissorder', 'RadioButton' + stringPageInfixTypeCurrent + 'Joint' + 'Atritis']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Nerve', arrayHealthQuestionnaire, ['Text' + stringPageInfixTypeCurrent + 'Epilepsy' + 'Since']);
			buttonPreviewForMultiPopUp(stringPageInfixTypeCurrent + 'Respiratory', arrayHealthQuestionnaire, ['RadioButton' + stringPageInfixTypeCurrent + 'RespiratoryDetail' + 'Disruption']);
			
			if (arrayHealthQuestionnaire.length > 0)
			{
				var stringNameInfix;
				var stringRadioButtonValue;
				
				stringNameInfix = stringPageInfixTypeCurrent + stringSPAJProposalInfix;
				stringRadioButtonValue = arrayFind(arrayHealthQuestionnaire, stringPrefixRadioButton + stringNameInfix)
				
				if (stringRadioButtonValue == true || stringRadioButtonValue == "true")
				{
					tableSPAJProposalGenerator("SPAJProposalList", arrayHealthQuestionnaire);
					$("#ButtonAddSPAJProposal").css("display", "block");
				}
				else
				{

				}

				var stringButtonPreviewJavaScriptID;
				var stringButtonPreviewJQueryID;
				var stringButtonPreviewName;
				var stringRadioButtonNameWithoutPrefix;
				var stringTextJavaScriptID;
				var stringValue;

				$(".ButtonPreview").each(function()
				{
					stringButtonPreviewJavaScriptID = $(this).attr("id");
					stringButtonPreviewJQueryID = stringKres + stringButtonPreviewJavaScriptID;
					stringButtonPreviewName = $(this).attr("name");
					stringValue = arrayFind(arrayHealthQuestionnaire, stringButtonPreviewName);

					if (stringValue == null || stringValue == undefined || stringValue == "false" || stringValue == false)
					{

					}
					else
					{
						$(stringButtonPreviewJQueryID).css("display", "block");
					}
				});
			}
			else
			{

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
    
    $("input[type=checkbox]").each(function()
    {
		var stringKey = $(this).attr("id");
        var stringValue = getCheckboxGeneral(stringKey);
        // validatePush(objectContent, stringKey, stringValue);
		// objectContent.push({ elementID: stringKey, Value: stringValue });
		arrayAdd(objectContent, stringKey, stringValue);
    });
    
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
			var dateBirthday = new Date(arrayBirthday[2], parseInt(arrayBirthday[1] - 1, 10), arrayBirthday[0]);
			var dateToday = new Date();
			
			if( (dateBirthday.getTime() > dateToday.getTime()))
			{
				alert("Tanggal lahir tidak bisa lebih dari hari ini !.");
				$(stringBirthdayJQueryID).val("");
			}
			else
			{
				
				var dateDifference = Math.ceil(dateToday.getTime() - dateBirthday.getTime()) / (1000 * 60 * 60 * 24 * 366);
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
           $(stringTextID).val("");
       }
   });
}

function checkboxOtherGenerator(stringCheckboxJavaScriptID, stringTextID,
stringValue)
{
	var stringCheckboxJQueryID = stringKres + stringCheckboxJavaScriptID;
	$(stringTextID).prop("readonly", true);

	$(stringCheckboxJQueryID).change(function()
	{
		if ($(stringCheckboxJQueryID).is(":checked") == true)
		{
			if (getCheckboxGeneral(stringCheckboxJavaScriptID) == stringValue)
			{
			   $(stringTextID).prop("readonly", false);
			}
			else
			{
			   $(stringTextID).prop("readonly", true);
			   $(stringTextID).val("");
			}
		}
		else
		{
			$(stringTextID).prop("readonly", true);
			$(stringTextID).val("");	
		}
	});
}

function telephoneStripGenerator(stringInputJavaScriptID)
{
	var stringInputValue;
	var stringInputJQueryID = stringKres + stringInputJavaScriptID;
  
	$(stringInputJQueryID).keyup(function()
	{
		stringInputValue = $(this).val();

		if (stringInputValue.length == 4)
		{
			stringInputValue += stringSeparatorTelephone;
			$(this).val(stringInputValue);
		}
		else
		{

		}
	});
}

function inputListener()
{
	$("input").change(function()
	{
		booleanInputChangeState = "true";
	});
	
	$("textarea").change(function()
	{
		booleanInputChangeState = "true";
	});
	
	$("select").change(function()
	{
		booleanInputChangeState = "true";
	});
}

function releaseInfix(stringKey)
{
	if (stringKey.substring(0, stringPolicyHolderPrefix.length) == stringPolicyHolderPrefix)
	{
		return stringKey.substring(stringPolicyHolderPrefix.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringProspectiveInsuredPrefix.length) == stringProspectiveInsuredPrefix)
	{
		return stringKey.substring(stringProspectiveInsuredPrefix.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringBeneficiariesListInfix.length) == stringBeneficiariesListInfix)
	{
		return stringKey.substring(stringBeneficiariesListInfix.length, stringKey.length);
	}
	else if (stringKey.substring(0, stringSPAJProposalInfix.length) == stringSPAJProposalInfix)
	{
		return stringKey.substring(stringSPAJProposalInfix.length, stringKey.length);
	}
	else
	{
		return "";
	}
}

function getInfix(stringKey)
{
	if (stringKey.substring(0, stringPolicyHolderPrefix.length) == stringPolicyHolderPrefix)
	{
		return stringPolicyHolderPrefix;
	}
	else if (stringKey.substring(0, stringProspectiveInsuredPrefix.length) == stringProspectiveInsuredPrefix)
	{
		return stringProspectiveInsuredPrefix;
	}
	else if (stringKey.substring(0, stringBeneficiariesListInfix.length) == stringBeneficiariesListInfix)
	{
		return stringBeneficiariesListInfix;
	}
	else if (stringKey.substring(0, stringSPAJProposalInfix.length) == stringSPAJProposalInfix)
	{
		return stringSPAJProposalInfix;
	}
	else
	{
		return "";
	}
}

function imageSelector(stringPath)
{
	$("img").each(function()
	{
		var stringSource = $(this).attr("src");

		if (stringSource == undefined || stringSource == "" || stringSource == null)
		{

		}
		else
		{
			$(this).attr("src", $(this).attr("src").replace("..\/..\/Resource\/|..\/..\/jqueryLibrary\/Resource\/", stringPath));
		}
	});
}