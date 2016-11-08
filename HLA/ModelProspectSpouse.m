//
//  ModelProspectSpouse.m
//  BLESS
//
//  Created by Basvi on 6/14/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelProspectSpouse.h"


@implementation ModelProspectSpouse

-(void)saveProspectSpouse:(NSDictionary *)dictProspectSpouse{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into prospectspouse_profile (ProspectSpouseName, ProspectSpouseGender, ProspectSpouseDOB, OtherIDType,OtherIDTypeNo,Smoker,Nationality,ProspectSpouseOccupationCode,ProspectIndexNo,CFFTransactionID,Relation,YearsInsured,DateCreated,DateModified) values (?,?,?,?,?,?,?,?,?,?,?,?,""datetime(\"now\", \"+7 hour\")"",""datetime(\"now\", \"+7 hour\")"")" ,
                    [dictProspectSpouse valueForKey:@"ProspectSpouseName"],
                    [dictProspectSpouse valueForKey:@"ProspectSpouseGender"],
                    [dictProspectSpouse valueForKey:@"ProspectSpouseDOB"],
                    [dictProspectSpouse valueForKey:@"OtherIDType"],
                    [dictProspectSpouse valueForKey:@"OtherIDTypeNo"],
                    [dictProspectSpouse valueForKey:@"Smoker"],
                    [dictProspectSpouse valueForKey:@"Nationality"],
                    [dictProspectSpouse valueForKey:@"ProspectSpouseOccupationCode"],
                    [dictProspectSpouse valueForKey:@"ProspectIndexNo"],
                    [dictProspectSpouse valueForKey:@"CFFTransactionID"],
                    [dictProspectSpouse valueForKey:@"Relation"],
                    [dictProspectSpouse valueForKey:@"YearsInsured"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(void)updateProspectSpouse:(NSDictionary *)dictProspectSpouse{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"update prospectspouse_profile set ProspectSpouseName=?, ProspectSpouseGender=?, ProspectSpouseDOB=?, OtherIDType=?,OtherIDTypeNo=?,Smoker=?,Nationality=?,ProspectSpouseOccupationCode=?,ProspectIndexNo=?,CFFTransactionID=?,Relation=?,YearsInsured=?,DateModified=""datetime(\"now\", \"+7 hour\")"" where IndexNo = ?" ,
                    [dictProspectSpouse valueForKey:@"ProspectSpouseName"],
                    [dictProspectSpouse valueForKey:@"ProspectSpouseGender"],
                    [dictProspectSpouse valueForKey:@"ProspectSpouseDOB"],
                    [dictProspectSpouse valueForKey:@"OtherIDType"],
                    [dictProspectSpouse valueForKey:@"OtherIDTypeNo"],
                    [dictProspectSpouse valueForKey:@"Smoker"],
                    [dictProspectSpouse valueForKey:@"Nationality"],
                    [dictProspectSpouse valueForKey:@"ProspectSpouseOccupationCode"],
                    [dictProspectSpouse valueForKey:@"ProspectIndexNo"],
                    [dictProspectSpouse valueForKey:@"CFFTransactionID"],
                    [dictProspectSpouse valueForKey:@"Relation"],
                    [dictProspectSpouse valueForKey:@"YearsInsured"],
                    [dictProspectSpouse valueForKey:@"IndexNo"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)deleteProspectSpouseByCFFTransID:(int)cffTransactionID{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"delete from prospectspouse_profile where CFFTransactionID = %i",cffTransactionID]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSDictionary *)selectProspectSpouse:(int)prospectIndexNo CFFTransctoinID:(int)cffTransactionID{
    NSDictionary *dict;
    
    NSString* spouseIndexNo;
    NSString* spouseName;
    NSString* spouseDOB;
    NSString* spouseOtherIDType;
    NSString* spouseOtherIDNumber;
    NSString* spouseNationality;
    NSString* spouseRelation;
    NSString* spouseYearsInsured;
    NSString* spouseOccupationCode;
    NSString* spouseGender;
    NSString* spouseSmoker;
    NSString* spouseProspectIndexNo;
    NSString* spouseCFFTransactionID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from prospectspouse_profile where ProspectIndexNo = %i and CFFTransactionID = %i",prospectIndexNo,cffTransactionID]];
    while ([s next]) {
        spouseIndexNo = [NSString stringWithFormat:@"%i",[s intForColumn:@"IndexNo"]];
        spouseName = [s stringForColumn:@"ProspectSpouseName"];
        spouseDOB = [s stringForColumn:@"ProspectSpouseDOB"];
        spouseOtherIDType = [s stringForColumn:@"OtherIDType"];
        spouseOtherIDNumber = [s stringForColumn:@"OtherIDTypeNo"];
        spouseNationality = [s stringForColumn:@"Nationality"];
        spouseRelation = [s stringForColumn:@"Relation"];
        spouseYearsInsured = [s stringForColumn:@"YearsInsured"];
        spouseOccupationCode = [s stringForColumn:@"ProspectSpouseOccupationCode"];
        spouseGender = [s stringForColumn:@"ProspectSpouseGender"];
        spouseSmoker = [s stringForColumn:@"Smoker"];
        spouseProspectIndexNo = [s stringForColumn:@"ProspectIndexNo"];
        spouseCFFTransactionID = [s stringForColumn:@"CFFTransactionID"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          spouseIndexNo,@"IndexNo",
          spouseName,@"ProspectSpouseName",
          spouseDOB,@"ProspectSpouseDOB",
          spouseOtherIDType,@"OtherIDType",
          spouseOtherIDNumber,@"OtherIDTypeNo",
          spouseNationality,@"Nationality",
          spouseRelation,@"Relation",
          spouseYearsInsured,@"YearsInsured",
          spouseOccupationCode,@"ProspectSpouseOccupationCode",
          spouseGender,@"ProspectSpouseGender",
          spouseSmoker,@"Smoker",
          spouseProspectIndexNo,@"ProspectIndexNo",
          spouseCFFTransactionID,@"CFFTransactionID",nil];
    
    [results close];
    [database close];
    return dict;
}

-(int)chekcExistingRecord:(int)prospectSpuseIndexNo{
    
    int countData;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT count(*) as count FROM prospectspouse_profile where IndexNo = %i",prospectSpuseIndexNo]];
    while ([s next]) {
        countData = [s intForColumn:@"count"];
    }
    
    [results close];
    [database close];
    return countData;
}



@end
