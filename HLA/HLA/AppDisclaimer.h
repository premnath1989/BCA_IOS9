//
//  PasswordTips.h
//  HLA Ipad
//
//  Created by Erwin on 11/20/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarouselViewController.h"

@protocol AppDisclaimerDelegate
- (void)CloseWindow;
@end

@interface AppDisclaimer : UIViewController{
    id<AppDisclaimerDelegate> _delegate;
    CarouselViewController *homeController;
}
@property (nonatomic, strong) id<AppDisclaimerDelegate> delegate;
@property (nonatomic, strong) CarouselViewController *homeController;

- (IBAction)approve:(id)sender;



@end
