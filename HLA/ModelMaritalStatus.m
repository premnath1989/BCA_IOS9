//
//  ModelMaritalStatus.m
//  MPOS
//
//  Created by Basvi on 2/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelMaritalStatus.h"

@implementation ModelMaritalStatus

-(NSDictionary *)getMaritalStatus{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayMSCode=[[NSMutableArray alloc] init];
    NSMutableArray* arrayMSDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM eProposal_Marital_Status WHERE status = 'A'"];
    while ([s next]) {
        NSString *MSCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"MSCode"]];
        NSString *MSDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"MSDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arrayMSCode addObject:MSCode];
        [arrayMSDesc addObject:MSDesc];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayMSCode,@"MSCode", arrayMSDesc,@"MSDesc",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}

@end
