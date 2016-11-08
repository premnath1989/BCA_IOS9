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

    // COLOR

    -(UIColor *)generateUIColor:(UInt32)intHex floatOpacity:(CGFloat)floatOpacity
    {
        CGFloat floatRed = ((intHex & 0xFF0000) >> 16) / 256.0;
        CGFloat floatGreen = ((intHex & 0xFF00) >> 8) / 256.0;
        CGFloat floatBlue = (intHex & 0xFF) / 256.0;
        
        return [UIColor colorWithRed : floatRed green : floatGreen blue : floatBlue alpha : floatOpacity];
    };


    // TABLE HELPER

    - (NSString*) generateTimeRemaining:(NSDate *)dateCreatedOn
    {
        NSTimeInterval timeInterval = [dateCreatedOn timeIntervalSinceNow];
        NSDate* dateDifferent = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        
        NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [_dateFormatter setDateFormat:@"HH:mm:ss"];

        return [_dateFormatter stringFromDate:dateDifferent];
    }

    - (NSString*) generateDate:(NSDate *)dateRaw
    {
        NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [_dateFormatter setDateFormat:@"dd-MM-yyyy"];
        return [_dateFormatter stringFromDate:dateRaw];
    }

    - (NSString*) generateTime:(NSDate *)dateRaw
    {
        NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [_dateFormatter setDateFormat:@"HH:mm:ss"];
        return [_dateFormatter stringFromDate:dateRaw];
    }


    // QUERY HELPER

    - (NSString*) generateQueryParameter:(NSString *)stringRaw
    {
        if ([stringRaw length] == 0)
        {
            return nil;
        }
        else
        {
            return stringRaw;
        }
    }


    // FORM HELPER

    - (void) resetTextField:(NSMutableArray *)arrayTextField
    {
        if (arrayTextField.count == 0)
        {
            
        }
        else
        {
            for (int i = 0; i < arrayTextField.count; i++)
            {
                if ([[arrayTextField objectAtIndex:i] isKindOfClass:[UITextField class]])
                {
                    UITextField* textField = [arrayTextField objectAtIndex:i];
                    [textField setText:@""];
                }
                else
                {
                    
                }
            }
        }
    }

@end