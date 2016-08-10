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
-(bool)voidSignatureCaptured:(int)intTransactionSPAJID;
@end
