//
//  ModelCFFAnswers.h
//  BLESS
//
//  Created by Basvi on 6/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface ModelCFFAnswers : NSObject{
    FMResultSet *results;
}
-(void)deleteCFFAnswerByCFFTransID:(int)cffTransactionID;
-(int)getCFFAnswersCount:(int)intCFFTransactionID CFFSection:(NSString *)stringCFFSection;
-(int)voidGetDuplicateRowID:(NSDictionary *)dictionaryCFFAnswers;
@end
