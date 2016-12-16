//
//  ModelSIULRider.m
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSIULRider.h"

@implementation ModelSIULRider
-(int)getULRiderDataCount:(NSString *)SINo{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_UL_Rider where SINO = \"%@\"",SINo]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(void)saveULRiderData:(NSMutableDictionary *)dictULRiderData{
    //cek the SINO exist or not
    int exist = [self getULRiderDataCount:[dictULRiderData valueForKey:@"SINO"]];
    
    /*if (exist>0){
        //update data
        [self updateULRiderData:dictULRiderData];
    }
    else{
        //insert data
        [self insertToDBULRiderData:dictULRiderData];
    }*/
    [self insertToDBULRiderData:dictULRiderData];
}

-(void)deleteULRiderData:(NSString *)stringSINO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"delete from SI_UL_Rider where SINO=?" ,
                    stringSINO];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)insertToDBULRiderData:(NSMutableDictionary *)dictULRiderData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_UL_Rider (SINO, RiderCode, RiderDesc, SumAssured,Term,ExtraPremiMil,ExtraPremiMilTerm,ExtraPremiPercent,ExtraPremiPercentTerm) values (?,?,?,?,?,?,?,?,?)",
                    [dictULRiderData valueForKey:@"SINO"],
                    [dictULRiderData valueForKey:@"RiderCode"],
                    [dictULRiderData valueForKey:@"RiderDesc"],
                    [dictULRiderData valueForKey:@"SumAssured"],
                    [dictULRiderData valueForKey:@"Term"],
                    [dictULRiderData valueForKey:@"ExtraPremiMil"],
                    [dictULRiderData valueForKey:@"ExtraPremiMilTerm"],
                    [dictULRiderData valueForKey:@"ExtraPremiPercent"],
                    [dictULRiderData valueForKey:@"ExtraPremiPercentTerm"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateULRiderData:(NSMutableDictionary *)dictULRiderData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"update SI_UL_Rider set RiderCode=?, RiderDesc=?, SumAssured=?,Term=?,ExtraPremiMil=?,ExtraPremiMilTerm=?,ExtraPremiPercent=?,ExtraPremiPercentTerm=? where SINO=?" ,
                    [dictULRiderData valueForKey:@"RiderCode"],
                    [dictULRiderData valueForKey:@"RiderDesc"],
                    [dictULRiderData valueForKey:@"SumAssured"],
                    [dictULRiderData valueForKey:@"Term"],
                    [dictULRiderData valueForKey:@"ExtraPremiMil"],
                    [dictULRiderData valueForKey:@"ExtraPremiMilTerm"],
                    [dictULRiderData valueForKey:@"ExtraPremiPercent"],
                    [dictULRiderData valueForKey:@"ExtraPremiPercentTerm"],
                    [dictULRiderData valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSMutableArray *)getULRiderDataFor:(NSString *)SINo{
    NSMutableArray* arrayRiderData = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString* SINO;
    NSString* RiderCode;
    NSString* RiderDesc;
    NSString* SumAssured;
    NSString* Term;
    NSString* ExtraPremiMil;
    NSString* ExtraPremiMilTerm;
    NSString* ExtraPremiPercent;
    NSString* ExtraPremiPercentTerm;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_UL_Rider where SINO = \"%@\"",SINo]];
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        RiderCode = [s stringForColumn:@"RiderCode"];
        RiderDesc = [s stringForColumn:@"RiderDesc"];
        SumAssured = [s stringForColumn:@"SumAssured"];
        Term = [s stringForColumn:@"Term"];
        ExtraPremiMil = [s stringForColumn:@"ExtraPremiMil"];
        ExtraPremiMilTerm = [s stringForColumn:@"ExtraPremiMilTerm"];
        ExtraPremiPercent = [s stringForColumn:@"ExtraPremiPercent"];
        ExtraPremiPercentTerm = [s stringForColumn:@"ExtraPremiPercentTerm"];
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              SINO,@"SINO",
              RiderCode,@"RiderCode",
              RiderDesc,@"RiderDesc",
              SumAssured,@"SumAssured",
              Term,@"Term",
              ExtraPremiMil,@"ExtraPremiMil",
              ExtraPremiMilTerm,@"ExtraPremiMilTerm",
              ExtraPremiPercent,@"ExtraPremiPercent",
              ExtraPremiPercentTerm,@"ExtraPremiPercentTerm",nil];
        
        [arrayRiderData addObject:dict];
    }
    
    
    [results close];
    [database close];
    return arrayRiderData;
}
@end
