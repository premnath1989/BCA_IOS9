//
//  SIMenuUnitLinkedLifeAssuredViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SIUnitLinkedLifeAssuredViewController : UIViewController  {
    IBOutlet UIButton* buttonDOB;
    IBOutlet UIButton* buttonOccupation;
    IBOutlet UIButton* buttonPOlist;
    
    IBOutlet UITextField* textLA;
    IBOutlet UITextField* textLAAge;
    
    IBOutlet UISegmentedControl* segmentSex;
}

@end
