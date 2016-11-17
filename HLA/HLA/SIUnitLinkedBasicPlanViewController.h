//
//  SIUnitLinkedBasicPlanViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ULBasicPlanViewControllerDelegate
-(void)setBasicPlanDictionary:(NSMutableDictionary *)dictULBasicPlanData;
-(NSMutableDictionary *)getBasicPlanDictionary;
@end
@interface SIUnitLinkedBasicPlanViewController : UIViewController{
    IBOutlet UIButton* buttonTargetAccountValue;
}
@property (nonatomic,strong) id <ULBasicPlanViewControllerDelegate> delegate;
@end
