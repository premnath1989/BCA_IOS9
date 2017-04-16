//
//  SAMMeetingNoteModel.h
//  BLESS
//
//  Created by administrator on 4/15/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAMMeetingNoteModel : NSObject

@property (weak, nonatomic) NSString *meetingDate;
@property (weak, nonatomic) NSString *meetingTime;
@property (weak, nonatomic) NSString *meetingLocation;
@property (weak, nonatomic) NSString *meetingDuration;
@property (weak, nonatomic) NSString *meetingStatus;
@property (weak, nonatomic) NSString *meetingActivity;
@property (weak, nonatomic) NSString *meetingComments;

@end
