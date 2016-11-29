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
-(NSString *)getRunnigSINumber;
-(void)showUnitLinkModuleAtIndex:(NSIndexPath *)indexPath;
@end
@interface SIUnitLinkedBasicPlanViewController : UIViewController{
    IBOutlet UISegmentedControl* segmentCurrency;
    IBOutlet UITextField *textBasicPremiField;
    IBOutlet UITextField *textSumAssuredField;
    IBOutlet UITextField *textExtraPremiPercentField;
    IBOutlet UITextField *textExtraPremiNumberField;
    IBOutlet UITextField *textMasaExtraPremiField;
    IBOutlet UIButton *buttonMasaPembayaran;
    IBOutlet UIButton *buttonFrekuensiPembayaran;

}

@property (nonatomic,strong) id <ULBasicPlanViewControllerDelegate> delegate;
@end
