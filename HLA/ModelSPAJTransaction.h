//
//  ModelSPAJTransaction.h
//  BLESS
//
//  Created by Basvi on 7/28/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSPAJTransaction : NSObject{
    FMResultSet *results;
}

-(void)saveSPAJTransaction:(NSDictionary *)spajTransactionDictionary;
-(void)updateSPAJTransaction:(NSString *)stringColumnName StringColumnValue:(NSString *)stringColumnValue StringWhereName:(NSString *)stringWhereName StringWhereValue:(NSString *)stringWhereValue;
-(NSString *)getSPAJTransactionData:(NSString *)stringColumnName StringWhereName:(NSString *)stringWhereName StringWhereValue:(NSString *)stringWhereValue;
@end
