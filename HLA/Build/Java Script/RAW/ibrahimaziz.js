// IBRAHIM AZIZ 
// BHIMBIM
// http://www.ibrahimaziz.biz
// built for PT Emobile Indonesia - Official Website 2014
// http://www.emobile.com.sg


// INITIALIZATION

var directoryRoot = "..";
var boxTypeWithBottomLabel = "With bottom label";
var boxTypeWithoutLabel = "Without label";
var labelDay = "Hari";
var labelMonth = "Bulan";
var labelYear = "Tahun";
var sizeBox = 20;


// LABEL GENERATOR

function labelGenerator(labelID, labelAmount)
{
    $(labelID).css("width", (((sizeBox + 4) * labelAmount) - 10) - labelAmount + "px");
}

function spanGenerator(spanID, spanAmount)
{
    $(spanID).css("width", (((sizeBox + 4) * spanAmount) - 10) - spanAmount + "px");
}


// INPUT GENERATOR

function boxGenerator(tableID, boxAmount, boxType, boxLabel)
{
    $(tableID).append("<tbody></tbody>");
    $(tableID + " tbody").append("<tr></tr>");
    var stringTableID = tableID.substring(1, tableID.length);
    
    for(var i = 0; i < boxAmount; i++)
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


// BOX SETTER AND GETTER

function boxSetter(tableID, stringContent)
{
    for(var i = 0; i < stringContent.length; i++)
    {
        $(tableID + " tbody tr " + tableID + i).append(stringContent[i]);
    }
}

function boxGetter(tableID, boxAmount)
{
    var stringContent = "";
    
    for(var i = 0; i < boxAmount; i++)
    {
        stringContent += $(tableID + " tbody tr " + tableID + i).text();
    }
    
    return stringContent;
}