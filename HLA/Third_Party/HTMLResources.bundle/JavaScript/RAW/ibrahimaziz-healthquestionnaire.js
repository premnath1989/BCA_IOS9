// GENERATOR

function footerSetterForHealthQuestionnairePDF(stringDetail, intTotalPage)
{
	$("footer .Detail").each(function(indexPage)
	{
		$(this).text(stringDetail + " Hal " + (indexPage + 1) + " / " + intTotalPage);
	})
}

function titleSetterForHealthQuestionnairePDF(stringTitle)
{
	$("h1").text(stringTitle);
	$("span.QuestionnaireTitle").text(stringTitle);
}


// MULTI POP UP

function showPopUpFromButton(stringPopUpLinkJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{
	var stringPopUpLinkJQueryID = stringKres + stringPopUpLinkJavaScriptID;
	$(stringPopUpLinkJQueryID).css("display", "block");
	setInputFrom(stringPopUpLinkJavaScriptID, arrayContent, stringParentNameWithoutPrefix);
}

function showPopUpFromRadioButton(stringRadioButtonName, stringRadioButtonValue, stringPopUpLinkJavaScriptID, stringInfix, arrayContent, arrayInfix)
{
	var stringPopUpLinkJQueryID = stringKres + stringPopUpLinkJavaScriptID;
	var stringParentNameWithoutPrefix = stringInfix + arrayInfix[0];
	
	if (getRadioButtonGeneral(stringRadioButtonName) == stringRadioButtonValue)
	{
		setRadioButtonGeneral(stringRadioButtonName, null);
		$(stringPopUpLinkJQueryID).css("display", "block");
		setInputFrom(stringPopUpLinkJavaScriptID, arrayContent, stringParentNameWithoutPrefix);
	}
	else
	{
		var stringInfixForDelete;
		var stringKeyWithoutPrefix;
		var stringKeyInfix;
		var arrayDeleteTemporary = [];
		
		for (var i = 0; i < arrayInfix.length; i++)
		{
			stringInfixForDelete = stringInfix + arrayInfix[i];
			
			for (var j = 0; j < arrayContent.length; j++)
			{
				stringKeyWithoutPrefix = releasePrefix(arrayContent[j].elementID);
				stringKeyInfix = stringKeyWithoutPrefix.substring(0, stringInfixForDelete.length);
				
				if (stringInfixForDelete == stringKeyInfix)
				{
					arrayAdd(arrayDeleteTemporary, arrayContent[j].elementID, arrayContent[j].Value);
				}
				else
				{
					
				}
			}
		}
		
		for (var k = 0; k < arrayDeleteTemporary.length; k++)
		{
			for (var l = 0; l < arrayContent.length; l ++)
			{
				if (arrayDeleteTemporary[k].elementID == arrayContent[l].elementID)
				{
					arrayContent.splice(l, 1);
				}
				else
				{
					
				}
			}
		}
		
		arrayAdd(arrayContent, stringRadioButtonName, getRadioButtonGeneral(stringRadioButtonName));
		
		var stringButtonPreviewJavaScriptID = stringButtonPreviewPrefix + stringParentNameWithoutPrefix;
		var stringButtonPreviewJQueryID = stringKres + stringButtonPreviewJavaScriptID;
		$(stringButtonPreviewJQueryID).css("display", "none");
	}
	
	// previewArrayObject(arrayContent);
}

function buttonPopUpNavigation(stringButtonJavaScriptID, stringPopUpCurrentJavaScriptID, stringPopUpLinkJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{	
	var stringButtonJQueryID = stringKres + stringButtonJavaScriptID;	
	var stringPopUpCurrentJQueryID = stringKres + stringPopUpCurrentJavaScriptID;	
	var stringPopUpLinkJQueryID = stringKres + stringPopUpLinkJavaScriptID;	
	setInputFrom(stringPopUpLinkJavaScriptID, arrayContent, stringParentNameWithoutPrefix);
	
	$(stringPopUpCurrentJQueryID).css("display", "none");	
	$(stringPopUpLinkJQueryID).css("display", "block");
}

function buttonPopUpDone(stringPopUpCurrentJavaScriptID, stringParentNameWithoutPrefix, arrayContent, arrayValidation)
{
	var stringPopUpCurrentJQueryID = stringKres + stringPopUpCurrentJavaScriptID;
	var booleanState = false;		
	
	if (arrayValidation == null)
	{
		booleanState = true;
	}
	else
	{
		var stringRequiredValue;
		
		for (var i = 0; i < arrayValidation.length; i++)
		{						
			stringRequiredValue = arrayFind(arrayHealthQuestionnaire, arrayValidation[i]);
			
			if (stringRequiredValue != null)
			{				
				booleanState = true;
			}
			else
			{
				
			}
		}
	}
	
	if (booleanState == true)
	{
		var stringButtonPreviewJavaScriptID = stringButtonPreviewPrefix + stringParentNameWithoutPrefix;
		var stringButtonPreviewJQueryID = stringKres + stringButtonPreviewJavaScriptID;
		var stringRadioButtonName = stringPrefixRadioButton + stringParentNameWithoutPrefix;
		
		getInputFrom(stringPopUpCurrentJavaScriptID, arrayContent, stringParentNameWithoutPrefix);
		$(stringPopUpCurrentJQueryID).css("display", "none");
		$(stringButtonPreviewJQueryID).css("display", "block");
		setRadioButtonGeneral(stringRadioButtonName, "true");
		arrayAdd(arrayContent, stringRadioButtonName, getRadioButtonGeneral(stringRadioButtonName));
		
		resetInputFrom(stringPopUpCurrentJavaScriptID);
	}
	else
	{
		alert("Harap mengisi kuesioner tambahan minimal satu !.");
	}
}

function buttonPopUpCancel(stringPopUpCurrentJavaScriptID)
{
	var stringPopUpCurrentJQueryID = stringKres + stringPopUpCurrentJavaScriptID;
	
	$(stringPopUpCurrentJQueryID).css("display", "none");
	resetInputFrom(stringPopUpCurrentJavaScriptID);
}

function buttonSubPopUpDone(stringPopUpCurrentJavaScriptID, stringPopUpParentJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{
	var stringPopUpCurrentJQueryID = stringKres + stringPopUpCurrentJavaScriptID;
	var stringPopUpParentJQueryID = stringKres + stringPopUpParentJavaScriptID;
	var booleanState = getInputFrom(stringPopUpCurrentJavaScriptID, arrayContent, stringParentNameWithoutPrefix);
	
	if (booleanState == true)
	{
		$(stringPopUpCurrentJQueryID).css("display", "none");
		$(stringPopUpParentJQueryID).css("display", "block");
		resetInputFrom(stringPopUpCurrentJavaScriptID);
	}
	else
	{
			
	}	
}

function buttonSubPopUpCancel(stringPopUpCurrentJavaScriptID, stringPopUpParentJavaScriptID)
{
	var stringPopUpCurrentJQueryID = stringKres + stringPopUpCurrentJavaScriptID;
	var stringPopUpParentJQueryID = stringKres + stringPopUpParentJavaScriptID;
	
	$(stringPopUpCurrentJQueryID).css("display", "none");
	$(stringPopUpParentJQueryID).css("display", "block");
	resetInputFrom(stringPopUpCurrentJavaScriptID);
}

function buttonPreviewForMultiPopUp(stringParentNameWithoutPrefix, arrayContent, arrayValidation)
{
	var booleanState = false;
	
	if (arrayValidation == null)
	{
		booleanState = true;
	}
	else
	{
		var stringRequiredValue;
		
		for (var i = 0; i < arrayValidation.length; i++)
		{
			stringRequiredValue = arrayFind(arrayContent, arrayValidation[i]);
			
			if (stringRequiredValue != null)
			{
				booleanState = true;
			}
			else
			{

			}
		}
	}
	
	if (booleanState == true)
	{
		var stringButtonPreviewJavaScriptID = stringButtonPreviewPrefix + stringParentNameWithoutPrefix;
		var stringButtonPreviewJQueryID = stringKres + stringButtonPreviewJavaScriptID;
		
		$(stringButtonPreviewJQueryID).css("display", "block");
	}
	else
	{
		
	}
}


// FOR POP UP

function resetInputFrom(stringLayoutJavaScriptID)
{
	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	
	$(stringLayoutJQueryID + " input[type='text']").each(function()
	{
		$(this).val("");
	});
	
	$(stringLayoutJQueryID + " input[type='date']").each(function()
	{
		$(this).val("");
	});
	
	$(stringLayoutJQueryID + " input[type='number']").each(function()
	{
		$(this).val("");
	});
	
	$(stringLayoutJQueryID + " input[type='email']").each(function()
	{
		$(this).val("");
	});
	
	$(stringLayoutJQueryID + " input[type='radio']").each(function()
	{
		setRadioButtonGeneral($(this).attr("name"), null);
	});
	
	$(stringLayoutJQueryID + " input[type='checkbox']").each(function()
	{
		setCheckboxGeneral($(this).attr("id"), stringStateNotChecked);
	});
	
	$(stringLayoutJQueryID + " select").each(function()
	{
		$(this).val("");
	});
	
	$(stringLayoutJQueryID + " textarea").each(function()
	{
		$(this).val("");
	});
}

function getInputFrom(stringLayoutJavaScriptID, arrayContent, stringInputInfix)
{
	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	var arrayInputTemporary = [];
	stateValidation = true;
	
	// TEXT
	
	if (stateValidation == true)
	{
		$(stringLayoutJQueryID + " form input[type='text']").each(function()
		{
			var stringInputJavaScriptID =$(this).attr("id");
			var stringInputJQueryID = stringKres + stringInputJavaScriptID;
			var stringInputRequired = $(this).attr("required");
			var stringInputIDWithoutPrefix = releasePrefix($(this).attr("id"));
			var stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			var stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			var stringKey = getPrefix(stringInputJavaScriptID) + stringInputInfix + stringInputIDWithoutPrefix;
			var stringValue = getTextForm(stringSpecificInputJavaScriptID);
			
			if (stringInputRequired == stringStateRequired)
			{
				if (validateTextGeneral(stringSpecificInputJQueryID) == false)
				{
					validationMessage("Harap lengkapi form terlebih dahulu !.", null);
					return false;
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
				}
			}
			else
			{
				arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
			}
		});
	}
	else
	{
		
	}
	
	// RADIO BUTTON
	
	if (stateValidation == true)
	{
		var stringRadioButtonFlag = 0;
		
		$(stringLayoutJQueryID + " form input[type='radio']").each(function()
		{
			var stringInputName = $(this).attr("name");
			var stringInputRequired = $(this).attr("required");
			var stringInputNameWithoutPrefix = releasePrefix($(this).attr("name"));
			var stringKey = stringPrefixRadioButton + stringInputInfix + stringInputNameWithoutPrefix;
			var stringValue = getSpecificRadioButtonGeneral(stringLayoutJQueryID, stringInputName);

			if (stringRadioButtonFlag != stringInputName)
			{
				if (stringInputRequired == stringStateRequired)
				{
					if (validateSpecificRadioButtonGeneral(stringLayoutJQueryID, stringInputName) == false)
					{
						validationMessage("Harap lengkapi form terlebih dahulu !.", null);
						return false;
					}
					else
					{
						arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
						stringRadioButtonFlag = stringInputName;
					}
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
					stringRadioButtonFlag = stringInputName;
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
	
	// SELECT
	
	if (stateValidation == true)
	{
		$(stringLayoutJQueryID + " form select").each(function()
		{
			var stringInputJavaScriptID = $(this).attr("id");
			var stringInputJQueryID = stringKres + stringInputJavaScriptID;
			var stringInputRequired = $(this).attr("required");
			var stringInputIDWithoutPrefix = releasePrefix($(this).attr("id"));
			var stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			var stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			var stringKey = stringPrefixSelect + stringInputInfix + stringInputIDWithoutPrefix;
			var stringValue = getSelectForm(stringSpecificInputJavaScriptID);

			if (stringInputRequired == stringStateRequired)
			{
				if (validateSelectGeneral(stringSpecificInputJQueryID) == false)
				{
					validationMessage("Harap lengkapi form terlebih dahulu !.", null);
					return false;
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
				}
			}
			else
			{
				arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
			}
		});
	}
	else
	{
		
	}
	
	// DATE
	
	if (stateValidation == true)
	{
		$(stringLayoutJQueryID + " form input[type='date']").each(function()
		{
			var stringInputJavaScriptID = $(this).attr("id");
			var stringInputJQueryID = stringKres + stringInputJavaScriptID;
			var stringInputRequired = $(this).attr("required");
			var stringInputIDWithoutPrefix = releasePrefix($(this).attr("id"));
			var stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			var stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			var stringKey = stringPrefixDate + stringInputInfix + stringInputIDWithoutPrefix;
			var stringValue = getDateForm(stringSpecificInputJavaScriptID);

			if (stringInputRequired == stringStateRequired)
			{
				if (validateTextGeneral(stringSpecificInputJQueryID) == false)
				{
					validationMessage("Harap lengkapi form terlebih dahulu !.", null);
					return false;
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
				}
			}
			else
			{
				arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
			}
		});
	}
	else
	{
		
	}
	
	// EMAIL
	
	if (stateValidation == true)
	{
		$(stringLayoutJQueryID + " form input[type='email']").each(function()
		{
			var stringInputJavaScriptID = $(this).attr("id");
			var stringInputJQueryID = stringKres + stringInputJavaScriptID;
			var stringInputRequired = $(this).attr("required");
			var stringInputIDWithoutPrefix = releasePrefix($(this).attr("id"));
			var stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			var stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			var stringKey = stringPrefixEmail + stringInputInfix + stringInputIDWithoutPrefix;
			var stringValue = getEmailForm(stringSpecificInputJavaScriptID);

			if (stringInputRequired == true)
			{
				if (validateTextGeneral(stringSpecificInputJQueryID) == false)
				{
					validationMessage("Harap lengkapi form terlebih dahulu !.", null);
					return false;
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
				}
			}
			else
			{
				arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
			}
		});
	}
	else
	{
		
	}
	
	// NUMBER
	
	if (stateValidation == true)
	{
		$(stringLayoutJQueryID + " form input[type='number']").each(function()
		{
			var stringInputJavaScriptID = $(this).attr("id");
			var stringInputJQueryID = stringKres + stringInputJavaScriptID;
			var stringInputRequired = $(this).attr("required");
			var stringInputIDWithoutPrefix = releasePrefix($(this).attr("id"));
			var stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			var stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			var stringKey = stringPrefixNumber + stringInputInfix + stringInputIDWithoutPrefix;
			var stringValue = getNumberForm(stringSpecificInputJavaScriptID);

			if (stringInputRequired == stringStateRequired)
			{
				if (validateTextGeneral(stringSpecificInputJQueryID) == false)
				{
					validationMessage("Harap lengkapi form terlebih dahulu !.", null);
					return false;
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
				}
			}
			else
			{
				arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
			}
		});
	}
	else
	{
		
	}
	
	// CHECKBOX
	
	if (stateValidation == true)
	{
		$(stringLayoutJQueryID + " form input:checkbox").each(function()
		{
			var stringInputJavaScriptID = $(this).attr("id");
			var stringInputJQueryID = stringKres + stringInputJavaScriptID;
			var stringInputRequired = $(this).attr("required");
			var stringInputIDWithoutPrefix = releasePrefix($(this).attr("id"));
			var stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			var stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			var stringKey = stringPrefixCheckbox + stringInputInfix + stringInputIDWithoutPrefix;
			var stringValue = getCheckboxGeneral(stringSpecificInputJavaScriptID);

			if (stringInputRequired == stringStateRequired)
			{
				if (validateTextGeneral(stringSpecificInputJQueryID) == false)
				{
					validationMessage("Harap lengkapi form terlebih dahulu !.", null);
					return false;
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
				}
			}
			else
			{
				arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
			}
		});
	}
	else
	{
		
	}
	
	// TEXT AREA
	
	if (stateValidation == true)
	{
		$(stringLayoutJQueryID + " form textarea").each(function()
		{
			var stringInputJavaScriptID = $(this).attr("id");
			var stringInputJQueryID = stringKres + stringInputJavaScriptID;
			var stringInputRequired = $(this).attr("required");
			var stringInputIDWithoutPrefix = releasePrefix($(this).attr("id"));
			var stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			var stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			var stringKey = stringPrefixArea + stringInputInfix + stringInputIDWithoutPrefix;
			var stringValue = getAreaForm(stringSpecificInputJavaScriptID);

			if (stringInputRequired == stringStateRequired)
			{
				if (validateTextGeneral(stringSpecificInputJQueryID) == false)
				{
					validationMessage("Harap lengkapi form terlebih dahulu !.", null);
					return false;
				}
				else
				{
					arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
				}
			}
			else
			{
				arrayValidatePush(arrayInputTemporary, stringKey, stringValue);
			}
		});
	}
	else
	{
		
	}
	
	if (stateValidation == true)
	{
		arrayTransfer(arrayInputTemporary, arrayContent);
		return true;
	}
	else
	{
		return false;
	}
}

function setInputFrom(stringLayoutJavaScriptID, arrayContent, stringInputInfix)
{	
	var stringKey;
	var stringValue;
	var stringKeyPrefix;
	var stringKeyWithoutPrefix;
	var stringKeyWithoutInfix;
	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	var stringPopUpSuffix = stringLayoutJavaScriptID.substring("PopUp".length, stringLayoutJavaScriptID.length);
	var stringSectionInfix;
	
	for (var i = 0; i < arrayContent.length; i++)
	{
		stringKey = arrayContent[i].elementID;
		stringValue = arrayContent[i].Value;
		stringKeyPrefix = getPrefix(stringKey);
		stringKeyWithoutPrefix = releasePrefix(stringKey);
		stringKeyWithoutInfix = stringKeyWithoutPrefix.substring(stringInputInfix.length, stringKeyWithoutPrefix.length);
		
		if (stringKeyPrefix == stringPrefixText)
		{
			setTextForm(stringLayoutJavaScriptID + " " + stringKres + stringPrefixText + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixRadioButton)
		{
			setSpecificRadioButtonGeneral(stringLayoutJavaScriptID, stringPrefixRadioButton + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixCheckbox)
		{
			setCheckboxGeneral(stringLayoutJavaScriptID + " " + stringKres + stringPrefixCheckbox + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixSelect)
		{
			setSelectForm(stringLayoutJavaScriptID + " " + stringKres + stringPrefixSelect + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixArea)
		{
			setAreaForm(stringLayoutJavaScriptID + " " + stringKres + stringPrefixArea + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixNumber)
		{
			setNumberForm(stringLayoutJavaScriptID + " " + stringKres + stringPrefixNumber + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixEmail)
		{
			setEmailForm(stringLayoutJavaScriptID + " " + stringKres + stringPrefixEmail + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixDate)
		{
			setDateForm(stringLayoutJavaScriptID + " " + stringKres + stringPrefixDate + stringKeyWithoutInfix, stringValue);
		}
		else
		{
			
		}
		
		stringSectionInfix = getInfixSection(stringKeyWithoutPrefix);
	}
	
	
	// QUICK FIX FOR MULTI POP UP.
	
	var stringAmandmentDetailKey = stringPrefixArea + stringSectionInfix + stringPopUpSuffix + "AmandmentDetail";
	var stringAmandmentDetail = arrayFind(arrayContent, stringAmandmentDetailKey);
	
	if (stringAmandmentDetail == null)
	{
		$(stringKres + stringLayoutJavaScriptID + " " + stringKres + stringPrefixArea + "AmandmentDetail").val("");
	}
	else
	{
		$(stringKres + stringLayoutJavaScriptID + " " + stringKres + stringPrefixArea + "AmandmentDetail").val(stringAmandmentDetail);
	}
}

function getInfixSection(stringContent)
{
	if (stringContent.substring(0, 3) == "Pro")
	{
		return stringProspectiveInsuredPrefix;
	}
	else if (stringContent.substring(0, 3) == "Pol")
	{
		return stringPolicyHolderPrefix;
	}
	else
	{

	}
}

function getPrefix(stringKey)
{
	if (stringKey.substring(0, stringPrefixText.length) == stringPrefixText)
	{
		return stringPrefixText;
	}
	else if (stringKey.substring(0, stringPrefixRadioButton.length) == stringPrefixRadioButton)
	{
		return stringPrefixRadioButton;
	}
	else if (stringKey.substring(0, stringPrefixCheckbox.length) == stringPrefixCheckbox)
	{
		return stringPrefixCheckbox;
	}
	else if (stringKey.substring(0, stringPrefixSelect.length) == stringPrefixSelect)
	{
		return stringPrefixSelect;
	}
	else if (stringKey.substring(0, stringPrefixDate.length) == stringPrefixDate)
	{
		return stringPrefixDate;
	}
	else if (stringKey.substring(0, stringPrefixArea.length) == stringPrefixArea)
	{
		return stringPrefixArea;
	}
	else if (stringKey.substring(0, stringPrefixNumber.length) == stringPrefixNumber)
	{
		return stringPrefixNumber;
	}
	else if (stringKey.substring(0, stringPrefixEmail.length) == stringPrefixEmail)
	{
		return stringPrefixEmail;
	}
	else
	{
		
	}
}

function setToHealthQuestionnairePDF(stringLayoutJavaScriptID, arrayContent)
{
	var stringKey;
	var stringValue;
	var stringKeyPrefix;
	var stringKeyWithoutPrefix;
	var stringKeyWithoutInfix;
	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	var stringInputJavaScriptID;
	var stringInputJQueryID;
	var stringSpecificInputJavaScriptID;
	var stringSpecificInputJQueryID;
	
	for (var i = 0; i < arrayContent.length; i++)
	{
		stringKey = arrayContent[i].elementID;
		stringValue = arrayContent[i].Value;
		stringKeyPrefix = getPrefix(stringKey);

		if (stringKeyPrefix == stringPrefixText)
		{
			stringInputJQueryID = stringKres + stringKey;
			stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			
			if (stringSpecificInputJQueryID.is("table") == true)
			{
				setBoxGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
			else
			{
				setTextGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
		}
		else if (stringKeyPrefix == stringPrefixRadioButton)
		{
			setRadioButtonGeneral(stringLayoutJavaScriptID + " " + stringKres + stringKey, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixCheckbox)
		{
			setCheckboxGeneral(stringLayoutJavaScriptID + " " + stringKres + stringKey, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixSelect)
		{
			stringInputJQueryID = stringKres + stringKey;
			stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			
			if (stringSpecificInputJQueryID.is("table") == true)
			{
				setBoxGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
			else
			{
				setTextGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
		}
		else if (stringKeyPrefix == stringPrefixArea)
		{
			stringInputJQueryID = stringKres + stringKey;
			stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			
			if (stringSpecificInputJQueryID.is("table") == true)
			{
				setBoxGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
			else
			{
				setTextGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
		}
		else if (stringKeyPrefix == stringPrefixNumber)
		{
			stringInputJQueryID = stringKres + stringKey;
			stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			
			if (stringSpecificInputJQueryID.is("table") == true)
			{
				setBoxGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
			else
			{
				setTextGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
			
			setNumberForm(stringLayoutJavaScriptID + " " + stringKres + stringPrefixNumber + stringKeyWithoutInfix, stringValue);
		}
		else if (stringKeyPrefix == stringPrefixEmail)
		{
			stringInputJQueryID = stringKres + stringKey;
			stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			
			if (stringSpecificInputJQueryID.is("table") == true)
			{
				setBoxGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
			else
			{
				setTextGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
		}
		else if (stringKeyPrefix == stringPrefixDate)
		{
			stringInputJQueryID = stringKres + stringKey;
			stringSpecificInputJavaScriptID = stringLayoutJavaScriptID + " " + stringInputJQueryID;
			stringSpecificInputJQueryID = stringKres + stringSpecificInputJavaScriptID;
			
			if (stringSpecificInputJQueryID.is("table") == true)
			{
				setBoxGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
			else
			{
				setTextGeneral(stringSpecificInputJavaScriptID, stringValue);
			}
		}
		else
		{
			
		}
	}
}


// SETTER FOR AMANDEMENT

function getFromDatabaseForAmandment(arrayContent, stringPageInfix, stringLayoutJavaScriptID)
{
	// AREA DETAIL

	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	var arrayPrefixFilter = [stringPrefixText, stringPrefixArea];
	var stringInfixFilter;
	var stringSuffixFilter = stringAmandmentSuffix + stringDetailSuffix;
	var arrayGeneralForm = ["SmokeActivity", "Junkie", "Activity", "Abroad", "Respiratory", "Cardiac", "Digest", "Nerve", "Liver", "Motion", "Gland", "Cell", "Claim", "Diagnostic", "PregnancyIllness", "FemaleAbnormality", "PapSmear", "HeartDissorder"];
	var arrayGeneralFormInIndonesia = ["Merokok", "Narkoba dan adiktif", "Aktifitas", "Bepergian keluar", "Pernapasan", "Jantung", "Pencernaan", "Saraf", "Hati", "Gerak", "Sel", "Kelenjar", "Klaim SPAJ", "Pemeriksaan", "Sakit Kehamilan", "Kelainan Wanita", "Pap Smear", "Kelainan Jantung"];
	var stringComposedKey;
	var stringQuestionPrefix = "Jawaban tambahan kuesioner ";
	var intQuestionNumber = 0;
	var stringKey;
	var stringValue;
	
	for (var i = 0; i < arrayGeneralForm.length; i++)
	{
		stringInfixFilter = stringPageInfix + arrayGeneralForm[i];
		
		for (var j = 0; j < arrayContent.length; j++)
		{
			stringKey = arrayContent[j].elementID;
			stringValue = arrayContent[j].Value;

			for (var k = 0; k < arrayPrefixFilter.length; k++)
			{
				stringComposedKey = arrayPrefixFilter[k] + stringInfixFilter + stringSuffixFilter;
				
				if (stringComposedKey == stringKey)
				{
					intQuestionNumber++;

					$(stringLayoutJQueryID).append
					(
						"<div class='ContainerFit'>" + 
						"<span class='NumberFix Single Item'>" + intQuestionNumber + ". " + "</span>" + 
						"<label for='" + stringKey + "' class='Single Full Item' >" + stringQuestionPrefix + arrayGeneralFormInIndonesia[i] + "</label>" + 
						"</div>" + 
						"<div class='ContainerFit NumberIndent'>" + 
						"<textarea id='" + stringKey + "' class='Full Double Item'>" + stringValue + "</textarea>" + 
						"</div>"
						
					);
				}
				else
				{

				}
			}
		}
	}


	// DISEASE

	var stringContentSuffix;
	var arraySicknessHeader = ["Vision", "ENT", "Reproduction", "Immune", "OtherIllness"];
	var stringContentSickness;
	var stringKeyWithoutPrefix;
	var stringKeyWithoutInfix;
	var stringContainerSicknessJavaScriptID;
	var stringContainerSicknessJQueryID;
	intQuestionNumber = 1;
	var intFlagQuestionNumber = 0;
	var stringKeyInfix;
	var booleanQuestionState = false;
	var stringKeyPrefix;

	for (var k = 0; k < arraySicknessHeader.length; k++)
	{
		for (var j = 0; j < arrayContent.length; j++)
		{
			stringKey = arrayContent[j].elementID;
			stringValue = arrayContent[j].Value;
			stringKeyWithoutPrefix = releasePrefix(stringKey);
			stringKeyInfix = getInfix(stringKeyWithoutPrefix);
			stringKeyWithoutInfix = releaseInfix(stringKeyWithoutPrefix);
			stringContentSickness = stringKeyWithoutInfix.substring(0, arraySicknessHeader[k].length);
			stringKeyPrefix = getPrefix(stringKey);
			
			if (stringKeyInfix == stringPageInfix)
			{
				if (stringContentSickness == arraySicknessHeader[k])
				{
					if (stringKeyPrefix == stringPrefixRadioButton)
					{

					}
					else
					{
						stringContainerSicknessJavaScriptID = stringContentSickness + intQuestionNumber;
						stringContainerSicknessJQueryID = stringKres + stringContainerSicknessJavaScriptID;

						if (intFlagQuestionNumber == intQuestionNumber)
						{

						}
						else
						{
							if (intQuestionNumber == 1)
							{
								$(stringLayoutJQueryID).append
								(
									"<h3 style='margin-top: 40px; margin-bottom: 10px;'>" + "Disease Form" + "</h3>" + 
									"<br>" + 
									"<div class='ContainerFit'>" + 
										"<span class='ShortFix Single Item Margin'>" + "Pertanyaan" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Nama Penyakit" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Mulai Sakit" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Lama Sakit" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Nama Dokter" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Rumah Sakit" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Alamat" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Telepon" + "</span>" + 
									"</div>"
								);
							}
							else
							{

							}

							$(stringLayoutJQueryID).append
							(
								"<div class='ContainerFit' id='" + stringContainerSicknessJavaScriptID + "'></div>"
							);

							$(stringContainerSicknessJQueryID).append
							(
								"<span class='ShortFix Single Item Margin'>" + stringContentSickness + "</span>"
							);

							booleanQuestionState = true;
							intFlagQuestionNumber = intQuestionNumber;
						}

						for (var i = 0; i < arrayHealthTableHeader.length; i++)
						{
							stringContentSuffix = stringKeyWithoutInfix.substring(arraySicknessHeader[k].length, stringKeyWithoutInfix.length);

							if(stringContentSuffix == arrayHealthTableHeader[i])
							{
								$(stringContainerSicknessJQueryID).append
								(
									"<input type='text' class='Tiny Single Item Margin' value='" + stringValue + "'/>"
								);
							}
							else
							{

							}
						}
					}
					
				}
				else
				{

				}
			}
			else
			{

			}
		}

		if (booleanQuestionState == true)
		{
			intQuestionNumber ++;
			intFlagQuestionNumber = 0;
		}
		else
		{

		}
	}


	// BENEFICIARIES LIST

	var intBeneficiariesListTotalRow = getLastID(arrayContent, stringPrefixText + stringBeneficiariesListInfix + arrayBeneficiariesListPopUpHeader[0]);
	var intBeneficiariesListID;
	intQuestionNumber = 1;
	intFlagQuestionNumber = 0;
	var intFlagBeneficiariesListID = 0;
	var stringContainerBeneficiariesListJavaScriptID;
	var stringContainerBeneficiariesListJQueryID;
	booleanQuestionState = false;

	for (var k = 1; k <= intBeneficiariesListTotalRow; k++)
	{
		for (var j = 0; j < arrayBeneficiariesListPopUpHeader.length; j++)
		{
			for (var i = 0; i < arrayContent.length; i++)
			{
				stringKey = arrayContent[i].elementID;
				stringValue = arrayContent[i].Value;
				stringKeyWithoutPrefix = releasePrefix(stringKey);
				stringKeyWithoutInfix = releaseInfix(stringKeyWithoutPrefix);

				stringContentSuffix = stringKeyWithoutInfix.substring(0, arrayBeneficiariesListPopUpHeader[j].length);
				intBeneficiariesListID = stringKeyWithoutInfix.substring(arrayBeneficiariesListPopUpHeader[j].length, stringKeyWithoutInfix.length);

				if (intBeneficiariesListID == k)
				{
					if (stringContentSuffix == arrayBeneficiariesListPopUpHeader[j])
					{
						stringContainerBeneficiariesListJavaScriptID = stringBeneficiariesListInfix + k;
						stringContainerBeneficiariesListJQueryID = stringKres + stringContainerBeneficiariesListJavaScriptID;

						if (intFlagQuestionNumber == intQuestionNumber)
						{
							
						}
						else
						{
							if (intQuestionNumber == 1)
							{
								$(stringLayoutJQueryID).append
								(
									"<h3 style='margin-top: 40px; margin-bottom: 10px;'>" + "Beneficiaries List" + "</h3>" + 
									"<br>" + 
									"<div class='ContainerFit'>" + 
										"<span class='ShortFix Single Item Margin'>" + "Nomor" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Nama Lengkap" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Tanggal Lahir" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Sex" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Hubungan" + "</span>" + 
										"<span class='Tiny Single Item Margin'>" + "Kewarganegaraan" + "</span>" + 
									"</div>"
								);
							}
							else
							{

							}

							$(stringLayoutJQueryID).append
							(
								"<div class='ContainerFit' id='" + stringContainerBeneficiariesListJavaScriptID + "'></div>"
							);

							$(stringContainerBeneficiariesListJQueryID).append
							(
								"<span class='ShortFix Single Item Margin'>" + intQuestionNumber + "</span>"
							);

							booleanQuestionState = true;
							intFlagQuestionNumber = intQuestionNumber;
						}

						$(stringContainerBeneficiariesListJQueryID).append
						(
							"<input type='text' class='Tiny Single Item Margin' value='" + stringValue + "'/>"
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

		if (booleanQuestionState == true)
		{
			intQuestionNumber ++;
			intFlagQuestionNumber = 0;
		}
		else
		{

		}
	}


	// SPAJ PROPOSAL

	var intSPAJProposalTotalRow = getLastID(arrayContent, stringPrefixText + stringPageInfix + stringSPAJProposalInfix + arraySPAJProposalTableHeader[0]);
	var intSPAJProposalID;
	intQuestionNumber = 1;
	intFlagQuestionNumber = 0;
	var intFlagSPAJProposalID = 0;
	var stringContainerSPAJProposalJavaScriptID;
	var stringContainerSPAJProposalJQueryID;
	booleanQuestionState = false;

	for (var k = 1; k <= intSPAJProposalTotalRow; k++)
	{
		for (var j = 0; j < arraySPAJProposalTableHeader.length; j++)
		{
			for (var i = 0; i < arrayContent.length; i++)
			{
				stringKey = arrayContent[i].elementID;
				stringValue = arrayContent[i].Value;
				stringKeyWithoutPrefix = releasePrefix(stringKey);
				stringKeyInfix = getInfix(stringKeyWithoutPrefix);
				stringKeyWithoutInfix = releaseInfix(stringKeyWithoutPrefix);

				stringContentSuffix = stringKeyWithoutInfix.substring(stringSPAJProposalInfix.length, stringSPAJProposalInfix.length + arraySPAJProposalTableHeader[j].length);
				intSPAJProposalID = stringKeyWithoutInfix.substring(stringSPAJProposalInfix.length + arraySPAJProposalTableHeader[j].length, stringKeyWithoutInfix.length);

				if (stringKeyInfix == stringPageInfix)
				{
					if (intSPAJProposalID == k)
					{
						if (stringContentSuffix == arraySPAJProposalTableHeader[j])
						{
							stringContainerSPAJProposalJavaScriptID = stringSPAJProposalInfix + k;
							stringContainerSPAJProposalJQueryID = stringKres + stringContainerSPAJProposalJavaScriptID;

							if (intFlagQuestionNumber == intQuestionNumber)
							{
								
							}
							else
							{

								if (intQuestionNumber == 1)
								{
									$(stringLayoutJQueryID).append
									(
										"<h3 style='margin-top: 40px; margin-bottom: 10px;'>" + "SPAJ Proposal" + "</h3>" + 
										"<br>" + 
										"<div class='ContainerFit'>" + 
											"<span class='ShortFix Single Item Margin'>" + "Nomor" + "</span>" + 
											"<span class='Tiny Single Item Margin'>" + "Nama Perusahaan" + "</span>" + 
											"<span class='Tiny Single Item Margin'>" + "Nomor Polis" + "</span>" + 
											"<span class='Tiny Single Item Margin'>" + "Tanggal Diterbitkan" + "</span>" + 
											"<span class='Tiny Single Item Margin'>" + "Uang Pertanggungan" + "</span>" + 
											"<span class='Tiny Single Item Margin'>" + "Hasil Keputusan" + "</span>" + 
										"</div>"
									);
								}
								else
								{

								}

								$(stringLayoutJQueryID).append
								(
									"<div class='ContainerFit' id='" + stringContainerSPAJProposalJavaScriptID + "'></div>"
								);

								$(stringContainerSPAJProposalJQueryID).append
								(
									"<span class='ShortFix Single Item Margin'>" + intQuestionNumber + "</span>"
								);

								booleanQuestionState = true;
								intFlagQuestionNumber = intQuestionNumber;
							}


							$(stringContainerSPAJProposalJQueryID).append
							(
								"<input type='text' class='Tiny Single Item Margin' value='" + stringValue + "'/>"
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
				else
				{

				}
			}
		}

		if (booleanQuestionState == true)
		{
			intQuestionNumber ++;
			intFlagQuestionNumber = 0;
		}
		else
		{

		}
	}
}


// GET FROM DATABASE

function getFromDatabaseForHealthQuestionnaire(objectContent, stringPageType)
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
				var stringKeyJQueryID = stringKres + stringKey;
				
				if ($(stringKeyJQueryID).is("table") == true)
				{
					var intMaxString = $(stringKeyJQueryID + " tbody tr td").length;
				
					if (stringValue.length > intMaxString)
					{
						if ($(stringKeyJQueryID + "2nd").length > 0)
						{
							var stringValue1 = stringValue.substring(0, intMaxString);
							var stringValue2 = stringValue.substring(intMaxString, stringValue.length);

							setTextPDF(stringKey, stringValue1);
							setTextPDF(stringKey + "2nd", stringValue2);
						}
						else
						{
							setTextPDF(stringKey, stringValue);
						}
					}
					else
					{
						setTextPDF(stringKey, stringValue);
					}
				}
				else
				{
					setTextPDF(stringKey, stringValue);
				}
				
				/* var intMaxString = 26;
				var stringKeyWithoutPrefix = releasePrefix(stringKey);
				var stringKeyWithoutInfix = releaseInfix(stringKeyWithoutPrefix);
				var stringIDMedication = "HypertensionMedication";
				
				if (stringKeyWithoutInfix == undefined)
				{
					if (stringValue.length > intMaxString)
					{
						var stringValue1 = stringValue.substring(0, intMaxString);
						var stringValue2 = stringValue.substring(0, intMaxString);

						setTextPDF(stringKey, stringValue1);
						setTextPDF(stringKey + "2nd", stringValue2);
					}
					else
					{
						setTextPDF(stringKey, stringValue);
					}
				}
				else
				{
					var stringKeyForMedication = stringKeyWithoutInfix.substring(0, stringIDMedication.length);
					var stringKeyForTable;
				
					if (stringKeyForMedication == stringIDMedication)
					{
						stringKeyForTable = stringCellPrefix + stringKeyWithoutPrefix;
						// alert(stringKres + " " + stringKeyForTable + " " + stringValue)
						$(stringKres + stringKeyForTable).append(stringValue);
					}
					else
					{
						if (stringValue.length > intMaxString)
						{
							var stringValue1 = stringValue.substring(0, intMaxString);
							var stringValue2 = stringValue.substring(0, intMaxString);

							setTextPDF(stringKey, stringValue1);
							setTextPDF(stringKey + "2nd", stringValue2);
						}
						else
						{
							setTextPDF(stringKey, stringValue);
						}
					} 
				} */
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
            setCheckboxGeneral(stringKey, stringValue);
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
                setDatePDFForHealthQuestionnaire(stringKey, stringValue);
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
}

var stringIDHour = "Hour";
var stringIDMinute = "Minute";
var stringIDSecond = "Second";
var stringSeparatorTime = ":";

function setDatePDFForHealthQuestionnaire(stringID, stringContent)
{	
    var arrayDateID = [stringIDDay, stringIDMonth, stringIDYear];
    var arrayDateString = stringContent.split(stringSeparatorDate);
	var arrayTimeID = [stringIDHour, stringIDMinute, stringIDSecond];
    var arrayTimeString = stringContent.split(stringSeparatorTime);
	
	if (arrayDateString.length > 1)
	{
		for (var i = 0; i < arrayDateString.length; i++)
		{
			if ($(stringKres + stringID + arrayDateID[i]).is("table") == true)
			{				
				setBoxGeneral(stringID + arrayDateID[i], arrayDateString[i]);	
			}
			else if ($(stringKres + stringID + arrayDateID[i]).is("div") == true)
			{				
				setLineGeneral(stringID + arrayDateID[i], arrayDateString[i]);	
			}
			else
			{
				setTextGeneral(stringID, stringContent);
			}
		}
	}
	else
	{
		for (var i = 0; i < arrayTimeString.length; i++)
		{
			if ($(stringKres + stringID + arrayTimeID[i]).is("table") == true)
			{
				setBoxGeneral(stringID + arrayTimeID[i], arrayTimeString[i]);	
			}
			else if ($(stringKres + stringID + arrayTimeID[i]).is("div") == true)
			{
				setLineGeneral(stringID + arrayTimeID[i], arrayTimeString[i]);	
			}
			else if ($(stringKres + stringID + arrayTimeID[i]).is("input[type='text']") == true)
			{
				setTextGeneral(stringID + arrayTimeID[i], arrayTimeString[i]);	
			}
			else
			{
				setTextGeneral(stringID, stringContent);
			}			
		}
	}
}


// TABLE GENERATOR

var stringPrefixTHead = "THead";
var stringPrefixTBody = "TBody";
var stringPrefixTFoot = "TFoot";

function tablePDFStaticGeneralGenerator(stringTableJavaScriptID, arrayHeader, intRow)
{
	var stringTableJQueryID = stringKres + stringTableJavaScriptID;
	var stringInfix = releasePrefix(stringTableJavaScriptID);
	var stringTableBodyJavaScriptID = stringPrefixTBody + stringInfix;
	var stringTableBodyJQueryID = stringKres + stringPrefixTBody + stringInfix;
	var stringTableRowJavaScriptID;
	var stringTableRowJQueryID;
	var stringCellJavaScriptID;

	$(stringTableJQueryID).append("<tbody id='" + stringTableBodyJavaScriptID + "'></tbody>");

	for (var i = 0; i < intRow; i++)
	{
		stringTableRowJavaScriptID = stringRowPrefix + stringInfix + i;
		stringTableRowJQueryID = stringKres + stringTableRowJavaScriptID;
		$(stringTableBodyJQueryID).append("<tr id='" + stringTableRowJavaScriptID + "'></tr>");
		
		for (var j = 0; j < arrayHeader.length; j++)
		{
			stringCellJavaScriptID = stringCellPrefix + stringInfix + arrayHeader[j] + i;
			$(stringTableBodyJQueryID + " " + stringTableRowJQueryID).append("<td id='" + stringCellJavaScriptID + "'></td>");
		}
	}
}

//for (var i = 0; i < arrayHeader.length; i++)
//	{
//		
//	}