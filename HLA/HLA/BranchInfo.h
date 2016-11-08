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
-(void)selectedBranch:(NSString *)branchCode BranchName:(NSString *)branchName BranchStatus:(NSString *)branchStatus BranchKanwil:(NSString *)branchKanwil;
@end


@interface BranchInfo : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>{
    NSMutableArray *_itemsKodeCabang;
    NSMutableArray *_itemsNamaCabang;
    NSMutableArray *_itemsStatusCabang;
    NSMutableArray *_itemsKanwilCabang;
    ModelPopover* modelPopOver;
    id <BranchInfoDelegate> _delegate;
    NSArray *sorted;
}
@property (nonatomic, strong) id <BranchInfoDelegate> delegate;
@property (nonatomic, strong) NSNumber *data;
@property (nonatomic, assign) bool isFiltered;
@property (strong, nonatomic) NSMutableArray* FilteredData;
@end
