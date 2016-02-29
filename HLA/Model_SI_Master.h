//
//  Model_SI_Master.h
//  BLESS
//
//  Created by Basvi on 2/26/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface Model_SI_Master : NSObject{
    FMResultSet *results;
}
-(void)saveIlustrationMaster:(NSDictionary *)dataIlustration;
-(NSDictionary *)getIlustrationata;
-(void)updateIlustrationMaster:(NSDictionary *)dataIlustration;
-(int)getMasterCount:(NSString *)SINo;
@end
