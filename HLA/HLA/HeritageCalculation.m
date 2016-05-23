//
//  HeritageCalculation.m
//  BLESS
//
//  Created by Basvi on 5/4/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "HeritageCalculation.h"

@implementation HeritageCalculation
-(void)setPremiumDictionary:(NSMutableDictionary *)premiumDictionary{
    dictionaryPremium = [[NSMutableDictionary alloc]initWithDictionary:premiumDictionary];
    
    _Pertanggungan_Dasar = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    _PayorAge = [[dictionaryPremium valueForKey:@"PO_Age"]integerValue];;
    _PayorSex = [dictionaryPremium valueForKey:@"PO_Gender"];
    PremiType = [dictionaryPremium valueForKey:@"Payment_Term"];
    _RelWithLA = [dictionaryPremium valueForKey:@"RelWithLA"];
    Highlight =[dictionaryPremium valueForKey:@"Payment_Frequency"];
    Pertanggungan_ExtrePremi = [[dictionaryPremium valueForKey:@"ExtraPremiumTerm"] longLongValue];
    ExtraPremiNumbValue  = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] longLongValue];
    _LASex = [dictionaryPremium valueForKey:@"LA_Gender"];
    _LAAge = [[dictionaryPremium valueForKey:@"LA_Age"]integerValue];
    _LAAge = [[dictionaryPremium valueForKey:@"LA_Age"]integerValue];
    ExtraPercentagePremi = [dictionaryPremium valueForKey:@"ExtraPremiumPercentage"];
}

-(NSString *)getRatesInt:(NSString *)premType{
    NSString*AnsuransiDasarQuery;
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    /*NSString* premType;
    
    if ([PremiType isEqualToString:@"Premi 5 Tahun"]){
        premType = @"R";
    }
    else{
        premType = @"S";
    }*/
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    if(([_RelWithLA isEqualToString:@"DIRI SENDIRI"])||([_RelWithLA isEqualToString:@"SELF"]))
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_PayorAge];
        NSLog(@"query %@",AnsuransiDasarQuery);
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }
        
        
    }
    else
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM EMRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_LAAge];
        NSLog(@"query %@",AnsuransiDasarQuery);
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([_LASex isEqualToString:@"Male"]||[_LASex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }
        
        
    }
    return RatesPremiumRate;
}

-(NSString *)getRatesIntPremiDasar:(NSString *)premType{
    NSString*AnsuransiDasarQuery;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
    
    /*NSString* premType;
    
    if ([premType isEqualToString:@"Premi 5 Tahun"]){
        premType = @"R";
    }
    else{
        premType = @"S";
    }*/
    
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    
    NSString*RatesPremiumRate;
    if (![database open])
    {
        NSLog(@"Could not open db.");
    }
    
    
    if(([_RelWithLA isEqualToString:@"DIRI SENDIRI"])||([_RelWithLA isEqualToString:@"SELF"]))
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_PayorAge];
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([_PayorSex isEqualToString:@"Male"]||[_PayorSex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
            
        }
        
    }
    else
    {
        AnsuransiDasarQuery = [NSString stringWithFormat:@"SELECT Male,Female FROM basicPremiumRate Where BasicCode = '%@' AND PremType = '%@'  AND EntryAge = %i",@"HRT",premType,_LAAge];
        results = [database executeQuery:AnsuransiDasarQuery];
        
        while([results next])
        {
            if ([_LASex isEqualToString:@"Male"]||[_LASex isEqualToString:@"MALE"]){
                RatesPremiumRate  = [results stringForColumn:@"Male"];
            }
            else{
                RatesPremiumRate  = [results stringForColumn:@"Female"];
            }
        }
    }
    return RatesPremiumRate;
}

-(double)extraPremiSekaligus{
    return [self calculateExtraPremiPercentSekaligus] + [self calculateExtraPremiNumberSekaligus];
}

-(double)extraPremiBulanan{
    return [self calculateExtraPremiPercentBulanan] + [self calculateExtraPremiNumberBulanan];
}

-(double)extraPremiTahunan{
    return [self calculateExtraPremiPercentTahunan] + [self calculateExtraPremiNumberTahunan];
}

-(double)totalPremiDiscount:(double)discount BasicPremi:(double)basicPremi{
    return basicPremi-discount;
}

-(double)totalPremiAll:(double)basicPremi ExtraPremi:(double)extraPremi{
    return basicPremi+extraPremi;
}

-(double)totalPremiSekaligus{
    return [self calculateExtraPremiPercentSekaligus] + [self calculateExtraPremiNumberSekaligus] + [self getPremiDasarSekaligus];
}

-(double)totalPremiBulanan{
    return [self calculateExtraPremiPercentBulanan] + [self calculateExtraPremiNumberBulanan] + [self getPremiDasarBulanan];
}

-(double)totalPremiTahunan{
    return [self calculateExtraPremiPercentTahunan] + [self calculateExtraPremiNumberTahunan] + [self getPremiDasarTahunan];
}

-(double)getPremiDasarSekaligus{
    double PaymentMode=1;
    double RatesInt = [[self getRatesIntPremiDasar:@"S"] doubleValue];
    double test = PaymentMode * RatesInt;
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double test2 = (test * BasisSumAssured)/1000;
    return test2;
}

-(double)getPremiDasarBulanan{
    double PaymentMode=0.1;
    double RatesInt = [[self getRatesIntPremiDasar:@"R"] doubleValue];
    double test = PaymentMode * RatesInt;
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double test2 = (test * BasisSumAssured)/1000;
    return test2;
}

-(double)getPremiDasarTahunan{
    double PaymentMode=1;
    double RatesInt = [[self getRatesIntPremiDasar:@"R"] doubleValue];
    double test = PaymentMode * RatesInt;
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double test2 = (test * BasisSumAssured)/1000;
    return test2;
}

-(double)getDiskonSekaligus{
    double discountPercent=0.08;
    double premiDasar = [self getPremiDasarSekaligus];
    double discount = discountPercent * premiDasar;
    return discount;
}

-(double)getDiskonBulanan{
    double discountPercent=0.08;
    double premiDasar = [self getPremiDasarBulanan];
    double discount = discountPercent * premiDasar;
    return discount;
}

-(double)getDiskonTahunan{
    double discountPercent=0.08;
    double premiDasar = [self getPremiDasarTahunan];
    double discount = discountPercent * premiDasar;
    return discount;
}

-(double)calculateExtraPremiPercentSekaligus{
    double PaymentMode=1;
    double RatesInt0 = [[self getRatesInt:@"S"] doubleValue];
    double percent = [[dictionaryPremium valueForKey:@"ExtraPremiumPercentage"] doubleValue] / 100;
    double RatesInt = percent * RatesInt0;
    double valueofTotal =(PaymentMode * RatesInt);
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double total =(((double)BasisSumAssured/1000) * valueofTotal);
    
    return total;
}

-(double)calculateExtraPremiPercentTahunan{
    double PaymentMode=1;
    double RatesInt0 = [[self getRatesInt:@"R"] doubleValue];
    double percent = [[dictionaryPremium valueForKey:@"ExtraPremiumPercentage"] doubleValue] / 100;
    double RatesInt = percent * RatesInt0;
    double valueofTotal =(PaymentMode * RatesInt);
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double total =(((double)BasisSumAssured/1000) * valueofTotal);
    
    return total;
    
}

-(double)calculateExtraPremiPercentBulanan{
    double PaymentMode=0.1;
    double RatesInt0 = [[self getRatesInt:@"R"] doubleValue];
    double percent = [[dictionaryPremium valueForKey:@"ExtraPremiumPercentage"] doubleValue] / 100;
    double RatesInt = percent * RatesInt0;
    double valueofTotal =(PaymentMode * RatesInt);
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double total =(((double)BasisSumAssured/1000) * valueofTotal);
    
    return total;
    
}

-(double)calculateExtraPremiNumberSekaligus{
    double PaymentMode=1;
    double  ExtraPremiNumb = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] doubleValue];
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double Extraprem =(ExtraPremiNumb* PaymentMode) *((double)BasisSumAssured/1000);
    return Extraprem;
}

-(double)calculateExtraPremiNumberTahunan{
    double PaymentMode=1;
    double  ExtraPremiNumb = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] doubleValue];
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double Extraprem =(ExtraPremiNumb* PaymentMode) *((double)BasisSumAssured/1000);
    return Extraprem;
    
}

-(double)calculateExtraPremiNumberBulanan{
    double PaymentMode=0.1;
    double  ExtraPremiNumb = [[dictionaryPremium valueForKey:@"ExtraPremiumSum"] doubleValue];
    long long BasisSumAssured = [[dictionaryPremium valueForKey:@"Number_Sum_Assured"] longLongValue];
    double Extraprem =(ExtraPremiNumb* PaymentMode) *((double)BasisSumAssured/1000);
    return Extraprem;
}
@end
