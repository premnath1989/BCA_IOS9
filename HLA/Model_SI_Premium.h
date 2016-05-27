//
//  Model_SI_Premium.h
//  MPOS
//
//  Created by Basvi on 2/27/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface Model_SI_Premium : NSObject{
    FMResultSet *results;
}
-(void)savePremium:(NSDictionary *)dataPremium;
-(void)deletePremium:(NSString *)siNo;
-(NSDictionary *)getPremium_For:(NSString *)SINo;
-(void)updatePremium:(NSDictionary *)dataPremium;
-(int)getPremiumCount:(NSString *)SINo;
-(void)updatePremiumDate:(NSString *)SINO;
@end
