//
//  SIUnitLinkedSpecialOptionViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ULSpecialOptionViewControllerDelegate
    -(void)setULSpecialOptionArray:(NSMutableArray *)arraySpecialOption;
    -(NSMutableArray *)getULSpecialOptionArray;
    -(NSMutableDictionary *)getPOLADictionary;
    -(NSMutableDictionary *)getBasicPlanDictionary;
    -(NSString *)getRunnigSINumber;
    -(void)showUnitLinkModuleAtIndex:(NSIndexPath *)indexPath;
@end


@interface SIUnitLinkedSpecialOptionViewController : UIViewController{
    IBOutlet UITableView* tableTopUp;
    IBOutlet UITableView* tableWithDrawal;
    
    IBOutlet UIButton* buttonTopUpYear;
    IBOutlet UIButton* buttonWithDrawalYear;
    
    IBOutlet UITextField* textTopUpAmount;
    IBOutlet UITextField* textWithDrawalAmount;
}
@property (nonatomic,weak)IBOutlet UIScrollView* scrollSpecialOption;
@property (nonatomic,strong) id <ULSpecialOptionViewControllerDelegate> delegate;
@end
