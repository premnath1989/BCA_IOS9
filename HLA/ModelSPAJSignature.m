//
//  ModelSPAJSignature.m
//  BLESS
//
//  Created by Basvi on 7/29/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSPAJSignature.h"

@implementation ModelSPAJSignature

-(void)saveSPAJSignature:(NSDictionary *)spajSignatureDictionary{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"insert into SPAJSignature (SPAJTransactionID,SPAJSignatureParty1,SPAJSignatureParty2,SPAJSignatureParty3, SPAJSignatureParty4) values ((select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@'),%@,%@,%@,%@)" ,
                                            [spajSignatureDictionary valueForKey:@"SPAJEappNumber"],
                                            [spajSignatureDictionary valueForKey:@"SPAJSignatureParty1"],
                                            [spajSignatureDictionary valueForKey:@"SPAJSignatureParty2"],
                                            [spajSignatureDictionary valueForKey:@"SPAJSignatureParty3"],
                                            [spajSignatureDictionary valueForKey:@"SPAJSignatureParty4"]]];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateSPAJSignature:(NSString *)setString{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    
    BOOL success = [database executeUpdate:[NSString stringWithFormat:@"update SPAJSignature %@" ,
                                            setString]];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


@end
