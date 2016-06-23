//
//  ViewController.h
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Rule.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


// DECLARATION

@interface Validation : NSObject

    // REGEX

    - (Boolean)regularExpression : (NSString *) stringRAW stringPattern : (NSString *) stringPattern;

    - (Boolean)stringFormatNumeric : (NSString *) stringRAW;

    - (Boolean)stringFormatAlpha : (NSString *) stringRAW;

    - (Boolean)stringFormatAlphaNumeric : (NSString *) stringRAW;

    - (Boolean)stringFormatEmail: (NSString *) stringRAW;

    - (Boolean)stringConsistOf: (NSString *) stringRAW stringWord : (NSString *) stringWord;

    - (Boolean)stringStartWith: (NSString *) stringRAW stringWord : (NSString *) stringWord;

    - (Boolean)stringEndWith: (NSString *) stringRAW stringWord : (NSString *) stringWord;

    // LENGTH

    - (Boolean)stringLengthRange: (NSString *) stringRAW intMin : (int) intMin intMax : (int) intMax;

    - (Boolean)stringLengthExact: (NSString *) stringRAW intExact : (int) intExact;

    // VALUE

    - (Boolean)stringValueExact: (NSString *) stringRAW stringExact : (NSString *) stringExact;

    - (Boolean)intValueRange: (int) intRAW intMin : (int) intMin intMax : (int) intMax;

    - (Boolean)intValueExact: (int) intRAW intExact : (int) intExact;

@end