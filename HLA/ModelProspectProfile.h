//
//  ModelProspectProfile.h
//  MPOS
//
//  Created by Faiz Umar Baraja on 29/01/2016.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface ModelProspectProfile : NSObject {
    FMResultSet *results;
}
-(NSMutableArray *)getProspectProfile;
-(NSMutableArray *)getDataMobileAndPrefix:(NSString *)DataToReturn ProspectTableData:(NSMutableArray *)prospectTableData;
-(NSMutableArray *)searchProspectProfileByName:(NSString *)searchName BranchName:(NSString *)branchName DOB:(NSString *)dateOfBirth Order:(NSString *)orderBy Method:(NSString *)method ID:(NSString *)IDNumber;
-(NSString *)checkDuplicateData:(NSString *)Name Gender:(NSString *)gender DOB:(NSString *)dob;
-(NSMutableArray *)searchProspectProfileByID:(int)prospectID;

-(NSMutableArray *)getColumnNames:(NSString *)stringTableName;
-(NSMutableArray *)getColumnValue:(NSString *)stringProspectID ColumnCount:(int)intColumnCount;
-(NSString *)getDataMobileAndPrefix:(NSString *)ContactCode IndexNo:(NSString *)IndexNo;

-(NSString *)selectProspectData:(NSString *)stringColumnName ProspectIndex:(int)intIndexNo;
@end
