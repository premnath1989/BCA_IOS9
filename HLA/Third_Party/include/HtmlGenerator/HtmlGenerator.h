//
//  PCViewController.h
//  ProductConfiguratorPOC
//
//  Created by Erwin Lim  on 4/28/16.
//  Copyright © 2016 Erwin Lim . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HtmlGenerator : UIViewController<UIWebViewDelegate>{
    UIWebView *webview;
    NSString *databasePath;
}
- (NSMutableDictionary*) readfromDB:(NSMutableDictionary*) params;
- (void) savetoDB:(NSDictionary*) params;
- (void) callErrorCallback:(NSString *) name withMessage:(NSString *) msg;
- (void) callSuccessCallback:(NSString *) name withRetValue:(id) retValue;

@end
