//
//  BranchInfoTableViewController.h
//  BLESS
//
//  Created by Basvi on 2/12/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelPopover.h"

@protocol BranchInfoDelegate
-(void)selectedBranch:(NSString *)branchCode BranchName:(NSString *)branchName BranchStatus:(NSString *)branchStatus;
@end


@interface BranchInfo : UITableViewController{
    NSMutableArray *_itemsKodeCabang;
    NSMutableArray *_itemsNamaCabang;
    NSMutableArray *_itemsStatusCabang;
    ModelPopover* modelPopOver;
    id <BranchInfoDelegate> _delegate;
    
}
@property (nonatomic, strong) id <BranchInfoDelegate> delegate;
@property (nonatomic, strong) NSNumber *data;
@end
