//
//  SAMModel.h
//  BLESS
//
//  Created by administrator on 4/4/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SAMModel : NSObject

@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *customerID;
@property (strong, nonatomic) NSString *customerType;
@property (strong, nonatomic) NSString *customerName;
@property (strong, nonatomic) NSString *idCFF;
@property (strong, nonatomic) NSString *idRecomendation;
@property (strong, nonatomic) NSString *idVideo;
@property (strong, nonatomic) NSString *idIllustration;
@property (strong, nonatomic) NSString *idApplication;
@property (strong, nonatomic) NSString *dateCreated;
@property (strong, nonatomic) NSString *dateModified;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *dateNextMeeting;

@end
