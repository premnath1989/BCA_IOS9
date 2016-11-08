//
//  SynchDaysCounter.m
//  BLESS
//
//  Created by Erwin on 14/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "SynchdaysCounter.h"

@implementation SynchdaysCounter

+ (NSInteger)synchLeftDate{
    
    //add function to retrieve last Synch Date From local DB
    
    NSDate *today = [NSDate date];
    return [self daysBetweenDate:today andDate:today];
}


+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
