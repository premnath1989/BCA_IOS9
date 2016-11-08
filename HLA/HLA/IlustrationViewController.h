//
//  IlustrationViewController.h
//  BLESS
//
//  Created by Basvi on 3/1/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NDHTMLtoPDF.h"
#import "BrowserViewController.h"
#import "ModelAgentProfile.h"
#import "RateModel.h"
#import <MessageUI/MessageUI.h>
#import "PagesController.h"
#import "ReaderViewController.h"
#import "Formatter.h"
#import "ModelSIRider.h"
#import "RiderCalculation.h"
#import "Model_SI_Master.h"

@interface IlustrationViewController : UIViewController<ReaderViewControllerDelegate,NDHTMLtoPDFDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate,PagesControllerDelegate>{
    IBOutlet UIWebView* webIlustration;
    UIWebView *webTemp;
    NDHTMLtoPDF *PDFCreator;
    ModelAgentProfile* modelAgentProfile;
    RateModel* modelRate;
    ModelSIRider* modelSIRider;
    Model_SI_Master* modelSIMaster;
    RiderCalculation* riderCalculation;
    Formatter* formatter;
    UIBarButtonItem *email;
    UIBarButtonItem *printSI;
    UIBarButtonItem *pages;
    UIBarButtonItem *page4;
    UIPrintInteractionController *printInteraction;
    PagesController *_PagesList;
    UIPopoverController *_PagesPopover;
    IBOutlet UIView* viewspinBar;
    
    int Pertanggungan_Dasar;
    int Pertanggungan_ExtrePremi;
    NSString *PayorSex;
    int PayorAge;
    double AnssubtotalBulan;
    double AnssubtotalYear;
    int ExtraPercentsubtotalBulan;
    int ExtraPercentsubtotalYear;
    int ExtraNumbsubtotalBulan;
    int ExtraNumbsubtotalYear;
    int ExtraPremiNumbValue;
    NSString *Highlight;
    int totalYear;
    int totalBulanan;
}
@property (retain, nonatomic) NSMutableDictionary* dictionaryPOForInsert;
@property (retain, nonatomic) NSMutableDictionary* dictionaryMasterForInsert;
@property (retain, nonatomic) NSMutableDictionary* dictionaryForBasicPlan;
@property (retain, nonatomic) NSMutableDictionary* dictionaryForAgentProfile;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end
