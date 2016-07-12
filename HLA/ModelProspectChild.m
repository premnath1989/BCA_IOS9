//
//  ModelProspectChild.m
//  BLESS
//
//  Created by Basvi on 6/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelProspectChild.h"

@implementation ModelProspectChild

-(void)saveProspectChild:(NSDictionary *)dictProspectChild{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into prospectchild_profile (ProspectChildName, ProspectChildGender, ProspectChildDOB, OtherIDType,OtherIDTypeNo,Smoker,Nationality,ProspectChildOccupationCode,ProspectIndexNo,CFFTransactionID,Relation,YearsInsured,DateCreated,DateModified) values (?,?,?,?,?,?,?,?,?,?,?,?,""datetime(\"now\", \"+7 hour\")"",""datetime(\"now\", \"+7 hour\")"")" ,
                    [dictProspectChild valueForKey:@"ProspectChildName"],
                    [dictProspectChild valueForKey:@"ProspectChildGender"],
                    [dictProspectChild valueForKey:@"ProspectChildDOB"],
                    [dictProspectChild valueForKey:@"OtherIDType"],
                    [dictProspectChild valueForKey:@"OtherIDTypeNo"],
                    [dictProspectChild valueForKey:@"Smoker"],
                    [dictProspectChild valueForKey:@"Nationality"],
                    [dictProspectChild valueForKey:@"ProspectChildOccupationCode"],
                    [dictProspectChild valueForKey:@"ProspectIndexNo"],
                    [dictProspectChild valueForKey:@"CFFTransactionID"],
                    [dictProspectChild valueForKey:@"Relation"],
                    [dictProspectChild valueForKey:@"YearsInsured"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateProspectChild:(NSDictionary *)dictProspectChild{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"update prospectchild_profile set ProspectChildName=?, ProspectChildGender=?, ProspectChildDOB=?, OtherIDType=?,OtherIDTypeNo=?,Smoker=?,Nationality=?,ProspectChildOccupationCode=?,ProspectIndexNo=?,CFFTransactionID=?,Relation=?,YearsInsured=?,DateModified=""datetime(\"now\", \"+7 hour\")"" where IndexNo = ?" ,
                    [dictProspectChild valueForKey:@"ProspectChildName"],
                    [dictProspectChild valueForKey:@"ProspectChildGender"],
                    [dictProspectChild valueForKey:@"ProspectChildDOB"],
                    [dictProspectChild valueForKey:@"OtherIDType"],
                    [dictProspectChild valueForKey:@"OtherIDTypeNo"],
                    [dictProspectChild valueForKey:@"Smoker"],
                    [dictProspectChild valueForKey:@"Nationality"],
                    [dictProspectChild valueForKey:@"ProspectChildOccupationCode"],
                    [dictProspectChild valueForKey:@"ProspectIndexNo"],
                    [dictProspectChild valueForKey:@"CFFTransactionID"],
                    [dictProspectChild valueForKey:@"Relation"],
                    [dictProspectChild valueForKey:@"YearsInsured"],
                    [dictProspectChild valueForKey:@"IndexNo"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)deleteProspectChildByCFFTransID:(int)cffTransactionID{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"delete from prospectchild_profile where CFFTransactionID = %i",cffTransactionID]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSMutableArray *)selectProspectChild:(int)prospectIndexNo CFFTransctoinID:(int)cffTransactionID{
    NSMutableArray* arrayDictProspectChild = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString* childIndexNo;
    NSString* childName;
    NSString* childDOB;
    NSString* childOtherIDType;
    NSString* childOtherIDNumber;
    NSString* childNationality;
    NSString* childRelation;
    NSString* childYearsInsured;
    NSString* childOccupationCode;
    NSString* childGender;
    NSString* childSmoker;
    NSString* childProspectIndexNo;
    NSString* childCFFTransactionID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from prospectchild_profile where ProspectIndexNo = %i and CFFTransactionID = %i",prospectIndexNo,cffTransactionID]];
    while ([s next]) {
        childIndexNo = [NSString stringWithFormat:@"%i",[s intForColumn:@"IndexNo"]];
        childName = [s stringForColumn:@"ProspectChildName"];
        childDOB = [s stringForColumn:@"ProspectChildDOB"];
        childOtherIDType = [s stringForColumn:@"OtherIDType"];
        childOtherIDNumber = [s stringForColumn:@"OtherIDTypeNo"];
        childNationality = [s stringForColumn:@"Nationality"];
        childRelation = [s stringForColumn:@"Relation"];
        childYearsInsured = [s stringForColumn:@"YearsInsured"];
        childOccupationCode = [s stringForColumn:@"ProspectChildOccupationCode"];
        childGender = [s stringForColumn:@"ProspectChildGender"];
        childSmoker = [s stringForColumn:@"Smoker"];
        childProspectIndexNo = [s stringForColumn:@"ProspectIndexNo"];
        childCFFTransactionID = [s stringForColumn:@"CFFTransactionID"];
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              childIndexNo,@"IndexNo",
              childName,@"ProspectChildName",
              childDOB,@"ProspectChildDOB",
              childOtherIDType,@"OtherIDType",
              childOtherIDNumber,@"OtherIDTypeNo",
              childNationality,@"Nationality",
              childRelation,@"Relation",
              childYearsInsured,@"YearsInsured",
              childOccupationCode,@"ProspectChildOccupationCode",
              childGender,@"ProspectChildGender",
              childSmoker,@"Smoker",
              childProspectIndexNo,@"ProspectIndexNo",
              childCFFTransactionID,@"CFFTransactionID",nil];
        
        [arrayDictProspectChild addObject:dict];
    }
    
    
    
    [results close];
    [database close];
    return arrayDictProspectChild;
}

-(int)chekcExistingRecord:(int)prospectChildIndexNo{
    
    int countData;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT count(*) as count FROM prospectchild_profile where IndexNo = %i",prospectChildIndexNo]];
    while ([s next]) {
        countData = [s intForColumn:@"count"];
    }
    
    [results close];
    [database close];
    return countData;
}

@end
