//
//  UIElementsManagement.h
//  BLESS
//
//  Created by Erwin on 12/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIElementsManagement : NSObject{
    UIView *ParentView;
    UIColor *themeColour;
    UIFont *themeFont;
}
- (instancetype)init:(UIView *)view themeColour:(UIColor *)Colour font:(UIFont *)Font;
- (void)setupUI;

@end