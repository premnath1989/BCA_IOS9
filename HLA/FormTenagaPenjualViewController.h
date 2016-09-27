//
//  FormTenagaPenjualViewController.h
//  BLESS
//
//  Created by Basvi on 9/20/16.
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

@interface FormTenagaPenjualViewController : HtmlGenerator {
    NSString *filePath;
    
    UserInterface *functionUserInterface;
    AllAboutPDFFunctions *allAboutPDFFunctions;
    
    
    IBOutlet UIScrollView *scrollViewForm;
    IBOutlet UIStackView *stackViewForm;
    
    IBOutlet UICollectionView *collectionReasonInsurancePurchase;
    
    
    IBOutlet TextFieldSPAJ *textFieldPolicyHolder;
    IBOutlet TextFieldSPAJ *textFieldInsured;
    IBOutlet TextFieldSPAJ *textFieldSPAJNumber;
    
    IBOutlet TextFieldSPAJ *TextSalesDeclarationRelationshipWithProspectiveInsuredOther;
    IBOutlet TextFieldSPAJ *TextSalesDeclarationPurposeOther;
    
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationRelationshipWithProspectiveInsured;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationKnowProspectiveInsured;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationHealth;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationWithoutSecrecy;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationDenyClaim;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationStillConsideration;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationFaceToFace;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclaration60DaysLimit;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationSelfVerified;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationThirdParty;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationConsitution;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclaration90DaysLimit;
    IBOutlet SegmentSPAJ *RadioButtonSalesDeclarationBasicSumAssured;
    
    IBOutlet TextFieldSPAJ *TextSalesDeclarationIncomeSource;
    IBOutlet TextFieldSPAJ *TextSalesDeclarationIncomeBruto;
    IBOutlet TextViewSPAJ *AreaSalesDeclarationAdditionalInformation;
    
}
@property (strong, nonatomic) NSDictionary* dictTransaction;
@end
