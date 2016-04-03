//
//  Formatter.h
//  MPOS
//
//  Created by Basvi on 3/18/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Formatter : NSObject
-(NSString *)numberToCurrencyDecimalFormatted:(NSNumber *)number;
-(NSString *)convertDateFrom:(NSString *)originalDateFormat TargetDateFormat:(NSString *)targetDateFormat DateValue:(NSString *)dateValue;
-(NSString *)getDateToday:(NSString *)dateFormat;
-(NSString *)stringToCurrencyDecimalFormatted:(NSString  *)stringNumber;
-(NSNumber *)convertNumberFromString:(NSString *)stringNumber;
-(NSNumber *)convertNumberFromStringCurrency:(NSString *)stringNumber;
-(NSString *)roundTwoDigit:(double)originalNumber;
@end
