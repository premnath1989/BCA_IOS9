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

-(NSString *)stringToCurrencyDecimalFormatted:(NSString  *)stringNumber{
    @try {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"in_ID"]];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:0];
        NSNumber *myNumber = [numberFormatter numberFromString:stringNumber];
        NSString *theString = [numberFormatter stringFromNumber:myNumber];
        NSLog(@"The string: %@", theString);
        return theString;

    }
    @catch (NSException *exception) {
        return stringNumber;
    }
    @finally {
        
    }
}

-(NSNumber *)convertNumberFromString:(NSString *)stringNumber{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:stringNumber];
    return myNumber;
}

-(double)formatToTwoDecimal:(double)valueToFormat{
    NSNumberFormatter *format21 = [[NSNumberFormatter alloc]init];
    [format21 setNumberStyle:NSNumberFormatterNoStyle];
    [format21 setGeneratesDecimalNumbers:TRUE];
    [format21 setMaximumFractionDigits:2];
    [format21 setRoundingMode:NSNumberFormatterRoundHalfUp];
}


-(NSString *)convertDateFrom:(NSString *)originalDateFormat TargetDateFormat:(NSString *)targetDateFormat DateValue:(NSString *)dateValue{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",originalDateFormat]];
    NSDate *dateToConvert = [dateFormatter dateFromString:dateValue];
    
    // Convert date object to desired output format
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",targetDateFormat]];
    NSString *targetDateString = [dateFormatter stringFromDate:dateToConvert];

    return targetDateString;
}

-(NSString *)getDateToday:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",dateFormat]];
    NSString *targetDateString = [dateFormatter stringFromDate:[NSDate date]];
    return targetDateString;
}


@end
