//
//  ModelSIULFundAllocation.h
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSIULFundAllocation : NSObject{
    FMResultSet *results;
}

-(void)saveULFundAllocationData:(NSMutableDictionary *)dictULFundAllocationData;
-(NSDictionary *)getULFundAllocationDataFor:(NSString *)SINo;

@end
