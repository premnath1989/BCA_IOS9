//
//  ModelOccupation.h
//  BLESS
//
//  Created by Basvi on 8/19/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelOccupation : NSObject{
    FMResultSet *results;
}
-(NSString *)getOccupationDesc:(NSString *)occupationCode;
@end
