//
//  SAMActivityListViewController.m
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMActivityListViewController.h"
#import "SAMTableViewActivityListCell.h"
#import "SAMActivityViewController.h"
#import "SAMActivityDetailViewController.h"
#import "SAMDBHelper.h"

@interface SAMActivityListViewController ()

@end

NSMutableArray *SAMData;

@implementation SAMActivityListViewController {
    sqlite3 *contactDB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSAMData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark load SPAJTransaction
-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    SAMActivityDetailViewController* viewController = [[SAMActivityDetailViewController alloc] initWithNibName:@"SAMActivityDetailViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void) editDetailsForIndexPath:(NSIndexPath*)indexPath
{
    SAMActivityViewController* viewController = [[SAMActivityViewController alloc] initWithNibName:@"SAMActivityViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)actionEdit:(UIButton*)sender {
    [self editDetailsForIndexPath:0];
}

- (void) loadSAMData {
    SAMDBHelper *dbHelper = [[SAMDBHelper alloc] init];
    SAMData = [dbHelper loadAllSAMData];
}

// TABLE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SAMData count];
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
    SAMTableViewActivityListCell *cellSAMList = (SAMTableViewActivityListCell *)[tableView dequeueReusableCellWithIdentifier:@"SAMTableViewActivityListCell"];
    
    if (cellSAMList == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SAMTableViewActivityListCell" owner:self options:nil];
        cellSAMList = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }
    
//    if(indexPath.row < 5) {
//        [cellSAMList.buttonEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
//        [cellSAMList.buttonEdit setTag:indexPath.row];
//    }
    
    
    
    return cellSAMList;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
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
