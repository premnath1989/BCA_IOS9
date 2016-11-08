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
    NSMutableArray* arrayDataIdentifier=[[NSMutableArray alloc] init];
    NSMutableArray* arrayIdentityDesc=[[NSMutableArray alloc] init];
    NSMutableArray* arrayStatus=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM eProposal_Identification WHERE status = 'A'"];
    while ([s next]) {
        NSString *IdentityCode = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IdentityCode"]];
        NSString *DataIdentifier = [NSString stringWithFormat:@"%@",[s stringForColumn:@"DataIdentifier"]];
        NSString *IdentityDesc = [NSString stringWithFormat:@"%@",[s stringForColumn:@"IdentityDesc"]];
        NSString *Status = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Status"]];
        
        [arrayIdentityCode addObject:IdentityCode];
        [arrayIdentityDesc addObject:IdentityDesc];
        [arrayDataIdentifier addObject:DataIdentifier];
        [arrayStatus addObject:Status];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayIdentityCode,@"IdentityCode", arrayIdentityDesc,@"IdentityDesc",arrayDataIdentifier,@"DataIdentifier",arrayStatus,@"Status",nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSString*) getOtherTypeDesc : (NSString*)otherId
{
    NSString *desc;
    otherId = [otherId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *result = [database executeQuery:@"SELECT IdentityDesc FROM eProposal_Identification WHERE IdentityCode = ? or DataIdentifier = ?", otherId,otherId];
    
    NSInteger *count = 0;
    while ([result next]) {
        count = count + 1;
        //desc =[result objectForColumnName:@"IdentityDesc"];
        desc =[result stringForColumn:@"IdentityDesc"];
    }
    [result close];
    
    if (count == 0) {
        if (otherId.length > 0) {
            if ([otherId isEqualToString:@"- SELECT -"] || [otherId isEqualToString:@"- Select -"]) {
                desc = @"";
            } else {
                desc = otherId;
            }
        }
    }
    return desc;
}

-(NSString*) getOtherTypeID : (NSString*)otherDesc
{
    NSString *desc;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet *result = [database executeQuery:@"SELECT DataIdentifier FROM eProposal_Identification WHERE Status='A' and IdentityDesc = ? ", otherDesc];
    
    NSInteger *count = 0;
    while ([result next]) {
        count = count + 1;
        //desc =[result objectForColumnName:@"IdentityDesc"];
        desc =[result stringForColumn:@"DataIdentifier"];
    }
    [result close];
    
    return desc;
}


@end
