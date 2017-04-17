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
#import "SAMModel.h"

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

-(void) editDetailsForIndexPath:(NSInteger)indexPath
{
    SAMActivityViewController* viewController = [[SAMActivityViewController alloc] initWithNibName:@"SAMActivityViewController" bundle:nil];
    viewController._SAMModel = [SAMData objectAtIndex:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)actionEdit:(UIButton*)sender {
    [self editDetailsForIndexPath:sender.tag];
}

- (void) loadSAMData {
    SAMDBHelper *dbHelper = [[SAMDBHelper alloc] init];
    SAMData = [dbHelper readAllSAMData];
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
    
    [cellSAMList.buttonEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
    [cellSAMList.buttonEdit setTag:indexPath.row];
    
    SAMModel *sam = [SAMData objectAtIndex:indexPath.row];
    
    // Set the field value;
    [cellSAMList.name setText:sam.customerName];
    [cellSAMList.age setText:@"30"];
    [cellSAMList.activityDate setText:sam.dateModified];
    [cellSAMList.type setText:sam.customerType];
    [cellSAMList.activity setText:[self GetActivity:sam]];
    [cellSAMList.status setText:sam.status];
    
    return cellSAMList;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

- (NSString *) GetActivity: (SAMModel *) data
{
    if(!([data.idApplication isEqualToString:@""] || [data.idApplication isEqualToString:@"null"])) {
        return @"Aplikasi";
    } else if(!([data.idIllustration isEqualToString:@""] || [data.idIllustration isEqualToString:@"null"])) {
        return @"Illustrasi";
    } else if(!([data.idVideo isEqualToString:@""] || [data.idVideo isEqualToString:@"null"])) {
        return @"Video";
    } else if(!([data.idRecomendation isEqualToString:@""] || [data.idRecomendation isEqualToString:@"null"])) {
        return @"Rekomendasi Produk";
    } else if(!([data.idCFF isEqualToString:@""] || [data.idCFF isEqualToString:@"null"])) {
        return @"CFF";
    } else {
        return @"Introduksi";
    }
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
