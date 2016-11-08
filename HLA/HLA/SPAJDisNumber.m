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
#import "ProgressBar.h"
#import "ModelSPAJTransaction.h"
#import "Formatter.h"
#import "SPAJSubmissionFiles.h"
#import "AppDelegate.h"


@implementation SPAJDisNumber{
    Formatter* formatter;
    ModelSPAJTransaction* modelSPAJTransaction;
    
    NSString* SPAJStatus;
}

@synthesize txtSPAJAllocated;
@synthesize txtSPAJBalance;
@synthesize txtSPAJUsed;

@synthesize SPAJSubmissionTable;
@synthesize SPAJRequestTable;
@synthesize btnSPAJSync;


- (void)viewDidLoad{
    [super viewDidLoad];

    SPAJStatus = @"'Submitted','ExistingList'";
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    formatter = [[Formatter alloc]init];

    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    [txtSPAJAllocated setText:[NSString stringWithFormat:@"%lli", [loginDB SPAJAllocated]]];
    [txtSPAJBalance setText:[NSString stringWithFormat:@"%lli", [loginDB SPAJBalance]]];
    [txtSPAJUsed setText:[NSString stringWithFormat:@"%lli", [loginDB SPAJUsed]]];
    
    //tableDataSubmission = [loginDB SPAJRetrievePackID];
    tableDataSubmission = [[NSMutableArray alloc]initWithArray:[modelSPAJTransaction getAllReadySPAJ:@"datetime(spajtrans.SPAJDateModified)" SortMethod:@"DESC" SPAJStatus:SPAJStatus]];
    tableDataRequest = [loginDB SPAJRetrievePackID];
    
    [SPAJSubmissionTable setTag:1];
    [SPAJRequestTable setTag:2];
    [SPAJRequestTable reloadData];
    [SPAJSubmissionTable reloadData];
    
    spinnerLoading = [[SpinnerUtilities alloc]init];

    if([loginDB SPAJBalance] > 30){
        [btnSPAJSync setHidden:YES];
    }
}

-(IBAction)actionSearch:(id)sender{
    NSDictionary *dictSearch = [[NSDictionary alloc]initWithObjectsAndKeys:@"",@"Name",textSearch.text,@"SPAJNumber",@"",@"IDNo",SPAJStatus,@"SPAJStatus", nil];
    tableDataSubmission = [modelSPAJTransaction searchReadySPAJ:dictSearch];
    [SPAJSubmissionTable reloadData];
}

-(IBAction)actionReset:(id)sender{
    [textSearch setText:@""];
    tableDataSubmission = [[NSMutableArray alloc]initWithArray:[modelSPAJTransaction getAllReadySPAJ:@"datetime(spajtrans.SPAJDateModified)" SortMethod:@"DESC" SPAJStatus:SPAJStatus]];
    [SPAJSubmissionTable reloadData];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
                NSString* date = [formatter convertDateFrom:@"yyyy-MM-dd HH:mm:ss" TargetDateFormat:@"dd/MM/yyyy" DateValue:[[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"SPAJDateCreated"]];
                cell.labelDate.text = date;
                cell.labelName.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"ProspectName"];
                cell.labelSINO.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"SPAJSINO"];
                cell.labelSPAJ.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"SPAJNumber"];
                cell.labelStatus.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"SPAJStatus"];
                cell.labelProduk.text = [[tableDataSubmission objectAtIndex:indexPath.row] valueForKey:@"ProductName"];
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
            if((tableDataRequest.count >0)){
                
                long long total = [[[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"SPAJAllocationEnd"] longLongValue] - [[[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"SPAJAllocationBegin"] longLongValue] + 1;
                
                cell.labelDate.text = [[tableDataRequest objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
                cell.labelPackID.text = [[tableDataRequest objectAtIndex:indexPath.row]
                    valueForKey:@"PackID"];
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
        if((tableDataRequest !=nil)&&(tableDataSubmission !=nil)){
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
    [spinnerLoading startLoadingSpinner:self.view label:@"Loading"];
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *serverURL = [NSString stringWithFormat:@"%@/Service2.svc/AllocateSpajForAgent?agentCode=%@",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL], [loginDB AgentCodeLocal]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:serverURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                    [spinnerLoading stopLoadingSpinner];
                 });
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
                    
                    [loginDB insertTableFromJSON:ResponseDict databasePath:@"hladb.sqlite"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self viewDidLoad];
                        
                        if([loginDB SPAJBalance] > 30){
                            [btnSPAJSync setHidden:YES];
                        }
                        
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Success" message:[NSString stringWithFormat:@"SPAJ Number telah di terima."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self viewDidLoad];
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Periksa lagi koneksi internet anda" message:[NSString stringWithFormat:@""] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    });
                }
            }] resume];
}

- (IBAction)btnTestCreateFile:(id)sender{
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:@"image.jpg"];
}

- (IBAction)btnTestUpload:(id)sender{
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *serverURL = [NSString stringWithFormat:@"%@/Service2.svc/CreateRemoteFtpFolder?spajNumber=60000000009",[(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    [[session dataTaskWithURL:[NSURL URLWithString:serverURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data != nil){
                    dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *defaultDBPath = [[dirPaths objectAtIndex:0] stringByAppendingPathComponent:@"SI_Temp.html"];
                    NSBundle *myLibraryBundle = [NSBundle bundleWithURL:[[NSBundle mainBundle]
                                                                         URLForResource:@"xibLibrary" withExtension:@"bundle"]];
                    ProgressBar *progressBar = [[ProgressBar alloc]initWithNibName:@"ProgressBar" bundle:myLibraryBundle];
                    progressBar.TitleFileName = [NSString stringWithFormat: @"%@.%@",@"SI_Temp", @"html"];
                    progressBar.progressDelegate = self;
                    progressBar.ftpfolderdestination = @"60000000009";
                    progressBar.ftpfiletoUpload = defaultDBPath;
                    progressBar.ftpFunction = @"upload";
                    progressBar.modalPresentationStyle = UIModalPresentationFormSheet;
                    progressBar.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    progressBar.preferredContentSize = CGSizeMake(600, 200);
                    [self presentViewController:progressBar animated:YES completion:nil];
                    });
                }
            }] resume];
}

- (IBAction)btnTestAssign:(id)sender{
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSLog(@"%lld",[loginDB getLastActiveSPAJNum]);
}

- (void)downloadisFinished{
    NSString *urlStr = [NSString stringWithFormat:@"%@/Service2.svc/UpdateOnPostUploadData?spajNumber=60000000009&producName=Heritage Product&polisOwner=Johan Regar", [(AppDelegate*)[[UIApplication sharedApplication] delegate] serverURL]];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlStr]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if(data != nil){
                    NSMutableDictionary* json = [NSJSONSerialization
                                                 JSONObjectWithData:data //1
                                                 options:NSJSONReadingMutableContainers
                                                 error:&error];
                    NSLog(@"%@", json);
                    
                }
            }] resume];

}

- (void)percentCompletedfromFTP:(float)percent{
    //left this blank
}

- (void)downloadisError{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)failedConnectToFTP{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Koneksi ke FTP Gagal" message:[NSString stringWithFormat:@"Pastikan perangkat terhubung ke internet yang stabil untuk mengakses FTP"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end