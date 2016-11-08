//
//  Table2.h
//  MPOS
//
//  Created by Danial D. Moghaddam on 3/19/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Table2 : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *localArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

-(void)loadFromArray:(NSArray *)arr;
@end
