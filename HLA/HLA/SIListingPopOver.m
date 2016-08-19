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

-(void)loadData{
    sorted = [[NSArray alloc]init];
    NSDictionary* dictSIInfo = [[NSDictionary alloc]initWithDictionary:[modelSIMaster getNonQuickQuoteIlustrationata:@"sim.SINO" Method:@"DESC"]];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (isFiltered == true)
    {
        NSString *ms = [FilteredData objectAtIndex:indexPath.row];
        cell.textLabel.text = ms;
        
        
        if (ms == SelectedString) {
            cell.accessoryType= UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else{
        NSString *ms;
        ms = [arrayPOName objectAtIndex:indexPath.row];
        cell.textLabel.text = ms;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",[arraySIDate objectAtIndex:indexPath.row],[arraySINo objectAtIndex:indexPath.row]];
        if (ms == SelectedString) {
            cell.accessoryType= UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16 ];
    return cell;
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
