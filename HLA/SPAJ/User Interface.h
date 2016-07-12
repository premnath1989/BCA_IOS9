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

@interface UserInterface : NSObject

    // COLOR

    - (UIColor*) generateUIColor : (UInt32) intHex floatOpacity : (CGFloat) floatOpacity;


    // TABLE HELPER

    - (NSString*) generateTimeRemaining : (NSDate*) dateCreatedOn;

    - (NSString*) generateDate : (NSDate*) dateRaw;

    - (NSString*) generateTime : (NSDate*) dateRaw;


    // QUERY HELPER

    - (NSString*) generateQueryParameter : (NSString*) stringRaw;


    // FORM HELPER

    - (void) resetTextField : (NSMutableArray*) arrayTextField;

@end