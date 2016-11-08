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

- (instancetype)init:(UIView *)view themeColour:(UIColor *)Colour themeFont:(UIFont *)font{
    ParentView = view;
    themeColour = Colour;
    themeFont = font;
    return self;
}


- (UIView *) TableHeaderSetup:(NSArray *)columnHeaders positionY:(float)originY{
    TableHeader = [[UIView alloc]initWithFrame:
                               CGRectMake(ParentView.frame.origin.x + 15.0f,
                                          originY, ParentView.frame.size.width - 90.0f, 41.0f)];
    [TableHeader setBackgroundColor:themeColour];
    [self TableHeaderColumn:columnHeaders];
    return TableHeader;
}

- (UIView *) TableHeaderSetupXY:(NSArray *)columnHeaders positionY:(float)originY positionX:(float)originX{
    TableHeader = [[UIView alloc]initWithFrame:
                   CGRectMake(originX,
                              originY, ParentView.frame.size.width+132.0f, 41.0f)];
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
                                               headerTable*styleHeader.getColumnWidth,
                                               TableHeader.frame.size.height)];
        lblHeaderColumn.text = styleHeader.getTitle;
        lblHeaderColumn.textColor = [UIColor whiteColor];
        lblHeaderColumn.numberOfLines = 0;
        lblHeaderColumn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        lblHeaderColumn.lineBreakMode = NSLineBreakByWordWrapping;
        lblHeaderColumn.font = themeFont;
        lblHeaderColumn.textAlignment = styleHeader.getAlignment;
        
        [TableHeader addSubview:lblHeaderColumn];
        
        if(lblHeaderColumn.frame.size.height > (TableHeader.frame.size.height - 1.0f)){
            [TableHeader setFrame:CGRectMake(TableHeader.frame.origin.x,
                                             TableHeader.frame.origin.y, TableHeader.frame.size.width,
                                             lblHeaderColumn.frame.size.height + 1.0f)];
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

- (void)TableRowInsert:(NSMutableArray *)dataArray index:(NSInteger)index table:(UITableViewCell*)cell color:(UIColor *)textColor{
    int i = 0;
    for(UIView *view in [TableHeader subviews]){
        if([view isKindOfClass:[UILabel class]]){
            CGRect frame=CGRectMake(view.frame.origin.x + 15.0f,0, view.frame.size.width, 50);
            UILabel *label1=[[UILabel alloc]init];
            label1.frame=frame;
            if ([dataArray count]>0){
                label1.text= [dataArray objectAtIndex:i];
            }
            else{
                label1.text= @"";
            }
            
            label1.tag = (index*1000)+i;
            label1.textColor = textColor;
            label1.textAlignment = NSTextAlignmentJustified;
            label1.font = [UIFont fontWithName:@"BPreplay" size:16];
            [cell.contentView addSubview:label1];
            
            NSLog(@"tag : %ld", (long)label1.tag);
            NSLog(@"name : %@", label1.text);
            NSLog(@"row : %d", index);
            
            i++;
        }
    }
}

@end