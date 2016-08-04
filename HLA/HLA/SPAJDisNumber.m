//
//  SPAJDisNumber.m
//  BLESS
//
//  Created by Erwin Lim  on 8/1/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import <Foundation/Foundation.h>
#import "SPAJDisNumber.h"
#import "LoginDBManagement.h"
#import "SPAJTableCell.h"
#import "SPAJRequestCell.h"

@implementation SPAJDisNumber

@synthesize txtSPAJAllocated;
@synthesize txtSPAJBalance;
@synthesize txtSPAJUsed;

@synthesize SPAJSubmissionTable;
@synthesize SPAJRequestTable;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    [txtSPAJAllocated setText:[NSString stringWithFormat:@"%lli", [loginDB SPAJAllocated]]];
    [txtSPAJBalance setText:[NSString stringWithFormat:@"%lli", [loginDB SPAJBalance]]];
    [txtSPAJUsed setText:[NSString stringWithFormat:@"%lli", [loginDB SPAJUsed]]];
    
    tableDataSubmission = [loginDB SPAJRetrievePackID];
    tableDataRequest = [loginDB SPAJRetrievePackID];
    
    [SPAJSubmissionTable setTag:1];
    [SPAJRequestTable setTag:2];
    [SPAJRequestTable reloadData];
    [SPAJSubmissionTable reloadData];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView tag] == 1){
        static NSString *simpleTableIdentifier = @"SubmissionTableItem";
        SPAJTableCell *cell = (SPAJTableCell *)[tableView
                                                dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SPAJTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if(tableDataSubmission != nil){
            if(tableDataSubmission.count >0){
                cell.labelDate.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
                cell.labelName.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"PackID"];
                cell.labelSINO.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"PackID"];
                cell.labelSPAJ.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"PackID"];
                cell.labelStatus.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"PackID"];
                cell.labelProduk.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"PackID"];
            }
        }
        return cell;
    }else{
        static NSString *simpleTableIdentifier = @"RequestTableItem";
        SPAJRequestCell *cell = (SPAJRequestCell *)[tableView
                                                dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SPAJRequestCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if(tableDataRequest != nil){
            if(tableDataRequest.count >0){
                
                long long total = [[[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"SPAJAllocationEnd"] longLongValue] - [[[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"SPAJAllocationBegin"] longLongValue] + 1;
                
                cell.labelDate.text = [[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
                cell.labelPackID.text = [[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"PackID"];
                cell.labelTotal.text = [NSString stringWithFormat:@"%lld",total];
                cell.labelSPAJStart.text = [[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"SPAJAllocationBegin"];
                cell.labelSPAJEnd.text = [[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"SPAJAllocationEnd"];
            }
        }
        return cell;

    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView tag] == 1){
        if(tableDataSubmission !=nil){
            return [tableDataSubmission count];
        }else{
            return 0;
        }
    }else{
        if(tableDataRequest !=nil){
            return [tableDataRequest count];
        }else{
            return 0;
        }
    }
}



- (IBAction)btnClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES ];
}

- (IBAction)btnSync:(id)sender
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://mposws.azurewebsites.net/Service2.svc/AllocateSpajForAgent?agentCode=11600026"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data != nil){
                    NSMutableDictionary* json = [NSJSONSerialization
                                          JSONObjectWithData:data //1
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                    NSMutableDictionary *ResponseDict = [[NSMutableDictionary alloc]init];
                    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
                    
                    
                    //set the date
                    NSDate *today = [NSDate date];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"dd/MM/yyyy"];
                    NSString *dateString = [dateFormat stringFromDate:today];
                    
                    [[json valueForKey:@"d"] setValue:dateString forKey:@"CreatedDate"];
                    [[json valueForKey:@"d"] setValue:dateString forKey:@"UpdatedDate"];
                    [[json valueForKey:@"d"] setValue:@"ACTIVE" forKey:@"Status"];
                    [[json valueForKey:@"d"] removeObjectForKey:@"__type"];
                    [jsonArray addObject:[json valueForKey:@"d"]];
                    [ResponseDict setValue:jsonArray forKey:@"SPAJPackNumber"];
                    NSLog(@"%@",ResponseDict);
                    
                    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
                    [loginDB insertTableFromJSON:ResponseDict databasePath:@"hladb.sqlite"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self viewDidLoad];
                    });
                }
            }] resume];


}

@end