//
//  ModelCFFTransaction.m
//  BLESS
//
//  Created by Basvi on 6/14/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelCFFTransaction.h"

@implementation ModelCFFTransaction

-(void)saveCFFTransaction:(NSDictionary *)cffTransactionDictionary{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into CFFTransaction (CFFID, ProspectIndexNo, CFFDateCreated, CreatedBy,CFFDateModified,ModifiedBy,CFFStatus) values (?,?,?,?,?,?,?)" ,
                    [cffTransactionDictionary valueForKey:@"CFFID"],
                    [cffTransactionDictionary valueForKey:@"ProspectIndexNo"],
                    [cffTransactionDictionary valueForKey:@"CFFDateCreated"],
                    [cffTransactionDictionary valueForKey:@"CreatedBy"],
                    [cffTransactionDictionary valueForKey:@"CFFDateModified"],
                    [cffTransactionDictionary valueForKey:@"ModifiedBy"],
                    [cffTransactionDictionary valueForKey:@"CFFStatus"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSMutableArray *)getAllCFF:(NSString *)sortedBy SortMethod:(NSString *)sortMethod{
    NSMutableArray* arrayDictCFF = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *ProspectName;
    NSString *ProspectIDNumber;
    NSString *ProspectDOB;
    NSString *ProspectPrefix;
    NSString *ProspectMobileNumber;
    NSString *ProspectBranch;
    NSString *CFFDateCreated;
    NSString *CFFDateModified;
    NSString *CFFStatus;
    int ProspectIndex;
    int CFFTransactionID;
    
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select CFFT.*,pp.*,ci.*,ci.Prefix||ci.ContactNo AS ContactPhone from CFFTransaction CFFT join prospect_profile pp join contact_input ci on CFFT.ProspectIndexNo=pp.IndexNo and CFFT.ProspectIndexNo=ci.IndexNo where ci.ContactCode='CONT008' order by %@ %@",sortedBy,sortMethod]];
    //NSLog(@"query %@",[NSString stringWithFormat:@"select * from SI_Premium where SINO = \"%@\" and RiderCode=\"%@\"",SINo,riderCode]);
    while ([s next]) {
        ProspectIndex = [s intForColumn:@"IndexNo"];
        CFFTransactionID = [s intForColumn:@"CFFTransactionID"];
        ProspectName = [s stringForColumn:@"ProspectName"];
        ProspectIDNumber = [s stringForColumn:@"OtherIDTypeNo"];
        ProspectDOB = [s stringForColumn:@"ProspectDOB"];
        ProspectPrefix = [s stringForColumn:@"Prefix"];
        ProspectMobileNumber = [s stringForColumn:@"ContactNo"];
        ProspectBranch = [s stringForColumn:@"BranchName"];
        //ProspectBranch = @"";
        CFFDateCreated = [s stringForColumn:@"CFFDateCreated"];
        CFFDateModified = [s stringForColumn:@"CFFDateModified"];
        CFFStatus = [s stringForColumn:@"CFFStatus"];
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithInt:ProspectIndex],@"IndexNo",
              [NSNumber numberWithInt:CFFTransactionID],@"CFFTransactionID",
              ProspectName,@"ProspectName",
              ProspectIDNumber,@"OtherIDTypeNo",
              ProspectDOB,@"ProspectDOB",
              ProspectPrefix,@"Prefix",
              ProspectMobileNumber,@"ContactNo",
              ProspectBranch,@"BranchName",
              CFFDateCreated,@"CFFDateCreated",
              CFFDateModified,@"CFFDateModified",
              CFFStatus,@"CFFStatus",nil];
        
        [arrayDictCFF addObject:dict];
    }
    
    
    
    [results close];
    [database close];
    return arrayDictCFF;
}

-(NSMutableArray *)searchCFF:(NSDictionary *)dictSearch{
    NSMutableArray* arrayDictCFF = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *ProspectName;
    NSString *ProspectIDNumber;
    NSString *ProspectDOB;
    NSString *ProspectPrefix;
    NSString *ProspectMobileNumber;
    NSString *ProspectBranch;
    NSString *CFFDateCreated;
    NSString *CFFDateModified;
    NSString *CFFStatus;
    int ProspectIndex;
    int CFFTransactionID;
    
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s;
    if ([dictSearch valueForKey:@"Date"] != nil){
        s = [database executeQuery:[NSString stringWithFormat:@"select CFFT.*,pp.*,ci.* from CFFTransaction CFFT join prospect_profile pp join contact_input ci on CFFT.ProspectIndexNo=pp.IndexNo and CFFT.ProspectIndexNo=ci.IndexNo where ci.ContactCode='CONT008' and pp.ProspectName like \"%%%@%%\" and pp.BranchName like \"%%%@%%\" and CFFT.CFFDateCreated = \"%@\"",[dictSearch valueForKey:@"Name"],[dictSearch valueForKey:@"BranchName"],[dictSearch valueForKey:@"Date"]]];
        NSLog(@"query %@",[NSString stringWithFormat:@"select CFFT.*,pp.*,ci.* from CFFTransaction CFFT join prospect_profile pp join contact_input ci on CFFT.ProspectIndexNo=pp.IndexNo and CFFT.ProspectIndexNo=ci.IndexNo where ci.ContactCode='CONT008' and pp.ProspectName = like \"%%%@%%\" and pp.BranchName = like \"%%%@%%\" and CFFT.CFFDateCreated \"%@\"",[dictSearch valueForKey:@"Name"],[dictSearch valueForKey:@"BranchName"],[dictSearch valueForKey:@"Date"]]);
    }
    else{
        s = [database executeQuery:[NSString stringWithFormat:@"select CFFT.*,pp.*,ci.* from CFFTransaction CFFT join prospect_profile pp join contact_input ci on CFFT.ProspectIndexNo=pp.IndexNo and CFFT.ProspectIndexNo=ci.IndexNo where ci.ContactCode='CONT008' and pp.ProspectName like \"%%%@%%\" and pp.BranchName like \"%%%@%%\"",[dictSearch valueForKey:@"Name"],[dictSearch valueForKey:@"BranchName"]]];
    }
    
    //NSLog(@"query %@",[NSString stringWithFormat:@"select * from SI_Premium where SINO = \"%@\" and RiderCode=\"%@\"",SINo,riderCode]);
    while ([s next]) {
        ProspectIndex = [s intForColumn:@"IndexNo"];
        CFFTransactionID = [s intForColumn:@"CFFTransactionID"];
        ProspectName = [s stringForColumn:@"ProspectName"];
        ProspectIDNumber = [s stringForColumn:@"OtherIDTypeNo"];
        ProspectDOB = [s stringForColumn:@"ProspectDOB"];
        ProspectPrefix = [s stringForColumn:@"Prefix"];
        ProspectMobileNumber = [s stringForColumn:@"ContactNo"];
        ProspectBranch = [s stringForColumn:@"BranchName"];
        //ProspectBranch = @"";
        CFFDateCreated = [s stringForColumn:@"CFFDateCreated"];
        CFFDateModified = [s stringForColumn:@"CFFDateModified"];
        CFFStatus = [s stringForColumn:@"CFFStatus"];
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithInt:ProspectIndex],@"IndexNo",
              [NSNumber numberWithInt:CFFTransactionID],@"CFFTransactionID",
              ProspectName,@"ProspectName",
              ProspectIDNumber,@"OtherIDTypeNo",
              ProspectDOB,@"ProspectDOB",
              ProspectPrefix,@"Prefix",
              ProspectMobileNumber,@"ContactNo",
              ProspectBranch,@"BranchName",
              CFFDateCreated,@"CFFDateCreated",
              CFFDateModified,@"CFFDateModified",
              CFFStatus,@"CFFStatus",nil];
        
        [arrayDictCFF addObject:dict];
    }
    
    
    
    [results close];
    [database close];
    return arrayDictCFF;
}


@end
