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

-(double)calculateTotalPremiTopUp:(NSString *)stringSINO{
    double totalPremiTopUp = 0;
    
    modelSIULSpecialOption = [[ModelSIULSpecialOption alloc]init];
    formatter = [[Formatter alloc]init];
    
    NSMutableArray* araySpecialOption = [[NSMutableArray alloc]initWithArray:[modelSIULSpecialOption getULSpecialOptionDataFor:stringSINO Option:@"TopUp"]];
    NSMutableArray *arrayAmountTopUp = [[NSMutableArray alloc]init];
    
    for (int i=0;i<[araySpecialOption count];i++){
        [arrayAmountTopUp addObject:[[araySpecialOption objectAtIndex:i] valueForKey:@"Amount"]];
    }
    
    
    for (int x=0;x<[arrayAmountTopUp count];x++) {
        totalPremiTopUp += [[formatter convertNumberFromStringCurrency:[arrayAmountTopUp objectAtIndex:x]] doubleValue];
    }
    
    return totalPremiTopUp;
}

-(double)calculateTotalPremi:(double)totalPremiSekaligus TotalPremiTopUp:(double)totalPremiTopUp{
    double totalPremi;
    totalPremi = totalPremiSekaligus + totalPremiTopUp;
    return totalPremi;
}

@end
