//
//  AreaPotensialDiskusiViewController.h
//  BLESS
//
//  Created by Basvi on 6/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"

@interface AreaPotensialDiskusiViewController : HtmlGenerator{
    NSString *filePath;
}
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;

@end
