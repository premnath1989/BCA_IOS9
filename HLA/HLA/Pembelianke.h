//
//  Frekeunsi.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/16/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PembeliaKe;
@protocol PembeliaKeDelegate
-(void)PlanPembelianKe:(PembeliaKe *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc;
@end

@interface PembeliaKe : UITableViewController {
    NSUInteger selectedIndex;
    id <PembeliaKeDelegate> delegate;
}

@property (retain, nonatomic) NSMutableArray *ListOfPlan;
@property (retain, nonatomic) NSMutableArray *ListOfCode;
@property (nonatomic,strong) id <PembeliaKeDelegate> delegate;

@property (nonatomic,strong) id TradOrEver;
@property (nonatomic,strong) id Frekuensi;
@property (readonly) NSString *selectedCode;
@property (readonly) NSString *selectedDesc;

@end
