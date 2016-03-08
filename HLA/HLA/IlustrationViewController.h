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

@interface IlustrationViewController : UIViewController<NDHTMLtoPDFDelegate,UIWebViewDelegate>{
    IBOutlet UIWebView* webIlustration;
    UIWebView *webTemp;
    NDHTMLtoPDF *PDFCreator;
    ModelAgentProfile* modelAgentProfile;
    RateModel* modelRate;
    UIBarButtonItem *page1;
    UIBarButtonItem *page2;
    UIBarButtonItem *page3;
    UIBarButtonItem *page4;
}
@property (retain, nonatomic) NSMutableDictionary* dictionaryPOForInsert;
@property (retain, nonatomic) NSMutableDictionary* dictionaryMasterForInsert;
@property (retain, nonatomic) NSMutableDictionary* dictionaryForBasicPlan;
@property (retain, nonatomic) NSMutableDictionary* dictionaryForAgentProfile;
@end
