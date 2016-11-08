//
//  AnalisaKebutuhanNasabahViewController.h
//  BLESS
//
//  Created by Basvi on 6/17/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AnalisaKebutuhanNasabahViewControllerDelegate
-(void)voidSetAnalisaKebutuhanNasabahBoolValidate:(BOOL)boolValidate;
@end

@interface AnalisaKebutuhanNasabahViewController : UIViewController
@property (nonatomic,strong) id <AnalisaKebutuhanNasabahViewControllerDelegate> delegate;
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSNumber* cffID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;
-(void)voidDoneAnalisaKebutuhanNasabah;
@end
