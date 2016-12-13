//
//  SIUnitLinkedPolicyHolderViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ULPolicyHolderViewControllerDelegate
-(void)setPOLADictionary:(NSMutableDictionary *)NSDictionary;
-(NSMutableDictionary *)getPOLADictionary;

-(void)showUnitLinkModuleAtIndex:(NSIndexPath *)indexPath;
-(void)saveSIMaster;
-(NSString *)getRunnigSINumber;
@end

@interface SIUnitLinkedPolicyHolderViewController : UIViewController{
    
    
    IBOutlet UISwitch* quickQuoteFlag;
    
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
    IBOutlet UISegmentedControl* segmentSmoker;
}
-(void)loadDataFromList;
-(void)setInfoNewIllustration:(NSDictionary *)dictIllustration;
@property (nonatomic,weak)IBOutlet UIScrollView* scrollPolicyHolder;
@property (nonatomic,weak)IBOutlet UITextField* textIllustrationNumber;

@property (nonatomic,strong) id <ULPolicyHolderViewControllerDelegate> delegate;
@end
