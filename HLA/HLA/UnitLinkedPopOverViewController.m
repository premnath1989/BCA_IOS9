//
//  UnitLinkedPopOverViewController.m
//  BLESS
//
//  Created by Basvi on 11/11/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "UnitLinkedPopOverViewController.h"

@interface UnitLinkedPopOverViewController (){
    NSMutableArray* arrayTableDesc;
    NSMutableArray* arrayTableCode;
}

@end

@implementation UnitLinkedPopOverViewController
@synthesize UnitLinkedPopOverDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTablData:(NSDictionary *)dictTableData Title:(NSString *)stringTitle{
    arrayTableCode = [[NSMutableArray alloc]initWithArray:[dictTableData valueForKey:@"TableCode"]];
    arrayTableDesc = [[NSMutableArray alloc]initWithArray:[dictTableData valueForKey:@"TableDesc"]];
    
    [tablePopOver reloadData];
    
    [navigationItemPopOver setTitle:stringTitle];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayTableDesc count];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.textLabel.text = [arrayTableDesc objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UnitLinkedPopOverDelegate TableData:[arrayTableDesc objectAtIndex:indexPath.row] TableCode:[arrayTableCode objectAtIndex:indexPath.row]];
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
