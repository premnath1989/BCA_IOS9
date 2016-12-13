//
//  ModelSIULBasicPlan.h
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Model_SI_Master.h"

@interface ModelSIULBasicPlan : NSObject{
    FMResultSet *results;
    Model_SI_Master *modelSIMaster;
}

-(void)saveULBasicPlanData:(NSMutableDictionary *)dictULBasicPlanData;
-(NSDictionary *)getULBasicPlanDataFor:(NSString *)SINo;
-(int)getULBasicPlanDataCount:(NSString *)SINo;
@end
