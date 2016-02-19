//
//  ModelAgentProfile.h
//  BLESS
//
//  Created by Basvi on 2/19/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelAgentProfile : NSObject{
    FMResultSet *results;
}

-(NSDictionary *)getAgentData;

@end
