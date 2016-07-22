//
//  AnalisaKebutuhanPendidikanViewController.h
//  BLESS
//
//  Created by Basvi on 7/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"
@protocol AnalisaKebutuhanPendidikanViewControllerDelegate
-(void)voidSetAnalisaKebutuhanPendidikanBoolValidate:(BOOL)boolValidate;
@end

@interface AnalisaKebutuhanPendidikanViewController : HtmlGenerator{
    NSString *filePath;
}
@property (nonatomic,strong) id <AnalisaKebutuhanPendidikanViewControllerDelegate> delegate;
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSString* htmlFileName;
@property (strong, nonatomic) NSNumber* cffID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;
-(void)voidDonePendidikan;
-(void)viewDidAppear:(BOOL)animated;
@end
