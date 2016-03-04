//
//  RateModel.m
//  BLESS
//
//  Created by Basvi on 3/4/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "RateModel.h"

@implementation RateModel

-(long)getCashSurValue5Year:(NSString *)BasicCode EntryAge:(int)entryAge PolYear:(int)polYear Gender:(NSString *)gender{
    long Rate;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT Rate FROM Cash_SurValue_Regular Where BasicCode = \"%@\" AND EntryAge = %i  AND PolYear = %i AND Gender = \"%@\"",BasicCode,entryAge,polYear,gender]];
    while ([s next]) {
        Rate = [s intForColumn:@"Rate"];
    }
    
    [results close];
    [database close];
    return Rate;
}

-(long)getCashSurValue1Year:(NSString *)Gender BasicCode:(NSString *)basicCode EntryAge:(int)entryAge{
    long Rate;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"BCA_Rates.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT \"%@\" FROM Cash_SurValue_Single Where BasicCode = \"%@\" AND EntryAge = %i",Gender,basicCode,entryAge]];
    while ([s next]) {
        Rate = [s intForColumn:Gender];
    }
    
    [results close];
    [database close];
    return Rate;
}


@end
