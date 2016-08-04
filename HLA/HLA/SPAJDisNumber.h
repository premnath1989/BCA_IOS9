//
//  SPAJDisNumber.h
//  BLESS
//
//  Created by Erwin Lim  on 8/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAJDisNumber : UIViewController<UITableViewDataSource>{
    
    NSMutableArray *tableDataSubmission;
    NSMutableArray *tableDataRequest;
}

@property (weak, nonatomic) IBOutlet UITextField *txtSPAJAllocated;
@property (weak, nonatomic) IBOutlet UITextField *txtSPAJBalance;
@property (weak, nonatomic) IBOutlet UITextField *txtSPAJUsed;


@property (weak, nonatomic) IBOutlet UITableView *SPAJSubmissionTable;
@property (weak, nonatomic) IBOutlet UITableView *SPAJRequestTable;

- (IBAction)btnClose:(id)sender;
- (IBAction)btnSync:(id)sender;

@end