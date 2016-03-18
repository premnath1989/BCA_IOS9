//
//  Formatter.m
//  BLESS
//
//  Created by Basvi on 3/18/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "Formatter.h"

@implementation Formatter


-(NSString *)numberToCurrencyDecimalFormatted:(NSNumber *)number{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"in_ID"]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    NSString *theString = [numberFormatter stringFromNumber:number];
    NSLog(@"The string: %@", theString);
    return theString;
}
@end
