//
//  RiderCalculation.m
//  BLESS
//
//  Created by Basvi on 3/22/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "RiderCalculation.h"

@implementation RiderCalculation

-(NSNumber *)getSumAssuredForMDBKK:(NSNumber *)numberBasicSumAssured{
    @try {
        return numberBasicSumAssured;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(NSNumber *)getSumAssuredForMBKK:(NSNumber *)numberBasicSumAssured{
    @try {
        long long basicSumAssured = [numberBasicSumAssured longLongValue];
        basicSumAssured = basicSumAssured * 2;
        return [NSNumber numberWithLongLong:basicSumAssured];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(NSString *)getKeluargakuMOP:(int)paymentCode{
    return [rateModel getKeluargakuMOPRate:paymentCode];
}

-(double)getKeluargakuEMRate:(NSString *)gender EntryAge:(int)entryAge{
    return [rateModel getKeluargakuEMRate:gender EntryAge:entryAge];
}

-(double)getWaiverRate:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType{
    double waiverRate = 0;
    rateModel = [[RateModel alloc]init];
    waiverRate  = [rateModel getWaiverRate:Gender EntryAge:entryAge PersonType:personType];
    return waiverRate;
}

-(double)calculateMDBKKLoading:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    int emPercent = [[dictCalculate valueForKey:@"ExtraPremiPerCent"] integerValue];
    int emNumber = [[dictCalculate valueForKey:@"ExtraPremiPerMil"] integerValue];
    NSString *sex;
    if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"FEMALE"])){
        sex=@"Male";
    }
    else{
        sex=@"Female";
    }
    double emRate = [self getKeluargakuEMRate:sex EntryAge:[[dictPO valueForKey:@"LA_Age"] integerValue]];
    
    NSString *mop = [self getKeluargakuMOP:paymentCode];
    mop = [mop substringToIndex:[mop length]-1];
    double paymentFactor = [mop doubleValue];
    double sumAssured = [[dictionaryBasicPlan valueForKey:@"Number_Sum_Assured"] doubleValue];
    
    double MDBKKLoading = ((emPercent * emRate)+emNumber) * (sumAssured/1000) * paymentFactor;
    return MDBKKLoading;
}

-(double)calculateMDBKK:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    
    NSString *sex;
    if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"FEMALE"])){
        sex=@"Male";
    }
    else{
        sex=@"Female";
    }

    NSString *mop = [self getKeluargakuMOP:paymentCode];
    mop = [mop substringToIndex:[mop length]-1];
    double paymentFactor = [mop doubleValue];

    double nopolRate;
    if ([[dictionaryBasicPlan valueForKey:@"PurchaseNumber"] integerValue]==1){
        nopolRate = 1;
    }
    else{
        nopolRate = 0.95;
    }

    double sumAssured = [[dictionaryBasicPlan valueForKey:@"Number_Sum_Assured"] doubleValue];
    double basicPremRate = [rateModel getKeluargakuBasicPremRate:sex EntryAge:[[dictPO valueForKey:@"LA_Age"] integerValue] BasicCode:basicCode];
    double MDBKK = basicPremRate * (sumAssured/1000) * paymentFactor * nopolRate;
    MDBKK = MDBKK/100;
    double Rounded = 1.0 * floor((MDBKK/1.0)+0.5);
    return Rounded;
}

#pragma mark - calculate 
-(double)calculateBPPremi:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    NSString *sex;
    if (([[dictPO valueForKey:@"PO_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"PO_Gender"] isEqualToString:@"FEMALE"])){
        sex=@"Male";
    }
    else{
        sex=@"Female";
    }
    
    double nopolRate;
    if ([[dictionaryBasicPlan valueForKey:@"PurchaseNumber"] integerValue]==1){
        nopolRate = 1;
    }
    else{
        nopolRate = 0.95;
    }
    
    int age;
    if ([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"]){
        age = [[dictPO valueForKey:@"LA_Age"] integerValue];
    }
    else{
        age = [[dictPO valueForKey:@"PO_Age"] integerValue];
    }
    double waiverRate = [self getWaiverRate:sex EntryAge:age PersonType:personType];
    double MDBKK = [self calculateMDBKK:dictCalculate DictionaryBasicPlan:dictionaryBasicPlan DictionaryPO:dictPO BasicCode:basicCode PaymentCode:paymentCode PersonType:personType];
    double MDBKKLoading  = [self calculateMDBKKLoading:dictCalculate DictionaryBasicPlan:dictionaryBasicPlan DictionaryPO:dictPO BasicCode:basicCode PaymentCode:paymentCode PersonType:personType];
    
    double bpRiderPremium = (waiverRate/100) * (MDBKK+MDBKKLoading);
    double Rounded = 100.0 * floor((bpRiderPremium/100.0)+0.5);
    
    return Rounded;
}

@end
