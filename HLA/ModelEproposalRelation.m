//
//  ModelEproposalRelation.m
//  BLESS
//
//  Created by Basvi on 11/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelEproposalRelation.h"

@implementation ModelEproposalRelation

-(NSString *)GetRelationCode:(NSString *)stringRelationDesc{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    NSString *RelationCode;
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *s;
    
    s = [database executeQuery:[NSString stringWithFormat:@"select RelCode from eProposal_Relation where RelDesc = '%@'",stringRelationDesc]];
    
    while ([s next]) {
        RelationCode = [s stringForColumn:@"RelCode"];
    }
    
    [results close];
    [database close];
    return RelationCode;
}

@end
