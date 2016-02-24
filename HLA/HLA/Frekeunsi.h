//
//  Frekeunsi.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/16/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Frekeunsi;
@protocol FrekeunsiDelegate
-(void)PlanFrekuensi:(Frekeunsi *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc;
@end

@interface Frekeunsi : UITableViewController {
    NSUInteger selectedIndex;
    id <FrekeunsiDelegate> delegate;
}

@property (retain, nonatomic) NSMutableArray *ListOfPlan;
@property (retain, nonatomic) NSMutableArray *ListOfCode;
@property (nonatomic,strong) id <FrekeunsiDelegate> delegate;

@property (nonatomic,strong) id TradOrEver;
@property (nonatomic,strong) id Frekuensi;
@property (readonly) NSString *selectedCode;
@property (readonly) NSString *selectedDesc;

@end
