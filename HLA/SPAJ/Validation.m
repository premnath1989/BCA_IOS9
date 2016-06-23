//
//  ViewController.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "Validation.h"



// IMPLEMENTATION

@implementation Validation

    // REGEX

    - (Boolean)regularExpression: (NSString*) stringRAW stringPattern : (NSString*) stringPattern
    {
        if([stringRAW length] == 0)
        {
            NSLog(@"Validation | stringRAW length = %lu", (unsigned long)stringRAW.length);
            return false;
        }
        else
        {
            NSRegularExpression* regExStatement = [[NSRegularExpression alloc] initWithPattern:stringPattern options:NSRegularExpressionCaseInsensitive error:nil];
            NSUInteger regExMatches = [regExStatement numberOfMatchesInString:stringRAW options:0 range:NSMakeRange(0, [stringRAW length])];
            
            NSLog(@"%lu", (unsigned long)regExMatches);
            
            if (regExMatches == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }

    - (Boolean)stringFormatNumeric: (NSString*) stringRAW
    {
        return [self regularExpression:stringRAW stringPattern:REGEX_IS_NUMERIC];
    }

    - (Boolean)stringFormatAlpha: (NSString*) stringRAW
    {
        return [self regularExpression:stringRAW stringPattern:REGEX_IS_ALPHA];
    }

    - (Boolean)stringFormatAlphaNumeric: (NSString*) stringRAW
    {
        return [self regularExpression:stringRAW stringPattern:REGEX_IS_ALPHANUMERIC];
    }

    - (Boolean)stringConsistOf:(NSString *)stringRAW stringWord:(NSString *)stringWord
    {
        NSString *stringPattern = [@"." stringByAppendingString:stringWord];
        stringPattern = [stringPattern stringByAppendingString:@"."];
        
        return [self regularExpression:stringRAW stringPattern:stringPattern];
    }

    - (Boolean)stringStartWith:(NSString *)stringRAW stringWord:(NSString *)stringWord
    {
        NSString *stringPattern = [@"^" stringByAppendingString:stringWord];
        stringPattern = [stringPattern stringByAppendingString:@"."];
        
        return [self regularExpression:stringRAW stringPattern:REGEX_IS_ALPHANUMERIC];
    }

    - (Boolean)stringEndWith:(NSString *)stringRAW stringWord:(NSString *)stringWord
    {
        NSString *stringPattern = [@"." stringByAppendingString:stringWord];
        stringPattern = [stringPattern stringByAppendingString:@"$"];

        
        return [self regularExpression:stringRAW stringPattern:REGEX_IS_ALPHANUMERIC];
    }

    - (Boolean) stringFormatEmail:(NSString *)stringRAW
    {
        return [self regularExpression:stringRAW stringPattern:REGEX_IS_NUMERIC];
    }


    // LENGTH

    - (Boolean)stringLengthRange:(NSString *)stringRAW intMin:(int)intMin intMax:(int)intMax
    {
        if (stringRAW.length < intMin)
        {
            return false;
        }
        else if ([stringRAW length] > intMax)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    - (Boolean)stringLengthExact:(NSString *)stringRAW intExact:(int)intExact
    {
        if(stringRAW.length != intExact)
        {
            return false;
        }
        else
        {
            return true;
        }
    }


    // VALUE

    - (Boolean)intValueRange:(int)intRAW intMin:(int)intMin intMax:(int)intMax
    {
        if (intRAW < intMin)
        {
            return false;
        }
        else if (intRAW > intMax)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    - (Boolean)intValueExact:(int)intRAW intExact:(int)intExact
    {
        if(intRAW!= intExact)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    - (Boolean)stringValueExact:(NSString *)stringRAW stringExact:(NSString *)stringExact
    {
        if(stringRAW == stringExact)
        {
            return false;
        }
        else
        {
            return true;
        }
    }

@end