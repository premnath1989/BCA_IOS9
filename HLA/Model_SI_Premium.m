//
//  Model_SI_Premium.m
//  MPOS
//
//  Created by Basvi on 2/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Model_SI_Premium.h"


@implementation Model_SI_Premium

-(void)savePremium:(NSDictionary *)dataPremium{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into SI_Premium (SINO, Sum_Assured, Payment_Term, Payment_Frequency,PremiumPolicyA,ExtraPremiumPercentage,ExtraPremiumSum,ExtraPremiumTerm,ExtraPremiumPolicy,TotalPremiumLoading,SubTotalPremium,CreatedDate,UpdatedDate,PurchaseNumber,Discount) values (?,?,?,?,?,?,?,?,?,?,?,""datetime(\"now\", \"+7 hour\")"",""datetime(\"now\", \"+7 hour\")"",?,?)" ,
                    [dataPremium valueForKey:@"SINO"],
                    [dataPremium valueForKey:@"Sum_Assured"],
                    [dataPremium valueForKey:@"Payment_Term"],
                    [dataPremium valueForKey:@"Payment_Frequency"],
                    [dataPremium valueForKey:@"PremiumPolicyA"],
                    [dataPremium valueForKey:@"ExtraPremiumPercentage"],
                    [dataPremium valueForKey:@"ExtraPremiumSum"],
                    [dataPremium valueForKey:@"ExtraPremiumTerm"],
                    [dataPremium valueForKey:@"ExtraPremiumPolicy"],
                    [dataPremium valueForKey:@"TotalPremiumLoading"],
                    [dataPremium valueForKey:@"SubTotalPremium"],
                    [dataPremium valueForKey:@"PurchaseNumber"],
                    [dataPremium valueForKey:@"Discount"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updatePremium:(NSDictionary *)dataPremium{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"update SI_Premium set Sum_Assured=?, Payment_Term=?, Payment_Frequency=?,PremiumPolicyA=?,ExtraPremiumPercentage=?,ExtraPremiumSum=?,ExtraPremiumTerm=?,ExtraPremiumPolicy=?,TotalPremiumLoading=?,SubTotalPremium=?,UpdatedDate=""datetime(\"now\", \"+7 hour\")"",PurchaseNumber=?,Discount=? where SINO=?" ,
                    [dataPremium valueForKey:@"Sum_Assured"],
                    [dataPremium valueForKey:@"Payment_Term"],
                    [dataPremium valueForKey:@"Payment_Frequency"],
                    [dataPremium valueForKey:@"PremiumPolicyA"],
                    [dataPremium valueForKey:@"ExtraPremiumPercentage"],
                    [dataPremium valueForKey:@"ExtraPremiumSum"],
                    [dataPremium valueForKey:@"ExtraPremiumTerm"],
                    [dataPremium valueForKey:@"ExtraPremiumPolicy"],
                    [dataPremium valueForKey:@"TotalPremiumLoading"],
                    [dataPremium valueForKey:@"SubTotalPremium"],
                    [dataPremium valueForKey:@"PurchaseNumber"],
                    [dataPremium valueForKey:@"Discount"],
                    [dataPremium valueForKey:@"SINO"]];
   
    NSLog(@"query %@",[NSString stringWithFormat:@"update SI_Premium set Sum_Assured=\"%@\", Payment_Term=\"%@\", Payment_Frequency=\"%@\",PremiumPolicyA=\"%@\",ExtraPremiumPercentage=\"%@\",ExtraPremiumSum=\"%@\",ExtraPremiumTerm=\"%@\",ExtraPremiumPolicy=\"%@\",TotalPremiumLoading=\"%@\",SubTotalPremium=\"%@\",UpdatedDate=""datetime(\"now\", \"+7 hour\")"",PurchaseNumber=\"%@\",Discount=\"%@\" where SINO=\"%@\"" ,
                       [dataPremium valueForKey:@"Sum_Assured"],
                       [dataPremium valueForKey:@"Payment_Term"],
                       [dataPremium valueForKey:@"Payment_Frequency"],
                       [dataPremium valueForKey:@"PremiumPolicyA"],
                       [dataPremium valueForKey:@"ExtraPremiumPercentage"],
                       [dataPremium valueForKey:@"ExtraPremiumSum"],
                       [dataPremium valueForKey:@"ExtraPremiumTerm"],
                       [dataPremium valueForKey:@"ExtraPremiumPolicy"],
                       [dataPremium valueForKey:@"TotalPremiumLoading"],
                       [dataPremium valueForKey:@"SubTotalPremium"],
                       [dataPremium valueForKey:@"PurchaseNumber"],
                       [dataPremium valueForKey:@"Discount"],
                       [dataPremium valueForKey:@"SINO"]]);
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updatePremiumDate:(NSString *)SINO{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"update SI_Premium set CreatedDate=""datetime(\"now\", \"+7 hour\")"",UpdatedDate=""datetime(\"now\", \"+7 hour\")"" where SINO=?" ,
                    SINO];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}



-(void)deletePremium:(NSString *)siNo{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"delete from SI_Premium where SINO=?" ,siNo];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(NSDictionary *)getPremium_For:(NSString *)SINo{
    NSDictionary *dict;
    
    NSString* SINO;
    NSString* Sum_Assured;
    NSString* Payment_Term;
    NSString* Payment_Frequency;
    NSString* PremiumPolicyA;
    NSString* ExtraPremiumPercentage;
    NSString* ExtraPremiumSum;
    NSString* ExtraPremiumTerm;
    NSString* ExtraPremiumPolicy;
    NSString* TotalPremiumLoading;
    NSString* SubTotalPremium;
    NSString *CreatedDate;
    NSString *UpdatedDate;
    NSString *PurchaseNumber;
    NSString *Discount;

    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select *,cast(ExtraPremiumPolicy as TEXT) as EPPolicy from SI_Premium where SINO = \"%@\"",SINo]];
    NSLog(@"query %@",[NSString stringWithFormat:@"select * from SI_Premium where SINO = \"%@\"",SINo]);
    while ([s next]) {
        SINO = [s stringForColumn:@"SINO"];
        Sum_Assured = [s stringForColumn:@"Sum_Assured"];
        Payment_Term = [s stringForColumn:@"Payment_Term"];
        Payment_Frequency = [s stringForColumn:@"Payment_Frequency"];
        PremiumPolicyA = [s stringForColumn:@"PremiumPolicyA"];
        ExtraPremiumPercentage = [s stringForColumn:@"ExtraPremiumPercentage"];
        ExtraPremiumSum = [s stringForColumn:@"ExtraPremiumSum"];
        ExtraPremiumTerm = [s stringForColumn:@"ExtraPremiumTerm"];
        //ExtraPremiumPolicy = [s stringForColumn:@"ExtraPremiumPolicy"];
        ExtraPremiumPolicy = [s stringForColumn:@"EPPolicy"];
        TotalPremiumLoading = [s stringForColumn:@"TotalPremiumLoading"];
        SubTotalPremium = [s stringForColumn:@"SubTotalPremium"];
        CreatedDate = [s stringForColumn:@"CreatedDate"];
        UpdatedDate = [s stringForColumn:@"UpdatedDate"];
        PurchaseNumber = [s stringForColumn:@"PurchaseNumber"];
        Discount = [s stringForColumn:@"Discount"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          SINO,@"SINO",
          Sum_Assured,@"Sum_Assured",
          Payment_Term,@"Payment_Term",
          Payment_Frequency,@"Payment_Frequency",
          PremiumPolicyA,@"PremiumPolicyA",
          ExtraPremiumPercentage,@"ExtraPremiumPercentage",
          ExtraPremiumSum,@"ExtraPremiumSum",
          ExtraPremiumTerm,@"ExtraPremiumTerm",
          ExtraPremiumPolicy,@"ExtraPremiumPolicy",
          TotalPremiumLoading,@"TotalPremiumLoading",
          SubTotalPremium,@"SubTotalPremium",
          CreatedDate,@"CreatedDate",
          UpdatedDate,@"UpdatedDate",
          PurchaseNumber,@"PurchaseNumber",
          Discount,@"Discount",
          nil];
    
    [results close];
    [database close];
    return dict;
}

-(int)getPremiumCount:(NSString *)SINo{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_Premium where SINO = \"%@\"",SINo]];
    NSLog(@"query %@",[NSString stringWithFormat:@"select count(*) from SI_Premium where SINO = \"%@\"",SINo]);
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}


@end

