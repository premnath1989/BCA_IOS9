//
//  ModelPopover.h
//  BLESS
//
//  Created by Basvi on 2/4/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelPopover : NSObject {
    FMResultSet *results;
}
-(NSDictionary *)getSourceIncome;
-(NSDictionary *)getVIPClass;
-(NSDictionary *)getReferralSource;
-(NSDictionary *)getOccupation;
-(NSDictionary *)getTitle;
-(NSDictionary *)getBranchInfo:(NSString *)columnOrder;
-(NSDictionary *)getBranchInfoFilter:(NSString *)columnFilter ColumnValue:(NSString *)columnValue;
@end
