//
//  PlanList.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/16/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Pembelianke.h"

@interface PembeliaKe()

@end

@implementation PembeliaKe
@synthesize ListOfPlan,ListOfCode,selectedCode,selectedDesc, TradOrEver, Frekuensi;
@synthesize delegate;

-(id)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([Frekuensi isEqualToString:@"Trad"])
//    {
        ListOfPlan = [[NSMutableArray alloc] initWithObjects: @"0",@"1",@"2",@"3",@"4",@"5", nil ];
        ListOfCode = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"", nil ];

   // }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ListOfPlan count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = [ListOfPlan objectAtIndex:indexPath.row];
    
	if (indexPath.row == selectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16 ];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    
  //  [delegate Planlisting:self didSelectCode:self.selectedCode andDesc:self.selectedDesc];
    [delegate PlanPembelianKe:self didSelectCode:self.selectedCode andDesc:self.selectedDesc];
    
    [tableView reloadData];
}

-(NSString *)selectedCode
{
    return [ListOfCode objectAtIndex:selectedIndex];
}

-(NSString *)selectedDesc
{
    return [ListOfPlan objectAtIndex:selectedIndex];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [super viewDidUnload];
}

@end
