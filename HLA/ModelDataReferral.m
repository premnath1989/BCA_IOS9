//
//  ModelDataReferral.m
//  MPOS
//
//  Created by Basvi on 3/9/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelDataReferral.h"

@implementation ModelDataReferral

-(NSDictionary *)getNIPInfo{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"DataReferral.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayNIP=[[NSMutableArray alloc] init];
    NSMutableArray* arrayNamaReferral=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select NIP,Name from DataReferral WHERE Status = 'A' order by NIP ASC"]];
    
    while ([s next]) {
        NSString *nip = [NSString stringWithFormat:@"%@",[s stringForColumn:@"NIP"]];
        NSString *name = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Name"]];
        
        [arrayNIP addObject:nip];
        [arrayNamaReferral addObject:name];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayNIP,@"NIP", arrayNamaReferral,@"Nama",nil];
    
    [results close];
    [database close];
    return dict;
}

-(NSDictionary *)getNIPInfoByNIP:(NSString *)nipNumber{
    NSDictionary *dict;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"DataReferral.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayNIP=[[NSMutableArray alloc] init];
    NSMutableArray* arrayNamaReferral=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select NIP,Name from DataReferral where NIP = \"%@\" order by NIP ASC",nipNumber]];
    
    while ([s next]) {
        NSString *nip = [NSString stringWithFormat:@"%@",[s stringForColumn:@"NIP"]];
        NSString *name = [NSString stringWithFormat:@"%@",[s stringForColumn:@"Name"]];
        
        [arrayNIP addObject:nip];
        [arrayNamaReferral addObject:name];
    }
    dict = [[NSDictionary alloc] initWithObjectsAndKeys:arrayNIP,@"NIP", arrayNamaReferral,@"Nama",nil];
    
    [results close];
    [database close];
    return dict;
}


-(NSString *)getReferralName:(NSString *)referralNIP{
    NSString *referralName;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"DataReferral.sqlite"];
    
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
