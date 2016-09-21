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
    
    IBOutlet SegmentSPAJ *segmentRelation;
    IBOutlet SegmentSPAJ *segmentDurationKnowPolicyHolder;
    IBOutlet SegmentSPAJ *segmentIs3;
    IBOutlet SegmentSPAJ *segmentIs4;
    IBOutlet SegmentSPAJ *segmentIs5;
    IBOutlet SegmentSPAJ *segmentIs6;
    IBOutlet SegmentSPAJ *segmentIs7;
    IBOutlet SegmentSPAJ *segmentIs8;
    IBOutlet SegmentSPAJ *segmentIs9;
    IBOutlet SegmentSPAJ *segmentIs10;
    IBOutlet SegmentSPAJ *segmentIs11;
    IBOutlet SegmentSPAJ *segmentIs12;
    IBOutlet SegmentSPAJ *segmentIs13;
}
@property (strong, nonatomic) NSDictionary* dictTransaction;
@end
