//
//  ModelSIULSpecialRequest.h
//  BLESS
//
//  Created by Basvi on 11/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelSIULSpecialOption : NSObject{
    FMResultSet *results;
}

-(void)saveULSpecialOptionData:(NSMutableDictionary *)dictULSpecialOptionData;
-(void)deleteULSpecialOptionData:(NSString *)stringSINO;
-(NSMutableArray *)getULSpecialOptionDataFor:(NSString *)SINo;
-(NSMutableArray *)getULSpecialOptionDataFor:(NSString *)SINo Option:(NSString *)stringOption;
@end
