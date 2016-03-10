//
//  ModelDataReferral.h
//  BLESS
//
//  Created by Basvi on 3/9/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelDataReferral : NSObject{
    FMResultSet *results;
}
-(NSString *)getReferralName:(NSString *)referralNIP;
@end
