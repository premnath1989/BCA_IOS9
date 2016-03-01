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
    sqlite3 *contactDB;
}
-(void)saveIlustrationMaster:(NSDictionary *)dataIlustration;
-(NSDictionary *)getIlustrationata;
-(void)updateIlustrationMaster:(NSDictionary *)dataIlustration;
-(int)getMasterCount:(NSString *)SINo;
-(NSDictionary *)searchSIListingByName:(NSString *)SINO POName:(NSString *)poName Order:(NSString *)orderBy Method:(NSString *)method DateFrom:(NSString *)dateFrom DateTo:(NSString *)dateTo;
@end
