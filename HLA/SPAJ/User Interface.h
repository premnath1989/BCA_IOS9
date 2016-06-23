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

    // FUNCTION

    - (UIColor*) generateUIColor : (UInt32) intHex floatOpacity : (CGFloat) floatOpacity;

@end