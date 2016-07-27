//
//  DataNasabahViewController.m
//  BLESS
//
//  Created by Basvi on 6/13/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "DataNasabahViewController.h"
#import "ModelCFFTransaction.h"

@interface DataNasabahViewController ()
{
    ModelCFFTransaction* modelCFFTransaction;
}
@end

@implementation DataNasabahViewController{
    IBOutlet UITableView* tableNasabah;
    
    NSDictionary* dictSpouseData;
    NSMutableArray* arrayChildData;
    
    NSMutableArray *ListDataNasabah;
    NSMutableArray *SupplementaryListDataNasabah;
    NSMutableArray *ListDataAnak;
    NSMutableArray *SupplementaryListDataAnak;
    
    NSString* nameNasabah;
    NSString* nameSpouse;
    NSString* nameChild1;
    NSString* nameChild2;
    NSString* nameChild3;
    NSString* nameChild4;
    NSString* nameChild5;
}
@synthesize prospectProfileID,cffTransactionID,cffHeaderSelectedDictionary;

-(void)viewWillAppear:(BOOL)animated{
    //[self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelCFFTransaction = [[ModelCFFTransaction alloc]init];
    modelProspectProfile=[[ModelProspectProfile alloc]init];
    modelProspectSpouse=[[ModelProspectSpouse alloc]init];
    modelProspectChild=[[ModelProspectChild alloc]init];
    
    addSpouseVC = [[AddSpouseViewController alloc]initWithNibName:@"AddSpouseViewController" bundle:nil];
    addSpouseVC.delegate=self;
    addSpouseVC.prospectProfileID=prospectProfileID;
    addSpouseVC.cffTransactionID=cffTransactionID;
    addSpouseVC.modalPresentationStyle = UIModalPresentationFormSheet;
    addSpouseVC.preferredContentSize = CGSizeMake(824, 415);
    //addSpouseVC.view.superview.bounds = CGRectMake(0, 0, 824, 415);
    
    addChildVC = [[AddChildViewController alloc]initWithNibName:@"AddChildViewController" bundle:nil];
    addChildVC.delegate = self;
    addChildVC.prospectProfileID=prospectProfileID;
    addChildVC.cffTransactionID=cffTransactionID;
    addChildVC.modalPresentationStyle = UIModalPresentationFormSheet;
    addChildVC.preferredContentSize = CGSizeMake(824, 415);
    
    ListDataNasabah = [[NSMutableArray alloc] initWithObjects:@"Nama Nasabah :", @"Tambah Data Pasangan :", nil];
    ListDataAnak = [[NSMutableArray alloc] initWithObjects:@"Tambah Anak (1)", @"Tambah Anak (2)", @"Tambah Anak (3)", @"Tambah Anak (4)",@"Tambah Anak (5)", nil];
    
    SupplementaryListDataNasabah = [[NSMutableArray alloc]init];
    SupplementaryListDataAnak = [[NSMutableArray alloc]init];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData{
    [self getNasabahInfo];
    [self getSpouseInfo];
    [self getChildInfo];
    //nameChild1 = @"";
    //nameChild2 = @"";
    //nameChild3 = @"";
    //nameChild4 = @"";
    //nameChild5 = @"";
    
    
    [tableNasabah reloadData];
}

-(void)getNasabahInfo{
    ProspectProfile* pp;
    NSMutableArray *ProspectTableData = [modelProspectProfile searchProspectProfileByID:[prospectProfileID intValue]];
    pp = [ProspectTableData objectAtIndex:0];
    nameNasabah = pp.ProspectName;
    [SupplementaryListDataNasabah insertObject:nameNasabah atIndex:0];
    //[SupplementaryListDataNasabah addObject:nameNasabah];
}

-(void)getSpouseInfo{
    dictSpouseData=[modelProspectSpouse selectProspectSpouse:[prospectProfileID intValue] CFFTransctoinID:[cffTransactionID intValue]];
    if ([[dictSpouseData valueForKey:@"ProspectSpouseName"] length]>0){
        nameSpouse = [dictSpouseData valueForKey:@"ProspectSpouseName"];
    }
    else{
        nameSpouse = @"";
    }
    [SupplementaryListDataNasabah insertObject:nameSpouse atIndex:1];
}

-(void)getChildInfo{
    arrayChildData=[[NSMutableArray alloc]initWithArray:[modelProspectChild selectProspectChild:[prospectProfileID intValue] CFFTransctoinID:[cffTransactionID intValue]]];
    if ([arrayChildData count]>0){
        for (int i=0;i<[ListDataAnak count];i++){
            if (i<[arrayChildData count]){
                NSString* nameChild = [[arrayChildData objectAtIndex:i]valueForKey:@"ProspectChildName"];
                [SupplementaryListDataAnak insertObject:nameChild atIndex:i];
            }
            else{
                [SupplementaryListDataAnak insertObject:@"" atIndex:i];
            }
        }
    }
    else{
        for (int i=0;i<[ListDataAnak count];i++){
            [SupplementaryListDataAnak insertObject:@"" atIndex:i];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 1:
                    [addSpouseVC setDictSpouseData:dictSpouseData];
                    [addSpouseVC loadSpouseData:dictSpouseData];
                    [self presentViewController:addSpouseVC animated:YES completion:nil];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            if (indexPath.row < [arrayChildData count]){
                [addChildVC setDictChildData:[arrayChildData objectAtIndex:indexPath.row]];
            }
            else{
                [addChildVC setDictChildData:[NSDictionary dictionary]];
            }
            [self presentViewController:addChildVC animated:YES completion:nil];
            break;
            
        default:
            break;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case 0:
            return [ListDataNasabah count];
            break;
        case 1:
            return [ListDataAnak count];
            break;
    }
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag!=0){
        if(section == 0)
            return @"Data Nasabah";
        
        if(section == 1)
            return @"Data Anak";
    }
    
    return @"";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor=[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,30)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.shadowColor = [UIColor blackColor];
    tempLabel.shadowOffset = CGSizeMake(0,0);
    tempLabel.textColor = [UIColor colorWithRed:0/255.0f green:102.0f/255.0f blue:179.0f/255.0f alpha:1]; //here you can change the text color of header.
    tempLabel.text=[self tableView:tableView titleForHeaderInSection:section];
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FirstLevelCell= @"FirstLevelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell];
    }
    switch([indexPath section]){
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[ListDataNasabah objectAtIndex: [indexPath row] ],[SupplementaryListDataNasabah objectAtIndex: [indexPath row]]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[ListDataAnak objectAtIndex: [indexPath row] ],[SupplementaryListDataAnak objectAtIndex: [indexPath row]]];
            break;
    }
    cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green:102.0f/255.0f blue:179.0f/255.0f alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

#pragma mark delegate
-(void)reloadProspectData{
    [self loadData];
    [modelCFFTransaction updateCFFDateModified:[cffTransactionID intValue]];
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
