//
//  TabValidation.m
//  BLESS
//
//  Created by Erwin Lim  on 3/12/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "TabValidation.h"

@implementation TabValidation
static TabValidation* _sharedMySingleton = nil;

BOOL Tab1;
BOOL Tab2;
BOOL Tab3;


+(TabValidation*)sharedMySingleton {
    
    static TabValidation *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        // initialize stuff here
        Tab1 = false;
        Tab2 = false;
        Tab3 = false;
    }
    return self;
}

- (void) setValidTab1:(BOOL)flag{
    Tab1 = flag;
}

- (void) setValidTab2:(BOOL)flag{
    Tab2 = flag;
}

- (void) setValidTab3:(BOOL)flag{
    Tab3 = flag;
}

- (BOOL) CheckTab1{
    return Tab1;
}

- (BOOL) CheckTab2{
    return Tab2;
}

- (BOOL) CheckTab3{
    return Tab3;
}

- (int) currentValidRow{
    int n = 0;
    if(Tab1)
        n++;
    if(Tab2)
        n++;
    if(Tab3)
        n++;
    return n;
}


@end
