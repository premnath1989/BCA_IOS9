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

@interface IlustrationViewController : UIViewController<NDHTMLtoPDFDelegate>{
    IBOutlet UIWebView* webIlustration;
    NDHTMLtoPDF *PDFCreator;
}

@end
