//
//  SingleUnitLinkedCalculation.h
//  BLESS
//
//  Created by Basvi on 11/25/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSIULSpecialOption.h"
#import "Formatter.h"
@interface SingleUnitLinkedCalculation : NSObject{
    ModelSIULSpecialOption* modelSIULSpecialOption;
    Formatter* formatter;
}
-(double)calculateSumAssured:(double)basicPremi;
-(double)calculateTotalPremiTopUp:(NSString *)stringSINO;
-(double)calculateTotalPremi:(double)totalPremiSekaligus TotalPremiTopUp:(double)totalPremiTopUp;
@end
