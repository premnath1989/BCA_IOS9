//
//  ModelIdentificationType.h
//  MPOS
//
//  Created by Basvi on 2/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelIdentificationType : NSObject {
    FMResultSet *results;
}
-(NSDictionary *)getIDType;
-(NSString*)getOtherTypeDesc : (NSString*)otherId;
-(NSString*)getOtherTypeID : (NSString*)otherDesc;
@end
