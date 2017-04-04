//
//  SAMModel.m
//  BLESS
//
//  Created by administrator on 4/4/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMModel.h"

@implementation SAMModel {
    sqlite3 *contactDB;
}

@synthesize number;
@synthesize customerID;
@synthesize customerType;
@synthesize customerName;
@synthesize idCFF;
@synthesize idVideo;
@synthesize idApplication;
@synthesize idIllustration;
@synthesize idRecomendation;
@synthesize dateCreated;
@synthesize dateModified;
@synthesize dateNextMeeting;
@synthesize status;



@end
