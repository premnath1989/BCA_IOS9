//
//  ModelEproposalRelation.h
//  BLESS
//
//  Created by Basvi on 11/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelEproposalRelation : NSObject{
    FMResultSet *results;
    sqlite3 *contactDB;
}

-(NSString *)GetRelationCode:(NSString *)stringRelationDesc;
@end
