//
//  Formatter.h
//  BLESS
//
//  Created by Basvi on 3/18/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Formatter : NSObject
-(NSString *)numberToCurrencyDecimalFormatted:(NSNumber *)number;
-(NSString *)convertDateFrom:(NSString *)originalDateFormat TargetDateFormat:(NSString *)targetDateFormat DateValue:(NSString *)dateValue;
-(NSString *)getDateToday:(NSString *)dateFormat;
-(NSString *)stringToCurrencyDecimalFormatted:(NSString  *)stringNumber;
-(NSNumber *)convertNumberFromString:(NSString *)stringNumber;
@end
