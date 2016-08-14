//
//  ModelSPAJFormGeneration.h
//  BLESS
//
//  Created by Basvi on 8/10/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface ModelSPAJFormGeneration : NSObject{
    FMResultSet *results;
}
-(void)saveSPAJFormGeneration:(NSDictionary *)spajFormGenerationDictionary;
-(void)updateSPAJFormGeneration:(NSString *)setString;
-(bool)voidFormGenerated:(int)intTransactionSPAJID;
-(bool)voidCertainFormGenerateCaptured:(int)intTransactionSPAJID FormType:(NSString *)stringFormType;
@end
