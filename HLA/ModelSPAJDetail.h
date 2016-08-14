//
//  ModelSPAJDetail.h
//  BLESS
//
//  Created by Basvi on 8/10/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface ModelSPAJDetail : NSObject{
    FMResultSet *results;
}
-(void)saveSPAJDetail:(NSDictionary *)spajDetailDictionary;
-(void)updateSPAJDetail:(NSString *)setString;
-(bool)voidDetailCaptured:(int)intTransactionSPAJID;
-(bool)voidCertainDetailCaptured:(int)intTransactionSPAJID DetailParty:(NSString *)stringDetailSPAJ;
@end
