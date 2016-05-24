//
//  RateModel.m
//  MPOS
//
//  Created by Basvi on 3/4/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RateModel.h"

@implementation RateModel

-(double)getCashSurValue5Year:(NSString *)BasicCode EntryAge:(int)entryAge PolYear:(int)polYear Gender:(NSString *)gender{
    double Rate;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT Rate FROM Cash_SurValue_Regular Where BasicCode = \"%@\" AND EntryAge = %i  AND PolYear = %i AND Gender = \"%@\"",BasicCode,entryAge,polYear,gender]];
    
    while ([s next]) {
        Rate = [s doubleForColumn:@"Rate"];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(double)getCashSurValue1Year:(NSString *)Gender BasicCode:(NSString *)basicCode EntryAge:(int)entryAge{
    double Rate;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT \"%@\" FROM Cash_SurValue_Single Where BasicCode = \"%@\" AND EntryAge = %i",Gender,basicCode,entryAge]];
    while ([s next]) {
        Rate = [s doubleForColumn:Gender];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(double)getCashSurValue:(NSString *)Gender BasicCode:(NSString *)basicCode EntryAge:(int)entryAge PolYear:(int)polYear{
    double Rate;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT \"%@\" FROM Cash_SurValue_Single Where BasicCode = \"%@\" AND EntryAge = ((%i+%i)-1)",Gender,basicCode,entryAge,polYear]];
    
    NSLog(@"surval %@",[NSString stringWithFormat:@"SELECT \"%@\" FROM Cash_SurValue_Single Where BasicCode = \"%@\" AND EntryAge = ((%i+%i)-1)",Gender,basicCode,entryAge,polYear]);
    while ([s next]) {
        Rate = [s doubleForColumn:Gender];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(CGFloat)getWaiverRate:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType{
    CGFloat Rate;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT \"%@\" FROM KLK_Waiver Where EntryAge = %i AND PersonType = \"%@\"",Gender,entryAge,personType]];

    while ([s next]) {
        Rate = [[s stringForColumn:Gender] floatValue];
    }
   
    [results close];
    [database close];
    return Rate;
}

-(NSString *)getWaiverRateAsString:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType{
    NSString* Rate;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT \"%@\" FROM KLK_Waiver Where EntryAge = %i AND PersonType = \"%@\"",Gender,entryAge,personType]];
    
    while ([s next]) {
        Rate = [s stringForColumn:Gender];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(double)getKeluargakuBasicPremRate:(NSString *)Gender EntryAge:(int)entryAge BasicCode:(NSString *)basicCode{
    double Rate;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT \"%@\" FROM Keluargaku_Rates_BasicPrem Where BasicCode = '%@' AND EntryAge = %i",Gender,basicCode,entryAge]];
    
    while ([s next]) {
        Rate = [s doubleForColumn:Gender];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(NSString *)getKeluargakuMOPRate:(int)PaymentCode{
    NSString *Rate;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT Payment_Fact FROM Keluargaku_Rates_MOP Where Payment_Code = %i",PaymentCode]];
    
    while ([s next]) {
        Rate = [s stringForColumn:@"Payment_Fact"];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(int)getKeluargakuMOPFreq:(int)PaymentType{
    int paymentFreq;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT Payment_Freq FROM Keluargaku_Rates_MOP Where Payment_Code = %i",PaymentType]];
    
    while ([s next]) {
        paymentFreq = [s intForColumn:@"Payment_Freq"];
    }
    
    [results close];
    [database close];
    return paymentFreq;
}


-(double)getKeluargakuEMRate:(NSString *)Gender EntryAge:(int)entryAge{
    double Rate;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT %@ FROM Keluargaku_Rates_EM Where EntryAge = '%i'",Gender,entryAge]];
    
    while ([s next]) {
        Rate = [s doubleForColumn:Gender];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(double)getKeluargakuAnuityRate:(int)PaymentCode{
    double Rate;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT \"Annuity Factor\" FROM Keluargaku_Rates_AnuityRate Where PaymentCode = %i",PaymentCode]];
    NSLog(@"query %@",[NSString stringWithFormat:@"SELECT \"Annuity Factor\" FROM Keluargaku_Rates_AnuityRate Where PaymentCode = %i",PaymentCode]);
    while ([s next]) {
        Rate = [s doubleForColumn:@"Annuity Factor"];
    }
    
    [results close];
    [database close];
    return Rate;
}


@end
