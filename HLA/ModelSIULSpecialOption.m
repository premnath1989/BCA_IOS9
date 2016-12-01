//
//  ModelSIULSpecialRequest.m
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSIULSpecialOption.h"

@implementation ModelSIULSpecialOption
-(int)getULSpecialOptionDataCount:(NSString *)SINo Year:(NSString *)stringYear Option:(NSString *)stringOption{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_UL_SpecialOption where SINO = \"%@\" and Year = \"%@\" and Option = \"%@\"",SINo,stringYear,stringOption]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(void)saveULSpecialOptionData:(NSMutableDictionary *)dictULSpecialOptionData{
    //cek the SINO exist or not
    int exist = [self getULSpecialOptionDataCount:[dictULSpecialOptionData valueForKey:@"SINO"] Year:[dictULSpecialOptionData valueForKey:@"Year"] Option:[dictULSpecialOptionData valueForKey:@"Option"]];
    
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
    BOOL success = [database executeUpdate:@"insert into SI_UL_SpecialOption (SINO, Year, Amount,Option) values (?,?,?,?)",
                    [dictULSpecialOptionData valueForKey:@"SINO"],
                    [dictULSpecialOptionData valueForKey:@"Year"],
                    [dictULSpecialOptionData valueForKey:@"Amount"],
                    [dictULSpecialOptionData valueForKey:@"Option"]];
    
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
    BOOL success = [database executeUpdate:@"update SI_UL_SpecialOption set Year=?, Amount=?, Option=? where SINO=?" ,
                    [dictULSpecialOptionData valueForKey:@"Year"],
                    [dictULSpecialOptionData valueForKey:@"Amount"],
                    [dictULSpecialOptionData valueForKey:@"Option"],
                    [dictULSpecialOptionData valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)deleteULSpecialOptionData:(NSString *)stringSINO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"delete from SI_UL_SpecialOption where SINO=?" ,
                    stringSINO];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(NSMutableArray *)getULSpecialOptionDataFor:(NSString *)SINo{
    NSMutableArray* arraySpecialOption = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *SINO;
    NSString *Year;
    NSString *Amount;
    NSString *Option;
    
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_UL_SpecialOption where SINO = \"%@\"",SINo]];
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        Year = [s stringForColumn:@"Year"];
        Amount = [s stringForColumn:@"Amount"];
        Option = [s stringForColumn:@"Option"];
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              SINO,@"SINO",
              Year,@"Year",
              Amount,@"Amount",
              Option,@"Option",nil];
        
        [arraySpecialOption addObject:dict];
    }
    
    
    
    [results close];
    [database close];
    return arraySpecialOption;
}

-(NSMutableArray *)getULSpecialOptionDataFor:(NSString *)SINo Option:(NSString *)stringOption{
    NSMutableArray* arraySpecialOption = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *SINO;
    NSString *Year;
    NSString *Amount;
    NSString *Option;
    
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_UL_SpecialOption where SINO = \"%@\" and Option = \"%@\"",SINo,stringOption]];
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        Year = [s stringForColumn:@"Year"];
        Amount = [s stringForColumn:@"Amount"];
        Option = [s stringForColumn:@"Option"];
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              SINO,@"SINO",
              Year,@"Year",
              Amount,@"Amount",
              Option,@"Option",nil];
        
        [arraySpecialOption addObject:dict];
    }
    
    
    
    [results close];
    [database close];
    return arraySpecialOption;
}

@end
