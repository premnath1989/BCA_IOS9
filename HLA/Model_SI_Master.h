//
//  Model_SI_Master.h
//  MPOS
//
//  Created by Basvi on 2/26/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface Model_SI_Master : NSObject{
    FMResultSet *results;
    sqlite3 *contactDB;
}
-(void)saveIlustrationMaster:(NSDictionary *)dataIlustration;
-(NSDictionary *)getIlustrationata:(NSString *)orderBy Method:(NSString *)sortMethod;
-(void)updateIlustrationMaster:(NSDictionary *)dataIlustration;
-(int)getMasterCount:(NSString *)SINo;

-(NSDictionary *)searchSIListingByName:(NSString *)SINO POName:(NSString *)poName Order:(NSString *)orderBy Method:(NSString *)method DateFrom:(NSString *)dateFrom DateTo:(NSString *)dateTo;
-(NSDictionary *)getNonQuickQuoteIlustrationata:(NSString *)orderBy Method:(NSString *)sortMethod;

-(void)deleteIlustrationMaster:(NSString *)siNo;
-(void)signIlustrationMaster:(NSString *)SINO;
-(BOOL)isSignedIlustration:(NSString *)SINo;
-(void)updateIlustrationMasterDate:(NSString *)SINO;
-(NSDictionary *)getIlustrationDataForSI:(NSString *)SINO;
@end
