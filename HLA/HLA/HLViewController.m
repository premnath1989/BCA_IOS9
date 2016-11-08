//
//  HLViewController.m
//  iMobile Planner
//
//  Created by shawal sapuan on 3/6/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "HLViewController.h"
#import "Constants.h"

@interface HLViewController ()

@end

@implementation HLViewController
@synthesize HLField,HLTermField,TempHLField,TempHLTermField,headerTitle;
@synthesize getHL,getHLTerm,getTempHL,getTempHLTerm,termCover,ageClient,planChoose,SINo,requesteProposalStatus, EAPPorSI, outletDone;
@synthesize outletEAPP, outletSpace, getMOP;
@synthesize delegate = _delegate;

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
		[requesteProposalStatus isEqualToString:@"Received"] || [EAPPorSI isEqualToString:@"eAPP"] || [requesteProposalStatus isEqualToString:@"Created_View"]) {
		Editable = NO;
	} else {
		Editable = YES;
	}
    
    outletEAPP.title = @"";
    outletEAPP.enabled = FALSE;
    
    [HLField setDelegate:self];
    [HLTermField setDelegate:self];
    [TempHLField setDelegate:self];
    [TempHLTermField setDelegate:self];
    [self loadHL];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(hideKeyboard)];
	tap.cancelsTouchesInView = NO;
	tap.numberOfTapsRequired = 1;
	
	[self.view addGestureRecognizer:tap];
		
	if (Editable == NO) {
		[self DisableTextField:HLField];
		[self DisableTextField:HLTermField];
		[self DisableTextField:TempHLField];
		[self DisableTextField:TempHLTermField];
		
        if([EAPPorSI isEqualToString:@"eAPP"]) {
            outletEAPP.title = @"e-Application Checklist";
            outletEAPP.enabled = TRUE;
            outletDone.enabled = FALSE;
        }
	}
	    
    if([EAPPorSI isEqualToString:@"eAPP"]){
        [self disableFieldsForEapp];
    }

}

-(void) disableFieldsForEapp
{
    HLField.enabled = NO;
    HLField.backgroundColor = [UIColor lightGrayColor];
    
    HLTermField.enabled = NO;
    HLTermField.backgroundColor = [UIColor lightGrayColor];
    
    TempHLField.enabled = NO;
    TempHLField.backgroundColor = [UIColor lightGrayColor];
    
    TempHLTermField.enabled = NO;
    TempHLTermField.backgroundColor = [UIColor lightGrayColor];
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

-(void)loadHL
{
    [self getTermRule];
    [self getExistingData];
    [self clearHLFields];
    if (getHLTerm > 0 || getTempHLTerm > 0) {
        [self getExistingView];
    }
	
}

-(void)clearHLFields
{
    HLField.text = @"";
    HLTermField.text = @"";
    TempHLField.text = @"";
    TempHLTermField.text = @"";
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return YES;
}

-(void)textFieldDidChange:(UITextField*)textField
{
    appDelegate.isNeedPromptSaveMsg = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString     = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    if ((textField == HLTermField || textField == TempHLTermField) && [arrayOfString count] > 1) {
        return NO;
    }
    
    if ([arrayOfString count] > 2 )
    {
        return NO;
    }
    
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
        return NO;
    }
    return YES;
}

- (void)getExistingView
{
    if (getHL.length != 0) {
        
        NSRange rangeofDot = [getHL rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getHL substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getHL substringToIndex:rangeofDot.location ];
            }
            else {
                valueToDisplay = getHL;
            }
        }
        else {
            valueToDisplay = getHL;
        }
        HLField.text = valueToDisplay;
    }
    
    if (getHLTerm != 0) {
        HLTermField.text = [NSString stringWithFormat:@"%d",getHLTerm];
    }
    
    if (getTempHL.length != 0) {
        NSRange rangeofDot = [getTempHL rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getTempHL substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getTempHL substringToIndex:rangeofDot.location ];
            }
            else {
                valueToDisplay = getTempHL;
            }
        }
        else {
            valueToDisplay = getTempHL;
        }
        TempHLField.text = valueToDisplay;
    }
    
    if (getTempHLTerm != 0) {
        TempHLTermField.text = [NSString stringWithFormat:@"%d",getTempHLTerm];
        
    }
}

#pragma mark - action

- (IBAction)ActionEAPP:(id)sender {
    [_delegate dismissEApp];
}

- (IBAction)doSave:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    [_delegate saveAll];
	
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001 && buttonIndex == 0) {
        
        [self updateHL];
    }
}

#pragma mark - VALIDATION

-(BOOL)DifferentPaymentTerm : (NSString *) aaPlanCode{
    if ([aaPlanCode isEqualToString:STR_HLAWP])
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

-(BOOL)validateSave//health Loading validation checking before save
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if (HLField.text.length > 0 && [HLField.text floatValue] == 0) {
        [HLField setText:@""];
    }
    if (HLTermField.text.length > 0 && [HLTermField.text floatValue] == 0) {
        [HLTermField setText:@""];
    }
    if (TempHLField.text.length > 0 && [TempHLField.text floatValue] == 0) {
        [TempHLField setText:@""];
    }
    if (TempHLTermField.text.length > 0 && [TempHLTermField.text floatValue] == 0) {
        [TempHLTermField setText:@""];
    }
    NSRange rangeofDotHL = [HLField.text rangeOfString:@"."];
    NSString *substringHL = @"";
    NSRange rangeofDotTempHL = [TempHLField.text rangeOfString:@"."];
    NSString *substringTempHL = @"";
    if (rangeofDotHL.location != NSNotFound) {
        substringHL = [HLField.text substringFromIndex:rangeofDotHL.location ];
    }
    
    if (rangeofDotTempHL.location != NSNotFound) {
        substringTempHL = [TempHLField.text substringFromIndex:rangeofDotTempHL.location ];
    }
    
    if ([HLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if (substringHL.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLField.text intValue] >= 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (Per 1k SA) cannot be greater than or equal to 10000." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLField.text floatValue] > 0 && HLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
    else if ([HLTermField.text intValue] > 0 && HLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) into Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
    else if ([HLTermField.text intValue] > termCover &&  ![planChoose isEqualToString:STR_HLAWP]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be greater than %d",termCover] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
    else if ([HLField.text floatValue] == 0 && HLField.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLTermField.text intValue] == 0 && HLTermField.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
    
    //--
    
    else if ([TempHLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Temporary Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [TempHLField becomeFirstResponder];
    }
    else if (substringTempHL.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [TempHLField becomeFirstResponder];
    }
    else if ([TempHLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Invalid input. Please enter numeric value (0-9) into Temporary Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [TempHLTermField becomeFirstResponder];
    }
    else if ([TempHLField.text floatValue] > 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (Per 1k SA) cannot be greater than 10000" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [TempHLField becomeFirstResponder];
    }
    else if ([TempHLField.text floatValue] > 0 && TempHLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [TempHLTermField becomeFirstResponder];
    }
    else if ([TempHLTermField.text intValue] > 0 && TempHLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [TempHLField becomeFirstResponder];
    }
    else if ([TempHLTermField.text intValue] > termCover  &&  ![planChoose isEqualToString:STR_HLAWP]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Temporary Health Loading (per 1k SA) Term cannot be greater than %d",termCover] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [TempHLTermField becomeFirstResponder];
    }
    else if ([TempHLField.text floatValue] == 0 && TempHLField.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [TempHLField becomeFirstResponder];
    }
    else if ([TempHLTermField.text intValue] == 0 && TempHLTermField.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:@"Temporary Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [TempHLTermField becomeFirstResponder];
    }
    else if ([HLTermField.text intValue] > getMOP && [self DifferentPaymentTerm:planChoose] == TRUE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Health Loading (per 1k SA) term cannot be greater than %d ", getMOP  ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
	else if ([TempHLTermField.text intValue] > getMOP && [self DifferentPaymentTerm:planChoose] == TRUE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:[NSString stringWithFormat:@"Temporary Health Loading (per 1k SA) term cannot be greater than %d ", getMOP] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [TempHLTermField becomeFirstResponder];
    }
	else{
        
        return YES;
		
    }
    return NO;
}

#pragma mark - db

-(void) getTermRule
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;
        int ppo = 99;
        if ([planChoose isEqualToString:STR_S100]) {
            querySQL = [NSString stringWithFormat: @"SELECT PremiumPaymentOption FROM Trad_Details WHERE SINo=\"%@\"",SINo];
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    ppo = sqlite3_column_int(statement, 0);
                }            
            }
            sqlite3_finalize(statement);
        }
        
        querySQL = [NSString stringWithFormat: @"SELECT MaxTerm FROM Trad_Sys_Mtn WHERE PlanCode=\"%@\"",planChoose];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int maxTerm  =  sqlite3_column_int(statement, 0);
                
                if ([planChoose isEqualToString:STR_HLAWP]) {
                    termCover = maxTerm - ageClient;
                } else if ([planChoose isEqualToString:STR_S100]) {
                    if (ppo < 99) {
                        termCover = ppo;
                    } else {
                        termCover = 100 - ageClient;
                    }
                }else if ([planChoose isEqualToString:@"BCALH"]) {
                    termCover = maxTerm - ageClient;
    
                } else {
                    termCover = -1; //for debugging
                }
            } else {
                NSLog(@"error access getTermRule");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(BOOL)updateHL
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET HL1KSA=\"%@\", HL1KSATerm=\"%d\", TempHL1KSA=\"%@\", TempHL1KSATerm=\"%d\", UpdatedAt=%@ WHERE SINo=\"%@\"",  HLField.text, [HLTermField.text intValue], TempHLField.text, [TempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {                
                [_delegate HLInsert:HLField.text andBasicTempHL:TempHLField.text];
            }
            else
            {
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
				sqlite3_close(contactDB);
                return NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    return YES;
}

- (void)getExistingData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT SINo, PlanCode, HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm FROM Trad_Details WHERE SINo=\"%@\"",SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                planChoose = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
				
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 2);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 3);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 4);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 5);
                
            } else {
                NSLog(@"error getExistingData");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setHLField:nil];
    [self setHLTermField:nil];
    [self setTempHLField:nil];
    [self setTempHLTermField:nil];
    [self setMyToolBar:nil];
    [self setHeaderTitle:nil];
    [self setOutletDone:nil];
    [self setOutletEAPP:nil];
    [self setOutletSpace:nil];
    [super viewDidUnload];
}

@end
