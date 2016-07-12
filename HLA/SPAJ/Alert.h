//
//  ViewController.h
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Theme.h"


// DECLARATION

@interface Alert : NSObject

    // INFORMATION

    - (UIAlertController*) alertInformation : (NSString*) stringTitle stringMessage : (NSString*) stringMessage;


    // RESPONSE

    - (UIAlertController*) alertTableDelete : (NSString*) stringTitle stringMessage : (NSString*) stringMessage;


    // INPUT

    - (UIAlertController*) alertInputTextField : (NSString*) stringTitle stringMessage : (NSString*) stringMessage stringPlaceholder : (NSString*) stringPlaceholder;

@end