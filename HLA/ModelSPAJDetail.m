//
//  ModelSPAJDetail.m
//  BLESS
//
//  Created by Basvi on 8/10/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJDetail.h"

@implementation ModelSPAJDetail
-(void)saveSPAJDetail:(NSDictionary *)spajDetailDictionary{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"insert into SPAJDetail (SPAJTransactionID,SPAJDetail1,SPAJDetail2,SPAJDetail3,SPAJDetail4,SPAJDetail5,SPAJDetail6) values ((select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@'),%@,%@,%@,%@,%@,%@)" ,
                                            [spajDetailDictionary valueForKey:@"SPAJEappNumber"],
                                            [spajDetailDictionary valueForKey:@"SPAJDetail1"],
                                            [spajDetailDictionary valueForKey:@"SPAJDetail2"],
                                            [spajDetailDictionary valueForKey:@"SPAJDetail3"],
                                            [spajDetailDictionary valueForKey:@"SPAJDetail4"],
                                            [spajDetailDictionary valueForKey:@"SPAJDetail5"],
                                            [spajDetailDictionary valueForKey:@"SPAJDetail6"]]];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateSPAJDetail:(NSString *)setString{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"update SPAJDetail %@" ,
                                            setString]];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(bool)voidDetailCaptured:(int)intTransactionSPAJID{
    int signatureCaptured = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as DetailCaptured from SPAJDetail where SPAJTransactionID=%i and SPAJDetail1=1 and SPAJDetail2=1 and SPAJDetail3=1 and SPAJDetail4=1 and SPAJDetail5=1 and SPAJDetail6=1",intTransactionSPAJID]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as DetailCaptured from SPAJDetail where SPAJTransactionID=%i and SPAJDetail1=1 and SPAJDetail2=1 and SPAJDetail4=1 and SPAJDetail5=1 and SPAJDetail6=1",intTransactionSPAJID]];
    
    while ([s next]) {
        signatureCaptured = [s intForColumn:@"DetailCaptured"];
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

-(bool)voidCertainDetailCaptured:(int)intTransactionSPAJID DetailParty:(NSString *)stringDetailSPAJ{
    int DetailCaptured = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJDetail where SPAJTransactionID=%i",stringDetailSPAJ,intTransactionSPAJID]];
    
    DetailCaptured = [s intForColumn:stringDetailSPAJ];
    while ([s next]) {
        DetailCaptured = [s intForColumn:stringDetailSPAJ];
    }
    
    [results close];
    [database close];
    if (DetailCaptured>0){
        return true;
        
    }
    else{
        return false;
    }
}

@end
