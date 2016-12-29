// IBRAHIM AZIZ 
// BHIMBIM
// http://www.ibrahimaziz.design
// built for InfoConnect Sdn Bhd - BCA Life Bless
// http://www.infoconnect.com.my


// GENERATE FORM

function formGenerator(JSONInput, stringLayoutJavaScriptID)
{
	var elementMain = document.getElementById(stringLayoutJavaScriptID);
	var stringHTMLForm = "<form id='formMain'></form>";
	elementMain.innerHTML = stringHTMLForm;
	var stringMessageTitle = "Form generator";
	var stringMessageContent = "There is problem in the config file -> ";

	if (JSONInput.fieldset == undefined | JSONInput.fieldset == null | JSONInput.fieldset == "")
	{
		messageError(stringMessageTitle, stringMessageContent + "fieldset");
	}
	else
	{
		fieldsetGenerator(JSONInput.fieldset, "formMain");
	}
	
	if (JSONInput.question == undefined | JSONInput.question == null | JSONInput.question == "")
	{
		messageError(stringMessageTitle, stringMessageContent + "question");
	}
	else
	{
		questionGenerator(JSONInput.question);
	}
	
	if (JSONInput.input == undefined | JSONInput.input == null | JSONInput.input == "")
	{
		messageError(stringMessageTitle, stringMessageContent + "input");
	}
	else
	{
		inputGenerator(JSONInput.input);
	}
	
	if (JSONInput.table == undefined | JSONInput.table == null | JSONInput.table == "")
	{
		messageError(stringMessageTitle, stringMessageContent + "table");
	}
	else
	{
		tableGenerator(JSONInput.table);
	}
}

// GENERATE FIELDSET

function fieldsetGenerator(JSONFieldset, stringLayoutJavaScriptID)
{
	/* INITIALIZE */

	var stringJSONFieldsetKey;
	var stringJSONFieldsetLegend;
	var stringJSONFieldsetOrder;
	var stringJSONFieldsetState;
	var stringLayoutJQueryID = stringKres + stringLayoutJavaScriptID;
	var elementForm = document.getElementById(stringLayoutJavaScriptID);
	var stringHTMLFieldset = "";

	JSONFieldset = JSONSort(JSONFieldset, "fieldsetOrder");

	for (var i = 0; i < JSONFieldset.length; i++)
	{
		/* GET JSON */

		stringJSONFieldsetKey = JSONFieldset[i].fieldsetKey;
		stringJSONFieldsetLegend = JSONFieldset[i].fieldsetLegend;
		stringJSONFieldsetOrder = JSONFieldset[i].fieldsetOrder;
		stringJSONFieldsetState = JSONFieldset[i].fieldsetState;

		/* FIELDSET */

		if (stringJSONFieldsetState == stringStateTrue)
		{
			if (stringJSONFieldsetLegend.length > 0)
			{
				stringHTMLFieldset += "<fieldset id='" + stringJSONFieldsetKey + "'><legend>" + stringJSONFieldsetLegend + "</legend><ul></ul></fieldset>";
			}
			else
			{
				stringHTMLFieldset += "<fieldset id='" + stringJSONFieldsetKey + "'><ul></ul></fieldset>";
			}
		}
		else
		{

		}
	}

	stringHTMLFieldset += "</form>";
	elementForm.innerHTML = stringHTMLFieldset;
};


// GENERATE QUESTION

function questionGenerator(JSONQuestion)
{
	/* INITIALIZE */

	var stringJSONQuestionKey;
	var stringJSONQuestionFieldsetKey;
	var stringJSONQuestionOrder;
	var stringJSONQuestionState;
	
	var stringHTMLQuestion;

	JSONQuestion = JSONSort(JSONQuestion, "questionOrder");

	for (var i = 0; i < JSONQuestion.length; i++)
	{
		/* GET JSON */

		stringJSONQuestionKey = JSONQuestion[i].questionKey;
		stringJSONQuestionOrder = JSONQuestion[i].questionOrder;
		stringJSONQuestionState = JSONQuestion[i].questionState;
		stringJSONQuestionFieldsetKey = JSONQuestion[i].fieldsetKey;
		stringHTMLQuestion = "";

		/* QUESTION */

		if (stringJSONQuestionState == stringStateTrue)
		{
			stringHTMLQuestion = "<li id='" + stringJSONQuestionKey + "'></li>";
			$(stringKres + stringJSONQuestionFieldsetKey + " ul").append(stringHTMLQuestion);
		}
		else
		{

		}
	}
};


// GENERATE INPUT

function inputGenerator(JSONInput)
{
	/* INITIALIZE */

	var stringJSONInputQuestionKey;
	var stringJSONInputLabelKey;
	var stringJSONInputLabelWidth;
	var stringJSONInputLabelValue;
	var stringJSONInputKey;
	var stringJSONInputName;
	var stringJSONInputType;
	var stringJSONInputPlaceholder;
	var stringJSONInputValue;
	var stringJSONInputState;
	var stringJSONInputValidationType;
	var stringJSONInputValidationName;
	var stringJSONInputOrder;
	var stringJSONInputWidth;
	var stringJSONInputKeyTemporary;
	var stringJSONInputFormulaKey;

	var arrayJSONInputValue;
	var arrayJSONInputText;
	var arrayJSONInputKey;
	
	var arrayJSONInputState;
	var arrayJSONInputSelectedValue;
	var stringAttributeState;

	var stringHTMLInput
	var elementQuestion;

	JSONInput = JSONSort(JSONInput, "inputOrder");

	for (var i = 0; i < JSONInput.length; i++)
	{
		/* GET JSON */

		stringJSONInputQuestionKey = JSONInput[i].questionKey;
		stringJSONInputLabelKey = JSONInput[i].labelKey;
		stringJSONInputLabelWidth = JSONInput[i].labelWidth;
		stringJSONInputLabelValue = JSONInput[i].labelValue;
		stringJSONInputKey = JSONInput[i].inputKey;
		stringJSONInputWidth = JSONInput[i].inputWidth;
		stringJSONInputName = JSONInput[i].inputName;
		stringJSONInputType = JSONInput[i].inputType;
		stringJSONInputPlaceholder = JSONInput[i].inputPlaceholder;
		stringJSONInputValue = JSONInput[i].inputValue;
		stringJSONInputState = JSONInput[i].inputState;
		stringJSONInputValidationType = JSONInput[i].inputValidationType;
		stringJSONInputValidationName = JSONInput[i].inputValidationName;
		stringJSONInputOrder = JSONInput[i].inputOrder;
		stringJSONInputFormulaKey = JSONInput[i].formulaKey;
		stringHTMLInput = "";
		arrayJSONInputState = [];
		arrayJSONInputSelectedValue = [];
		stringAttributeState = "";

		if (stringJSONInputState != stringStateFalse)
		{
			/* LABEL */

			if (stringJSONInputLabelKey != "")
			{
				if (stringJSONInputType == stringInputTypeRadioButton | stringJSONInputType == stringInputTypeCheckbox)
				{
					arrayJSONInputKey = stringJSONInputKey.split(stringJSONArraySeparator);
					stringJSONInputKeyTemporary = arrayJSONInputKey[0];
				}
				else 
				{
					stringJSONInputKeyTemporary = stringJSONInputKey;
				}

				stringHTMLInput += "<label for='" + stringJSONInputKeyTemporary + "' id='" + stringJSONInputLabelKey + "' class='" + stringJSONInputLabelWidth + "'>" + stringJSONInputLabelValue + "</label>";
			}
			else
			{

			}

			/* STATE, SELECTED and CHECKED */

			if (stringJSONInputState.indexOf(stringJSONStateSeparator) >= 0)
			{
				arrayJSONInputState = stringJSONInputState.split(stringJSONStateSeparator);
				stringJSONInputState = arrayJSONInputState[0];
				arrayJSONInputSelectedValue = arrayJSONInputState[1].split(stringJSONArraySeparator);
			}
			else
			{
				
			}

			/* INPUT */

			if (stringJSONInputType == stringInputTypeSelect)
			{
				/* SELECT */

				stringHTMLInput += 
					"<select " + 
					"id='" + stringJSONInputKey + "' " + 
					"class='" + stringJSONInputWidth + "' " + 
					"name='" + stringJSONInputName + "' " + 
					"placeholder='" + stringJSONInputPlaceholder + "' " + 
					stringJSONInputState + "='true' " + 
					stringDataValidationType + "='" + stringJSONInputValidationType + "' " + 
					stringDataErrorMessage + "='" + stringJSONInputValidationName + "' " + 
					stringDataFormulaKey + "='" + stringJSONInputFormulaKey + "' >";

				arrayJSONInputValue = stringJSONInputValue.split(stringJSONArraySeparator);
				arrayJSONInputText = stringJSONInputPlaceholder.split(stringJSONArraySeparator);

				for (var j = 0; j < arrayJSONInputValue.length; j++)
				{
					stringAttributeState = setInputStateAttribute(arrayJSONInputSelectedValue, arrayJSONInputValue[j], stringStateSelected);

					stringHTMLInput += "<option value='" + arrayJSONInputValue[j] + "' " + stringAttributeState + ">" + arrayJSONInputText[j] + "</option>";
				}

				stringHTMLInput += "</select>";
			}
			else if (stringJSONInputType == stringInputTypeRadioButton | stringJSONInputType == stringInputTypeCheckbox)
			{
				/* RADIO BUTTON AND CHECKBOX */

				stringHTMLInput += "<div class='RadioButton'>";

				arrayJSONInputKey = stringJSONInputKey.split(stringJSONArraySeparator);
				arrayJSONInputValue = stringJSONInputValue.split(stringJSONArraySeparator);
				arrayJSONInputText = stringJSONInputPlaceholder.split(stringJSONArraySeparator);

				for (var j = 0; j < arrayJSONInputKey.length; j++)
				{
					stringAttributeState = setInputStateAttribute(arrayJSONInputSelectedValue, arrayJSONInputValue[j], stringStateChecked);

					stringHTMLInput += 
						"<input type='" + stringJSONInputType + "' id='" + arrayJSONInputKey[j] + "' " + 
						"name='" + stringJSONInputName + "' value='" + arrayJSONInputValue[j] + "' " + 
						stringAttributeState + " " + stringDataFormulaKey + "='" + stringJSONInputFormulaKey + "' />";
					stringHTMLInput += "<label for='" + arrayJSONInputKey[j] + "'>" + arrayJSONInputText[j] + "</label>";
				}

				stringHTMLInput += "</div>";
			}
			else
			{
				/* TEXT BASED INPUT */

				stringHTMLInput += 
					"<input type='" + stringJSONInputType + "' " + 
					"id='" + stringJSONInputKey + "' " + 
					"class='" + stringJSONInputWidth + "' " + 
					"name='" + stringJSONInputName + "' " + 
					"placeholder='" + stringJSONInputPlaceholder + "' " + 
					"value='" + stringJSONInputValue + "' " + 
					stringJSONInputState + "='true' " + 
					stringDataValidationType + "='" + stringJSONInputValidationType + "' " + 
					stringDataErrorMessage + "='" + stringJSONInputValidationName + "' " + 
					stringDataFormulaKey + "='" + stringJSONInputFormulaKey + "' />";
			}
		}
		else
		{

		}

		$(stringKres + stringJSONInputQuestionKey).append(stringHTMLInput);
	}
};

function setInputStateAttribute(arrayJSONInputSelectedValue, arrayJSONInputValue, stringState)
{
	var stringAttribute;
	if (arrayJSONInputSelectedValue != "")
	{
		for (var k = 0; k < arrayJSONInputSelectedValue.length; k++)
		{
			if (arrayJSONInputSelectedValue[k] == arrayJSONInputValue)
			{
				stringAttribute = stringState;
				k = arrayJSONInputSelectedValue.length;
			}
			else
			{
				
			}
		}
	}
	else
	{

	}

	return stringAttribute;
}


// TABLE GENERATOR

function tableGenerator(JSONInput)
{
	/* INITIALIZE */

	JSONAttribute = JSONInput.attribute;
	var stringJSONAttributeTableKey;
	var stringJSONAttributeFiedlsetKey;
	var stringJSONAttributeTableHeaderKey;
	var stringJSONAttributeTableBodyKey;
	var stringJSONAttributeTableFooterKey;
	var stringJSONAttributeTableOrder;
	var stringJSONAttributeTableState;
	var stringHTMLTable = "";

	JSONAttribute = JSONSort(JSONAttribute, "tableOrder");

	/* TABLE THEAD, TBODY, TFOOT */

	for (var i = 0; i < JSONAttribute.length; i++)
	{
		stringJSONAttributeTableKey = JSONAttribute[i].tableKey;
		stringJSONAttributeFieldsetKey = JSONAttribute[i].fieldsetKey;
		stringJSONAttributeTableHeaderKey = JSONAttribute[i].tableHeaderKey;
		stringJSONAttributeTableBodyKey = JSONAttribute[i].tableBodyKey;
		stringJSONAttributeTableFooterKey = JSONAttribute[i].tableFooterKey;
		stringJSONAttributeTableOrder = JSONAttribute[i].tableOrder;
		stringJSONAttributeTableState = JSONAttribute[i].tableState;

		if (stringJSONAttributeTableState == stringStateTrue)
		{
			stringHTMLTable += "<table id='" + stringJSONAttributeTableKey + "'>";

			if (stringJSONAttributeTableHeaderKey != null | stringJSONAttributeTableHeaderKey != undefined | stringJSONAttributeTableHeaderKey != "")
			{
				stringHTMLTable += "<thead id='" + stringJSONAttributeTableHeaderKey + "'></thead>"
			}
			else
			{

			}

			if (stringJSONAttributeTableBodyKey != null | stringJSONAttributeTableBodyKey != undefined | stringJSONAttributeTableBodyKey != "")
			{
				stringHTMLTable += "<tbody id='" + stringJSONAttributeTableBodyKey + "'></tbody>"
			}
			else
			{

			}

			if (stringJSONAttributeTableFooterKey != null | stringJSONAttributeTableFooterKey != undefined | stringJSONAttributeTableFooterKey != "")
			{
				stringHTMLTable += "<tfoot id='" + stringJSONAttributeTableFooterKey + "'></tfoot>"
			}
			else
			{

			}

			stringHTMLTable += "</table>";
		}
		else
		{

		}	
	}

	$(stringKres + stringJSONAttributeFieldsetKey).append(stringHTMLTable);

	tableRowGenerator(JSONInput.row);
	tableColumnGenerator(JSONInput.column);
}

function tableRowGenerator(JSONInput)
{
	/* INITIALIZE */

	var stringJSONInputRowKey;
	var stringJSONInputSectionKey;
	var stringJSONInputRowOrder;
	var stringJSONInputRowState;
	var stringHTMLRow;

	JSONInput = JSONSort(JSONInput, "rowOrder");

	/* TABLE TR */

	for (var i = 0; i < JSONInput.length; i++)
	{
		stringJSONInputRowKey = JSONInput[i].rowKey;
		stringJSONInputSectionKey = JSONInput[i].sectionKey;
		stringJSONInputRowOrder = JSONInput[i].rowOrder;
		stringJSONInputTableState = JSONInput[i].rowState;
		stringHTMLRow = "";

		if (stringJSONInputTableState == stringStateTrue)
		{
			stringHTMLRow = "<tr id='" + stringJSONInputRowKey + "'></tr>";
			$(stringKres + stringJSONInputSectionKey).append(stringHTMLRow);
		}
		else
		{
			
		}
	}
}

function tableColumnGenerator(JSONInput)
{
	/* INITIALIZE */

	var stringJSONInputColumnKey;
	var stringJSONInputRowKey;
	var stringJSONInputColumnValue;
	var stringJSONInputRowSpan;
	var stringJSONInputColumnSpan;
	var stringJSONInputColumnOrder;
	var stringJSONInputColumnState;
	var elementTableHeaderRow;
	var stringHTMLColumn;

	JSONInput = JSONSort(JSONInput, "columnOrder");

	/* TABLE TH / TD */

	for (var i = 0; i < JSONInput.length; i++)
	{
		stringJSONInputColumnKey = JSONInput[i].columnKey;
		stringJSONInputRowKey = JSONInput[i].rowKey;
		stringJSONInputColumnValue = JSONInput[i].columnValue;
		stringJSONInputRowSpan = JSONInput[i].rowSpan;
		stringJSONInputColumnSpan = JSONInput[i].columnSpan;
		stringJSONInputColumnOrder = JSONInput[i].columnOrder;
		stringJSONInputColumnState = JSONInput[i].columnState;

		if (stringJSONInputTableState == stringStateTrue)
		{
			stringHTMLColumn = 
				"<td id='" + stringJSONInputColumnKey + "' rowspan='" + stringJSONInputRowSpan + "' " + 
				"colspan='" + stringJSONInputColumnSpan + "'>" + stringJSONInputColumnValue + "</td>";
			$(stringKres + stringJSONInputRowKey).append(stringHTMLColumn);
		}
		else
		{
			
		}
	}
}


// FORMULA

function formulaGenerator(JSONInput, JSONConstant)
{
	/* INITIALIZE */

	var stringJSONInputFormulaKey;
	var stringJSONInputFormulaContent;
	var stringJSONInputKey;
	var stringJSONInputFormulaState;
	var arrayJSONInputFormulaContent = [];
	var arrayJSONInputFormulaValue = [];

	var JSONConstantFormula;
	var JSONConstantTable;
	var stringJSONConstantFormulaKey;
	var stringJSONConstantTableHeader;
	var stringJSONConstantTableKey;
	var stringJSONConstantFormulaOperator;
	var stringJSONConstantFormulaState;
	var arrayJSONConstantTableHeader = [];
	var arrayJSONConstantInputValue = [];
	var arrayJSONConstantFormulaOperator = [];

	var JSONConstantTableSelected;
	var arrayJSONConstantTableSelectedKey = [];
	var arrayJSONConstantTableSelectedValue = [];
	var arrayJSONConstantFormulaValue = [];


	/* INPUT LISTENER */

	$("input,select,textarea").each(function()
	{
		var stringFormulaKey = $(this).attr(stringDataFormulaKey);
		
		if (stringFormulaKey == null | stringFormulaKey == undefined | stringFormulaKey == "")
		{

		}
		else
		{
			$(this).change(function()
			{
				arrayJSONInputFormulaContent = [];
				arrayJSONInputFormulaValue = [];
				arrayJSONConstantTableHeader = [];
				arrayJSONConstantInputValue = [];
				arrayJSONConstantFormulaOperator = [];
				arrayJSONConstantTableSelectedKey = [];
				arrayJSONConstantTableSelectedValue = [];
				arrayJSONConstantFormulaValue = [];

				/* READ JSON */

				for (var i = 0; i < JSONInput.length; i++)
				{
					stringJSONInputFormulaKey = JSONInput[i].formulaKey;
					stringJSONInputFormulaState = JSONInput[i].formulaState;

					if (stringJSONInputFormulaState == stringStateTrue && stringJSONInputFormulaKey == stringFormulaKey)
					{
						stringJSONInputFormulaContent = JSONInput[i].formulaContent;
						stringJSONInputKey = JSONInput[i].inputKey;
						arrayJSONInputFormulaContent = stringJSONInputFormulaContent.split(stringJSONArraySeparator);
						arrayJSONInputFormulaValue = arrayJSONInputFormulaContent;

						/* FORMULA LISTENER */

						for (var j = 0; j < arrayJSONInputFormulaContent.length; j++)
						{
							if (indicatorPrefix(arrayJSONInputFormulaContent[j]) == stringStateInput)
							{
								/* GET VALUE FROM UI */

								arrayJSONInputFormulaValue[j] = getGeneralInputForm(arrayJSONInputFormulaContent[j]);
							}
							else if (indicatorPrefix(arrayJSONInputFormulaContent[j]) == stringStateConstant)
							{
								/* GET VALUE FROM CONSTANT */

								JSONConstantFormula = JSONConstant.formula;
								JSONConstantTable = JSONConstant.table;

								for (var k = 0; k < JSONConstantFormula.length; k++)
								{
									stringJSONConstantFormulaKey = JSONConstantFormula[k].formulaKey;
									stringJSONConstantFormulaState = JSONConstantFormula[k].formulaState;

									if (stringJSONConstantFormulaState == stringStateTrue && stringJSONConstantFormulaKey == arrayJSONInputFormulaContent[j])
									{
										stringJSONConstantTableKey = JSONConstantFormula[k].tableKey;
										stringJSONConstantTableHeader = JSONConstantFormula[k].tableHeader;
										stringJSONConstantFormulaOperator = JSONConstantFormula[k].formulaOperator;
										
										arrayJSONConstantTableHeader = stringJSONConstantTableHeader.split(stringJSONArraySeparator);
										arrayJSONConstantFormulaOperator = stringJSONConstantFormulaOperator.split(stringJSONArraySeparator);
										JSONConstantTableSelected = eval("JSONConstantTable." + stringJSONConstantTableKey);

										/* SELECT TABLE */
										
										if (JSONConstantTableSelected == null | JSONConstantTableSelected == undefined | JSONConstantTableSelected == "")
										{

										}
										else
										{
											/* GET INPUT VALUE AND TABLE KEY */
											
											for (var l = 0; l < arrayJSONConstantTableHeader.length; l++)
											{
												arrayJSONConstantTableSelectedKey[l] = releaseInfix(releasePrefix(arrayJSONConstantTableHeader[l])).toLowerCase();

												if (indicatorPrefix(arrayJSONConstantTableHeader[l]) == stringStateInput)
												{
													arrayJSONConstantFormulaValue[l] = getGeneralInputForm(arrayJSONConstantTableHeader[l]);
												}
												else
												{

												}
											}

											/* QUERY TABLE WITH KEY AND VALUE */

											for (var l = 0; l < JSONConstantTableSelected.length; l++)
											{
												var booleanEquals = true;
												
												for (var m = 0; m < arrayJSONConstantTableSelectedKey.length; m++)
												{
													arrayJSONConstantTableSelectedValue[m] = eval("JSONConstantTableSelected[" + l + "]." + arrayJSONConstantTableSelectedKey[m]);
													
													if (eval("parseInt(arrayJSONConstantFormulaValue[" + m + "], 10) " + arrayJSONConstantFormulaOperator[m] + " parseInt(arrayJSONConstantTableSelectedValue[" + m + "], 10)"))
													{
														
													}
													else
													{
														booleanEquals = false;
													}
												}

												if (booleanEquals == true)
												{
													arrayJSONInputFormulaValue[j] = JSONConstantTableSelected[l].value;
													l = JSONConstantTableSelected.length;
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
							}
							else
							{

							}
						}

						// alert(arrayJSONInputFormulaValue.join(" "));
						$(stringKres + stringJSONInputKey).val(eval(arrayJSONInputFormulaValue.join(" ")));
					}
					else
					{
						
					}
				}
			});
		}
	});
}

function formulaTableGenerator(JSONFormula, JSONConstant)
{
	/* INITIALIZE */

	var stringJSONFormulaKey;
	var stringJSONFormulaContent;
	var stringJSONFormulaInputKey;
	var stringJSONFormulaState;
	var stringJSONFormulaKeyWithoutPrefix;
	var arrayJSONFormulaContent = [];
	var arrayJSONFormulaValue = [];
	var stringRowJavaScriptID;
	var stringColumnJavaScriptID;

	var JSONConstantFormula;
	var JSONConstantTable;
	var stringJSONConstantFormulaKey;
	var stringJSONConstantTableHeader;
	var stringJSONConstantTableKey;
	var stringJSONConstantFormulaOperator;
	var stringJSONConstantFormulaState;
	var arrayJSONConstantTableHeader = [];
	var arrayJSONConstantInputValue = [];
	var arrayJSONConstantFormulaOperator = [];

	var JSONConstantTableSelected;
	var arrayJSONConstantTableSelectedKey = [];
	var arrayJSONConstantTableSelectedValue = [];
	var arrayJSONConstantFormulaValue = [];

	var intColumnID;
	
	for (var i = 0; i < JSONFormula.length; i++)
	{
		stringJSONFormulaState = JSONFormula[i].formulaState;
		stringJSONFormulaKey = JSONFormula[i].formulaKey;
		stringJSONFormulaKeyWithoutPrefix = releasePrefix(stringJSONFormulaKey);

		if (stringJSONFormulaState == stringStateTrue && getPrefix(stringJSONFormulaKeyWithoutPrefix) == stringPrefixTable)
		{
			$(stringKres + stringJSONFormulaKeyWithoutPrefix + " tbody tr").each(function()
			{
				stringJSONFormulaContent = JSONFormula[i].formulaContent;
				stringJSONFormulaInputKey = JSONFormula[i].inputKey;
				arrayJSONFormulaContent = stringJSONFormulaContent.split(stringJSONArraySeparator);
				arrayJSONFormulaValue = arrayJSONFormulaContent;
				stringRowJavaScriptID = $(this).attr("id");
				intColumnID = stringRowJavaScriptID.substring("RowRiderBody".length, stringRowJavaScriptID.length);
				
				$(stringKres + stringRowJavaScriptID + " td").each(function()
				{
					stringColumnJavaScriptID = $(this).attr("id");

					if (stringColumnJavaScriptID.substring(0, stringJSONFormulaInputKey.length) == stringJSONFormulaInputKey)
					{
						/* FORMULA LISTENER */
						
						for (var j = 0; j < arrayJSONFormulaContent.length; j++)
						{
							if (indicatorPrefix(arrayJSONFormulaContent[j]) == stringStateInput)
							{
								/* GET VALUE FROM UI */
								
								arrayJSONFormulaValue[j] = getGeneralInputForm(arrayJSONFormulaContent[j]);
							}
							else if (indicatorPrefix(arrayJSONFormulaContent[j]) == stringStateTable)
							{
								/* GET VALUE FROM TABLE */

								arrayJSONFormulaValue[j] = $(this).text();
							}
							else if (indicatorPrefix(arrayJSONFormulaContent[j]) == stringStateConstant)
							{
								/* GET VALUE FROM CONSTANT */

								JSONConstantFormula = JSONConstant.formula;
								JSONConstantTable = JSONConstant.table;

								for (var k = 0; k < JSONConstantFormula.length; k++)
								{
									stringJSONConstantFormulaKey = JSONConstantFormula[k].formulaKey;
									stringJSONConstantFormulaState = JSONConstantFormula[k].formulaState;

									if (stringJSONConstantFormulaState == stringStateTrue && stringJSONConstantFormulaKey == arrayJSONFormulaContent[j])
									{
										stringJSONConstantTableKey = JSONConstantFormula[k].tableKey;
										stringJSONConstantTableHeader = JSONConstantFormula[k].tableHeader;
										stringJSONConstantFormulaOperator = JSONConstantFormula[k].formulaOperator;
										
										arrayJSONConstantTableHeader = stringJSONConstantTableHeader.split(stringJSONArraySeparator);
										arrayJSONConstantFormulaOperator = stringJSONConstantFormulaOperator.split(stringJSONArraySeparator);
										JSONConstantTableSelected = eval("JSONConstantTable." + stringJSONConstantTableKey);

										/* SELECT TABLE */
										
										if (JSONConstantTableSelected == null | JSONConstantTableSelected == undefined | JSONConstantTableSelected == "")
										{

										}
										else
										{
											/* GET INPUT VALUE AND TABLE KEY */
											
											for (var l = 0; l < arrayJSONConstantTableHeader.length; l++)
											{
												arrayJSONConstantTableSelectedKey[l] = releaseInfix(releasePrefix(arrayJSONConstantTableHeader[l])).toLowerCase();

												if (indicatorPrefix(arrayJSONConstantTableHeader[l]) == stringStateInput)
												{
													arrayJSONConstantFormulaValue[l] = getGeneralInputForm(arrayJSONConstantTableHeader[l]);
												}
												else if (indicatorPrefix(arrayJSONConstantTableHeader[l]) == stringStateTable)
												{
													arrayJSONConstantFormulaValue[l] = $(stringKres + arrayJSONConstantTableHeader[l] + intColumnID).text();
												}
												else
												{

												}
											}

											/* QUERY TABLE WITH KEY AND VALUE */
											
											for (var l = 0; l < JSONConstantTableSelected.length; l++)
											{
												var booleanEquals = true;

												for (var m = 0; m < arrayJSONConstantTableSelectedKey.length; m++)
												{
													arrayJSONConstantTableSelectedValue[m] = eval("JSONConstantTableSelected[" + l + "]." + arrayJSONConstantTableSelectedKey[m]);

													if (eval("parseInt(arrayJSONConstantFormulaValue[" + m + "], 10) " + arrayJSONConstantFormulaOperator[m] + " parseInt(arrayJSONConstantTableSelectedValue[" + m + "], 10)"))
													{
														
													}
													else
													{
														booleanEquals = false;
													}
												}

												if (booleanEquals == true)
												{
													arrayJSONFormulaValue[j] = JSONConstantTableSelected[l].value;
													l = JSONConstantTableSelected.length;
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
							}
							else
							{
								
							}
						}

						// alert(arrayJSONFormulaValue.join(" "));
						$(stringKres + stringJSONFormulaInputKey + intColumnID).text(eval(arrayJSONFormulaValue.join(" ")));
					}
					else
					{

					}
				});
			});
		}
		else
		{

		}
	}
}