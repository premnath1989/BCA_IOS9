//
//  SIMenuUnitLinkedViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTableViewCell.h"
@interface SIMenuUnitLinkedViewController : UIViewController{
    IBOutlet UITableView *myTableView;
    IBOutlet UIView* viewRightView;
    
    NSString* stringSINumber;
    NSMutableDictionary* dictParentPOLAData;
    NSMutableDictionary* dictParentULBasicPlanData;
}

@property (nonatomic,weak)NSString* stringSIDate;

-(void)setIllustrationNumber:(NSString *)stringIllustrationNumber;
@end
