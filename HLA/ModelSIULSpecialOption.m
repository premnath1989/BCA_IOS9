//
//  ModelSIULSpecialRequest.m
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSIULSpecialOption.h"

@implementation ModelSIULSpecialOption
-(int)getULSpecialOptionDataCount:(NSString *)SINo{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_UL_SpecialOption where SINO = \"%@\"",SINo]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(void)saveULSpecialOptionData:(NSMutableDictionary *)dictULSpecialOptionData{
    //cek the SINO exist or not
    int exist = [self getULSpecialOptionDataCount:[dictULSpecialOptionData valueForKey:@"SINO"]];
    
    if (exist>0){
        //update data
        [self updateULSpecialOptionData:dictULSpecialOptionData];
    }
    else{
        //insert data
        [self insertToDBULSpecialOptionData:dictULSpecialOptionData];
    }
}

-(void)insertToDBULSpecialOptionData:(NSMutableDictionary *)dictULSpecialOptionData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_UL_SpecialOption (SINO, TopUpYear, TopUpAmount, WithDrawalYear,WithDrawalAmount) values (?,?,?,?,?)",
                    [dictULSpecialOptionData valueForKey:@"SINO"],
                    [dictULSpecialOptionData valueForKey:@"TopUpYear"],
                    [dictULSpecialOptionData valueForKey:@"TopUpAmount"],
                    [dictULSpecialOptionData valueForKey:@"WithDrawalYear"],
                    [dictULSpecialOptionData valueForKey:@"WithDrawalAmount"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateULSpecialOptionData:(NSMutableDictionary *)dictULSpecialOptionData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"update SI_UL_SpecialOption set TopUpYear=?, TopUpAmount=?, WithDrawalYear=?,WithDrawalAmount=? where SINO=?" ,
                    [dictULSpecialOptionData valueForKey:@"TopUpYear"],
                    [dictULSpecialOptionData valueForKey:@"TopUpAmount"],
                    [dictULSpecialOptionData valueForKey:@"WithDrawalYear"],
                    [dictULSpecialOptionData valueForKey:@"WithDrawalAmount"],
                    [dictULSpecialOptionData valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSDictionary *)getULSpecialOptionDataFor:(NSString *)SINo{
    NSDictionary *dict;
    
    NSString *SINO;
    NSString *TopUpYear;
    NSString *TopUpAmount;
    NSString *WithDrawalYear;
    NSString *WithDrawalAmount;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_UL_SpecialOption where SINO = \"%@\"",SINo]];
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        TopUpYear = [s stringForColumn:@"TopUpYear"];
        TopUpAmount = [s stringForColumn:@"TopUpAmount"];
        WithDrawalYear = [s stringForColumn:@"WithDrawalYear"];
        WithDrawalAmount = [s stringForColumn:@"WithDrawalAmount"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          SINO,@"SINO",
          TopUpYear,@"TopUpYear",
          TopUpAmount,@"TopUpAmount",
          WithDrawalYear,@"WithDrawalYear",
          WithDrawalAmount,@"WithDrawalAmount",nil];
    
    [results close];
    [database close];
    return dict;
}
@end
