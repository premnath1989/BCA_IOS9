//
//  NewLAViewController.m
//  MPOS
//
//  Created by shawal sapuan on 7/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "NewLAViewController.h"
#import "PayorViewController.h"
#import "SecondLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "AppDelegate.h"
#import "SIMenuViewController.h"
#import "MainScreen.h"
#import "ColorHexCode.h"
#import "MaineApp.h"
#import "eAppMenu.h"
#import "Constants.h"
#import "TabValidation.h"
#import "UIView+viewRecursion.h"
#import "LoginDBManagement.h"

@interface NewLAViewController (){
    NSString *ilustrationProductCode;
    int clientProfileID;
    NSNumber *numberIntInternalStaff;
}

@end

@implementation NewLAViewController
@synthesize myScrollView;
@synthesize SecondLAController = _SecondLAController;
@synthesize LANameField;
@synthesize sexSegment;
@synthesize smokerSegment;
@synthesize LAAgeField;
@synthesize LAOccLoadingField,Hubungan;
@synthesize LACPAField;
@synthesize LAPAField,btnToEAPP;
@synthesize btnCommDate,btnEnabled,btnProspect,QuickQuoteBool;
@synthesize statusLabel,EAPPorSI;
@synthesize sex,smoker,age,ANB,DOB,jobDesc,SINo,CustCode;
@synthesize occDesc,occCode,occLoading,payorSINo,occCPA_PA;
@synthesize popOverController,requestSINo,clientName,occuCode,occuDesc,CustCode2,payorCustCode;
@synthesize dataInsert,commDate,occuClass,IndexNo,laBH;
@synthesize ProspectList=_ProspectList;
@synthesize NamePP,DOBPP,GenderPP,OccpCodePP,occPA;
@synthesize getSINo,dataInsert2,btnDOB,btnOccp;
@synthesize getHL,getHLTerm,getPolicyTerm,getSumAssured,getTempHL,getTempHLTerm,MOP,cashDividend,advanceYearlyIncome,yearlyIncome,NamaProduk;
@synthesize termCover,planCode,arrExistRiderCode,arrExistPlanChoice;
@synthesize prospectPopover = _prospectPopover;
@synthesize idPayor,idProfile,idProfile2,lastIdPayor,lastIdProfile,planChoose,ridCode,atcRidCode,atcPlanChoice, outletDone;
@synthesize delegate = _delegate;
@synthesize basicSINo,requestCommDate,requestIndexNo,requestLastIDPay,requestLastIDProf,requestSex,requestSmoker, strPA_CPA,payorAge;
@synthesize LADate = _LADate;
@synthesize datePopover = _datePopover;
@synthesize planList = _planList;
@synthesize planPopover = _planPopover;
@synthesize dobPopover = _dobPopover;
@synthesize OccupationList = _OccupationList;
@synthesize OccupationListPopover = _OccupationListPopover;
@synthesize siObj,requesteProposalStatus;
@synthesize planName;
@synthesize  SINOBCA,TanggalIllustrasi;

@synthesize LAHbgTertanggung;
@synthesize LAProductName,Relationship;
@synthesize quickQuoteFlag;
@synthesize navigationBar;

id temp;
id dobtemp;
id dobtanngal;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self saveBasicPlan];
    
    outletDone.enabled=TRUE;
    btnProspect.enabled = NO;
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] init];
//    [newAttributes setObject:[UIFont systemFontOfSize:17] forKey:UITextAttributeFont];
//    [self.navigationBar setTitleTextAttributes:newAttributes];

    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],
                                                           NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]
                                                           }];
    
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    themeColour = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];
     _planList.delegate = self;
    [self setupUIElementDefaultSetting];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [TanggalIllustrasi setTitle:dateString forState:UIControlStateNormal];
    
    TanggalIllustrasi.enabled = NO;

    
//    NSString*test;
//    NSString*test1;
//    
//    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsPath2 = [paths2 objectAtIndex:0];
//    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"BCA_Rates.sqlite"];
//    
//    
//    FMDatabase *database = [FMDatabase databaseWithPath:path2];
//    [database open];
//    FMResultSet *results;
//    results = [database executeQuery:@"select BasicCode,Male from BasicPremiumRate"];
//    
//    FMDatabase *database1 = [FMDatabase databaseWithPath:path2];
//    if (![database open]) {
//        NSLog(@"Could not open db.");
//    }
//    
//    while([results next])
//        
//    {
//        test  = [results stringForColumn:@"BasicCode"];
//        test1  = [results stringForColumn:@"Male"];
//    }
    [self loadDataFromList];
    [_delegate setQuickQuoteValue:[quickQuoteFlag isOn]];
}

- (void) checkEditingMode {
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:[dictPOData valueForKey:@"SINO"]];
    NSLog(@" Edit Mode %@ : %@", EditMode, [dictPOData valueForKey:@"SINO"]);
    //disable all text fields
    if([EditMode caseInsensitiveCompare:@"0"] == NSOrderedSame){
        for(UIView *v in [self.view allSubViews])
        {
            if([v isKindOfClass:[UITextField class]])
            {
                ((UITextField*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UIButton class]])
            {
                ((UIButton*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UISegmentedControl class]])
            {
                ((UISegmentedControl*)v).userInteractionEnabled=NO;
            }else if([v isKindOfClass:[UISwitch class]])
            {
                ((UISwitch*)v).userInteractionEnabled=NO;
            }
        }
    }else{
        for(UIView *v in [self.view allSubViews])
        {
            if([v isKindOfClass:[UITextField class]])
            {
                ((UITextField*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UIButton class]])
            {
                ((UIButton*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UISegmentedControl class]])
            {
                ((UISegmentedControl*)v).userInteractionEnabled=YES;
            }else if([v isKindOfClass:[UISwitch class]])
            {
                ((UISwitch*)v).userInteractionEnabled=YES;
            }
        }
    }
}


- (void) setupUIElementDefaultSetting{
    [self setUIElementsDelegate];
    [self setUIelementsAction];
    [self setUIElementsEditable];
    [self setupUIElementsColor];
}

- (void)setUIElementsDelegate{
    LAProductName.delegate = self;
    LANameField.delegate = self;
    LAHbgTertanggung.delegate = self;
}

- (void)setUIelementsAction{
   // [quickQuoteFlag addTarget:self action:@selector(changeUIElementsEditable:) forControlEvents:UIControlEventValueChanged];
}

- (void)changeUIElementsEditable:(id)sender {
   // [self setUIElementsEditable];
    
    
    
    
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   // return [quickQuoteFlag isOn];
//}

- (void)setUIElementsEditable{
//    btnDOB.enabled = [quickQuoteFlag isOn];
//    sexSegment.enabled = [quickQuoteFlag isOn];
//    btnOccp.enabled = [quickQuoteFlag isOn];
    //TanggalIllustrasi.enabled = [quickQuoteFlag isOn];
    
}

- (IBAction)InternalStaffFunc:(UISwitch *)sender{

}



- (IBAction)QuickQuoteFunc:(UISwitch *)sender
{
    _SecondLAController =[self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
    if([sender isOn])
    {
        [btnDOB setTitle:@"--Please Select--" forState:UIControlStateNormal];
        [sexSegment setSelectedSegmentIndex:-1];
        [btnOccp setTitle:@"--Please Select--" forState:UIControlStateNormal];
        LAAgeField.enabled = FALSE;
        LAAgeField.text =@"";
        LANameField.text =@"";
        LANameField.enabled = YES;
        btnDOB.enabled = YES;
        sexSegment.enabled = YES;
        btnOccp.enabled = YES;
        btnProspect.enabled = NO;
        [_labelQuickQuote setTextColor:themeColour];
        //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        //[prefs setObject:@"Yes" forKey:@"keyToLookupString"];
        
        //[_SecondLAController testing:@"Enable"];
        
        /*added by faiz*/
        [_delegate setQuickQuoteValue:YES];
    }
    else
    {
        [btnDOB setTitle:@"--Please Select--" forState:UIControlStateNormal];
        [sexSegment setSelectedSegmentIndex:-1];
        [btnOccp setTitle:@"--Please Select--" forState:UIControlStateNormal];
        LAAgeField.enabled = FALSE;
        LAAgeField.text =@"";
        LANameField.text =@"";
        LANameField.enabled = NO;
        btnDOB.enabled = NO;
        sexSegment.enabled = NO;
        btnOccp.enabled = NO;
        btnProspect.enabled = YES;
        [_labelQuickQuote setTextColor:[UIColor lightGrayColor]];
        //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        //[prefs setObject:@"No" forKey:@"keyToLookupString"];
        //[_SecondLAController testing:@"Disable"];
        /*added by faiz*/
        [_delegate setQuickQuoteValue:NO];
    }
}

- (void) setupUIElementsColor
{
    _ProdukBtn.layer.borderColor = [themeColour CGColor];
    _ProdukBtn.layer.borderWidth = 1.0f;

    LAAgeField.layer.borderColor = [themeColour CGColor];
    LAAgeField.layer.borderWidth = 1.0f;

    LANameField.layer.borderColor = [themeColour CGColor];
    LANameField.layer.borderWidth = 1.0f;
    
    _SINumberBCA.layer.borderColor = [themeColour CGColor];
    _SINumberBCA.layer.borderWidth = 1.0f;
    
    LAHbgTertanggung.layer.borderColor = [themeColour CGColor];
    LAHbgTertanggung.layer.borderWidth = 1.0f;
    
    LAProductName.layer.borderColor = [themeColour CGColor];
    LAProductName.layer.borderWidth = 1.0f;
    
    btnDOB.layer.borderColor = [themeColour CGColor];
    btnDOB.layer.borderWidth = 1.0f;
    
    TanggalIllustrasi.layer.borderColor = [themeColour CGColor];
    TanggalIllustrasi.layer.borderWidth = 1.0f;
    
    _BtnHubungan.layer.borderColor = [themeColour CGColor];
    _BtnHubungan.layer.borderWidth = 1.0f;

    btnOccp.layer.borderColor = [themeColour CGColor];
    btnOccp.layer.borderWidth = 1.0f;
    
    //this button must always be enabled
    btnCommDate.layer.borderColor = [themeColour CGColor];
    btnCommDate.layer.borderWidth = 1.0f;
}

-(void)processLifeAssured
{
    if ([requesteProposalStatus isEqualToString:@"Failed"] ||
        [requesteProposalStatus isEqualToString:@"Confirmed"] || [requesteProposalStatus isEqualToString:@"Submitted"] ||
        [requesteProposalStatus isEqualToString:@"Received"] || [EAPPorSI isEqualToString:@"eAPP"] || [requesteProposalStatus isEqualToString:@"Created_View"] ||
        [requesteProposalStatus isEqualToString:@"Created"]) {
        Editable = NO;
    } else {
        Editable = YES;
    }
    
    [self cleanDatabase];
    smoker = @"N";
    DiffClient = NO; //initialized to NO, as to allow riders to be added, else riders wouldn't be able to be added in every new SI.
    savedIndexNo = -1; //initialized to -1, for debugging and to prevent it from going to the different condition for setting DiffClient
    
//    planChoose = NULL;
//    LANameField.enabled = NO;
//    sexSegment.enabled = NO;
//    LAAgeField.enabled = NO;
//    LAOccLoadingField.enabled = NO;
//    LACPAField.enabled = NO;
//    LAPAField.enabled = NO;
//    btnOccp.enabled = NO;
//    btnDOB.enabled = NO;
//    useExist = NO;
//    AgeChanged = NO;
//    JobChanged = NO;
//    QQProspect = NO;
//    self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
//    [LANameField setDelegate:self];
//    [LAAgeField setDelegate:self];
//    [LAOccLoadingField setDelegate:self];
//    [LACPAField setDelegate:self];
//    [LAPAField setDelegate:self];
    
    getSINo = [self.requestSINo description];
    
    if (getSINo.length != 0) {
        appDelegate.isSIExist = YES;
        outletDone.enabled = TRUE;
        
        [self checkingExisting];
        [self checkingExistingSI];
        
        if (basicSINo.length != 0) {
            [self getExistingBasic];
            [self getTerm];
            [self toogleExistingBasic];
        }
        
        if (SINo.length != 0) {
            [self getProspectData];
            
            if ([DOBPP isEqualToString:@"0000"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Client profile is corrupted. Please create a new one."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
            }
            [self getSavedField];
        }
    } else {
        outletDone.enabled = TRUE;
        appDelegate.isSIExist = NO;
    }
    
    if (requestIndexNo != 0) {
        [self tempView];
    }
    
    [self checking2ndLA];
    
    if (CustCode2.length != 0) {
        SecondLAViewController *ccc = [[SecondLAViewController alloc] init ];
        ccc.requestLAIndexNo = requestIndexNo;
        ccc.requestCommDate = commDate;
        ccc.requestSINo = getSINo;
        ccc.LAView = @"1";
        ccc.delegate = (SIMenuViewController *)_delegate;
        
        UIView *iii = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) ];
        [iii addSubview:ccc.view];
        ccc.Change = @"No";
        ccc = Nil;
        iii = Nil;
    }
    
    [self checkingPayor];
    
    btnToEAPP.title = @"";
    btnToEAPP.enabled = FALSE;
    if (payorSINo.length != 0) {
        PayorViewController *ggg = [[PayorViewController alloc] init ];
        ggg.requestLAIndexNo = requestIndexNo;
        ggg.requestLAAge = payorAge;
        ggg.requestCommDate = commDate;
        ggg.requestSINo = getSINo;
        ggg.LAView = @"1";
        ggg.delegate = (SIMenuViewController *)_delegate;
        
        UIView *iii = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) ];
        [iii addSubview:ggg.view];
        
        ggg.Change = @"no";
        ggg = Nil;
        iii = Nil;
    }
    
    if ([[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
        btnProspect.hidden = YES;
        btnToEAPP.title = @"e-Application Checklist";
        btnToEAPP.enabled = TRUE;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard)];
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
    
//    if (Editable == NO) {
//        [self DisableTextField:LANameField ];
//        [self DisableTextField:LAAgeField ];
//        [self DisableTextField:LACPAField ];
//        [self DisableTextField:LAOccLoadingField ];
//        [self DisableTextField:LAPAField ];
//        
//        sexSegment.enabled = FALSE;
//        smokerSegment.enabled = FALSE;
//        btnCommDate.enabled = FALSE;
//        btnEnabled.enabled = FALSE;
//        btnProspect.enabled = FALSE;
//        
//        if([EAPPorSI isEqualToString:@"eAPP"]) {
//            outletDone.enabled = FALSE;
//        }		
//    }
    
    if([EAPPorSI isEqualToString:@"eAPP"]) {
        [self disableFieldsForEapp];
    }
    
}

-(void)cleanDatabase {
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK) {
        NSString *querySQL = @"DELETE FROM Trad_LAPayor WHERE SINo IS NULL OR SINo='(null)'";
        if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {            
            sqlite3_step(statement);
        }
        
        querySQL = @"DELETE FROM Clt_Profile WHERE CustCode IS NULL OR CustCode in ('null', 'LA', 'PY', '2LA')";
        if(sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

- (void)passValidationCheck{
    if(![NamaProduk.titleLabel.text isEqualToString:@"--Please Select--"] && ![LANameField.text isEqualToString:@""] && ![btnDOB.titleLabel.text isEqualToString:@"--Please Select--"] && ![_BtnHubungan.titleLabel.text isEqualToString:@"--Please Select--"] && ![btnOccp.titleLabel.text isEqualToString:@"--Please Select--"] && !sexSegment.selected){
            unsigned flags = NSDayCalendarUnit;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            NSString *selectDate = TanggalIllustrasi.titleLabel.text;
            NSDate *startDate = [dateFormatter dateFromString:selectDate];
            
            NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
            NSDate *endDate = [dateFormatter dateFromString:todayDate];
            NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
            int diffDays = [difference day];
            if (diffDays >180)
            {
               
            }
            else
            {
                [[TabValidation sharedMySingleton] setValidTab1:TRUE];
            }
    }
    
}

-(void) disableFieldsForEapp
{
    [btnDOB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnCommDate setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnOccp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

-(void)hideKeyboard{
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
}

-(void)DisableTextField :(UITextField *)aaTextField{
	aaTextField.backgroundColor = [UIColor lightGrayColor];
	aaTextField.enabled = FALSE;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{    
    self.view.frame = CGRectMake(-5, 0, 778, 1004);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //force the page to load new sino and modify the textfield
    _modelSIPOData = [[ModelSIPOData alloc]init];
    dictPOData=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:requestSINo]];
    if ([dictPOData count]!=0){
        [_SINumberBCA setText:[dictPOData valueForKey:@"SINO"]];
    }
    //test disable the fields
    [self checkEditingMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark - Handle KeyboardShow

//-(void)keyboardDidShow:(NSNotificationCenter *)notification
//{
//    self.myScrollView.frame = CGRectMake(0, 44, 708, 960-264);
//    self.myScrollView.contentSize = CGSizeMake(708, 960);
//    
//    CGRect textFieldRect = [activeField frame];
//    textFieldRect.origin.y += 10;
//    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];    
//}
//
//-(void)keyboardDidHide:(NSNotificationCenter *)notification
//{
//    self.myScrollView.frame = CGRectMake(0, 44, 708, 960);
//}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    activeField = textField;    
//    [activeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//	
//    return YES;
//}

-(void)textFieldDidChange:(UITextField*)textField
{
    appDelegate.isNeedPromptSaveMsg = YES;
}

#pragma mark - ToogleView

//usually for EDD case
-(NSString*) getNonGender:(NSString*)gender
{
    NSString * toReturn = @"";
    
    if( [gender length]>0 ) {
        toReturn = [gender substringToIndex:1];
    }
    
    return toReturn;
}

-(void)getSavedField
{
    BOOL valid = TRUE;
    if (![NamePP isEqualToString:clientName]) {
        valid = FALSE;
    }
    
    NSString * gender1 = [self getNonGender:GenderPP];
    NSString * sex1 = [self getNonGender:sex];
    
    if (![gender1 isEqualToString:sex1]) {
        valid = FALSE;
    }
    
    if (![DOB isEqualToString:DOBPP]) {
        valid = FALSE;
        AgeChanged = YES;
    }
    
    if (![occuCode isEqualToString:OccpCodePP]) {
        valid = FALSE;
        JobChanged = YES;
    }
    
    if (valid) {
        
        LANameField.text = clientName;
        [btnDOB setTitle:DOB forState:UIControlStateNormal];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        if (!EDDCase) {
            if ([sex isEqualToString:@"MALE"] || [sex isEqualToString:@"M"]) {
                sexSegment.selectedSegmentIndex = 0;
            } else if ([sex isEqualToString:@"FEMALE"] || [sex isEqualToString:@"F"]) {
                sexSegment.selectedSegmentIndex = 1;
            }
            
            if ([smoker isEqualToString:@"Y"]) {
                smokerSegment.selectedSegmentIndex = 0;
            } else if ([smoker isEqualToString:@"N"]) {
                smokerSegment.selectedSegmentIndex = 1;
            }
        }
        
        [self getOccLoadExist];
        [btnOccp setTitle:occuDesc forState:UIControlStateNormal];
        LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading]; //here noob
        
        if (occCPA_PA == 0) {
            LACPAField.text = @"D";
        } else {
            LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
            LAPAField.text = @"D";
        } else {
            LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
        }
        
        [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo
                 andCommDate:commDate andSmoker:smoker DiffClient:DiffClient bEDDCase:EDDCase];
    } else {
        LANameField.text = NamePP;
        sex = [GenderPP substringToIndex:1];
        [self setSexToGlobal];
        
        if (!EDDCase) {
            if ([GenderPP isEqualToString:@"MALE"] || [GenderPP isEqualToString:@"M"]) {
                sexSegment.selectedSegmentIndex = 0;
            } else if ([GenderPP isEqualToString:@"FEMALE"] || [GenderPP isEqualToString:@"F"]) {
                sexSegment.selectedSegmentIndex = 1;
            }
            
            if ([smoker isEqualToString:@"Y"]) {
                smokerSegment.selectedSegmentIndex = 0;
            } else if ([smoker isEqualToString:@"N"])  {
                smokerSegment.selectedSegmentIndex = 1;
            }
        }
        
        DOB = DOBPP;
        [self calculateAge];
		
        [btnDOB setTitle:DOB forState:UIControlStateNormal];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        [btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        occuCode = OccpCodePP;
        [self getOccLoadExist];
        [btnOccp setTitle:occuDesc forState:UIControlStateNormal];
        LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading];
        
        if (occCPA_PA == 0) {
            LACPAField.text = @"D";
        } else {
            LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
            LAPAField.text = @"D";
        } else {
            LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
        }
		
        [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo
                 andCommDate:commDate andSmoker:smoker DiffClient:DiffClient bEDDCase:EDDCase];
                   
        if ([OccpCodePP isEqualToString:@"OCC01975"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            //---------
            sex = GenderPP;
            [self setSexToGlobal];
            DOB = DOBPP;
            occuCode = OccpCodePP;
            [self calculateAge];
            [self getOccLoadExist];
            
            LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading];
            
            
            if (occCPA_PA == 0) {
                LACPAField.text = @"D";
            } else {
                LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
            }
            
            if (occPA == 0) {
                LAPAField.text = @"D";
            } else {
                LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
            }
            //-------------------
            
            [self calculateAge];
            if (AgeLess) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be at least 30 days."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert setTag:1005];
                [alert show];
            } else if (AgeExceed189Days) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Expected date of delivery cannot be more than 189 days."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert setTag:1005];
                [alert show];
            } else {
                [self checkExistRider];
                if (AgeChanged) {                        
                    if (arrExistRiderCode.count > 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Rider(s) has been deleted due to business rule."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert setTag:1007];
                        [alert show];
                    }
                    
                    [self updateData:getSINo];
                } else if (JobChanged) {                        
                    //--1)check rider base on occpClass
                    [self getActualRider];
                    
                    BOOL dodelete = NO;
                    for(int i = 0; i<arrExistRiderCode.count; i++)
                    {
                        if(![ridCode containsObject:[arrExistRiderCode objectAtIndex:i]])
                        {
                            [self deleteRider:[arrExistRiderCode objectAtIndex:i]];
                            dodelete = YES;
                        }
                    }
                    [self checkExistRider];
                    
                    //--2)check Occp not attach
                    [self getOccpNotAttach];
                    if (atcRidCode.count !=0) {
                        
                        for (int j=0; j<arrExistRiderCode.count; j++)
                        {
                            if ([[arrExistRiderCode objectAtIndex:j] isEqualToString:@"CPA"]) {
                                [self deleteRider:[arrExistRiderCode objectAtIndex:j]];
                                dodelete = YES;
                            }
                            
                            if ([[arrExistRiderCode objectAtIndex:j] isEqualToString:@"HMM"] && [[arrExistPlanChoice objectAtIndex:j] isEqualToString:@"HMM_1000"]) {
                                [self deleteRider:[arrExistRiderCode objectAtIndex:j]];
                                dodelete = YES;
                            }
                        }
                    }
                    [self checkExistRider];
                    
                    if (dodelete) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Some Rider(s) has been deleted due to marketing rule."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    [self updateData:getSINo];
                } else {
                    [self updateData:getSINo];
                }
            }
        }
    }
    
    AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    if (age < 10) {
        [self checkingPayor];
        if (payorSINo.length == 0) {
            del.ExistPayor = NO;
        }
    } else {
        del.ExistPayor = YES;
    }
}

-(void)toogleExistingBasic
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    NSString *sumAss = [formatter stringFromNumber:[NSNumber numberWithDouble:getSumAssured]];
    sumAss = [sumAss stringByReplacingOccurrencesOfString:@"," withString:@""];
        
    [self getPlanCodePenta];
    [_delegate BasicSI:getSINo andAge:age andOccpCode:occuCode andCovered:termCover andBasicSA:sumAss andBasicHL:getHL andBasicTempHL:getTempHL
                andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose planName:planName];
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    del.SICompleted = YES;
}

-(void)tempView
{
    IndexNo = requestIndexNo;
    lastIdPayor = requestLastIDPay;
    lastIdProfile = requestLastIDProf;
    [self getProspectData];
    
    LANameField.text = NamePP;
    DOB = DOBPP;
    commDate = [self.requestCommDate description];
    [self calculateAge];
    [btnDOB setTitle:DOBPP forState:UIControlStateNormal];
    LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
    [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
    
    sex = [self.requestSex description];
    Relationship = [self.requestSmoker description];
    [self setSexToGlobal];
    sexSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    smokerSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    if (!EDDCase) {
        if ([sex isEqualToString:@"MALE"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else if ([sex isEqualToString:@"FEMALE"]) {
            sexSegment.selectedSegmentIndex = 1;
        }
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else if ([smoker isEqualToString:@"N"]) {
            smokerSegment.selectedSegmentIndex = 1;
        }
    }
    
    occuCode = OccpCodePP;
    [self getOccLoadExist];
    [btnOccp setTitle:occuDesc forState:UIControlStateNormal];
    LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading];
    
    if (occCPA_PA == 0) {
        LACPAField.text = @"D";
    } else {
        LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
    }
    
    if (occPA == 0) {
        LAPAField.text = @"D";
    } else {
        LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
    }
    [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo
             andCommDate:commDate andSmoker:smoker DiffClient:DiffClient bEDDCase:EDDCase];
    Inserted = YES;
}

#pragma mark - Data Load from listing added by faiz
-(void)loadDataFromList{
    _modelSIPOData = [[ModelSIPOData alloc]init];
    dictPOData=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:requestSINo]];
    if ([dictPOData count]!=0){
        NSNumber *numberBoolQuickQuote =[NSNumber numberWithInt:[[dictPOData valueForKey:@"QuickQuote"] intValue]];
        if ([numberBoolQuickQuote intValue]==0){
            [quickQuoteFlag setOn:false];
        }
        else{
            [quickQuoteFlag setOn:true];
        }
        [self QuickQuoteFunc:quickQuoteFlag];
        
        ilustrationProductCode = [dictPOData valueForKey:@"ProductCode"];
        occuCode = [dictPOData valueForKey:@"PO_OccpCode"];
        clientProfileID = [[dictPOData valueForKey:@"PO_ClientID"] intValue];
        [_SINumberBCA setText:[dictPOData valueForKey:@"SINO"]];
        [LANameField setText:[dictPOData valueForKey:@"PO_Name"]];
        [LAAgeField setText:[dictPOData valueForKey:@"PO_Age"]];
        [NamaProduk setTitle:[dictPOData valueForKey:@"ProductName"] forState:UIControlStateNormal];
        [TanggalIllustrasi setTitle:[dictPOData valueForKey:@"SIDate"] forState:UIControlStateNormal];
        [btnDOB setTitle:[dictPOData valueForKey:@"PO_DOB"] forState:UIControlStateNormal];
        [btnOccp setTitle:[dictPOData valueForKey:@"PO_Occp"] forState:UIControlStateNormal];
        [_BtnHubungan setTitle:[dictPOData valueForKey:@"RelWithLA"] forState:UIControlStateNormal];
        
        sex=[[NSString alloc]initWithString:[dictPOData valueForKey:@"PO_Gender"]];
        if ([sex isEqualToString:@"MALE"]){
            [sexSegment setSelectedSegmentIndex:0];
        }
        else{
            [sexSegment setSelectedSegmentIndex:1];
        }
        
        if ([ilustrationProductCode isEqualToString:@"BCALHST"]){
            numberIntInternalStaff = [NSNumber numberWithInt:1];
        }
        else{
            numberIntInternalStaff = [NSNumber numberWithInt:0];
        }

        [_delegate setPODictionaryWhenLoadFromList:dictPOData];
    }
}

-(void)loadDataAfterSaveAs:(NSString *)SINO{
    _modelSIPOData = [[ModelSIPOData alloc]init];
    NSDictionary *localdictPOData=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:SINO]];
    if ([localdictPOData count]!=0){
        [TanggalIllustrasi setTitle:[localdictPOData valueForKey:@"SIDate"] forState:UIControlStateNormal];
    }
}

#pragma mark - Action

- (IBAction)ActionEAPP:(id)sender
{
    [_delegate dismissEApp];
    
}

- (void)updateSINO:(NSString *)newSINO{
    _SINumberBCA.text = newSINO;
}

- (IBAction)sexSegmentPressed:(id)sender
{
    if ([sexSegment selectedSegmentIndex]==0) {
        sex = @"MALE";
    } else if (sexSegment.selectedSegmentIndex == 1) {
        sex = @"FEMALE";
    }
    
    appDelegate.isNeedPromptSaveMsg = YES;
}

- (IBAction)smokerSegmentPressed:(id)sender
{
    if ([smokerSegment selectedSegmentIndex]==0) {
        smoker = @"Y";
    } else if (smokerSegment.selectedSegmentIndex == 1) {
        smoker = @"N";
    }
    appDelegate.isNeedPromptSaveMsg = YES;
	
}

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc{
//    txtBasicPremium.text = @"0";
//    txtBasicSA.text = @"0";
//    txtBUMP.text = @"0";
//    txtCommFrom.text = @"0";
//    txtFor.text = @"0";
//    txtGrayRTUP.text = @"0";
//    txtPolicyTerm.text = @"0";
//    txtPremiumPayable.text = @"0";
//    txtRTUP.text = @"0";
//    txtTotalBAPremium.text = @"0";
//    outletLanguage.selectedSegmentIndex = 0;
//    segPremium.selectedSegmentIndex = 0;
//    
//    if ( ageClient > 70) {
//        [self.planPopover dismissPopoverAnimated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        alert.tag = 1008;
//        [alert show];
//    }
//    /*#EDD
//     else if ( [OccpCode isEqualToString:@"OCC01360"] && ageClient == 0) {
//     [self.planPopover dismissPopoverAnimated:YES];
//     if([aaCode isEqualToString:@"UV"]){
//     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be greater than or equal to 30 days for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//     [alert show];
//     }
//     else{
//     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be greater than or equal to 6 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//     [alert show];
//     }
//     
//     }
//     else if (LA_EDD == TRUE) {
//     [self.planPopover dismissPopoverAnimated:YES];
//     
//     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//     //alert.tag = 3333;
//     [alert show];
//     
//     }*/
//    else if ([aaCode isEqualToString:@"UP"]  && ageClient < 6) {
//        [self.planPopover dismissPopoverAnimated:YES];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be greater than or equal to 6 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
//        
//        
//    }
//    else{
//        
//        if([aaCode isEqualToString:@"UV"]){
//            [self DisableTextField:txtPolicyTerm];
//            txtPolicyTerm.text =  [NSString stringWithFormat:@"%d", (100 - requestAge)];
//        }
//        else{
//            [self EnableTextField:txtPolicyTerm];
//            txtPolicyTerm.text =  [NSString stringWithFormat:@"25"];
//        }
    
    
    
        ilustrationProductCode = aaCode;
        if ([ilustrationProductCode isEqualToString:@"BCALHST"]){
            numberIntInternalStaff = [NSNumber numberWithInt:1];
        }
        else{
            numberIntInternalStaff = [NSNumber numberWithInt:0];
        }
        [NamaProduk setTitle:aaDesc forState:UIControlStateNormal];
        [_BtnHubungan setTitle:@"--Please Select--" forState:UIControlStateNormal];
        [self.planPopover dismissPopoverAnimated:YES];
       // getPlanCode = aaCode;
        
//    }
    
}


-(void)saveBasicPlan
{
    NSString *_AgentCode;
    
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"hladb.sqlite"];

    
    FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
    FMResultSet *results;
    results = [database executeQuery:@"select AgentCode,AgentName from Agent_profile"];
    
    FMDatabase *database1 = [FMDatabase databaseWithPath:path2];
    if (![database open]) {
        NSLog(@"Could not open db.");
    }
    
    while([results next])
        
    {
        _AgentCode  = [results stringForColumn:@"AgentCode"];
    }
    
    
    
    //generate SINo || CustCode
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
    [dateFormatter setDateFormat:@"YYMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    SINOBCA =[NSString stringWithFormat:@"%@%@",_AgentCode,dateString];
    
    _SINumberBCA.text =SINOBCA;

    
//    int runningNoSI = SILastNo + 1;
//    int runningNoCust = CustLastNo + 1;
//    NSString *fooSI = [NSString stringWithFormat:@"%04d", runningNoSI];
//    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
//    
//    SINo = [[NSString alloc] initWithFormat:@"SI%@-%@",currentdate,fooSI];
//    LACustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
//    NSString *AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
//    
//    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
//    {
//        sqlite3_stmt *statement;
//        NSString *query = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"", SINo];
//        BOOL isUpdate = FALSE;
//        if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            if (sqlite3_step(statement) == SQLITE_ROW) {
//                isUpdate = TRUE;
//            }
//            sqlite3_finalize(statement);
//        }
//        
//        if (isUpdate) {
//            query = [NSString stringWithFormat:
//                     @"UPDATE Trad_Details SET PlanCode=\"%@\", PTypeCode=\"LA\", Seq=\"1\", PolicyTerm=\"%@\", BasicSA=\"%@\", "
//                     "PremiumPaymentOption=\"%d\", CashDividend=\"%@\", YearlyIncome=\"%@\", AdvanceYearlyIncome=\"%d\", HL1KSA=\"%@\", HL1KSATerm=\"%@\", "
//                     "TempHL1KSA=\"%@\", TempHL1KSATerm=\"%@\", CreatedAt=%@,UpdatedAt=%@,PartialAcc=%d,PartialPayout=%@, QuotationLang=\"%@\", SIVersion='%@', SIStatus='%@' "
//                     "WHERE SINo=\"%@\"",
//                     planChoose, @"", @"", MOP, cashDividend, yearlyIncome,
//                     advanceYearlyIncome, HLField.text,@" ", tempHLField.text,
//                     @"", @"datetime(\"now\", \"+8 hour\")",@"datetime(\"now\", \"+8 hour\")",
//                     @"",@"", quotationLang, AppsVersion, @"INVALID", SINo];
//        } else {
//            query = [NSString stringWithFormat:
//                     @"INSERT INTO Trad_Details (SINo,  PlanCode, PTypeCode, Seq, PolicyTerm, BasicSA, "
//                     "PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome, HL1KSA, HL1KSATerm, "
//                     "TempHL1KSA, TempHL1KSATerm, CreatedAt,UpdatedAt,PartialAcc,PartialPayout, QuotationLang, SIVersion, SIStatus) "
//                     "VALUES (\"%@\", \"%@\", \"LA\", \"1\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%d\", \"%@\", "
//                     "\"%d\", \"%@\", \"%d\", %@ , %@,%d,%d, \"%@\", '%@', '%@')",
//                     SINo, planChoose, [self getTerm], yearlyIncomeField.text, MOP, cashDividend, yearlyIncome,
//                     advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text,
//                     [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",@"datetime(\"now\", \"+8 hour\")",
//                     [parAccField.text intValue],[parPayoutField.text intValue], quotationLang, AppsVersion, @"INVALID"];
//        }
//        
//        if(sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
//            if (sqlite3_step(statement) == SQLITE_DONE)
//            {
//                [self updateLA];
//                [self getPlanCodePenta];
//                
//                prevPlanChoose = planChoose;
//                
//                if (PayorIndexNo != 0) {
//                    IndexNo = PayorIndexNo;
//                    [self getProspectData];
//                    [self savePayor];
//                }
//                
//                if (secondLAIndexNo != 0) {
//                    IndexNo = secondLAIndexNo;
//                    [self getProspectData];
//                    [self saveSecondLA];
//                }
//                
//                [_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andBasicTempHL:tempHLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose planName:(NSString *)btnPlan.titleLabel.text];
//                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
//                zzz.SICompleted = YES;
//                [self updateFirstRunSI];
//            } else {
//                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [failAlert show];
//            }
//            sqlite3_finalize(statement);
//        }
//        sqlite3_close(contactDB);
//    }
//    
//    appDelegate.isSIExist = YES;
}

-(NSDictionary *)setDictionaryLA{
    NSNumber *numberBoolQuickQuote;
    NSNumber *numberIntClientProfile;
    //NSNumber *numberIntInternalStaff;
    
    if ([quickQuoteFlag isOn]){
        clientProfileID = -1;
    }
    
    if ([ilustrationProductCode isEqualToString:@"BCALHST"]){
        numberIntInternalStaff = [NSNumber numberWithInt:1];
    }
    else{
        numberIntInternalStaff = [NSNumber numberWithInt:0];
    }
    
    numberIntClientProfile = [NSNumber numberWithInt:clientProfileID];
    
    if ([quickQuoteFlag isOn]){
        numberBoolQuickQuote=[NSNumber numberWithInt:1];
    }
    else{
        numberBoolQuickQuote=[NSNumber numberWithInt:0];
    }
    NSDictionary *originalDictionaryPO = [_modelSIPOData getPO_DataFor:[self.requestSINo description]];
    
    
    NSString *occupationDesc=btnOccp.titleLabel.text;
    NSString *relationDesc=_BtnHubungan.titleLabel.text;
    NSString *productName=NamaProduk.titleLabel.text;
    NSString *originalRelation = [originalDictionaryPO valueForKey:@"RelWithLA"];
    NSMutableDictionary *dictionaryNewLA=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          _SINumberBCA.text,@"SINO",
                                          ilustrationProductCode,@"ProductCode",
                                          productName,@"ProductName",
                                          numberBoolQuickQuote,@"QuickQuote",
                                          TanggalIllustrasi.titleLabel.text,@"SIDate",
                                          LANameField.text,@"PO_Name",
                                          btnDOB.titleLabel.text,@"PO_DOB",
                                          sex,@"PO_Gender",
                                          LAAgeField.text,@"PO_Age",
                                          occuCode,@"PO_OccpCode",
                                          occupationDesc,@"PO_Occp",
                                          numberIntClientProfile,@"PO_ClientID",
                                          relationDesc,@"RelWithLA",
                                          numberIntInternalStaff,@"IsInternalStaff",
                                          originalRelation,@"originalRelation",
                                          nil];
    
    if (([relationDesc isEqualToString:@"DIRI SENDIRI"])||([relationDesc isEqualToString:@"SELF"])){
        [dictionaryNewLA setObject:numberIntClientProfile forKey:@"LA_ClientID"];
        [dictionaryNewLA setObject:LANameField.text forKey:@"LA_Name"];
        [dictionaryNewLA setObject:btnDOB.titleLabel.text forKey:@"LA_DOB"];
        [dictionaryNewLA setObject:LAAgeField.text forKey:@"LA_Age"];
        [dictionaryNewLA setObject:sex forKey:@"LA_Gender"];
        [dictionaryNewLA setObject:occuCode forKey:@"LA_OccpCode"];
        [dictionaryNewLA setObject:occupationDesc forKey:@"LA_Occp"];
    }
    else{
        [dictionaryNewLA setObject:@"" forKey:@"LA_ClientID"];
        [dictionaryNewLA setObject:@"" forKey:@"LA_Name"];
        [dictionaryNewLA setObject:@"" forKey:@"LA_DOB"];
        [dictionaryNewLA setObject:@"" forKey:@"LA_Age"];
        [dictionaryNewLA setObject:@"" forKey:@"LA_Gender"];
        [dictionaryNewLA setObject:@"" forKey:@"LA_OccpCode"];
        [dictionaryNewLA setObject:@"" forKey:@"LA_Occp"];
    }
    return dictionaryNewLA;
}

- (IBAction)doSave:(id)sender
{
    //[_delegate saveAll];
    if ([self validateSave]){
        [self passValidationCheck];
        [_delegate saveNewLA:[self setDictionaryLA]];
    }
}

/*- (IBAction)doSaveLA:(id)sender
{
    //[_delegate saveAll];
    if ([self validateSave]){
        NSNumber *numberBoolQuickQuote;
        NSNumber *numberIntClientProfile;
        if ([quickQuoteFlag isOn]){
            clientProfileID = -1;
        }
        numberIntClientProfile = [NSNumber numberWithInt:clientProfileID];
        
        if ([quickQuoteFlag isOn]){
            numberBoolQuickQuote=[NSNumber numberWithInt:1];
        }
        else{
            numberBoolQuickQuote=[NSNumber numberWithInt:0];
        }
        
        NSString *occupationDesc=[btnOccp.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *relationDesc=[_BtnHubungan.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *productName=NamaProduk.titleLabel.text;
        NSMutableDictionary *dictionaryNewLA=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                              _SINumberBCA.text,@"SINO",
                                              ilustrationProductCode,@"ProductCode",
                                              productName,@"ProductName",
                                              numberBoolQuickQuote,@"QuickQuote",
                                              TanggalIllustrasi.titleLabel.text,@"SIDate",
                                              LANameField.text,@"PO_Name",
                                              btnDOB.titleLabel.text,@"PO_DOB",
                                              sex,@"PO_Gender",
                                              LAAgeField.text,@"PO_Age",
                                              occuCode,@"PO_OccpCode",
                                              occupationDesc,@"PO_Occp",
                                              numberIntClientProfile,@"PO_ClientID",
                                              relationDesc,@"RelWithLA",nil];

        if ([relationDesc isEqualToString:@"DIRI SENDIRI"]){
            [dictionaryNewLA setObject:numberIntClientProfile forKey:@"LA_ClientID"];
            [dictionaryNewLA setObject:LANameField.text forKey:@"LA_Name"];
            [dictionaryNewLA setObject:btnDOB.titleLabel.text forKey:@"LA_DOB"];
            [dictionaryNewLA setObject:LAAgeField.text forKey:@"LA_Age"];
            [dictionaryNewLA setObject:sex forKey:@"LA_Gender"];
            [dictionaryNewLA setObject:occuCode forKey:@"LA_OccpCode"];
            [dictionaryNewLA setObject:occupationDesc forKey:@"LA_Occp"];
        }
        
        [self passValidationCheck];
        [_delegate saveNewLA:dictionaryNewLA];
    }
}*/


- (IBAction)NamaProdukDropDown:(id)sender;
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_planList == nil) {
        self.planList = [[PlanList alloc] init];
        self.planList.TradOrEver = @"TRAD";
        _planList.delegate = self;
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
    }
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 30;
    
    [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}


- (IBAction)selectProspect:(id)sender
{
    
    if (_ProspectList == nil) {
        self.ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        _ProspectList.delegate = self;
        self.prospectPopover = [[UIPopoverController alloc] initWithContentViewController:_ProspectList];
    }
    
    CGRect rect = [sender frame];
	rect.origin.y = [sender frame].origin.y + 40;
    
    [self.prospectPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)enableFields:(id)sender
{
    if (QQProspect) {
        LANameField.enabled = NO;
        LANameField.backgroundColor = [UIColor lightGrayColor];
        LANameField.textColor = [UIColor darkGrayColor];
        sexSegment.enabled = NO;
        
        btnDOB.enabled = NO;
        self.btnDOB.titleLabel.textColor = [UIColor darkGrayColor];
        
        btnOccp.enabled = NO;
        self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
        
		QQProspect = NO;
        QQProspect = FALSE;
        
    }
    else
    {
        LANameField.enabled = YES;
        LANameField.backgroundColor = [UIColor whiteColor];
        LANameField.textColor = [UIColor blackColor];
        sexSegment.enabled = YES;
		smokerSegment.enabled = YES;
        
        btnDOB.enabled = YES;
        self.btnDOB.titleLabel.textColor = [UIColor blackColor];
        
        btnOccp.enabled = YES;
        self.btnOccp.titleLabel.textColor = [UIColor blackColor];
        
        QQProspect = YES;
        QQProspect = TRUE;
    }
    
    LANameField.text = @"";
    sexSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    smokerSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    btnDOB.titleLabel.text = @"";
    LAAgeField.text = @"";
    btnCommDate.titleLabel.text = @"";
    btnOccp.titleLabel.text = @"";
    LAOccLoadingField.text = @"";
    LACPAField.text = @"";
    LAPAField.text = @"";
}


- (IBAction)btnTanggalIllustrasiPressed:(UIButton *)sender;
{
    date1 = NO;
    date2 = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:9001 forKey:@"Illustrasi"];
    [defaults synchronize];
    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    self.LADate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    _LADate.delegate = self;
    _LADate.msgDate = sender.titleLabel.text;
    _LADate.btnSender = 1;
    self.dobPopover = [[UIPopoverController alloc] initWithContentViewController:_LADate];
    
    
    [self.dobPopover setPopoverContentSize:CGSizeMake(100.0f, 100.0f)];
    
//    CGRect rect = [sender frame];
//    rect.origin.y = [sender frame].origin.y;
    
    [self.dobPopover presentPopoverFromRect:[sender frame]  inView:scrollLA permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    appDelegate.isNeedPromptSaveMsg = YES;

}

- (IBAction)btnDOBPressed:(UIButton *)sender
{
    date1 = YES;
    date2 = NO;
    
//    if (DOB.length==0 || btnDOB.titleLabel.text.length == 0) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//        
//        [self.btnDOB setTitle:dateString forState:UIControlStateNormal];
//        dobtemp = btnDOB.titleLabel.text;
//    } else {
//        dobtemp = btnDOB.titleLabel.text;
//    }
//    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    self.LADate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    _LADate.delegate = self;
    _LADate.btnSender = 1;
    _LADate.msgDate = sender.titleLabel.text;
    self.dobPopover = [[UIPopoverController alloc] initWithContentViewController:_LADate];
    [self.dobPopover setPopoverContentSize:CGSizeMake(100.0f, 100.0f)];
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [self.dobPopover presentPopoverFromRect:[sender frame]  inView:scrollLA permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    appDelegate.isNeedPromptSaveMsg = YES;
}

- (IBAction)btnCommDatePressed:(id)sender
{
    date1 = NO;
    date2 = YES;
    
    if (commDate.length==0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [btnCommDate setTitle:dateString forState:UIControlStateNormal];
        temp = btnCommDate.titleLabel.text;
    } else {
        temp = btnCommDate.titleLabel.text;
    }
    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    self.LADate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    _LADate.delegate = self;
    _LADate.msgDate = temp;
    _LADate.btnSender = 3;
    self.datePopover = [[UIPopoverController alloc] initWithContentViewController:_LADate];
    
    [self.datePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    
    CGRect rect = [sender frame];
	rect.origin.y = [sender frame].origin.y + 30;
    
    [self.datePopover presentPopoverFromRect:rect  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    appDelegate.isNeedPromptSaveMsg = YES;
}


- (IBAction)btnOccpPressed:(id)sender
{
    if (_OccupationList == nil) {
        self.OccupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
        _OccupationList.delegate = self;
        self.OccupationListPopover = [[UIPopoverController alloc] initWithContentViewController:_OccupationList];
    }
    
    [self.OccupationListPopover presentPopoverFromRect:[sender frame]  inView:scrollLA permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
    appDelegate.isNeedPromptSaveMsg = YES;
	
}

-(int)getAgeFromDOB:(NSString *)dob CommDate:(NSString *)cDate
{    
    NSArray *comm = [cDate componentsSeparatedByString: @"/"];
    NSString *commDay = [comm objectAtIndex:0];
    int dayN = [commDay intValue];
    
    NSString *commMonth = [comm objectAtIndex:1];
    int monthN = [commMonth intValue];
    
    NSString *commYear = [comm objectAtIndex:2];
    int yearN = [commYear intValue];    
    
    NSArray *foo = [dob componentsSeparatedByString: @"/"];
    NSString *birthDay = [foo objectAtIndex: 0];    
    int dayB = [birthDay intValue];
    
    NSString *birthMonth = [foo objectAtIndex: 1];
    int monthB = [birthMonth intValue];
    
    NSString *birthYear = [foo objectAtIndex: 2];
    int yearB = [birthYear intValue];
    
    int ALB = yearN - yearB;
    
    int currentAge = 0;
    
    if (yearN > yearB) {
        if (monthN < monthB) {
            currentAge = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            currentAge = ALB - 1;
        } else if (monthN == monthB && dayN == dayB) { //edited by heng
            currentAge = ALB ;  //edited by heng
        } else {
            currentAge = ALB;            
        }
        
    } else  {        
        currentAge = 0;
    }
    return currentAge;
}

-(void)calculateAge
{
    AgeLess = NO;
    EDDCase = FALSE;
    AgeExceed189Days = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
    NSArray *comm = [commDate componentsSeparatedByString: @"/"];
    NSString *commDay = [comm objectAtIndex:0];
    NSString *commMonth = [comm objectAtIndex:1];
    NSString *commYear = [comm objectAtIndex:2];

    
    NSArray *foo = [DOB componentsSeparatedByString: @"/"];
    NSString *birthDay = [foo objectAtIndex: 0];
    NSString *birthMonth = [foo objectAtIndex: 1];
    NSString *birthYear = [foo objectAtIndex: 2];
    
    int yearN = [commYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [commMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [commDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    
    NSString *msgAge;
    if (yearN > yearB) {
        if (monthN < monthB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN == dayB) { //edited by heng
            newALB = ALB ;  //edited by heng
        } else {
            newALB = ALB;            
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN > dayB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN == dayB) { // edited by heng
            newANB = ALB; //edited by heng
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        age = newALB;
        ANB = newANB;
    } else if (yearN == yearB) {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = DOB;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:commDate];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
        if (diffDays < 0 && diffDays > -190 ) {
            EDDCase = YES;
            AgeExceed189Days = NO;
        } else if (diffDays < 0 && diffDays <  -190 ) {
            AgeExceed189Days = YES;
            EDDCase = FALSE;
        } else if (diffDays < 30) {
            AgeLess = YES;
            EDDCase = FALSE;
            AgeExceed189Days = NO;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d days",diffDays];
        
        age = 0;
        ANB = 1;
    } else {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = DOB;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:commDate];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
//        if (diffDays < 0 && diffDays > -190 ) {
//            EDDCase = YES;
//            AgeExceed189Days = NO;
//        } else if (diffDays < 0 && diffDays <  -190 ) {
//            AgeExceed189Days = YES;
//            EDDCase = NO;
//        } else if (diffDays < 30) {
//            AgeLess = YES;
//            AgeExceed189Days = NO;
//        }
        age = 0;
        ANB = 1;
    }
}


#pragma mark - UIALERT VIEW DELEGATE
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0) {
        
        if (useExist) {
            [self updateData:getSINo];
        } else if (Inserted) {
           // [self updateData2];
        } else {
            [self insertData];
        }
    } else if (alertView.tag==1002 && buttonIndex == 0) {
        [self delete2ndLA];
    } else if (alertView.tag==1003 && buttonIndex == 0) {
        [self deletePayor];
    } else if (alertView.tag==1004 && buttonIndex == 0) {
        if ([OccpCodePP isEqualToString:@"OCC01975"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
		} else {
            sex = GenderPP;
            [self setSexToGlobal];
            DOB = DOBPP;
            occuCode = OccpCodePP;
            [self calculateAge];
            [self getOccLoadExist];
            
            LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading];            
            
            if (occCPA_PA == 0) {
                LACPAField.text = @"D";
            } else {
                LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
            }
            
            if (occPA == 0) {
                LAPAField.text = @"D";
            } else {
                LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
            }
            //-------------------
            
            [self calculateAge];
            if (AgeLess) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert setTag:1005];
                [alert show];
            } else if (AgeExceed189Days) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Expected date of delivery cannot be more than 189 days."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert setTag:1005];
                [alert show];
            } else {
                [self checkExistRider];
                if (AgeChanged) {
                    
                    if (arrExistRiderCode.count > 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Rider(s) has been deleted due to business rule."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert setTag:1007];
                        [alert show];
                    }
                    
                    [self updateData:getSINo];
                } else if (JobChanged) {                    
                    //--1)check rider base on occpClass
                    [self getActualRider];
                    
                    BOOL dodelete = NO;
                    for(int i = 0; i<arrExistRiderCode.count; i++) {
                        if(![ridCode containsObject:[arrExistRiderCode objectAtIndex:i]]) {
                            [self deleteRider:[arrExistRiderCode objectAtIndex:i]];
                            dodelete = YES;
                        }
                    }
                    [self checkExistRider];
                    
                    //--2)check Occp not attach
                    [self getOccpNotAttach];
                    if (atcRidCode.count !=0) {
                        
                        for (int j=0; j<arrExistRiderCode.count; j++) {
                            if ([[arrExistRiderCode objectAtIndex:j] isEqualToString:@"CPA"]) {
                                [self deleteRider:[arrExistRiderCode objectAtIndex:j]];
                                dodelete = YES;
                            }
                            
                            if ([[arrExistRiderCode objectAtIndex:j] isEqualToString:@"HMM"] && [[arrExistPlanChoice objectAtIndex:j] isEqualToString:@"HMM_1000"]) {
                                [self deleteRider:[arrExistRiderCode objectAtIndex:j]];
                                dodelete = YES;
                            }
                        }
                    }
                    [self checkExistRider];
                    
                    if (dodelete) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Some Rider(s) has been deleted due to marketing rule."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    [self updateData:getSINo];
                } else {
                    [self updateData:getSINo];
                }
            }
        }
    } else if (alertView.tag==1004 && buttonIndex == 1) { // added by heng
        LANameField.text = clientName;
        [btnDOB setTitle:DOB forState:UIControlStateNormal];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        if ([sex isEqualToString:@"MALE"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else if ([sex isEqualToString:@"FEMALE"]) {
            sexSegment.selectedSegmentIndex = 1;
        }
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else if ([smoker isEqualToString:@"N"]) {
            smokerSegment.selectedSegmentIndex = 1;
        }
        
        [self getOccLoadExist];
        [btnOccp setTitle:occuDesc forState:UIControlStateNormal];
        LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading];
        
        if (occCPA_PA == 0) {
            LACPAField.text = @"D";
        } else {
            LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
            LAPAField.text = @"D";
        } else {
            LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
        }
    } else if (alertView.tag==1005 && buttonIndex == 0) {
        
        LANameField.text = @"";
        [sexSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [btnDOB setTitle:@"" forState:UIControlStateNormal];
        LAAgeField.text = @"";
        [self.btnCommDate setTitle:@"" forState:UIControlStateNormal];
        [btnOccp setTitle:@"" forState:UIControlStateNormal];
        LAOccLoadingField.text = @"";
        LACPAField.text = @"";
        LAPAField.text = @"";
    } else if (alertView.tag == 1007 && buttonIndex == 0) {
        [self deleteRider];
    }
}



#pragma mark - Handle Data

-(void)getOccLoadExist
{
    FMDatabase *db;
    FMResultSet *results;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];
    
    db = [FMDatabase databaseWithPath:path];
    [db open];
    
  
    
    results = Nil;

    results = [db executeQuery:@"SELECT OccpDesc from eProposal_OCCP WHERE occp_Code = ?", occuCode, Nil];
    while ([results next]) {
        NSString *occpDesc = [results stringForColumn:@"OccpDesc"] != NULL ? [results stringForColumn:@"OccpDesc"] : @"";
        occuDesc = occpDesc;
    }
    [db close];
}


-(void) GetLastID
{
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *lastID;
    NSString *contactCode;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *GetLastIdSQL = [NSString stringWithFormat:@"Select indexno  from prospect_profile order by \"indexNo\" desc limit 1"];
        const char *SelectLastId_stmt = [GetLastIdSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, SelectLastId_stmt, -1, &statement2, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement2) == SQLITE_ROW)
            {
                lastID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                IndexNo = [lastID intValue];
                sqlite3_finalize(statement2);
            }
        }
		
		for (int i = 0; i<4; i++) {
			
			switch (i) {
				case 0:					
					contactCode = @"CONT006";
					break;
					
				case 1:
					contactCode = @"CONT008";
					break;
					
				case 2:
					contactCode = @"CONT007";
					break;
					
				case 3:
					contactCode = @"CONT009";
					break;
					
				default:
					break;
			}
			
			if (![contactCode isEqualToString:@""]) {				
				NSString *insertContactSQL = @"";
				if (i==0) {
					insertContactSQL = [NSString stringWithFormat:
										@"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
										" VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, @"", @"N", @""];
				} else if (i==1) {
					insertContactSQL = [NSString stringWithFormat:
										@"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
										" VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, @"", @"N", @""];
				} else if (i==2) {
					insertContactSQL = [NSString stringWithFormat:
										@"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
										" VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, @"", @"N", @""];
				} else if (i==3) {
					insertContactSQL = [NSString stringWithFormat:
										@"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
										" VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, @"", @"N", @""];
				}
				
				const char *insert_contactStmt = [insertContactSQL UTF8String];
				if(sqlite3_prepare_v2(contactDB, insert_contactStmt, -1, &statement3, NULL) == SQLITE_OK) {
					if (sqlite3_step(statement3) == SQLITE_DONE){
						sqlite3_finalize(statement3);
					}
				}
				insert_contactStmt = Nil, insertContactSQL = Nil;
			}
		}
		
		sqlite3_close(contactDB);
    }
        
    statement2 = Nil, statement3 = Nil, lastID = Nil;
    contactCode = Nil;
    dbpath = Nil;
}

-(void)insertClient
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL3 = [NSString stringWithFormat:
                                @"INSERT INTO prospect_profile(\"ProspectName\", \"ProspectDOB\", \"ProspectGender\", \"ProspectOccupationCode\", \"DateCreated\", \"CreatedBy\","
                                "\"DateModified\",\"ModifiedBy\", \"Smoker\", 'QQflag') "
                                "VALUES (\"%@\", \"%@\", \"%@\", \"%@\", %@, \"%@\", \"%@\", \"%@\", \"%@\", '%@')",
                                LANameField.text, DOB, sex, occuCode, @"datetime(\"now\", \"+8 hour\")", @"1", @"", @"1", smoker, @"true"];
        
        if(sqlite3_prepare_v2(contactDB, [insertSQL3 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [self GetLastID];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)UpdateClient
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
		if (sexSegment.selectedSegmentIndex == 1) {
			sex = @"FEMALE";
		} else {
			sex = @"MALE";
		}
		
        NSString *insertSQL3 = [NSString stringWithFormat:
								@"Update prospect_profile Set ProspectName = '%@', ProspectDOB = '%@', ProspectGender = '%@', "
								" ProspectOccupationCode = '%@', DateModified='%@', ModifiedBy='%@', Smoker= '%@' WHERE indexNo = '%d' ",
								LANameField.text, DOB, sex, occuCode, @"datetime(\"now\", \"+8 hour\")", @"1", smoker, IndexNo];
		
        if(sqlite3_prepare_v2(contactDB, [insertSQL3 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }	
}

-(BOOL)insertData
{
    if (QQProspect) {
        [self insertClient];
    }
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
							   @"INSERT INTO Trad_LAPayor (SINo, CustCode, PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"%@\", \"null\",\"LA\",\"1\",\"%@\",\"hla\")",
                               getSINo, commDate];
        
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) != SQLITE_DONE)
            {
                return NO;
            }
            sqlite3_finalize(statement);
        }
        
        NSString *sexI = @"";
        
        if([sex length]>0) {
            sexI = sex;
        }
        
        NSString *insertSQL2 = [NSString stringWithFormat:@"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, "
								"DateCreated, CreatedBy,indexNo) VALUES (\"null\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", "
								"\"%@\", \"hla\", \"%d\")",LANameField.text, smoker, sexI, DOB, age, ANB, occuCode, commDate,IndexNo];
		
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                savedIndexNo = IndexNo;
                [self setGlobalExistPayor];
                [self getLastIDPayor];
                [self getLastIDProfile];
                
            } else {
                savedIndexNo = -1;
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
                return NO;
            }
            sqlite3_finalize(statement);
        }
		
        [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo
                 andCommDate:commDate andSmoker:smoker DiffClient:DiffClient bEDDCase:EDDCase];
        Inserted = YES;
        AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        //del.SICompleted = NO;
        del.SICompleted = YES;
        sqlite3_close(contactDB);
    }
    return YES;
}

-(void)setGlobalExistPayor
{
    AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    if (age < 10) {
        [self checkingPayor];
        if (payorSINo.length == 0) {
            del.ExistPayor = NO;
        }
    } else {
        del.ExistPayor = YES; //more than age of 10, bypass this logic and set to YES
    }
}

-(BOOL)updateData:(NSString *) SiNo
{
    [self getDiffClient:IndexNo];
    getSINo = SiNo;
    self.requestSINo = SiNo;
	if (QQProspect == TRUE) {
		[self UpdateClient];
	}
	
    BOOL isUpdated = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString * sex1 = @"";
        if( [sex length] > 0 ) {
            sex1 = sex;
        }
        
        NSString *querySQL = [NSString stringWithFormat:
							  @"UPDATE Clt_Profile SET Name=\'%@\', Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateModified=\"%@\","
                              "ModifiedBy=\"hla\",indexNo=\"%d\", DateCreated = \"%@\"  WHERE id=\"%d\"",
                              LANameField.text,smoker,sex1,DOB,age,ANB,occuCode,currentdate,IndexNo, commDate,idProfile];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                if (DiffClient)  {                    
                    if (age < 10) {
                        [self checkingPayor];
                        if (payorSINo.length == 0) {                            
                            AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                            del.ExistPayor = NO;
                        }
                    }
                    
                    [self checkExistRider];
                    if (arrExistRiderCode.count > 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Rider(s) has been deleted due to business rule."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert setTag:1007];
                        [alert show];
                    }
                    
                    if (age > 18) {
                        [self checkingPayor];
                        if (payorSINo.length != 0 && ![payorSINo isEqualToString:@"(null)"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Payor's details will be deleted due to Life Assured's age is greater or equal to 18."
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1003];
                            [alert show];
                        }
                    }
                    
                    if (age < 16) {
                        [self checking2ndLA];
                        if (CustCode2.length != 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"2nd Life Assured's details will be deleted due to life Assured's age is less than 16."
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1002];
                            [alert show];
                        }
                    }
                    
                    isUpdated = NO;
                    
                    [self getExistingBasic];
                    if ([planChoose isEqualToString:STR_S100]) {
                        termCover = 100;
                    }
                    [self toogleExistingBasic];
                } else {
                    if (age < 10) {
                        [self checkingPayor];
                        if (payorSINo.length == 0) {
                            AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                            del.ExistPayor = NO;
                        }
                    }
                    
                    if (age >= 18) {
                        [self checkingPayor];
                        if (payorSINo.length != 0 && ![payorSINo isEqualToString:@"(null)"]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Payor's details will be deleted due to life Assured's age is greater or equal to 18"
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1003];
                            [alert show];
                        }
                    }
                    
                    if (age < 16) {
                        [self checking2ndLA];
                        if (CustCode2.length != 0) {
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"2nd Life Assured's details will be deleted due to life Assured's age is less than 16"
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1002];
                            [alert show];
                        }
                    }
                }
                AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ]; 
                del.SICompleted = YES; 
                
                savedIndexNo = IndexNo;
                [self setGlobalExistPayor];
            } else {
                savedIndexNo = -1;
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
                isUpdated = NO;
            }
            [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo
                     andCommDate:commDate andSmoker:smoker DiffClient:DiffClient bEDDCase:EDDCase];
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return isUpdated;
}

//-(void)updateData2
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
//    
//    sqlite3_stmt *statement;
//    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
//    {
//        NSString *sex1 = [self getNonGender:sex];
//        NSString *querySQL = [NSString stringWithFormat:
//                              @"UPDATE Clt_Profile SET Name=\'%@\', Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateModified=\"%@\", "
//                              "ModifiedBy=\"hla\",indexNo=\"%d\", DateCreated = \"%@\"  WHERE id=\"%d\"",
//                              LANameField.text,smoker,sex1,DOB,age,ANB,occuCode,currentdate,IndexNo, commDate,lastIdProfile];
//        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
//        {
//            if (sqlite3_step(statement) == SQLITE_DONE)
//            {
//                if (age < 10) {
//                    [self checkingPayor];
//                    if (payorSINo.length == 0) {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please attach Payor as Life Assured is below 10 years old."
//                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//                        [alert show];
//                    }
//                }
//                
//                savedIndexNo = IndexNo;
//                [self setGlobalExistPayor];
//            } else {
//                savedIndexNo = -1;
//                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [failAlert show];
//            }
//            
//            [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo
//                     andCommDate:commDate andSmoker:smoker DiffClient:DiffClient bEDDCase:EDDCase];
//            
//            sqlite3_finalize(statement);
//        }
//        sqlite3_close(contactDB);
//    }
//}

-(void)checkingExisting
{
    
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, "
							  "b.id, b.IndexNo, a.rowid FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode "
							  "WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                CustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                clientName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                smoker = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                sex = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                [self setSexToGlobal];
                DOB = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                age = sqlite3_column_int(statement, 6);
                occuCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                commDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                idProfile = sqlite3_column_int(statement, 9);
                IndexNo = sqlite3_column_int(statement, 10);
                savedIndexNo = IndexNo;
                [self setGlobalExistPayor];
                idPayor = sqlite3_column_int(statement, 11);
                useExist = NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (SINo.length != 0) {
        useExist = YES;
    } else {
        useExist = NO;
    }
    [self storeLAObj];
}

-(void) setSexToGlobal
{
    AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ]; //firstLAsex
    del.firstLAsex = sex;
}

-(void)checkingExistingSI
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getProspectData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT ProspectName, ifnull(ProspectDOB, 000) as ProspectDOB, ProspectGender, ProspectOccupationCode, QQFlag, Smoker, OtherIDType FROM prospect_profile "
							  "WHERE IndexNo= \"%d\"",IndexNo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NamePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                DOBPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                GenderPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] isEqualToString:@"EDD"]) {
                    OccpCodePP = @"OCC01360";
                    EDDCase = TRUE;
                } else {
                    OccpCodePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                    EDDCase = FALSE;
                }
                
                smoker = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
				
				NSString *TempQQProspect = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
				if ([TempQQProspect isEqualToString:@"true"]) {
					QQProspect = TRUE;
					sexSegment.enabled = TRUE;
					smokerSegment.enabled = TRUE;
				} else {
					QQProspect = FALSE;
					sexSegment.enabled = FALSE;
					smokerSegment.enabled = FALSE;
				}				
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getExistingBasic
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.PlanCode, a.PolicyTerm, a.BasicSA, a.PremiumPaymentOption, a.CashDividend, a.YearlyIncome, "
                              "a.AdvanceYearlyIncome, a.HL1KSA, a.HL1KSATerm, a.TempHL1KSA, a.TempHL1KSATerm, b.planname FROM Trad_Details a "
                              "left outer join trad_sys_profile b on a.plancode=b.plancode "
							  "WHERE SINo=\"%@\" AND a.PlanCode <> '(null)'",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                planChoose = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                getPolicyTerm = sqlite3_column_int(statement, 2);
                getSumAssured = sqlite3_column_double(statement, 3);
                MOP = sqlite3_column_int(statement, 4);
                cashDividend = [[NSString alloc ] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                yearlyIncome = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                advanceYearlyIncome = sqlite3_column_int(statement, 7);
                
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 8);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 9);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 10);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 11);
                planName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON "
                              "a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
				payorAge = sqlite3_column_int(statement, 6);
                
            } else {
                payorSINo= nil;
                payorCustCode = nil;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(BOOL)checking2ndLA
{
    BOOL secondLAExist = false;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON "
                              "a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                secondLAExist = TRUE;
                CustCode2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                idProfile2 = sqlite3_column_int(statement, 9);
            } else {
                secondLAExist = FALSE;
                CustCode2 = nil;
                idProfile2 = 0;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    return secondLAExist;
}

-(void)delete2ndLA
{
    [_delegate secondLADelete];
	
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_LAPayor WHERE CustCode=\"%@\"",CustCode2];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Clt_Profile WHERE CustCode=\"%@\"",CustCode2];
        if (sqlite3_prepare_v2(contactDB, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deletePayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_LAPayor WHERE CustCode=\"%@\"",payorCustCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Clt_Profile WHERE CustCode=\"%@\"",payorCustCode];
        if (sqlite3_prepare_v2(contactDB, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getTerm
{
    if ([planChoose isEqualToString:STR_HLAWP] || [planChoose isEqualToString:STR_S100]) {
        termCover = getPolicyTerm;
    } else {
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:
                                  @"SELECT MinTerm,MaxTerm,MinSA,MaxSA FROM Trad_Sys_Mtn WHERE PlanCode=\"%@\"",planChoose];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    if ([planChoose isEqualToString:STR_HLAWP])
                    {
                        termCover = getPolicyTerm;
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
    }
}

-(void)getPlanCodePenta
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = nil;
        if ([planChoose isEqualToString:@"HLAIB"]) {
            querySQL = [NSString stringWithFormat: @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",planChoose,MOP];
        } else {
            querySQL = [NSString stringWithFormat: @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"%@\"",planChoose];
        }
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                planCode =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkExistRider
{
    arrExistRiderCode = [[NSMutableArray alloc] init];
    arrExistPlanChoice = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT RiderCode, PlanOption FROM Trad_Rider_Details WHERE SINo=\"%@\"",getSINo];
		
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [arrExistRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [arrExistPlanChoice addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getActualRider
{
    ridCode = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        if (self.occuClass == 4 && ![strPA_CPA isEqualToString:@"D" ]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN Trad_Sys_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\" AND a.RiderCode != \"MG_IV\")j "
                        "LEFT JOIN Trad_Sys_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"", planChoose, age, age];
        } else if (self.occuClass > 4) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN Trad_Sys_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\" AND a.RiderCode != \"CPA\" AND a.RiderCode != \"PA\" AND a.RiderCode != \"HMM\" AND a.RiderCode != \"HB\" AND a.RiderCode != \"MG_II\" AND a.RiderCode != \"MG_IV\" AND a.RiderCode != \"HSP_II\")j "
                        "LEFT JOIN Trad_Sys_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"",planChoose, age, age];
        } else if ([strPA_CPA isEqualToString:@"D"]){
			querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN Trad_Sys_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\" AND a.RiderCode != \"MG_IV\" AND a.RiderCode != \"CPA\")j "
                        "LEFT JOIN Trad_Sys_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"", planChoose, age, age];
		} else {
            querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN Trad_Sys_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\")j "
                        "LEFT JOIN Trad_Sys_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"",planChoose, age, age];
        }
		
        if (age > 60) {
            querySQL = [querySQL stringByAppendingFormat:@" AND j.RiderCode != \"I20R\""];
        }
        if (age > 65) {
            querySQL = [querySQL stringByAppendingFormat:@" AND j.RiderCode != \"IE20R\""];
        }
        
        if ([[OccuCatCode stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"UNEMP"]) {
            querySQL = [querySQL stringByAppendingFormat:@" AND j.RiderCode not in (\"CPA\", 'HB') AND j.PlanOption != \"HMM_1000\"   "];
        }
        
        if ([[OccuCatCode stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"RET"]) {
            querySQL = [querySQL stringByAppendingFormat:@" AND j.RiderCode not in (\"TPDYLA\") "];
        }
        
        querySQL = [querySQL stringByAppendingFormat:@" order by j.RiderCode asc"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [ridCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccpNotAttach
{
    atcRidCode = [[NSMutableArray alloc] init];
    atcPlanChoice = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,PlanChoice FROM Trad_Sys_Occp_NotAttach WHERE OccpCode=\"%@\"",occuCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *zzRidCode = (const char *)sqlite3_column_text(statement, 0);
                [atcRidCode addObject:zzRidCode == NULL ? @"" :[[NSString alloc] initWithUTF8String:zzRidCode]];
                
                const char *zzPlan = (const char *)sqlite3_column_text(statement, 1);
                [atcPlanChoice addObject:zzPlan == NULL ? @"" :[[NSString alloc] initWithUTF8String:zzPlan]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deleteRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [_delegate RiderAdded];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deleteRider:(NSString *)aaCode
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",getSINo,aaCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [_delegate RiderAdded];                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getLastIDPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT rowid FROM Trad_LAPayor ORDER by rowid desc limit 1"];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                lastIdPayor  =  sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

# pragma mark - VALIDATION
-(BOOL)performSaveData
{
    [self getProspectData];
    if (useExist) {
        return[self updateData:getSINo];
    } else {
		return [self insertData];
    }	
}

-(BOOL)validateSave// validate new la before saving
{
    //temp
    //return YES;
    
    int LAAGEint = [[LAAgeField text] intValue];
    
    if ([NamaProduk.titleLabel.text isEqualToString:@"(null)"] ||[NamaProduk.titleLabel.text isEqualToString:@"--Please Select--"] || NamaProduk.titleLabel.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Produk harus diisi."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        return NO;
        
    }
    else if ([TanggalIllustrasi.titleLabel.text isEqualToString:@"(null)"] ||[TanggalIllustrasi.titleLabel.text isEqualToString:@"--Please Select--"] || TanggalIllustrasi.titleLabel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Tanggal Ilustrasi harus diisi "
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        return NO;
        
    }
    else if (AgeExceed189Days == true) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Tanggal lahir yang dimasukkan tidak boleh lebih dari 180 hari yang lalu"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1005];
        [alert show];
        return NO;
    }
    else if (LANameField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Nama Pemegang harus diisi."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [LANameField becomeFirstResponder];
        return NO;
       
    } else if ([btnDOB.titleLabel.text isEqualToString:@"(null)"] ||[btnDOB.titleLabel.text isEqualToString:@"--Please Select--"] || btnDOB.titleLabel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Tanggal Lahir Pemegang Polis"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        return NO;
    } else if (LAAGEint < 18) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Usia harus sama dengan atau lebih dari 18 tahun"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
     //   [alert setTag:1005];
        [alert show];
        return NO;
    }
    
     else if (((LAAGEint >70)&&[NamaProduk.titleLabel.text isEqualToString:@"BCA Life Heritage Protection"])||((LAAGEint >70)&&[NamaProduk.titleLabel.text isEqualToString:@"BCA Life Heritage Protection – For BCA Staff"]))
    {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Usia tidak boleh melebihi dari 70 tahun."
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        // [alert setTag:1005];
         [alert show];
         return NO;
     }
    
     else if ((LAAGEint >55)&&[NamaProduk.titleLabel.text isEqualToString:@"BCA Life Keluargaku"])
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Usia tidak boleh melebihi dari 55 tahun."
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
         // [alert setTag:1005];
         [alert show];
         return NO;
     }

    
    else if (sexSegment.selectedSegmentIndex == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Jenis kelamin Pemegang Polis harus diisi."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        // [alert setTag:1005];
        [alert show];
        return NO;
    }
    
    else if ([btnOccp.titleLabel.text isEqualToString:@"(null)"]||[btnOccp.titleLabel.text isEqualToString:@" - SELECT -"]||[btnOccp.titleLabel.text isEqualToString:@"- SELECT -"]||[btnOccp.titleLabel.text isEqualToString:@"--Please Select--"] || btnOccp.titleLabel.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Pekerjaan Pemegang Polis harus diisi."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        return NO;
    }
    
    else if ([_BtnHubungan.titleLabel.text isEqualToString:@"(null)"] ||[_BtnHubungan.titleLabel.text isEqualToString:@"--Please Select--"] ||[_BtnHubungan.titleLabel.text isEqualToString:@"- SELECT -"] || _BtnHubungan.titleLabel.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Hubungan Dengan Tertannggung harus diisi"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        return NO;
    }
    
    /*else if (([_BtnHubungan.titleLabel.text isEqualToString:@"DIRI SENDIRI"])||([_BtnHubungan.titleLabel.text isEqualToString:@"SELF"]))
    {
        //if hubungan dengan tertanggung is not equal to self",tertanggung screen...
    }*/





    //        else if (AgeExceed189Days) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Expected date of delivery cannot be more than 189 days."
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert setTag:1005];
//        [alert show];
//    } else if ( (occuCode.length == 0 || btnOccp.titleLabel.text.length == 0) && [sex length]>0 ) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please select an Occupation Description."
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
//    } else if ([occuCode isEqualToString:@"OCC01975"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"There is no existing plan which can be offered to this occupation."
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
//    }
    else {
        return YES;
    }
    
    
}

#pragma mark - STORE LA BEFORE SAVE INTO DATABASE
-(void)storeLAObj
{
    if (!siObj) {
        siObj = [[SIObj alloc]init];
    }
    
    if(!tempSIDict) {
        tempSIDict = [[NSMutableDictionary alloc]init];
    }
    
    if (CustCode != NULL) {
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT Name,Smoker,Sex,DOB,ALB,ANB,OccpCode,DateModified,ModifiedBy,indexNo,DateCreated FROM "
                                  "Clt_Profile WHERE CustCode = \"%@\" ", CustCode];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    int rowCount = sqlite3_column_count(statement);                    
                    for (int i = 0; i<rowCount; i++) {
                        [tempSIDict setObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, i)] forKey:[NSString stringWithFormat:@"key%d",i]];
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
    }
}

-(void) getLastIDProfile
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT id FROM Clt_Profile ORDER by id desc limit 1"];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                lastIdProfile  =  sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - delegate

-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    int selectedIndex = [aaIndex intValue];

    clientProfileID = [aaIndex intValue];
    tempSmoker = smoker;
    tempSex = sex;
    tempDOB = DOB;
    tempAge =age;
    tempOccCode = occuCode;
    tempIndexNo = IndexNo;
    tempCommDate = commDate;
    tempIdProfile = idProfile;
    
    
        
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    
    commDate = dateString;
   // }
    
    if([aaDOB length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"The selected client is not applicable for this SI product."
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		alert = Nil;
        return;
    }
    
    int currentAge =[self getAgeFromDOB:aaDOB CommDate:commDate];
    
	LANameField.enabled = NO;
//	LANameField.backgroundColor = [UIColor lightGrayColor];
//	LANameField.textColor = [UIColor darkGrayColor];
	
	sexSegment.enabled = NO;
	
	btnDOB.enabled = NO;
	self.btnDOB.titleLabel.textColor = [UIColor darkGrayColor];
	
	btnOccp.enabled = NO;
	self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
	
	QQProspect = NO;
	   
    if (SINo) {
        useExist = YES;		
    } else {
        useExist = NO;
    }
    statusLabel.text = @"";
    prevIndexNo = IndexNo;
    IndexNo = [aaIndex intValue];
    
    AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    del.ExistPayor = YES;
    
    NSString *aaGen = [self getNonGender:aaGender];
    if(([del.planChoose isEqualToString:STR_S100]) && [self checking2ndLA] && [[del.secondLAsex substringToIndex:1] isEqualToString:aaGen]) {
        IndexNo = prevIndexNo;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"You can't select the First Life Assured with the same sex as the Second Life Assured." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else if ([del.planChoose isEqualToString:STR_HLAWP] && (currentAge > 18 && getPolicyTerm==70)) {
        IndexNo = prevIndexNo;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age Last Birthday must be less than or equal to 45 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if( savedIndexNo==selectedIndex ) {
            //do nothing, user selected the same LA that has been saved
            DiffClient = NO;
        } else {
            if(savedIndexNo==-1) { //SI is new, savedIndexNo is -1
                DiffClient = NO; 
            } else {
                DiffClient = YES;
            }
      }

        DOB = aaDOB;
        [self calculateAge];
       // LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        
        LANameField.text = aaName;
        sex = aaGender;
        [self setSexToGlobal];
        sexSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
        smokerSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
		sexSegment.enabled = FALSE;
        smokerSegment.enabled = FALSE;
        if (!EDDCase) {
            if ([sex isEqualToString:@"MALE"] || [sex isEqualToString:@"M"] || EDDCase == TRUE ) {
                sexSegment.selectedSegmentIndex = 0;
                sex = @"MALE";
            } else {
                sexSegment.selectedSegmentIndex = 1;
                sex = @"FEMALE";
            }
            
            if ([aaSmoker isEqualToString:@"N"] || EDDCase == TRUE) {
                smokerSegment.selectedSegmentIndex = 1;
            } else {
                smokerSegment.selectedSegmentIndex = 0;
            }
        }
		
        [btnDOB setTitle:DOB forState:UIControlStateNormal];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        if (EDDCase == TRUE) {
            occuCode = @"OCC01360";
        } else {
            occuCode = aaCode;
        }        
        
        [self getOccLoadExist];
        [btnOccp setTitle:occuDesc forState:UIControlStateNormal];
        self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
        LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading];
        
        if (occCPA_PA == 0) {
            LACPAField.text = @"D";
        } else {
            LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
            LAPAField.text = @"D";
        } else {
            LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
        }
        
        [self.prospectPopover dismissPopoverAnimated:YES];
        outletDone.enabled = TRUE;
        //del.SICompleted = NO; //added by Edwin 9-10-2013
        del.SICompleted = YES;
	}	
}

-(void) getDiffClient:(int)selectedIndex
{
    if( savedIndexNo==selectedIndex ) {
        //do nothing, user selected the same LA that has been saved
        DiffClient = NO;
    } else {
        if(savedIndexNo==-1) {//SI is new, savedIndexNo is -1
            DiffClient = NO; 
        } else {
            DiffClient = YES;
        }
    }   
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    NSLog(@"date %@ age %@ bAge %i anb %i",aDate,aAge,bAge,aANB);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *selectDate = aDate;
    NSDate *startDate = [dateFormatter dateFromString:selectDate];
    
    NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *endDate = [dateFormatter dateFromString:todayDate];
    
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    int diffDays = [difference day];
    if (diffDays >180)
    {
        AgeExceed189Days = true;
    }
    else
    {
        AgeExceed189Days = false;
    }

    
    if (date1)
    {
        if (aDate == NULL) {
            [btnDOB setTitle:dobtemp forState:UIControlStateNormal];
            DOB = dobtemp;
            [self calculateAge];
            LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
            
        } else {
            [btnDOB setTitle:aDate forState:UIControlStateNormal];
            DOB = aDate;
            [self calculateAge];
            LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",bAge];
        }
        
        self.btnDOB.titleLabel.textColor = [UIColor blackColor];
        [self.dobPopover dismissPopoverAnimated:YES];
        date1 = NO;
    } else if (date2)
    {
        if (aDate == NULL) {
            [TanggalIllustrasi setTitle:aDate forState:UIControlStateNormal];
            DOB = dobtemp;
          //  [self calculateAge];
          //  LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
            
        } else {
            [TanggalIllustrasi setTitle:aDate forState:UIControlStateNormal];
            DOB = aDate;
           // [self calculateAge];
           // LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",bAge];
        }
    
    self.btnDOB.titleLabel.textColor = [UIColor blackColor];
    [self.dobPopover dismissPopoverAnimated:YES];
    date1 = NO;
}
    
   // if (DAteTanggal)
//    {
//        [self.TanggalIllustrasi setTitle:aDate forState:UIControlStateNormal];
//        
//        
//        [self.datePopover dismissPopoverAnimated:YES];
//        
    
//    }
    
    [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo
             andCommDate:commDate andSmoker:smoker DiffClient:DiffClient bEDDCase:EDDCase];
}

-(void)selectedRship:(NSString *)selectedRship :(NSString *)SelectedPshipCode;
{
    //[Relationship setText:selectedRship];
    
    NSString *Test = SelectedPshipCode;
    
    Relationship = selectedRship;
    
     [_BtnHubungan setTitle:Relationship forState:UIControlStateNormal];
    
    
      Relationship = [self.requestSmoker description];
    
    if (_RshipTypePickerPopover) {
        [_RshipTypePickerPopover dismissPopoverAnimated:YES];
        _RshipTypePickerPopover = nil;
    }
}

- (IBAction)Hubungan:(id)sender;
{
    [self.view endEditing:YES];
    
   // _RshipTypePicker.rowToUpdate = _rowToUpdate;
    if (_RshipTypePicker == nil) {
        _RshipTypePicker = [[RelationshipPopoverViewController alloc] initWithStyle:UITableViewStylePlain];
        _RshipTypePicker.delegate = self;
        //_RshipTypePicker.rowToUpdate = _rowToUpdate;
    }
    
    //if (_RshipTypePickerPopover == nil) {
        [_RshipTypePicker loadData:numberIntInternalStaff];
        _RshipTypePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_RshipTypePicker];
        [_RshipTypePickerPopover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    /*} else {
        [_RshipTypePickerPopover dismissPopoverAnimated:YES];
        _RshipTypePickerPopover = nil;
    }*/
    
    
    
}


- (void)OccupCodeSelected:(NSString *)OccupCode
{
    
    occuCode = OccupCode;
    [self getOccLoadExist];
    LAOccLoadingField.text = [NSString stringWithFormat:@"%@",occLoading];
    
    if (occCPA_PA == 0) {
        LACPAField.text = @"D";
    } else {
        LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
    }
    
    if (occPA == 0) {
        LAPAField.text = @"D";
    } else {
        LAPAField.text = [NSString stringWithFormat:@"%d",occPA];
    }
}

- (void)OccupDescSelected:(NSString *)color {
    [btnOccp setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", color]forState:UIControlStateNormal];
    [self.OccupationListPopover dismissPopoverAnimated:YES];
}

-(void)OccupClassSelected:(NSString *)OccupClass{
	
}

#pragma mark - Memory management
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverController = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == LANameField)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        /*NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz./@'()-"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]) && newLength <= 40);*/
        return (newLength <= 40);
    }

    return YES;
}

- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setDelegate:nil];
    [self setRequestSINo:nil];
    [self setRequestCommDate:nil];
    [self setRequestSex:nil];
    [self setRequestSmoker:nil];
    [self setGetSINo:nil];
    [self setProspectList:nil];
    [self setLADate:nil];
    [self setProspectPopover:nil];
    [self setDatePopover:nil];
    [self setMyScrollView:nil];
    [self setPopOverController:nil];
    [self setLANameField:nil];
    [self setSexSegment:nil];
    [self setSmokerSegment:nil];
    [self setLAAgeField:nil];
    [self setLAOccLoadingField:nil];
    [self setLACPAField:nil];
    [self setLAPAField:nil];
    [self setBtnCommDate:nil];
    [self setStatusLabel:nil];
    [self setMyToolBar:nil];
    [self setSINo:nil];
    [self setCustCode:nil];
    [self setClientName:nil];
    [self setOccuCode:nil];
    [self setOccuDesc:nil];
    [self setBasicSINo:nil];
    [self setGetHL:nil];
    [self setGetTempHL:nil];
    [self setYearlyIncome:nil];
    [self setCashDividend:nil];
    [self setPlanCode:nil];
    [self setSmoker:nil];
    [self setSex:nil];
    [self setDOB:nil];
    [self setCommDate:nil];
    [self setJobDesc:nil];
    [self setCustCode2:nil];
    [self setPayorSINo:nil];
    [self setPayorCustCode:nil];
    [self setOccDesc:nil];
    [self setOccCode:nil];
    [self setNamePP:nil];
    [self setGenderPP:nil];
    [self setDOBPP:nil];
    [self setOccpCodePP:nil];
    [self setArrExistRiderCode:nil];
    [self setPlanChoose:nil];
    [self setBtnDOB:nil];
    [self setBtnOccp:nil];
    [self setBtnProspect:nil];
    [self setBtnEnabled:nil];
    [self setBtnEnabled:nil];
    [self setBtnProspect:nil];
    [self setBtnToEAPP:nil];
    [self setOutletDone:nil];
    [super viewDidUnload];
}

@end
