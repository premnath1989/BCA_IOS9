//
//  ModelKodepos.m
//  MPOS
//
//  Created by Basvi on 3/16/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelKodepos.h"

@implementation ModelKodepos

-(NSMutableArray *)getPropinsi{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayPropinsiName=[[NSMutableArray alloc] init];

    FMResultSet *s = [database executeQuery:@"select propinsi from kodepos group by propinsi"];
    while ([s next]) {
        NSString *stringPropinsi = [NSString stringWithFormat:@"%@",[s stringForColumn:@"propinsi"]];
        
        [arrayPropinsiName addObject:stringPropinsi];
    }
    [results close];
    [database close];
    return arrayPropinsiName;
}

-(NSMutableArray *)getKabupatengbyPropinsi:(NSString *)propinsi{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSMutableArray* arrayKabupatenName=[[NSMutableArray alloc] init];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select kabupaten from kodepos where propinsi=\"%@\" group by kabupaten",propinsi]];
    while ([s next]) {
        NSString *stringKabupaten = [NSString stringWithFormat:@"%@",[s stringForColumn:@"kabupaten"]];
        
        [arrayKabupatenName addObject:stringKabupaten];
    }
    [results close];
    [database close];
    return arrayKabupatenName;
}

@end
