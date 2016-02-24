//
//  ModelAgentProfile.m
//  BLESS
//
//  Created by Basvi on 2/19/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "ModelAgentProfile.h"

@implementation ModelAgentProfile

-(NSDictionary *)getAgentData{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *NamaChannel ;
    NSString *Kanwil ;
    NSString *CodeChannel ;
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM Agent_profile"];
    while ([s next]) {
        NamaChannel = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ChannelName"]];
        CodeChannel = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ChannelCode"]];
        Kanwil = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Kanwil"]];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:NamaChannel,@"ChannelName", CodeChannel,@"ChannelCode",Kanwil,@"Kanwil",nil];
    
    [results close];
    [database close];
    return dict;
}


@end
