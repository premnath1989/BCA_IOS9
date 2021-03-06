//
//  Formatter.m
//  MPOS
//
//  Created by Basvi on 3/18/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
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

-(NSNumber *)convertNumberFromStringCurrency:(NSString *)stringNumber{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setLocale:[NSLocale localeWithLocaleIdentifier:@"in_ID"]];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:stringNumber];
    return myNumber;
}

-(NSNumber *)convertAnyNonDecimalNumberToString:(NSString *)stringNumber{
    NSString *returnNumber = stringNumber;
    returnNumber = [returnNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    returnNumber = [returnNumber stringByReplacingOccurrencesOfString:@"," withString:@""];
    returnNumber = [returnNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
    returnNumber = [returnNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    long long newNumber=[returnNumber longLongValue];
    return [NSNumber numberWithLongLong:newNumber];
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

-(NSString *)roundTwoDigit:(double)originalNumber{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    
    return [formatter stringFromNumber:[NSNumber numberWithDouble:originalNumber]];
//    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:22.368511]];
}

-(NSNumberFormatter *)formatterForCurrencyText{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:2];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"in_ID"]];
    return formatter;
}

-(int)decimalDigitFromString:(NSString *)decimalString DecimalSeparator:(NSString *)decimalSeparator {
    NSString *string = decimalString;
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:decimalSeparator];
    NSRange range = [string rangeOfCharacterFromSet:charSet];
    NSUInteger *position = &range.location;
    NSUInteger result = decimalString.length - (int)position - 1;
    return (int)result;
}
/*-(NSString *)convertSpecialCharacter:(NSString *)originalString{
    NSString *someString = originalString;
    NSString *newString = [someString stringByReplacingOccurrencesOfString:@"[/,@"'; ]+" withString:@"-" options: NSRegularExpressionSearch range:NSMakeRange(0, someString.length)];
    return newString;
}*/

@end
