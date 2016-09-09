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

function showPopUpFromRadioButton(stringRadioButtonName, stringRadioButtonValue, stringPopUpLinkJavaScriptID, stringParentNameWithoutPrefix, arrayContent)
{
	var stringPopUpLinkJQueryID = stringKres + stringPopUpLinkJavaScriptID;
	
	if (getRadioButtonGeneral(stringRadioButtonName) == stringRadioButtonValue)
	{
		$(stringPopUpLinkJQueryID).css("display", "block");
		setInputFrom(stringPopUpLinkJavaScriptID, arrayContent, stringParentNameWithoutPrefix);
		arrayAdd(arrayHealthQuestionnaire, stringRadioButtonName, getRadioButtonGeneral(stringRadioButtonName));
	}
	else
	{
		
	}
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
	
	if (arrayValidation.length == 0 || arrayValidation == null)
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
		
		getInputFrom(stringPopUpCurrentJavaScriptID, arrayContent, stringParentNameWithoutPrefix);
		$(stringPopUpCurrentJQueryID).css("display", "none");
		$(stringButtonPreviewJQueryID).css("display", "block");
		previewArrayObject(arrayContent);
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
		previewArrayObject(arrayContent);
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
		
        var stringInputNameWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);
        var stringKey = stringPrefixText + stringParentNameWithoutPrefix + stringInputNameWithoutPrefix;
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
		
		var stringInputNameWithoutPrefix = stringInputJavaScriptID.substring(stringPrefixText.length, stringInputJavaScriptID.length);
        var stringKey = stringPrefixText + stringParentNameWithoutPrefix + stringInputNameWithoutPrefix;
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


// FOR POP UP

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
				// alert(stringKey + " " + stringValue);
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
			var stringKey = stringPrefixText + stringInputInfix + stringInputIDWithoutPrefix;
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
			var stringKey = stringPrefixText + stringInputInfix + stringInputIDWithoutPrefix;
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