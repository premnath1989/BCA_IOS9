//
//   UIView+viewRecursion.m UIView+viewRecursion.m
//  BLESS
//
//  Created by Erwin Lim  on 3/31/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation UIView (viewRecursion)

- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}
@end