//
//  Model_SI_Master.m
//  MPOS
//
//  Created by Basvi on 2/26/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Model_SI_Master.h"

@implementation Model_SI_Master

-(void)saveIlustrationMaster:(NSDictionary *)dataIlustration{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_Master (SINO, SI_Version, ProposalStatus, CreatedDate,UpdatedDate) values (?,?,?,""datetime(\"now\", \"+7 hour\")"",""datetime(\"now\", \"+7 hour\")"")" ,
                    [dataIlustration valueForKey:@"SINO"],
                    [dataIlustration valueForKey:@"SI_Version"],
                    [dataIlustration valueForKey:@"ProposalStatus"]];

    NSLog(@"log query %@",[NSString stringWithFormat:@"insert into SI_Master (SINO, SI_Version, ProposalStatus, CreatedDate,UpdatedDate) values (\"%@\",\"%@\",\"%@\",""datetime(\"now\", \"+7 hour\")"",""datetime(\"now\", \"+7 hour\")"")" ,
                           [dataIlustration valueForKey:@"SINO"],
                           [dataIlustration valueForKey:@"SI_Version"],
                           [dataIlustration valueForKey:@"ProposalStatus"]]);
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateIlustrationMaster:(NSDictionary *)dataIlustration{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"update SI_Master set SI_Version=?, ProposalStatus=?,UpdatedDate=""datetime(\"now\", \"+7 hour\")"" where SINO=?" ,
                    [dataIlustration valueForKey:@"SI_Version"],
                    [dataIlustration valueForKey:@"ProposalStatus"],
                    [dataIlustration valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateIlustrationMasterDate:(NSString *)SINO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"update SI_Master set CreatedDate=""datetime(\"now\", \"+7 hour\")"",UpdatedDate=""datetime(\"now\", \"+7 hour\")"" where SINO=?" ,
                    SINO];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)deleteIlustrationMaster:(NSString *)siNo{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"delete from SI_Master where SINO=?",siNo];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSDictionary *)getIlustrationata:(NSString *)orderBy Method:(NSString *)sortMethod{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arraySINo=[[NSMutableArray alloc] init];
    NSMutableArray* arrayCreatedDate=[[NSMutableArray alloc] init];
    NSMutableArray* arrayPOName=[[NSMutableArray alloc] init];
    NSMutableArray* arrayProductName=[[NSMutableArray alloc] init];
    NSMutableArray* arraySumAssured=[[NSMutableArray alloc] init];
    NSMutableArray* arrayProposalStatus=[[NSMutableArray alloc] init];
    NSMutableArray* arraySIVersion=[[NSMutableArray alloc] init];
    NSMutableArray* arraySIQQ=[[NSMutableArray alloc] init];
    NSMutableArray* arrayEdit=[[NSMutableArray alloc] init];
    NSMutableArray* arraySigned=[[NSMutableArray alloc] init];
    
   // FMResultSet *s = [database executeQuery:@"SELECT sim.*, po.ProductName,po.PO_Name,premi.Sum_Assured FROM SI_master sim, SI_PO_Data po,SI_Premium premi WHERE sim.SINO = po.SINO and sim.SINO = premi.SINO"];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select sim.*, po.ProductName,po.PO_Name,ifnull(sip.Sum_Assured,0) as Sum_Assured, po.QuickQuote FROM SI_master sim left join SI_PO_Data po on sim.SINO=po.SINO left join SI_Premium sip on sim.SINO=sip.SINO group by sim.ID order by %@ %@",orderBy,sortMethod]];
    
    NSLog(@"query %@",[NSString stringWithFormat:@"select sim.*, po.ProductName,po.PO_Name,ifnull(sip.Sum_Assured,0) FROM SI_master sim left join SI_PO_Data po on sim.SINO=po.SINO left join SI_Premium sip on sim.SINO=sip.SINO group by sim.ID order by %@ %@",orderBy,sortMethod]);
    
    while ([s next]) {
        NSString *stringSINo = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SINO"]];
        NSString *stringCreatedDate = [NSString stringWithFormat:@"%@",[s stringForColumn:@"CreatedDate"]];
        NSString *stringPOName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"PO_Name"]];
        NSString *stringProductName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProductName"]];
        NSString *stringProposalStatus = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProposalStatus"]];
        NSString *stringSIVersion = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SI_Version"]];
        NSString *sumAssured = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Sum_Assured"]];
        NSString *qqStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"QuickQuote"]];
        NSString *editStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"EnableEditing"]];
        NSString *signedStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IllustrationSigned"]];
        
        
        NSLog(@"sumassured %@",sumAssured);
        [arraySINo addObject:stringSINo];
        [arrayCreatedDate addObject:stringCreatedDate];
        [arrayPOName addObject:stringPOName];
        [arrayProductName addObject:stringProductName];
        [arraySumAssured addObject:sumAssured];
        [arrayProposalStatus addObject:stringProposalStatus];
        [arraySIVersion addObject:stringSIVersion];
        [arraySIQQ addObject:qqStr];
        [arrayEdit addObject:editStr];
        [arraySigned addObject:signedStr];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arraySINo,@"SINO", arrayCreatedDate,@"CreatedDate", arrayPOName,@"PO_Name",arrayProductName,@"ProductName",arrayProposalStatus,@"ProposalStatus",arraySIVersion,@"SI_Version",arraySumAssured,@"Sum_Assured", arraySIQQ, @"QuickQuote",arrayEdit, @"EnableEditing",arraySigned,@"IllustrationSigned", nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSDictionary *)getIlustrationDataForSI:(NSString *)SINO {
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    NSString *stringSINo;
    NSString *stringCreatedDate;
    NSString *stringPOName;
    NSString *stringProductName;
    NSString *stringProposalStatus;
    NSString *stringSIVersion;
    NSString *sumAssured;
    NSString *qqStr;
    NSString *editStr;
    NSString *signedStr;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
       // FMResultSet *s = [database executeQuery:@"SELECT sim.*, po.ProductName,po.PO_Name,premi.Sum_Assured FROM SI_master sim, SI_PO_Data po,SI_Premium premi WHERE sim.SINO = po.SINO and sim.SINO = premi.SINO"];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * FROM SI_master where SINO = \"%@\"",SINO]];
    
    while ([s next]) {
        stringSINo = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SINO"]];
        stringCreatedDate = [NSString stringWithFormat:@"%@",[s stringForColumn:@"CreatedDate"]];
        stringPOName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"PO_Name"]];
        stringProductName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProductName"]];
        stringProposalStatus = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProposalStatus"]];
        stringSIVersion = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SI_Version"]];
        sumAssured = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Sum_Assured"]];
        qqStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"QuickQuote"]];
        editStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"EnableEditing"]];
        signedStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IllustrationSigned"]];
        
        NSLog(@"sumassured %@",sumAssured);
}
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:stringSINo,@"SINO", stringCreatedDate,@"CreatedDate", stringPOName,@"PO_Name",stringProductName,@"ProductName",stringProposalStatus,@"ProposalStatus",stringSIVersion,@"SI_Version",sumAssured,@"Sum_Assured", qqStr, @"QuickQuote",editStr, @"EnableEditing",signedStr,@"IllustrationSigned", nil];
    
    [results close];
    [database close];
    return dict;
}


-(NSDictionary *)getNonQuickQuoteIlustrationata:(NSString *)orderBy Method:(NSString *)sortMethod{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arraySINo=[[NSMutableArray alloc] init];
    NSMutableArray* arrayCreatedDate=[[NSMutableArray alloc] init];
    NSMutableArray* arrayPOName=[[NSMutableArray alloc] init];
    NSMutableArray* arrayProductName=[[NSMutableArray alloc] init];
    NSMutableArray* arraySumAssured=[[NSMutableArray alloc] init];
    NSMutableArray* arrayProposalStatus=[[NSMutableArray alloc] init];
    NSMutableArray* arraySIVersion=[[NSMutableArray alloc] init];
    NSMutableArray* arraySIQQ=[[NSMutableArray alloc] init];
    NSMutableArray* arrayEdit=[[NSMutableArray alloc] init];
    NSMutableArray* arraySigned=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select sim.*, po.ProductName,po.PO_Name,ifnull(sip.Sum_Assured,0) as Sum_Assured, po.QuickQuote FROM SI_Master sim left join SI_PO_Data po on sim.SINO=po.SINO left join SI_Premium sip on sim.SINO=sip.SINO where sim.IllustrationSigned=0 and po.QuickQuote=0 and po.SINO not in (select SPAJSINO from SPAJTransaction) group by sim.ID order by %@ %@",orderBy,sortMethod]];
    
    NSLog(@"query %@",[NSString stringWithFormat:@"select sim.*, po.ProductName,po.PO_Name,ifnull(sip.Sum_Assured,0) FROM SI_master sim left join SI_PO_Data po on sim.SINO=po.SINO left join SI_Premium sip on sim.SINO=sip.SINO group by sim.ID order by %@ %@",orderBy,sortMethod]);
    
    while ([s next]) {
        NSString *stringSINo = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SINO"]];
        NSString *stringCreatedDate = [NSString stringWithFormat:@"%@",[s stringForColumn:@"CreatedDate"]];
        NSString *stringPOName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"PO_Name"]];
        NSString *stringProductName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProductName"]];
        NSString *stringProposalStatus = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProposalStatus"]];
        NSString *stringSIVersion = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SI_Version"]];
        NSString *sumAssured = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Sum_Assured"]];
        NSString *qqStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"QuickQuote"]];
        NSString *editStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"EnableEditing"]];
        NSString *signedStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IllustrationSigned"]];
        
        
        NSLog(@"sumassured %@",sumAssured);
        [arraySINo addObject:stringSINo];
        [arrayCreatedDate addObject:stringCreatedDate];
        [arrayPOName addObject:stringPOName];
        [arrayProductName addObject:stringProductName];
        [arraySumAssured addObject:sumAssured];
        [arrayProposalStatus addObject:stringProposalStatus];
        [arraySIVersion addObject:stringSIVersion];
        [arraySIQQ addObject:qqStr];
        [arrayEdit addObject:editStr];
        [arraySigned addObject:signedStr];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arraySINo,@"SINO", arrayCreatedDate,@"CreatedDate", arrayPOName,@"PO_Name",arrayProductName,@"ProductName",arrayProposalStatus,@"ProposalStatus",arraySIVersion,@"SI_Version",arraySumAssured,@"Sum_Assured", arraySIQQ, @"QuickQuote",arrayEdit, @"EnableEditing",arraySigned,@"IllustrationSigned", nil];
    
    [results close];
    [database close];
    return dict;
}

-(int)getMasterCount:(NSString *)SINo{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_master where SINO = \"%@\"",SINo]];
    while ([s next]) {
        count = [s intForColumn:@"count"];
    }
    
    [results close];
    [database close];
    return count;
}

-(NSDictionary *)searchSIListingByName:(NSString *)SINO POName:(NSString *)poName Order:(NSString *)orderBy Method:(NSString *)method DateFrom:(NSString *)dateFrom DateTo:(NSString *)dateTo{
    NSDictionary *dict ;
    
    NSMutableArray* arraySINo=[[NSMutableArray alloc] init];
    NSMutableArray* arrayCreatedDate=[[NSMutableArray alloc] init];
    NSMutableArray* arrayPOName=[[NSMutableArray alloc] init];
    NSMutableArray* arrayProductName=[[NSMutableArray alloc] init];
    NSMutableArray* arraySumAssured=[[NSMutableArray alloc] init];
    NSMutableArray* arrayProposalStatus=[[NSMutableArray alloc] init];
    NSMutableArray* arraySIVersion=[[NSMutableArray alloc] init];
    NSMutableArray* arrayQQ=[[NSMutableArray alloc] init];
    NSMutableArray* arrayEdit=[[NSMutableArray alloc] init];
    NSMutableArray* arraySigned=[[NSMutableArray alloc] init];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *s;
    if (([dateFrom length]>0)&&([dateTo length]>0)){
        NSMutableString* dateFromNew=[[NSMutableString alloc]initWithString:dateFrom];
        NSMutableString* dateToNew=[[NSMutableString alloc]initWithString:dateTo];
        [dateFromNew appendString:@" 00:00:00"];
        [dateToNew appendString:@" 24:00:00"];
        s = [database executeQuery:[NSString stringWithFormat:@"SELECT sim.*, po.ProductName,po.PO_Name,ifnull(sip.Sum_Assured,0) as Sum_Assured, po.QuickQuote FROM SI_Master sim left join SI_PO_Data po on sim.SINO=po.SINO left join SI_Premium sip on sim.SINO=sip.SINO where sim.SINO like \"%%%@%%\" and po.PO_Name like \"%%%@%%\" and sim.CreatedDate between \"%@\" and \"%@\" group by sim.ID order by %@ %@",SINO,poName,dateFromNew,dateToNew,orderBy,method]];
        NSLog(@"query %@",[NSString stringWithFormat:@"SELECT sim.*, po.ProductName,po.PO_Name,ifnull(sip.Sum_Assured,0) FROM SI_Master sim join SI_PO_Data po on sim.SINO=po.SINO join SI_Premium sip on sim.SINO=sip.SINO where sim.SINO like \"%%%@%%\" and po.PO_Name like \"%%%@%%\" and sim.CreatedDate between \"%@\" and \"%@\" group by sim.ID order by %@ %@",SINO,poName,dateFromNew,dateToNew,orderBy,method]);
    }
    else{
        s = [database executeQuery:[NSString stringWithFormat:@"SELECT sim.*, po.ProductName,po.PO_Name,ifnull(sip.Sum_Assured,0) as Sum_Assured, po.QuickQuote FROM SI_Master sim left join SI_PO_Data po on sim.SINO=po.SINO left join SI_Premium sip on sim.SINO=sip.SINO  where sim.SINO like \"%%%@%%\" and po.PO_Name like \"%%%@%%\" group by sim.ID order by %@ %@",SINO,poName,orderBy,method]];
    }

    while ([s next]) {
        NSLog(@"SINO %@",[NSString stringWithFormat:@"%@",[s stringForColumn:@"SINO"]]);
        //occpToEnableSection = [results stringForColumn:@"OccpCode"];
        NSString *stringSINo = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SINO"]];
        NSString *stringCreatedDate = [NSString stringWithFormat:@"%@",[s stringForColumn:@"CreatedDate"]];
        NSString *stringPOName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"PO_Name"]];
        NSString *stringProductName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProductName"]];
        NSString *stringProposalStatus = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProposalStatus"]];
        NSString *stringSIVersion = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SI_Version"]];
        NSString *sumAssured = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Sum_Assured"]];
        NSString *qqStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"QuickQuote"]];
        NSString *editStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"EnableEditing"]];
        NSString *signedStr = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IllustrationSigned"]];
        
        [arraySINo addObject:stringSINo];
        [arrayCreatedDate addObject:stringCreatedDate];
        [arrayPOName addObject:stringPOName];
        [arrayProductName addObject:stringProductName];
        [arraySumAssured addObject:sumAssured];
        [arrayProposalStatus addObject:stringProposalStatus];
        [arraySIVersion addObject:stringSIVersion];
        [arrayQQ addObject:qqStr];
        [arrayEdit addObject:editStr];
        [arraySigned addObject:signedStr];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arraySINo,@"SINO", arrayCreatedDate,@"CreatedDate", arrayPOName,@"PO_Name",arrayProductName,@"ProductName",arrayProposalStatus,@"ProposalStatus",arraySIVersion,@"SI_Version",arraySumAssured,@"Sum_Assured",arrayQQ, @"QuickQuote", arrayEdit, @"EnableEditing",arraySigned,@"IllustrationSigned", nil];
    
    [results close];
    [database close];
    return dict;
}

-(void)signIlustrationMaster:(NSString *)SINO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"update SI_Master set IllustrationSigned=\"0\" where SINO=?",SINO];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(BOOL)isSignedIlustration:(NSString *)SINo{
    NSString* signedIllustration;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select IllustrationSigned from SI_Master where SINO = \"%@\"",SINo]];
    while ([s next]) {
        signedIllustration = [s stringForColumn:@"IllustrationSigned"];
    }
    
    [results close];
    [database close];
    
    if ([signedIllustration isEqualToString:@"0"]){
        return true;
    }
    else{
        return false;
    }
}

@end
