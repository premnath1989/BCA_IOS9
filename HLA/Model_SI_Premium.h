//
//  Model_SI_Premium.h
//  BLESS
//
//  Created by Basvi on 2/27/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface Model_SI_Premium : NSObject{
    FMResultSet *results;
}
-(void)savePremium:(NSDictionary *)dataPremium;
@end
