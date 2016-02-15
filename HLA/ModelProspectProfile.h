//
//  ModelProspectProfile.h
//  iMobile Planner
//
//  Created by Faiz Umar Baraja on 29/01/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelProspectProfile : NSObject {
    FMResultSet *results;
}
-(NSMutableArray *)getProspectProfile;
-(NSMutableArray *)getDataMobileAndPrefix:(NSString *)DataToReturn ProspectTableData:(NSMutableArray *)prospectTableData;
-(NSMutableArray *)searchProspectProfileByName:(NSString *)searchName BranchName:(NSString *)branchName DOB:(NSString *)dateOfBirth;
@end
