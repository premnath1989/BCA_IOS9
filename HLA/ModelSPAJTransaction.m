//
//  ModelSPAJTransaction.m
//  BLESS
//
//  Created by Basvi on 7/28/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJTransaction.h"


@implementation ModelSPAJTransaction

-(NSMutableArray *)getAllSPAJ:(NSString *)sortedBy SortMethod:(NSString *)sortMethod{
    NSMutableArray* arrayDictSPAJ = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *ProspectName;
    NSString *ProspectIDDesc;
    NSString *ProspectIDNumber;
    NSString *SPAJEAppNumber;
    NSString *SPAJNumber;
    NSString *SPAJDateCreated;
    NSString *SPAJDateModified;
    NSString *SPAJDateExpired;
    NSString *SPAJStatus;
    NSString *SPAJCompleteness;
    NSString *SPAJSINO;
    
    int ProspectIndex;
    int SPAJTransactionID;
    int SPAJID;
    
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT spajtrans.*,sipo.*,pp.*,ep.* FROM SPAJTransaction spajtrans left join SI_PO_Data sipo on spajtrans.SPAJSINO = sipo.SINO left join prospect_profile pp on sipo.PO_ClientID = pp.IndexNo left join eProposal_Identification ep on pp.OtherIDType=ep.DataIdentifier where spajtrans.SPAJStatus='EAPP' order by %@ %@",sortedBy,sortMethod]];
    
    while ([s next]) {
        ProspectIndex = [s intForColumn:@"IndexNo"];
        SPAJTransactionID = [s intForColumn:@"SPAJTransactionID"];
        SPAJID = [s intForColumn:@"SPAJID"];
        ProspectName = [s stringForColumn:@"ProspectName"]?:@"";
        ProspectIDDesc = [s stringForColumn:@"IdentityDesc"]?:@"";
        ProspectIDNumber = [s stringForColumn:@"OtherIDTypeNo"]?:@"";
        SPAJDateCreated = [s stringForColumn:@"SPAJDateCreated"]?:@"";
        SPAJDateModified = [s stringForColumn:@"SPAJDateModified"]?:@"";
        SPAJDateExpired = [s stringForColumn:@"SPAJDateExpired"]?:@"";
        SPAJStatus = [s stringForColumn:@"SPAJStatus"]?:@"";
        SPAJCompleteness = [s stringForColumn:@"SPAJCompleteness"]?:@"";
        SPAJEAppNumber = [s stringForColumn:@"SPAJEappNumber"]?:@"";
        SPAJNumber = [s stringForColumn:@"SPAJNumber"]?:@"";
        SPAJSINO = [s stringForColumn:@"SPAJSINO"]?:@"";
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithInt:ProspectIndex],@"IndexNo",
              [NSNumber numberWithInt:SPAJTransactionID],@"SPAJTransactionID",
              [NSNumber numberWithInt:SPAJID],@"SPAJID",
              ProspectName,@"ProspectName",
              ProspectIDNumber,@"OtherIDTypeNo",
              SPAJDateCreated,@"SPAJDateCreated",
              SPAJDateModified,@"SPAJDateModified",
              SPAJDateExpired,@"SPAJDateExpired",
              SPAJStatus,@"SPAJStatus",
              SPAJCompleteness,@"SPAJCompleteness",
              ProspectIDDesc,@"IdentityDesc",
              SPAJEAppNumber,@"SPAJEappNumber",
              SPAJNumber,@"SPAJNumber",
              SPAJSINO,@"SPAJSINO",nil];
        
        [arrayDictSPAJ addObject:dict];
    }
    
    [results close];
    [database close];
    return arrayDictSPAJ;
}

-(NSMutableArray *)getAllReadySPAJ:(NSString *)sortedBy SortMethod:(NSString *)sortMethod SPAJStatus:(NSString *)stringSPAJStatus{
    NSMutableArray* arrayDictSPAJ = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *ProspectName;
    NSString *ProspectIDDesc;
    NSString *ProspectIDNumber;
    NSString *SPAJEAppNumber;
    NSString *SPAJNumber;
    NSString *SPAJProduct;
    NSString *SPAJDateCreated;
    NSString *SPAJDateModified;
    NSString *SPAJDateExpired;
    NSString *SPAJStatus;
    NSString *SPAJCompleteness;
    NSString *SPAJSINO;
    NSString *SPAJSIVersion;
    
    int ProspectIndex;
    int SPAJTransactionID;
    int SPAJID;
    
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT spajtrans.*,sipo.*,pp.*,ep.*,sim.SI_Version FROM SPAJTransaction spajtrans left join SI_Master sim on spajtrans.SPAJSINO = sim.SINO left join SI_PO_Data sipo on spajtrans.SPAJSINO = sipo.SINO left join prospect_profile pp on sipo.PO_ClientID = pp.IndexNo left join eProposal_Identification ep on pp.OtherIDType=ep.DataIdentifier where spajtrans.SPAJNumber <>'' and spajtrans.SPAJStatus in (%@) order by %@ %@",stringSPAJStatus,sortedBy,sortMethod]];
    
    while ([s next]) {
        ProspectIndex = [s intForColumn:@"IndexNo"];
        SPAJTransactionID = [s intForColumn:@"SPAJTransactionID"];
        SPAJID = [s intForColumn:@"SPAJID"];
        ProspectName = [s stringForColumn:@"ProspectName"]?:@"";
        ProspectIDDesc = [s stringForColumn:@"IdentityDesc"]?:@"";
        ProspectIDNumber = [s stringForColumn:@"OtherIDTypeNo"]?:@"";
        SPAJDateCreated = [s stringForColumn:@"SPAJDateCreated"]?:@"";
        SPAJDateModified = [s stringForColumn:@"SPAJDateModified"]?:@"";
        SPAJDateExpired = [s stringForColumn:@"SPAJDateExpired"]?:@"";
        SPAJStatus = [s stringForColumn:@"SPAJStatus"]?:@"";
        SPAJCompleteness = [s stringForColumn:@"SPAJCompleteness"]?:@"";
        SPAJEAppNumber = [s stringForColumn:@"SPAJEappNumber"]?:@"";
        SPAJNumber = [s stringForColumn:@"SPAJNumber"]?:@"";
        SPAJProduct = [s stringForColumn:@"ProductName"]?:@"";
        SPAJSINO = [s stringForColumn:@"SPAJSINO"]?:@"";
        SPAJSIVersion = [s stringForColumn:@"SI_Version"]?:@"";
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithInt:ProspectIndex],@"IndexNo",
              [NSNumber numberWithInt:SPAJTransactionID],@"SPAJTransactionID",
              [NSNumber numberWithInt:SPAJID],@"SPAJID",
              ProspectName,@"ProspectName",
              ProspectIDNumber,@"OtherIDTypeNo",
              SPAJDateCreated,@"SPAJDateCreated",
              SPAJDateModified,@"SPAJDateModified",
              SPAJDateExpired,@"SPAJDateExpired",
              SPAJStatus,@"SPAJStatus",
              SPAJCompleteness,@"SPAJCompleteness",
              ProspectIDDesc,@"IdentityDesc",
              SPAJEAppNumber,@"SPAJEappNumber",
              SPAJNumber,@"SPAJNumber",
              SPAJProduct,@"ProductName",
              SPAJSINO,@"SPAJSINO",
              SPAJSIVersion,@"SI_Version",nil];
        
        [arrayDictSPAJ addObject:dict];
    }
    
    //[results close];
    [database close];
    return arrayDictSPAJ;
}

-(NSMutableArray *)searchReadySPAJ:(NSDictionary *)dictSearch{
    NSMutableArray* arrayDictSPAJ = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *ProspectName;
    NSString *ProspectIDDesc;
    NSString *ProspectIDNumber;
    NSString *SPAJEAppNumber;
    NSString *SPAJNumber;
    NSString *SPAJProduct;
    NSString *SPAJDateCreated;
    NSString *SPAJDateModified;
    NSString *SPAJDateExpired;
    NSString *SPAJStatus;
    NSString *SPAJCompleteness;
    NSString *SPAJSINO;
    NSString *SPAJSIVersion;
    
    int ProspectIndex;
    int SPAJTransactionID;
    int SPAJID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    NSString *stringIDNumber = [dictSearch valueForKey:@"IDNo"];
    NSString *stringName = [dictSearch valueForKey:@"Name"];
    NSString *stringSPAJNumber = [dictSearch valueForKey:@"SPAJNumber"];
    NSString *stringSPAJStatus = [dictSearch valueForKey:@"SPAJStatus"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"SELECT spajtrans.*,sipo.*,pp.*,ep.*,sim.SI_Version FROM SPAJTransaction spajtrans left join SI_Master sim on spajtrans.SPAJSINO = sim.SINO left join SI_PO_Data sipo on spajtrans.SPAJSINO = sipo.SINO left join prospect_profile pp on sipo.PO_ClientID = pp.IndexNo left join eProposal_Identification ep on pp.OtherIDType=ep.DataIdentifier where spajtrans.SPAJNumber like \"%%%@%%\" and pp.ProspectName like \"%%%@%%\" and pp.OtherIDTypeNo like \"%%%@%%\" and spajtrans.SPAJStatus in (%@)",stringSPAJNumber,stringName,stringIDNumber,stringSPAJStatus]];
    
    
    NSLog(@"query %@",[NSString stringWithFormat:@"SELECT spajtrans.*,sipo.*,pp.*,ep.*,sim.SI_Version FROM SPAJTransaction spajtrans SI_Master sim on spajtrans.SPAJSINO = sim.SINO left join SI_PO_Data sipo on spajtrans.SPAJSINO = sipo.SINO left join prospect_profile pp on sipo.PO_ClientID = pp.IndexNo left join eProposal_Identification ep on pp.OtherIDType=ep.DataIdentifier where spajtrans.SPAJNumber like \"%%%@%%\" and pp.ProspectName like \"%%%@%%\" and pp.OtherIDTypeNo like \"%%%@%%\"",stringSPAJNumber,stringName,stringIDNumber]);
    while ([s next]) {
        ProspectIndex = [s intForColumn:@"IndexNo"];
        SPAJTransactionID = [s intForColumn:@"SPAJTransactionID"];
        SPAJID = [s intForColumn:@"SPAJID"];
        ProspectName = [s stringForColumn:@"ProspectName"]?:@"";
        ProspectIDDesc = [s stringForColumn:@"IdentityDesc"]?:@"";
        ProspectIDNumber = [s stringForColumn:@"OtherIDTypeNo"]?:@"";
        SPAJDateCreated = [s stringForColumn:@"SPAJDateCreated"]?:@"";
        SPAJDateModified = [s stringForColumn:@"SPAJDateModified"]?:@"";
        SPAJDateExpired = [s stringForColumn:@"SPAJDateExpired"]?:@"";
        SPAJStatus = [s stringForColumn:@"SPAJStatus"]?:@"";
        SPAJCompleteness = [s stringForColumn:@"SPAJCompleteness"]?:@"";
        SPAJEAppNumber = [s stringForColumn:@"SPAJEappNumber"]?:@"";
        SPAJNumber = [s stringForColumn:@"SPAJNumber"]?:@"";
        SPAJProduct = [s stringForColumn:@"ProductName"]?:@"";
        SPAJSINO = [s stringForColumn:@"SPAJSINO"]?:@"";
        SPAJSIVersion = [s stringForColumn:@"SI_Version"]?:@"";
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithInt:ProspectIndex],@"IndexNo",
              [NSNumber numberWithInt:SPAJTransactionID],@"SPAJTransactionID",
              [NSNumber numberWithInt:SPAJID],@"SPAJID",
              ProspectName,@"ProspectName",
              ProspectIDNumber,@"OtherIDTypeNo",
              SPAJDateCreated,@"SPAJDateCreated",
              SPAJDateModified,@"SPAJDateModified",
              SPAJDateExpired,@"SPAJDateExpired",
              SPAJStatus,@"SPAJStatus",
              SPAJCompleteness,@"SPAJCompleteness",
              ProspectIDDesc,@"IdentityDesc",
              SPAJEAppNumber,@"SPAJEappNumber",
              SPAJNumber,@"SPAJNumber",
              SPAJProduct,@"ProductName",
              SPAJSINO,@"SPAJSINO",
              SPAJSIVersion,@"SI_Version",nil];
        
        
        [arrayDictSPAJ addObject:dict];
    }
    
    [results close];
    [database close];
    return arrayDictSPAJ;
}


-(NSMutableArray *)searchSPAJ:(NSDictionary *)dictSearch{
    NSMutableArray* arrayDictSPAJ = [[NSMutableArray alloc]init];
    NSDictionary *dict;
    
    NSString *ProspectName;
    NSString *ProspectIDDesc;
    NSString *ProspectIDNumber;
    NSString *SPAJEAppNumber;
    NSString *SPAJNumber;
    NSString *SPAJDateCreated;
    NSString *SPAJDateModified;
    NSString *SPAJDateExpired;
    NSString *SPAJStatus;
    NSString *SPAJSINO;
    
    int ProspectIndex;
    int SPAJTransactionID;
    int SPAJID;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s;
    s = [database executeQuery:[NSString stringWithFormat:@"SELECT spajtrans.*,sipo.*,pp.*,ep.* FROM SPAJTransaction spajtrans left join SI_PO_Data sipo on spajtrans.SPAJSINO = sipo.SINO left join prospect_profile pp on sipo.PO_ClientID = pp.IndexNo left join eProposal_Identification ep on pp.OtherIDType=ep.DataIdentifier where where spajtrans.SPAJStatus='EAPP' and pp.ProspectName like \"%%%@%%\" and spajtrans.SPAJEappNumber like \"%%%@%%\"",[dictSearch valueForKey:@"Name"],[dictSearch valueForKey:@"SPAJEappNumber"]]];
    
    
    //NSLog(@"query %@",[NSString stringWithFormat:@"select * from SI_Premium where SINO = \"%@\" and RiderCode=\"%@\"",SINo,riderCode]);
    while ([s next]) {
        ProspectIndex = [s intForColumn:@"IndexNo"];
        SPAJTransactionID = [s intForColumn:@"SPAJTransactionID"];
        SPAJID = [s intForColumn:@"SPAJID"];
        ProspectName = [s stringForColumn:@"ProspectName"]?:@"";
        ProspectIDDesc = [s stringForColumn:@"IdentityDesc"]?:@"";
        ProspectIDNumber = [s stringForColumn:@"OtherIDTypeNo"]?:@"";
        SPAJDateCreated = [s stringForColumn:@"SPAJDateCreated"]?:@"";
        SPAJDateModified = [s stringForColumn:@"SPAJDateModified"]?:@"";
        SPAJDateExpired = [s stringForColumn:@"SPAJDateExpired"]?:@"";
        SPAJStatus = [s stringForColumn:@"SPAJStatus"]?:@"";
        SPAJEAppNumber = [s stringForColumn:@"SPAJEappNumber"]?:@"";
        SPAJNumber = [s stringForColumn:@"SPAJNumber"]?:@"";
        SPAJSINO = [s stringForColumn:@"SPAJSINO"]?:@"";
        
        dict=[[NSDictionary alloc]initWithObjectsAndKeys:
              [NSNumber numberWithInt:ProspectIndex],@"IndexNo",
              [NSNumber numberWithInt:SPAJTransactionID],@"SPAJTransactionID",
              [NSNumber numberWithInt:SPAJID],@"SPAJID",
              ProspectName,@"ProspectName",
              ProspectIDNumber,@"OtherIDTypeNo",
              SPAJDateCreated,@"SPAJDateCreated",
              SPAJDateModified,@"SPAJDateModified",
              SPAJDateExpired,@"SPAJDateExpired",
              SPAJStatus,@"SPAJStatus",
              ProspectIDDesc,@"IdentityDesc",
              SPAJEAppNumber,@"SPAJEappNumber",
              SPAJNumber,@"SPAJNumber",
              SPAJSINO,@"SPAJSINO",nil];

        
        [arrayDictSPAJ addObject:dict];
    }
    
    [results close];
    [database close];
    return arrayDictSPAJ;
}



-(void)saveSPAJTransaction:(NSDictionary *)spajTransactionDictionary{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into SPAJTransaction (SPAJID,SPAJEappNumber,SPAJNumber,SPAJSINO, SPAJDateCreated,CreatedBy,SPAJDateModified,ModifiedBy,SPAJStatus,SPAJCompleteness) values (?,?,?,?,?,?,?,?,?,?)" ,
                    [spajTransactionDictionary valueForKey:@"SPAJID"],
                    [spajTransactionDictionary valueForKey:@"SPAJEappNumber"],
                    [spajTransactionDictionary valueForKey:@"SPAJNumber"],
                    [spajTransactionDictionary valueForKey:@"SPAJSINO"],
                    [spajTransactionDictionary valueForKey:@"SPAJDateCreated"],
                    [spajTransactionDictionary valueForKey:@"CreatedBy"],
                    [spajTransactionDictionary valueForKey:@"SPAJDateModified"],
                    [spajTransactionDictionary valueForKey:@"ModifiedBy"],
                    [spajTransactionDictionary valueForKey:@"SPAJStatus"],
                    [spajTransactionDictionary valueForKey:@"SPAJCompleteness"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateSPAJTransaction:(NSString *)stringColumnName StringColumnValue:(NSString *)stringColumnValue StringWhereName:(NSString *)stringWhereName StringWhereValue:(NSString *)stringWhereValue{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"update SPAJTransaction set %@ = '%@'  where %@ = '%@'",
                    stringColumnName,
                    stringColumnValue,
                    stringWhereName,
                    stringWhereValue]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)voidHideExpiredSPAJ{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"Update SPAJTransaction set  SPAJStatus = ? where SPAJStatus in ('EAPP','ExistingList') and datetime(\"now\",\"+7 hour\") > SPAJDateExpired",@"VOID"];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)deleteSPAJTransaction:(NSString *)stringTableName StringWhereName:(NSString *)stringWhereName StringWhereValue:(NSString *)stringWhereValue{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"delete from  %@ where %@ = '%@'",stringTableName,stringWhereName,stringWhereValue]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


-(NSString *)getSPAJTransactionData:(NSString *)stringColumnName StringWhereName:(NSString *)stringWhereName StringWhereValue:(NSString *)stringWhereValue{
    NSString *returnValue;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJTransaction where %@ = '%@'",
                                            stringColumnName,
                                            stringWhereName,
                                            stringWhereValue]];
    
    while ([s next]) {
        returnValue = [s stringForColumn:stringColumnName];
    }
    [results close];
    [database close];
    return returnValue;
}



@end
