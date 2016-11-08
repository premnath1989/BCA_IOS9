//
//  ModelSPAJSubmitTracker.m
//  BLESS
//
//  Created by Basvi on 8/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJSubmitTracker.h"

@implementation ModelSPAJSubmitTracker

-(void)saveSPAJSubmitDate:(NSString *)stringSPAJNumber SubmitDate:(NSString *)stringDate{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into SPAJSubmitTracker (SPAJNumber,SPAJSubmissionDate) values (?,?)" ,stringSPAJNumber,stringDate];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(bool)voidMaximumSubmitReached:(NSString *)stringSubmitDate{
    int countSubmit = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:@"SELECT count(*) as CountSubmit FROM SPAJSubmitTracker where substr(SPAJSubmissionDate,0,11)  = ?",stringSubmitDate];
    
    while ([s next]) {
        countSubmit = [s intForColumn:@"CountSubmit"];
    }
    
    [results close];
    [database close];
    if (countSubmit>1){
        return true;
    }
    else{
        return false;
    }
}



@end
