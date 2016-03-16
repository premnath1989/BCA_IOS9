    //
//  KodePosInfo.m
//  BLESS
//
//  Created by Basvi on 3/16/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import "KodePosInfo.h"
NSString *SelectedString;
@interface KodePosInfo ()

@end

@implementation KodePosInfo
@synthesize delegate = _delegate;
@synthesize isFiltered,FilteredData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        modelKodepos=[[ModelKodepos alloc]init];
        // Custom initialization
    }
    return self;
}

-(void)loadData{
    if (([_data intValue] == 0)||([_data intValue] == 2)){
        arrayProvinsi = [[NSMutableArray alloc]initWithArray:[modelKodepos getPropinsi]];
        NSInteger rowsCount = [arrayProvinsi count];
        self.clearsSelectionOnViewWillAppear = NO;
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        CGFloat largestLabelWidth = 0;
        for (NSString *Title in arrayProvinsi) {
            CGSize labelSize = [Title sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        CGFloat popoverWidth = largestLabelWidth + 100;
        self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    else{
        arrayKota = [[NSMutableArray alloc]initWithArray:[modelKodepos getKabupatengbyPropinsi:_provinsiText]];
        NSInteger rowsCount = [arrayKota count];
        self.clearsSelectionOnViewWillAppear = NO;
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        CGFloat largestLabelWidth = 0;
        for (NSString *Title in arrayKota) {
            CGSize labelSize = [Title sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        CGFloat popoverWidth = largestLabelWidth + 100;
        self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated{
    sorted = [[NSArray alloc]init];
    if (([_data intValue] == 0)||([_data intValue] == 2)){
        [self loadData];
        sorted  =  [arrayProvinsi sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    else{
        [self loadData];
        sorted  =  [arrayKota sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *zzz = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50) ];
    
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
    //return 0;
    if(isFiltered ==false)
        if (([_data intValue]==0)||([_data intValue]==2)){
            return [arrayProvinsi count];
        }
        else{
            return [arrayKota count];
        }
        
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
        if (([_data intValue]==0)||([_data intValue]==2)){
            ms = [arrayProvinsi objectAtIndex:indexPath.row];
        }
        else{
            ms = [arrayKota objectAtIndex:indexPath.row];
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
        if (([_data intValue] == 0)||([_data intValue] == 2)){
            SelectedString = [arrayProvinsi objectAtIndex:indexPath.row];
        }
        else{
            SelectedString = [arrayKota objectAtIndex:indexPath.row];
        }
        [_delegate selectedKodePosText:SelectedString SenderTag:[_data intValue]];
    }
    else
    {
        SelectedString = [FilteredData objectAtIndex:indexPath.row];
        //[_delegate selectedBranch:theBranchCode BranchName:theBranchName BranchStatus:theBranchStatus BranchKanwil:theBranchKanwil];
        [_delegate selectedKodePosText:SelectedString SenderTag:[_data intValue]];

        /*NSString *ms = [FilteredData objectAtIndex:indexPath.row];
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
        [_delegate selectedBranch:theBranchCode BranchName:theBranchName BranchStatus:theBranchStatus BranchKanwil:theBranchKanwil];*/
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
