//
//  SingleUnitLinkedCalculation.m
//  BLESS
//
//  Created by Basvi on 11/25/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SingleUnitLinkedCalculation.h"

@implementation SingleUnitLinkedCalculation

-(double)calculateSumAssured:(double)basicPremi{
    float percentage = (float) 150/100;
    double sumAssured = (percentage*basicPremi);
    return sumAssured;
}

@end
