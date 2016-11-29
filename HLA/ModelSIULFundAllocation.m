//
//  ModelSIULFundAllocation.m
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSIULFundAllocation.h"

@implementation ModelSIULFundAllocation
-(int)getULFundAllocationDataCount:(NSString *)SINo{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_UL_FundAllocation where SINO = \"%@\"",SINo]];
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(void)saveULFundAllocationData:(NSMutableDictionary *)dictULFundAllocationData{
    //cek the SINO exist or not
    int exist = [self getULFundAllocationDataCount:[dictULFundAllocationData valueForKey:@"SINO"]];
    
    if (exist>0){
        //update data
        [self updateULFundAllocationData:dictULFundAllocationData];
    }
    else{
        //insert data
        [self insertToDBULFundAllocationData:dictULFundAllocationData];
    }
}

-(void)insertToDBULFundAllocationData:(NSMutableDictionary *)dictULFundAllocationData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_UL_FundAllocation (SINO, DanaProteksiNusantara, DanaEkuitasNusantara, DanaObligasiNusantara,BNPParibasCashInvestFund,DanaProgresifNusantara,IDRFixedIncomeFund,IDREquityIncomeFund,USDFixedIncomeFund,USDEquityIncomeFund) values (?,?,?,?,?,?,?,?,?,?)",
                    [dictULFundAllocationData valueForKey:@"SINO"],
                    [dictULFundAllocationData valueForKey:@"DanaProteksiNusantara"],
                    [dictULFundAllocationData valueForKey:@"DanaEkuitasNusantara"],
                    [dictULFundAllocationData valueForKey:@"DanaObligasiNusantara"],
                    [dictULFundAllocationData valueForKey:@"BNPParibasCashInvestFund"],
                    [dictULFundAllocationData valueForKey:@"DanaProgresifNusantara"],
                    [dictULFundAllocationData valueForKey:@"IDRFixedIncomeFund"],
                    [dictULFundAllocationData valueForKey:@"IDREquityIncomeFund"],[dictULFundAllocationData valueForKey:@"USDFixedIncomeFund"],
                    [dictULFundAllocationData valueForKey:@"USDEquityIncomeFund"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateULFundAllocationData:(NSMutableDictionary *)dictULFundAllocationData{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path] ;
    [database open];
    BOOL success = [database executeUpdate:@"update SI_UL_FundAllocation set DanaProteksiNusantara=?, DanaEkuitasNusantara=?, DanaObligasiNusantara=?,BNPParibasCashInvestFund=?,DanaProgresifNusantara=?,IDRFixedIncomeFund=?, IDREquityIncomeFund=?,USDFixedIncomeFund=?,USDEquityIncomeFund=? where SINO=?" ,
                    [dictULFundAllocationData valueForKey:@"DanaProteksiNusantara"],
                    [dictULFundAllocationData valueForKey:@"DanaEkuitasNusantara"],
                    [dictULFundAllocationData valueForKey:@"DanaObligasiNusantara"],
                    [dictULFundAllocationData valueForKey:@"BNPParibasCashInvestFund"],
                    [dictULFundAllocationData valueForKey:@"DanaProgresifNusantara"],
                    [dictULFundAllocationData valueForKey:@"IDRFixedIncomeFund"],
                    [dictULFundAllocationData valueForKey:@"IDREquityIncomeFund"],
                    [dictULFundAllocationData valueForKey:@"USDFixedIncomeFund"],[dictULFundAllocationData valueForKey:@"USDEquityIncomeFund"],
                    [dictULFundAllocationData valueForKey:@"SINO"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSDictionary *)getULFundAllocationDataFor:(NSString *)SINo{
    NSDictionary *dict;
    
    NSString* SINO;
    NSString* DanaProteksiNusantara;
    NSString* DanaEkuitasNusantara;
    NSString* DanaObligasiNusantara;
    NSString* BNPParibasCashInvestFund;
    NSString* DanaProgresifNusantara;
    NSString* IDRFixedIncomeFund;
    NSString* IDREquityIncomeFund;
    NSString* USDFixedIncomeFund;
    NSString* USDEquityIncomeFund;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_UL_FundAllocation where SINO = \"%@\"",SINo]];
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        DanaProteksiNusantara = [s stringForColumn:@"DanaProteksiNusantara"];
        DanaEkuitasNusantara = [s stringForColumn:@"DanaEkuitasNusantara"];
        DanaObligasiNusantara = [s stringForColumn:@"DanaObligasiNusantara"];
        BNPParibasCashInvestFund = [s stringForColumn:@"BNPParibasCashInvestFund"];
        DanaProgresifNusantara = [s stringForColumn:@"DanaProgresifNusantara"];
        IDRFixedIncomeFund = [s stringForColumn:@"IDRFixedIncomeFund"];
        IDREquityIncomeFund = [s stringForColumn:@"IDREquityIncomeFund"];
        USDFixedIncomeFund = [s stringForColumn:@"USDFixedIncomeFund"];
        USDEquityIncomeFund = [s stringForColumn:@"USDEquityIncomeFund"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          SINO,@"SINO",
          DanaProteksiNusantara,@"DanaProteksiNusantara",
          DanaEkuitasNusantara,@"DanaEkuitasNusantara",
          DanaObligasiNusantara,@"DanaObligasiNusantara",
          BNPParibasCashInvestFund,@"BNPParibasCashInvestFund",
          DanaProgresifNusantara,@"DanaProgresifNusantara",
          IDRFixedIncomeFund,@"IDRFixedIncomeFund",
          IDREquityIncomeFund,@"IDREquityIncomeFund",
          USDFixedIncomeFund,@"USDFixedIncomeFund",
          USDEquityIncomeFund,@"USDEquityIncomeFund",
          nil];
    
    [results close];
    [database close];
    return dict;
}
@end
