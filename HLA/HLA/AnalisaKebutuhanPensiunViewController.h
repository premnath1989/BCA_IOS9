//
//  AnalisaKebutuhanPensiunViewController.h
//  BLESS
//
//  Created by Basvi on 7/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"
@protocol AnalisaKebutuhanPensiunViewControllerDelegate
-(void)voidSetAnalisaKebutuhanPensiunBoolValidate:(BOOL)boolValidate;
@end

@interface AnalisaKebutuhanPensiunViewController : HtmlGenerator{
    NSString *filePath;
}
@property (nonatomic,strong) id <AnalisaKebutuhanPensiunViewControllerDelegate> delegate;
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSString* htmlFileName;
@property (strong, nonatomic) NSNumber* cffID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;
-(void)voidDonePensiun;
-(void)viewDidAppear:(BOOL)animated;
@end
