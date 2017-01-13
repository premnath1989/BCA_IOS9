//
//  SAMActivityListViewController.m
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMActivityListViewController.h"
#import "SAMTableViewAcitivtyListCell.h"
#import "SAMActivityDetailViewController.h"

@interface SAMActivityListViewController ()

@end

@implementation SAMActivityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

// TABLE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    SAMTableViewAcitivtyListCell *cellSAMList = (SAMTableViewAcitivtyListCell *)[tableView dequeueReusableCellWithIdentifier:@"SAMTableViewAcitivtyListCell"];
    
    if (cellSAMList == nil)
    {
        NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SAMTableViewAcitivtyListCell" owner:self options:nil];
        cellSAMList = [arrayNIB objectAtIndex:0];
    }
    else
    {
        
    }
    
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