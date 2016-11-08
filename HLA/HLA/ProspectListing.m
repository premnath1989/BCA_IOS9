//
//  ProspectListing.m
//  MPOS
//
//  Created by Md. Nazmus Saadat on 10/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ProspectListing.h"
#import <sqlite3.h>
#import "ProspectProfile.h"
#import "ProspectViewController.h"
#import "EditProspect.h"
#import "AppDelegate.h"
#import "MainScreen.h"
#import "ColorHexCode.h"
#import "IDTypeViewController.h"
#import "MBProgressHUD.h"
#import "CustomAlertBox.h"
#import "ClearData.h"
#import "Cleanup.h"


@interface ProspectListing ()

@end

@implementation ProspectListing
@synthesize ProspectTableData, FilteredProspectTableData, isFiltered;
@synthesize txtIDTypeNo,btnGroup,groupLabel,txtIDNumber;
@synthesize EditProspect = _EditProspect;
@synthesize ProspectViewController = _ProspectViewController;
@synthesize idNoLabel,idTypeLabel,clientNameLabel,editBtn,deleteBtn,nametxt;
@synthesize GroupList = _GroupList;
@synthesize GroupPopover = _GroupPopover;
@synthesize dataMobile,dataPrefix,dataIndex;
@synthesize OrderBy;
//@synthesize outletDOB;
//@synthesize SIDate = _SIDate;

int RecDelete = 0;
int totalView = 20;
int TotalData;

MBProgressHUD *HUD;

- (void)viewDidLoad
{
    [super viewDidLoad];
    modelSIPOData=[[ModelSIPOData alloc]init];
    modelSIRider=[[ModelSIRider alloc]init];
    modelSIPremium=[[Model_SI_Premium alloc]init];
    modelSIMaster=[[Model_SI_Master alloc]init];

    ClearData *CleanData =[[ClearData alloc]init];
    [CleanData ClientWipeOff];
    
    sortMethod=@"ASC";
    
    borderColor=[[UIColor alloc]initWithRed:250.0/255.0 green:175.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletDOB.imageEdgeInsets = UIEdgeInsetsMake(0., outletDOB.frame.size.width - (24 + 10.0), 0., 0.);
    outletDOB.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    outletDOB.layer.borderColor = borderColor.CGColor;
    outletDOB.layer.borderWidth = 1.0;
    
    
    [self setTextfieldBorder];

    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    self.noMoreResultsAvail =NO;
	totalView = 20;
	
    [btnGroup setTitle:@"- SELECT -" forState:UIControlStateNormal];
    btnGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    _btnSortBy.hidden=true;
    _outletOrder.hidden=true;
    
	AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	appDel.MhiMessage = Nil;
	appDel = Nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eApp_SI:) name:@"eApp_SI" object:nil];
    
    [self.view endEditing:YES];
    [self resignFirstResponder];
    
    //modfied by faiz due to change request
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    //self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
//    searchBar.delegate = (id)self;
    [self getTotal]; //just to get total row of data.
    
    /*added by faiz*/
    modelProspectProfile=[[ModelProspectProfile alloc]init];
    ProspectTableData = [modelProspectProfile getProspectProfile];
    [self createBlackStatusBar];
    /*end of added by faiz*/
    
    self.myTableView.rowHeight = 50;
    self.myTableView.backgroundColor = [UIColor clearColor];
    //self.myTableView.separatorColor = [UIColor clearColor];
    self.myTableView.opaque = NO;
    
    deleteBtn.hidden = TRUE;
    deleteBtn.enabled = FALSE;
    ItemToBeDeleted = [[NSMutableArray alloc] init];
    indexPaths = [[NSMutableArray alloc] init];
    
    [self getMobileNo];
	
    OrderBy = @"ASC";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadTableData) name:@"ReloadData" object:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]}];
    
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsZero];
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSLog(@"count %i",[ProspectTableData count]);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

#pragma mark - added by faiz

//added by faiz
-(IBAction)actionProvince:(UIButton *)sender{

}

- (IBAction)btnDOB:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_SIDate == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        _SIDate = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        _SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [_SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [_SIDatePopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:NO];
}

-(void)createBlackStatusBar{
    CGFloat statusBarHeight = 20.0;
    UIView* colorView = [[UIView alloc]initWithFrame:CGRectMake(0, -statusBarHeight, self.view.bounds.size.width, statusBarHeight)];
    [colorView setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:colorView];
}

-(void)setTextfieldBorder{
    UIFont *font= [UIFont fontWithName:@"BPreplay" size:16.0f];
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.layer.borderColor=borderColor.CGColor;
            textField.layer.borderWidth=1.0;
            textField.delegate=self;
            [textField setFont:font];
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
        }
    }
    
    
}


//end of added by faiz
#pragma mark - `Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([ProspectTableData count] == 0){
        return 0;
    }
    else {
        NSLog(@"%i",[ProspectTableData count]+1);
        //return [ProspectTableData count]+1;
        return [ProspectTableData count];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	//change
	if (ProspectTableData.count != 0) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }

		if (indexPath.row == [ProspectTableData count]) {
			//cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.textLabel.text =@"";
            if ([ProspectTableData count] == TotalData) {
                cell.textLabel.text = @"Tidak ada catatan lebih lanjut tersedia";
			}
			else {
            	cell.textLabel.text = @"Memuat lebih banyak catatan...";
			}
			
			cell.textLabel.textColor = [UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1];
			cell.textLabel.font = [UIFont fontWithName:@"BPreplay" size:14];
            cell.userInteractionEnabled = NO;
            return cell;
        }
        else if(indexPath.row <[ProspectTableData count]){
            //static NSString *CellIdentifier = @"Cell";
            ProspectListingTableViewCell *cell1 = (ProspectListingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DataCell"];
            if (cell1 == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProspectListingTableViewCell" owner:self options:nil];
                cell1 = [nib objectAtIndex:0];
            }
            ProspectProfile *pp = [ProspectTableData objectAtIndex:indexPath.row];
            
            int hoursToAdd = 8760;
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            NSArray *CreatedDate = [pp.DateCreated componentsSeparatedByString:@" "];
            NSString *CreatedDateString = [CreatedDate objectAtIndex:0];
            NSString *CreatedTimeString = [CreatedDate objectAtIndex:1];
            NSString *DateNTime = [NSString stringWithFormat:@"%@ %@",CreatedDateString,CreatedTimeString];
            
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateFromString1 = [[NSDate alloc] init];
            // voila!
            dateFromString1 = [dateFormatter1 dateFromString:DateNTime];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *FinalDate = dateFromString1;

            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setHour:hoursToAdd];
            NSLog(@"components %@",components);
            NSDate *newDate= [calendar dateByAddingComponents:components toDate:FinalDate options:0];
            
            [df setDateFormat:@"dd/MM/yyyy ( HH:mm a )"];
            //NSString *strNewDate = [df stringFromDate:newDate];
            
            NSDate *mydate = [NSDate date];
            NSTimeInterval secondsInEightHours = 8 * 60 * 60;
            NSDate *currentDate = [mydate dateByAddingTimeInterval:secondsInEightHours];
            NSDate *expireDate = [newDate dateByAddingTimeInterval:secondsInEightHours];

            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *componentsDay = [gregorianCalendar components:NSCalendarUnitDay
                                                                   fromDate:currentDate
                                                                     toDate:expireDate
                                                                    options:NSCalendarWrapComponents];
            int days1 = [componentsDay day];
            
            int countdown = -[currentDate timeIntervalSinceDate:expireDate];//pay attention here.
            int minutes = (countdown / 60) % 60;
            int hours = (countdown / 3600) % 24;
            int days = (countdown / 86400) % 365;
            
            NSString *DateRemaining =[NSString stringWithFormat:@"%d Hari %d Jam\n %d Menit",days1,hours,minutes];
            
            if ([dataIndex containsObject:pp.ProspectID]){
                int indexArray = [dataIndex indexOfObject:pp.ProspectID];
                [cell1.labelPhone1 setText:[NSString stringWithFormat:@"%@ - %@",[dataPrefix objectAtIndex:indexArray],[dataMobile objectAtIndex:indexArray]]];
            }
            //NSString *identityType = @"";
            NSString *identity = @"";
            /*if([pp.OtherIDType caseInsensitiveCompare:@"1"]==NSOrderedSame){
                identityType = @"KTP";
                identity = [NSString stringWithFormat:@"%@ : %@",identityType, pp.OtherIDTypeNo];
            }else if([pp.OtherIDType caseInsensitiveCompare:@"2"]==NSOrderedSame){
                identityType = @"PASSPOR";
                identity = [NSString stringWithFormat:@"%@ : %@",identityType, pp.OtherIDTypeNo];
            }*/
            if ([pp.OtherIDTypeNo length]>0){
                identity = [NSString stringWithFormat:@"%@ : %@",pp.OtherIDType, pp.OtherIDTypeNo];
            }
            
            [cell1.labelName setText:pp.ProspectName];
            [cell1.labelidNum setText:identity];
            [cell1.labelDOB setText:pp.ProspectDOB];
            [cell1.labelBranchName setText:pp.BranchName];
            //[cell1.labelPhone1 setText:@""];
            if ([dataPrefix count]>indexPath.row){
                cell1.labelPhone1.text= [NSString stringWithFormat:@"%@ - %@",[dataPrefix objectAtIndex:indexPath.row],[dataMobile objectAtIndex:indexPath.row]];
            }
            else {
                cell1.labelPhone1.text = @"";
            }

            [cell1.labelDateCreated setText:pp.DateCreated];
            [cell1.labelDateModified setText:pp.DateModified];
            [cell1.labelTimeRemaining setText:DateRemaining];
            //cell=cell1;
            return cell1;
            
            /*cell.userInteractionEnabled = YES;
			cell.textLabel.text = nil;
			
			//ORIGINAL
			[[cell.contentView viewWithTag:2001] removeFromSuperview ];
			[[cell.contentView viewWithTag:2002] removeFromSuperview ];
			[[cell.contentView viewWithTag:2003] removeFromSuperview ];
			[[cell.contentView viewWithTag:2004] removeFromSuperview ];
			[[cell.contentView viewWithTag:2005] removeFromSuperview ];
			[[cell.contentView viewWithTag:2006] removeFromSuperview ];
			
			
			ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
			
            NSLog(@"prospect name %@",pp.ProspectName);
            
			CGRect frame=CGRectMake(-30,0, 206, 50);
			UILabel *label1=[[UILabel alloc]init];
			label1.frame=frame;
			label1.text= [NSString stringWithFormat:@"        %@",pp.ProspectName];
			label1.textAlignment = NSTextAlignmentLeft;
			label1.tag = 2001;
			cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			[cell.contentView addSubview:label1];
			
			CGRect frame2=CGRectMake(156,0, 196, 50);
			UILabel *label2=[[UILabel alloc]init];
			label2.frame=frame2;
			
			pp.OtherIDTypeNo = [pp.OtherIDTypeNo stringByTrimmingCharactersInSet:
								[NSCharacterSet whitespaceCharacterSet]];
			
			if(([pp.OtherIDType isEqualToString:@"EXPECTED DELIVERY DATE"] || [pp.OtherIDType isEqualToString:@"EDD"]) && [pp.IDTypeNo isEqualToString:@""])
			{
				[label2 setNumberOfLines:1];
				label2.text= pp.ProspectDOB ;
			}
			else if(![pp.OtherIDTypeNo isEqualToString:@""] && ![pp.IDTypeNo isEqualToString:@""])
			{
				[label2 setNumberOfLines:2];
				label2.text = [NSString stringWithFormat:@"%@\n%@", pp.IDTypeNo, pp.OtherIDTypeNo];
			}
			else if(![pp.IDTypeNo isEqualToString:@""])
			{
				[label2 setNumberOfLines:1];
				label2.text= pp.IDTypeNo;
			}
			else if(![pp.OtherIDTypeNo isEqualToString:@""])
			{
				[label2 setNumberOfLines:1];
				label2.text= pp.OtherIDTypeNo;
			}
			
			label2.textAlignment = NSTextAlignmentCenter;
			label2.tag = 2002;
			cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			[cell.contentView addSubview:label2];
			
			CGRect frame3=CGRectMake(312,0, 196, 50);
			UILabel *label3=[[UILabel alloc]init];
			label3.frame=frame3;
			//if (![[dataPrefix objectAtIndex:indexPath.row] isEqualToString:@""]) {
            if ([dataPrefix count]>indexPath.row){
				label3.text= [NSString stringWithFormat:@"%@ - %@",[dataPrefix objectAtIndex:indexPath.row],[dataMobile objectAtIndex:indexPath.row]];
			}
			else {
				label3.text = @"";
			}
			label3.textAlignment = NSTextAlignmentCenter;
			label3.tag = 2003;
			cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			[cell.contentView addSubview:label3];
			
			
			
			
			//date format for date created
			
			NSArray *dateArray = [pp.DateCreated componentsSeparatedByString:@" "];
			
			NSString *dateF =[dateArray objectAtIndex:0];
			
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"yyyy-MM-dd"];
			NSDate *myDate = [df dateFromString: dateF];
			
			
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"dd/MM/yyyy"];
			NSDate * CurrentdateString = [dateFormat stringFromDate:myDate];
			
			NSString *timeF =[dateArray objectAtIndex:1];
			
			CGRect frame4=CGRectMake(478,0, 156, 50);
			UILabel *label4=[[UILabel alloc]init];
			label4.frame=frame4;
			label4.textAlignment = NSTextAlignmentCenter;
			label4.tag = 2004;
			label4.text= [NSString stringWithFormat:@"%@\n%@",CurrentdateString,timeF];
			[label4 setNumberOfLines:2];
			cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			[cell.contentView addSubview:label4];
			NSString *finaldate;
			//date formatted for date modified
			if([pp.DateModified isEqualToString:@""])
			{
                finaldate=pp.DateModified;
			}
			else
			{
				NSArray *dateArray1 = [pp.DateModified componentsSeparatedByString:@" "];
				
				NSString *dateF1 =[dateArray1 objectAtIndex:0];
				
				NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
				[df1 setDateFormat:@"yyyy-MM-dd"];
				NSDate *myDate1 = [df dateFromString: dateF1];
				
				
				NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
				[dateFormat1 setDateFormat:@"dd/MM/yyyy"];
				NSDate * CurrentdateString1 = [dateFormat1 stringFromDate:myDate1];
				
                NSLog(@"%@",dateArray1);
                //FIXME:-dateArray1 only contain 1 row
				NSString *timeF1 = @"test";//[dateArray1 objectAtIndex:1];
				finaldate =[NSString stringWithFormat:@"%@\n%@",CurrentdateString1,timeF1];
				
			}
			
			CGRect frame5=CGRectMake(614,0, 196, 50);
			UILabel *label5=[[UILabel alloc]init];
			label5.frame=frame5;
			label5.textAlignment = NSTextAlignmentCenter;
			label5.tag = 2005;
			label5.text= finaldate;
			[label5 setNumberOfLines:2];
			
			NSArray *CreatedDate = [pp.DateCreated componentsSeparatedByString:@" "];
			NSString *CreatedDateString = [CreatedDate objectAtIndex:0];
			NSString *CreatedTimeString = [CreatedDate objectAtIndex:1];
			NSString *DateNTime = [NSString stringWithFormat:@"%@ %@",CreatedDateString,CreatedTimeString];
			
			NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *dateFromString1 = [[NSDate alloc] init];
            // voila!
            dateFromString1 = [dateFormatter1 dateFromString:DateNTime];
			
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			
			NSDate *FinalDate = dateFromString1;
            
            NSString *strNewDate;
            NSString *strCurrentDate;
            NSDateFormatter *df1 =[[NSDateFormatter alloc]init];
            [df1 setDateStyle:NSDateFormatterMediumStyle];
            [df1 setTimeStyle:NSDateFormatterMediumStyle];
            strCurrentDate = [df1 stringFromDate:FinalDate];
            
            int hoursToAdd = 720;
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setHour:hoursToAdd];
            NSDate *newDate= [calendar dateByAddingComponents:components toDate:FinalDate options:0];
            
            [df setDateFormat:@"dd/MM/yyyy ( HH:mm a )"];
            strNewDate = [df stringFromDate:newDate];
			
			NSDate *mydate = [NSDate date];
            NSTimeInterval secondsInEightHours = 8 * 60 * 60;
            NSDate *currentDate = [mydate dateByAddingTimeInterval:secondsInEightHours];
            NSDate *expireDate = [newDate dateByAddingTimeInterval:secondsInEightHours];
            
            int countdown = -[currentDate timeIntervalSinceDate:expireDate];//pay attention here.
			int minutes = (countdown / 60) % 60;
            int hours = (countdown / 3600) % 24;
            int days = (countdown / 86400) % 30;
			
			NSString *DateRemaining =[NSString stringWithFormat:@"%d Days %d Hours\n %d Minutes",days,hours,minutes];
           
			CGRect frame6=CGRectMake(794,0, 186, 50);
			UILabel *label6=[[UILabel alloc]init];
			label6.frame=frame6;
			label6.textAlignment = NSTextAlignmentCenter;
			label6.tag = 2006;
			label6.text= DateRemaining;
			[label6 setNumberOfLines:2];
			
			cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			[cell.contentView addSubview:label6];
			
			cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			[cell.contentView addSubview:label5];
			
			if (indexPath.row % 2 == 0) {
				label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
				label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
				label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
				label4.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
				label5.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
				label6.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
				
				label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			}
			else {
				label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
				label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
				label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
				label4.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
				label5.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
				label6.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
				
				label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
				label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
			}*/
						
			// ADD HERE
			[spinner stopAnimating];
			spinner.hidden=YES;
			pp = Nil;
        }
        else {
            if (!self.noMoreResultsAvail) {
                spinner.hidden =NO;
                cell.textLabel.text=nil;
                
                spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                spinner.frame = CGRectMake(150, 10, 24, 50);
                [cell addSubview:spinner];
                if ([ProspectTableData count] >= 10) {
                    [spinner startAnimating];
                }
            }
            else {				
                [spinner stopAnimating];
                spinner.hidden=YES;
                cell.textLabel.text=nil;
            }
        }
    }
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma UIScroll View Method::
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.loading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            [self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:1];
        }
    }
}

#pragma UserDefined Method for generating data which are show in Table :::
-(void)loadDataDelayed{
	if (totalView < TotalData) {
		totalView = totalView + 10;
		[self ReloadTableData];
	}
}

- (NSString*) getGroupName:(NSString*)groupid
{
    groupid = [groupid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *groupname = @"";
        FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
        [db open];
    
        FMResultSet *result = [db executeQuery:@"SELECT name from prospect_groups WHERE id = ?", groupid];
        while ([result next]) {
                groupname =  [result stringForColumn:@"name"];
        }
        [result close];
        [db close];
            
    return groupname;
}

- (NSString*) getGroupID:(NSString*)groupName
{
    groupName = [groupName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *groupID = @"";
	FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
	[db open];
    
	FMResultSet *result = [db executeQuery:@"SELECT id from prospect_groups WHERE name = ?", groupName];
	while ([result next]) {
		groupID =  [result stringForColumn:@"id"];
		
	}
	[result close];
	[db close];
	
    return groupID;
}

- (void) getTotal
{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
	FMDatabase *db = [FMDatabase databaseWithPath:path];
	if ([db close]) {
		[db open];
	}
    
	NSString *SqlCount = [NSString stringWithFormat:@"SELECT count(*) as count FROM prospect_profile WHERE QQFlag = 'false'  order by LOWER(ProspectName) ASC"];
	
	FMResultSet *result = [db executeQuery:SqlCount];
	while ([result next]) {
		TotalData =  [result intForColumn:@"count"];
		
	}
	[result close];
	[db close];
}

#pragma mark - delegate
-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *d = [NSDate date];
    NSDate* d2 = [df dateFromString:strDate];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    NSString        *clientDateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter* clientDateFormmater = [[NSDateFormatter alloc] init];
    [clientDateFormmater setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    clientDateString = [clientDateFormmater stringFromDate:d2];
    
    if ([d compare:d2] == NSOrderedAscending){
        NSString *validationTanggalLahirFuture=@"Tanggal lahir tidak dapat lebih besar dari tanggal hari ini";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else{
        outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [outletDOB setTitle:strDate forState:UIControlStateNormal];
    }
    df = Nil, d = Nil, d2 = Nil;
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [_SIDatePopover dismissPopoverAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecDelete = RecDelete+1;
    
    if ([self.myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [self.myTableView visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (!gotRowSelected) {
            ////[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = FALSE;
        }
        else {
            ////[deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            deleteBtn.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted addObject:zzz];
        [indexPaths addObject:indexPath];
    }
    else {
		NSUInteger row = [indexPath row];
		NSUInteger count = [ProspectTableData count];
		if (row != count) {
			[self showDetailsForIndexPath:indexPath];
		}
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecDelete = RecDelete - 1;
   
    if ([self.myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [self.myTableView visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (RecDelete < 1) {
            ////[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = FALSE;
        }
        else {
            ////[deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            deleteBtn.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted removeObject:zzz];
        [indexPaths removeObject:indexPath];
    }
}

-(void) eApp_SI: (NSNotification *)notification
{
    
    NSString  *ppindex = [notification object];
   //DB QUERY START
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSString *ProspectID = @"";
    NSString *NickName = @"";
    NSString *ProspectName = @"";
    NSString *ProspectDOB = @"" ;
    NSString *ProspectGender = @"";
    NSString *ResidenceAddress1 = @"";
    NSString *ResidenceAddress2 = @"";
    NSString *ResidenceAddress3 = @"";
    NSString *ResidenceAddressTown = @"";
    NSString *ResidenceAddressState = @"";
    NSString *ResidenceAddressPostCode = @"";
    NSString *ResidenceAddressCountry = @"";
    NSString *OfficeAddress1 = @"";
    NSString *OfficeAddress2 = @"";
    NSString *OfficeAddress3 = @"";
    NSString *OfficeAddressTown = @"";
    NSString *OfficeAddressState = @"";
    NSString *OfficeAddressPostCode = @"";
    NSString *OfficeAddressCountry = @"";
    NSString *ProspectEmail = @"";
    NSString *ProspectOccupationCode = @"";
    NSString *ExactDuties = @"";
    NSString *ProspectRemark = @"";
    
    //basvi added
    NSString *DateCreated = @"";
    NSString *CreatedBy = @"";
    NSString *DateModified = @"";
    NSString *ModifiedBy = @"";

    NSString *ProspectGroup = @"";
    NSString *ProspectTitle = @"";
    NSString *IDTypeNo = @"";
    NSString *OtherIDType = @"";
    NSString *OtherIDTypeNo = @"";
    NSString *Smoker = @"";
    
    NSString *Race = @"";
    
    NSString *Nationality = @"";
    NSString *MaritalStatus = @"";
    NSString *Religion = @"";
    
    NSString *AnnIncome = @"";
    NSString *BussinessType = @"";
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM prospect_profile WHERE IndexNo = %@", ppindex];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            ProspectTableData = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ProspectID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                const char *name = (const char*)sqlite3_column_text(statement, 1);
                NickName = name == NULL ? nil : [[NSString alloc] initWithUTF8String:name];
                
                ProspectName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                ProspectDOB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                ProspectGender = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                
                const char *Address1 = (const char*)sqlite3_column_text(statement, 5);
                ResidenceAddress1 = Address1 == NULL ? nil : [[NSString alloc] initWithUTF8String:Address1];
                
                const char *Address2 = (const char*)sqlite3_column_text(statement, 6);
                ResidenceAddress2 = Address2 == NULL ? nil : [[NSString alloc] initWithUTF8String:Address2];
                
                const char *Address3 = (const char*)sqlite3_column_text(statement, 7);
                ResidenceAddress3 = Address3 == NULL ? nil : [[NSString alloc] initWithUTF8String:Address3];
                
                const char *AddressTown = (const char*)sqlite3_column_text(statement, 8);
                ResidenceAddressTown = AddressTown == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressTown];
                
                const char *AddressState = (const char*)sqlite3_column_text(statement, 9);
                ResidenceAddressState = AddressState == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressState];
                
                const char *AddressPostCode = (const char*)sqlite3_column_text(statement, 10);
                ResidenceAddressPostCode = AddressPostCode == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressPostCode];
                
                const char *AddressCountry = (const char*)sqlite3_column_text(statement, 11);
                ResidenceAddressCountry = AddressCountry == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressCountry];
                
                const char *AddressOff1 = (const char*)sqlite3_column_text(statement, 12);
                OfficeAddress1 = AddressOff1 == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOff1];
                
                const char *AddressOff2 = (const char*)sqlite3_column_text(statement, 13);
                OfficeAddress2 = AddressOff2 == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOff2];
                
                const char *AddressOff3 = (const char*)sqlite3_column_text(statement, 14);
                OfficeAddress3 = AddressOff3 == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOff3];
                
                const char *AddressOffTown = (const char*)sqlite3_column_text(statement, 15);
                OfficeAddressTown = AddressOffTown == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffTown];
                
                const char *AddressOffState = (const char*)sqlite3_column_text(statement, 16);
                OfficeAddressState = AddressOffState == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffState];
                
                const char *AddressOffPostCode = (const char*)sqlite3_column_text(statement, 17);
                OfficeAddressPostCode = AddressOffPostCode == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffPostCode];
                
                const char *AddressOffCountry = (const char*)sqlite3_column_text(statement, 18);
                OfficeAddressCountry = AddressOffCountry == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffCountry];
                
                const char *Email = (const char*)sqlite3_column_text(statement, 19);
                ProspectEmail = Email == NULL ? nil : [[NSString alloc] initWithUTF8String:Email];
                
                ProspectOccupationCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)];
                
                const char *Duties = (const char*)sqlite3_column_text(statement, 21);
                ExactDuties = Duties == NULL ? nil : [[NSString alloc] initWithUTF8String:Duties];
                
                const char *Remark = (const char*)sqlite3_column_text(statement, 22);
                ProspectRemark = Remark == NULL ? nil : [[NSString alloc] initWithUTF8String:Remark];
                //basvi added
                const char *DateCr = (const char*)sqlite3_column_text(statement, 23);
                DateCreated = DateCr == NULL ? nil : [[NSString alloc] initWithUTF8String:DateCr];
                
                const char *CrBy = (const char*)sqlite3_column_text(statement, 24);
                CreatedBy = CrBy == NULL ? nil : [[NSString alloc] initWithUTF8String:CrBy];
                
                const char *DateMod = (const char*)sqlite3_column_text(statement, 25);
                DateModified = DateMod == NULL ? nil : [[NSString alloc] initWithUTF8String:DateMod];
                
                const char *ModBy = (const char*)sqlite3_column_text(statement, 26);
                ModifiedBy = ModBy == NULL ? nil : [[NSString alloc] initWithUTF8String:ModBy];
                //
                const char *Group = (const char*)sqlite3_column_text(statement, 27);
                ProspectGroup = Group == NULL ? nil : [[NSString alloc] initWithUTF8String:Group];
                
                const char *Title = (const char*)sqlite3_column_text(statement, 28);
                ProspectTitle = Title == NULL ? nil : [[NSString alloc] initWithUTF8String:Title];
                
                const char *typeNo = (const char*)sqlite3_column_text(statement, 29);
                IDTypeNo = typeNo == NULL ? nil : [[NSString alloc] initWithUTF8String:typeNo];
                
                const char *OtherType = (const char*)sqlite3_column_text(statement, 30);
                OtherIDType = OtherType == NULL ? nil : [[NSString alloc] initWithUTF8String:OtherType];
                if ([OtherIDType isEqualToString:@"(NULL)"] || [OtherIDType isEqualToString:@"(null)"]) {
					OtherIDType = @"";
                }
                
                const char *OtherTypeNo = (const char*)sqlite3_column_text(statement, 31);
                OtherIDTypeNo = OtherTypeNo == NULL ? nil : [[NSString alloc] initWithUTF8String:OtherTypeNo];
                
                const char *smok = (const char*)sqlite3_column_text(statement, 32);
                Smoker = smok == NULL ? nil : [[NSString alloc] initWithUTF8String:smok];
                
                const char *ann = (const char*)sqlite3_column_text(statement, 33);
                AnnIncome = ann == NULL ? nil : [[NSString alloc] initWithUTF8String:ann];
                
                const char *buss = (const char*)sqlite3_column_text(statement, 34);
                BussinessType = buss == NULL ? nil : [[NSString alloc] initWithUTF8String:buss];
                
                const char *rac = (const char*)sqlite3_column_text(statement, 35);
                Race = rac == NULL ? nil : [[NSString alloc] initWithUTF8String:rac];
                
                const char *marstat = (const char*)sqlite3_column_text(statement, 36);
                MaritalStatus = marstat == NULL ? nil : [[NSString alloc] initWithUTF8String:marstat];
                
                const char *rel = (const char*)sqlite3_column_text(statement, 41);
                Religion = rel == NULL ? nil : [[NSString alloc] initWithUTF8String:rel];
                
                const char *nat = (const char*)sqlite3_column_text(statement, 38);
                Nationality = nat == NULL ? nil : [[NSString alloc] initWithUTF8String:nat];
                
                const char *reg = (const char*)sqlite3_column_text(statement, 41);
                NSString *registrationNo = reg == NULL ? nil : [[NSString alloc] initWithUTF8String:reg];

                const char *isreg = (const char*)sqlite3_column_text(statement, 40);
                NSString *registration = isreg == NULL ? nil : [[NSString alloc] initWithUTF8String:isreg];
                
                const char *regdate = (const char*)sqlite3_column_text(statement, 42);
                NSString *registrationDate = regdate == NULL ? nil : [[NSString alloc] initWithUTF8String:regdate];
                
                const char *exempted = (const char*)sqlite3_column_text(statement, 43);
                NSString *regExempted = exempted == NULL ? nil : [[NSString alloc] initWithUTF8String:exempted];
				
                const char *isG = (const char*)sqlite3_column_text(statement, 45);
                NSString *isGrouping = isG == NULL ? nil : [[NSString alloc] initWithUTF8String:isG];
				
				const char *CountryOfBirth = (const char*)sqlite3_column_text(statement, 46);
                NSString *COB = CountryOfBirth == NULL ? nil : [[NSString alloc] initWithUTF8String:CountryOfBirth];
                
                [ProspectTableData addObject:[[ProspectProfile alloc] initWithName:NickName AndProspectID:ProspectID AndProspectName:ProspectName
                                                                  AndProspecGender:ProspectGender AndResidenceAddress1:ResidenceAddress1
                                                              AndResidenceAddress2:ResidenceAddress2 AndResidenceAddress3:ResidenceAddress3
                                                           AndResidenceAddressTown:ResidenceAddressTown AndResidenceAddressState:ResidenceAddressState
                                                       AndResidenceAddressPostCode:ResidenceAddressPostCode AndResidenceAddressCountry:ResidenceAddressCountry
                                                                 AndOfficeAddress1:OfficeAddress1 AndOfficeAddress2:OfficeAddress2 AndOfficeAddress3:OfficeAddress3 AndOfficeAddressTown:OfficeAddressTown
                                                             AndOfficeAddressState:OfficeAddressState AndOfficeAddressPostCode:OfficeAddressPostCode
                                                           AndOfficeAddressCountry:OfficeAddressCountry AndProspectEmail:ProspectEmail AndProspectRemark:ProspectRemark AndDateCreated:DateCreated AndDateModified:DateModified AndCreatedBy:CreatedBy AndModifiedBy:ModifiedBy
                                                         AndProspectOccupationCode:ProspectOccupationCode AndProspectDOB:ProspectDOB AndExactDuties:ExactDuties AndGroup:ProspectGroup AndTitle:ProspectTitle AndIDTypeNo:IDTypeNo AndOtherIDType:OtherIDType AndOtherIDTypeNo:OtherIDTypeNo AndSmoker:Smoker AndAnnIncome:AnnIncome AndBussType:BussinessType AndRace:Race AndMaritalStatus:MaritalStatus AndReligion:Religion AndNationality:Nationality AndRegistrationNo:registrationNo AndRegistration:registration AndRegistrationDate:registrationDate AndRegistrationExempted:regExempted AndProspect_IsGrouping:isGrouping AndCountryOfBirth:COB AndNIP:@"" AndBranchCode:@"" AndBranchName:@"" AndKCU:@"" AndReferralSource:@"" AndReferralName:@"" AndIdentitySubmitted:@"" AndIDExpirityDate:@"" AndNPWPNo:@"" AndKanwil:@"" AndHomeVillage:@"" AndHomeDistrict:@"" AndHomeProvince:@"" AndOfficeVillage:@"" AndOfficeDistrict:@"" AndOfficePorvince:@"" AndSourceIncome:@"" AndClientSegmentation:@""]];
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
        query_stmt = Nil, query_stmt = Nil;
    }
    
    dirPaths = Nil, docsDir = Nil, dbpath = Nil, statement = Nil, statement = Nil;
    ProspectID = Nil;
    NickName = Nil;
    ProspectName = Nil ;
    ProspectDOB = Nil  ;
    ProspectGender = Nil;
    ResidenceAddress1 = Nil;
    ResidenceAddress2 = Nil;
    ResidenceAddress3 = Nil;
    ResidenceAddressTown = Nil;
    ResidenceAddressState = Nil;
    ResidenceAddressPostCode = Nil;
    ResidenceAddressCountry = Nil;
    OfficeAddress1 = Nil;
    OfficeAddress2 = Nil;
    OfficeAddress3 = Nil;
    OfficeAddressTown = Nil;
    OfficeAddressState = Nil;
    OfficeAddressPostCode = Nil;
    OfficeAddressCountry = Nil;
    ProspectEmail = Nil;
    ProspectOccupationCode = Nil;
    ExactDuties = Nil;
    ProspectRemark = Nil;
    //basvi
    DateCreated = Nil;
    CreatedBy = Nil;
    DateModified = Nil;
    ModifiedBy = Nil;
    //

    ProspectTitle = Nil, ProspectGroup = Nil, IDTypeNo = Nil, OtherIDType = Nil, OtherIDTypeNo = Nil, Smoker = Nil;
    Race = Nil, Religion = Nil, MaritalStatus = Nil, Nationality = Nil;
   
   //DB QUERY END
    ProspectProfile* pp = [ProspectTableData objectAtIndex:0];
    
    if (_EditProspect == Nil) {
        self.EditProspect = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProspect"];
        _EditProspect.delegate = self;
    }
    
    _EditProspect.pp = pp;
    _EditProspect.navigationItem.hidesBackButton = YES;
    _EditProspect.navigationItem.leftBarButtonItem = nil;
    _EditProspect.navigationItem.backBarButtonItem=nil;
   
    self.view.frame = CGRectMake(0, 0, 1388, 1004);
    _EditProspect.view.superview.frame = CGRectMake(0, 0, 1388, 1004);
    _EditProspect.view.frame = CGRectMake(0, 0, 1388, 1004);
    [self.navigationController pushViewController:_EditProspect animated:YES];
    _EditProspect.navigationItem.title = @"Edit Client Profile";
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditProspect_Done" object:self];
  
    pp = Nil;

}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    EditProspect* zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProspect"];
    ProspectProfile* pp;
    
    if(isFiltered)
    {
        pp = [FilteredProspectTableData objectAtIndex:indexPath.row];
    }
    else
    {
        pp = [ProspectTableData objectAtIndex:indexPath.row];
    }
    zzz.pp = pp;
    
    if (_EditProspect == Nil) {
        self.EditProspect = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProspect"];
        _EditProspect.delegate = self;
    }
    _EditProspect.pp = pp;
    @try {
		[self.navigationController pushViewController:_EditProspect animated:YES];
		_EditProspect.navigationItem.title = @"Edit";
	} @catch (NSException * e) {
		NSLog(@"Exception: %@", e);
	} @finally {
	}
    pp = Nil, zzz = Nil;

}

- (void)pushViewController:(UIViewController *)viewController {
	if (viewController) {
		@try {
			[self.navigationController pushViewController:_EditProspect animated:YES];
			_EditProspect.navigationItem.title = @"Edit Client Profile";
		} @catch (NSException * ex) {
			//“Pushing the same view controller instance more than once is not supported”
			NSLog(@"Exception: [%@]:%@",[ex  class], ex );
			NSLog(@"ex.name:'%@'", ex.name);
			NSLog(@"ex.reason:'%@'", ex.reason);
			//Full error includes class pointer address so only care if it starts with this error
			NSRange range = [ex.reason rangeOfString:@"Pushing the same view controller instance more than once is not supported"];
			
			if ([ex.name isEqualToString:@"NSInvalidArgumentException"] &&
				range.location != NSNotFound) {
				//view controller already exists in the stack - just pop back to it
				[self.navigationController pushViewController:_EditProspect animated:YES];
				_EditProspect.navigationItem.title = @"Edit Client Profile";
			} else {
				NSLog(@"ERROR:UNHANDLED EXCEPTION TYPE:%@", ex);
			}
		} @finally {
		}
	} else {
		NSLog(@"ERROR:pushViewController: viewController is nil");
	}
}

#pragma mark - action

-(void)getMobileNo
{
    dataIndex = [[NSMutableArray alloc] initWithArray:[modelProspectProfile getDataMobileAndPrefix:@"Index" ProspectTableData:ProspectTableData]];
    dataMobile = [[NSMutableArray alloc] initWithArray:[modelProspectProfile getDataMobileAndPrefix:@"ContactNo" ProspectTableData:ProspectTableData]];
    dataPrefix = [[NSMutableArray alloc] initWithArray:[modelProspectProfile getDataMobileAndPrefix:@"Prefix" ProspectTableData:ProspectTableData]];
    
    /*for (int a=0; a<ProspectTableData.count; a++) {
        
        ProspectProfile *pp = [ProspectTableData objectAtIndex:a];
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
            NSString *querySQL = [NSString stringWithFormat:@"SELECT ContactCode, ContactNo, Prefix FROM contact_input where indexNo = %@ AND ContactCode = 'CONT008'", pp.ProspectID];
        
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *ContactNo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *Prefix = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    
                    [dataMobile addObject:ContactNo];
                    [dataPrefix addObject:Prefix];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
    }*/
}

- (IBAction)btnAddNew:(id)sender//premnathvj
{
    
	/*UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:nil];
    CustomAlertBox * agree = (CustomAlertBox *)[storyboard instantiateViewControllerWithIdentifier:@"CustomAlertBox"];
    agree.AlertProspect=YES;
	
	agree.delegate=self;
    
    agree.modalPresentationStyle = UIModalPresentationFormSheet;
    agree.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:agree animated:NO completion:nil];
    agree.preferredContentSize = CGSizeMake(600, 450);
    agree.view.superview.frame = CGRectMake(120, 200, 450, 600);*/
	
    
    //UIStoryboard* clientProfileStoryboard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
    self.ProspectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Prospect"];
    self.ProspectViewController.delegate = self;
    [self.navigationController pushViewController:_ProspectViewController animated:YES];
    //Cheged by faiz due to language translation
    /*_ProspectViewController.navigationItem.title = @"Add Client Profile";*/
    _ProspectViewController.navigationItem.title = @"Add";
}

-(void) ReloadTableData
{
    [self getTotal];
    [ProspectTableData removeAllObjects];
    ProspectTableData=[modelProspectProfile getProspectProfile];
    [self getMobileNo];
    [self.myTableView reloadData];
    
    [self.myTableView reloadData];
}

-(void) FinishEdit
{
    isFiltered = FALSE;
	totalView = 20;
    [self ReloadTableData];
    _EditProspect = Nil;
	[self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:1];
    
}

-(void) FinishInsert
{
    isFiltered = FALSE;
	totalView = 20;
    [self ReloadTableData];
    _ProspectViewController = nil;
	[self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:1];
}



- (void)selectDataForEdit:(NSString *)indexNo{
    ProspectProfile* pp;
    ProspectTableData = [modelProspectProfile searchProspectProfileByID:[indexNo intValue]];
    pp = [ProspectTableData objectAtIndex:0];
    EditProspect* zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProspect"];
    zzz.pp = pp;
    
    if (_EditProspect == Nil) {
        self.EditProspect = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProspect"];
        _EditProspect.delegate = self;
    }
    _EditProspect.pp = pp;
    @try {
        [self.navigationController pushViewController:_EditProspect animated:YES];
        _EditProspect.navigationItem.title = @"Edit";
    } @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    } @finally {
    }
    pp = Nil, zzz = Nil;

}

- (void) SortBySelected:(NSMutableArray *)SortBySelected {
     
    idTypeLabel.highlighted= false;
    groupLabel.highlighted = false;
    
    if (SortBySelected.count > 0) {
        _outletOrder.enabled = true;
        _outletOrder.selectedSegmentIndex = 0;
    }
    else {
        _outletOrder.enabled = false;
        _outletOrder.selected = false;
        _outletOrder.selectedSegmentIndex = -1;
    }
    
    for (NSString *zzz in SortBySelected ) {
      if ([zzz isEqualToString:@"Name"]) {
            idTypeLabel.highlightedTextColor = [UIColor blueColor];
            idTypeLabel.highlighted = TRUE;
        }
        
        if ([zzz isEqualToString:@"Group"]) {
            groupLabel.highlightedTextColor = [UIColor blueColor];
            groupLabel.highlighted = TRUE;
        }
    }
}


- (IBAction)segOrderBy:(id)sender
{
    if (_outletOrder.selectedSegmentIndex == 0) {
        OrderBy = @"ASC";
    }
    else {
        OrderBy = @"DESC";
    }
}

- (IBAction)btnSortBy:(UIButton *)sender
{
    /*if (_SortBy == nil) {
        self.SortBy = [[ClientProfileListingSortBy alloc] initWithStyle:UITableViewStylePlain];
        _SortBy.delegate = self;
        self.Popover = [[UIPopoverController alloc] initWithContentViewController:_SortBy];
    }
    [self.Popover setPopoverContentSize:CGSizeMake(200, 300)];
    [self.Popover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
    NSString* sortedBy=sender.titleLabel.text;
    if (sender==_btnSortFullName){
        sortedBy=@"ProspectName";
    }
    else if (sender==_btnSortDOB){
        sortedBy=@"ProspectDOB";
    }
    else if (sender==_btnSortBranchName){
        sortedBy=@"BranchName";
    }
    else if (sender==_btnSortDateCreated){
        sortedBy=@"DateCreated";
    }
    else if (sender==_btnSortDateModified){
        sortedBy=@"DateModified";
    }
    
    ProspectTableData=[modelProspectProfile searchProspectProfileByName:nametxt.text BranchName:_txtBranchName.text DOB:outletDOB.titleLabel.text Order:sortedBy Method:sortMethod ID:txtIDNumber.text];
    [self getMobileNo];
    TotalData = ProspectTableData.count;
    [self.myTableView reloadData];
    
    if ([sortMethod isEqualToString:@"ASC"]){
        sortMethod=@"DESC";
    }
    else{
        sortMethod=@"ASC";
    }
}

- (IBAction)searchPressed:(id)sender
{
   
    [self resignFirstResponder];
    [self.view endEditing:YES];
    NSString *querySQL = Nil;
    
    sqlite3_stmt *statement;
    
    NSString *trim_group = [btnGroup.titleLabel.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
    
    if(nametxt.text.length ==0 && txtIDTypeNo.text.length ==0 &&  [trim_group isEqualToString:@"- SELECT -"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Kriteria pencarian diperlukan . Silahkan memasukkan salah satu kriteria." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        alert = nil;
    }
    else
    {
        /*if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
            querySQL = @"SELECT * FROM prospect_profile";
			
			if (![txtIDTypeNo.text isEqualToString:@""] && ![nametxt.text isEqualToString:@""] && (![trim_group isEqualToString:@""] && ![trim_group isEqualToString:@"- SELECT -"])) {
				trim_group = [self getGroupID:trim_group];
                querySQL = [querySQL stringByAppendingFormat:@" WHERE ProspectName like \"%%%@%%\" and (IDTypeNo like \"%%%@%%\" OR OtherIDTypeNo like \"%%%@%%\") and QQFlag = 'false' and ProspectGroup like \"%%%@%%\"",nametxt.text, txtIDTypeNo.text, txtIDTypeNo.text, trim_group];
            }
			else if (![txtIDTypeNo.text isEqualToString:@""] && ![nametxt.text isEqualToString:@""]) {
                querySQL = [querySQL stringByAppendingFormat:@" WHERE ProspectName like \"%%%@%%\" and (IDTypeNo like \"%%%@%%\" OR OtherIDTypeNo like \"%%%@%%\") and QQFlag = 'false'",nametxt.text, txtIDTypeNo.text, txtIDTypeNo.text];
            }
			else  if (![nametxt.text isEqualToString:@""] && (![trim_group isEqualToString:@""] && ![trim_group isEqualToString:@"- SELECT -"])) {
				trim_group = [self getGroupID:trim_group];
				querySQL = [querySQL stringByAppendingFormat:@" WHERE ProspectName like \"%%%@%%\" and QQFlag = 'false' and ProspectGroup like \"%%%@%%\"", nametxt.text, trim_group];
			}
			else  if (![nametxt.text isEqualToString:@""]) {
				querySQL = [querySQL stringByAppendingFormat:@" WHERE ProspectName like \"%%%@%%\" and QQFlag = 'false'", nametxt.text ];
			}
			else if (![txtIDTypeNo.text isEqualToString:@""] && (![trim_group isEqualToString:@""] && ![trim_group isEqualToString:@"- SELECT -"])) {
				trim_group = [self getGroupID:trim_group];
				querySQL = [querySQL stringByAppendingFormat:@" WHERE (IDTypeNo like \"%%%@%%\" OR OtherIDTypeNo like \"%%%@%%\") and QQFlag = 'false' and ProspectGroup like \"%%%@%%\"",txtIDTypeNo.text, txtIDTypeNo.text, trim_group];
			}
			else if (![txtIDTypeNo.text isEqualToString:@""]) {
				querySQL = [querySQL stringByAppendingFormat:@" WHERE (IDTypeNo like \"%%%@%%\" OR OtherIDTypeNo like \"%%%@%%\") and QQFlag = 'false'",txtIDTypeNo.text, txtIDTypeNo.text ];
			}
			else if ((![trim_group isEqualToString:@""] && ![trim_group isEqualToString:@"- SELECT -"])) {
				trim_group = [self getGroupID:trim_group];
				querySQL = [querySQL stringByAppendingFormat:@" WHERE ProspectGroup like \"%%%@%%\" and QQFlag = 'false'", trim_group ];
			}
			else
			{
				querySQL = [querySQL stringByAppendingFormat:@" WHERE QQFlag = 'false'" ];
			}
        
            //SORTING START
            
            NSString *Sorting = [[NSString alloc] init ];
            Sorting = @"";
            NSString *group = @"";
            
            if (idTypeLabel.highlighted == TRUE) {
                Sorting = @"ProspectName";
            }
            
            if (groupLabel.highlighted == TRUE) {
                group = @"ProspectGroup";
            }
     
            if (![Sorting isEqualToString:@""] && ![group isEqualToString:@""]) {
                
                querySQL = [querySQL stringByAppendingFormat:@" order by %@, %@ %@ ", Sorting, group,  OrderBy ];
            }
            else if (![Sorting isEqualToString:@""]) {
            
                querySQL = [querySQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
            }
            else if (![group isEqualToString:@""]) {
                
                querySQL = [querySQL stringByAppendingFormat:@" order by %@ %@ ", group, OrderBy ];
            }
            else
            {
                  querySQL = [querySQL stringByAppendingFormat:@" order by LOWER(ProspectName) ASC"];
            }

            //SORTING END
            
            const char *SelectSI = [querySQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, SelectSI, -1, &statement, NULL) == SQLITE_OK)
            {
                ProspectTableData = [[NSMutableArray alloc] init];
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *ProspectID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    
                    const char *name = (const char*)sqlite3_column_text(statement, 1);
                    NSString *NickName = name == NULL ? nil : [[NSString alloc] initWithUTF8String:name];
                    
                    NSString *ProspectName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    NSString *ProspectDOB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *ProspectGender = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    
                    const char *Address1 = (const char*)sqlite3_column_text(statement, 5);
                    NSString *ResidenceAddress1 = Address1 == NULL ? nil : [[NSString alloc] initWithUTF8String:Address1];
                    
                    const char *Address2 = (const char*)sqlite3_column_text(statement, 6);
                    NSString *ResidenceAddress2 = Address2 == NULL ? nil : [[NSString alloc] initWithUTF8String:Address2];
                    
                    const char *Address3 = (const char*)sqlite3_column_text(statement, 7);
                    NSString *ResidenceAddress3 = Address3 == NULL ? nil : [[NSString alloc] initWithUTF8String:Address3];
                    
                    const char *AddressTown = (const char*)sqlite3_column_text(statement, 8);
                    NSString *ResidenceAddressTown = AddressTown == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressTown];
                    
                    const char *AddressState = (const char*)sqlite3_column_text(statement, 9);
                    NSString *ResidenceAddressState = AddressState == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressState];
                    
                    const char *AddressPostCode = (const char*)sqlite3_column_text(statement, 10);
                    NSString *ResidenceAddressPostCode = AddressPostCode == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressPostCode];
                    
                    const char *AddressCountry = (const char*)sqlite3_column_text(statement, 11);
                    NSString *ResidenceAddressCountry = AddressCountry == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressCountry];
                    
                    const char *AddressOff1 = (const char*)sqlite3_column_text(statement, 12);
                    NSString *OfficeAddress1 = AddressOff1 == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOff1];
                    
                    const char *AddressOff2 = (const char*)sqlite3_column_text(statement, 13);
                    NSString *OfficeAddress2 = AddressOff2 == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOff2];
                    
                    const char *AddressOff3 = (const char*)sqlite3_column_text(statement, 14);
                    NSString *OfficeAddress3 = AddressOff3 == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOff3];
                    
                    const char *AddressOffTown = (const char*)sqlite3_column_text(statement, 15);
                    NSString *OfficeAddressTown = AddressOffTown == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffTown];
                    
                    const char *AddressOffState = (const char*)sqlite3_column_text(statement, 16);
                    NSString *OfficeAddressState = AddressOffState == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffState];
                    
                    const char *AddressOffPostCode = (const char*)sqlite3_column_text(statement, 17);
                    NSString *OfficeAddressPostCode = AddressOffPostCode == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffPostCode];
                    
                    const char *AddressOffCountry = (const char*)sqlite3_column_text(statement, 18);
                    NSString *OfficeAddressCountry = AddressOffCountry == NULL ? nil : [[NSString alloc] initWithUTF8String:AddressOffCountry];
                    
                    const char *Email = (const char*)sqlite3_column_text(statement, 19);
                    NSString *ProspectEmail = Email == NULL ? nil : [[NSString alloc] initWithUTF8String:Email];
                    
                    NSString *ProspectOccupationCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)];
                    
                    const char *Duties = (const char*)sqlite3_column_text(statement, 21);
                    NSString *ExactDuties = Duties == NULL ? nil : [[NSString alloc] initWithUTF8String:Duties];
                    
                    const char *Remark = (const char*)sqlite3_column_text(statement, 22);
                    NSString *ProspectRemark = Remark == NULL ? nil : [[NSString alloc] initWithUTF8String:Remark];
                    //basvi added
                    const char *DateCr = (const char*)sqlite3_column_text(statement, 23);
                    NSString *DateCreated = DateCr == NULL ? nil : [[NSString alloc] initWithUTF8String:DateCr];
                    
                    const char *CrBy = (const char*)sqlite3_column_text(statement, 24);
                    NSString *CreatedBy = CrBy == NULL ? nil : [[NSString alloc] initWithUTF8String:CrBy];
                    
                    const char *DateMod = (const char*)sqlite3_column_text(statement, 25);
                    NSString *DateModified = DateMod == NULL ? nil : [[NSString alloc] initWithUTF8String:DateMod];
                    
                    const char *ModBy = (const char*)sqlite3_column_text(statement, 26);
                    NSString *ModifiedBy = ModBy == NULL ? nil : [[NSString alloc] initWithUTF8String:ModBy];
                    //
                    
                    const char *Group = (const char*)sqlite3_column_text(statement, 27);
                    NSString *ProspectGroup = Group == NULL ? nil : [[NSString alloc] initWithUTF8String:Group];
                        
                    const char *Title = (const char*)sqlite3_column_text(statement, 28);
                    NSString *ProspectTitle = Title == NULL ? nil : [[NSString alloc] initWithUTF8String:Title];
                        
                    const char *typeNo = (const char*)sqlite3_column_text(statement, 29);
                    NSString *IDTypeNo = typeNo == NULL ? nil : [[NSString alloc] initWithUTF8String:typeNo];
                        
                    const char *OtherType = (const char*)sqlite3_column_text(statement, 30);
                    NSString *OtherIDType = OtherType == NULL ? nil : [[NSString alloc] initWithUTF8String:OtherType];
                    if ([OtherIDType isEqualToString:@"(NULL)"] || [OtherIDType isEqualToString:@"(null)"]) {
                        OtherIDType = @"";
                    }
                    
                    const char *OtherTypeNo = (const char*)sqlite3_column_text(statement, 31);
                    NSString *OtherIDTypeNo = OtherTypeNo == NULL ? nil : [[NSString alloc] initWithUTF8String:OtherTypeNo];
                        
                    const char *smok = (const char*)sqlite3_column_text(statement, 32);
                    NSString *Smoker = smok == NULL ? nil : [[NSString alloc] initWithUTF8String:smok];
                        
                    const char *ann = (const char*)sqlite3_column_text(statement, 33);
                    NSString *AnnIncome = ann == NULL ? nil : [[NSString alloc] initWithUTF8String:ann];
                        
                    const char *buss = (const char*)sqlite3_column_text(statement, 34);
                    NSString *BussinessType = buss == NULL ? nil : [[NSString alloc] initWithUTF8String:buss];
                    
                    const char *rac = (const char*)sqlite3_column_text(statement, 35);
                    NSString *Race = rac == NULL ? nil : [[NSString alloc] initWithUTF8String:rac];
                    
                    const char *marstat = (const char*)sqlite3_column_text(statement, 36);
                    NSString *MaritalStatus = marstat == NULL ? nil : [[NSString alloc] initWithUTF8String:marstat];
                    
                    const char *rel = (const char*)sqlite3_column_text(statement, 41);
                    NSString *Religion = rel == NULL ? nil : [[NSString alloc] initWithUTF8String:rel];
                    
                    const char *nat = (const char*)sqlite3_column_text(statement, 38);
                    NSString *Nationality = nat == NULL ? nil : [[NSString alloc] initWithUTF8String:nat];
                    
                    const char *reg = (const char*)sqlite3_column_text(statement, 41);
                    NSString *registrationNo = reg == NULL ? nil : [[NSString alloc] initWithUTF8String:reg];
                    
                    const char *isreg = (const char*)sqlite3_column_text(statement, 40);
                    NSString *registration = isreg == NULL ? nil : [[NSString alloc] initWithUTF8String:isreg];
                    
                    const char *regdate = (const char*)sqlite3_column_text(statement, 42);
                    NSString *registrationDate = regdate == NULL ? nil : [[NSString alloc] initWithUTF8String:regdate];
                    
                    const char *exempted = (const char*)sqlite3_column_text(statement, 43);
                    NSString *regExempted = exempted == NULL ? nil : [[NSString alloc] initWithUTF8String:exempted];

                    const char *isGrouping = (const char*)sqlite3_column_text(statement, 45);
                    NSString *isGroup = isGrouping == NULL ? nil : [[NSString alloc] initWithUTF8String:isGrouping];
                    
                    const char *CountryOfBirth = (const char*)sqlite3_column_text(statement, 46);
                    NSString *COB = CountryOfBirth == NULL ? nil : [[NSString alloc] initWithUTF8String:CountryOfBirth];
                        
                    [ProspectTableData addObject:[[ProspectProfile alloc] initWithName:NickName AndProspectID:ProspectID AndProspectName:ProspectName AndProspecGender:ProspectGender AndResidenceAddress1:ResidenceAddress1 AndResidenceAddress2:ResidenceAddress2 AndResidenceAddress3:ResidenceAddress3 AndResidenceAddressTown:ResidenceAddressTown AndResidenceAddressState:ResidenceAddressState AndResidenceAddressPostCode:ResidenceAddressPostCode AndResidenceAddressCountry:ResidenceAddressCountry AndOfficeAddress1:OfficeAddress1 AndOfficeAddress2:OfficeAddress2 AndOfficeAddress3:OfficeAddress3 AndOfficeAddressTown:OfficeAddressTown AndOfficeAddressState:OfficeAddressState AndOfficeAddressPostCode:OfficeAddressPostCode AndOfficeAddressCountry:OfficeAddressCountry AndProspectEmail:ProspectEmail AndProspectRemark:ProspectRemark AndDateCreated:DateCreated AndDateModified:DateModified AndCreatedBy:CreatedBy AndModifiedBy:ModifiedBy AndProspectOccupationCode:ProspectOccupationCode AndProspectDOB:ProspectDOB AndExactDuties:ExactDuties AndGroup:ProspectGroup AndTitle:ProspectTitle AndIDTypeNo:IDTypeNo AndOtherIDType:OtherIDType AndOtherIDTypeNo:OtherIDTypeNo AndSmoker:Smoker AndAnnIncome:AnnIncome AndBussType:BussinessType AndRace:Race AndMaritalStatus:MaritalStatus AndReligion:Religion AndNationality:Nationality AndRegistrationNo:registrationNo AndRegistration:registration AndRegistrationDate:registrationDate AndRegistrationExempted:regExempted AndProspect_IsGrouping:isGroup AndCountryOfBirth:COB AndNIP:@"" AndBranchCode:@"" AndBranchName:@"" AndKCU:@"" AndReferralSource:@"" AndReferralName:@"" AndIdentitySubmitted:@"" AndIDExpirityDate:@"" AndNPWPNo:@"" AndKanwil:@"" AndHomeVillage:@"" AndHomeDistrict:@"" AndHomeProvince:@"" AndOfficeVillage:@"" AndOfficeDistrict:@"" AndOfficePorvince:@"" AndSourceIncome:@"" AndClientSegmentation:@""]];
                    
                    ProspectID = Nil;
                    NickName = Nil;
                    ProspectName = Nil ;
                    ProspectDOB = Nil  ;
                    ProspectGender = Nil;
                    ResidenceAddress1 = Nil;
                    ResidenceAddress2 = Nil;
                    ResidenceAddress3 = Nil;
                    ResidenceAddressTown = Nil;
                    ResidenceAddressState = Nil;
                    ResidenceAddressPostCode = Nil;
                    ResidenceAddressCountry = Nil;
                    OfficeAddress1 = Nil;
                    OfficeAddress2 = Nil;
                    OfficeAddress3 = Nil;
                    OfficeAddressTown = Nil;
                    OfficeAddressState = Nil;
                    OfficeAddressPostCode = Nil;
                    OfficeAddressCountry = Nil;
                    ProspectEmail = Nil;
                    ProspectOccupationCode = Nil;
                    ExactDuties = Nil;
                    ProspectRemark = Nil, querySQL = Nil;
                    ProspectTitle = Nil, ProspectGroup = Nil, IDTypeNo = Nil, OtherIDType = Nil, OtherIDTypeNo = Nil, Smoker = Nil;
                    
                }
                sqlite3_finalize(statement);
                    
            }
            sqlite3_close(contactDB);
            querySQL = Nil;
        }*/
        [ProspectTableData removeAllObjects];
        [self.myTableView reloadData];
        
        ProspectTableData=[modelProspectProfile searchProspectProfileByName:nametxt.text BranchName:_txtBranchName.text DOB:outletDOB.titleLabel.text Order:@"ProspectName" Method:@"ASC" ID:txtIDNumber.text];
    }
    [self getMobileNo];
    
	TotalData = ProspectTableData.count;
    [self.myTableView reloadData];
    statement = Nil;
    
   if(ProspectTableData.count == 0)
   {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Data Tidak Ditemukan" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       
       [alert show];
       alert = nil;
   }
	


}
-(void)hideKeyboard{
    
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
    
}

- (IBAction)resetPressed:(id)sender
{
    [self hideKeyboard];
    nametxt.text = @"";
    txtIDTypeNo.text = @"";
    txtIDNumber.text = @"";
    _txtBranchName.text = @"";
    [outletDOB setTitle:@"" forState:UIControlStateNormal];
    [outletDOB.titleLabel setText:@""];
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:@""];
    // Set the font to bold from the beginning of the string to the ","
    // Set the attributed string as the buttons' title text
    [outletDOB setAttributedTitle:titleText forState:UIControlStateNormal];
    
    idTypeLabel.highlighted= false;
    [btnGroup setTitle:@"- SELECT -" forState:UIControlStateNormal];
    btnGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	totalView = 20;
    [self ReloadTableData];
	[self performSelector:@selector(loadDataDelayed) withObject:nil afterDelay:2];
}

- (IBAction)editPressed:(id)sender
{
     
    [self resignFirstResponder];
    if ([self.myTableView isEditing]) {
        
        [self.myTableView setEditing:NO animated:TRUE];
        deleteBtn.hidden = true;
        deleteBtn.enabled = false;
        [editBtn setTitle:@"Delete" forState:UIControlStateNormal ];
        
        ItemToBeDeleted = [[NSMutableArray alloc] init];
        indexPaths = [[NSMutableArray alloc] init];
        
        RecDelete = 0;
    }
    else {
        
        [self.myTableView setEditing:YES animated:TRUE];
        deleteBtn.hidden = FALSE;
        //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [editBtn setTitle:@"Cancel" forState:UIControlStateNormal ];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)clearSIData{
    for (UITableViewCell *cell in [self.myTableView visibleCells])
    {
        if (cell.selected == TRUE) {
            NSIndexPath *selectedIndexPath = [self.myTableView indexPathForCell:cell];
            
            ProspectProfile *pp = [ProspectTableData objectAtIndex:selectedIndexPath.row];
            NSMutableArray *usedSI = [[NSMutableArray alloc]initWithArray:[modelSIPOData getSINumberForProspectProfileID:pp.ProspectID]];//
            for (int i=0; i<[usedSI count];i++){
                [modelSIMaster deleteIlustrationMaster:[usedSI objectAtIndex:i]];
                [modelSIPOData deletePOData:[usedSI objectAtIndex:i]];
                [modelSIPremium deletePremium:[usedSI objectAtIndex:i]];
                [modelSIRider deleteRiderData:[usedSI objectAtIndex:i]];
            }
        }
    }
    
}

- (IBAction)deletePressed:(id)sender
{
    BOOL status_delete;
    NSString *clientID;
    NSString *clt;
	sqlite3_stmt *statement;
	BOOL CanDelete = TRUE;
    int RecCount = 0;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];

    for (UITableViewCell *cell in [self.myTableView visibleCells])
    {
        if (cell.selected == TRUE) {
            NSIndexPath *selectedIndexPath = [self.myTableView indexPathForCell:cell];
            
			ProspectProfile *pp = [ProspectTableData objectAtIndex:selectedIndexPath.row];
			clientID = pp.ProspectID;
            if (RecCount == 0) {
                clt = pp.ProspectName;
            }
			
			/*if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK) {
                // For Trad product should check trad_lapayor and not ul_payor table.
                NSString *SQL = [NSString stringWithFormat:@"select * from trad_lapayor as A, clt_profile as B, prospect_profile as C where A.custcode = B.custcode AND B.indexno = c.indexno AND  C.indexNo = '%@' ", pp.ProspectID];
           
				if(sqlite3_prepare_v2(contactDB, [SQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
					if (sqlite3_step(statement) == SQLITE_ROW) {
						CanDelete = FALSE;
					}
					sqlite3_finalize(statement);
				}
                
                //SI EVER SERIES
                SQL = [NSString stringWithFormat:@"select * from UL_LAPayor as A, clt_profile as B, prospect_profile as C where A.custcode = B.custcode AND B.indexno = c.indexno  AND C.indexNo = '%@' ", pp.ProspectID];
                
                
                if(sqlite3_prepare_v2(contactDB, [SQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
					if (sqlite3_step(statement) == SQLITE_ROW) {
						CanDelete = FALSE;
					}
					sqlite3_finalize(statement);
				}
				
                //CFF 
                SQL = [NSString stringWithFormat:@"SELECT *  FROM CFF_Master WHERE ClientProfileID = '%@' ", pp.ProspectID];
                
                if(sqlite3_prepare_v2(contactDB, [SQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
					if (sqlite3_step(statement) == SQLITE_ROW) {
						CanDelete = FALSE;
					}
					sqlite3_finalize(statement);
				}
                
                //eAPP
                SQL = [NSString stringWithFormat:@"SELECT *  FROM eApp_Listing WHERE ClientProfileID = '%@' ", pp.ProspectID];
                
                if(sqlite3_prepare_v2(contactDB, [SQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
					if (sqlite3_step(statement) == SQLITE_ROW) {
						CanDelete = FALSE;
					}
					sqlite3_finalize(statement);
				}
                sqlite3_close(contactDB);
			}*/
            int usedInSI=[modelSIPOData getLADataCount:pp.ProspectID];
            if (usedInSI>0){
                CanDelete = FALSE;
            }
			
			if (CanDelete == FALSE) {
				break;
			}
			else {
				RecCount = RecCount + 1;
				if (RecCount > 1) {
					break;
				}
			}
        }
    }
    
    //CHECK eProposal Status for pending case

    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    [db open];
    NSString *status;
    FMResultSet *results;
    
    results = [db executeQuery:@"SELECT A.Status  from eProposal AS A, eApp_Listing AS B where B.ClientProfileID  = ?  AND B.ProposalNo = A.eProposalNo", clientID];
    
	int ee = 0;
    while ([results next]) {
        status = [results objectForColumnName:@"Status"];
		ee = ee + 1;
    }
    [results close];
    [db close];
    
    if([status isEqualToString:@"2"] || [status isEqualToString:@"3"] || [status isEqualToString:@"6"]) {
		status_delete = TRUE;
    } else {
		status_delete = FALSE;
    }
		
	/*if (CanDelete == FALSE && status_delete == TRUE) {
		NSString *msg = @"There are pending eApp cases for this client. Should you wish to proceed, system will auto delete all the pending eApp cases and you are required to recreate the necessary should you wish to resubmit the case.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert setTag:1002];
		[alert show];

	}
    else if(CanDelete == FALSE && status_delete == FALSE)
    {
        NSString *msg = @"There are existing records created (either SI, CFF or eApp cases) for this client.Should you wish to proceed, system will auto delete all the existing records and you are required to recreate the necessary should you wish to resubmit the case.";
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert setTag:1002];
		[alert show];
    }
    else */if(CanDelete == FALSE)
    {
        NSString *msg = @"Nasabah telah memiliki Ilustrasi/SPAJ, bila ada perubahan data, data Ilustrasi/SPAJ akan terhapus dan perlu dilakukan pengisian Ilustrasi/SPAJ ulang";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert setTag:1002];
        [alert show];
    }
	else {
		NSString *msg;
		if (RecDelete == 1) {
            msg = @"Apakah anda yakin ingin menghapus klien ini ?";//Are you sure want to delete these Clients?";
		}
		else {
			msg = @"Apakah anda yakin ingin menghapus klien ini ?";//Are you sure want to delete these Clients?";
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
		[alert setTag:1001];
		[alert show];
	}
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0) //delete
    {
        if (ItemToBeDeleted.count < 1) {
            return;
        }
        else {
            NSLog(@"itemToBeDeleted:%d", ItemToBeDeleted.count);
        }
        
        NSArray *sorted = [[NSArray alloc] init ];
        sorted = [ItemToBeDeleted sortedArrayUsingComparator:^(id firstObject, id secondObject){
            return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
        }];
        
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
			ProspectProfile *pp;
            NSString *DeleteSQL;
            int value;
            for(int a=0; a<sorted.count; a++) {
                value = [[sorted objectAtIndex:a] intValue] - a;
                
                pp = [ProspectTableData objectAtIndex:value];
                DeleteSQL = [NSString stringWithFormat:@"Delete from prospect_profile where IndexNo = %@", pp.ProspectID];
                NSLog(@"delete sql %@",DeleteSQL);

                const char *Delete_stmt = [DeleteSQL UTF8String];
                if(sqlite3_prepare_v2(contactDB, Delete_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                else {
                    NSLog(@"Error in Delete Statement %s",sqlite3_errmsg(contactDB));
                }
                
                [ProspectTableData removeObjectAtIndex:value];
            }
            sqlite3_close(contactDB);
        }
        
        [ItemToBeDeleted removeAllObjects];
        [indexPaths removeAllObjects];
        deleteBtn.enabled = FALSE;
        //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        
        [self ReloadTableData];
        
        NSString *msg = @"Profil klien berhasil dihapus";//Client Profile has been successfully deleted.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        alert = nil;
        
    }
    
    if (alertView.tag==1002 && buttonIndex == 0)
    {
        [self clearSIData];
        [self delete_prospect_eApp];
        
        NSString *msg = @"Profil klien berhasil dihapus";//Client Profile has been successfully deleted.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        alert = nil;
    }
}

- (void) delete_prospect_eApp
{    
    if (ItemToBeDeleted.count < 1) {
        return;
    }
    else {
        NSLog(@"AitemToBeDeleted:%d", ItemToBeDeleted.count);
    }
    
    NSArray *sorted = [[NSArray alloc] init ];
    sorted = [ItemToBeDeleted sortedArrayUsingComparator:^(id firstObject, id secondObject){
        return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
    }];
    
	NSMutableArray *EProArr = [NSMutableArray array];
	
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    [db open];
    int value;
    for(int a=0; a<sorted.count; a++) {
        value = [[sorted objectAtIndex:a] intValue] - a;
        ProspectProfile *pp = [ProspectTableData objectAtIndex:value];
        
        [db executeUpdate:@"Delete from prospect_profile where IndexNo = ?", pp.ProspectID];
                
        //Get proposal No
        FMResultSet *results;
        NSString *proposal = @"";
        results = [db executeQuery:@"SELECT eProposalNo FROM eProposal_LA_Details where prospectProfileID = ?", pp.ProspectID];
        while ([results next]) {
            proposal = [results objectForColumnName:@"eProposalNo"];
			[EProArr addObject:proposal];
        }
        
		ClearData *ClData =[[ClearData alloc]init];
		
        //Delete eApp_Listing
		if (EProArr.count != 0) {
			for (int d=0; d<= EProArr.count-1; d++) {
				proposal = [EProArr objectAtIndex:d];
				
				[ClData deleteEApp:proposal database:db];
				[ClData deleteOldPdfs:proposal];
			}
		}
			
		Cleanup *DeleteSi =[[Cleanup alloc]init];
		[DeleteSi deleteAllSIUsingCustomerID: pp.ProspectID];
		
		[ClData deleteCFF:pp.ProspectID database:db];
        [ProspectTableData removeObjectAtIndex:value];
        
        [results close];
	
    }
    
    [db close];
    
    [ItemToBeDeleted removeAllObjects];
    [indexPaths removeAllObjects];
    deleteBtn.enabled = FALSE;
    //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    
    [self ReloadTableData];
}

- (IBAction)ActionGroup:(id)sender
{
    _GroupList = nil;
    self.GroupList = [[GroupClass alloc] initWithStyle:UITableViewStylePlain];
    _GroupList.delegate = self;
    self.GroupPopover = [[UIPopoverController alloc] initWithContentViewController:_GroupList];
    
    [self.GroupPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

#pragma mark - memory management

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setIdTypeLabel:nil];
    [self setIdNoLabel:nil];
    [self setClientNameLabel:nil];
    [self setEditBtn:nil];
    [self setDeleteBtn:nil];
    [self setNametxt:nil];
    [self setBtnGroup:nil];
    [self setTxtIDTypeNo:nil];
    [self setGroupLabel:nil];
    [super viewDidUnload];
    FilteredProspectTableData = Nil;
    ProspectTableData = Nil;
}

-(void)Clear
{
	ProspectTableData = Nil;
	FilteredProspectTableData = Nil;
	databasePath = Nil;
}

-(void)selectedGroup:(NSString *)aaGroup
{
    if([aaGroup isEqualToString:@"- SELECT -"])
         btnGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    else
         btnGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnGroup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",aaGroup]forState:UIControlStateNormal];
    [self.GroupPopover dismissPopoverAnimated:YES];
}

-(void)AgreeFlag:(NSString *)agree {
    
}

-(void)CloseFlag:(NSString *)Closeagree {
    
}

@end
