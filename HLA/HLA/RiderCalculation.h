//
//  RiderCalculation.h
//  BLESS
//
//  Created by Basvi on 3/22/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateModel.h"
#import "Formatter.h"

@interface RiderCalculation : NSObject{
    RateModel* rateModel;
    Formatter* formatter;
}

-(NSNumber *)getSumAssuredForMDBKK:(NSNumber *)numberBasicSumAssured;
-(NSNumber *)getSumAssuredForMBKK:(NSNumber *)numberBasicSumAssured;

-(CGFloat)getWaiverRate:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType;
-(double)calculateBPPremi:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateMDBKKLoading:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateMDBKKLoadingPercent:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateMDBKKLoadingNumber:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateMDBKK:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateBPPremiLoading:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(int)getPaymentType:(NSString *)PaymentDesc;
-(double)totalPremiDiscount:(double)discount BasicPremi:(double)basicPremi;
@end
