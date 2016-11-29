//
//  PlanList.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/16/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlanList;
@protocol PlanListDelegate
-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc;
@end

@interface PlanList : UITableViewController {
    NSUInteger selectedIndex;
    id <PlanListDelegate> delegate;
}
-(void)setProductDataForUnitLink;

@property (strong, nonatomic) NSMutableArray *ListOfPlan;
@property (strong, nonatomic) NSMutableArray *ListOfCode;
@property (nonatomic,strong) id <PlanListDelegate> delegate;

@property (nonatomic,strong) id TradOrEver;
@property (readonly) NSString *selectedCode;
@property (readonly) NSString *selectedDesc;

@end
