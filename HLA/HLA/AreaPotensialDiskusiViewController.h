//
//  AreaPotensialDiskusiViewController.h
//  BLESS
//
//  Created by Basvi on 6/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"
@protocol AreaPotensialDiskusiViewControllerDelegate
-(void)voidSetAreaPotentialBoolValidate:(BOOL)boolValidate;
@end

@interface AreaPotensialDiskusiViewController : HtmlGenerator{
    NSString *filePath;
}
@property (nonatomic,strong) id <AreaPotensialDiskusiViewControllerDelegate> delegate;
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSString* htmlFileName;
@property (strong, nonatomic) NSNumber* cffID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;
- (void)voidDoneAreaPotential;
@end
