//
//  SPAJThirdParty.h
//  BLESS
//
//  Created by Basvi on 9/28/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User Interface.h"
#import "SegmentSPAJ.h"
#import "TextFieldSPAJ.h"
#import "ButtonSPAJ.h"
#import "TextViewSPAJ.h"
#import "AllAboutPDFFunctions.h"
#import "HtmlGenerator/HtmlGenerator.h"

@interface SPAJThirdParty : HtmlGenerator{
    NSString *filePath;
    
    UserInterface *functionUserInterface;
    AllAboutPDFFunctions *allAboutPDFFunctions;
    
    
    IBOutlet UIScrollView *scrollViewForm;
    IBOutlet UIStackView *stackViewForm;
    
    //view B
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyAsking;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyAskingRelationship;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyPremiPayor;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyPremiPayorRelationship;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyBeneficiary;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyBeneficiaryRelationship;
    
    IBOutlet TextFieldSPAJ* TextThirdPartyAskingRelationshipOther; //textSebutkan
    IBOutlet TextFieldSPAJ* TextThirdPartyPremiPayorRelationshipOther;//textSebutkan
    IBOutlet TextFieldSPAJ* TextThirdPartyBeneficiaryRelationshipOther; //textSebutkan
    
    //view C
    //IBOutlet SegmentSPAJ*
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyNationality;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyUSACitizen;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartySex;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyMaritalStatus;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyReligion;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCorrespondanceAddress;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyRelationAssured;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartySalary;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyRevenue;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyOtherIncome;
    
    IBOutlet ButtonSPAJ* DateThirdPartyActive;
    IBOutlet ButtonSPAJ* DateThridPartyBirth;
    //IBOutlet ButtonSPAJ* //tanggal npwp
    
    //IBOutlet TextFieldSPAJ* //textSebutkanjenisidentitas
    IBOutlet TextFieldSPAJ* TextThirdPartyBeneficiaryNationalityWNA;//textSebutkan
    IBOutlet TextFieldSPAJ* LineThirdPartyOtherRelationship;//textSebutkan
    IBOutlet TextFieldSPAJ* TextThirdPartyInsurancePurposeOther;//textSebutkan
    
    IBOutlet TextFieldSPAJ* TextThirdPartySalary;//penghasilan/tahun
    IBOutlet TextFieldSPAJ* TextThirdPartyRevenue;//penghasilan/tahun
    IBOutlet TextFieldSPAJ* TextThirdPartyOtherIncome;//penghasilan/tahun
    
    IBOutlet TextFieldSPAJ* TextThirdPartyCIN;
    IBOutlet TextFieldSPAJ* TextThirdPartyFullName;
    IBOutlet TextFieldSPAJ* TextThirdPartyFullName2nd;
    IBOutlet TextFieldSPAJ* TextThirdPartyIDNumber;
    IBOutlet TextFieldSPAJ* TextThirdPartyBirthPlace;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompany;
    IBOutlet TextFieldSPAJ* TextThirdPartyMainJob;
    IBOutlet TextFieldSPAJ* TextThirdPartyWorkScope;
    IBOutlet TextFieldSPAJ* TextThirdPartyPosition;
    IBOutlet TextFieldSPAJ* TextThirdPartyJobDescription;
    IBOutlet TextFieldSPAJ* TextThirdPartySideJob;
    IBOutlet TextFieldSPAJ* TextThirdPartyHomeAddress;
    IBOutlet TextFieldSPAJ* TextThirdPartyHomeAddress2nd;
    IBOutlet TextFieldSPAJ* TextThirdPartyHomeCity;
    IBOutlet TextFieldSPAJ* TextThirdPartyHomePostalCode;
    IBOutlet TextFieldSPAJ* TextThirdPartyHomeTelephonePrefix;
    IBOutlet TextFieldSPAJ* TextThirdPartyHomeTelephoneSuffix;
    IBOutlet TextFieldSPAJ* TextThirdPartyHandphone1;
    IBOutlet TextFieldSPAJ* TextThirdPartyHandphone2;
    IBOutlet TextFieldSPAJ* TextThirdPartyEmail;
    
    //IBOutlet TextFieldSPAJ* //textOffice1
    //IBOutlet TextFieldSPAJ* //textOffice2
    //IBOutlet TextFieldSPAJ* //textOfficeKodePos
    //IBOutlet TextFieldSPAJ* //textOfficeKota
    //IBOutlet TextFieldSPAJ* //textNomorNPWP
    IBOutlet TextFieldSPAJ* TextThirdPartySource;
    //IBOutlet TextFieldSPAJ* //textSumberDanaPembelianAsuransi
    
    //view D
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCompanyType;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCompanyAsset;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCompanyRevenue;
    //IBOutlet SegmentSPAJ* RadioButtonRelationWithInsured
    
    
    IBOutlet ButtonSPAJ* DateThirdPartyCompanyNoAnggaranDasarExpired;
    IBOutlet ButtonSPAJ* DateThirdPartyCompanySIUPExpired;
    IBOutlet ButtonSPAJ* DateThirdPartyCompanyNoTDPExpired;
    IBOutlet ButtonSPAJ* DateThirdPartyCompanyNoSKDPExpired;
    //IBOutlet ButtonSPAJ* //tanggalNPWP
    
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyTypeOther;//textSebutkan
    //IBOutlet TextFieldSPAJ* //textHubunganCalonTertanggung//textSebutkan
    //IBOutlet TextFieldSPAJ* //textSebutkanTujuanPembelianAsuransi//textSebutkan
    
    
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoAnggaranDasar;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoSIUP;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoTDP;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoSKDP;
    //IBOutlet TextFieldSPAJ* //textNPWP
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanySector;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyAddress;
    //IBOutlet TextFieldSPAJ* //TextThirdPartyCompanyAddress2//ini belum ada
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyCity;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyPostalCode;
    
    //IBOutlet TextFieldSPAJ*
    //IBOutlet TextFieldSPAJ*
}
@property (strong, nonatomic) NSDictionary* dictTransaction;
@end
