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
    rateModel = [[RateModel alloc]init];
    return [rateModel getKeluargakuMOPRate:paymentCode];
}

-(double)getKeluargakuEMRate:(NSString *)gender EntryAge:(int)entryAge{
    rateModel = [[RateModel alloc]init];
    return [rateModel getKeluargakuEMRate:gender EntryAge:entryAge];
}

-(CGFloat)getWaiverRate:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType{
    CGFloat waiverRate = 0;
    rateModel = [[RateModel alloc]init];
    waiverRate  = [rateModel getWaiverRate:Gender EntryAge:entryAge PersonType:personType];
    return waiverRate;
}

-(NSString *)getWaiverRateAsStrig:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType{
    NSString* waiverRate = @"0";
    rateModel = [[RateModel alloc]init];
    waiverRate  = [rateModel getWaiverRateAsString:Gender EntryAge:entryAge PersonType:personType];
    return waiverRate;
}

-(NSString *)getWaiverRateAsString:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType{
    NSString* waiverRate;
    rateModel = [[RateModel alloc]init];
    waiverRate  = [rateModel getWaiverRateAsString:Gender EntryAge:entryAge PersonType:personType];
    return waiverRate;
}

-(double)calculateMDBKKLoading:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    double emPercent;
    int emNumber;
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        emPercent = emPercent/100;
        emNumber= [[dictionaryBasicPlan valueForKey:@"ExtraPremiumSum"] integerValue];

    }
    else{
        //emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        //emPercent = 0;
        //emNumber = 0;
        emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        emPercent = emPercent/100;
        emNumber= [[dictionaryBasicPlan valueForKey:@"ExtraPremiumSum"] integerValue];
    }
    
    NSString *sex;
    if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"Male"])){
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
    
    double MDBKKLoading = (emPercent * emRate + emNumber) * (sumAssured/1000) * (paymentFactor/100);
    return MDBKKLoading;
}

-(double)calculateMDBKKLoadingPercent:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    double emPercent;
    int emNumber;
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        emPercent = emPercent/100;
        emNumber= [[dictionaryBasicPlan valueForKey:@"ExtraPremiumSum"] integerValue];
        
    }
    else{
        //emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        //emPercent = 0;
        //emNumber = 0;
        emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        emPercent = emPercent/100;
        emNumber= [[dictionaryBasicPlan valueForKey:@"ExtraPremiumSum"] integerValue];
    }
    
    NSString *sex;
    if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"Male"])){
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
    
    double MDBKKLoading = (emPercent * emRate) * (sumAssured/1000) * (paymentFactor/100);
    return MDBKKLoading;
}

-(double)calculateMDBKKLoadingNumber:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    double emPercent;
    int emNumber;
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        emPercent = emPercent/100;
        emNumber= [[dictionaryBasicPlan valueForKey:@"ExtraPremiumSum"] integerValue];
        
    }
    else{
        //emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        //emPercent = 0;
        //emNumber = 0;
        emPercent = [[dictionaryBasicPlan valueForKey:@"ExtraPremiumPercentage"] doubleValue];
        emPercent = emPercent/100;
        emNumber= [[dictionaryBasicPlan valueForKey:@"ExtraPremiumSum"] integerValue];
    }
    
    NSString *sex;
    if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"Male"])){
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
    
    double MDBKKLoading = (emNumber) * (sumAssured/1000) * (paymentFactor/100);
    return MDBKKLoading;
}

-(double)calculateMDBKK:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    
    NSString *sex;
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"Male"])){
            sex=@"Male";
        }
        else{
            sex=@"Female";
        }
    }
    else{
        if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"Male"])){
            sex=@"Male";
        }
        else{
            sex=@"Female";
        }
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
    formatter = [[Formatter alloc]init];
    NSString *sex;
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        if (([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"LA_Gender"] isEqualToString:@"Male"])){
            sex=@"Male";
        }
        else{
            sex=@"Female";
        }
    }
    else{
        if (([[dictPO valueForKey:@"PO_Gender"] isEqualToString:@"MALE"])||([[dictPO valueForKey:@"PO_Gender"] isEqualToString:@"Male"])){
            sex=@"Male";
        }
        else{
            sex=@"Female";
        }
    }
    
    
    double nopolRate;
    if ([[dictionaryBasicPlan valueForKey:@"PurchaseNumber"] integerValue]==1){
        nopolRate = 1;
    }
    else{
        nopolRate = 0.95;
    }
    
    int age;
    if (([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"SELF"])||([[dictPO valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"])){
        age = [[dictPO valueForKey:@"LA_Age"] integerValue];
    }
    else{
        age = [[dictPO valueForKey:@"PO_Age"] integerValue];
    }
    
    
    CGFloat waiverRate = [self getWaiverRate:sex EntryAge:age PersonType:personType];
    NSLog(@"%.02f",waiverRate);
    NSString* stringWaiverRate = [formatter roundTwoDigit:waiverRate];
    
    double MDBKK = [self calculateMDBKK:dictCalculate DictionaryBasicPlan:dictionaryBasicPlan DictionaryPO:dictPO BasicCode:basicCode PaymentCode:paymentCode PersonType:personType];
    double MDBKKLoading  = [self calculateMDBKKLoading:dictCalculate DictionaryBasicPlan:dictionaryBasicPlan DictionaryPO:dictPO BasicCode:basicCode PaymentCode:paymentCode PersonType:personType];
    
   
    NSDecimalNumber *waiverDecimal = [NSDecimalNumber decimalNumberWithString:[self getWaiverRateAsString:sex EntryAge:age PersonType:personType]];
    NSDecimalNumber *waiverDecimalDivide = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *DecimalMDBKK = [[NSDecimalNumber alloc]initWithDouble:MDBKK];
    NSDecimalNumber *DecimalMDBKKLoading = [[NSDecimalNumber alloc]initWithDouble:MDBKKLoading];

    NSDecimalNumber *result = [waiverDecimal decimalNumberByDividingBy:waiverDecimalDivide];
    NSDecimalNumber *premiDecimal = [DecimalMDBKK decimalNumberByAdding:DecimalMDBKKLoading];
    //NSDecimalNumber *totalResult = [result decimalNumberByMultiplyingBy:premiDecimal withBehavior:roundUp];
    NSDecimalNumber *totalResult = [result decimalNumberByMultiplyingBy:premiDecimal];
    
    //NSString* resultFromDecimal = [NSString stringWithFormat:@"%@",totalResult];
    
    //double bpRiderPremium = (waiverRate/100) * (MDBKK+MDBKKLoading);
    //int intbpRiderPremium = round(bpRiderPremium);
    
    //double Rounded = 100.0 * floor((intbpRiderPremium/100.0)+0.5);
    double Rounded;
    Rounded = [totalResult doubleValue];
    Rounded = 100.0 * floor((Rounded/100.0)+0.5);
    //double Rounded = [resultFromDecimal doubleValue];
    //Rounded = [totalResult doubleValue];
    return Rounded;
}

-(double)calculateBPPremiLoading:(NSMutableDictionary *)dictCalculate DictionaryBasicPlan:(NSDictionary *)dictionaryBasicPlan DictionaryPO:(NSDictionary *)dictPO BasicCode:(NSString *)basicCode PaymentCode:(int)paymentCode PersonType:(NSString *)personType{
    
    double emPercent = [[dictCalculate valueForKey:@"ExtraPremiPerCent"] doubleValue]/100;
    int emNumber = [[dictCalculate valueForKey:@"ExtraPremiPerMil"] integerValue];

    NSString *mop = [self getKeluargakuMOP:paymentCode];
    mop = [mop substringToIndex:[mop length]-1];
    double paymentFactor = [mop doubleValue];
    
    double annuityRate = [rateModel getKeluargakuAnuityRate:paymentCode];
    
    double bpPremi = [self calculateBPPremi:dictCalculate DictionaryBasicPlan:dictionaryBasicPlan DictionaryPO:dictPO BasicCode:basicCode PaymentCode:paymentCode PersonType:personType];
    
    double mdbKKPremi = [self calculateMDBKK:dictCalculate DictionaryBasicPlan:dictionaryBasicPlan DictionaryPO:dictPO BasicCode:basicCode PaymentCode:paymentCode PersonType:personType];
    
    double bpPremiLoading = (emPercent * bpPremi + (emNumber * mdbKKPremi) * (annuityRate/1000) * (paymentFactor/100));
    
    return bpPremiLoading;
}

-(int)getPaymentType:(NSString *)PaymentDesc{
    int PaymentType;
    if ([PaymentDesc isEqualToString:@"Tahunan"])
    {
        PaymentType =1;
    }
    else if ([PaymentDesc isEqualToString:@"Semester"])
    {
        PaymentType =2;
    }
    else if ([PaymentDesc isEqualToString:@"Kuartal"])
    {
        PaymentType =3;
    }
    else {
        PaymentType =4;
    }
    return PaymentType;
}


-(double)totalPremiDiscount:(double)discount BasicPremi:(double)basicPremi{
    return basicPremi-discount;
}

@end
