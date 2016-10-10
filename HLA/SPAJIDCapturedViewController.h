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
@property (weak, nonatomic) NSDictionary* dictionaryIDData;
@property (weak, nonatomic) NSDictionary* dictTransaction;
@property (weak, nonatomic) UIImage* imageFront;
@property (weak, nonatomic) UIImage* imageBack;
@property (weak, nonatomic) NSNumber* partyIndex;
@property (weak, nonatomic) NSString* buttonTitle;

@end
