//
//  RateModel.h
//  MPOS
//
//  Created by Basvi on 3/4/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface RateModel : NSObject{
    FMResultSet *results;
}
-(double)getCashSurValue5Year:(NSString *)BasicCode EntryAge:(int)entryAge PolYear:(int)polYear Gender:(NSString *)gender;
-(double)getCashSurValue1Year:(NSString *)Gender BasicCode:(NSString *)basicCode EntryAge:(int)entryAge;
-(double)getCashSurValue:(NSString *)Gender BasicCode:(NSString *)basicCode EntryAge:(int)entryAge PolYear:(int)polYear;
-(CGFloat)getWaiverRate:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType;
-(NSString *)getWaiverRateAsString:(NSString *)Gender EntryAge:(int)entryAge PersonType:(NSString *)personType;
-(double)getKeluargakuBasicPremRate:(NSString *)Gender EntryAge:(int)entryAge BasicCode:(NSString *)basicCode;
-(double)getKeluargakuEMRate:(NSString *)Gender EntryAge:(int)entryAge;
-(NSString *)getKeluargakuMOPRate:(int)PaymentCode;
-(double)getKeluargakuAnuityRate:(int)PaymentCode;
-(int)getKeluargakuMOPFreq:(int)PaymentType;
@end
