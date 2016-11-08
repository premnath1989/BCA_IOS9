//
//  SPAJDisNumber.h
//  BLESS
//
//  Created by Erwin Lim  on 8/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoItemsDelegate.h"
#import "ProgressBarDelegate.h"
#import "SpinnerUtilities.h"

@interface SPAJDisNumber : UIViewController<UITableViewDataSource, ProductInfoItemsDelegate, ProgressBarDelegate>{
    
    NSMutableArray *tableDataSubmission;
    NSMutableArray *tableDataRequest;
    SpinnerUtilities *spinnerLoading;
    
    IBOutlet UITextField* textSearch;
}

@property (weak, nonatomic) IBOutlet UITextField *txtSPAJAllocated;
@property (weak, nonatomic) IBOutlet UITextField *txtSPAJBalance;
@property (weak, nonatomic) IBOutlet UITextField *txtSPAJUsed;

@property (weak, nonatomic) IBOutlet UIButton *btnSPAJSync;


@property (weak, nonatomic) IBOutlet UITableView *SPAJSubmissionTable;
@property (weak, nonatomic) IBOutlet UITableView *SPAJRequestTable;

- (IBAction)btnClose:(id)sender;
- (IBAction)btnSync:(id)sender;
- (IBAction)btnTestUpload:(id)sender;
- (IBAction)btnTestAssign:(id)sender;
- (IBAction)btnTestCreateFile:(id)sender;

@end