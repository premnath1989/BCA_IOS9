//
//  ModelSPAJAnswers.h
//  BLESS
//
//  Created by Basvi on 8/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSPAJAnswers : NSObject{
    FMResultSet *results;
}
-(int)voidGetDuplicateRowID:(NSDictionary *)dictionaryCFFAnswers;
-(NSString *)selectSPAJAnswersData:(NSString *)stringColumnName StringWhere:(NSString *)stringWhere;
-(void)deleteSPAJAnswers:(NSString *)stringWhereValue;
-(int)selectSPAJIDActiveHtml;
-(int)getCountElementID:(NSString *)stringElementName SPAJTransactionID:(int)spajTransactionID Section:(NSString *)stringSection;
-(NSMutableArray *)getSPAJAnswerValue:(NSString *)stringElementName SPAJTransactionID:(int)spajTransactionID Section:(NSString *)stringSection;
-(NSMutableArray *)getSPAJAnswerElementValue:(NSString *)stringElementName SPAJTransactionID:(int)spajTransactionID Section:(NSString *)stringSection;
@end
