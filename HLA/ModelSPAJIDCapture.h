//
//  SPAJIDCapture.h
//  BLESS
//
//  Created by Basvi on 8/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSPAJIDCapture : NSObject{
    FMResultSet *results;
}
-(NSString *)selectIDType:(NSString *)stringColumnName SPAJSection:(int)intSpajTransactionID;
-(void)saveSPAJIDCapture:(NSDictionary *)spajIDCaptureDictionary;
-(void)updateSPAJIDCapture:(NSString *)setString;
-(bool)voidIDCaptured:(int)intTransactionSPAJID Relationship:(NSString*)stringRelation LAAge:(int)laAge;
-(bool)voidCertainIDPartyCaptured:(int)intTransactionSPAJID IDParty:(NSString *)stringIDParty;
@end
