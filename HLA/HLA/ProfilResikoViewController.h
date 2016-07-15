//
//  ProfilResikoViewController.h
//  BLESS
//
//  Created by Basvi on 6/30/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlGenerator/HtmlGenerator.h"

@interface ProfilResikoViewController : HtmlGenerator{
    NSString *filePath;
}
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;
@property (strong, nonatomic) NSString* htmlFileName;
@property (strong, nonatomic) NSNumber* cffID;
@property (strong, nonatomic) NSDictionary* cffHeaderSelectedDictionary;
@end
