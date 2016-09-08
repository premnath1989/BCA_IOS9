//
//  SPAJIDCapturedViewController.h
//  BLESS
//
//  Created by Basvi on 8/19/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Formatter.h"
#import "MultipleImageIDTableViewCell.h"

@interface SPAJIDCapturedViewController : UIViewController{
    Formatter *formatter;
    
    IBOutlet UIImageView* imageViewFront;
    IBOutlet UIImageView* imageViewBack;
    IBOutlet UILabel* labelName;
    IBOutlet UILabel* labelIDDesc;
    IBOutlet UITableView* tableImageCaptured;
}

-(void)loadIDInformation;
-(void)loadIDImage:(UIImage *)imageFront ImageBack:(UIImage *)imageBack;
-(void)showMultiplePictureForSection:(NSString *)stringSection StringButtonType:(NSString *)stringButtonType;
@property (strong, nonatomic) NSDictionary* dictionaryIDData;
@property (strong, nonatomic) NSDictionary* dictTransaction;
@property (strong, nonatomic) UIImage* imageFront;
@property (strong, nonatomic) UIImage* imageBack;
@property (strong, nonatomic) NSNumber* partyIndex;
@property (strong, nonatomic) NSString* buttonTitle;

@end
