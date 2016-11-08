//
//  SecondLAViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/31/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SecondLAViewController.h"
#import "MainScreen.h"
#import "AppDelegate.h"
#import "ColorHexCode.h"
#import "TabValidation.h"
#import "UIView+viewRecursion.h"

#import "LoginDBManagement.h"
@interface SecondLAViewController (){
    ColorHexCode *CustomColor;
    int clientProfileID;
}

@end

NSString *gNameSecond = @"";

@implementation SecondLAViewController
@synthesize nameField,msgAge;
@synthesize sexSegment;
@synthesize smokerSegment;
@synthesize ageField;
@synthesize OccpLoadField;
@synthesize CPAField;
@synthesize PAField,diffDaysValiation;
@synthesize sex,smoker,DOB,jobDesc,age,ANB,OccpCode,occLoading,SINo,CustLastNo,CustDate,CustCode,clientName,clientID,OccpDesc,occCPA_PA, occuCode,occuDesc;
@synthesize popOverController,requestSINo,la2ndHand,basicHand;
@synthesize ProspectList = _ProspectList;
@synthesize prospectPopover = _prospectPopover;
@synthesize CheckRiderCode,IndexNo;
@synthesize NamePP,DOBPP,GenderPP,OccpCodePP;
@synthesize DOBField,OccpField,deleteBtn,getCommDate,dataInsert;
@synthesize delegate = _delegate;
@synthesize getSINo,getLAIndexNo,requestLAIndexNo,occPA,occuClass, LAView, Change;
@synthesize LADate = _LADate;
@synthesize dobPopover = _dobPopover;
@synthesize btnDOB, btnOccp;
@synthesize saved2ndLA,requesteProposalStatus, EAPPorSI, outletDone, outletProspect, outletQQ, outletEAPP;
@synthesize navigationBar;

id temp;
id dobtemp;
- (void)viewDidLoad
{
    [super viewDidLoad];
    CustomColor = [[ColorHexCode alloc] init ];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	
    _modelSIPOData = [[ModelSIPOData alloc]init];
    
    self.view.backgroundColor=[UIColor whiteColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
	if ([requesteProposalStatus isEqualToString:@"Failed"] ||
		[requesteProposalStatus isEqualToString:@"Confirmed"] || [requesteProposalStatus isEqualToString:@"Submitted"] ||
		[requesteProposalStatus isEqualToString:@"Received"] || [EAPPorSI isEqualToString:@"eAPP"] || [requesteProposalStatus isEqualToString:@"Created_View"] ||
        [requesteProposalStatus isEqualToString:@"Created"]) {
		Editable = NO;
	} else {
		Editable = YES;
	}
    
    [nameField setDelegate:self];
    [ageField setDelegate:self];
    [OccpLoadField setDelegate:self];
    [CPAField setDelegate:self];
    [PAField setDelegate:self];
    [DOBField setDelegate:self];
    [OccpField setDelegate:self];
	
    inserted = NO;    
    saved2ndLA = FALSE;
    
    [deleteBtn setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.shadowColor = [UIColor lightGrayColor];
    deleteBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
//	btnDOB.enabled = FALSE;
//	btnOccp.enabled = FALSE;
    
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(hideKeyboard)];
	tap.cancelsTouchesInView = NO;
	tap.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tap];
	
    if (requestSINo) {
        [self checkingExisting];
        if (SINo.length != 0) {
            [self getProspectData];
            [self getSavedField];
            self.deleteBtn.hidden = NO;
        }
    }
    
    outletEAPP.title = @"";
    outletEAPP.enabled = FALSE;
    
	if (Editable == NO) {
		[self DisableTextField:nameField ];
		[self DisableTextField:ageField ];
		[self DisableTextField:CPAField ];
		[self DisableTextField:PAField ];
		[self DisableTextField:OccpField];
		[self DisableTextField:OccpLoadField];
		[self DisableTextField:DOBField];
		
		outletProspect.enabled = FALSE;
		outletQQ.enabled = FALSE;
		sexSegment.enabled = FALSE;
		smokerSegment.enabled = FALSE;
		btnDOB.enabled = FALSE;
		btnOccp.enabled = TRUE;
        
        if([EAPPorSI isEqualToString:@"eAPP"]){
            outletEAPP.title = @"e-Application Checklist";
            outletEAPP.enabled = TRUE;
			outletDone.enabled = FALSE;
            if (SINo.length == 0) {
                nameField.text = @" ";
            }
        }
	}
    
    if([EAPPorSI isEqualToString:@"eAPP"]){
        [self disableFieldsForEapp];
    } else {
        outletProspect.hidden = false;
    }
    
    
    UIColor *themeColour = [UIColor colorWithRed:218.0f/255.0f green:49.0f/255.0f blue:85.0f/255.0f alpha:1];

    nameField.layer.borderColor = [themeColour CGColor];
    nameField.layer.borderWidth = 1.0f;
    
    _BtnTanggalLahir.layer.borderColor = [themeColour CGColor];
    _BtnTanggalLahir.layer.borderWidth = 1.0f;
    
    btnOccp.layer.borderColor = [themeColour CGColor];
    btnOccp.layer.borderWidth = 1.0f;
    
    ageField.layer.borderColor = [themeColour CGColor];
    ageField.layer.borderWidth = 1.0f;
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],
                                                           NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]
                                                           }];
    
    
    [self loadDataFromList];
}

- (void) checkEditingMode {
    
    LoginDBManagement *loginDB = [[LoginDBManagement alloc]init];
    NSString *EditMode = [loginDB EditIllustration:[_poDictionaryPO valueForKey:@"SINO"]];
    NSLog(@" Edit Mode second %@ : %@", EditMode, [_poDictionaryPO valueForKey:@"SINO"]);
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

-(void)setElementActive :(BOOL)active
{
    //if ([testing isEqualToString:@"Enable"])
    if (active)
    {
        //nameField.text =@"test";
        //[nameField setBackgroundColor:[UIColor whiteColor]];
        nameField.enabled = YES;
        _BtnTanggalLahir.enabled = true;
        ageField.enabled = false;
        sexSegment.enabled = true;
        btnOccp.enabled = true;
        outletProspect.enabled = false;
    }
//    else if ([testing isEqualToString:@"Disable"])
    else
    {
        
        //nameField.text = @"TestDisable";
        //[nameField setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0]];
        [nameField setBackgroundColor:[CustomColor colorWithHexString:@"EEEEEE"]];
        nameField.enabled = NO;
        _BtnTanggalLahir.enabled = false;
        ageField.enabled = false;
        sexSegment.enabled = false;
        btnOccp.enabled = false;
        outletProspect.enabled = YES;
    }
}

-(void) disableFieldsForEapp
{
    outletProspect.hidden = true;
    deleteBtn.hidden = true;
    [btnDOB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnOccp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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

- (void)viewWillAppear:(BOOL)animated
{    
    self.view.frame = CGRectMake(-5, 0, 778, 1004);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setElementActive:_quickQuoteEnabled];
    [self checkEditingMode];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)OccupClassSelected:(NSString *)OccupClass{
	
}

-(void)OccupCodeSelected:(NSString *)OccupCode{
	occuCode = OccupCode;
    OccpCode = OccupCode;
    [self getOccLoadExist];
    OccpLoadField.text = [NSString stringWithFormat:@"%@",occLoading];
    
    if (occCPA_PA == 0) {
        CPAField.text = @"D";
    }
    else {
        CPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
    }
    
    if (occPA == 0) {
        PAField.text = @"D";
    }
    else {
        PAField.text = [NSString stringWithFormat:@"%d",occPA];
    }
}

-(void)OccupDescSelected:(NSString *)OccupDesc{
   // btnOccp.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    [btnOccp setTitle:OccupDesc forState:UIControlStateNormal];
    [self.OccupationListPopover dismissPopoverAnimated:YES];
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB{
	if (date1) {
        if (aDate == NULL) {
            [btnDOB setTitle:dobtemp forState:UIControlStateNormal];
            DOB = dobtemp;
            [self calculateAge];
            ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
            
        } else {
            [btnDOB setTitle:aDate forState:UIControlStateNormal];
            DOB = aDate;
            [_BtnTanggalLahir setTitle:aDate forState:UIControlStateNormal];
            [self calculateAge];
            ageField.text = [[NSString alloc] initWithFormat:@"%d",bAge];
        }
        

      //  _BtnTanggalLahir.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];

        self.btnDOB.titleLabel.textColor = [UIColor blackColor];
        [self.dobPopover dismissPopoverAnimated:YES];
        date1 = NO;
    }
}

-(void)getSavedField
{
    BOOL valid = TRUE;
    if (![NamePP isEqualToString:clientName]) {
        valid = FALSE;
    }
    
	if (![[GenderPP substringToIndex:1] isEqualToString:[sex substringToIndex:1]]) {
        valid = FALSE;
    }
    
    if (![DOB isEqualToString:DOBPP]) {
        valid = FALSE;
    }
    
    if (![OccpCode isEqualToString:OccpCodePP]) {
        valid = FALSE;
    }
	
    if (valid) {		
        nameField.text = clientName;
		gNameSecond = clientName;
        DOBField.text = [[NSString alloc] initWithFormat:@"%@",DOB];
		[btnDOB setTitle:DOB forState:UIControlStateNormal];
        ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
        
        if ([sex isEqualToString:@"M"] || [sex isEqualToString:@"MALE"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else  {
            sexSegment.selectedSegmentIndex = 1;
        }
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else {
            smokerSegment.selectedSegmentIndex = 1;
        }
        
        [self getOccLoadExist];
        OccpField.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
		[btnOccp setTitle:OccpDesc forState:UIControlStateNormal ];
        OccpLoadField.text = [NSString stringWithFormat:@"%@",occLoading];
        
        if (occCPA_PA == 0) {
            CPAField.text = @"D";
        } else {
            CPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
            PAField.text = @"D";
        } else {
            PAField.text = [NSString stringWithFormat:@"%d",occPA];
        }
        
		[_delegate LA2ndIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
        AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        del.SICompleted = YES;
		Change = @"no";
        
    } else {        
        nameField.text = NamePP;
		gNameSecond = NamePP;
        sex = [GenderPP substringToIndex:1];
        [self setSexToGlobal];
		
        if ([sex isEqualToString:@"M"] || [sex isEqualToString:@"MALE"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else {
            sexSegment.selectedSegmentIndex = 1;
        }
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else {
            smokerSegment.selectedSegmentIndex = 1;
        }
        
        DOBField.text = [[NSString alloc] initWithFormat:@"%@",DOBPP];
        DOB = DOBPP;
        [self calculateAge];
        ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
        
        OccpCode = OccpCodePP;
        [self getOccLoadExist];
        OccpField.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
        OccpLoadField.text = [NSString stringWithFormat:@"%@",occLoading];
        
        if (occCPA_PA == 0) {
            CPAField.text = @"D";
        } else {
            CPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
            PAField.text = @"D";
        } else {
            PAField.text = [NSString stringWithFormat:@"%d",occPA];
        }
        
		if ([LAView isEqualToString:@"1"] ) {
			[self updateData];
			[self CheckValidRider];
			Change = @"yes";
			[_delegate RiderAdded];
		} else {
            [self updateData];
			[self CheckValidRider];
			[_delegate RiderAdded];
		}		
    }
}

#pragma mark - Data Load from listing added by faiz
-(void)loadDataFromList{
    @try {
        _modelSIPOData = [[ModelSIPOData alloc]init];
        NSDictionary* dictPOData=[[NSDictionary alloc]initWithDictionary:[_modelSIPOData getPO_DataFor:[self.requestSINo description]]];
        if (![[dictPOData valueForKey:@"RelWithLA"] isEqualToString:@"DIRI SENDIRI"]){
            if ([dictPOData count]!=0){
                occuCode = [dictPOData valueForKey:@"LA_OccpCode"];
                clientProfileID = [[dictPOData valueForKey:@"LA_ClientID"] intValue];
                [nameField setText:[dictPOData valueForKey:@"LA_Name"]];
                [ageField setText:[dictPOData valueForKey:@"LA_Age"]];
                if (([[dictPOData valueForKey:@"LA_DOB"] isEqualToString:@""])||(![dictPOData objectForKey:@"LA_DOB"])){
                    [_BtnTanggalLahir setTitle:@"--Please Select--" forState:UIControlStateNormal];
                }
                else{
                    [_BtnTanggalLahir setTitle:[dictPOData valueForKey:@"LA_DOB"] forState:UIControlStateNormal];
                }
                if (([[dictPOData valueForKey:@"LA_Occp"] isEqualToString:@""])||(![dictPOData objectForKey:@"LA_Occp"])){
                    [btnOccp setTitle:@"--Please Select--" forState:UIControlStateNormal];
                }
                else{
                    [btnOccp setTitle:[dictPOData valueForKey:@"LA_Occp"] forState:UIControlStateNormal];
                }
                
                
                sex=[[NSString alloc]initWithString:[dictPOData valueForKey:@"LA_Gender"]];
                if ([sex length]>0){
                    if ([sex isEqualToString:@"MALE"]){
                        [sexSegment setSelectedSegmentIndex:0];
                    }
                    else{
                        [sexSegment setSelectedSegmentIndex:1];
                    }
                }
                else{
                    [sexSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
                }
                
                
                DOB = _BtnTanggalLahir.titleLabel.text;
                [self calculateAge];
            }

        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)passValidationCheck{
    if(![_BtnTanggalLahir.titleLabel.text isEqualToString:@"--Please Select--"] && ![nameField.text isEqualToString:@""]&& ![btnOccp.titleLabel.text isEqualToString:@"--Please Select--"] && !sexSegment.selected){
            [[TabValidation sharedMySingleton] setValidTab2:TRUE];
    }
}

#pragma mark - action
- (IBAction)ActionEAPP:(id)sender {
    [_delegate dismissEApp];
}

- (IBAction)doSelectProspect:(id)sender
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

- (IBAction)sexSegmentChange:(id)sender
{
    if ([sexSegment selectedSegmentIndex]==0) {
        sex = @"MALE";
    } else if (sexSegment.selectedSegmentIndex == 1) {
        sex = @"FEMALE";
    }
    
    appDelegate.isNeedPromptSaveMsg = YES;
    //    [self getSmoker];
}

- (IBAction)smokerSegmentChange:(id)sender
{
    if ([smokerSegment selectedSegmentIndex]==0) {
        smoker = @"Y";
    } else if (smokerSegment.selectedSegmentIndex == 1) {
        smoker = @"N";
    }
    appDelegate.isNeedPromptSaveMsg = YES;
	
}

-(void) getSmoker
{
    if ([smokerSegment selectedSegmentIndex]==0) {
        smoker = @"Y";
    } else if (smokerSegment.selectedSegmentIndex == 1) {
        smoker = @"N";
    }
    appDelegate.isNeedPromptSaveMsg = YES;
}

-(IBAction)enableFields:(id)sender{
	if (QQProspect) {        
        nameField.enabled = NO;
        nameField.backgroundColor = [UIColor lightGrayColor];
        nameField.textColor = [UIColor darkGrayColor];
        sexSegment.enabled = NO;
        btnDOB.enabled = NO;
        self.btnDOB.titleLabel.textColor = [UIColor darkGrayColor];
        btnOccp.enabled = NO;
        self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
        [_delegate setIsSecondLaNeeded:NO];
        QQProspect = NO;
    } else {
        
        nameField.enabled = YES;
        nameField.backgroundColor = [UIColor clearColor];
        nameField.textColor = [UIColor blackColor];
        sexSegment.enabled = YES;
        smokerSegment.enabled = YES;
        btnDOB.enabled = YES;
        self.btnDOB.titleLabel.textColor = [UIColor blackColor];
        btnOccp.enabled = YES;
        self.btnOccp.titleLabel.textColor = [UIColor blackColor];
        [_delegate setIsSecondLaNeeded:YES];
		QQProspect = YES;
    }
    
    nameField.text = @"";
    sexSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    smokerSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    btnDOB.titleLabel.text = @"";
    ageField.text = @"";
    btnOccp.titleLabel.text = @"";
    OccpLoadField.text = @"";
    CPAField.text = @"";
    PAField.text = @"";
    [_delegate setIsSecondLaNeeded:YES];
}

-(IBAction)btnOccpPressed:(id)sender{
	[self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_OccupationList == nil) {
        self.OccupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
        _OccupationList.delegate = self;
        self.OccupationListPopover = [[UIPopoverController alloc] initWithContentViewController:_OccupationList];
    }
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 70;
    
	[self.OccupationListPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(IBAction)btnDOBPressed:(UIButton *)sender{
	[self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    date1 = YES;
    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    self.LADate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    _LADate.delegate = self;
    _LADate.msgDate = sender.titleLabel.text;
    _LADate.btnSender = 1;
    
    self.dobPopover = [[UIPopoverController alloc] initWithContentViewController:_LADate];
    
    [self.dobPopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.dobPopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

-(void)setPODictionaryRegular:(NSMutableDictionary *)dictionaryRootPO{
    _poDictionaryPO=dictionaryRootPO;
}

-(void)setPODictionaryFromRoot:(NSMutableDictionary *)dictionaryRootPO originalRelation:(NSString *)OriginalRelation{
    if ([_poDictionaryPO count]>0){
        if (![[_poDictionaryPO valueForKey:@"RelWithLA"] isEqualToString:[dictionaryRootPO valueForKey:@"RelWithLA"]]){
            [self resetField];
            _poDictionaryPO=dictionaryRootPO;
        }
        else{
            _poDictionaryPO=dictionaryRootPO;
        }
    }
    else{
        if (OriginalRelation){
            if (![OriginalRelation isEqualToString:[dictionaryRootPO valueForKey:@"RelWithLA"]]){
                [self resetField];
                _poDictionaryPO=dictionaryRootPO;
            }
            else{
                _poDictionaryPO=dictionaryRootPO;
            }
        }
        else{
            _poDictionaryPO=dictionaryRootPO;
        }
    }
}

-(NSMutableDictionary *)setDictionarySecondLA{
    NSNumber *numberIntClientProfile;
    
    if ([sexSegment selectedSegmentIndex]==0) {
        sex = @"MALE";
    } else if (sexSegment.selectedSegmentIndex == 1) {
        sex = @"FEMALE";
    }
    
    if (_quickQuoteEnabled){
        clientProfileID = -1;
    }
    
    numberIntClientProfile = [NSNumber numberWithInt:clientProfileID];
    NSLog(@"nameField %@",nameField.text);
    
    NSString *laDOB=[_BtnTanggalLahir.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *occupationDesc=btnOccp.titleLabel.text;
    NSMutableDictionary *dictionaryNewLA=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          numberIntClientProfile,@"LA_ClientID",
                                          nameField.text,@"LA_Name",
                                          laDOB,@"LA_DOB",
                                          ageField.text,@"LA_Age",
                                          sex,@"LA_Gender",
                                          occuCode,@"LA_OccpCode",
                                          occupationDesc,@"LA_Occp",nil];
    return dictionaryNewLA;
}

- (IBAction)doSave:(id)sender
{
    //[_delegate saveAll];
    if ([self validateSave]){
        [self passValidationCheck];
        [_delegate saveSecondLA:[self setDictionarySecondLA]];
    }
}

/*- (IBAction)doSave:(id)sender
{
    //[_delegate saveAll];
    if ([self validateSave]){
        NSNumber *numberIntClientProfile;
        if (_quickQuoteEnabled){
            clientProfileID = -1;
        }

        numberIntClientProfile = [NSNumber numberWithInt:clientProfileID];
        
        NSString *laDOB=[_BtnTanggalLahir.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *occupationDesc=[btnOccp.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSMutableDictionary *dictionaryNewLA=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                              numberIntClientProfile,@"LA_ClientID",
                                              nameField.text,@"LA_Name",
                                              laDOB,@"LA_DOB",
                                              ageField.text,@"LA_Age",
                                              sex,@"LA_Gender",
                                              occuCode,@"LA_OccpCode",
                                              occupationDesc,@"LA_Occp",nil];
        [self passValidationCheck];
        [_delegate saveSecondLA:dictionaryNewLA];
    }
}*/

- (IBAction)doDelete:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Delete 2nd Life Assured:%@?",nameField.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
    [alert setTag:1002];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0)
    {
        if (self.requestSINo) {
            if (SINo.length > 0) {
                [self updateData];
				[self CheckValidRider];
				[_delegate RiderAdded];
				
            } else {
                [self saveData];
            }
        } else {
            [self save2ndLAHandler];
        }
        
    } else if (alertView.tag == 1002 && buttonIndex == 0) { //delete
        [self deleteSecondLA];//delete from database
        
    }
    else if (alertView.tag==1004 && buttonIndex == 0) {        
        if (smoker.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            [self updateData];
			[self CheckValidRider];
			[_delegate RiderAdded];
        }
    }
}

-(BOOL)calculateAge
{
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSArray *comm = [dateString componentsSeparatedByString: @"/"];
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
        
        NSDate *endDate = [dateFormatter dateFromString:dateString];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
        msgAge = [[NSString alloc] initWithFormat:@"%d days",diffDays];
        
        age = 0;
        ANB = 1;
    } else {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = DOB;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSDate *endDate = [dateFormatter dateFromString:dateString];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        
    age = 0;
        ANB = 1;
    }
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *selectDate = DOB;
    NSDate *startDate = [dateFormatter dateFromString:selectDate];
    
    NSDate *endDate = [dateFormatter dateFromString:dateString];
    
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
    diffDaysValiation = [difference day];
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return YES;
}
-(void)textFieldDidChange:(UITextField*)textField
{
    appDelegate.isNeedPromptSaveMsg = YES;
}

-(int)get1stLAIndexNo
{
    NSString *sql = [NSString stringWithFormat:@"SELECT b.IndexNo FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",[self.requestSINo description]];
    
    int returnInt = -1;
    sqlite3_stmt *statement;    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        if (sqlite3_prepare_v2(contactDB, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                returnInt = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    return returnInt;
}

#pragma mark - Length Check
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == nameField)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        /*NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz./@'()-"] invertedSet];
         NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
         return (([string isEqualToString:filtered]) && newLength <= 40);*/
        return (newLength <= 40);
    }
    return YES;
}

#pragma mark - delegate

-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    if([aaDOB length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"The selected client is not applicable for this SI product."
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		alert = Nil;
        return;
    }
    
    saved2ndLA = FALSE;
    
    if (sex != NULL) {
        sex = nil;
        smoker = nil;
    }
    smoker = @"N";
    prevIndexNo = IndexNo;
    BOOL isValid = TRUE;
    if (getLAIndexNo == [aaIndex intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"This Life Assured has already been attached to the plan." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ]; //firstLAsex
        IndexNo = [aaIndex intValue];
        if( [[del.firstLAsex substringToIndex:1] isEqualToString:[aaGender substringToIndex:1]] && ([del.planChoose isEqualToString:@"S100"] || [del.planChoose isEqualToString:@"L100"]))
        {
            IndexNo = prevIndexNo;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"The Second Life Assured cannot be the same sex as the First Life Assured." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
//            [self deleteLA];
            clientProfileID = [aaIndex intValue];
            nameField.enabled = NO;
//            nameField.backgroundColor = [UIColor lightGrayColor];
            nameField.textColor = [UIColor darkGrayColor];
            sexSegment.enabled = NO;
            
            btnDOB.enabled = NO;
            self.btnDOB.titleLabel.textColor = [UIColor darkGrayColor];
            
            btnOccp.enabled = NO;
            self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
            QQProspect = NO;
            
            nameField.text = aaName;
            gNameSecond = aaName;
            sex = [aaGender substringToIndex:1];
            [self setSexToGlobal];
            
            sexSegment.enabled = FALSE;
            if ([sex isEqualToString:@"M"] || [sex isEqualToString:@"MALE"]) {
                sexSegment.selectedSegmentIndex = 0;
                sex =@"MALE";
            } else {
                sexSegment.selectedSegmentIndex = 1;
                sex =@"FEMALE";
            }
            
           // DOBField.text = [[NSString alloc] initWithFormat:@"%@",aaDOB];
            [_BtnTanggalLahir setTitle:aaDOB forState:UIControlStateNormal];
            DOB = aaDOB;
            isValid = [self calculateAge];
            ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
            
            OccpCode = aaCode;
            occuCode = aaCode;
            [self getOccLoadExist];
            OccpField.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
            [btnOccp setTitle:OccpDesc forState:UIControlStateNormal];
           
            
            [_delegate saved:YES];
        }
        
                [_delegate setIsSecondLaNeeded:YES];
        [_prospectPopover dismissPopoverAnimated:YES];
        
    }
}

-(void) setSexToGlobal
{
    AppDelegate *del= (AppDelegate*)[[UIApplication sharedApplication] delegate ];  
    del.secondLAsex = sex;
}

#pragma mark - db handle

-(void)getRunningCustCode
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\""];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustLastNo = sqlite3_column_int(statement, 0);
                CustDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(NSString *)get2ndLACustCode
{
    NSString *sql = [NSString stringWithFormat:@"select custcode from trad_lapayor where SINo=\"%@\" and sequence='2'", requestSINo];
    
    sqlite3_stmt *statement;
    NSString *toReturn = nil;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        if (sqlite3_prepare_v2(contactDB, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                toReturn = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return toReturn;
}

-(void)saveData
{
    [self getSmoker];
	if (QQProspect) {
        [self insertClient];
    }
    
    [self getRunningCustCode];
    
    //generate CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
    
    SINo = [self.requestSINo description];
    CustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    [self updateRunCustCode];
    [self deleteLA];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
							   @"INSERT INTO Trad_LAPayor (SINo, CustCode, PTypeCode, Sequence, DateCreated, CreatedBy) VALUES (\"%@\",\"%@\",\"LA\",\"2\",\"%@\",\"hla\")",
                               SINo, CustCode, dateStr];
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        
        insertSQL = [NSString stringWithFormat:
								@"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy,indexNo) "
								"VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")",
								CustCode, nameField.text, smoker, [sex substringToIndex:1], DOB, age, ANB, OccpCode, dateStr,IndexNo];
        
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [_delegate LA2ndIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
                [_delegate saved:YES];
            } else {
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    self.deleteBtn.hidden = NO;
    
    saved2ndLA = TRUE;
}

-(void)save2ndLAHandler
{
	if(QQProspect == TRUE) {
		[self insertClient];
	}
    [self getSmoker];
	
    [_delegate LA2ndIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
    self.deleteBtn.hidden = NO;
    inserted = YES;
    [_delegate saved:YES];
}

-(void)updateRunCustCode
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingExisting
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id, b.IndexNo FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",getSINo];
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
                OccpCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                clientID = sqlite3_column_int(statement, 8);
                IndexNo = sqlite3_column_int(statement, 9);
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
                              @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode, QQFlag  FROM prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NamePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                DOBPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                GenderPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                OccpCodePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
				
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
    
    results = [db executeQuery:@"SELECT OccpDesc from eProposal_OCCP WHERE occp_Code = ?", OccpCode, Nil];
    while ([results next]) {
        NSString *occpDesc = [results stringForColumn:@"OccpDesc"] != NULL ? [results stringForColumn:@"OccpDesc"] : @"";
        OccpDesc = occpDesc;
    }
    [db close];
}

-(BOOL)updateData
{
	[self getSmoker];
    
	if (QQProspect == TRUE) {
		[self UpdateClient];
	}
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Clt_Profile SET Name=\'%@\', Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", "
                              "DateModified=\"%@\", ModifiedBy=\"hla\", indexNo=\"%d\" WHERE  WHERE SINo='%@' AND Sequence=2",
							  gNameSecond,smoker,[sex substringToIndex:1],DOB,age,ANB,OccpCode,currentdate,IndexNo,SINo];
		
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [_delegate LA2ndIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
                [_delegate saved:YES];
                
            } else {
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
                return NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return YES;
}

-(void)CheckValidRider
{
    
    sqlite3_stmt *statement;
	BOOL popMsg = FALSE;
	
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
		if ([OccpCode isEqualToString:@"OCC01975"]) {
			NSString *querySQL = [NSString stringWithFormat:@"Select * From trad_Rider_Details where SINO = \"%@\" AND RiderCode in ('LCWP', 'PR', 'SP_PRE', 'SP_STD') ", SINo];
			if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{
				if (sqlite3_step(statement) == SQLITE_ROW)
				{
					popMsg = TRUE;
				}
				
				sqlite3_finalize(statement);
			}
			
			if (popMsg == TRUE) {
				querySQL = [NSString stringWithFormat:@"DELETE From trad_Rider_Details where SINO = \"%@\" AND RiderCode in ('LCWP', 'PR', 'SP_PRE', 'SP_STD') ", SINo];
				
				if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
				{
					sqlite3_step(statement);
					sqlite3_finalize(statement);
					
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Some Rider(s) has been deleted due to marketing rule." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
					[alert show];
				}
			}
		}
        sqlite3_close(contactDB);
		
    }
}

-(void)deleteLA
{
    NSString *secondLACustCode = [self get2ndLACustCode];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_LAPayor WHERE CustCode=\"%@\"",secondLACustCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
        
        querySQL = [NSString stringWithFormat:@"DELETE FROM Clt_Profile WHERE CustCode=\"%@\"",secondLACustCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) != SQLITE_DONE) {
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in deleting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    self.deleteBtn.hidden = YES;
}

-(void)checkingRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,SumAssured,RiderTerm,Units FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"LA\" AND Seq=\"2\"",requestSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                CheckRiderCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"LA\" AND Seq=\"2\"",requestSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)resetField
{
    nameField.text = @"";
    gNameSecond = @"";
    [sexSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    DOBField.text = @"";
    ageField.text = @"";
    OccpField.text = @"";
    OccpLoadField.text = @"";
    CPAField.text = @"";
    PAField.text = @"";
    
    occuCode = @"";
    clientProfileID = -1;
    [nameField setText:@""];
    [ageField setText:@""];
    [_BtnTanggalLahir setTitle:@"--Please Select--" forState:UIControlStateNormal];
    [btnOccp setTitle:@"--Please Select--" forState:UIControlStateNormal];
    sex=@"";
    [sexSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    DOB = @"";
}

-(void)insertClient
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL3 = [NSString stringWithFormat:
                                @"INSERT INTO prospect_profile(\"ProspectName\", \"ProspectDOB\", \"ProspectGender\", \"ProspectOccupationCode\", \"DateCreated\", \"CreatedBy\", \"DateModified\",\"ModifiedBy\", \"Smoker\", 'QQFlag') "
                                "VALUES (\"%@\", \"%@\", \"%@\", \"%@\", %@, \"%@\", \"%@\", \"%@\", \"%@\", '%@')",
								nameField.text, DOB, sex, occuCode, @"datetime(\"now\", \"+8 hour\")", @"1", @"", @"1", smoker, @"true"];
        
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
		if (sexSegment.selectedSegmentIndex == 0) {
			sex = @"MALE";
		} else {
			sex = @"FEMALE";
		}
		
		NSString *insertSQL3 = [NSString stringWithFormat:
								@"Update prospect_profile Set ProspectName = '%@', ProspectDOB = '%@', ProspectGender = '%@', "
								" ProspectOccupationCode = '%@', DateModified='%@', ModifiedBy='%@', Smoker= '%@' WHERE indexNo = '%d' ",
								nameField.text, DOB, sex, occuCode, @"datetime(\"now\", \"+8 hour\")", @"1", smoker, IndexNo];
		
		if(sqlite3_prepare_v2(contactDB, [insertSQL3 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			sqlite3_step(statement);
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
	
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


#pragma mark - VALIDATION
-(void)deleteSecondLA
{
    if (self.requestSINo) {
        [self checkingRider];
        [self deleteLA];
        if (CheckRiderCode.length != 0) {
            [self deleteRider];
            [_delegate RiderAdded];
        }
        [self resetField];
    } else {
        [self resetField];
        self.deleteBtn.hidden = YES;
    }
	
    [_delegate secondLADelete];
}

- (void)createAlertViewAndShow:(NSString *)message tag:(int)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                    message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = alertTag;
    [alert show];
}


- (bool)validationDataLifeAssured{
    bool valid=true;
    NSString *PlanTypeProduct = [_poDictionaryPO valueForKey:@"ProductName"];

    NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@" - SELECT -",@"- SELECT -",@"- Select -",@"--Please Select--", nil];
    int DOBDate =[msgAge intValue];
    //validation message data refferal
    NSString *validationNamaTertanggung=@"Nama Tertanggung harus diisi";
    NSString *validationTanggalLahir=@"Tanggal Lahir Tertanggung harus diisi";
    NSString *validationJenisKelamin=@"Jenis Kelamin Tertanggung harus diisi";
    NSString *validationPekerjaan=@"Pekerjaan Tertanggung harus diisi";
    NSString *validation70=@"Usia tidak boleh lebih dari 70 tahun";
    NSString *validation180=@"Usia tidak boleh kurang dari 180 hari atau lebih dari 55 tahun";
    NSString *validation180Heritage=@"Usia tidak boleh kurang dari 180 hari atau lebih dari 70 tahun";
    NSString *validationUsiaSuamiIstri=@"Usia tidak boleh kurang dari 19 atau lebih dari 55 tahun";
    NSString *validationUsiaParents=@"Usia tidak boleh kurang dari 180 hari atau lebih dari 18 tahun";
    NSString *validationOthers=@"Usia tidak boleh kurang dari 18 tahun atau lebih dari 55 tahun";
    
    //outletkodecabang
    NSString* namaTertangggung=nameField.text;
    //outletnamacabang
    NSString* tanggalLahir=_BtnTanggalLahir.titleLabel.text;
    //segmen jenis kelamin
    //segGender.selectedSegmentIndex
    //occupation
    NSString* occupation=btnOccp.titleLabel.text;
    
    if ([validationSet containsObject:namaTertangggung]||namaTertangggung==NULL){
        [self createAlertViewAndShow:validationNamaTertanggung tag:0];
        [nameField becomeFirstResponder];
        return false;
    }
    /*else if(age >70)
    {
        [self createAlertViewAndShow:validation70 tag:0];
        //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
        return false;
    }
    else if(diffDaysValiation <180)
    {
        [self createAlertViewAndShow:validation180 tag:0];
        //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
        return false;
    }*/
    
    else if ([validationSet containsObject:tanggalLahir]||tanggalLahir==NULL){
        [self createAlertViewAndShow:validationTanggalLahir tag:0];
       // [_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
        return false;
    }
    
    else if (sexSegment.selectedSegmentIndex == -1){
        [self createAlertViewAndShow:validationJenisKelamin tag:0];
        return false;
    }
    
    else if (sexSegment.selectedSegmentIndex==UISegmentedControlNoSegment){
        [self createAlertViewAndShow:validationJenisKelamin tag:0];
        return false;
    }
    
    else if ([validationSet containsObject:occupation]||occupation==NULL){
        [self createAlertViewAndShow:validationPekerjaan tag:0];
        //[btnOccp setBackgroundColor:[UIColor redColor]];
        return false;
    }
    else if ([validationSet containsObject:occupation]||occupation==NULL)
    {
        
    }
    
    else if(([PlanTypeProduct isEqualToString:@"BCA Life Heritage Protection"])||([PlanTypeProduct isEqualToString:@"BCA Life Heritage Protection – For BCA Staff"])){
         if(age >70)
         {
             [self createAlertViewAndShow:validation70 tag:0];
         //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
             return false;
         }
         else if(diffDaysValiation <180)
         {
             [self createAlertViewAndShow:validation180Heritage tag:0];
         //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
             return false;
         }
    }
    else if(([PlanTypeProduct isEqualToString:@"BCA Life Heritage Protection"])||([PlanTypeProduct isEqualToString:@"BCA Life Heritage Protection – For BCA Staff"])){
        if(age >70)
        {
            [self createAlertViewAndShow:validation70 tag:0];
            //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
            return false;
        }
        else if(diffDaysValiation <180)
        {
            [self createAlertViewAndShow:validation180Heritage tag:0];
            //[_BtnTanggalLahir setBackgroundColor:[UIColor redColor]];
            return false;
        }
    }
    
    else if([PlanTypeProduct isEqualToString:@"BCA Life Keluargaku"]){
        if ([[_poDictionaryPO valueForKey:@"RelWithLA"] isEqualToString:@"ORANG TUA"]){
            if ((diffDaysValiation <180)||(age >18)){
                [self createAlertViewAndShow:validationUsiaParents tag:0];
                return false;
            }
        }
        
        else if ([[_poDictionaryPO valueForKey:@"RelWithLA"] isEqualToString:@"SUAMI/ISTRI"]){
            if ((age <19)||(age >55)){
                [self createAlertViewAndShow:validationUsiaSuamiIstri tag:0];
                return false;
            }
        }
        
        else if ((![[_poDictionaryPO valueForKey:@"RelWithLA"] isEqualToString:@"ORANG TUA"])&&(![[_poDictionaryPO valueForKey:@"RelWithLA"] isEqualToString:@"SUAMI/ISTRI"])){
            if ((age <18)||(age >55)){
                [self createAlertViewAndShow:validationOthers tag:0];
                return false;
            }
        }
    }
    
    
    
    return valid;
}

-(BOOL)validateSave
{
    /*if (nameField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"2nd Life Assured Name is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else if (OccpCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Please select an Occupation Description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else if (smoker.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else if (age < 16) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be at least 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else {
        return YES;
    }*/
    if (_quickQuoteEnabled){
        return [self validationDataLifeAssured];
    }
    else{
        return [self validationDataLifeAssured];
    }
    return NO;
}
#pragma mark - STORE 2nd LA BEFORE SAVE INTO DATABASE
-(BOOL)performUpdateData//update second la while looping all section
{
	if (self.requestSINo) {
		if (SINo.length > 0) {
			[self updateData];
			[self CheckValidRider];
			[_delegate RiderAdded];
            
		} else {
			if( !saved2ndLA ) {
                [self saveData];
            }
		}
		return YES;
	} else {
		[self save2ndLAHandler];
		return YES;
	}
    return NO;
    
}

-(void)storeData
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    if (!siObj) {
        siObj = [[SIObj alloc]init];
    }
    siObj.name = gNameSecond;
    siObj.smoker = smoker;
    siObj.sex = sex;
    siObj.DOB = DOB;
    siObj.age = [NSString stringWithFormat:@"%d",age];
    siObj.ANB = [NSString stringWithFormat:@"%d",ANB];
    siObj.occupationCode = OccpCode;
    siObj.dateModified = currentdate;//currentDate
    siObj.indexNo = [NSString stringWithFormat:@"%d",IndexNo];
    siObj.clientID = [NSString stringWithFormat:@"%d",clientID];
	
}

#pragma mark - memory management
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverController = nil;
}

- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setPopOverController:nil];
    [self setProspectList:nil];
    [self setDelegate:nil];
    [self setRequestSINo:nil];
    [self setRequestCommDate:nil];
    [self setGetSINo:nil];
    [self setGetCommDate:nil];
    [self setNameField:nil];
    [self setSexSegment:nil];
    [self setSmokerSegment:nil];
    [self setAgeField:nil];
    [self setOccpLoadField:nil];
    [self setCPAField:nil];
    [self setPAField:nil];
    [self setDOBField:nil];
    [self setOccpField:nil];
    [self setDeleteBtn:nil];
    [self setMyToolBar:nil];
    [self setSex:nil];
    [self setSmoker:nil];
    [self setDOB:nil];
    [self setJobDesc:nil];
    [self setOccpCode:nil];
    [self setSINo:nil];
    [self setCustDate:nil];
    [self setCustCode:nil];
    [self setClientName:nil];
    [self setOccpDesc:nil];
    [self setCheckRiderCode:nil];
    [self setNamePP:nil];
    [self setDOBPP:nil];
    [self setGenderPP:nil];
    [self setOccpCodePP:nil];
	[self setOutletDone:nil];
    [self setOutletProspect:nil];
    [self setOutletQQ:nil];
    [super viewDidUnload];
}


@end
