//
//  TableManagement.h
//  BLESS
//
//  Created by Erwin on 11/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableManagement : NSObject{
    UIView *TableHeader;
    UIView *ParentView;
    UIColor *themeColour;
}

- (instancetype)init:(UIView *)view themeColour:(UIColor *)Colour;
- (UIView *) TableHeaderSetup:(NSArray *)columnHeaders;

@end