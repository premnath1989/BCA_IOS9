//
//  Model_SI_Premium.m
//  BLESS
//
//  Created by Basvi on 2/27/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "Model_SI_Premium.h"


@implementation Model_SI_Premium
-(void)savePremium:(NSDictionary *)dataPremium{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"insert into SI_Premium (SINO, Sum_Assured, Payment_Term, Payment_Frequency,PremiumPolicyA,ExtraPremiumPercentage,ExtraPremiumSum,ExtraPremiumTerm,ExtraPremiumPolicy,TotalPremiumLoading,SubTotalPremium,CreatedDate,UpdatedDate) values (?,?,?,?,?,?,?,?,?,?,?,""datetime(\"now\", \"+8 hour\")"",""datetime(\"now\", \"+8 hour\")"")" ,
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
                    [dataPremium valueForKey:@"SubTotalPremium"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

@end

