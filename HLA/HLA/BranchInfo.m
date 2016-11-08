//
//  BranchInfoTableViewController.m
//  BLESS
//
//  Created by Basvi on 2/12/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "BranchInfo.h"
NSString *SelectedString;
@interface BranchInfo (){
    UISearchBar *zzz;
}

@end

@implementation BranchInfo
@synthesize delegate = _delegate;
@synthesize isFiltered,FilteredData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        modelPopOver=[[ModelPopover alloc]init];
        /*NSDictionary *dict = [modelPopOver getBranchInfo];
        _itemsKodeCabang = [dict objectForKey:@"KodeCabang"];
        _itemsNamaCabang = [dict objectForKey:@"NamaCabang"];
        _itemsStatusCabang = [dict objectForKey:@"StatusCabang"];
        _itemsKanwilCabang = [dict objectForKey:@"KanwilCabang"];
        
        self.clearsSelectionOnViewWillAppear = NO;
        
        NSInteger rowsCount = [_itemsKodeCabang count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;

        CGFloat largestLabelWidth = 0;
        for (NSString *Title in _itemsKodeCabang) {
            CGSize labelSize = [Title sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        CGFloat popoverWidth = largestLabelWidth + 100;
        
        self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);*/
        
        // Custom initialization
    }
    return self;
}

-(void)loadData:(NSString *)orderBy{
    NSDictionary *dict = [modelPopOver getBranchInfo:orderBy];
    _itemsKodeCabang = [dict objectForKey:@"KodeCabang"];
    _itemsNamaCabang = [dict objectForKey:@"NamaCabang"];
    _itemsStatusCabang = [dict objectForKey:@"StatusCabang"];
    _itemsKanwilCabang = [dict objectForKey:@"KanwilCabang"];
    
    self.clearsSelectionOnViewWillAppear = NO;
    NSInteger rowsCount = [_itemsKodeCabang count];
    NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                           heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger totalRowsHeight = rowsCount * singleRowHeight;
    
    CGFloat largestLabelWidth = 0;
    for (NSString *Title in _itemsKodeCabang) {
        CGSize labelSize = [Title sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
        if (labelSize.width > largestLabelWidth) {
            largestLabelWidth = labelSize.width;
        }
    }
    CGFloat popoverWidth = largestLabelWidth + 100;
    self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
}

-(void)viewWillAppear:(BOOL)animated{
    sorted = [[NSArray alloc]init];
    if ([_data intValue] == 0){
        zzz.keyboardType=UIKeyboardTypeNumberPad;
        [self loadData:@"KodeCabang"];
        sorted  =  [_itemsKodeCabang sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    else{
        zzz.keyboardType=UIKeyboardTypeAlphabet;
        [self loadData:@"NamaCabang"];
        sorted  =  [_itemsNamaCabang sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    zzz = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50) ];
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
    //return [_itemsKodeCabang count];
    if(isFiltered ==false)
        return [_itemsKodeCabang count];
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
        if ([_data intValue]==0){
            ms = [_itemsKodeCabang objectAtIndex:indexPath.row];
        }
        else{
            ms = [_itemsNamaCabang objectAtIndex:indexPath.row];
        }
        
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
        NSString *theBranchCode = [_itemsKodeCabang objectAtIndex:indexPath.row];
        NSString *theBranchName = [_itemsNamaCabang objectAtIndex:indexPath.row];
        NSString *theBranchStatus = [_itemsStatusCabang objectAtIndex:indexPath.row];
        NSString *theBranchKanwil = [_itemsKanwilCabang objectAtIndex:indexPath.row];
        SelectedString = theBranchCode;
        [_delegate selectedBranch:theBranchCode BranchName:theBranchName BranchStatus:theBranchStatus BranchKanwil:theBranchKanwil];
    }
    else
    {
        NSString *ms = [FilteredData objectAtIndex:indexPath.row];
        SelectedString = ms;
        NSString* stringDataShow;
        if ([_data intValue]==0){
            stringDataShow=@"dc.KodeCabang";
        }
        else{
            stringDataShow=@"dc.NamaCabang";
        }
        NSDictionary* dictBranchFilteredData = [modelPopOver getBranchInfoFilter:stringDataShow ColumnValue:SelectedString];
        NSString *theBranchCode = [dictBranchFilteredData valueForKey:@"KodeCabang"];
        NSString *theBranchName = [dictBranchFilteredData valueForKey:@"NamaCabang"];
        NSString *theBranchStatus = [dictBranchFilteredData valueForKey:@"StatusCabang"];
        NSString *theBranchKanwil = [dictBranchFilteredData valueForKey:@"KanwilCabang"];
        [_delegate selectedBranch:theBranchCode BranchName:theBranchName BranchStatus:theBranchStatus BranchKanwil:theBranchKanwil];
    }
    [tableView reloadData];
}
-(void) setTitle:(NSString *)title
{
    SelectedString = title;
    [self.tableView reloadData];
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
