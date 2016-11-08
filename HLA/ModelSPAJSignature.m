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

-(bool)voidSignatureCaptured:(int)intTransactionSPAJID Relationship:(NSString*)stringRelation LAAge:(int)laAge{
    int signatureCaptured = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s;
    if ([stringRelation isEqualToString:@"DIRI SENDIRI"]){
        s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as SignatureCaptured from SPAJSignature where SPAJTransactionID=%i and SPAJSignatureParty1=1 and SPAJSignatureParty4=1",intTransactionSPAJID]];
    }
    else{
        if (laAge<21){
            s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as SignatureCaptured from SPAJSignature where SPAJTransactionID=%i and SPAJSignatureParty1=1 and SPAJSignatureParty3=1 and SPAJSignatureParty4=1",intTransactionSPAJID]];
        }
        else{
            s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as SignatureCaptured from SPAJSignature where SPAJTransactionID=%i and SPAJSignatureParty1=1 and SPAJSignatureParty2=1 and SPAJSignatureParty4=1",intTransactionSPAJID]];
        }
    }
    
    while ([s next]) {
        signatureCaptured = [s intForColumn:@"SignatureCaptured"];
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

-(bool)voidCertainSignaturePartyCaptured:(int)intTransactionSPAJID SignatureParty:(NSString *)stringSignatureParty{
    int signatureCaptured = 0;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJSignature where SPAJTransactionID=%i",stringSignatureParty,intTransactionSPAJID]];
    
    while ([s next]) {
        signatureCaptured = [s intForColumn:stringSignatureParty];
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


-(NSMutableDictionary *)voidSignaturePartyCaptured:(int)intTransactionSPAJID SignatureParty:(NSString *)stringSignatureParty{
    NSMutableDictionary* dictSignatureCaptured = [[NSMutableDictionary alloc] init];
    int signatureCaptured = 0;
    NSString* stringDateParty1;

    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count (*) as SignatureCaptured,SPAJDateSignatureParty1 from SPAJSignature where SPAJTransactionID=%i and %@=1",intTransactionSPAJID,stringSignatureParty]];
    
    while ([s next]) {
        signatureCaptured = [s intForColumn:@"SignatureCaptured"];
        stringDateParty1 = [s stringForColumn:@"SPAJDateSignatureParty1"];
    }
    
    [results close];
    [database close];
    if (signatureCaptured>0){
//        return true;
        [dictSignatureCaptured setObject:@true forKey:@"SignatureCaptured"];
        [dictSignatureCaptured setObject:stringDateParty1?:@"" forKey:@"SPAJDateSignatureParty1"];
    }
    else{
//        return false;
        [dictSignatureCaptured setObject:@false forKey:@"SignatureCaptured"];
        [dictSignatureCaptured setObject:stringDateParty1?:@"" forKey:@"SPAJDateSignatureParty1"];
    }
    return dictSignatureCaptured;
}

-(NSString *)selectSPAJSignatureData:(NSString *)stringColumnName SPAJTransactionID:(int)intSpajTransactionID{
    NSString *stringReturn;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select %@ from SPAJSignature where SPAJTransactionID = %i",stringColumnName,intSpajTransactionID]];
    while ([s next]) {
        stringReturn = [s stringForColumn:stringColumnName];
    }
    
    [results close];
    [database close];
    return stringReturn;
}



@end
