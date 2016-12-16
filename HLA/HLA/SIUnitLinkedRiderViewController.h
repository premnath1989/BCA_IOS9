//
//  SIUnitLinkedRiderViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ULRiderViewControllerDelegate
    -(NSString *)getRunnigSINumber;
    -(NSMutableDictionary *)getBasicPlanDictionary;
    -(void)setULRiderDictionary:(NSMutableArray *)arrayULRiderData;
    -(NSMutableArray *)getULRiderArray;
    -(void)showUnitLinkModuleAtIndex:(NSIndexPath *)indexPath;
@end

@interface SIUnitLinkedRiderViewController : UIViewController

@property (nonatomic,weak)IBOutlet UIView* viewRider;
@property (nonatomic,strong) id <ULRiderViewControllerDelegate> delegate;
@end
