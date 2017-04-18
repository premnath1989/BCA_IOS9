//
//  SAMMeetingNoteModel.h
//  BLESS
//
//  Created by administrator on 4/15/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMMeetingNoteModel : NSObject

@property (strong, nonatomic) NSString *SAMID;
@property (strong, nonatomic) NSString *SAMNumber;
@property (strong, nonatomic) NSString *meetingDate;
@property (strong, nonatomic) NSString *meetingTime;
@property (strong, nonatomic) NSString *meetingLocation;
@property (strong, nonatomic) NSString *meetingDuration;
@property (strong, nonatomic) NSString *meetingStatus;
@property (strong, nonatomic) NSString *meetingActivity;
@property (strong, nonatomic) NSString *meetingComments;

@end
