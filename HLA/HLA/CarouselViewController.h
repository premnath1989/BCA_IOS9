//
//  CarouselViewController.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/10/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol CarouselDelegate
- (void)PresentMain;
@end

@interface CarouselViewController : UIViewController< NSXMLParserDelegate> {
    sqlite3 *contactDB;
}

@property (nonatomic, strong) id<CarouselDelegate> delegate;
@property(strong) NSString *previousElementName;
@property(strong) NSString *elementName;
@property (nonatomic, retain) NSString *getInternet;
@property (nonatomic, retain) NSString *getValid;
@property (nonatomic, retain) NSString *ErrorMsg;
@property (nonatomic, assign) int indexNo;

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIButton *outletClientProfile;
@property (weak, nonatomic) IBOutlet UIButton *outletCustomerFF;
@property (weak, nonatomic) IBOutlet UIButton *outletSI;
@property (weak, nonatomic) IBOutlet UIButton *outletEAPP;

@property (weak, nonatomic) IBOutlet UIButton *CPBtn;
@property (weak, nonatomic) IBOutlet UINavigationBar *outletNavBar;

- (IBAction)selectClientProfile:(id)sender;
- (IBAction)selectSalesIllustration:(id)sender;
- (IBAction)selectCFF:(id)sender;
- (IBAction)selectEApp:(id)sender;

@end
