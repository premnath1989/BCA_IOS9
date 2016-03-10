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

@interface IlustrationViewController : UIViewController<NDHTMLtoPDFDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate,PagesControllerDelegate>{
    IBOutlet UIWebView* webIlustration;
    UIWebView *webTemp;
    NDHTMLtoPDF *PDFCreator;
    ModelAgentProfile* modelAgentProfile;
    RateModel* modelRate;
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
@end
