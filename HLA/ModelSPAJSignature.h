//
//  ModelSPAJSignature.h
//  BLESS
//
//  Created by Basvi on 7/29/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSPAJSignature : NSObject{
    FMResultSet *results;
}
-(void)saveSPAJSignature:(NSDictionary *)spajSignatureDictionary;
-(void)updateSPAJSignature:(NSString *)setString;
-(bool)voidSignatureCaptured:(int)intTransactionSPAJID Relationship:(NSString*)stringRelation LAAge:(int)laAge;
-(NSMutableDictionary *)voidSignaturePartyCaptured:(int)intTransactionSPAJID SignatureParty:(NSString *)stringSignatureParty;
-(bool)voidCertainSignaturePartyCaptured:(int)intTransactionSPAJID SignatureParty:(NSString *)stringSignatureParty;
-(NSString *)selectSPAJSignatureData:(NSString *)stringColumnName SPAJTransactionID:(int)intSpajTransactionID;
@end
