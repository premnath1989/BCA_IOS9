//
//  CFFQuestionsViewController.h
//  BLESS
//
//  Created by Basvi on 6/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIMenuTableViewCell.h"

@interface CFFQuestionsViewController : UIViewController

@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSNumber* cffID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;
@end
