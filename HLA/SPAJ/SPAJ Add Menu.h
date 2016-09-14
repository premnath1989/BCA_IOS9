//
//  ViewController.h
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"


// DECLARATION

@protocol SPAJMainDelegate

    - (void) voidGoToAddDetail;
    - (void) voidGoToFormGeneration;
    - (void) voidGoToCaptureIdentification;
    - (void) voidGoToAddSignature;
    - (NSDictionary *)getUpdatedDictTransaction;
    - (IBAction)actionGoToExistingList:(id)sender;

@end

@interface SPAJAddMenu : HtmlGenerator{
    NSString *filePath;
}


    @property (strong, nonatomic) NSDictionary* dictTransaction;

    // PROTOCOL

    @property (nonatomic,strong) id <SPAJMainDelegate> delegateSPAJMain;

    //NSString

    @property (strong, nonatomic) NSString* stringEAPPNumber;

    // VIEW
    @property (nonatomic, weak) IBOutlet UIView *viewActivityIndicator;
    @property (nonatomic, weak) IBOutlet UIView *viewStep1;
    @property (nonatomic, weak) IBOutlet UIView *viewStep2;
    @property (nonatomic, weak) IBOutlet UIView *viewStep3;
    @property (nonatomic, weak) IBOutlet UIView *viewStep4;
    @property (nonatomic, weak) IBOutlet UIView *viewStep5;
    @property (nonatomic, weak) IBOutlet UIView *viewStep6;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel *labelPageTitle;
    @property (nonatomic, weak) IBOutlet UILabel *labelMenuHint;

    @property (nonatomic, weak) IBOutlet UILabel *labelStep1;
    @property (nonatomic, weak) IBOutlet UILabel *labelHeader1;
    @property (nonatomic, weak) IBOutlet UILabel *labelDetail1;

    @property (nonatomic, weak) IBOutlet UILabel *labelStep2;
    @property (nonatomic, weak) IBOutlet UILabel *labelHeader2;
    @property (nonatomic, weak) IBOutlet UILabel *labelDetail2;

    @property (nonatomic, weak) IBOutlet UILabel *labelStep3;
    @property (nonatomic, weak) IBOutlet UILabel *labelHeader3;

    @property (nonatomic, weak) IBOutlet UILabel *labelStep4;
    @property (nonatomic, weak) IBOutlet UILabel *labelHeader4;

    @property (nonatomic, weak) IBOutlet UILabel *labelStep5;
    @property (nonatomic, weak) IBOutlet UILabel *labelHeader5;

    @property (nonatomic, weak) IBOutlet UILabel *labelStep6;
    @property (nonatomic, weak) IBOutlet UILabel *labelHeader6;

    @property (nonatomic, weak) IBOutlet UILabel *labelTitleImportantInformation;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldCustomerSignature;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldDateTime;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldExpiredDate;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldLastUpdate;
    @property (nonatomic, weak) IBOutlet UILabel *labelFieldTimeRemaining;
    @property (nonatomic, weak) IBOutlet UILabel *labelPropertyCustomerSignature;
    @property (nonatomic, weak) IBOutlet UILabel *labelPropertyDateTime;
    @property (nonatomic, weak) IBOutlet UILabel *labelPropertyExpiredDate;
    @property (nonatomic, weak) IBOutlet UILabel *labelPropertyLastUpdate;
    @property (nonatomic, weak) IBOutlet UILabel *labelPropertyTimeRemining;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonStep1;
    @property (nonatomic, weak) IBOutlet UIButton *buttonStep2;
    @property (nonatomic, weak) IBOutlet UIButton *buttonStep3;
    @property (nonatomic, weak) IBOutlet UIButton *buttonStep4;
    @property (nonatomic, weak) IBOutlet UIButton *buttonStep5;
    @property (nonatomic, weak) IBOutlet UIButton *buttonStep6;

    @property (nonatomic, weak) IBOutlet UIButton *buttonConfirmSPAJ;

@end