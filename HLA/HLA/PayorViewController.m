//
//  PayorViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/31/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PayorViewController.h"
#import "MainScreen.h"
#import "PayorHandler.h"
#import "AppDelegate.h"

@interface PayorViewController ()

@end

NSString *gName = @"";

@implementation PayorViewController
@synthesize nameField;
@synthesize sexSegment;
@synthesize smokerSegment;
@synthesize ageField;
@synthesize occpLoadField;
@synthesize CPAField;
@synthesize PAField;
@synthesize sex,smoker,DOB,jobDesc,age,ANB,OccpCode,occLoading,SINo,CustLastNo,CustDate,CustCode,clientName,clientID,OccpDesc,occCPA_PA, occuCode, occuDesc;
@synthesize popOverController,requestSINo,payorHand;
@synthesize ProspectList = _ProspectList;
@synthesize CheckRiderCode,DOBField,OccpField,IndexNo,requestCommDate;
@synthesize NamePP,DOBPP,GenderPP,OccpCodePP,basicHand,deleteBtn,getCommDate,dataInsert,getSINo;
@synthesize delegate = _delegate;
@synthesize getLAIndexNo,requestLAIndexNo,requestLAAge,getLAAge,occPA,occuClass, RiderToBeDeleted, LAView, Change;
@synthesize LADate = _LADate;
@synthesize btnDOB, btnOccp,requesteProposalStatus, EAPPorSI, outletDone, outletProspect, outletQQ, outletEAPP, outletSpace;

id dobtemp;
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
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
	
    [btnOccp setEnabled:FALSE];
    [smokerSegment setEnabled:FALSE];
        
    sexSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    smokerSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    nameField.enabled = NO;
    sexSegment.enabled = NO;
    ageField.enabled = NO;
    occpLoadField.enabled = NO;
    CPAField.enabled = NO;
    PAField.enabled = NO;
    DOBField.enabled = NO;
    OccpField.enabled = NO;
    self.deleteBtn.hidden = YES;
    useExist = NO;
    inserted = NO;    
    
    [nameField setDelegate:self];
    [ageField setDelegate:self];
    [occpLoadField setDelegate:self];
    [CPAField setDelegate:self];
    [PAField setDelegate:self];
    [DOBField setDelegate:self];
    [OccpField setDelegate:self];
	
    
    [deleteBtn setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.shadowColor = [UIColor lightGrayColor];
    deleteBtn.titleLabel.shadowOffset = CGSizeMake(0, -1);
	
    [self loadData];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(hideKeyboard)];
	tap.cancelsTouchesInView = NO;
	tap.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tap];    
    
    outletEAPP.title = @"";
    outletEAPP.enabled = FALSE;
	
	if (Editable == NO) {
		[self DisableTextField:nameField];
		[self DisableTextField:DOBField];
		[self DisableTextField:ageField];
		
		[self DisableTextField:occpLoadField];
		[self DisableTextField:OccpField];
		[self DisableTextField:CPAField];
		[self DisableTextField:PAField];
		sexSegment.enabled = FALSE;
		smokerSegment.enabled = FALSE;
		btnDOB.enabled = FALSE;
		btnOccp.enabled = FALSE;
		deleteBtn.enabled = FALSE;
		outletProspect.enabled = FALSE;
		outletQQ.enabled = FALSE;
        
        if ([[self.EAPPorSI description] isEqualToString:@"eAPP"]) {
            outletEAPP.title = @"e-Application Checklist";
            outletEAPP.enabled = TRUE;
            outletDone.enabled = FALSE;
		}
	}
    
    if([EAPPorSI isEqualToString:@"eAPP"]) {
        [self disableFieldsForEapp];
    } else {
        outletProspect.hidden = false;
    }
}

-(void) disableFieldsForEapp
{    
    outletProspect.hidden = true;
    deleteBtn.hidden = true;
    [btnDOB setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
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

-(void)loadData
{
    getLAIndexNo = requestLAIndexNo;
    getLAAge = requestLAAge;
    getCommDate = [self.requestCommDate description];
    getSINo = [self.requestSINo description];    
    if (self.requestSINo) {
        [self checkingExisting];
        if (SINo.length != 0) {
            [self getProspectData];
            [self getSavedField];
        } else {
            self.deleteBtn.hidden = YES;
        }
    }	
}

-(BOOL)isPayorSelected
{
    if([nameField.text isEqualToString:@""]) {
        return NO;		
    }
    return YES;
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
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
    
    if (![smoker isEqualToString:SmokerPP]) {
        valid = FALSE;
    }
    
    if (valid) {		
        nameField.text = clientName;
		gName = clientName;
        DOBField.text = [[NSString alloc] initWithFormat:@"%@",DOB];
		[btnDOB setTitle:DOB forState:UIControlStateNormal];
        ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
		
        if ([sex isEqualToString:@"M"] || [sex isEqualToString:@"MALE"] ) {
            sexSegment.selectedSegmentIndex = 0;
        } else {
            sexSegment.selectedSegmentIndex = 1;
        }		
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else {
            smokerSegment.selectedSegmentIndex = 1;
        }
        
        [self getOccLoadExist];
        OccpField.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
		[btnOccp setTitle:OccpDesc forState:UIControlStateNormal];
        occpLoadField.text = [NSString stringWithFormat:@"%@",occLoading];
		
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
        
        [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
        AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        zzz.SICompleted = YES;
        Change = @"no";
        
    } else {		
        nameField.text = NamePP;
		gName = NamePP;
        sex = [GenderPP substringToIndex:1];
        smoker = SmokerPP;
        
        if ([sex isEqualToString:@"M"] || [sex isEqualToString:@"MALE"] ) {
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
        occpLoadField.text = [NSString stringWithFormat:@"%@",occLoading];
		
        if (occCPA_PA == 0) {
            CPAField.text = @"D";
        } else {
            CPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occCPA_PA == 0) {
            PAField.text = @"D";
        } else {
            PAField.text = [NSString stringWithFormat:@"%d",occPA];
        }
        
		if ([LAView isEqualToString:@"1"] ) {
			[self updatePayor];
			[self CheckValidRider];
			Change = @"yes";
			[_delegate RiderAdded];
			
		} else {            
            [self updatePayor];
			[self CheckValidRider];
			[_delegate RiderAdded];
		}
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
        _ProspectList.ignoreID = getLAIndexNo;
        _ProspectList.filterEDD = TRUE;
        _ProspectList.delegate = self;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:_ProspectList];
    }
    
    [popOverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)btnDOBPressed:(id)sender
{
	[self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    date1 = YES;
    
    UIStoryboard *sharedStoryboard = [UIStoryboard storyboardWithName:@"SharedStoryboard" bundle:Nil];
    self.LADate = [sharedStoryboard instantiateViewControllerWithIdentifier:@"showDate"];
    _LADate.delegate = self;
    _LADate.msgDate = dobtemp;
    _LADate.btnSender = 1;
    
    self.dobPopover = [[UIPopoverController alloc] initWithContentViewController:_LADate];
    
    [self.dobPopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.dobPopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

-(IBAction)btnOccpPressed:(id)sender
{
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
	[self.OccupationListPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

-(IBAction)enableFields:(id)sender
{
	if (QQProspect) {        
        nameField.enabled = NO;
        nameField.backgroundColor = [UIColor lightGrayColor];
        nameField.textColor = [UIColor darkGrayColor];
        sexSegment.enabled = NO;
        
        btnDOB.enabled = NO;
        self.btnDOB.titleLabel.textColor = [UIColor darkGrayColor];
        
        btnOccp.enabled = NO;
        self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
        
		QQProspect = NO;
    } else {
        
        nameField.enabled = YES;
        nameField.backgroundColor = [UIColor whiteColor];
        nameField.textColor = [UIColor blackColor];
        sexSegment.enabled = YES;
        smokerSegment.enabled = YES;
        
        btnDOB.enabled = YES;
        self.btnDOB.titleLabel.textColor = [UIColor blackColor];
        
        btnOccp.enabled = YES;
        self.btnOccp.titleLabel.textColor = [UIColor blackColor];
        
		QQProspect = YES;
    }
    
    nameField.text = @"";
    sexSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    smokerSegment.selectedSegmentIndex = UISegmentedControlNoSegment;
    btnDOB.titleLabel.text = @"";
    ageField.text = @"";
    btnOccp.titleLabel.text = @"";
    occpLoadField.text = @"";
    CPAField.text = @"";
    PAField.text = @"";
}

- (IBAction)sexSegmentChange:(id)sender
{
    if ([sexSegment selectedSegmentIndex]==0) {
        sex = @"MALE";
    } else if (sexSegment.selectedSegmentIndex == 1) {
        sex = @"FEMALE";
    }
    appDelegate.isNeedPromptSaveMsg = YES;
}

- (IBAction)smokerSegmentChange:(id)sender
{
    [self getSmoker];
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

- (IBAction)doSave:(id)sender
{
    [_delegate saveAll];
}

- (IBAction)doDelete:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Delete Payor:%@?",nameField.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
    [alert setTag:2002];
    [alert show];
}

-(void) resetField
{
    nameField.text = @"";
    gName = @"";
    [sexSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    DOBField.text = @"";
    ageField.text = @"";
    OccpField.text= @"";
    occpLoadField.text = @"";
    CPAField.text = @"";
    PAField.text = @"";
	
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2001 && buttonIndex == 0) { //save
        if (self.requestSINo) {
            if (useExist) {
				[self updatePayor];
				[self CheckValidRider];
				
            } else {
				[self savePayor];
            }
        } else {
            [self savePayorHandler];
        }
    } else if (alertView.tag == 2002 && buttonIndex == 0) { //delete
        [self deletePayor];
    } else if (alertView.tag==2003 && buttonIndex == 0) {        
        if (smoker.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            [self updatePayor];
        }
    }
}

-(void)deletePayor
{    
    if (self.requestSINo) {
        [self checkingRider];
        [self deletePayorDatabase];
        if (CheckRiderCode.length != 0) {
            [self deleteRider];
            [_delegate RiderAdded];
        }
        [self resetField];
    } else {
        [self resetField];
        [_delegate PayorDeleted];
        
        self.deleteBtn.hidden = YES;
    }
}

-(BOOL)calculateAge
{
    NSArray *curr = [getCommDate componentsSeparatedByString: @"/"];
    NSString *currentDay = [curr objectAtIndex:0];
    NSString *currentMonth = [curr objectAtIndex:1];
    NSString *currentYear = [curr objectAtIndex:2];
    
    NSArray *foo = [DOB componentsSeparatedByString: @"/"];
    NSString *birthDay = [foo objectAtIndex: 0];
    NSString *birthMonth = [foo objectAtIndex: 1];
    NSString *birthYear = [foo objectAtIndex: 2];
    
    int yearN = [currentYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [currentMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [currentDay intValue];
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
        } else {
            newALB = ALB;
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN >= dayB) {
            newANB = ALB + 1;
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        age = newALB;
        ANB = newANB;
        
        if (age < 16) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be at least 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            
            return false;
        } else {
            return true;
		}
    } else {
        age = 0;
        ANB = 1;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be at least 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        
        return false;
    }
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

#pragma mark - delegate

-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    
    if([aaDOB length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"The selected client is not applicable for this SI product."
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		alert = Nil;
        return;
    }
    
    if (sex != NULL) {
        sex = nil;
        smoker = nil;
    }    
    
    NSString *tempPrevDOB;
    int tempPrevIndexNo;
    
    if (DOB.length > 0) {
        tempPrevDOB = DOB;
        tempPrevIndexNo = IndexNo;
    }
    
    DOB = aaDOB;
    BOOL proceedWithAge = [self calculateAge];
    
    if (SINo.length != 0) {
        if (IndexNo != [aaIndex intValue]) {
            if ([self deleteRiderWithAgeCheck] > 0) {
                [_delegate RiderAdded];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Rider(s) has been deleted due to business rule."
                                                               delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];                
            }
        }
    }    
    
    IndexNo = [aaIndex intValue];
    if (proceedWithAge) {
        if (getLAIndexNo == [aaIndex intValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"This Payor has already been attached to the plan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            if (age > 100) {//added by Edwin 8-10-2013
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be less than or equal to 100 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert show];
            } else {
                if(proceedWithAge) {
                    DOBField.text = [[NSString alloc] initWithFormat:@"%@",aaDOB];
                    
                    clientName = aaName;
                    
                    nameField.enabled = NO;
                    nameField.backgroundColor = [UIColor lightGrayColor];
                    nameField.textColor = [UIColor darkGrayColor];
                    sexSegment.enabled = NO;
                    
                    btnDOB.enabled = NO;
                    self.btnDOB.titleLabel.textColor = [UIColor darkGrayColor];
                    
                    btnOccp.enabled = NO;
                    self.btnOccp.titleLabel.textColor = [UIColor darkGrayColor];
                    
                    QQProspect = NO;
                    
                    [_delegate payorSaved:NO];
                    nameField.text = aaName;
                    gName = aaName;
                    sex = aaGender;
                    
                    sexSegment.enabled = FALSE;
                    if ([sex isEqualToString:@"M"] || [sex isEqualToString:@"MALE"]) {
                        sexSegment.selectedSegmentIndex = 0;
                    } else {
                        sexSegment.selectedSegmentIndex = 1;
                    }                    
                    
                    ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
                    [btnDOB setTitle:aaDOB forState:UIControlStateNormal];
                    
                    OccpCode = aaCode;
                    [self getOccLoadExist];
                    
                    OccpField.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
                    [btnOccp setTitle:OccpDesc forState:UIControlStateNormal];
                    occpLoadField.text = [NSString stringWithFormat:@"%@",occLoading];
                    
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
                    
                    if (age > 65) {
                        if ([self deleteRider] > 0) {
                            [_delegate RiderAdded];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Rider(s) has been deleted due to business rule."
                                                                           delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert show];                            
                        }
                    }
                } else {
                    if (tempPrevDOB.length > 0) {
                        DOB = tempPrevDOB;
                        IndexNo = tempPrevIndexNo;
                    }
                }
            }
        }
        
        if(age < 17) {
            smokerSegment.enabled = FALSE;
        } else {
            smokerSegment.enabled = FALSE;
            if ([aaSmoker isEqualToString:@"N"]) {
                smokerSegment.selectedSegmentIndex = 1;
                smoker = @"N";
            } else {
                smokerSegment.selectedSegmentIndex = 0;
                smoker = @"Y";            
            }   
        }
    }
    [popOverController dismissPopoverAnimated:YES];
}

-(void)OccupClassSelected:(NSString *)OccupClass{
        
}

-(void)OccupCodeSelected:(NSString *)OccupCode{
	occuCode = OccupCode;
    OccpCode = OccupCode;
    
    [self getOccLoadExist];
    occpLoadField.text = [NSString stringWithFormat:@"%@",occLoading];
    
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
}

-(void)OccupDescSelected:(NSString *)OccupDesc{
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
            [self calculateAge];
            ageField.text = [[NSString alloc] initWithFormat:@"%d",bAge];
        }
        
        self.btnDOB.titleLabel.textColor = [UIColor blackColor];
        [self.dobPopover dismissPopoverAnimated:YES];
        date1 = NO;
    }
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
                if( sqlite3_column_text(statement, 1) != NULL )
                {
					CustDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                }                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)savePayor
{
	if (QQProspect) {
        [self insertClient];
    }
    
    //generate CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];    
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *tempCode = @"PY";
    if (requestSINo != NULL) {
        [self getRunningCustCode];
        
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
        
        int runningNoCust = CustLastNo + 1;
        NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
        SINo = [self.requestSINo description];
        CustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
        tempCode = CustCode;
        [self updateFirstRunCust];
    }
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO Trad_LAPayor (SINo, CustCode,PTypeCode,Sequence,DateCreated,CreatedBy) "
							   "VALUES (\"%@\",\"%@\",\"PY\",\"1\",\"%@\",\"hla\")",getSINo, tempCode, dateStr];
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
        }
        insertSQL = [NSString stringWithFormat:
                                @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, "
								"CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", "
								"\"hla\", \"%d\")",
								tempCode, nameField.text, smoker, [sex substringToIndex:1], DOB, age, ANB, OccpCode, dateStr,IndexNo];
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
                [_delegate payorSaved:YES];
                self.deleteBtn.hidden = NO;
                
                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                zzz.ExistPayor = YES;
            } else {
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
}

-(void)updateFirstRunCust
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)savePayorHandler
{
    if(![EAPPorSI isEqualToString:@"eAPP"]) {
        if (QQProspect) {
            [self insertClient];
        }
        
        [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
        AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        zzz.SICompleted = NO;
        
        self.deleteBtn.hidden = NO;
        inserted = YES;
        [_delegate payorSaved:YES];
    }
}

-(void)checkingExisting
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id, b.IndexNo "
							  "FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND "
							  "a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                CustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                clientName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                smoker = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                sex = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                DOB = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                age = sqlite3_column_int(statement, 6);
                OccpCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                clientID = sqlite3_column_int(statement, 8);
                IndexNo = sqlite3_column_int(statement, 9);
                
            } else {
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
}

-(void)checkingExisting2
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSString *tempSINo;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Sequence=1",[self.requestSINo description]];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                clientID = sqlite3_column_int(statement, 1);
                
            } else {
                useExist = NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (tempSINo.length != 0) {
        useExist = YES;
    } else {
        useExist = NO;
    }
}

-(void)getProspectData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode, QQFlag, Smoker "
							  "FROM prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NamePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                DOBPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                GenderPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                OccpCodePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
				
				NSString *TempQQProspect = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                SmokerPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
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
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.OccpDesc, b.OccLoading, b.CPA, b.PA, a.Class from Adm_Occp_Loading_Penta a LEFT JOIN Adm_Occp_Loading b ON a.OccpCode = b.OccpCode WHERE b.OccpCode = \"%@\"",OccpCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                OccpDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                occLoading =  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                occCPA_PA  = sqlite3_column_int(statement, 2);
                occPA  = sqlite3_column_int(statement, 3);
                occuClass = sqlite3_column_int(statement, 4);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(BOOL)updatePayor
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Clt_Profile SET Name=\'%@\', Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", "
                              "DateModified=\"%@\", ModifiedBy=\"hla\", indexNo=\"%d\" WHERE id=\"%d\"",
							  nameField.text,smoker,[sex substringToIndex:1],DOB,age,ANB,OccpCode,currentdate,IndexNo,clientID];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:[sex substringToIndex:1] andDOB:DOB andAge:age andOccpCode:OccpCode];
                [_delegate payorSaved:YES];
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

-(void)deletePayorDatabase
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_LAPayor WHERE CustCode=\"%@\"",CustCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                IndexNo = 0;
            }
        }
        querySQL = [NSString stringWithFormat:@"DELETE FROM Clt_Profile WHERE CustCode=\"%@\"",CustCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                [_delegate PayorDeleted];
                [self resetField];
				
                CustCode = nil;
                
                if (getLAAge < 10) {
                    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                    zzz.ExistPayor = NO;
                }
            } else {                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in deleting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    self.deleteBtn.hidden = YES;
    useExist = NO;
}

-(void)CheckValidRider
{
    RiderToBeDeleted = [[NSMutableArray alloc] init ];
	
    sqlite3_stmt *statement;
    
    NSString *temp;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"Select RiderTerm, RiderCode From trad_Rider_Details where SINO = \"%@\" AND RiderCode in ('PTR', 'PLCP') ", SINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            int riderTerm = 0;
            while (sqlite3_step(statement) == SQLITE_ROW)
            {	
				riderTerm = sqlite3_column_int(statement, 0);
                temp = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
				if(riderTerm + age > 60){
					[RiderToBeDeleted addObject:temp];
				}
            }
            sqlite3_finalize(statement);
        }
		
		if ([OccpCode isEqualToString:@"OCC01975"]) {
			NSString *querySQL = [NSString stringWithFormat:@"Select Ridercode From trad_Rider_Details where SINO = \"%@\" AND RiderCode in ('LCWP', 'PR', 'PTR', 'PLCP') ", SINo];
			if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{
				while (sqlite3_step(statement) == SQLITE_ROW)
				{
					temp =[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
					[RiderToBeDeleted addObject:temp];
				}
				sqlite3_finalize(statement);
			}
			
		}
		
		temp = Nil;
		
		if (RiderToBeDeleted.count > 0) {
			
			for (int i=0; i < RiderToBeDeleted.count; i++) {
				querySQL = [NSString stringWithFormat:@"DELETE From trad_Rider_Details where SINO = \"%@\" AND RiderCode = \"%@\" ", SINo, [RiderToBeDeleted objectAtIndex:i]];
				if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
				{
					sqlite3_step(statement);					
					sqlite3_finalize(statement);
				}
			}
			
			[_delegate RiderAdded];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Rider(s) has been deleted due to business rule."
														   delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			
		}
		
        sqlite3_close(contactDB);
    }
}


-(void)checkingRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,SumAssured,RiderTerm,Units FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"PY\" AND Seq=\"1\"",getSINo];
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

-(int)deleteRiderWithAgeCheck
{
    int rowsDeleted = 0;
    if (age < 20)
    {
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"PY\" AND Seq=\"1\" AND RiderCode in ('PTR', 'PLCP')",getSINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    rowsDeleted = sqlite3_changes(contactDB);
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
    }
    return rowsDeleted;
}

-(int)deleteRider
{
    sqlite3_stmt *statement;
    int rowsDeleted = 0;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"PY\" AND Seq=\"1\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                rowsDeleted = sqlite3_changes(contactDB);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    return rowsDeleted;
}

-(void)insertClient
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL3 = [NSString stringWithFormat:
                                @"INSERT INTO prospect_profile(\"ProspectName\", \"ProspectDOB\", \"ProspectGender\", \"ProspectOccupationCode\", \"DateCreated\", \"CreatedBy\", \"DateModified\",\"ModifiedBy\", \"Smoker\", 'QQFlag') "
                                "VALUES (\"%@\", \"%@\", \"%@\", \"%@\", %@, \"%@\", \"%@\", \"%@\", \"%@\", '%@')",
								nameField.text, DOB, sex, occuCode, @"datetime(\"now\", \"+8 hour\")",  @"1", @"", @"1", smoker, @"true"];
        
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
					sqlite3_step(statement3);
                    sqlite3_finalize(statement3);
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
-(BOOL)performSavePayor
{
    BOOL proceedWithAge = [self calculateAge];
    
    if (proceedWithAge) {
        if([clientName isEqualToString: @""] || clientName.length == 0) {
            [self savePayorHandler];
            
        } else {
            if (CustCode) {
                [self updatePayor];
                [self CheckValidRider];
            } else {
                [self savePayor];
            }
        }
        return YES;
    } else {        
        return NO;
    }
}

-(BOOL)validateSave
{
    if (age < 16) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Age must be at least 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else {
        return YES;
    }
    return NO;
}

#pragma mark - STORE PAYOR BEFORE SAVE INTO DATABASE
-(void)storeData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    if (!payorSIObj) {
        payorSIObj = [[SIObj alloc]init];
    }
    payorSIObj.name = gName;
    payorSIObj.smoker = smoker;
    payorSIObj.sex = sex;
    payorSIObj.DOB = DOB;
    payorSIObj.age = [NSString stringWithFormat:@"%d",age];
    payorSIObj.ANB = [NSString stringWithFormat:@"%d",ANB];
    payorSIObj.occupationCode = OccpCode;
    payorSIObj.dateModified = currentdate;//currentDate
    payorSIObj.indexNo = [NSString stringWithFormat:@"%d",IndexNo];
    payorSIObj.clientID = [NSString stringWithFormat:@"%d",clientID];
	
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
    [self setDOBField:nil];
    [self setAgeField:nil];
    [self setOccpField:nil];
    [self setOccpLoadField:nil];
    [self setCPAField:nil];
    [self setPAField:nil];
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
    [self setHeaderTitle:nil];
	[self setOutletDone:nil];
	[self setOutletProspect:nil];
	[self setOutletQQ:nil];
	[self setOutletEAPP:nil];
	[self setOutletSpace:nil];
    [super viewDidUnload];
}

@end
