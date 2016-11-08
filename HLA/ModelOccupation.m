//
//  ModelOccupation.m
//  BLESS
//
//  Created by Basvi on 8/19/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelOccupation.h"


@implementation ModelOccupation


-(NSString *)getOccupationDesc:(NSString *)occupationCode{
    NSString *stringOccupationDesc;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:@"SELECT OccpDesc from eProposal_OCCP WHERE occp_Code = ?", occupationCode, Nil];
    while ([s next]) {
        stringOccupationDesc = [s stringForColumn:@"OccpDesc"];
    }
    
    [results close];
    [database close];
    return stringOccupationDesc;
}


@end
