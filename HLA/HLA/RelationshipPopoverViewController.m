//
//  RelationshipPopoverViewController.m
//  MPOS
//
//  Created by Meng Cheong on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RelationshipPopoverViewController.h"
#import "DataClass.h"



@interface RelationshipPopoverViewController (){
    DataClass *obj;
}

@end

@implementation RelationshipPopoverViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    obj=[DataClass getInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData:(NSNumber*)numberIsInternalStaff{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(700.0, 400.0);
    self.IDTypes = [NSMutableArray array];
    self.IDCodes = [NSMutableArray array];
    
    
    //Add "-Select-" in first row
    [_IDTypes addObject:@"- SELECT -"];
    [_IDCodes addObject:@"-1"];
    
    
    
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        //NSString *querySQL = [NSString stringWithFormat:@"SELECT OccpCode, OccpDesc, Class FROM Adm_Occp_Loading_Penta where status = 'A' ORDER BY OccpDesc ASC"];
        NSString *querySQL;
        if ([numberIsInternalStaff intValue]==1){
            querySQL = [NSString stringWithFormat:@"SELECT RelCode,RelDesc FROM eProposal_Relation where status = 'A' and InternalStaff='Y' ORDER BY RelDesc ASC"];
        }
        else{
            querySQL = [NSString stringWithFormat:@"SELECT RelCode,RelDesc FROM eProposal_Relation where status = 'A' ORDER BY RelDesc ASC"];
        }
        
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            NSString *IDTypes;
            NSString *IDCodes;
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                IDTypes = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                IDCodes = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                [_IDTypes addObject:IDTypes];
                [_IDCodes addObject:IDCodes];
            }
        }
        
        sqlite3_close(contactDB);
    }
    
    /*UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50) ];
     
     searchbar.opaque = false;
     searchbar.delegate = (id) self;
     self.tableView.tableHeaderView = searchbar;
     CGRect searchbarFrame = searchbar.frame;
     [self.tableView scrollRectToVisible:searchbarFrame animated:NO];*/
    UISearchBar *zzz = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50) ];
    
    zzz.opaque = false;
    zzz.delegate = (id) self;
    self.tableView.tableHeaderView = zzz;
    CGRect searchbarFrame = zzz.frame;
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:searchbarFrame animated:NO];
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
    return [_IDTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [_IDTypes objectAtIndex:indexPath.row];

    //NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:20 inSection: 0];
    //[tableView selectRowAtIndexPath:indexPath1 animated:NO scrollPosition:UITableViewScrollPositionNone];
    //if (indexPath.row == 5){
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //[cell setSelected:YES];
    //}
    

    
    
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedRelationshipType = [_IDTypes objectAtIndex:indexPath.row];
    NSString *selectedRelationshipCode = [_IDCodes objectAtIndex:indexPath.row];
    
	NSLog(@"selected id :%@",selectedRelationshipType);
    
    if (_rowToUpdate == 0){
        [[obj.CFFData objectForKey:@"SecC"] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"Childen1RelationshipIndex"];
    }
    else if (_rowToUpdate == 1){
        [[obj.CFFData objectForKey:@"SecC"] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"Childen2RelationshipIndex"];        
    }
    else if (_rowToUpdate == 2){
        [[obj.CFFData objectForKey:@"SecC"] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"Childen3RelationshipIndex"];
    }
    else if (_rowToUpdate == 3){
        [[obj.CFFData objectForKey:@"SecC"] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"Childen4RelationshipIndex"];        
    }
    else if (_rowToUpdate == 4){
        [[obj.CFFData objectForKey:@"SecC"] setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:@"Childen5RelationshipIndex"];
    }
    
    //NSLog(@"XXXX%d",_rowToUpdate);
    //NSLog(@"XXXX%d",indexPath.row);
    
    
    //NSLog(@"TTTT%@",[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"CurrentSection"]);
    
    //[[obj.CFFData objectForKey:@"SecC"] setValue:@"" forKey:@"Childen1RelationshipIndex"];
    
    //Notify the delegate if it exists.
    if (_delegate != nil) {
        [_delegate selectedRship:selectedRelationshipType:selectedRelationshipCode];
        
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    //UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    //if (indexPath.row == 20){
    //    [cell setSelected:YES];
    //NSLog(@"csacas");
    //}
    
    
    if (_rowToUpdate == 0){
        if (indexPath.row == [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen1RelationshipIndex"] intValue]){
            [cell setSelected:YES];
        }
    }
    else if (_rowToUpdate == 1){
        if (indexPath.row == [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen2RelationshipIndex"] intValue]){
            [cell setSelected:YES];
        }
    }
    else if (_rowToUpdate == 2){
        if (indexPath.row == [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen3RelationshipIndex"] intValue]){
            [cell setSelected:YES];
        }
    }
    else if (_rowToUpdate == 3){
        if (indexPath.row == [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen4RelationshipIndex"] intValue]){
            [cell setSelected:YES];
        }
    }
    else if (_rowToUpdate == 4){
        if (indexPath.row == [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen5RelationshipIndex"] intValue]){
            [cell setSelected:YES];
        }
    }
    

}




- (void)viewWillAppear:(BOOL)animated {
    
    int temp;
    
    if (_rowToUpdate == 0){
        temp = [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen1RelationshipIndex"] intValue];
        
        if (temp != -1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen1RelationshipIndex"] intValue] inSection:0]
                                  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    else if (_rowToUpdate == 1){
        temp = [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen2RelationshipIndex"] intValue];

        if (temp != -1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen2RelationshipIndex"] intValue] inSection:0]
                                  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    else if (_rowToUpdate == 2){
        temp = [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen3RelationshipIndex"] intValue];

        if (temp != -1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen3RelationshipIndex"] intValue] inSection:0]
                                  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    else if (_rowToUpdate == 3){
        temp = [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen4RelationshipIndex"] intValue];
        
        if (temp != -1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen4RelationshipIndex"] intValue] inSection:0]
                                  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    else if (_rowToUpdate == 4){
        temp = [[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen5RelationshipIndex"] intValue];

        if (temp != -1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[obj.CFFData objectForKey:@"SecC"] objectForKey:@"Childen5RelationshipIndex"] intValue] inSection:0]
                                  atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
}


@end
