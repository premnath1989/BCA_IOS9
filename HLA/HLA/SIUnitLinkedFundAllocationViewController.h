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
    -(NSMutableDictionary *)getBasicPlanDictionary;
    -(NSString *)getRunnigSINumber;
    -(void)showUnitLinkModuleAtIndex:(NSIndexPath *)indexPath;
@end
@interface SIUnitLinkedFundAllocationViewController : UIViewController{
    IBOutlet UITextField* textFixedIncome;
    IBOutlet UITextField* textEquityIncome;
    IBOutlet UITextField* textTotalIncome;
}


@property (nonatomic,strong) id <ULFundAllocationViewControllerDelegate> delegate;
@end
