//
//  ModelSIRider.h
//  BLESS
//
//  Created by Basvi on 3/23/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSIRider : NSObject{
    FMResultSet *results;
}
-(void)saveRider:(NSDictionary *)dataRider;
-(int)getRiderCount:(NSString *)SINo RiderCode:(NSString *)riderCode;
-(void)updateRider:(NSDictionary *)dataRider;
-(NSDictionary *)getRider:(NSString *)SINo RiderCode:(NSString *)riderCode;
@end
