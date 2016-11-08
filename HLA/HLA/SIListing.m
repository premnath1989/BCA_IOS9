//
//  SIListing.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/2/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIListing.h"
#import "ColorHexCode.h"
#import "NewLAViewController.h"
#import "MainScreen.h"
#import "AppDelegate.h"
#import "FSVerticalTabBarController.h"
#import "EverLifeViewController.h"
#import "MasterMenuEApp.h"
#import "MBProgressHUD.h"

#import "ColumnHeaderStyle.h"
#import "UIButton+Property.h"
#import "UIElementsManagement.h"
#import <QuartzCore/QuartzCore.h>

@interface SIListing ()
@property(nonatomic, readwrite) int kPageIndex;
@property(nonatomic, readwrite) int kPageModulo;
@property(nonatomic, readwrite) BOOL isLoading;
@end

@implementation SIListing
@synthesize outletGender;
@synthesize outletEdit;
@synthesize lblSINO, DBDateTo, DBDateFrom,OrderBy;
@synthesize lblDateCreated, SIQQStatus, SIEditStatus,SISignedStatus;
@synthesize lblName;
@synthesize lblPlan;
@synthesize lblBasicSA;
@synthesize lblProposalStats;

@synthesize outletDateFrom;
@synthesize outletDelete;
@synthesize myTableView;
@synthesize outletDone;
@synthesize btnSortBy;
@synthesize outletDateTo;
@synthesize txtSINO,CustomerCode;
@synthesize txtLAName, SINO,FilteredBasicSA,FilteredDateCreated,FilteredName;
@synthesize FilteredSINO,FilteredPlanName,FilteredSIStatus,SIStatus,FilteredCustomerCode;
@synthesize BasicSA,Name,PlanName, DateCreated, TradOrEver, SIVersion, FilteredSIVersion, SIValidStatus, FilteredSIValidStatus, PDFCreator;
@synthesize SortBy = _SortBy;
@synthesize Popover = _Popover;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;

//@synthesize TableHeader;

int DateOption;
int deleteOption; // 101 = SI and eApps, 102 = delete Si only, 103 = combination of 101 + 102

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    modelProspectProfile=[[ModelProspectProfile alloc]init];
    _modelAgentProfile=[[ModelAgentProfile alloc]init];
    _modelSIMaster=[[Model_SI_Master alloc]init];
    _modelSIPremium=[[Model_SI_Premium alloc]init];
    _modelSIPOData=[[ModelSIPOData alloc]init];
    
    sortedBy = @"sim.CreatedDate";
    sortMethod=@"DESC";
    
    [NoIlustrasi setFont:[UIFont fontWithName:@"HelveticaLTStd-UltraComp" size:25]];
    themeColour = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
    fontType = [UIFont fontWithName:@"TreBuchet MS" size:16.0f];
    
	AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	appDel.MhiMessage = Nil;
	appDel = Nil;
    
    //set Button want to add border
    outletDateFrom.property = 1;
    outletDateTo.property = 1;
    
    UIElementsManagement *uiManagement = [[UIElementsManagement alloc]init:self.view themeColour:themeColour font:fontType];
    [uiManagement setupUI];
    
    //set TableView header design
    [self setupTableColumn];
    
    outletDone.hidden = true;
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //[self LoadAllResult];
    
    CGRect tableRect = myTableView.frame;
    myTableView.frame = CGRectMake(tableRect.origin.x, tableRect.origin.y, self.view.frame.size.width-75.0f, tableRect.size.height);
    myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    //[self.view addSubview:myTableView];
    
    
    [self getDataForTable];
    [myTableView reloadData];
    
    ItemToBeDeleted = [[NSMutableArray alloc] init];
    indexPaths = [[NSMutableArray alloc] init];
    
	if ([TradOrEver  isEqualToString:@"TRAD"]) {
        lblBasicSA.numberOfLines = 2;
		lblBasicSA.text = @"Sum Assured/\nBenefit";
	} else {
		lblBasicSA.text = @"Basic Sum Assured";
	}
	
    dirPaths = Nil;
    docsDir = Nil;

    DBDateFrom2 = @"";
    DBDateTo2 = @"";
//    txtSINO.clearButtonMode = UITextFieldViewModeWhileEditing;
//    txtLAName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],
                                                           NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]
                                                           }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)setupTableColumn{
    //we call the table management to design the table
    ColumnHeaderStyle *ilustrasi = [[ColumnHeaderStyle alloc]init:@" No. Ilustrasi" alignment:NSTextAlignmentLeft button:FALSE width:0.15];
    ColumnHeaderStyle *tanggal = [[ColumnHeaderStyle alloc]init:@"Tanggal Dibuat" alignment:NSTextAlignmentCenter button:TRUE width:0.17];
    ColumnHeaderStyle *nama = [[ColumnHeaderStyle alloc]init:@"Nama"
                                                   alignment:NSTextAlignmentLeft button:FALSE width:0.2];
    ColumnHeaderStyle *produk = [[ColumnHeaderStyle alloc]init:@"Produk"
                                                     alignment:NSTextAlignmentLeft button:FALSE width:0.2];
    ColumnHeaderStyle *pertanggungan = [[ColumnHeaderStyle alloc]init:@"Uang Pertanggungan" alignment:NSTextAlignmentCenter button:FALSE width:0.15];
    ColumnHeaderStyle *status = [[ColumnHeaderStyle alloc]init:@"Status Proposal" alignment:NSTextAlignmentCenter button:FALSE width:0.13];
    
    //add it to array
    columnHeadersContent = [NSArray arrayWithObjects:ilustrasi,
                            tanggal, nama, produk, pertanggungan,status,nil];
    tableManagement = [[TableManagement alloc]init:self.view themeColour:themeColour themeFont:fontType];
    TableHeader =[tableManagement TableHeaderSetup:columnHeadersContent
                                         positionY:outletDelete.frame.origin.y+55.0f];
    
    //[self.view addSubview:TableHeader];
}



-(void)hideKeyboard {
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)LoadAllResult {
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
		NSString *SIListingSQL;
		if ([TradOrEver isEqualToString:@"TRAD"]) {
			SIListingSQL = [NSString stringWithFormat:
                            @"select A.Sino, B.createdAT, name, planname, basicSA, F.Status, A.CustCode, B.SIVersion, B.SIStatus, G.ProspectName, G.QQFlag "
							" from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G, eApp_Listing as H "
							" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\" AND E.Sino = A.Sino "
                            " AND H.Status = F.StatusCode AND C.IndexNo = G.IndexNo AND E.eproposalNo = H.proposalNo "
							"union "
							"select A.Sino, B.createdAT, name, planname, basicSA, 'Not Created', A.CustCode, B.SIVersion, B.SIStatus, E.ProspectName, E.QQFlag   from Trad_lapayor as A, "
							"Trad_details as B, clt_profile as C, trad_sys_profile as D, prospect_profile as E  where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode "
							"AND A.Sequence = 1 AND A.ptypeCode = 'LA' AND A.sino not in (select sino from eProposal)  AND C.IndexNo = E.IndexNo "]; 
            
            if ([txtSINO.text length]>0) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
			}
			
            if ([txtLAName.text length]>0) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
			}
			
            if ([DBDateFrom length]>0) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", DBDateFrom ];
			}
			
            if ([DBDateTo length]>0) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", DBDateTo ];
			}
			
			NSString *Sorting = [[NSString alloc] init ];
			Sorting = @"";
            if (lblBasicSA.highlighted == TRUE) {
				Sorting = @"basicSA";
			}
			
			if (lblDateCreated.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @" createdAt";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",createdAt"];
				}
			}
			
			if (lblName.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"name";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",name"];
				}
			}
			
			if (lblPlan.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"planname";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",planname"];
				}
			}
			
			if (lblSINO.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"A.SINO";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",A.SINO"];
				}
			}
			
			if ([Sorting isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by createdAt Desc" ];
			} else {
                if( [OrderBy length]==0 ) {
                    [self segOrderBy:nil];
                }
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
			}
		} else { //for Ever
			SIListingSQL = [NSString stringWithFormat:@"select A.Sino, B.DateCreated, name, planname, basicSA, F.Status, A.CustCode, B.SIVersion, B.SIStatus, G.ProspectName, G.QQFlag "
							" from UL_lapayor as A, UL_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G  "
							" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND A.ptypeCode = \"LA\" "
							"AND E.Sino = B.Sino AND E.Status = F.StatusCode AND C.IndexNo = G.IndexNo "
							"Union "
							"select A.Sino, B.DateCreated, name, planname, basicSA, 'Not Created', A.CustCode, B.SIVersion, B.SIStatus, E.ProspectName, E.QQFlag from UL_lapayor as A, UL_details as B, "
							"clt_profile as C, trad_sys_profile as D, prospect_profile as E  where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND  "
							"A.ptypeCode = 'LA' AND A.sino not in (select sino from eProposal) AND C.IndexNo = E.IndexNo "];
			
			if (![txtSINO.text isEqualToString:@""]) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
			}
			
			if (![txtLAName.text isEqualToString:@""]) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
			}
			
			if ( ![DBDateFrom isEqualToString:@""]) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated > \"%@ 00:00:00\" ", DBDateFrom ];
			}
			
			if ( ![DBDateTo isEqualToString:@""] ) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated < \"%@ 23:59:59\" ", DBDateTo ];
			}
			
			NSString *Sorting = [[NSString alloc] init ];
			Sorting = @"";
			if (lblBasicSA.highlighted == TRUE) {
				Sorting = @"basicSA";
			}
			
			if (lblDateCreated.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @" DateCreated";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",DateCreated"];
				}
			}
			
			if (lblName.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"name";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",name"];
				}
			}
			
			if (lblPlan.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"planname";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",planname"];
				}
			}
			
			if (lblSINO.highlighted == TRUE) {
				if ([Sorting isEqualToString:@""]) {
					Sorting = @"A.SINO";
				} else {
					Sorting = [Sorting stringByAppendingFormat:@",A.SINO"];
				}
			}
			
			if ([Sorting isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by B.DateCreated Desc" ];
			} else {
                if( [OrderBy length]==0 ) {
                    [self segOrderBy:nil];
                }
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
			}			
		}
		
        if(sqlite3_prepare_v2(contactDB, [SIListingSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (SINO.count  == 0) {
                SINO = [[NSMutableArray alloc] init ];
                DateCreated = [[NSMutableArray alloc] init ];
                Name = [[NSMutableArray alloc] init ];
                PlanName = [[NSMutableArray alloc] init ];
                BasicSA = [[NSMutableArray alloc] init ];
                SIStatus = [[NSMutableArray alloc] init ];
                CustomerCode = [[NSMutableArray alloc] init ];
                SIVersion = [[NSMutableArray alloc] init ];
                SIValidStatus = [[NSMutableArray alloc] init ];
                SIQQStatus  = [[NSMutableArray alloc] init ];
            } else {
                [SINO removeAllObjects];
                [DateCreated removeAllObjects];
                [Name removeAllObjects];
                [PlanName removeAllObjects];
                [BasicSA removeAllObjects];
                [SIStatus removeAllObjects];
                [CustomerCode removeAllObjects];
                [SIVersion removeAllObjects];
                [SIValidStatus removeAllObjects];
                [SIQQStatus removeAllObjects];
            }
            
            NSString *SINumber;
            NSString *ItemDateCreated;
            NSString *ItemName;
            NSString *ItemPlanName;
            NSString *ItemBasicSA;
            NSString *ItemQQFlag;
            NSString *ItemStatus;
            NSString *ItemCustomerCode;
            NSString *ItemSIVersion;
            NSString *ItemSIValidStatus;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                SINumber = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                ItemDateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                ItemPlanName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                ItemBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                ItemStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                ItemCustomerCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                ItemQQFlag = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
				if (sqlite3_column_text(statement, 7) == NULL) {
					ItemSIVersion = @"";
				} else {
					ItemSIVersion = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
				}
				
				if (sqlite3_column_text(statement, 8) == NULL) {
					ItemSIValidStatus = @"";
				} else {
					ItemSIValidStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
				}                
				
                [SINO addObject:SINumber];
                [DateCreated addObject:ItemDateCreated ];
                [Name addObject:ItemName ];
                [SIQQStatus addObject:ItemQQFlag];
                [PlanName addObject:ItemPlanName ];
                [BasicSA addObject:ItemBasicSA ];
                [SIStatus addObject:ItemStatus];
                [CustomerCode addObject:ItemCustomerCode];
				[SIVersion addObject:ItemSIVersion];
                [SIValidStatus addObject:ItemSIValidStatus];
                
                SINumber = Nil;
                ItemDateCreated = Nil;
                ItemName = Nil;
                ItemQQFlag = Nil;
                ItemPlanName = Nil;
                ItemBasicSA = Nil;
                ItemStatus = Nil;
                ItemCustomerCode = Nil;
				ItemSIVersion = Nil;
                ItemSIValidStatus = Nil;
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
        
        SIListingSQL = Nil;
        
        self.kPageModulo = SINO.count;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    
    if (SINO.count == 0) {
       // [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        outletEdit.enabled = FALSE;
    } else {
      //  [outletEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
        outletEdit.enabled = TRUE;
    }
    
    statement = Nil;
    dbpath = Nil;
    
    [myTableView reloadData];
}

- (void)viewDidUnload
{
    [self setTxtSINO:nil];
    [self setTxtLAName:nil];
    [self setOutletDateFrom:nil];
    [self setOutletDateTo:nil];
    [self setBtnSortBy:nil];
    [self setOutletDelete:nil];
    [self setMyTableView:nil];
    
    [self setOutletDone:nil];
    [self setLblSINO:nil];
    [self setLblDateCreated:nil];
    [self setLblName:nil];
    [self setLblPlan:nil];
    [self setLblBasicSA:nil];
    [self setOutletDateFrom:nil];
    [self setOutletGender:nil];
    [self setOutletEdit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    databasePath = Nil, OrderBy = Nil, lblBasicSA = Nil, lblDateCreated = Nil, lblName = Nil, lblPlan = Nil, lblSINO = Nil;
    contactDB = Nil;
    _SortBy = Nil;
    _Popover = Nil;
    _SIDate = Nil;
    _SIDatePopover = Nil;
    
    ItemToBeDeleted = Nil;
    indexPaths = Nil;
    SINO = Nil;
    DateCreated = Nil;
    Name = Nil;
    PlanName= Nil;
    BasicSA= Nil;
    SIStatus= Nil;
    CustomerCode= Nil;
    SIVersion = Nil;
	SIValidStatus = Nil;
	
    FilteredSINO= Nil;
    FilteredDateCreated= Nil;
    FilteredName= Nil;
    FilteredPlanName= Nil;
    FilteredBasicSA= Nil;
    FilteredSIStatus= Nil;
    FilteredCustomerCode= Nil;
	FilteredSIVersion = Nil;
	FilteredSIValidStatus = Nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;   
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
    if (isFilter == false) {
        return SINO.count;
    } else {
        return FilteredSINO.count;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    SIListingTableViewCell *cell = (SIListingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SIListingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row < [SINO count]){
        [cell.buttonShowIlustrasi setTag:indexPath.row];
        [cell.buttonShowIlustrasi addTarget:self action:@selector(showIlustrasi:) forControlEvents:UIControlEventTouchUpInside];
        [cell.buttonShowIlustrasi setHidden:YES];
        [cell.imageShowIlustrasi setHidden:YES];
        
        [cell.labelIlusrationNo setText:[SINO objectAtIndex:indexPath.row]];
        [cell.labelIlustrationDate setText:[DateCreated objectAtIndex:indexPath.row]];
        [cell.labelPOName setText:[Name objectAtIndex:indexPath.row]];
        [cell.labelProduct setText:[PlanName objectAtIndex:indexPath.row]];
        [cell.labelSumAssured setText:[BasicSA objectAtIndex:indexPath.row]];
        //[cell.labelSumAssured setText:@"0"];
        
        NSString *status = @"";
        if([[SIQQStatus objectAtIndex:indexPath.row] caseInsensitiveCompare:@"0"] == NSOrderedSame){
            status = @"";
        }else{
            status = @"Q";
        }
        
        if([[SIEditStatus objectAtIndex:indexPath.row] caseInsensitiveCompare:@"0"] == NSOrderedSame){
            if ([status length]>0){
                status = [NSString stringWithFormat:@"%@ S",status];
            }
            else{
                status = [NSString stringWithFormat:@"%@ S",status];
            }
        }
        
        if([[SISignedStatus objectAtIndex:indexPath.row] caseInsensitiveCompare:@"0"] == NSOrderedSame){
            status = [NSString stringWithFormat:@"%@ TT",status];
            [cell.buttonShowIlustrasi setHidden:NO];
            [cell.imageShowIlustrasi setHidden:NO];
        }
        [cell.labelStatus setText:status];
    }
    /*UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [[cell.contentView viewWithTag:1001] removeFromSuperview ];
    [[cell.contentView viewWithTag:1002] removeFromSuperview ];
    [[cell.contentView viewWithTag:1003] removeFromSuperview ];
    [[cell.contentView viewWithTag:1004] removeFromSuperview ];
    [[cell.contentView viewWithTag:1005] removeFromSuperview ];
    [[cell.contentView viewWithTag:1006] removeFromSuperview ];
    [[cell.contentView viewWithTag:1007] removeFromSuperview ];
    [[cell.contentView viewWithTag:1008] removeFromSuperview ];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
 
    
    if (isFilter == false) {
        //NSArray *arrayOfData = [NSArray arrayWithObjects:SINO, DateCreated, Name, PlanName, SIValidStatus,BasicSA,SIVersion,nil];
        NSArray *arrayOfData = [NSArray arrayWithObjects:SINO, DateCreated, Name, PlanName, SIStatus,@"0",SIVersion,nil];
        [tableManagement TableRowInsert:arrayOfData index:indexPath.row table:cell];
//        CGRect frame=CGRectMake(headerOriginX,0, DataRowTableWidth, 50);
//        UILabel *label1=[[UILabel alloc]init];            
//        label1.frame=frame;
//        label1.text= [SINO objectAtIndex:indexPath.row];
//        label1.tag = 1001;
//        label1.textAlignment = NSTextAlignmentCenter;
//        [cell.contentView addSubview:label1];
//        headerOriginX += DataRowTableWidth + 10.0f;
//        
//        CGRect frame2=CGRectMake(headerOriginX+5.0f,0, DataRowTableWidth, 50);
//        UILabel *label2=[[UILabel alloc]init];
//        label2.frame=frame2;
//        label2.text= [DateCreated objectAtIndex:indexPath.row];
//        label2.textAlignment = NSTextAlignmentCenter;    
//        label2.tag = 1002;
//        [cell.contentView addSubview:label2];
//        headerOriginX += DataRowTableWidth + 10.0f;
//        
//        CGRect frame3=CGRectMake(headerOriginX+7.0f,0, DataRowTableWidth, 50);
//        UILabel *label3=[[UILabel alloc]init];            
//        label3.frame=frame3;
//        label3.text= [Name objectAtIndex:indexPath.row];
//        label3.tag = 1003;
//        [cell.contentView addSubview:label3];
//        headerOriginX += DataRowTableWidth;
//        
//        CGRect frame4=CGRectMake(headerOriginX,0, DataRowTableWidth, 50);
//        UILabel *label4=[[UILabel alloc]init];
//        label4.frame=frame4;
//        label4.text= [PlanName objectAtIndex:indexPath.row];
//        label4.textAlignment = NSTextAlignmentCenter;    
//        label4.tag = 1004;
//        [cell.contentView addSubview:label4];
//        headerOriginX += DataRowTableWidth + 10.0f;
//        
//        CGRect frame5=CGRectMake(headerOriginX,0, DataRowTableWidth, 50);
//        UILabel *label5=[[UILabel alloc]init];            
//        label5.frame=frame5;
//		label5.text = [NSString stringWithFormat:@"%.2f\n%@", [[BasicSA objectAtIndex:indexPath.row] doubleValue ], [SIValidStatus objectAtIndex:indexPath.row]];
//        label5.tag = 1005;
//        label5.textAlignment = NSTextAlignmentCenter;
//		label5.numberOfLines = 2;
//        [cell.contentView addSubview:label5];
//        headerOriginX += DataRowTableWidth + 10.0f;
//        
//        CGRect frame6=CGRectMake(headerOriginX,0, DataRowTableWidth, 50);
//        UILabel *label6=[[UILabel alloc]init];	
//        label6.frame=frame6;
//		label6.text = [NSString stringWithFormat:@"%@\n%@", [SIStatus objectAtIndex:indexPath.row], [SIVersion objectAtIndex:indexPath.row]];
//        label6.textAlignment = NSTextAlignmentCenter;
//        label6.tag = 1006;
//		label6.numberOfLines = 2;
//        [cell.contentView addSubview:label6];
//        headerOriginX += DataRowTableWidth + 10.0f;
//        
//        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
//        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
//        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
//        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
//        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
//        label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    } else {
        CGRect frame=CGRectMake(0,0, 170, 50);
        UILabel *label1=[[UILabel alloc]init];            
        label1.frame=frame;
        label1.text= [FilteredSINO objectAtIndex:indexPath.row];
        label1.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label1];
        label1.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame2=CGRectMake(170,0, 150, 50);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        label2.text= [FilteredDateCreated objectAtIndex:indexPath.row];
        label2.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label2];
        
        CGRect frame3=CGRectMake(320,0, 180, 50);
        UILabel *label3=[[UILabel alloc]init];            
        label3.frame=frame3;
        label3.text= [FilteredName objectAtIndex:indexPath.row];
        label3.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label3];
        
        CGRect frame4=CGRectMake(500,0, 150, 50);
        UILabel *label4=[[UILabel alloc]init];
        label4.frame=frame4;
        label4.text= [FilteredPlanName objectAtIndex:indexPath.row];
        label4.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label4];
        
        CGRect frame5=CGRectMake(650,0, 150, 50);
        UILabel *label5=[[UILabel alloc]init];            
        label5.frame=frame5;
        label5.text= [FilteredBasicSA objectAtIndex:indexPath.row];
        label5.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label5];
        
        CGRect frame6=CGRectMake(800,0, 150, 50);
        UILabel *label6=[[UILabel alloc]init];
        label6.frame=frame6;
        label6.text= [FilteredSIStatus objectAtIndex:indexPath.row];
        label6.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label6];
		
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
        } else {
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
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    CustomColor = Nil;*/
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        for (UITableViewCell *cell in [myTableView visibleCells]) {
            if (cell.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }            
        }
        
        if (!gotRowSelected) {
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDelete.enabled = FALSE;
        } else {
            [outletDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletDelete.enabled = TRUE;
        }
        
        NSString *item = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted addObject:item];
        [indexPaths addObject:indexPath];
        item = Nil;
        
    } else {
        AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
		main.tradOrEver = TradOrEver;
        main.IndexTab = appdlg.NewSIIndex ;
        main.requestSINo = [SINO objectAtIndex:indexPath.row];
		[self presentViewController:main animated:NO completion:nil];
		
		appdlg = Nil;
        main = Nil;
    }
    
}

-(void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF *)htmlToPDF {
}

-(void)HTMLtoPDFDidFail:(NDHTMLtoPDF *)htmlToPDF {
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        for (UITableViewCell *cell in [myTableView visibleCells]) {
            if (cell.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }            
        }
        
        if (!gotRowSelected) {
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDelete.enabled = FALSE;
        } else {
            [outletDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletDelete.enabled = TRUE;
        }
        
        NSString *item = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted removeObject:item];
        [indexPaths removeObject:indexPath];
        
        item = Nil;
    }
}

- (IBAction)btnDateFrom:(id)sender {
    DateOption = 1;
    if (_SIDate == Nil) {
        UIStoryboard *clientProfileStoryboard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        self.SIDate = [clientProfileStoryboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnDateTo:(id)sender {
    DateOption = 2;
    if (_SIDate == Nil) {
        UIStoryboard *clientProfileStoryboard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        self.SIDate = [clientProfileStoryboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)segOrderBy:(id)sender {
    if (outletGender.selectedSegmentIndex == 0) {
        OrderBy = @"ASC";
    } else {
        OrderBy = @"DESC";
    }
}
#pragma mark - delegate
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - void added by faiz
-(void)getDataForTable{
    NSDictionary *dictIlustrationData;
    
    if (([txtSINO.text length]>0)||([txtLAName.text length]>0)||([DBDateFrom2 length]>0)||([DBDateTo2 length]>0)){
        

        //dictIlustrationData=[[NSDictionary alloc]initWithDictionary:[_modelSIMaster searchSIListingByName:txtSINO.text POName:txtLAName.text Order:sortedBy Method:sortMethod DateFrom:dateFrom DateTo:dateTo]];
        dictIlustrationData=[[NSDictionary alloc]initWithDictionary:[_modelSIMaster searchSIListingByName:txtSINO.text POName:txtLAName.text Order:sortedBy Method:sortMethod DateFrom:DBDateFrom2 DateTo:DBDateTo2]];
    }
    else{
        dictIlustrationData=[[NSDictionary alloc]initWithDictionary:[_modelSIMaster getIlustrationata:sortedBy Method:sortMethod]];
    }
    
    
    SINO = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"SINO"]];
    DateCreated = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"CreatedDate"]];
    Name = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"PO_Name"]];
    PlanName = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"ProductName"]];
    SIStatus = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"ProposalStatus"]];
    SIVersion = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"SI_Version"]];
    BasicSA = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"Sum_Assured"]];
    SIQQStatus =[[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"QuickQuote"]];
    SIEditStatus = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"EnableEditing"]];
    SISignedStatus = [[NSMutableArray alloc] initWithArray:[dictIlustrationData valueForKey:@"IllustrationSigned"]];
    
    NSLog(@"SINO %@",dictIlustrationData);
}

#pragma mark - Button Action

- (IBAction)btnSearch:(id)sender {
    [self resignFirstResponder];
    [self.view endEditing:YES];
    ItemToBeDeleted = [[NSMutableArray alloc] init];
    indexPaths = [[NSMutableArray alloc] init];
    
    //isFilter = true;
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm;ss"];
    NSDate* d = [df dateFromString:DBDateFrom];
    NSDate* d2 = [df dateFromString:DBDateTo];
    
    if ([ d compare:d2] == NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:@"Date To cannot be greater than Date From" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
        [alert show ];
    } else {
        /*NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
			NSString *SIListingSQL;
			if ([TradOrEver isEqualToString:@"TRAD"]) {
                SIListingSQL = [NSString stringWithFormat:@"select A.Sino, B.CreatedAT, C.name, planname, basicSA, F.status, A.CustCode, G.ProspectName "
                                " from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G, eApp_Listing as H   "
                                " where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\"  "
                                "AND H.Status = F.statusCode AND E.sino = A.sino AND C.IndexNo = G.IndexNo AND E.eproposalNo = H.proposalNo   " ];
			} else {
				SIListingSQL = [NSString stringWithFormat:@"select A.Sino, B.DateCreated, C.name, planname, basicSA, F.status, A.CustCode, G.ProspectName "
								" from UL_lapayor as A, UL_details as B, clt_profile as C, trad_sys_profile as D, eProposal as E, eProposal_Status as F, prospect_profile as G"
								" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND A.ptypeCode = \"LA\" "
								"AND F.statusCode = E.Status AND E.sino = A.sino AND C.IndexNo = G.IndexNo  " ];
			}
            
            if (![txtSINO.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
                
            }
            
            if (![txtLAName.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
                
            }
            
            if ( ![DBDateFrom isEqualToString:@""]) {
				if ([TradOrEver isEqualToString:@"TRAD"]) {
                    SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND E.createdAT > \"%@ 00:00:00\" ", DBDateFrom ];
				} else {
                    SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated > \"%@ 00:00:00\" ", DBDateFrom ];
				}
            }
            
            if ( ![DBDateTo isEqualToString:@""] ) {
				if ([TradOrEver isEqualToString:@"TRAD"]) {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND E.createdAt < \"%@ 23:59:59\" ", DBDateTo ];
				} else {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated < \"%@ 23:59:59\" ", DBDateTo ];
				}
            }
            
			if ([TradOrEver isEqualToString:@"TRAD"]) {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@"Union select A.Sino, CreatedAT, name, planname, basicSA, 'Not Created', A.CustCode, E.ProspectName  "
								" from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D, prospect_profile as E   "
								" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\" AND C.IndexNo = E.IndexNo AND A.sino not in (select sino from eProposal) "];
			} else {
				SIListingSQL = [SIListingSQL stringByAppendingFormat:@"Union select A.Sino, B.DateCreated, name, planname, basicSA, 'Not Created' , A.CustCode, E.ProspectName "
								" from UL_lapayor as A, UL_details as B, clt_profile as C, trad_sys_profile as D, prospect_profile as E "
								" where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Seq = 1 AND A.ptypeCode = \"LA\" AND C.IndexNo = E.IndexNo " ];
			}
            
            if (![txtSINO.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
                
            }
            
            if (![txtLAName.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
                
            }
            
            if ( ![DBDateFrom isEqualToString:@""]) {
				if ([TradOrEver isEqualToString:@"TRAD"]) {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT > \"%@ 00:00:00\" ", DBDateFrom2 ];
				} else {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated > \"%@ 00:00:00\" ", DBDateFrom ];
				}
            }
            
            if ( ![DBDateTo isEqualToString:@""] ) {
				if ([TradOrEver isEqualToString:@"TRAD"]) {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt < \"%@ 23:59:59\" ", DBDateTo2 ];
				} else {
					SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND B.DateCreated < \"%@ 23:59:59\" ", DBDateTo ];
				}
            }
            
            NSMutableString *Sorting = [[NSMutableString alloc] init];
            
            if (lblBasicSA.highlighted == TRUE) {
                [Sorting appendString: @"basicSA"];
            }
            
            if (lblDateCreated.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
					if ([TradOrEver isEqualToString:@"TRAD"]) {
                        [Sorting appendString:@"createdAt"];
					}
					else{
						[Sorting appendString:@"DateCreated"];
					}
                } else {
					if ([TradOrEver isEqualToString:@"TRAD"]) {
						[Sorting appendString:@",createdAt"];
					}
					else{
						[Sorting appendString:@",DateCreated"];
					}
                }
            }
            
            if (lblName.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    [Sorting appendString:@"name"];
                }
                else {
                    [Sorting appendString:@",name"];
                }
            }
            
            if (lblPlan.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    [Sorting appendString:@"planname"];
                }
                else {
                    [Sorting appendString:@",planname"];
                }
            }
            
            if (lblSINO.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    [Sorting appendString:@"A.SINO" ];
                }
                else {
                    [Sorting appendString:@",A.SINO"];
                }
            }
            
            if (![Sorting isEqualToString:@""]) {
                if( [OrderBy length]==0 ) {
                    [self segOrderBy:nil];
                }
                
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
            }
            
            const char *SelectSI = [SIListingSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, SelectSI, -1, &statement, NULL) == SQLITE_OK) {
                SINO = nil;
                DateCreated = nil;
                Name = nil;
                PlanName = nil;
                BasicSA = nil;
                SIStatus = nil;
                CustomerCode = nil;
                
                SINO = [[NSMutableArray alloc] init ];
                DateCreated = [[NSMutableArray alloc] init ];
                Name = [[NSMutableArray alloc] init ];
                PlanName = [[NSMutableArray alloc] init ];
                BasicSA = [[NSMutableArray alloc] init ];
                SIStatus = [[NSMutableArray alloc] init ];
                CustomerCode = [[NSMutableArray alloc] init ];
                
                while (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *SINumber = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    NSString *ItemDateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    NSString *ItemPlanName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *ItemBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    NSString *ItemStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    NSString *ItemCustomerCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    
                    [SINO addObject:SINumber];
                    [DateCreated addObject:ItemDateCreated ];
                    [Name addObject:ItemName ];
                    [PlanName addObject:ItemPlanName ];
                    [BasicSA addObject:ItemBasicSA ];
                    [SIStatus addObject:ItemStatus];
                    [CustomerCode addObject:ItemCustomerCode];
                    
                    SINumber = Nil;
                    ItemDateCreated = Nil;
                    ItemName = Nil;
                    ItemPlanName = Nil;
                    ItemBasicSA = Nil;
                    ItemStatus = Nil;
                    ItemCustomerCode = Nil;
                }
                sqlite3_finalize(statement);
                SIListingSQL = Nil;
                Sorting = Nil;
            }            
            sqlite3_close(contactDB);
        }
        
        dirPaths = Nil;
        docsDir = Nil;
        statement = Nil;
        dbpath = Nil;
        statement = Nil;
        
        //isFilter = TRUE;
        if (SINO.count == 0) {
            outletEdit.enabled = FALSE;
            [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        } else {
            [outletEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletEdit.enabled = TRUE;
        }*/
        [self getDataForTable];
        [myTableView reloadData];
    }
    
    df = Nil;
    d = Nil;
    d2 = Nil;
}

- (IBAction)btnEdit:(id)sender {
    if ([self.myTableView isEditing]) {
        [self.myTableView setEditing:NO animated:TRUE];
        outletDelete.hidden = true;
        [outletEdit setTitle:@"Delete" forState:UIControlStateNormal ];
        
        if (SINO.count == 0) {
            outletEdit.enabled = FALSE;
          //  [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        } else {
            [outletEdit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletEdit.enabled = TRUE;
        }
    } else {
        [self.myTableView setEditing:YES animated:TRUE]; 
        outletDelete.hidden = FALSE;
        [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [outletEdit setTitle:@"Cancel" forState:UIControlStateNormal ];
    }
}

#pragma mark - Others

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            if (ItemToBeDeleted.count < 1) {
                return;
            }
            
            /*NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docsDir = [dirPaths objectAtIndex:0];
            databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
            
            sqlite3_stmt *statement;
            sqlite3_stmt *statement2;
            sqlite3_stmt *statement3;
            const char *dbpath = [databasePath UTF8String];
            NSArray *sorted = [[NSArray alloc] init ];
            
            sorted = [ItemToBeDeleted sortedArrayUsingComparator:^(id firstObject, id secondObject){
                return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
            }];
            
            if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
                int value;
                NSString *DeleteLAPayorSQL;
                NSString *DeleteCltProfileSQL;
                NSString *query;
                NSString *DeleteTradDetailsSQL;
                MasterMenuEApp *rrr;
                for(int a=0; a<sorted.count; a++){
                    value = [[sorted objectAtIndex:a] intValue] - a;
                    if (isFilter == false) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" trad_lapayor where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
						} else {
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" UL_lapayor where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
						}
                        
                    } else {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" trad_lapayor where custcode = \"%@\" ", [FilteredCustomerCode objectAtIndex:value]];
						} else {
							DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
												" UL_lapayor where custcode = \"%@\" ", [FilteredCustomerCode objectAtIndex:value]];
						}
                    }
                    
                    if(sqlite3_prepare_v2(contactDB, [DeleteLAPayorSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        sqlite3_step(statement);
                        sqlite3_finalize(statement);
                    }
                    
                    if (isFilter == FALSE) {
                        DeleteCltProfileSQL = [NSString stringWithFormat:@"Delete from clt_Profile where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
                    } else {
                        DeleteCltProfileSQL = [NSString stringWithFormat:@"Delete from clt_Profile where custcode = \"%@\" ", [FilteredCustomerCode objectAtIndex:value]];
                    }
                    
                    if(sqlite3_prepare_v2(contactDB, [DeleteCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        sqlite3_step(statement2);
                        sqlite3_finalize(statement2);
                    }
                    
					if (isFilter == FALSE) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_LApayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Sequence = '2') ", [SINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Seq = '2' )", [SINO objectAtIndex:value]];
						}
					} else {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Sequence = '2') ", [FilteredSINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Seq = '2') ", [FilteredSINO objectAtIndex:value]];
						}
					}
					
					if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        sqlite3_step(statement2);
                        sqlite3_finalize(statement2);
                    }
                    
					if (isFilter == FALSE) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_LApayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [SINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [SINO objectAtIndex:value]];
						}
					} else {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from Trad_lapayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [FilteredSINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from clt_profile where custcode = (Select custcode from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'PY') ", [FilteredSINO objectAtIndex:value]];
						}
					}
					
					if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        sqlite3_step(statement2);
                        sqlite3_finalize(statement2);
                    }
                    
					if (isFilter == FALSE) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from Trad_LApayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Sequence = '2' ", [SINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Seq = '2'", [SINO objectAtIndex:value]];
						}
					} else {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from Trad_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Sequence = '2' ", [FilteredSINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from  UL_lapayor where SINO = \"%@\" AND PTypeCode = 'LA' AND Seq = '2' ", [FilteredSINO objectAtIndex:value]];
						}
					}
					
					if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        sqlite3_step(statement2);
                        sqlite3_finalize(statement2);
                    }
                    
					if (isFilter == FALSE) {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from Trad_LApayor where SINO = \"%@\" AND PTypeCode = 'PY' ", [SINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'PY' ", [SINO objectAtIndex:value]];
						}
					} else {
						if ([TradOrEver isEqualToString:@"TRAD"]) {
							query = [NSString stringWithFormat:@"Delete from Trad_lapayor where SINO = \"%@\" AND PTypeCode = 'PY' ", [FilteredSINO objectAtIndex:value]];
						} else {
							query = [NSString stringWithFormat:@"Delete from UL_lapayor where SINO = \"%@\" AND PTypeCode = 'PY' ", [FilteredSINO objectAtIndex:value]];
						}
					}
					
					if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        sqlite3_step(statement2);
                        sqlite3_finalize(statement2);
                    }
                    
                    rrr = [[MasterMenuEApp alloc] init];
                    if (isFilter == FALSE) {
                        DeleteTradDetailsSQL = [NSString stringWithFormat:@"Delete from "
                                                " Trad_Details where SINo = \"%@\" ", [SINO objectAtIndex:value]];
                        if (deleteOption == 101) {
                            [rrr deleteEAppCase:[SINO objectAtIndex:value]];
                        } else if (deleteOption == 103) {
                            if ([[SIStatus objectAtIndex:value] isEqualToString:@"Created"] || [[SIStatus objectAtIndex:value] isEqualToString:@"Confirmed"] ) {
                                [rrr deleteEAppCase:[SINO objectAtIndex:value]];
                            }
                        }
                    } else {
                        DeleteTradDetailsSQL = [NSString stringWithFormat:@"Delete from "
                                                " Trad_Details where SINo = \"%@\" ", [FilteredSINO objectAtIndex:value]];
                        if (deleteOption == 101) {
                            [rrr deleteEAppCase:[FilteredSINO objectAtIndex:value]];
                        } else if (deleteOption == 103) {
                            if ([[SIStatus objectAtIndex:value] isEqualToString:@"Created"] || [[SIStatus objectAtIndex:value] isEqualToString:@"Confirmed"] ) {
                                [rrr deleteEAppCase:[FilteredSINO objectAtIndex:value]];
                            }                            
                        }
                    }
                    
                    if (sqlite3_prepare_v2(contactDB, [DeleteTradDetailsSQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                        sqlite3_step(statement3);
                        sqlite3_finalize(statement3);
                    }
                    
                    if (isFilter == FALSE) {
                        [SINO removeObjectAtIndex:value];
                        [DateCreated removeObjectAtIndex:value];
                        [Name removeObjectAtIndex:value];
                        [PlanName removeObjectAtIndex:value];
                        [BasicSA removeObjectAtIndex:value];
                        [SIStatus removeObjectAtIndex:value];
                        [CustomerCode removeObjectAtIndex:value];
                    } else {
                        [FilteredSINO removeObjectAtIndex:value];
                        [FilteredDateCreated removeObjectAtIndex:value];
                        [FilteredName removeObjectAtIndex:value];
                        [FilteredPlanName removeObjectAtIndex:value];
                        [FilteredBasicSA removeObjectAtIndex:value];
                        [FilteredSIStatus removeObjectAtIndex:value];
                        [FilteredCustomerCode removeObjectAtIndex:value];
                    }
                    
                    DeleteLAPayorSQL = Nil;
                    DeleteCltProfileSQL = Nil;
                    DeleteTradDetailsSQL = Nil;
                    rrr = Nil;
                }
                sqlite3_close(contactDB);
            }
            
            [myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            [self.myTableView reloadData];
            if(SINO.count == 0){
                outletDelete.hidden = TRUE;
                outletEdit.hidden = FALSE;
                [outletEdit setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [outletEdit setTitle:@"Delete" forState:UIControlStateNormal];
            }
            
            //action performed after deletion success
            outletDelete.enabled = FALSE;
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            ItemToBeDeleted = [[NSMutableArray alloc] init];
            indexPaths = [[NSMutableArray alloc] init];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"SI has been successfully deleted" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
            [alert show];
            
            dirPaths = Nil;
            docsDir = Nil;
            statement = Nil;
            statement2 = Nil;
            statement3 = Nil;
            dbpath = Nil;
            sorted = Nil;*/

            //delete from SIMaster
            //delete from SIPOData
            //delete from SIBasicPlan
            NSArray *sorted = [[NSArray alloc] init ];
            sorted = [ItemToBeDeleted sortedArrayUsingComparator:^(id firstObject, id secondObject){
                return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
            }];

            for(int a=0; a<sorted.count; a++){
                //value = [[sorted objectAtIndex:a] intValue] - a;
                int index = [[sorted objectAtIndex:a] intValue];
                [_modelSIPremium deletePremium:[SINO objectAtIndex:index]];
                [_modelSIPOData deletePOData:[SINO objectAtIndex:index]];
                [_modelSIMaster deleteIlustrationMaster:[SINO objectAtIndex:index]];
                [ItemToBeDeleted removeObject:[sorted objectAtIndex:a]];
            }
            
            //[myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self getDataForTable];
            [myTableView reloadData];
        }
    }    
}

- (IBAction)btnDelete:(id)sender {
    int RecCount = 0;
    NSString *FirstSINo;
    bool bCreated = FALSE, bConfirmed = FALSE, bSubmitted = FALSE, bReceived = FALSE, bFailed = FALSE, bNotCreated = FALSE;
    NSIndexPath *selectedIndexPath;
    for (UITableViewCell *cell in [myTableView visibleCells]) {
        if (cell.selected  == TRUE) {
            selectedIndexPath =  [myTableView indexPathForCell:cell];
            if (RecCount == 0) {
                FirstSINo = [SINO objectAtIndex:selectedIndexPath.row];
            }
            
            RecCount = RecCount + 1;
            
            if (RecCount > 1) {
                break;
            }
            selectedIndexPath = Nil;
        }
    }
    
    for (UITableViewCell *cell in [myTableView visibleCells]) {
        if (cell.selected  == TRUE) {
            selectedIndexPath =  [myTableView indexPathForCell:cell];
            if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Created"]){
                bCreated = TRUE;
            } else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Confirmed"]){
                bConfirmed = TRUE;
            } else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Submitted"]){
                bSubmitted = TRUE;
            } else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Received"]){
                bReceived = TRUE;
            } else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Failed"]){
                bFailed = TRUE;
            } else if([[SIStatus objectAtIndex:selectedIndexPath.row] isEqualToString:@"Not Created"]){
                bNotCreated = TRUE;
            }
        }
    }
    
	if (ItemToBeDeleted.count == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
														message:@"Please select at least one record to delete" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
		[alert show ];
		return;
	}
    
    if ((bCreated == TRUE || bConfirmed == TRUE) && bSubmitted == FALSE && bReceived == FALSE && bFailed == FALSE && bNotCreated == FALSE  ) {
        NSString *deleteMsg = [NSString stringWithFormat: @"There are pending eApp cases created for this client. Should you wish to proceed, system should auto delete all the "
                               " related pending eApp cases and you are required to recreate the necessary should you wish to resubmit the case. "];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@" ",nil)
                              message: deleteMsg
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
        alert.tag = 1; // delete eApps record and Si record
        deleteOption = 101;
        [alert show];
    } else if ((bCreated == FALSE && bConfirmed == FALSE) && (bSubmitted == TRUE || bReceived == TRUE || bFailed == TRUE || bNotCreated == TRUE)  ) {
        NSString *deleteMsg = [NSString stringWithFormat: @"Apakah anda yakin ingin menghapus SI ini ?"];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@" ",nil)
                              message: deleteMsg
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
        alert.tag = 1; // delete SI only
        deleteOption = 102;
        [alert show];
    } else {
        NSString *deleteMsg = [NSString stringWithFormat: @"There are pending eApp cases created for this client. Should you wish to proceed, system should auto delete all the "
                               " related pending eApp cases and you are required to recreate the necessary should you wish to resubmit the case. "];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@" ",nil)
                              message: deleteMsg
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                              otherButtonTitles: NSLocalizedString(@"No",nil), nil];
        alert.tag = 1; // combination of deleting SI only and SI plus eApps record
        deleteOption = 103;
        [alert show];
    }
    FirstSINo = Nil;
    
}

- (IBAction)btnDone:(id)sender {
    
    outletDone.hidden = true;
}

- (void) SortBySelected:(NSMutableArray *)SortBySelected {
    lblSINO.highlighted = false;
    lblDateCreated.highlighted= false;
    lblName.highlighted= false;
    lblPlan.highlighted = false;
    lblBasicSA.highlighted = false;
    
    if (SortBySelected.count > 0) {
        outletGender.enabled = true;
        outletGender.selectedSegmentIndex = 0;
        
    } else {
        outletGender.enabled = false;
        outletGender.selected = false;
        outletGender.selectedSegmentIndex = -1;
    }
    
    for (NSString *text in SortBySelected ) {
        if ([text isEqualToString:@"SI NO"]) {
            lblSINO.highlightedTextColor = [UIColor blueColor];
            lblSINO.highlighted = TRUE;
            
        } else if ([text isEqualToString:@"Plan Name"]) {
            lblPlan.highlightedTextColor = [UIColor blueColor];
            lblPlan.highlighted = TRUE;
            
        } else if ([text isEqualToString:@"Name"]) {
            lblName.highlightedTextColor = [UIColor blueColor];
            lblName.highlighted = TRUE;
            
        } else if ([text isEqualToString:@"Date Created"]) {
            lblDateCreated.highlightedTextColor = [UIColor blueColor];
            lblDateCreated.highlighted = TRUE;
            
        } else if ([text isEqualToString:@"Sum Assured/ Benefit"]) {
            lblBasicSA.highlightedTextColor = [UIColor blueColor];
            lblBasicSA.highlighted = TRUE;
            
        }
    }
}

- (IBAction)btnSortBy:(UIButton *)sender {
    /*if (_SortBy == nil) {
        self.SortBy = [[siListingSortBy alloc] initWithStyle:UITableViewStylePlain];
        _SortBy.delegate = self;
        self.Popover = [[UIPopoverController alloc] initWithContentViewController:_SortBy];               
    }
    [self.Popover setPopoverContentSize:CGSizeMake(300, 300)];
    [self.Popover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    */
    sortedBy=sender.titleLabel.text;
    if (sender==_btnSortFullName){
        sortedBy=@"po.PO_Name";
    }
    else if (sender==_btnSortSINO){
        sortedBy=@"sim.SINO";
    }
    else if (sender==_btnSortCreatedDate){
        sortedBy=@"sim.CreatedDate";
    }
    else if (sender==_btnSortProduct){
        sortedBy=@"po.ProductName";
    }
    else if (sender==_btnSortSumAssured){
        sortedBy=@"sip.Sum_Assured";
    }
    
    if ([sortMethod isEqualToString:@"ASC"]){
        sortMethod=@"DESC";
    }
    else{
        sortMethod=@"ASC";
    }
    [self getDataForTable];
    [myTableView reloadData];
}

-(void)DateSelected:(NSString *)strDate:(NSString *)dbDate{
    if (DateOption == 1) {
        [outletDateFrom setTitle:strDate forState:UIControlStateNormal];
        DBDateFrom = strDate;
        DBDateFrom2 = [self convertToDateFormat:strDate];
    } else {
        [outletDateTo setTitle:strDate forState:UIControlStateNormal];
        DBDateTo = strDate;
        DBDateTo2 = [self convertToDateFormat:strDate];
    }
}

-(NSString*)convertToDateFormat:(NSString*)strDate
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *date = [df dateFromString: strDate]; 
    
    df = [[[NSDateFormatter alloc] init] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSString *convertedString = [df stringFromDate:date];
    
    return convertedString;
}

-(void)CloseWindow {
    [self.SIDatePopover dismissPopoverAnimated:YES];
}

-(void)showIlustrasi:(UIButton *)sender{
    NSDictionary *_dictionaryPOForInsert=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:[SINO objectAtIndex:sender.tag]]];
    
    NSDictionary *_dictionaryForAgentProfile=[[NSDictionary alloc]initWithDictionary:[_modelAgentProfile getAgentData]];
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
    NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[_dictionaryPOForInsert valueForKey:@"ProductName"],[_dictionaryPOForInsert valueForKey:@"SINO"]];
    //NSString *file = [[NSBundle mainBundle] pathForResource:@"Brochure_ProdukBCALIfeKeluargaku_21012016" ofType:@"pdf"];
    
    //compose the subject and body

    NSString *sexPO;
    if ([[_dictionaryPOForInsert valueForKey:@"PO_Gender"] isEqualToString:@"MALE"]){
        sexPO=@"Bapak";
    }
    else{
        sexPO=@"Ibu";
    }
    
    NSString* AgentName = [_dictionaryForAgentProfile valueForKey:@"AgentName"];
    NSString *mailComposerText=[NSString stringWithFormat:@"Kepada %@ %@ <br/><br/>Calon Nasabah BCA Life,Terima kasih atas kesempatan yang diberikan kepada Financial Advisor kami %@ untuk menjelaskan mengenai produk perlindungan asuransi yang %@ butuhkan. <br/><br/>Terlampir kami kirimkan Ilustrasi yang sudah dibuat oleh Financial Advisor kami. Silahkan buka dan pelajari apakah sudah sesuai dengan kebutuhan jaminan masa depan %@. <br/><br/>Untuk informasi produk asuransi lainnya, silahkan mengunjungi website kami di www.bcalife.co.id atau menghubungi customer service HALO BCA 1500888.<br/><br/>Terima Kasih<br/>PT Asuransi Jiwa BCA",sexPO,[_dictionaryPOForInsert valueForKey:@"PO_Name"],AgentName,sexPO,sexPO];
    
    ProspectProfile* pp;
    NSMutableArray *TempProspectTableData = [[NSMutableArray alloc]initWithArray:[modelProspectProfile searchProspectProfileByID:[[_dictionaryPOForInsert valueForKey:@"PO_ClientID"] intValue]]];
    NSString* idTypeNo;
    if ([TempProspectTableData count]>0){
        pp = [TempProspectTableData objectAtIndex:0];
        NSString* idType = pp.OtherIDType;
        idTypeNo = pp.OtherIDTypeNo;
        if (![idType isEqualToString:@"1"]){
            idTypeNo = @"-";
        }
    }
    else{
        idTypeNo = @"-";
    }
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPathOutput password:nil];
    
    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    readerViewController.delegate = self;
    readerViewController.bodyEmail = mailComposerText;
    readerViewController.subjectEmail = [NSString stringWithFormat:@"BCALife Illustration %@",[_dictionaryPOForInsert valueForKey:@"SINO"]];
    readerViewController.POName = [_dictionaryPOForInsert valueForKey:@"PO_Name"];
    readerViewController.AgentName = [_dictionaryForAgentProfile valueForKey:@"AgentName"];
    readerViewController.AgentKTP = [_dictionaryForAgentProfile valueForKey:@"AgentCode"];
    BOOL illustrationSigned = [_modelSIMaster isSignedIlustration:[_dictionaryPOForInsert valueForKey:@"SINO"]];
    readerViewController.illustrationSignature = illustrationSigned;
    readerViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:readerViewController animated:YES completion:Nil];
}

- (IBAction)btnReset:(id)sender {
    txtSINO.text = @"";
    txtLAName.text = @"";
    [outletDateFrom setTitle:@"--Please Select--" forState:UIControlStateNormal];
    [outletDateTo setTitle:@"--Please Select--" forState:UIControlStateNormal];
    DBDateFrom = @"";
    DBDateTo = @"";
    DBDateFrom2 = @"";
    DBDateTo2 = @"";
    /*lblBasicSA.highlighted = FALSE;
    lblDateCreated.highlighted = FALSE;
    lblName.highlighted = FALSE;
    lblPlan.highlighted = FALSE;
    lblSINO.highlighted = FALSE;
    [self resignFirstResponder];
    outletGender.selectedSegmentIndex = -1;
    outletGender.enabled = FALSE;
    _SortBy = Nil;
    isFilter = FALSE;
    ItemToBeDeleted = [[NSMutableArray alloc] init ];
	indexPaths = [[NSMutableArray alloc] init ];*/
	
    //[self LoadAllResult];
    [self getDataForTable];
    [myTableView reloadData];
    
}

- (IBAction)btnAddNewSI:(id)sender {
    AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    main.IndexTab = appdlg.NewSIIndex;
	main.tradOrEver = TradOrEver;
    [self presentViewController:main animated:NO completion:nil];
    
    appdlg = Nil;
    main = Nil;
}

-(void)Refresh{
   /* [SINO removeAllObjects];
    [DateCreated removeAllObjects];
    [Name removeAllObjects];
    [PlanName removeAllObjects];
    [BasicSA removeAllObjects];
    [SIStatus removeAllObjects];
    [CustomerCode removeAllObjects];
    [SIVersion removeAllObjects];
    [SIValidStatus removeAllObjects];

    [self LoadAllResult];
    [myTableView reloadData];*/
    [self btnReset:nil];
}

-(void)SIListingClear{
	myTableView = Nil;
	SINO =Nil;
	DateCreated=Nil;
	Name =Nil;
	PlanName=Nil;
	SIStatus=Nil;
	CustomerCode=Nil;
	BasicSA =Nil;
	FilteredSINO =Nil;
	FilteredDateCreated=Nil;
	FilteredName=Nil;
	FilteredPlanName=Nil;
	FilteredBasicSA=Nil;
	FilteredSIStatus=Nil;
	FilteredCustomerCode=Nil;
	DBDateFrom = Nil, DBDateTo = Nil, OrderBy = Nil, _SIDate = Nil, _SIDatePopover = Nil, _SortBy = Nil;
	ItemToBeDeleted = Nil, indexPaths = Nil;
	lblBasicSA = Nil, lblDateCreated = Nil, lblName = Nil, lblPlan = Nil, lblSINO = Nil;
	outletDateFrom = Nil, outletDateTo = Nil, outletDelete = Nil, outletDone = Nil, outletEdit = Nil;
	outletGender = Nil;
}


#pragma UIScroll View Method::

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isLoading = NO;
}

#pragma UserDefined Method for generating data which are show in Table :::
-(void)loadDataDelayed {    
    //[self LoadAllResult];
}

@end