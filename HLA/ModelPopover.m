//
//  ModelPopover.m
//  BLESS
//
//  Created by Basvi on 2/4/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "ModelPopover.h"

@implementation ModelPopover
-(NSDictionary *)getSourceIncome{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arraySourceCode=[[NSMutableArray alloc] init];
    NSMutableArray* arraySourceDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM eProposal_SourceIncome WHERE status = 'A'"];
    while ([s next]) {
        NSString *SourceCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SourceCode"]];
        NSString *SourceDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"SourceDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arraySourceCode addObject:SourceCode];
        [arraySourceDesc addObject:SourceDesc];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arraySourceCode,@"SourceCode", arraySourceDesc,@"SourceDesc",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSDictionary *)getVIPClass{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayVIPCode=[[NSMutableArray alloc] init];
    NSMutableArray* arrayVIPDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM eProposal_VIPClass WHERE status = 'A'"];
    while ([s next]) {
        NSString *vipCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"VIPCode"]];
        NSString *vipDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"VIPDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arrayVIPCode addObject:vipCode];
        [arrayVIPDesc addObject:vipDesc];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayVIPCode,@"VIPCode", arrayVIPDesc,@"VIPDesc",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSDictionary *)getReferralSource{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayReferCode=[[NSMutableArray alloc] init];
    NSMutableArray* arrayReferDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM eProposal_ReferralSource WHERE status = 'A'"];
    while ([s next]) {
        NSString *referCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ReferCode"]];
        NSString *referDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ReferDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arrayReferCode addObject:referCode];
        [arrayReferDesc addObject:referDesc];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayReferCode,@"ReferCode", arrayReferDesc,@"ReferDesc",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}


@end
