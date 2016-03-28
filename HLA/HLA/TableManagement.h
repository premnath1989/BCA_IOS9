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
    UIFont *themeFont;
}

- (instancetype)init:(UIView *)view themeColour:(UIColor *)Colour themeFont:(UIFont *)font;
- (UIView *) TableHeaderSetup:(NSArray *)columnHeaders positionY:(float)originY;
- (void)TableRowInsert:(NSMutableArray *)dataArray index:(NSInteger)index table:(UITableViewCell*)cell color:(UIColor *)textColor;
- (UIView *) TableHeaderSetupXY:(NSArray *)columnHeaders positionY:(float)originY positionX:(float)originX;

@end