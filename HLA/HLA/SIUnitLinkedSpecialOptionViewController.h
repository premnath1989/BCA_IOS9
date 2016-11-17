//
//  SIUnitLinkedSpecialOptionViewController.h
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ULSpecialOptionViewControllerDelegate
    -(void)setULSpecialOptionDictionary:(NSMutableDictionary *)dictULSpecialOption;
    -(NSMutableDictionary *)getULSpecialOptionDictionary;
@end


@interface SIUnitLinkedSpecialOptionViewController : UIViewController
@property (nonatomic,strong) id <ULSpecialOptionViewControllerDelegate> delegate;
@end
