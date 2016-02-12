//
//  ColumnHeaderStyle.h
//  BLESS
//
//  Created by Erwin on 11/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColumnHeaderStyle : NSObject{
    NSString *lblTitle;
    NSTextAlignment algText;
    BOOL buttonFlag;
    float width;
}

- (instancetype)init:(NSString *)title alignment:(NSTextAlignment)textAlignment button:(BOOL)flag width:(float)columnWidth;

-(NSString *)getTitle;
-(NSTextAlignment)getAlignment;
-(BOOL)getButtonFlag;
-(float)getColumnWidth;

@end