//
//  ErrorViewController.m
//  MPOS
//
//  Created by Meng Cheong on 4/24/14.
//  Copyright (c) 2014 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ErrorViewController.h"
#import "submittedVC.h"
#import "FMDatabase.h"
#import "PendingVCCell.h"


@interface ErrorViewController ()
{
    NSString *databasePath;
    
    NSMutableArray *selectedRecords;
    
}
@property (retain, nonatomic) NSMutableArray *ProposalNo;

@end


@implementation ErrorViewController

@synthesize proposalNumber;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.errorTableView.backgroundView = nil;
    self.errorTableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    CGRect frame = self.view.frame;
    frame.size.width = 1024;
    frame.size.height = 768;
    self.view.frame = frame;
    
    
    [self DispalyTableData];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.

    return self.errorDescriptionArray.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.errorTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
		
	cell.textLabel.text = [self.errorDescriptionArray objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = [self.errorDescDTArray objectAtIndex:indexPath.row];
		
    NSLog(@"DEtailTextLabel %@",cell.detailTextLabel.text);
    
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [self.errorDescriptionArray objectAtIndex:indexPath.row];
    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",size.height);
    return size.height + 20;
}


#pragma mark - Table view delegate


-(void)DispalyTableData
{
    //fmdb start
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];
	FMDatabase *db = [FMDatabase databaseWithPath:path];
    [db open];
    
	FMResultSet *results;
    NSString *errordesc=@"";
    NSString *errorDateTime=@"";
    
    
    
    _errorDescriptionArray = [[NSMutableArray alloc] init];
	_errorDescDTArray = [[NSMutableArray alloc] init];
    

    results = [db executeQuery:@"select distinct ErrorDesc,CreateDate from eProposal_Error_Listing  WHERE  RefNo = ? order by ID asc",proposalNumber];
    
    while([results next]) {
		
        errordesc  =[results stringForColumn:@"ErrorDesc"];
        errorDateTime  =[results stringForColumn:@"CreateDate"];
        
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ:00"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:errorDateTime];
            
            
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
            NSString *FormatedDate =[formatter stringFromDate:dateFromString];
            
            [_errorDescriptionArray addObject:errordesc];
            [_errorDescDTArray addObject:FormatedDate];
    }
	
    [db close];
    
//    [_errorDescriptionArray addObject:@""];
//    [_errorDescriptionArray addObject:@""];
    
}
- (IBAction)selectCancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    //[self setPolicyno:nil];
    
    
    [self setErrorLabel1:nil];
    [super viewDidUnload];
}


@end