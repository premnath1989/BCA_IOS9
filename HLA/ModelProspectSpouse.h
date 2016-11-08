//
//  ModelProspectSpouse.h
//  BLESS
//
//  Created by Basvi on 6/14/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelProspectSpouse : NSObject{
    FMResultSet *results;
}

-(void)saveProspectSpouse:(NSDictionary *)dictProspectSpouse;
-(void)updateProspectSpouse:(NSDictionary *)dictProspectSpouse;
-(NSDictionary *)selectProspectSpouse:(int)prospectIndexNo CFFTransctoinID:(int)cffTransactionID;
-(int)chekcExistingRecord:(int)prospectSpuseIndexNo;
-(void)deleteProspectSpouseByCFFTransID:(int)cffTransactionID;
@end
