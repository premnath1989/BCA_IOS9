//
//  RateModel.h
//  BLESS
//
//  Created by Basvi on 3/4/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface RateModel : NSObject{
    FMResultSet *results;
}
-(long)getCashSurValue5Year:(NSString *)BasicCode EntryAge:(int)entryAge PolYear:(int)polYear Gender:(NSString *)gender;
-(long)getCashSurValue1Year:(NSString *)Gender BasicCode:(NSString *)basicCode EntryAge:(int)entryAge;
@end
