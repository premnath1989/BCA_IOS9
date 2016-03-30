//
//  ModelIdentificationType.m
//  MPOS
//
//  Created by Basvi on 2/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelIdentificationType.h"

@implementation ModelIdentificationType

-(NSDictionary *)getIDType{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayIdentityCode=[[NSMutableArray alloc] init];
    NSMutableArray* arrayIdentityDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM eProposal_Identification WHERE status = 'A'"];
    while ([s next]) {
        NSString *IdentityCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IdentityCode"]];
        NSString *IdentityDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IdentityDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arrayIdentityCode addObject:IdentityCode];
        [arrayIdentityDesc addObject:IdentityDesc];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayIdentityCode,@"IdentityCode", arrayIdentityDesc,@"IdentityDesc",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}

@end
