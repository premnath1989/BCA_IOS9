//
//  ModelSPAJSubmitTracker.h
//  BLESS
//
//  Created by Basvi on 8/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSPAJSubmitTracker : NSObject{
    FMResultSet *results;
}

-(void)saveSPAJSubmitDate:(NSString *)stringSPAJNumber SubmitDate:(NSString *)stringDate;
-(bool)voidMaximumSubmitReached:(NSString *)stringSubmitDate;
@end
