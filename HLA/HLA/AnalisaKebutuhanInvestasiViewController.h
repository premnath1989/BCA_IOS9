//
//  AnalisaKebutuhanInvestasiViewController.h
//  BLESS
//
//  Created by Basvi on 7/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"
@protocol AnalisaKebutuhanInvestasiViewControllerDelegate
-(void)voidSetAnalisaKebutuhanInvestasiBoolValidate:(BOOL)boolValidate;
@end

@interface AnalisaKebutuhanInvestasiViewController : HtmlGenerator{
    NSString *filePath;
}
@property (nonatomic,strong) id <AnalisaKebutuhanInvestasiViewControllerDelegate> delegate;
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSString* htmlFileName;
@property (strong, nonatomic) NSNumber* cffID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;
-(void)voidDoneInvestasi;
-(void)viewDidAppear:(BOOL)animated;
@end
