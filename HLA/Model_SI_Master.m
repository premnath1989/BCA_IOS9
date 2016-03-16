//
//  Model_SI_Master.m
//  BLESS
//
//  Created by Basvi on 2/26/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "Model_SI_Master.h"

@implementation Model_SI_Master

-(void)saveIlustrationMaster:(NSDictionary *)dataIlustration{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_Master (SINO, SI_Version, ProposalStatus, CreatedDate,UpdatedDate) values (?,?,?,""datetime(\"now\", \"+8 hour\")"",""datetime(\"now\", \"+8 hour\")"")" ,
                    [dataIlustration valueForKey:@"SINO"],
                    [dataIlustration valueForKey:@"SI_Version"],
                    [dataIlustration valueForKey:@"ProposalStatus"]];
    
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
    BOOL success = [database executeUpdate:@"update SI_Master set SI_Version=?, ProposalStatus=?,UpdatedDate=""datetime(\"now\", \"+8 hour\")"" where SINO=?" ,
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

-(NSDictionary *)getIlustrationata{
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
    
   // FMResultSet *s = [database executeQuery:@"SELECT sim.*, po.ProductName,po.PO_Name,premi.Sum_Assured FROM SI_master sim, SI_PO_Data po,SI_Premium premi WHERE sim.SINO = po.SINO and sim.SINO = premi.SINO"];
     FMResultSet *s = [database executeQuery:@"SELECT sim.*, po.ProductName,po.PO_Name,sip.Sum_Assured FROM SI_master sim, SI_PO_Data po, SI_Premium sip WHERE sim.SINO = po.SINO and sim.SINO = sip.SINO group by sim.ID"];
    while ([s next]) {
        NSString *stringSINo = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SINO"]];
        NSString *stringCreatedDate = [NSString stringWithFormat:@"%@",[s stringForColumn:@"CreatedDate"]];
        NSString *stringPOName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"PO_Name"]];
        NSString *stringProductName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProductName"]];
        NSString *stringProposalStatus = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProposalStatus"]];
        NSString *stringSIVersion = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SI_Version"]];
        NSString *sumAssured = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Sum_Assured"]];
        
        NSLog(@"sumassured %@",sumAssured);
        [arraySINo addObject:stringSINo];
        [arrayCreatedDate addObject:stringCreatedDate];
        [arrayPOName addObject:stringPOName];
        [arrayProductName addObject:stringProductName];
        [arraySumAssured addObject:sumAssured];
        [arrayProposalStatus addObject:stringProposalStatus];
        [arraySIVersion addObject:stringSIVersion];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arraySINo,@"SINO", arrayCreatedDate,@"CreatedDate", arrayPOName,@"PO_Name",arrayProductName,@"ProductName",arrayProposalStatus,@"ProposalStatus",arraySIVersion,@"SI_Version",arraySumAssured,@"Sum_Assured", nil];
    
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
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *s;
    if (([dateFrom length]>0)&&([dateTo length]>0)){
        s = [database executeQuery:[NSString stringWithFormat:@"SELECT sim.*, po.ProductName,po.PO_Name,sip.Sum_Assured FROM SI_Master sim join SI_PO_Data po on sim.SINO=po.SINO join SI_Premium sip on sim.SINO=sip.SINO where sim.SINO like \"%%%@%%\" and po.PO_Name like \"%%%@%%\" and sim.CreatedDate between \"%@\" and \"%@\" group by sim.ID order by %@ %@",SINO,poName,dateFrom,dateTo,orderBy,method]];
        NSLog(@"query %@",[NSString stringWithFormat:@"SELECT sim.*, po.ProductName,po.PO_Name,sip.Sum_Assured FROM SI_Master sim join SI_PO_Data po on sim.SINO=po.SINO join SI_Premium sip on sim.SINO=sip.SINO where sim.SINO like \"%%%@%%\" and po.PO_Name like \"%%%@%%\" and sim.CreatedDate between \"%@\" and \"%@\" group by sim.ID order by %@ %@",SINO,poName,dateFrom,dateTo,orderBy,method]);
    }
    else{
        s = [database executeQuery:[NSString stringWithFormat:@"SELECT sim.*, po.ProductName,po.PO_Name,sip.Sum_Assured FROM SI_Master sim join SI_PO_Data po on sim.SINO=po.SINO join SI_Premium sip on sim.SINO=sip.SINO  where sim.SINO like \"%%%@%%\" and po.PO_Name like \"%%%@%%\" group by sim.ID order by %@ %@",SINO,poName,orderBy,method]];
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
        
        [arraySINo addObject:stringSINo];
        [arrayCreatedDate addObject:stringCreatedDate];
        [arrayPOName addObject:stringPOName];
        [arrayProductName addObject:stringProductName];
        [arraySumAssured addObject:sumAssured];
        [arrayProposalStatus addObject:stringProposalStatus];
        [arraySIVersion addObject:stringSIVersion];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arraySINo,@"SINO", arrayCreatedDate,@"CreatedDate", arrayPOName,@"PO_Name",arrayProductName,@"ProductName",arrayProposalStatus,@"ProposalStatus",arraySIVersion,@"SI_Version",arraySumAssured,@"Sum_Assured", nil];
    
    [results close];
    [database close];
    return dict;
}


@end
