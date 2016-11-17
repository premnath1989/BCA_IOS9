//
//  SIUnitLinkedRiderViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ULRiderViewControllerDelegate
    -(void)setULRiderDictionary:(NSMutableDictionary *)dictULRider;
    -(NSMutableDictionary *)getULRiderDictionary;
@end

@interface SIUnitLinkedRiderViewController : UIViewController
@property (nonatomic,strong) id <ULRiderViewControllerDelegate> delegate;
@end
