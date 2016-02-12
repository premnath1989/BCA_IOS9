//
//  UIButton+Property.m
//  BLESS
//
//  Created by Erwin on 12/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "UIButton+Property.h"
#import <objc/runtime.h>

@implementation UIButton(Property)

static bool UIB_PROPERTY_KEY;

@dynamic property;

-(void)setProperty:(int)property
{
    NSNumber *number = [NSNumber numberWithInt: property];
    objc_setAssociatedObject(self, &UIB_PROPERTY_KEY, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(int)property
{
    NSNumber *number = objc_getAssociatedObject(self, &UIB_PROPERTY_KEY);
    return [number intValue];
}

@end
