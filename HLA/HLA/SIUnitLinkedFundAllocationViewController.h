//
//  SIUnitLinkedFundAllocationViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ULFundAllocationViewControllerDelegate
    -(void)setULFundAllocationDictionary:(NSMutableDictionary *)dictULFundAllocation;
    -(NSMutableDictionary *)getULFundAllocationDictionary;
@end
@interface SIUnitLinkedFundAllocationViewController : UIViewController


@property (nonatomic,strong) id <ULFundAllocationViewControllerDelegate> delegate;
@end
