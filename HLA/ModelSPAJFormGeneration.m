//
//  ModelSPAJFormGeneration.m
//  BLESS
//
//  Created by Basvi on 8/10/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJFormGeneration.h"

@implementation ModelSPAJFormGeneration
-(void)saveSPAJFormGeneration:(NSDictionary *)spajFormGenerationDictionary{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"insert into SPAJFormGeneration (SPAJTransactionID,SPAJFormGeneration1,SPAJFormGeneration2,SPAJFormGeneration3) values ((select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@'),%@,%@,%@)" ,
                                            [spajFormGenerationDictionary valueForKey:@"SPAJEappNumber"],
                                            [spajFormGenerationDictionary valueForKey:@"SPAJFormGeneration1"],
                                            [spajFormGenerationDictionary valueForKey:@"SPAJFormGeneration2"],
                                            [spajFormGenerationDictionary valueForKey:@"SPAJFormGeneration3"]]];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateSPAJFormGeneration:(NSString *)setString{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"update SPAJFormGeneration %@" ,
                                            setString]];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(bool)voidFormGenerated:(int)intTransactionSPAJID{
    int signatureCaptured = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    //FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as FormGenerationCaptured from SPAJFormGeneration where SPAJTransactionID=%i and SPAJFormGeneration1=1 and SPAJFormGeneration2=1 and SPAJFormGeneration3=1 ",intTransactionSPAJID]];
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as FormGenerationCaptured from SPAJFormGeneration where SPAJTransactionID=%i and SPAJFormGeneration1=1 ",intTransactionSPAJID]];
    
    while ([s next]) {
        signatureCaptured = [s intForColumn:@"FormGenerationCaptured"];
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

-(bool)voidCertainFormGenerateCaptured:(int)intTransactionSPAJID FormType:(NSString *)stringFormType{
    int FormGenerated = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJFormGeneration where SPAJTransactionID=%i",stringFormType,intTransactionSPAJID]];
    
    while ([s next]) {
        FormGenerated = [s intForColumn:stringFormType];
    }
    
    [results close];
    [database close];
    if (FormGenerated>0){
        return true;
        
    }
    else{
        return false;
    }
}


@end
