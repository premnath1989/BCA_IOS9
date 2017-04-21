//
//  SAMActivityDetailViewController.m
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMActivityDetailViewController.h"
#import "SAMTableViewActivityDetailCell.h"
#import "FMDatabase.h"

@interface SAMActivityDetailViewController ()

@end

NSMutableArray *notes;

@implementation SAMActivityDetailViewController

@synthesize SAMdata;
@synthesize labelFullName;
@synthesize labelBirthDate;
@synthesize labelBranchName;
@synthesize labelKCU;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dbHelper = [[SAMDBHelper alloc] init];
    
    notes = [dbHelper ReadMeetingNoteForSAM:SAMdata._id];
    NSMutableArray *res = [self LoadSAMMeetingNoteProspectProfile:SAMdata.customerID];
    
    [labelFullName setText:SAMdata.customerName];
//    while([res next]) {
        [labelBirthDate setText:[res objectAtIndex:0]];
        [labelBranchName setText:[res objectAtIndex:1]];
        [labelKCU setText:[res objectAtIndex:2]];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *) LoadSAMMeetingNoteProspectProfile: (NSString *) customerID
{
    NSMutableArray *arrayProspectDetail = [[NSMutableArray alloc] init];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    FMResultSet *result = [database executeQuery:@"SELECT p.ProspectDOB, p.BranchName, p.KCU FROM prospect_profile AS p WHERE IndexNo = ?", customerID];
    
    while([result next]) {
        [arrayProspectDetail addObject:[result stringForColumn:@"ProspectDOB"]];
        [arrayProspectDetail addObject:[result stringForColumn:@"BranchName"]];
        [arrayProspectDetail addObject:[result stringForColumn:@"KCU"]];
    }
    
    [database close];
    return arrayProspectDetail;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notes count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SAMTableViewActivityDetailCell *cellMeetingNoteList = (SAMTableViewActivityDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cellMeetingNoteList == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SAMTableViewActivityDetailCell" owner:self options:nil];
        cellMeetingNoteList = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }
    
    note = [notes objectAtIndex:indexPath.row];
    
    // Set the field value;
    [cellMeetingNoteList.labelActivityDate setText: note.meetingDate];
    [cellMeetingNoteList.labelTime setText:note.meetingTime];
    [cellMeetingNoteList.labelLocation setText:note.meetingLocation];
    [cellMeetingNoteList.labelDuration setText:note.meetingDuration];
    [cellMeetingNoteList.labelActivity setText:note.meetingActivity];
    [cellMeetingNoteList.labelStatus setText:note.meetingStatus];
    [cellMeetingNoteList.labelComments setText:note.meetingComments];
    
    return cellMeetingNoteList;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
