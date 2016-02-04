//
//  SourceIncome.h
//  BLESS
//
//  Created by Basvi on 2/4/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPopover.h"

@protocol SourceIncomeDelegate
-(void)selectedSourceIncome:(NSString *)sourceIncome;
@end

@interface SourceIncome : UITableViewController {
    NSMutableArray *_items;
    id <SourceIncomeDelegate> _delegate;
    ModelPopover* modelPopOver;
}
@property (nonatomic, strong) id <SourceIncomeDelegate> delegate;
@end
