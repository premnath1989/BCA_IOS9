//
//  ColumnHeaderStyle.m
//  BLESS
//
//  Created by Erwin on 11/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColumnHeaderStyle.h"

@implementation ColumnHeaderStyle

- (instancetype)init:(NSString *)title alignment:(NSTextAlignment)textAlignment button:(BOOL)flag width:(float)columnWidth{
    lblTitle = title;
    algText = textAlignment;
    buttonFlag = flag;
    width = columnWidth;
    return self;
}

-(NSString *)getTitle{
    return lblTitle;
}

-(NSTextAlignment)getAlignment{
    return algText;
}

-(BOOL)getButtonFlag{
    return buttonFlag;
}

-(float)getColumnWidth{
    return width;
}

@end
