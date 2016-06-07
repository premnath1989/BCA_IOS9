//
//  PasswordTips.h
//  HLA Ipad
//
//  Created by Erwin on 11/20/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppDisclaimerDelegate
- (void)CloseWindow;
@end

@interface AppDisclaimer : UIViewController{
    id<AppDisclaimerDelegate> _delegate;
}
@property (nonatomic, strong) id<AppDisclaimerDelegate> delegate;

- (IBAction)approve:(id)sender;



@end
