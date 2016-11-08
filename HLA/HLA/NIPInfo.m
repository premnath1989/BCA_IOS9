//
//  NIPInfo.m
//  BLESS
//
//  Created by Basvi on 3/18/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "NIPInfo.h"
NSString *SelectedString;

@interface NIPInfo ()

@end

@implementation NIPInfo
@synthesize delegate = _delegate;
@synthesize isFiltered,FilteredData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        modelDataReferral=[[ModelDataReferral alloc]init];
        [self loadData];
        // Custom initialization
    }
    return self;
}

-(void)loadData{
    sorted = [[NSArray alloc]init];
        NSDictionary* dictNIPInfo = [[NSDictionary alloc]initWithDictionary:[modelDataReferral getNIPInfo]];
        arrayNIP = [dictNIPInfo objectForKey:@"NIP"];
        arrayRefName = [dictNIPInfo objectForKey:@"Nama"];
    
        sorted  =  [arrayNIP sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSInteger rowsCount = [arrayNIP count];
        self.clearsSelectionOnViewWillAppear = NO;
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        CGFloat largestLabelWidth = 0;
        for (NSString *Title in arrayNIP) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if(isFiltered ==false)
        return [arrayNIP count];
    else
        
        return [FilteredData count];

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
        ms = [arrayNIP objectAtIndex:indexPath.row];
        cell.textLabel.text = ms;
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
        NSString *NIP = [arrayNIP objectAtIndex:indexPath.row];
        NSString *Name = [arrayRefName objectAtIndex:indexPath.row];
        SelectedString = NIP;
        [_delegate selectedNIP:NIP Name:Name];
    }
    else
    {
        NSString *ms = [FilteredData objectAtIndex:indexPath.row];
        SelectedString = ms;
        NSDictionary* dictBranchFilteredData = [modelDataReferral getNIPInfoByNIP:SelectedString];
        NSString *NIP = [[dictBranchFilteredData valueForKey:@"NIP"] objectAtIndex:0];
        NSString *Name = [[dictBranchFilteredData valueForKey:@"Nama"] objectAtIndex:0];
        [_delegate selectedNIP:NIP Name:Name];
    }
    [tableView reloadData];
}
-(void) setTitle:(NSString *)title
{
    SelectedString = title;
    [self.tableView reloadData];
}

@end
