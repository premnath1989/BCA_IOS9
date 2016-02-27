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
     FMResultSet *s = [database executeQuery:@"SELECT sim.*, po.ProductName,po.PO_Name FROM SI_master sim, SI_PO_Data po WHERE sim.SINO = po.SINO"];
    while ([s next]) {
        NSString *stringSINo = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SINO"]];
        NSString *stringCreatedDate = [NSString stringWithFormat:@"%@",[s stringForColumn:@"CreatedDate"]];
        NSString *stringPOName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"PO_Name"]];
        NSString *stringProductName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProductName"]];
        NSString *stringProposalStatus = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ProposalStatus"]];
        NSString *stringSIVersion = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SI_Version"]];
        //double sumAssured = [s doubleForColumn:@"Sum_Assured"];

        [arraySINo addObject:stringSINo];
        [arrayCreatedDate addObject:stringCreatedDate];
        [arrayPOName addObject:stringPOName];
        [arrayProductName addObject:stringProductName];
        //[arraySumAssured addObject:[NSNumber numberWithDouble:sumAssured]];
        [arrayProposalStatus addObject:stringProposalStatus];
        [arraySIVersion addObject:stringSIVersion];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arraySINo,@"SINO", arrayCreatedDate,@"CreatedDate", arrayPOName,@"PO_Name",arrayProductName,@"ProductName",arrayProposalStatus,@"ProposalStatus",arraySIVersion,@"SI_Version",/*arraySumAssured,@"Sum_Assured",*/ nil];
    
    [results close];
    [database close];
    return dict;
}


@end
