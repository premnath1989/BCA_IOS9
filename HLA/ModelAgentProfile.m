//
//  ModelAgentProfile.m
//  MPOS
//
//  Created by Basvi on 2/19/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
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
    NSString *AgentName ;
    NSString *AgentCode ;
    NSString *AgentBranch ;
    NSString *AgentExpiryDate ;
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM Agent_profile"];
    while ([s next]) {
        NamaChannel = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ChannelName"]];
        CodeChannel = [NSString stringWithFormat:@"%@",[s stringForColumn:@"ChannelCode"]];
        Kanwil = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Kanwil"]];
        AgentName = [NSString stringWithFormat:@"%@",[s stringForColumn:@"AgentName"]];
        AgentCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"AgentCode"]];
        AgentBranch = [NSString stringWithFormat:@"%@",[s stringForColumn:@"BranchName"]];
        AgentExpiryDate = [NSString stringWithFormat:@"%@",[s stringForColumn:@"LicenseExpiryDate"]];
    }

    dict = [[NSDictionary alloc] initWithObjectsAndKeys:NamaChannel,@"ChannelName", CodeChannel,@"ChannelCode",Kanwil,@"Kanwil",AgentName,@"AgentName", AgentCode,@"AgentCode",AgentBranch,@"BranchName",AgentExpiryDate,@"AgentExpiryDate",nil];
    
    [results close];
    [database close];
    return dict;
}


@end
