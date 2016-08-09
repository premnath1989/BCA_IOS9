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

@end
