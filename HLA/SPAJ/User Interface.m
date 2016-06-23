//
//  ViewController.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "User Interface.h"


// DECLARATION

@implementation UserInterface

    // FUNCTION

    -(UIColor *)generateUIColor:(UInt32)intHex floatOpacity:(CGFloat)floatOpacity
    {
        CGFloat floatRed = ((intHex & 0xFF0000) >> 16) / 256.0;
        CGFloat floatGreen = ((intHex & 0xFF00) >> 8) / 256.0;
        CGFloat floatBlue = (intHex & 0xFF) / 256.0;
        
        return [UIColor colorWithRed : floatRed green : floatGreen blue : floatBlue alpha : floatOpacity];
    };

@end