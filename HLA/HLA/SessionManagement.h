//
//  sessionManagement.h
//  BLESS
//
//  Created by Erwin on 19/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

//The length of time before your application "times out".
//This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 10

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"

@interface SessionManagement : UIApplication
{
    NSTimer     *myidleTimer;
}

-(void)resetIdleTimer;

@end