//
//  SIMenuUnitLinkedLifeAssuredViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ULLifeAssuredViewControllerDelegate
-(void)setPOLADictionary:(NSMutableDictionary *)NSDictionary;
-(NSMutableDictionary *)getPOLADictionary;
@end

@interface SIUnitLinkedLifeAssuredViewController : UIViewController  {
    IBOutlet UIButton* buttonDOB;
    IBOutlet UIButton* buttonOccupation;
    IBOutlet UIButton* buttonPOlist;
    
    IBOutlet UITextField* textLA;
    IBOutlet UITextField* textLAAge;
    
    IBOutlet UISegmentedControl* segmentSex;
}
@property (nonatomic,strong) id <ULLifeAssuredViewControllerDelegate> delegate;
@end
