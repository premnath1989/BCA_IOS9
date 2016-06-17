//
//  AddChildViewController.h
//  BLESS
//
//  Created by Basvi on 6/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddChildViewControllerDelegate
-(void)reloadProspectData;
@end

@interface AddChildViewController : UIViewController
@property (nonatomic,strong) id <AddChildViewControllerDelegate> delegate;
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSDictionary* DictChildData;
@end
