var maxRowCount = 13;

function updateScenarios() {
	sceneAPercent = "6.65%";
	sceneBPercent = "4.65%";
	$('.sceneA').html(sceneAPercent);
	$('.sceneB').html(sceneBPercent);
}

function updateInvestment() {
	var year = ['2012', '2013', '2014', '2015', '2016'];
	var investment = ['6.9', '5.4', '5.0', '5.6'];
	
	var str = "";
	for (var i=0; i<investment.length; i++) {
		str = str + '<tr><td>' + year[i] + '/' + year[i+1] + '</td><td>' + investment[i] + '%';
		if (i == investment.length-1) {
			str = str + '<span class="fnPage40_IRR" style="font-size: 5px;vertical-align: super"></span>';
		}
		str = str + '</td></tr>';
	}
	$('.investmentReturnTbl #table-design2 > tbody').append(str);
}

function onBodyLoad() {
	$.ajaxSetup({ cache: false });
	$.ajax({
		url: 'SI.json',
		async: false,
		dataType: 'json',
		success: function (data) {
			gdata = data;
			for(j=0;j<data.SI[0].SI_Temp_Pages.data.length;j++)
			{
				row = gdata.SI[0].SI_Temp_Pages.data[j];
				if (row.PageDesc != "Page1")
				{
					if (row.PageDesc == "Page2")
						htmlPages = '<div id="' + row.PageDesc + '" style="margin-top:900px;padding: 15px 0px 0px 0px;"></div>';
					else
						htmlPages = '<div id="' + row.PageDesc + '" style="margin-top:900px;padding: 15px 0px 0px 0px;"></div>';
					$(htmlPages).appendTo('#externalPages');
				}
			}
			
			var page;
			for(j=0;j<data.SI[0].SI_Temp_Pages.data.length;j++)
			{
				row = gdata.SI[0].SI_Temp_Pages.data[j];
				page = row.htmlName;
				
				if(page=='eng_HLAWP_PageWPRiders_1.html' || page=='eng_HLAWP_PageWPRiders_2.html')
				{
					page = page + '?rider=' + row.riders;
				}
				
				$.ajax({
					url: "SI/" + page,
					async: false,
					dataType: 'html',
					success: function (data) {
						$("#" + row.PageDesc).html(data);
					}
				});
			}
			loadJson();
		}
	});
}

function loadBenefitPage() {
    
    var WaiverRider = [];
    
    if(gdata.SI[0].SI_Temp_Trad_Details.data.length > 1){
        if(gdata.SI[0].QuotationLang == "Malay"){
            $('.Benefit1Title').html('Ringkasan Faedah bagi Pelan Asas dan Rider dilampirkan');
        }
        else
        {
            $('.Benefit1Title').html('Summary of Benefits for Basic Plan and attached Riders');    
        }        
    }
    else
    {
        $('.Benefit1Title').html('Summary of Benefits for Basic Plan'); 
    }
    
    var tempPage;
    var title;
    AddRow = 0;
	$.each(gdata.SI[0].SI_Temp_Trad_Details.data, function(index, row) {
		if(row.RiderCode == 'WB30R' || row.RiderCode == 'WB50R' ){
			AddRow = parseInt(AddRow) + 6;
			WBRider = true;
			if(row.RiderCode == 'WB30R'){
				WB30Rider = true;
            }
        }
        else if(row.RiderCode == 'WBI6R30'){
            AddRow = parseInt(AddRow) + 6;
		    WBi6 = true;
        }
        else if(row.RiderCode == 'WBD10R30' ){
            AddRow = parseInt(AddRow) + 6;
		    WBd10 = true;
        }
        else if(row.RiderCode == 'WBM6R'){
            AddRow = parseInt(AddRow) + 6;
	    	WBM6R = true;
        }
        else if(row.RiderCode == 'EDUWR'){
            AddRow = parseInt(AddRow) + 6;
	    	EduWB = true;
        }
        else if (row.RiderCode == 'TPDYLA') {
            AddRow = parseInt(AddRow) + 3;
        }
        else if (row.RiderCode == 'ICR') {
            AddRow = parseInt(AddRow) + 4;
        }
        else if (row.RiderCode == 'CCTR' || row.RiderCode == 'HMM' || row.RiderCode == 'CPA' ||
        	row.RiderCode == 'WP30R'|| row.RiderCode == "WP50R" || row.RiderCode == 'WPTPD30R'|| row.RiderCode == "WPTPD50R" ) {
            AddRow = parseInt(AddRow) + 2;
        } 
        else if (row.col0_2.indexOf("-Benefit") == 0) {
            AddRow = parseInt(AddRow) + 6;
        }
        else if (row.RiderCode == 'HLAWP') {
            AddRow = parseInt(AddRow) + 5;
        }
        else {
            AddRow = parseInt(AddRow) + 1;
        }
        
        if(parseInt(AddRow) < benefitPage1Limit){
            tempPage  = 'table-Benefit1';
        }
        else if(parseInt(AddRow) < benefitPage2Limit){
            tempPage  = 'table-Benefit2';
        }
        else
        {
            tempPage  = 'table-Benefit3';
        }
        
		if (row.col0_1.indexOf("-") == 0) {
			title = "&nbsp;&nbsp;"+row.col0_1;
		} else {
			title = row.col0_1;
		}
		
		if(row.col0_2 == "-Benefit"){
            WaiverRider.push(row);
        }  else if(row.RiderCode == "EDUWR" || row.RiderCode == "WB30R" || row.RiderCode == "WBM6R" || row.RiderCode == "WBI6R30" || row.RiderCode == "WBD10R30" || row.RiderCode == "WB50R"){            
            var tempGYCC;
            
            if(row.RiderCode == "EDUWR"){
                tempGYCC = formatCurrency( row.col2) + "<sup><span class='fnPage2_EDU' style='font-size: 5px;vertical-align: super'></sup></span>";
            }
            else if (row.RiderCode == "WBM6R") {
	            var monthly;
                if(gdata.SI[0].QuotationLang == "Malay"){
                	monthly = "(bulanan)";
                } else {
                	monthly = "(monthly)";
                }
                tempGYCC = formatCurrency( row.col2) + "<br/>" + monthly + "<sup><span class='fnPage2_GMCC' style='font-size: 5px;vertical-align: super'></sup></span>";
            }
            else{
	            var yearly;
                if(gdata.SI[0].QuotationLang == "Malay"){
                	yearly = "(tahunan)";
                } else {
                	yearly = "(yearly)";
                }
                tempGYCC = formatCurrency( row.col2) + "<br/>" + yearly + "<sup><span class='fnPage2_GYCC' style='font-size: 5px;vertical-align: super'></sup></span>";  
            }
            
       		var WPRider;
			if(gdata.SI[0].QuotationLang == "Malay"){
				WPRider = "100% jumlah premium yang  dibayar untuk Rider ini<sup><span class='fnPage2_PremiumPaid' style='font-size: 5px;vertical-align: super'></sup></span>";
			}
			else
			{
				WPRider = "100% of total premium paid for this Rider<sup><span class='fnPage2_PremiumPaid' style='font-size: 5px;vertical-align: super'></sup></span>";    
			}
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + needItalic(title) + '</td><td colspan="1" > ' + '-' +
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + WPRider + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + tempGYCC + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('Yes') +
            	'</td><td colspan="1">' + ReturnYESNO_ByLang('Yes') + '</td></tr>');            	
        }
        else if(row.RiderCode == 'HLAWP' ){
            var temp;
            if(parseInt(row.col3) == 30){
                if(gdata.SI[0].QuotationLang == "Malay"){
                    temp = '150%<br/>jumlah premium Pelan Asas dibayar<sup><span class="fnPage2_PremiumPaid" style="font-size: 5px;vertical-align: super"></span></sup>';
                }
                else
                {
                    temp = '150%<br/>of total Basic premium Paid<sup><span class="fnPage2_PremiumPaid" style="font-size: 5px;vertical-align: super"></span></sup>';    
                }                
            }
            else{
                if(gdata.SI[0].QuotationLang == "Malay"){
                    temp = '250%<br/>jumlah premium Pelan Asas dibayar<sup><span class="fnPage2_PremiumPaid" style="font-size: 5px;vertical-align: super"></span></sup>';    
                }
                else
                {
                    temp = '250%<br/>of total Basic premium Paid<sup><span class="fnPage2_PremiumPaid" style="font-size: 5px;vertical-align: super"></span></sup>';
                }                
            }
            
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' +
            	' </td><td colspan="1" >' +  '-' + '</td><td colspan="1">' + temp + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + 
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + temp + '</td><td colspan="1">' + ReturnYESNO_ByLang('Yes') + '</td><td colspan="1">' +
            	ReturnYESNO_ByLang('Yes') + '</td></tr>');
            
        } 
        else if(row.RiderCode == 'WP30R'|| row.RiderCode == "WP50R" ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' +
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + formatCurrency(row.col2) +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + 
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' +
            	ReturnYESNO_ByLang('Yes') + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'WPTPD30R'|| row.RiderCode == "WPTPD50R" ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' +  title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + formatCurrency(row.col2) + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + 
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('Yes') + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'ACIR' || row.RiderCode == 'ACIR_MPP' || row.RiderCode == "CIR" ){
            var temp;
            if(row.RiderCode == 'ACIR' || row.RiderCode == 'ACIR_MPP'){
                temp = formatCurrency(row.col2) + "<sup><span class='fnPage2_ACIR' style='font-size: 5px;vertical-align: top;'></span></sup>";
            }
            else{
                temp = formatCurrency(row.col2);    
            }
            
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + temp + '</td><td colspan="1">' + '-' + 
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + 
            	ReturnYESNO_ByLang('No') + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'LCPR'){
            var temp;
            
            temp = formatCurrency(row.col2) + "<sup><span class='fnPage2_LCPR' style='font-size: 5px'></span></sup>";    
            
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + formatCurrency(row.col2)  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + formatCurrency(row.col2) + 
            	'<sup><span class="fnPage2_LCPR" style="font-size: 5px;vertical-align: top"></span></sup></td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + 
            	ReturnYESNO_ByLang('Yes') + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == "PLCP" ){
            var temp;
             
            temp = formatCurrency(row.col2) + "<sup><span class='fnPage2_PLCP' style='font-size: 5px;vertical-align: top'></span></sup>";    
            
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + formatCurrency(row.col2)  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + formatCurrency(row.col2) + 
            	'<sup><span class="fnPage2_PLCP" style="font-size: 5px;vertical-align: top"></span></sup></td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + 
            	ReturnYESNO_ByLang('Yes') + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'CCTR'|| row.RiderCode == "PTR" ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + formatCurrency(row.col2)  + '</td><td colspan="1">' + '-' +
				'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + 
				'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
				'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + 
				'</td><td colspan="1">' + ReturnYESNO_ByLang('Yes') + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'HMM'|| row.RiderCode == "MG_IV" || row.RiderCode == 'MG_II' ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + (row.col0_2) + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-'  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('Medical Plan') +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') +
            	'</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'HSP_II' ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + (row.col0_2) + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-'  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('Medical Plan') +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + 
            	'</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'HB' ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title +
            	'</td><td colspan="1" > ' + '-' + ' </td><td colspan="1" >' +  row.col1 + '</td><td colspan="1">' + '-'  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('Hospitalisation Income') +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') +
            	'</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'C+' ){
        	mBenefit = '-';
        	if (row.col0_2 == "Option 3" || row.col0_2 == "Option 4") {
        		mBenefit = formatCurrency( row.col2)+"<sup><span class='fnPage2_GCP' style='font-size: 5px;vertical-align: top'></sup></span>";
        	}
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + row.col0_2 + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-'  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + formatCurrency(row.col2) +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + mBenefit + '</td><td colspan="1">' + ReturnYESNO_ByLang('Yes') + 
            	'</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'CPA'|| row.RiderCode == "PA" ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-'  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + 
            	'</td><td colspan="1">' + formatCurrency(row.col2) + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + 
            	'</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == 'ICR' ){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-'  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + 
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + formatCurrency(row.col2) + '<br/>' + ReturnYESNO_ByLang('per year upon CI/TPD') +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td><td colspan="1">' +
            	ReturnYESNO_ByLang('No') + '</td></tr>');
        }
        else if(row.RiderCode == "TPDYLA"){
            $('#' + tempPage + ' > tbody').append(
            	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + title + '</td><td colspan="1" > ' + '-' + 
            	' </td><td colspan="1" >' +  '-' +  '</td><td colspan="1">' + '-'  + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + formatCurrency(row.col2) + '<br/>' + ReturnYESNO_ByLang('per year upon TPD') +
            	'</td><td colspan="1">' + '-' + '</td><td colspan="1">' + '-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td><td colspan="1">' +
            	ReturnYESNO_ByLang('No') + '</td></tr>');
        }
    });
        
    if(WaiverRider.length > 0){
        var Annual;
        var Semi;
        var Quarterly;
        var Monthly;
        
        var payOptStr;
        if(gdata.SI[0].QuotationLang == "Malay"){
        	payOptStr = '<br/>&nbsp;&nbsp;- Tahunan<br/>&nbsp;&nbsp;- Setengah Tahun<br/>&nbsp;&nbsp;- Suku Tahun<br/>&nbsp;&nbsp;- Bulanan';
        } else {
        	payOptStr = '<br/>&nbsp;&nbsp;- Annually<br/>&nbsp;&nbsp;- Semi-Annually<br/>&nbsp;&nbsp;- Quarterly<br/>&nbsp;&nbsp;- Monthly';
        }
        $('#' + tempPage + '> tbody').append('<tr><td colspan="16" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" ><b>Waiver of Premium Riders</b></td>' + '</tr>');
        
        for (var x = 0; x < WaiverRider.length; x++){
			Annual = formatCurrency(WaiverRider[x].col5);
			Semi = formatCurrency(WaiverRider[x].col6) ;
			Quarterly = formatCurrency(WaiverRider[x].col7);
			Monthly = formatCurrency(WaiverRider[x].col8); 
            
            if(WaiverRider[x].RiderCode == 'CIWP'  ){
                $('#' + tempPage + '> tbody').append(
                	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 0px 2px; width: 12%;vertical-align: top" >' + WaiverRider[x].col0_1 + 
                	payOptStr + '</td><td colspan="1" > ' +
                	'<br/><br/>-<br/>-<br/>-<br/>-' + ' </td><td colspan="1" >' +  '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-'  + 
                	'</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + 
                	'</td><td colspan="1"><br/><br/>' + Annual + '<br/>' + Semi + '<br/>' + Quarterly + '<br/>' + Monthly +
                	'</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' +
                	'<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-'  + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + 
                	'</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1"><br/>' + ReturnYESNO_ByLang('No') + '</td><td colspan="1"><br/>' +
                	ReturnYESNO_ByLang('No') + '</td></tr>');
                	
            } else if(WaiverRider[x].RiderCode == 'SP_STD' ||  WaiverRider[x].RiderCode == 'PR'   ){ 
                $('#' + tempPage + '> tbody').append(
                	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + WaiverRider[x].col0_1 + 
                	payOptStr + '</td><td colspan="1" > ' +
                	'<br/>-<br/>-<br/>-<br/>-' + ' </td><td colspan="1" >' +  '<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + ''  + '<br/>' +
                	Annual + '<br/>' + Semi + '<br/>' + Quarterly + '<br/>' + Monthly  + '</td><td colspan="1">' + '<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' +
                	'<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + ''  + '<br/>-' + '<br/>-' + '<br/>-' + '<br/>-' +
                	'</td><td colspan="1">' + '<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + 
                	'<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/>-<br/>-<br/>-<br/>-'  + '</td><td colspan="1">' + '<br/>-<br/>-<br/>-<br/>-' + 
                	'</td><td colspan="1">' + '<br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td><td colspan="1">' +
                	ReturnYESNO_ByLang('No') + '</td></tr>');
                	
            } else if(WaiverRider[x].RiderCode == 'LCWP' ||  WaiverRider[x].RiderCode == 'SP_PRE' ){                 
                $('#' + tempPage + '> tbody').append(
                	'<tr><td colspan="1" style="text-align:left;padding: 2px 2px 2px 2px; width: 12%;vertical-align: top" >' + WaiverRider[x].col0_1 +
                	payOptStr + '</td><td colspan="1" > ' +
                	'<br/><br/>-<br/>-<br/>-<br/>-' + ' </td><td colspan="1" >' +  '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + ''  + '<br/><br/>' +
                	Annual + '<br/>' + Semi + '<br/>' + Quarterly + '<br/>' + Monthly  + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' +
                	'<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + ''  + '<br/><br/>' +
                	Annual + '<br/>' + Semi + '<br/>' + Quarterly + '<br/>' + Monthly +
                	'</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' +
                	'<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-'  + '</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + 
                	'</td><td colspan="1">' + '<br/><br/>-<br/>-<br/>-<br/>-' + '</td><td colspan="1">' + ReturnYESNO_ByLang('No') + '</td><td colspan="1">' +
                	ReturnYESNO_ByLang('No') + '</td></tr>');                
            }
        }
    }    
}

function loadDataToTable() {	
	var col1str;
	var col5Total = 0.00;
	var col6Total = 0.00;
	var col7Total = 0.00;
	var col8Total = 0.00;
	var col5Total1 = 0;
	var col6Total1 = 0;
	var col7Total1 = 0;
	var col8Total1 = 0;
	
	var showHLoading = false;
	var showOccLoading = false;
	
	var totalPremiumText;
	if (gdata.SI[0].QuotationLang == "Malay") {
		totalPremiumText = "Jumlah Bayaran Premium";
	} else {
		totalPremiumText = "Total Premium";
	}
	
	var LACount = gdata.SI[0].SI_Temp_trad_LA.data.length;
	
	$.each(gdata.SI[0].SI_Temp_Trad_Details.data, function(index, row) {
		if(row.col9 == '' || row.col9 ==  '0.00'){}
		else{
			showHLoading = true;
		}
	
		if(row.col10 == ''){}
		else{
			showOccLoading = true;
		}
	});
	hasLoading = showHLoading | showOccLoading;
	$.each(gdata.SI[0].SI_Temp_Trad_Details.data, function(index, row) {
		if (row.col0_2 != "-Benefit") {
			col5Total1 = parseFloat(col5Total1) + parseFloat((row.col5).replace(/,/g,'').replace('-', '0'));
			col6Total1 = parseFloat(col6Total1) + parseFloat((row.col6).replace(/,/g,'').replace('-', '0'));
			col7Total1 = parseFloat(col7Total1) + parseFloat((row.col7).replace(/,/g ,'').replace('-', '0'));
			col8Total1 = parseFloat(col8Total1) + parseFloat((row.col8).replace(/,/g,'').replace('-', '0'));
		}
	});
	
	var tableName = "table-data";
	var hLoading = "hLoading";
	var occLoading = "occLoading";
	var count = 1;
	$.each(gdata.SI[0].SI_Temp_Trad_Details.data, function(index, row) {
		if (row.col0_2 != "-Benefit") {
			col5Total = parseFloat(col5Total) + parseFloat((row.col5).replace(/,/g,'').replace('-', '0'));
			col6Total = parseFloat(col6Total) + parseFloat((row.col6).replace(/,/g,'').replace('-', '0'));
			col7Total = parseFloat(col7Total) + parseFloat((row.col7).replace(/,/g ,'').replace('-', '0'));
			col8Total = parseFloat(col8Total) + parseFloat((row.col8).replace(/,/g,'').replace('-', '0'));
			if(count == maxRowCount){
				tableName = "table-dataPage2";
				hLoading = "hLoading2";
				occLoading = "occLoading2";
			}
			
			if(!showHLoading){
				if(!showOccLoading){
					addPlanRowNoHLNoOccL(index, row, hLoading, occLoading, tableName, col6Total1, col7Total1, col8Total1, row.col0_1, LACount);
				} else{ 
					addPlanRowNoHL(index, row, hLoading, tableName, col6Total1, col7Total1, col8Total1, row.col0_1, LACount);
				}
			} else{
				if(!showOccLoading){
					addPlanRowNoOccL(index, row, occLoading, tableName, col6Total1, col7Total1, col8Total1, row.col0_1, LACount);
				} else{
					addPlanRow (index, row, tableName, col6Total1, col7Total1, col8Total1, row.col0_1, LACount);
				}
			}
			count++;
		}
	});
	
	$('#' + tableName + '> tfoot').append('<tr><td colspan ="9"><hr/></td></tr>' +
	'<tr>' + 
	'<td></td>' +
	'<td colspan="2" style="text-align:right;padding: 0px 0px 0px 0px;"><b>' + totalPremiumText +'</b></td>' +
	'<td><b>' + formatCurrency(col5Total.toFixed(2)) + '</b></td>' + 
	'<td><b>' + showDashOrValue("s",formatCurrency(col6Total.toFixed(2)),col6Total1) + '</b></td>' +
	'<td><b>' + showDashOrValue("q",formatCurrency(col7Total.toFixed(2)),col7Total1) + '</b></td>' +
	'<td><b>' + showDashOrValue("m",formatCurrency(col8Total.toFixed(2)),col8Total1) + '</b></td>' +
	'<td colspan="2"></td>' +
	'</tr><tr><td colspan ="9"><hr/></td></tr>');
}


function addPlanRowNoHLNoOccL (index, row, hLoading, occLoading, tableName, col6Total1, col7Total1, col8Total1, col1str, LACount) {
	document.getElementById(hLoading).innerHTML = "";
	document.getElementById(hLoading).style.width = "5px";
	document.getElementById(occLoading).innerHTML = "";
	document.getElementById(occLoading).style.width = "5px";
	if(LACount == 1){
		if(row.col0_1 == 'HLA Wealth Plan'){
			$('#' + tableName + '> tbody').append('<tr>' + 
			'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + row.col0_1 + '</td>' +
			'<td>' + row.col3 + '</td>' +
			'<td>' + row.col4 + '</td>' +
			'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
			'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
			'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
			'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
			'<td></td>' +
			'<td></td>' +
			'</tr>');
		} else {							
			$('#' + tableName + '> tbody').append('<tr>' + 
			'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(col1str) + '</td>' +
			'<td>' + row.col3 + '</td>' +
			'<td>' + row.col4 + '</td>' +
			'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
			'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
			'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
			'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
			'<td></td>' +
			'<td></td>' +
			'</tr>');
		}
	} else{
		if(row.col0_1 == 'HLA Wealth Plan'){
			$('#' + tableName + '> tbody').append('<tr>' + 
			'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + row.col0_1 + '</td>' +
			'<td>' + row.col3 + '</td>' +
			'<td>' + row.col4 + '</td>' +
			'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
			'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
			'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
			'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
			'<td></td>' +
			'<td></td>' +
			'</tr>');
		} else{
			$('#' + tableName + '> tbody').append('<tr>' + 
			'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(col1str) + '</td>' +
			'<td>' + row.col3 + '</td>' +
			'<td>' + row.col4 + '</td>' +
			'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
			'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
			'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
			'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
			'<td></td>' +
			'<td></td>' +
			'</tr>');
		}						    
	}
}

function addPlanRowNoHL (index, row, hLoading, tableName, col6Total1, col7Total1, col8Total1, col1str, LACount) {
	document.getElementById(hLoading).innerHTML = "";
	document.getElementById(hLoading).style.width = "5px";
	if(LACount == 1){
		$('#' + tableName + '> tbody').append(
		'<tr>' + 
		'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(col1str) + '</td>' +
		'<td>' + row.col3 + '</td>' +
		'<td>' + row.col4 + '</td>' +
		'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
		'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
		'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
		'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
		'<td></td>' +
		'<td>' + row.col10 + '</td>' + 
		'</tr>');
	} else{
		$('#' + tableName + '> tbody').append('<tr>' + 
		'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(col1str) + '</td>' +
		'<td>' + row.col3 + '</td>' +
		'<td>' + row.col4 + '</td>' +
		'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
		'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
		'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
		'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
		'<td></td>' +
		'<td>' + row.col10 + '</td>' +
		'</tr>');
	}
}

function addPlanRowNoOccL (index, row, occLoading, tableName, col6Total1, col7Total1, col8Total1, col1str, LACount) {
	document.getElementById(occLoading).innerHTML = "";
	document.getElementById(occLoading).style.width = "5px";
	if(LACount == 1){
		$('#' + tableName + '> tbody').append('<tr>' + 
		'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(col1str) + '</td>' +
		'<td>' + row.col3 + '</td>' +
		'<td>' + row.col4 + '</td>' +
		'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
		'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
		'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
		'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
		'<td style="vertical-align:text-top;">' + row.col9 + '</td>' + 
		'<td></td>' +
		'</tr>');
	} else{
		$('#' + tableName + '> tbody').append('<tr>' + 
		'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(col1str) + '</td>' +
		'<td>' + row.col3 + '</td>' +
		'<td>' + row.col4 + '</td>' +
		'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
		'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
		'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
		'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
		'<td style="vertical-align:text-top;">' + row.col9 + '</td>' + 
		'<td></td>' +
		'</tr>');
	}
}

function addPlanRow (index, row, tableName, col6Total1, col7Total1, col8Total1, col1str, LACount) {
	if(LACount == 1){ 
		$('#' + tableName + '> tbody').append('<tr>' + 
		'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(col1str) + '</td>' +
		'<td>' + row.col3 + '</td>' + '<td>' + row.col4 + '</td>' +
		'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
		'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
		'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
		'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
		'<td style="vertical-align:text-top;">' + row.col9 + '</td><td>' + row.col10 + '</td>' + 
		'</tr>');
	} else{
		$('#' + tableName + '> tbody').append('<tr>' + 
		'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(col1str) + '</td>' +
		'<td>' + row.col3 + '</td>' + '<td>' + row.col4 + '</td>' +
		'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
		'<td id=row1col6>' + showDashOrValue("s",formatCurrency(row.col6),col6Total1) + '</td>' +
		'<td id=row1col7>' + showDashOrValue("q",formatCurrency(row.col7),col7Total1) + '</td>' +
		'<td id=row1col8>' + showDashOrValue("m",formatCurrency(row.col8),col8Total1) + '</td>' +
		'<td style="vertical-align:text-top;">' + row.col9 + '</td><td>' + row.col10 + '</td>' + 
		'</tr>');
	}
}

function loadHLAWPPage1_2()
{
    var result = gdata.SI[0].SI_Temp_trad_LA.data;
    
	var col5Total, col6Total, col7Total, col8Total;
	col5Total = 0.00;
	col6Total = 0.00;
	col7Total = 0.00;
	col8Total = 0.00;

	var showHLoading = false;
	var showOccLoading = false;
	
	$.each(gdata.SI[0].SI_Temp_Trad_Details.data, function(index, row) {
	  
		if(index  + parseInt(AddRow) > 13){
			if(row.col9 != '' && row.col9 != '0.00'){
				showHLoading = true;
			}
  
			if(row.col10 != '' && row.col10 != '0.00'){
				showOccLoading = true;
			}
		}
	});
	
	var totalPremiumText;
	if (gdata.SI[0].QuotationLang == "Malay")
	{
		totalPremiumText = "Jumlah Bayaran Premium";
	} else {
		totalPremiumText = "Total Premium";
	}
	
	$.each(gdata.SI[0].SI_Temp_Trad_Details.data, function(index, row) {
		col5Total = parseFloat(col5Total) + parseFloat((row.col5).replace(/,/g,'').replace('-', '0'));
		col6Total = parseFloat(col6Total) + parseFloat((row.col6).replace(/,/g,'').replace('-', '0'));
		col7Total = parseFloat(col7Total) + parseFloat((row.col7).replace(/,/g ,'').replace('-', '0'));
		col8Total = parseFloat(col8Total) + parseFloat((row.col8).replace(/,/g,'').replace('-', '0'));
		
		if(index > maxRowCount){
			if(showHLoading == false){				  
			  if(showOccLoading == false){					
					document.getElementById('hLoading2').innerHTML = "";
					document.getElementById('hLoading2').style.width = "5px";
					document.getElementById('occLoading2').innerHTML = "";
					document.getElementById('occLoading2').style.width = "5px";
				
					if(result.length == 1){
						if(row.col0_1 == 'HLA Wealth Plan'){							  
							$('#table-dataPage2 > tbody').append('<tr>' + 
							'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + row.col0_1 + '</td>' +
							'<td>' + row.col3 + '</td>' +
							'<td>' + row.col4 + '</td>' +
							'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
							'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
							'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
							'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
							'<td></td>' + 
							'<td></td>' +
							'</tr>');
						} else{							  
							$('#table-dataPage2 > tbody').append('<tr>' +
							'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(row.col0_1) + '</td>' +
							'<td>' + row.col3 + '</td>' +
							'<td>' + row.col4 + '</td>' +
							'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
							'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
							'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
							'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
							'<td></td>' + 
							'<td></td>' +
							'</tr>');
						}							
					} else {							
						if(row.col0_1 == 'HLA Wealth Plan'){
							$('#table-dataPage2 > tbody').append('<tr>' + 
							 '<td style="text-align:left;padding: 0px 0px 0px 0px;">' + row.col0_1 + '</td>' +
							'<td>' + row.col3 + '</td>' +
							'<td>' + row.col4 + '</td>' +
							'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
							'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
							'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
							'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
							'<td></td>' +
							'<td></td>' +
							'</tr>');
						} else {
							$('#table-dataPage2 > tbody').append('<tr>' + 
							'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(row.col0_1) + '</td>' +
							'<td>' + row.col3 + '</td>' +
							'<td>' + row.col4 + '</td>' +
							'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
							'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
							'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
							'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
							'<td></td>' +
							'<td></td>' +
							'</tr>');
						}							
					}
			  } else { //occloading == true, hl == false						
					document.getElementById('hLoading2').innerHTML = "";
					document.getElementById('hLoading2').style.width = "5px";
					if(result.length == 1){
						$('#table-dataPage2 > tbody').append('<tr>' + 
						'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(row.col0_1) + '</td>' +
						'<td>' + row.col3 + '</td>' +
						'<td>' + row.col4 + '</td>' +
						'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
						'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
						'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
						'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
						'<td></td>' + 
						'<td>' + row.col10 + '</td>' + 
						'</tr>');
					} else {
						$('#table-dataPage2 > tbody').append('<tr>' + 
						'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(row.col0_1) + '</td>' +
						'<td>' + row.col3 + '</td>' +
						'<td>' + row.col4 + '</td>' +
						'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
						'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
						'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
						'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
						'<td></td>' +
						'<td>' + row.col10 + '</td>' + 
						'</tr>');
					}
				}
			} else {				  
				var HL;
				if(parseInt(row.col9) > 0){
					if(row.col9 % 1 == 0){
						HL = parseInt(row.col9);
					} else {
						HL = row.col9;
					}
				} else {
					HL = "";
				}
		  
				if(showOccLoading == false){						
					document.getElementById('occLoading2').innerHTML = "";
					document.getElementById('occLoading2').style.width = "5px";
					if(result.length == 1){
						$('#table-dataPage2 > tbody').append('<tr>' + 
						'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(row.col0_1) + '</td>' +
						'<td>' + row.col3 + '</td>' +
						'<td>' + row.col4 + '</td>' +
						'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
						'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
						'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
						'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
						'<td>' + HL + '</td>' +
						'<td></td>' + 
						'</tr>');
					} else {
						$('#table-dataPage2 > tbody').append('<tr>' + 
						'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(row.col0_1) + '</td>' +
						'<td>' + row.col3 + '</td>' +
						'<td>' + row.col4 + '</td>' +
						'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
						'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
						'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
						'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
						'<td>' + HL + '</td>' +
						'<td></td>' + 
						'</tr>');
					}
				} else {
					if(result.length == 1){ 
						$('#table-dataPage2 > tbody').append('<tr>' + 
						'<td style="text-align:left;padding: 0px 0px 0px 5px;">' + needItalic(row.col0_1) + '</td>' +
						'<td>' + row.col3 + '</td>' + '<td>' + row.col4 + '</td>' +
						'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
						'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
						'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
						'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
						'<td>' + HL + '</td>' + 
						'<td>' + row.col10 + '</td>' + 
						'</tr>');
					} else {
						$('#table-dataPage2 > tbody').append('<tr>' + 
						'<td style="text-align:left;padding: 0px 0px 0px 0px;">' + needItalic(row.col0_1) + '</td>' +
						'<td>' + row.col3 + '</td>' + '<td>' + row.col4 + '</td>' +
						'<td><span id=row' + index + 'col5>' + formatCurrency(row.col5) + '</span></td>' +
						'<td id=row1col6>' + formatCurrency(row.col6) + '</td>' +
						'<td id=row1col7>' + formatCurrency(row.col7) + '</td>' +
						'<td id=row1col8>' + formatCurrency(row.col8) + '</td>' +
						'<td>' + HL + '</td>' +
						'<td>' + row.col10 + '</td>' +
						'</tr>');
					}
				}
			}
			i++;
		}
	  
	});
	
	$('#table-dataPage2 > tfoot').append('<tr><td colspan ="9"><hr/></td></tr>' +
	'<tr>' +
	'<td></td>' +
	'<td colspan="2" style="text-align:right;padding: 0px 0px 0px 0px;"><b>' + totalPremiumText + '</b></td>' +
	'<td><b>' + formatCurrency(col5Total.toFixed(2)) + '</b></td>' +
	'<td><b>' + formatCurrency(col6Total.toFixed(2)) + '</b></td>' +
	'<td><b>' + formatCurrency(col7Total.toFixed(2)) + '</b></td>' +
	'<td><b>' + formatCurrency(col8Total.toFixed(2)) + '</b></td>' +
	'<td colspan="2" ></td>' +
	'</tr><tr><td colspan ="9"><hr/></td></tr>');
	
}

function buildRiderList() {
	var riderList = [];
	if (WBRider) {
		riderList[riderList.length] = "Wealth Booster Rider";
	}
    if (WBM6R) {
    	 riderList[riderList.length] = "Wealth Booster-<i>m6</i> Rider";
    }
	if (WBi6) {
		riderList[riderList.length] = "Wealth Booster-<i>i6</i> Rider";
	}
    if (WBd10) {
    	 riderList[riderList.length] = "Wealth Booster-<i>d10</i> Rider";
    }
    if (EduWB) {
    	 riderList[riderList.length] = "EduWealth Rider";
    } 
    var riders = "";
    for (var i=0; i<riderList.length; i++) {
		if (i == riderList.length - 1) {
			riders = riders + " & ";
		} else {
			riders = riders + ", ";
		}
    	riders = riders + riderList[i];
    }
    return riders;
}

function buildRiderList2() {
	var riderList = []; 
	if (WB30Rider) {
    	if(gdata.SI[0].QuotationLang == "Malay"){
			riderList[riderList.length] = "Wealth Booster Rider (30 tahun)";
		} else {
			riderList[riderList.length] = "Wealth Booster Rider (30 years)";
		}
	} 
    if (WBM6R) {
    	 riderList[riderList.length] = "Wealth Booster-<i>m6</i> Rider";
    }
	if (WBi6) {
		riderList[riderList.length] = "Wealth Booster-<i>i6</i> Rider";
	}
    if (WBd10) {
    	 riderList[riderList.length] = "Wealth Booster-<i>d10</i> Rider";
    }
    var riders = "";
    for (var i=0; i<riderList.length; i++) {
    	if (i > 0) {
    		if (i == riderList.length - 1) {
				riders = riders + " & ";
    		} else {
    			riders = riders + ", ";
    		}
    	}
    	riders = riders + riderList[i];
    }
    return riders;
}

function writeHLAWP_Summary() {   
    $('.TotPremPaid2').html(formatCurrency(gdata.SI[0].SI_Temp_Trad_Overall.data[0].TotPremPaid2));
    $('.SurrenderValueHigh2').html(formatCurrency(gdata.SI[0].SI_Temp_Trad_Overall.data[0].SurrenderValueHigh2));
    $('.SurrenderValueLow2').html(formatCurrency(gdata.SI[0].SI_Temp_Trad_Overall.data[0].SurrenderValueLow2));
    
    $('.TotPremPaid1').html(formatCurrency(gdata.SI[0].SI_Temp_Trad_Overall.data[0].TotPremPaid1));
    $('.SurrenderValueHigh1').html(formatCurrency(gdata.SI[0].SI_Temp_Trad_Overall.data[0].SurrenderValueHigh1));
    $('.SurrenderValueLow1').html(formatCurrency(gdata.SI[0].SI_Temp_Trad_Overall.data[0].SurrenderValueLow1));
    $('.TotYearlyIncome1').html(formatCurrency(gdata.SI[0].SI_Temp_Trad_Overall.data[0].TotYearlyIncome1));
    
    var tempTitle = "HLA Wealth Plan";
    var tempTitle2 = "";
    var note2 = "";
    var riders = buildRiderList();  
    tempTitle = tempTitle + riders;
    
    if (WBM6R) {
        if(gdata.SI[0].QuotationLang == "Malay"){
	    	tempTitle2 = tempTitle2 + "Kupon Tunai Bulanan";
	    } else {
	    	tempTitle2 = tempTitle2 + "Monthly Cash Coupons";
	    }
    }
    if (WBRider || WBi6 || WBd10) {
    	if (tempTitle2.length > 0) {
    		tempTitle2 = tempTitle2 + " / ";
    	}
        if(gdata.SI[0].QuotationLang == "Malay"){
	    	tempTitle2 = tempTitle2 + "Kupon Tunai Tahunan";
	    } else {
	    	tempTitle2 = tempTitle2 + "Yearly Cash Coupons";
	    }
    }
    if (EduWB) {
    	if (tempTitle2.length > 0) {
    		tempTitle2 = tempTitle2 + " / ";
    	}
        
        if(gdata.SI[0].QuotationLang == "Malay"){
    		tempTitle2 = tempTitle2 + "Bayaran Tunai";
        } else {
    		tempTitle2 = tempTitle2 + "Cash Payments";
        }
    }
    if (riders.length > 0 || EduWB) {
		var riders2 = buildRiderList2();
        if(gdata.SI[0].QuotationLang == "Malay"){
    		note2 = note2 + "Apabila tempoh ";
    	} else {
    		note2 = note2 + "Upon expiry of ";
    	}
    	
    	if (riders2.length > 0) {
			note2 = note2 + riders2;
		
			if(gdata.SI[0].QuotationLang == "Malay"){
				note2 = note2 + " tamat pada tahun 30";
			} else {
				note2 = note2 + " at year 30";
			}
        } 
        
        if (EduWB) {
  			if (riders2.length > 0) {
       			if(gdata.SI[0].QuotationLang == "Malay"){
    				note2 = note2 + " dan ";
       			} else {
    				note2 = note2 + " and ";
  				}
  			}
  			note2 = note2 + "EduWealth Rider";
  			
       		if(gdata.SI[0].QuotationLang == "Malay"){
       			note2 = note2 + " tamat pada tahun " + (21 - parseInt(gdata.SI[0].SI_Temp_trad_LA.data[0].Age) );       			
       		} else {
       			note2 = note2 + " at year " + (21 - parseInt(gdata.SI[0].SI_Temp_trad_LA.data[0].Age) );
       		}
  		}
  		
       	if(gdata.SI[0].QuotationLang == "Malay"){
  			note2 = note2 + ", Dividen Terminal bagi rider masing-masing akan dibayar.";
       	} else {
  			note2 = note2 + ", the Terminal Dividend of the respective rider(s) will be paid out.";
  		}
    }    
    
    if (WBM6R || EduWB || WBRider || WBi6 || WBd10) {
       	if(gdata.SI[0].QuotationLang == "Malay"){
       		tempTitle2 = tempTitle2 + "<br/>(Amaun Kumulatif bagi setiap Tahun)";
       	} else {
       		tempTitle2 = tempTitle2 + "<br/>(Cumulative Amount for the Year)";
       	}
    }
    
    $('.SummaryTitle').html(tempTitle);
    $('.WPRiderTitle').html(tempTitle2);
    
    if(parseInt(gdata.SI[0].Trad_Details.data[0].PolicyTerm) == 50){
        if(WB30Rider == true || EduWB ==  true || WBd10 || WBi6 ){
            $('.HLAWP_summary_Page3_note2').html('2. ' + note2);    
        }
        else{
            $('.HLAWP_summary_Page3_note2').html('');    
        }
    } else {
        if(EduWB ==  true){
            if(gdata.SI[0].QuotationLang == "Malay"){
                note2 = "Apabila tempoh EduWealth Rider tamat pada tahun " + 
                (21 - parseInt(gdata.SI[0].SI_Temp_trad_LA.data[0].Age) )  + ", Dividen Terminal bagi rider masing-masing akan dibayar.";
            }
            else{
               note2 = "Upon expiry of EduWealth Rider at year " +
               (21 - parseInt(gdata.SI[0].SI_Temp_trad_LA.data[0].Age) )  + ", the Terminal Dividend of the respective rider(s) will be paid out.";
            }            
            $('.HLAWP_summary_Page3_note2').html('2. ' + note2);
        }
        else
        {
            $('.HLAWP_summary_Page3_note2').html('');        
        }        
    }
    
    $.each(gdata.SI[0].SI_Temp_Trad_Summary.data, function(index, row) {
    	$('#table-SummaryHLAWP > tbody').append('<tr><td>' +
    		row.col0_1 + '</td><td>' + row.col0_2 + '</td><td>' + formatCurrency(row.col1) + '</td><td>' + formatCurrency(row.col2) + '</td><td>' + formatCurrency(row.col3) + '</td><td>' +
    		formatCurrency(row.col4) + '</td><td>' + CurrencyNoCents(row.col5) + '</td><td>' + CurrencyNoCents(row.col6) + '</td><td>' + CurrencyNoCents(row.col7) + '</td><td>' +
    		CurrencyNoCents(row.col8) + '</td><td>' + CurrencyNoCents(row.col9) + '</td><td>' + CurrencyNoCents(row.col10) + '</td><td>' +
    		CurrencyNoCents(row.col11) + '</td></tr>');
            
		if (colType == 1) { // CD: ACC, GYI : Payout
			$('#table-SummaryHLAWP3 > tbody').append('<tr><td>' + row.col0_1 + '</td><td>' + row.col0_2 + '</td><td>' + CurrencyNoCents(row.col12) + '</td><td>' + CurrencyNoCents(row.col13) + '</td><td>' +
				CurrencyNoCents(row.col14) + '</td><td>' + CurrencyNoCents(row.col15) + '</td><td>' + CurrencyNoCents(row.col18) + '</td><td>' + CurrencyNoCents(row.col19) + '</td><td>' +
				CurrencyNoCents(row.col20) + '</td><td>' + CurrencyNoCents(row.col21) + '</td></tr>');
		}
		else if (colType == 2) { // CD: ACC, GYI : ACC
			$('#table-SummaryHLAWP3 > tbody').append('<tr><td>' + row.col0_1 + '</td><td>' + row.col0_2 + '</td><td>' + CurrencyNoCents(row.col12) + '</td><td>' + CurrencyNoCents(row.col13) + '</td><td>' + 
				CurrencyNoCents(row.col14) + '</td><td>' + CurrencyNoCents(row.col15) + '</td><td>' + CurrencyNoCents(row.col16) + '</td><td>' + CurrencyNoCents(row.col17) + '</td><td>' +
				CurrencyNoCents(row.col18) + '</td><td>' + CurrencyNoCents(row.col19) + '</td><td>' + CurrencyNoCents(row.col20) + '</td><td>' + CurrencyNoCents(row.col21) + '</td></tr>');
		}
		else if (colType == 3) { // CD: Payout, GYI : Payout
			$('#table-SummaryHLAWP3 > tbody').append('<tr><td>' + row.col0_1 + '</td><td>' + row.col0_2 + '</td><td>' + CurrencyNoCents(row.col12) + '</td><td>' + CurrencyNoCents(row.col13) + '</td><td>' +
				CurrencyNoCents(row.col18) + '</td><td>' + CurrencyNoCents(row.col19) + '</td><td>' + CurrencyNoCents(row.col20) + '</td><td>' + CurrencyNoCents(row.col21) + '</td></tr>');   
		}
		else if (colType == 4) {  // CD: Payout, GYI : ACC
			   $('#table-SummaryHLAWP3 > tbody').append('<tr><td>' + row.col0_1 + '</td><td>' + row.col0_2 + '</td><td>' + CurrencyNoCents(row.col12) + '</td><td>' + CurrencyNoCents(row.col13) + '</td><td>' + 
			   CurrencyNoCents(row.col16) + '</td><td>' + CurrencyNoCents(row.col17) + '</td><td>' + CurrencyNoCents(row.col18) + '</td><td>' + CurrencyNoCents(row.col19) + '</td><td>' +
			   CurrencyNoCents(row.col20) + '</td><td>' + CurrencyNoCents(row.col21) + '</td></tr>');
		}
    });
}

function writeFootnote_HLAWP(){
    var a = 1;
    var fnPage2_GYCC = false;
    var fnPage2_GMCC = false;
    var fnPage2_GCP = false;
    var fnPage2_ACIR = false;
    var fnPage2_LCPR = false;
    var fnPage2_PLCP = false;
    var fnPage2_EDU = false;
    
    var fnPage35_GYCC = false;
    var fnPage35_GMCC = false;
    var fnPage35_GCP = false;
    var fnPage35_ACIR = false;
    var fnPage35_LCPR = false;
    var fnPage35_CIR = false;
    
    var SecondOrPayorRider = []; 
    var elementId;
    var showSummaryBenefitText = false;
    
    if(hasLoading) {
		$('.fnPage2_Amt').html('[' + a + ']');
		a++;
		
		for (i=2; --i>=0; ) {
			elementId = 'Amount' + (i+1);
			if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
			}
		}
    }
    
    $('.fnPage2_PremiumPaid').html('[' + a + ']');
    a++;
    $.each(gdata.SI[0].Trad_Rider_Details.data, function(index, row) { //for benefit table        
        if(row.RiderCode == 'ACIR'){
            $('.fnPage2_ACIR').html('[' + a + ']');
            a++;
            fnPage2_ACIR = true;
        }
        else if(row.RiderCode == 'C+' && (row.PlanOption.indexOf("_NCB") == row.PlanOption.length - 4)) {
			fnPage2_GCP = true;
			$('.fnPage2_GCP').append('[' + a + ']');
			a++;
        }
        else if(row.RiderCode == 'EDUWR'){
        	fnPage2_EDU = true;
        	$('.fnPage2_EDU').append('[' + a + ']');
        	a++;
            if (!showSummaryBenefitText) {
            	showSummaryBenefitText = parseInt(gdata.SI[0].Trad_Details.data[0].PolicyTerm) > parseInt(row.RiderTerm);
            }
        }
        else if(row.RiderCode == 'WB30R' || row.RiderCode == 'WB50R' || row.RiderCode == 'WBI6R30' || row.RiderCode == 'WBD10R30' ){
            if (fnPage2_GYCC == false){
                $('.fnPage2_GYCC').html('[' + a + ']');
                a++;
                fnPage2_GYCC = true;
            }
            
            if (!showSummaryBenefitText) {
            	showSummaryBenefitText = parseInt(gdata.SI[0].Trad_Details.data[0].PolicyTerm) > parseInt(row.RiderTerm);
            }
        }
        else if(row.RiderCode == 'WBM6R' ){
            if (fnPage2_GMCC == false){
                $('.fnPage2_GMCC').html('[' + a + ']');
                a++;
                fnPage2_GMCC = true;
            }
            if (!showSummaryBenefitText) {
            	showSummaryBenefitText = parseInt(gdata.SI[0].Trad_Details.data[0].PolicyTerm) > parseInt(row.RiderTerm);
            }
        }
        else if(row.RiderCode == 'LCPR' ){
            if (fnPage2_LCPR == false){
                $('.fnPage2_LCPR').html('[' + a + ']');
                a++;
                fnPage2_LCPR = true;
            }
        }
        else if(row.RiderCode == 'PLCP' ){
            if (fnPage2_PLCP == false){
                $('.fnPage2_PLCP').html('[' + a + ']');
                a++;
                fnPage2_PLCP = true;
            }
        }
    });
    
	for (i=3; --i>=0; ) {
		elementId = 'fnPageBenefit' + (i+1) + '_PremiumPaid';
		if (document.getElementById(elementId) != null) {
			document.getElementById(elementId).style.display = "";
			document.getElementById('fnPageBenefit' + (i+1) + '_note').style.display = "";
			break;
		}
	} 	
    if(fnPage2_ACIR){
    	for (i=3; --i>=0; ) {
    		elementId = 'fnPageBenefit' + (i+1) + '_ACIR';
    		if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
    		}
    	}
	}

	if(fnPage2_GYCC){
    	for (i=3; --i>=0; ) {
    		elementId = 'fnPageBenefit' + (i+1) + '_GYCC';
    		if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
    		}
    	}
	}

	if(fnPage2_GMCC){
    	for (i=3; --i>=0; ) {
    		elementId = 'fnPageBenefit' + (i+1) + '_GMCC';
    		if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
    		}
    	}
	}

	if(fnPage2_GCP){
    	for (i=3; --i>=0; ) {
    		elementId = 'fnPageBenefit' + (i+1) + '_GCP';
    		if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
    		}
    	}
	}

	if(fnPage2_EDU){
    	for (i=3; --i>=0; ) {
    		elementId = 'fnPageBenefit' + (i+1) + '_EDU';
    		if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
    		}
    	}
	}

	if(fnPage2_LCPR){
    	for (i=3; --i>=0; ) {
    		elementId = 'fnPageBenefit' + (i+1) + '_LCPR';
    		if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
    		}
    	}
	}

	if(fnPage2_PLCP){
    	for (i=3; --i>=0; ) {
    		elementId = 'fnPageBenefit' + (i+1) + '_PLCP';
    		if (document.getElementById(elementId) != null) {
				document.getElementById(elementId).style.display = "";
				break;
    		}
    	}
	}

    //for basic Page
	$('.fnPageBasic_DB').html('[' + a + ']');
	a++;
	
    if (fnPage2_GYCC || fnPage2_GMCC) {
		if ($.trim(gdata.SI[0].Trad_Details.data[0].CashDividend) == 'ACC') 
		{
			$('.fnPageWB30R_SV').html('[' + a + ']');
			a++;
		} else if (gdata.SI[0].Trad_Details.data[0].CashDividend == 'POF') {
			if (parseInt(gdata.SI[0].Trad_Details.data[0].PartialPayout) != 100) { //CD : Payout GYI : Payout           
				$('.fnPageWB30R_SV').html('[' + a + ']');
				a++;
			}
		}
		//for WB Riders
		if (gdata.SI[0].Trad_Details.data[0].YearlyIncome == "ACC") {
			if(fnPage2_GYCC == true || fnPage2_GCP == true || fnPage2_EDU == true ){
				$('.fnPageWB30R_AYCC').html('[' + a + ']');
				a++;
			}
		}
    }
    
	if (document.getElementById("WBSummary") != null) {		
		if (showSummaryBenefitText) {
			$('.fnPageWBSummary').html('[' + a + ']');
		 	a++;
		} else {
			document.getElementById("WBSummary").style.display= "none";
		}
	}
    // for other riders desc
    $.each(gdata.SI[0].Trad_Rider_Details.data, function(index, row) {        
        
        if(row.RiderCode == 'ACIR'){
			$('.fnPage35_ACIR').html('[' + a + ']');
			$('.fnPage35_CIR').html('[' + a + ']');
			a++;
			fnPage35_ACIR = true;
			fnPage35_CIR = true;
        }
        else if(row.RiderCode == 'CIR' && !fnPage35_CIR){  
			fnPage35_CIR = true;
			$('.fnPage35_CIR').html('[' + a + ']');
			a++;
        }
        else if(row.RiderCode == 'CIWP'){
            $('.fnPage35_CIWP').html('[' + a + ']');
            a++;
        }
        else if(row.RiderCode == 'ICR'){
            $('.fnPage35_ICR').html('[' + a + ']');
            a++;
        }
        else if(row.RiderCode == 'LCPR'){
            $('.fnPage35_LCPR').html('[' + a + ']');
            a++;
        }
        else if(row.RiderCode == 'PLCP'){
            $('.fnPage35_PLCP').html('[' + a + ']');
        	a++;
        }
        else if(row.RiderCode == 'LCWP'){
            SecondOrPayorRider.push('LCWP');    
        }
        else if(row.RiderCode == 'SP_PRE'){
            SecondOrPayorRider.push('SP_PRE');
        }
        
    });
    
	if(SecondOrPayorRider.length > 0){
		if(SecondOrPayorRider[0] == 'LCWP'){
		$('.fnPage35_LCWP').html('[' + a + ']');
		 a++;
		 
		}
		else if(SecondOrPayorRider[0] == 'SP_PRE'){
			$('.fnPage35_SPPRE').html('[' + a + ']');
			a++;
		}   
	}
	
	$('.fnPage40_IRR').html('[' + a + ']');
	a++;    
}

function loadSummaryBenefit() 
{
	var payoutGuaranteed = 0;	
	var payoutNotGuaranteedA = 0;
	var payoutNotGuaranteedB = 0;
	var payoutTotalA = 0;
	var payoutTotalB = 0;
	
	var accGuaranteed = 0;
	var totalPayoutEndA = 0;
	var totalPayoutEndB = 0;
	var accTotalA = 0;
	var accTotalB = 0;
	
	var totalGuaranteed = 0;
	var totalNotGuaranteedA = 0;
	var totalNotGuaranteedB = 0;
	var totalAllPayoutA = 0;
	var totalAllPayoutB = 0;
	
	var totalPremiumPaid = 0;
	if (gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit != null) {
		payoutGuaranteed = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.payoutGuaranteed;	
		payoutNotGuaranteedA = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.payoutNotGuaranteedA;
		payoutNotGuaranteedB = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.payoutNotGuaranteedB;
		payoutTotalA = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.payoutTotalA;
		payoutTotalB = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.payoutTotalB;
		accGuaranteed = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.accGuaranteed;
		
		totalPayoutEndA = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.totalPayoutEndA;
		totalPayoutEndB = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.totalPayoutEndB;
		accTotalA = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.accTotalA;
		accTotalB = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.accTotalB;
	
		totalGuaranteed = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.totalGuaranteed;
		totalNotGuaranteedA = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.totalNotGuaranteedA;
		totalNotGuaranteedB = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.totalNotGuaranteedB;
		totalAllPayoutA = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.totalAllPayoutA;
		totalAllPayoutB = gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.totalAllPayoutB;
	
		totalPremiumPaid = gdata.SI[0].SI_Temp_Trad_Overall.data[0].TotPremPaid2;
		if (gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.maturedRider != null) {
			processMaturedRiders(gdata.SI[0].SI_Temp_WealthGYIRider_Summary_Benefit.maturedRider);
		}
	}
	
	$('#policyTerm').html(gdata.SI[0].Trad_Details.data[0].PolicyTerm);
	
	$('#payoutGuaranteed').html(CurrencyNoCents(payoutGuaranteed));
	$('#payoutNotGuaranteedA').html(CurrencyNoCents(payoutNotGuaranteedA));
	$('#payoutNotGuaranteedB').html(CurrencyNoCents(payoutNotGuaranteedB));	
	$('#payoutTotalA').html(CurrencyNoCents(payoutTotalA));
	$('#payoutTotalB').html(CurrencyNoCents(payoutTotalB));	
	
	$('#accGuaranteed').html(CurrencyNoCents(accGuaranteed));
	$('#totalPayoutEndA').html(CurrencyNoCents(totalPayoutEndA));
	$('#totalPayoutEndB').html(CurrencyNoCents(totalPayoutEndB));	
	$('#accTotalA').html(CurrencyNoCents(accTotalA));
	$('#accTotalB').html(CurrencyNoCents(accTotalB));	
	
	$('#totalGuaranteed').html(CurrencyNoCents(totalGuaranteed));
	$('#totalNotGuaranteedA').html(CurrencyNoCents(totalNotGuaranteedA));
	$('#totalNotGuaranteedB').html(CurrencyNoCents(totalNotGuaranteedB));	
	$('#totalAllPayoutA').html(CurrencyNoCents(totalAllPayoutA));
	$('#totalAllPayoutB').html(CurrencyNoCents(totalAllPayoutB));
	
	$('#totalPremiumPaid').html(formatCurrency(totalPremiumPaid));	
}

function processMaturedRiders(maturedRider) 
{
	var content = '';
	current = 3;
	var temp;
	$.each(maturedRider, function(index, row) {
		content = '<tr><td';
		if (index == 0) {
			content = content + ' rowspan="' + maturedRider.length + '" style="text-align:center; vertical-align:text-top;width:25%;padding:2px;">';
			if (gdata.SI[0].QuotationLang == "Malay") {
				content = content + 'Dibayar apabila Kematangan Rider (bagi Rider yang matang sebelum Kematangan Pelan Asas)';
			} else {
				content = content + 'Terminal Dividend Payout upon Riders’ Maturity (for Riders that mature prior to the Basic Policy’s Maturity)';
			}
			content = content + '<td';
		}
		content = content + ' style="text-align:left;padding:2px;">' + row.rider + '</td><td>' + row.guaranteed + '</td>' + 
					'<td>' + CurrencyNoCents(row.ngSceA) + '</td><td>' + CurrencyNoCents(row.ngSceB) + '</td>' + 
					'<td class="cell_color_grey">' + CurrencyNoCents(row.totalSceA) + '</td>' + 
					'<td class="cell_color_grey">' + CurrencyNoCents(row.totalSceB) + '</td>' +
					'</tr>';
		temp = document.getElementById('table-SummaryHLAWP2').insertRow(current);
		current++;
		temp.innerHTML = content;
	});
// 	$('#maturedRider').html(content);	
}

function setRiderText()
{
	if (document.getElementById('disclaimer_2') != null) {
   		document.getElementById('Page1withRiders').style.display= "none";
// 		document.getElementById('Page1Figures').style.display= "none";
		document.getElementById('disclaimer').style.display = "none";
		document.getElementById('GIRR').style.display = "none";
		document.getElementById('HLAWPMain').style.height="370px";
	}
	
	if(gdata.SI[0].Trad_Details.data[0].GIRR == '1'){
		document.getElementById('GIRR').style.display= "";        
	}
}
