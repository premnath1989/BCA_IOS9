//
//  RiderCalculation.h
//  BLESS
//
//  Created by Basvi on 3/22/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateModel.h"

@interface RiderCalculation : NSObject{
    RateModel* rateModel;
}

-(NSNumber *)getSumAssuredForMDBKK:(NSNumber *)numberBasicSumAssured;
-(NSNumber *)getSumAssuredForMBKK:(NSNumber *)numberBasicSumAssured;

-(double)getWaiverRate:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType;
-(double)calculateBPPremi:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateMDBKKLoading:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateMDBKK:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(double)calculateBPPremiLoading:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType;
-(int)getPaymentType:(NSString *)PaymentDesc;
@end
