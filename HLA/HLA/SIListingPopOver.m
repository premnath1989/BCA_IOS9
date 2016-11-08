//
//  SIListingPopOver.m
//  BLESS
//
//  Created by Basvi on 7/28/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIListingPopOver.h"
NSString *SelectedString;

@interface SIListingPopOver ()

@end

@implementation SIListingPopOver
@synthesize delegate = _delegate;
@synthesize isFiltered,FilteredData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        modelSIMaster=[[Model_SI_Master alloc]init];
        [self loadData];
        // Custom initialization
    }
    return self;
}

/*- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 450, 500);
    [self.view.superview setBackgroundColor:[UIColor clearColor]];
}*/


-(void)loadData{
    sorted = [[NSArray alloc]init];
    NSDictionary* dictSIInfo = [[NSDictionary alloc]initWithDictionary:[modelSIMaster getNonQuickQuoteIlustrationata:@"sim.SINO" Method:@"DESC"]];
    arrayProductName = [[NSMutableArray alloc]initWithArray:[dictSIInfo valueForKey:@"ProductName"]];
    arrayPOName = [[NSMutableArray alloc] initWithArray:[dictSIInfo valueForKey:@"PO_Name"]];;
    arraySINo = [[NSMutableArray alloc] initWithArray:[dictSIInfo valueForKey:@"SINO"]];
    arraySIDate = [[NSMutableArray alloc] initWithArray:[dictSIInfo valueForKey:@"CreatedDate"]];
    
    sorted  =  [arraySINo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSInteger rowsCount = [arraySINo count];
    self.clearsSelectionOnViewWillAppear = NO;
    NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                           heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger totalRowsHeight = rowsCount * singleRowHeight;
    CGFloat largestLabelWidth = 0;
    for (NSString *Title in arraySINo) {
        CGSize labelSize = [Title sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
        if (labelSize.width > largestLabelWidth) {
            largestLabelWidth = labelSize.width;
        }
    }
    CGFloat popoverWidth = largestLabelWidth + 100;
    self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *zzz = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50) ];
    zzz.keyboardType=UIKeyboardTypeNumberPad;
    zzz.opaque = false;
    zzz.delegate = (id) self;
    self.tableView.tableHeaderView = zzz;
    CGRect searchbarFrame = zzz.frame;
    [self.tableView scrollRectToVisible:searchbarFrame animated:NO];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([self.tableView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [self.tableView setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (text.length == 0) {
        isFiltered = false;
        
    }
    else {
        isFiltered = true;
        FilteredData = [[NSMutableArray alloc] init ];
        
        for (int a =0; a<sorted.count; a++ ) {
            NSRange Occu = [[sorted objectAtIndex:a ] rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if (Occu.location != NSNotFound) {
                [FilteredData addObject:[sorted objectAtIndex:a ] ];
                
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isFiltered ==false)
        return [arraySINo count];
    else
        
        return [FilteredData count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    SIListingForSPAJTableViewCell *cellSISPAJListing = (SIListingForSPAJTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SIListingForSPAJTableViewCell"];
    
    if (cellSISPAJListing == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SIListingForSPAJTableViewCell" owner:self options:nil];
        cellSISPAJListing = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }
    
    if (isFiltered == true)
    {
        NSString *ms = [FilteredData objectAtIndex:indexPath.row];
        cellSISPAJListing.textLabel.text = ms;
        
        
        if (ms == SelectedString) {
            cellSISPAJListing.accessoryType= UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cellSISPAJListing.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else{
        NSString *ms;
        ms = [arrayPOName objectAtIndex:indexPath.row];
        cellSISPAJListing.labelPOName.text = ms;
        cellSISPAJListing.labelSIDateNumber.text = [NSString stringWithFormat:@"%@ / %@",[arraySIDate objectAtIndex:indexPath.row],[arraySINo objectAtIndex:indexPath.row]];
        cellSISPAJListing.labelProductName.text = [NSString stringWithFormat:@"%@",[arrayProductName objectAtIndex:indexPath.row]];
        
        if (ms == SelectedString) {
            cellSISPAJListing.accessoryType= UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cellSISPAJListing.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cellSISPAJListing.selectionStyle = UITableViewCellSelectionStyleNone;
    cellSISPAJListing.labelPOName.font = [UIFont fontWithName:@"TreBuchet MS" size:16 ];
    return cellSISPAJListing;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isFiltered == false)
    {
        NSString *SINO = [arraySINo objectAtIndex:indexPath.row];
        //NSString *POName = [arrayPOName objectAtIndex:indexPath.row];
        SelectedString = SINO;
        [_delegate selectedSI:SINO];
    }
    else
    {
        /*NSString *ms = [FilteredData objectAtIndex:indexPath.row];
        SelectedString = ms;
        NSDictionary* dictBranchFilteredData = [modelDataReferral getNIPInfoByNIP:SelectedString];
        NSString *NIP = [[dictBranchFilteredData valueForKey:@"NIP"] objectAtIndex:0];
        NSString *Name = [[dictBranchFilteredData valueForKey:@"Nama"] objectAtIndex:0];
        [_delegate selectedNIP:NIP Name:Name];*/
    }
    [tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
