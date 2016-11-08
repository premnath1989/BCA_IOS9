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
#import "DateViewController.h"
#import "mySmoothLineView.h"
#import "HtmlGenerator/HtmlGenerator.h"

@interface SPAJThirdParty : HtmlGenerator<DateViewControllerDelegate>{
    NSString *filePath;
    
    UserInterface *functionUserInterface;
    DateViewController *LADate;
    AllAboutPDFFunctions *allAboutPDFFunctions;
    
    UIPopoverController *dobPopover;
    
    IBOutlet UIButton* buttonSubmit;
    IBOutlet UIButton* buttonClose;
    IBOutlet UIButton* buttonShowSignature;
    
    IBOutlet UICollectionView *collectionReasonInsurancePurchaseC;
    IBOutlet UICollectionView *collectionReasonInsurancePurchaseD;
    
    IBOutlet UIView *viewSignature;
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
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyIDType;
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
    IBOutlet ButtonSPAJ* DateThirdPartyBirth;
    IBOutlet ButtonSPAJ* DateThirdPartyNPWPActive;//tanggal npwp
    
    IBOutlet TextFieldSPAJ* TextThirdPartyIDTypeOther;//textSebutkanjenisidentitas
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
    
    IBOutlet TextFieldSPAJ* TextThirdPartyOfficeAddress1;//textOffice1
    IBOutlet TextFieldSPAJ* TextThirdPartyOfficeAddress2;//textOffice2
    IBOutlet TextFieldSPAJ* TextThirdPartyOfficePostalCode;//textOfficeKodePos
    IBOutlet TextFieldSPAJ* TextThirdPartyOfficeCity;//textOfficeKota
    
    IBOutlet TextFieldSPAJ* TextThirdPartyNPWPNumber;//textNomorNPWP
    IBOutlet TextFieldSPAJ* TextThirdPartySource;
    IBOutlet TextFieldSPAJ* TextThirdPartyFundingSource;//textSumberDanaPembelianAsuransi ()
    
    //view D
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCompanyType;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCompanyAsset;
    
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCompanyRevenue;
    IBOutlet SegmentSPAJ* RadioButtonThirdPartyCompanyRelationAssured;
    
    IBOutlet ButtonSPAJ* DateThirdPartyCompanyNoAnggaranDasarExpired;
    IBOutlet ButtonSPAJ* DateThirdPartyCompanySIUPExpired;
    IBOutlet ButtonSPAJ* DateThirdPartyCompanyNoTDPExpired;
    IBOutlet ButtonSPAJ* DateThirdPartyCompanyNoSKDPExpired;
    IBOutlet ButtonSPAJ* DateThirdPartyCompanyNoNPWP;//tanggalNPWP
    
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyTypeOther;//textSebutkan
    IBOutlet TextFieldSPAJ* TextThirdPartyNonPersonOtherRelationship;//textHubunganCalonTertanggung//textSebutkan
    IBOutlet TextFieldSPAJ* TextThirdPartyNonPersonInsurancePurposeOther;//textSebutkanTujuanPembelianAsuransi//textSebutkan
    
    
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyName;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyDirectorName;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyDirectorName2;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoAnggaranDasar;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoSIUP;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoTDP;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoSKDP;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyNoNPWP;//textNPWP
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanySector;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyAddress;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyAddress2nd;//ini belum ada
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyCity;
    IBOutlet TextFieldSPAJ* TextThirdPartyCompanyPostalCode;
    
    //IBOutlet TextFieldSPAJ*
    //IBOutlet TextFieldSPAJ*
    
    //view E
    IBOutlet TextFieldSPAJ* TextThirdPartyAccountHolder;
    IBOutlet TextFieldSPAJ* TextThirdPartyAccountNumber;
    IBOutlet TextFieldSPAJ* TextThirdPartyBankName;
    IBOutlet TextFieldSPAJ* TextThirdPartyBankBranch;
    
    UITextField *activeField;
    UITextView *activeView;
    
    //signature
    IBOutlet UIView *viewBorder;
    IBOutlet mySmoothLineView *viewToSign;
}
@property (weak, nonatomic) NSDictionary* dictTransaction;
@end
