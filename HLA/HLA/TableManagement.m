//
//  TableManagement.m
//  BLESS
//
//  Created by Erwin on 11/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableManagement.h"
#import "ColumnHeaderStyle.h"

@implementation TableManagement

- (instancetype)init:(UIView *)view themeColour:(UIColor *)Colour{
    ParentView = view;
    themeColour = Colour;
    return self;
}


- (UIView *) TableHeaderSetup:(NSArray *)columnHeaders{
    TableHeader = [[UIView alloc]initWithFrame:
                               CGRectMake(ParentView.frame.origin.x + 15.0f,
                                          240.0f, ParentView.frame.size.width - 90.0f, 41.0f)];
    [TableHeader setBackgroundColor:themeColour];
    [self TableHeaderColumn:columnHeaders];
    return TableHeader;
}

- (void)TableHeaderColumn:(NSArray *)columnHeaders{
    CGFloat headerOriginX = 0.0f;
    CGFloat headerTable = TableHeader.frame.size.width - (10.0f * (columnHeaders.count-1));
    for(ColumnHeaderStyle *styleHeader in columnHeaders){
        UILabel *lblHeaderColumn = [[UILabel alloc]initWithFrame:
                                    CGRectMake(headerOriginX,
                                               0.0f,
                                               headerTable/columnHeaders.count,
                                               TableHeader.frame.size.height)];
        lblHeaderColumn.text = styleHeader.getTitle;
        lblHeaderColumn.textColor = [UIColor whiteColor];
        lblHeaderColumn.numberOfLines = 0;
        lblHeaderColumn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        lblHeaderColumn.lineBreakMode = NSLineBreakByWordWrapping;
        lblHeaderColumn.font = [UIFont fontWithName:@"HelveticaLTStd-Roman" size:17.0f];
            lblHeaderColumn.textAlignment = styleHeader.getAlignment;
        
        [TableHeader addSubview:lblHeaderColumn];
        
        if(lblHeaderColumn.frame.size.height > (TableHeader.frame.size.height - 1.0f)){
            [TableHeader setFrame:CGRectMake(TableHeader.frame.origin.x,
                                             TableHeader.frame.origin.y, TableHeader.frame.size.width,
                                             lblHeaderColumn.frame.size.height + 1.0f)];
//            NSUInteger currentIndex = [columnHeaders indexOfObject:styleHeader];
//            for(int i = currentIndex-1; i >= 0; i--){
//                UIView *lineObject = (UIView *)[TableHeader viewWithTag:i];
//                [(UIView *)[TableHeader viewWithTag:i] setFrame:CGRectMake(lineObject.frame.origin.x, lineObject.frame.origin.y, 1,TableHeader.frame.size.height)];
//                [lineObject setFrame:CGRectMake(lineObject.frame.origin.x, lineObject.frame.origin.y, 1,
//                                                TableHeader.frame.size.height)];
//            }
        }
        
        if(![styleHeader isEqual: (ColumnHeaderStyle *)[columnHeaders lastObject]]){
            UIView *verticalLineView=[[UIView alloc] initWithFrame:
                                      CGRectMake(lblHeaderColumn.frame.origin.x+lblHeaderColumn.frame.size.width+5, 0, 1, TableHeader.frame.size.height+3.0f)];
            [verticalLineView setTag:[columnHeaders indexOfObject:styleHeader]];
            [verticalLineView setBackgroundColor:[UIColor whiteColor]];
            [TableHeader addSubview:verticalLineView];
        }
        headerOriginX = headerOriginX + lblHeaderColumn.frame.size.width + 10.0f;
    }
}

@end