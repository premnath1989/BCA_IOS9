//
//  ModelDataReferral.m
//  BLESS
//
//  Created by Basvi on 3/9/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "ModelDataReferral.h"

@implementation ModelDataReferral


-(NSString *)getReferralName:(NSString *)referralNIP{
    NSString *referralName;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select Name from DataReferral where NIP = %@",referralNIP]];
    
    referralName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Name"]];
    while ([s next]) {
        referralName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Name"]];
    }
    [results close];
    [database close];
    return referralName;
}

@end
