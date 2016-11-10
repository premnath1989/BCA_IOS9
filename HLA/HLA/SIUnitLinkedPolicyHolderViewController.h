//
//  SIUnitLinkedPolicyHolderViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIUnitLinkedPolicyHolderViewController : UIViewController{
    IBOutlet UIScrollView* scrollPolicyHolder;
    
    IBOutlet UILabel* labelQuickQuote;
    
    IBOutlet UIButton* buttonPlan;
    IBOutlet UIButton* buttonDOB;
    IBOutlet UIButton* buttonOccupation;
    IBOutlet UIButton* buttonRelation;
    IBOutlet UIButton* buttonIllustrationDate;
    IBOutlet UIButton* buttonPOlist;
    
    IBOutlet UITextField* textPO;
    IBOutlet UITextField* textPOAge;
    
    IBOutlet UISegmentedControl* segmentSex;
}
-(void)setInfoNewIllustration:(NSDictionary *)dictIllustration;
@property (nonatomic,weak)IBOutlet UITextField* textIllustrationNumber;
@end
