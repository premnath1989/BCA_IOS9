//
//  ModelReligion.h
//  BLESS
//
//  Created by Basvi on 2/3/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelReligion : NSObject {
    FMResultSet *results;
}
-(NSDictionary *)getReligion;


@end
