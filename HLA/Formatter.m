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

#pragma mark calculate age
-(int)calculateAge:(NSString *)DOB{
    BOOL AgeLess = NO;
    BOOL EDDCase = FALSE;
    BOOL AgeExceed189Days = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString* commDate=[self getDateToday:@"dd/MM/yyyy"];
    NSArray *comm = [commDate componentsSeparatedByString: @"/"];
    NSString *commDay = [comm objectAtIndex:0];
    NSString *commMonth = [comm objectAtIndex:1];
    NSString *commYear = [comm objectAtIndex:2];
    
    
    NSArray *foo = [DOB componentsSeparatedByString: @"/"];
    NSString *birthDay = [foo objectAtIndex: 0];
    NSString *birthMonth = [foo objectAtIndex: 1];
    NSString *birthYear = [foo objectAtIndex: 2];
    
    int yearN = [commYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [commMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [commDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    int age;
    int ANB;
    
    NSString *msgAge;
    if (yearN > yearB) {
        if (monthN < monthB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN == dayB) { //edited by heng
            newALB = ALB ;  //edited by heng
        } else {
            newALB = ALB;
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN > dayB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN == dayB) { // edited by heng
            newANB = ALB; //edited by heng
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        age = newALB;
        ANB = newANB;
    } else if (yearN == yearB) {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = DOB;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:commDate];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
        if (diffDays < 0 && diffDays > -190 ) {
            EDDCase = YES;
            AgeExceed189Days = NO;
        } else if (diffDays < 0 && diffDays <  -190 ) {
            AgeExceed189Days = YES;
            EDDCase = FALSE;
        } else if (diffDays < 30) {
            AgeLess = YES;
            EDDCase = FALSE;
            AgeExceed189Days = NO;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d days",diffDays];
        
        age = 0;
        ANB = 1;
    } else {
        age = 0;
        ANB = 1;
    }
    return age;
}

-(int)calculateDifferenceDay:(NSString *)DOB
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSArray *comm = [dateString componentsSeparatedByString: @"/"];
    NSString *commDay = [comm objectAtIndex:0];
    NSString *commMonth = [comm objectAtIndex:1];
    NSString *commYear = [comm objectAtIndex:2];
    
    
    NSArray *foo = [DOB componentsSeparatedByString: @"/"];
    NSString *birthDay = [foo objectAtIndex: 0];
    NSString *birthMonth = [foo objectAtIndex: 1];
    NSString *birthYear = [foo objectAtIndex: 2];
    
    int yearN = [commYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [commMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [commDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    
    
    if (yearN > yearB) {
        if (monthN < monthB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN == dayB) { //edited by heng
            newALB = ALB ;  //edited by heng
        } else {
            newALB = ALB;
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN > dayB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN == dayB) { // edited by heng
            newANB = ALB; //edited by heng
        } else {
            newANB = ALB;
        }
        //age = newALB;
        //ANB = newANB;
    } else if (yearN == yearB) {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = DOB;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:dateString];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
        //age = 0;
        //ANB = 1;
    } else {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = DOB;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:dateString];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
        //age = 0;
        //ANB = 1;
    }
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *selectDate = DOB;
    NSDate *startDate = [dateFormatter dateFromString:selectDate];
    
    NSDate *endDate = [dateFormatter dateFromString:dateString];
    
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
    return [difference day];
    
}

#pragma mark get random number
-(int)getRandomNumberBetween:(int)minValue MaxValue:(int)maxValue{
    int randomNumber =  (arc4random() % minValue+1) + maxValue;
    return randomNumber;
}

#pragma mark create root directory for supporting files
- (void)createDirectory:(NSString *)documentRootDirectory{
    //create Directory
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentRootDirectory])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:documentRootDirectory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
}
/*-(NSString *)convertSpecialCharacter:(NSString *)originalString{
    NSString *someString = originalString;
    NSString *newString = [someString stringByReplacingOccurrencesOfString:@"[/,@"'; ]+" withString:@"-" options: NSRegularExpressionSearch range:NSMakeRange(0, someString.length)];
    return newString;
}*/

@end
