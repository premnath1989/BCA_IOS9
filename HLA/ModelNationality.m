//
//  ModelNationality.m
//  MPOS
//
//  Created by Basvi on 2/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelNationality.h"

@implementation ModelNationality

-(NSDictionary *)getNationality{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];

    NSMutableArray* arrayNationCode=[[NSMutableArray alloc] init];
    NSMutableArray* arrayNationDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM eProposal_Nationality WHERE status = 'A'"];
    while ([s next]) {
        NSString *NationCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"NationCode"]];
        NSString *NationDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"NationDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arrayNationCode addObject:NationCode];
        [arrayNationDesc addObject:NationDesc];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayNationCode,@"NationCode", arrayNationDesc,@"NationDesc",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}


@end
