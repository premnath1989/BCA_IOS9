//
//  ModelSIULBasicPlan.m
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSIULBasicPlan.h"

@implementation ModelSIULBasicPlan
#pragma mark unit linked methods

-(int)getULBasicPlanDataCount:(NSString *)SINo{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_UL_BasicPlan where SINO = \"%@\"",SINo]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(void)saveULBasicPlanData:(NSMutableDictionary *)dictULBasicPlanData{
    //cek the SINO exist or not
    int exist = [self getULBasicPlanDataCount:[dictULBasicPlanData valueForKey:@"SINO"]];
    
    if (exist>0){
        //update data
        [self updateULBasicPlanData:dictULBasicPlanData];
    }
    else{
        //insert data
        [self insertToDBULBasicPlanData:dictULBasicPlanData];
    }
}

-(void)insertToDBULBasicPlanData:(NSMutableDictionary *)dictULBasicPlanData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_PO_Data (SINO, PaymentMode, PreferredPremium, RegularTopUp,Premium,SumAssured,PremiumHolidayTerm,TotalUnAppliedPremium,TargetValue) values (?,?,?,?,?,?,?,?,?)",
                    [dictULBasicPlanData valueForKey:@"SINO"],
                    [dictULBasicPlanData valueForKey:@"PaymentMode"],
                    [dictULBasicPlanData valueForKey:@"PreferredPremium"],
                    [dictULBasicPlanData valueForKey:@"RegularTopUp"],
                    [dictULBasicPlanData valueForKey:@"Premium"],
                    [dictULBasicPlanData valueForKey:@"SumAssured"],
                    [dictULBasicPlanData valueForKey:@"PremiumHolidayTerm"],
                    [dictULBasicPlanData valueForKey:@"TotalUnAppliedPremium"],
                    [dictULBasicPlanData valueForKey:@"TargetValue"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateULBasicPlanData:(NSMutableDictionary *)dictULBasicPlanData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"update SI_PO_Data set PaymentMode=?, PreferredPremium=?, RegularTopUp=?,Premium=?,SumAssured=?,PremiumHolidayTerm=?,TotalUnAppliedPremium=?,TargetValue=? where SINO=?" ,
                    [dictULBasicPlanData valueForKey:@"PaymentMode"],
                    [dictULBasicPlanData valueForKey:@"PreferredPremium"],
                    [dictULBasicPlanData valueForKey:@"RegularTopUp"],
                    [dictULBasicPlanData valueForKey:@"Premium"],
                    [dictULBasicPlanData valueForKey:@"SumAssured"],
                    [dictULBasicPlanData valueForKey:@"PremiumHolidayTerm"],
                    [dictULBasicPlanData valueForKey:@"TotalUnAppliedPremium"],
                    [dictULBasicPlanData valueForKey:@"TargetValue"],
                    [dictULBasicPlanData valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSDictionary *)getULBasicPlanDataFor:(NSString *)SINo{
    NSDictionary *dict;
    
    NSString* SINO;
    NSString* PaymentMode;
    NSString* PreferredPremium;
    NSString* RegularTopUp;
    NSString* Premium;
    NSString* SumAssured;
    NSString* PremiumHolidayTerm;
    NSString* TotalUnAppliedPremium;
    NSString* TargetValue;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_UL_BasicPlan where SINO = \"%@\"",SINo]];
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        PaymentMode = [s stringForColumn:@"PaymentMode"];
        PreferredPremium = [s stringForColumn:@"PreferredPremium"];
        RegularTopUp = [s stringForColumn:@"RegularTopUp"];
        Premium = [s stringForColumn:@"Premium"];
        SumAssured = [s stringForColumn:@"SumAssured"];
        PremiumHolidayTerm = [s stringForColumn:@"PremiumHolidayTerm"];
        TotalUnAppliedPremium = [s stringForColumn:@"TotalUnAppliedPremium"];
        TargetValue = [s stringForColumn:@"TargetValue"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          SINO,@"SINO",
          PaymentMode,@"PaymentMode",
          PreferredPremium,@"PreferredPremium",
          RegularTopUp,@"RegularTopUp",
          Premium,@"Premium",
          SumAssured,@"SumAssured",
          PremiumHolidayTerm,@"PremiumHolidayTerm",
          TotalUnAppliedPremium,@"TotalUnAppliedPremium",
          TargetValue,@"TargetValue",nil];
    
    [results close];
    [database close];
    return dict;
}


@end
