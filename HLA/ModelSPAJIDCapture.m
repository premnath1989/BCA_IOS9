//
//  SPAJIDCapture.m
//  BLESS
//
//  Created by Basvi on 8/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJIDCapture.h"

@implementation ModelSPAJIDCapture

-(void)saveSPAJIDCapture:(NSDictionary *)spajIDCaptureDictionary{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"insert into SPAJIDCapture (SPAJTransactionID,SPAJIDCaptureParty1,SPAJIDCaptureParty2,SPAJIDCaptureParty3, SPAJIDCaptureParty4,SPAJIDTypeParty1,SPAJIDTypeParty2,SPAJIDTypeParty3,SPAJIDTypeParty4) values ((select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@'),%@,%@,%@,%@,%@,%@,%@,%@)" ,
                                            [spajIDCaptureDictionary valueForKey:@"SPAJEappNumber"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDCaptureParty1"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDCaptureParty2"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDCaptureParty3"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDCaptureParty4"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDTypeParty1"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDTypeParty2"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDTypeParty3"],
                                            [spajIDCaptureDictionary valueForKey:@"SPAJIDTypeParty4"]]];
   
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateSPAJIDCapture:(NSString *)setString{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"update SPAJIDCapture %@" ,
                                            setString]];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(bool)voidIDCaptured:(int)intTransactionSPAJID{
    int signatureCaptured = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as IDCaptured from SPAJIDCapture where SPAJTransactionID=%i and SPAJIDCaptureParty1=1 and SPAJIDCaptureParty2=1 and SPAJIDCaptureParty3=1 and SPAJIDCaptureParty4=1",intTransactionSPAJID]];
    
    while ([s next]) {
        signatureCaptured = [s intForColumn:@"IDCaptured"];
    }
    
    [results close];
    [database close];
    if (signatureCaptured>0){
        return true;
    }
    else{
        return false;
    }
}

-(NSString *)selectIDType:(NSString *)stringColumnName SPAJSection:(int)intSpajTransactionID{
    NSString *stringReturn;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJIDCapture where SPAJTransactionID = %i",stringColumnName,intSpajTransactionID]];
    while ([s next]) {
        stringReturn = [s stringForColumn:stringColumnName];
    }
    
    [results close];
    [database close];
    return stringReturn;
}



@end
