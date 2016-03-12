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

static BOOL Tab1 = false;
static BOOL Tab2 = false;
static BOOL Tab3 = false;


+(TabValidation*)sharedMySingleton {
    @synchronized([TabValidation class]) {
        if (!_sharedMySingleton){
            [[self alloc] init];
            Tab1 = false;
            Tab2 = false;
            Tab3 = false;
        }
        return _sharedMySingleton;
    }
    return nil;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        // initialize stuff here
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
