//
//  ModelProspectChild.h
//  BLESS
//
//  Created by Basvi on 6/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelProspectChild : NSObject{
    FMResultSet *results;
}

-(void)saveProspectChild:(NSDictionary *)dictProspectChild;
-(NSMutableArray *)selectProspectChild:(int)prospectIndexNo CFFTransctoinID:(int)cffTransactionID;
-(void)updateProspectChild:(NSDictionary *)dictProspectChild;
-(int)chekcExistingRecord:(int)prospectChildIndexNo;
-(void)deleteProspectChildByCFFTransID:(int)cffTransactionID;
@end
