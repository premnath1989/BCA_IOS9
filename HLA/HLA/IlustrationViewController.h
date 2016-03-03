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

@interface IlustrationViewController : UIViewController<NDHTMLtoPDFDelegate>{
    IBOutlet UIWebView* webIlustration;
    NDHTMLtoPDF *PDFCreator;
    ModelAgentProfile* modelAgentProfile;
}
@property (retain, nonatomic) NSMutableDictionary* dictionaryPOForInsert;
@property (retain, nonatomic) NSMutableDictionary* dictionaryMasterForInsert;
@property (retain, nonatomic) NSMutableDictionary* dictionaryForBasicPlan;
@property (retain, nonatomic) NSMutableDictionary* dictionaryForAgentProfile;
@end
