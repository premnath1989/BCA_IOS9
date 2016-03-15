//
//  eAppReport.m
//  iMobile Planner
//
//  Created by kuan on 11/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eAppReport.h"
#import "SICell.h"
#import "PolicyOwnerCell.h"
#import "CFFCell.h"
#import "eAppCell.h"
#import "eSignCell.h"
#import "eSubCell.h"
#import "DataClass.h"
#import "FormViewController.h"
#import "ColorHexCode.h"
#import "MBProgressHUD.h"
#import "ESignGenerator.h"
//#import "eSignController.h"

#import "SIxml.h"
#import "PRxml.h"
#import "PDFCreaterHeader.h"

#import "CA_Form.h"
#import "FF_Form.h"
#import "XMLDictionary.h"

#import "CashPromiseViewController.h"

@interface eAppReport ()
{
    NSMutableArray *items;
    
    SICell *siCell;
    PolicyOwnerCell *poCell;
    CFFCell *cffCell;
    eAppCell *eappCell;
    eAppCell *coaCell;
    eAppCell *eauthCell;
    eAppCell *genformsCell;
    eSubCell *esubcell;
    
    DataClass *obj;
    NSMutableArray *dataItems;
}

@property (nonatomic,strong)PDFCreater *proposalCreator;
@end

@implementation eAppReport
@synthesize CAPDFGenerator;
@synthesize FFPDFGenerator;

@synthesize SupplementaryProposalPDFGenerator;

//@synthesize SIPDFGenerator;
@synthesize ProposalPDFGenerator;
@synthesize ApplicationAuthorizationPDFGenerator;
@synthesize getPlanName, getPlanCode,progressLabel,progressView;
@synthesize proposalNo_display;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    obj=[DataClass getInstance];
    appobject=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appobject.ViewFromPendingBool==YES) {
        
        self.navigationItem.leftBarButtonItem.title= @"Pending Submission Listing";
        
        [self removeGenerateButton];
    }
    
    if (appobject.ViewFromSubmissionBool==YES) {        
        self.navigationItem.leftBarButtonItem.title= @"Submitted Cases Listing";
        
        [self removeGenerateButton];
    }
    
	if (appobject.ViewFromEappBool==YES)
	{        
        [self DoShowGenerateButton];
    }
    
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
    [self initFormListItems];
    
    self.reportTable.scrollEnabled = YES;
    
	// Do any additional setup after loading the view.
    
    
    NSString *displayThis = [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"];
    if (displayThis == NULL) {
        displayThis = @"";
    }
    
    
    self.reportTable.scrollEnabled = NO;
    
    proposalNo_display =[[UILabel alloc]initWithFrame:CGRectMake(700,5, 930, 20)];
    proposalNo_display.backgroundColor =[UIColor clearColor];
    proposalNo_display.textColor =[UIColor darkGrayColor];
    proposalNo_display.font =[UIFont systemFontOfSize:15];
    proposalNo_display.text =[NSString stringWithFormat:@"Proposal Number: %@",displayThis];
    proposalNo_display.hidden =NO;
    [self.view addSubview:self.proposalNo_display];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doGenerateReport:(id)sender {
    buttonGenerate = (UIButton *)sender;
    [buttonGenerate setHidden:YES];
    AppDelegate *MenuOption= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    MenuOption.FormsTickMark=NO;

    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setFrame:CGRectMake(45, 470, 930, 100)];
    progressView.hidden =NO;
    [self.view addSubview:self.progressView];

    progressLabel =[[UILabel alloc]initWithFrame:CGRectMake((progressView.frame.origin.x +450), progressView.frame.origin.y +10, 50, 50)];
    progressLabel.backgroundColor =[UIColor clearColor];
    progressLabel.hidden =NO;
    [self.view addSubview:self.progressLabel];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(updateProgreessBar) userInfo:nil repeats:YES];

    appobject=(AppDelegate *)[[UIApplication sharedApplication]delegate];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CompareSign"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ComparePhoto"];
    [[NSUserDefaults standardUserDefaults] synchronize];


    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"compareString"]) {
        NSMutableArray *array=[[[NSUserDefaults standardUserDefaults] objectForKey:@"compareString"] mutableCopy];
        if (![array containsObject:appobject.eappProposal]) {
            [array addObject:appobject.eappProposal];
        }
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"compareString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        NSMutableArray *array=[[NSMutableArray alloc] init];
        [array addObject:appobject.eappProposal];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"compareString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }


    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //create SIXML Path if not exist
    NSString *SIPath =  [documentsDirectory stringByAppendingPathComponent:@"SIXML"];

    if(![[NSFileManager defaultManager] fileExistsAtPath:SIPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:SIPath withIntermediateDirectories:NO attributes:nil error:nil];
    }


    //create ProposalXML Path if not exist
    NSString *PRPath =  [documentsDirectory stringByAppendingPathComponent:@"ProposalXML"];

    if(![[NSFileManager defaultManager] fileExistsAtPath:PRPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:PRPath withIntermediateDirectories:NO attributes:nil error:nil];
    }


    //create Forms Path if not exist
    NSString *FormsPath =  [documentsDirectory stringByAppendingPathComponent:@"Forms"];

    if(![[NSFileManager defaultManager] fileExistsAtPath:FormsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:FormsPath withIntermediateDirectories:NO attributes:nil error:nil];
    }

    [self performSelector:@selector(updateProgreessBar) withObject:nil afterDelay:6.0];


    //XML TO PDF ----->>>
    //XMLs
    SIxml *SIXMLgenerator = [[SIxml alloc]init];
    [SIXMLgenerator GenerateSIXML:self.populateSIXMLData RNNumber:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]];
    NSLog(@"Generate XML : SIXML - generated!");

    PRxml *PRXMLgenerator = [[PRxml alloc]init];
    [PRXMLgenerator GeneratePRXML:self.populatePRXMLData RNNumber:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]];
    NSLog(@"Generate XML : ProposalXML - generated!");
    
    NSString *xmlPRPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ProposalXML/%@_PR.xml",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]];

    NSString *xmlSIPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"SIXML/%@_SI.xml",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]];


    [self forSIdetails];


    //Prepare NSDICTIONARY

    NSString *str = [NSString stringWithContentsOfFile:xmlPRPath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:str];



    NSString  *sqlDBPath = [[NSBundle mainBundle] pathForResource:@"hladb" ofType:@"sqlite"];

    //To Check if this is company case
    NSString *otherIDType_check = @"CR";
    NSString *ptypeCode_check = @"PO";
    NSString *comcase = @"No";
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];

    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];

    FMResultSet *results_check_comcase = [database executeQuery:@"SELECT * from eProposal_LA_Details WHERE eProposalNo = ? AND PTypeCode =? AND LAOtherIDType = ?", [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"], ptypeCode_check, otherIDType_check];

    while ([results_check_comcase next]) {
        comcase = @"Yes";
    }

    if ([comcase isEqualToString:@"No"]) {

        //FF Form will be generated for Non-Company Case
        FF_Form *ffForm = [[FF_Form alloc]init];
        [ffForm returnPDFFromDictionary:xmlDoc proposalNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] referenceNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] sqliteDBPath:sqlDBPath];
        NSLog(@"Generate Forms : Customer Fact Find - generated!");

        // CA Form will be generated for Non-Company Case
        CA_Form *caCreator = [[CA_Form alloc]init];
        [caCreator returnPDFFromDictionary:xmlDoc proposalNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] referenceNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] ];
        NSLog(@"Generate Forms : Comfirmaion Of Advice - generated!");
    }

    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    NSDate *currDate = [NSDate date];
    [dateFormatter2 setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter2 stringFromDate:currDate];

    NSString *queryB = @"";
    queryB = [NSString stringWithFormat:@"UPDATE eApp_Listing SET DateUpdated = '%@' WHERE ProposalNo = '%@'", dateString, [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]];
    [database executeUpdate:queryB];


//    eSignController *esignCon = [[eSignController alloc]init];
//    [esignCon eApplicationForProposalNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] fromInfoDic:xmlDoc];
    NSLog(@"Generate Forms : Authorization Form - generated!");


    //PR Form
    self.proposalCreator = [[PDFCreater alloc] init];
    [self.proposalCreator generatePRFormFromPRXMLPath:xmlPRPath
                                         andSIXMLPath:xmlSIPath
                                  andDatabaseFilePath:sqlDBPath];
    NSLog(@"Generate Forms : Proposal Form - generated!");


    appobject.checkList=YES;
}

- (IBAction)doEAppChecklist:(id)sender {
    dataItems = nil;
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)updateProgreessBar
{
    static int count =0; count++;
    
    if (count ==12)
    {
        count =0;
    }
    
    if (count <=10)
    {
        progressLabel.text = [NSString stringWithFormat:@"%d %%",count*10];
        progressLabel.font = [UIFont boldSystemFontOfSize:16];
        self.progressView.progress = (float)count/10.0f;
        NSLog(@"progree_bar loading %@",progressLabel.text);
    }
    
    else
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
        
        NSLog(@"progree_bar loadingMy %@",progressLabel.text);
        
        if ([progressLabel.text isEqualToString:@"100 %"])
        {
            [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(TimerToRun) userInfo:nil repeats:NO];
            
        }
        
    }
    
}

-(void)TimerToRun
{
    
    self.progressLabel.hidden =YES;
    self.progressView.hidden =YES;
    self.Background.hidden =YES;
    
    [self initFormListItems];
    [self.reportTable reloadData];
    [self.reportTable setNeedsDisplay];
    
    [self AlertGenerateDone];
    
}

-(void)AlertGenerateDone
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                    message:@"Forms have been generated successfully."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];    
}


-(void)stopSpinner{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self initFormListItems];
    [self.reportTable reloadData];
    [self.reportTable setNeedsDisplay];
    
    
}

-(void)initFormListItems{
    //initialize Form path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];    
    NSString *FormsPath =  [documentsDirectory stringByAppendingPathComponent:@"Forms"];
    
    //prepare array to store forms path
    dataItems = [[NSMutableArray alloc] init];
    
    //check if Form exists.
    if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_PR.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
        [dataItems addObject:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_PR.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]];
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SP_1.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
        [dataItems addObject:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SP_1.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]];
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SI.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
        [dataItems addObject:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SI.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]];
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_FF.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
        [dataItems addObject:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_FF.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]];
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_CA.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
        [dataItems addObject:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_CA.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]];
    }
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_AU.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
        [dataItems addObject:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_AU.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]];
    }    
}


-(void)viewWillAppear:(BOOL)animated
{    
    [self.navigationController setNavigationBarHidden:NO animated:NO];    
    [self removeGenerateButton];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)removeGenerateButton
{
    [buttonGenerate setHidden:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)DoShowGenerateButton
{
	
	NSString *isPOSign;
    NSString *DatePOSign;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"hladb.sqlite"];
	
	FMDatabase *db = [FMDatabase databaseWithPath:path];
	if (![db open]) {
        NSLog(@"Could not open db.");
        db = [FMDatabase databaseWithPath:path];
        
        [db open];
    }
    
    NSString *displayThis = nil;
    displayThis = [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"];
    if (displayThis ==nil) {
        displayThis = @"";
    }
    
    FMResultSet *result_eSign = [db executeQuery:@"SELECT * from eProposal_Signature WHERE eProposalNo = ? ",displayThis];
	
	while ([result_eSign next])
    {
		isPOSign = [result_eSign stringForColumn:@"isPOSign"];
		DatePOSign = [result_eSign stringForColumn:@"DatePOSign"];
        
        if  ((NSNull *) isPOSign == [NSNull null]||[isPOSign isEqualToString:@""]||isPOSign ==Nil)
        {
			isPOSign =@"";
        }
	}
	
	if ([isPOSign isEqualToString:@"YES"])
	{
		[buttonGenerate setHidden:YES];
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		
	}
	else
	{	
        [buttonGenerate setHidden:NO];
        
	}
}

- (NSDictionary *) populateSIXMLData
{    
    NSMutableDictionary *SIXMLData = [[NSMutableDictionary alloc] init];
    obj=[DataClass getInstance];
    
    //Getting eSystemInfo Key
    NSDictionary *eSystemInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eSystemInfo"];    
    if (eSystemInfo) {
        [SIXMLData setObject:eSystemInfo forKey:@"eSystemInfo"];
    }
    
    //Getting SIDetails key
    NSDictionary *SIDetails = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"SIDetails"];
    if (SIDetails) {
        [SIXMLData setObject:SIDetails forKey:@"SIDetails"];
    }
    
    return SIXMLData;
    
}

- (NSDictionary *) populatePRXMLData
{
    NSMutableDictionary *PRXMLData = [[NSMutableDictionary alloc] init];
    obj=[DataClass getInstance];
    
    //Getting eSystemInfo key
    NSDictionary *eSystemInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eSystemInfo"];
    if (eSystemInfo) {
        [PRXMLData setObject:eSystemInfo forKey:@"eSystemInfo"];
    }
    
    //Getting SubmissionInfo key
    NSDictionary *SubmissionInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"SubmissionInfo"];
    
    if (SubmissionInfo) {
        [PRXMLData setObject:SubmissionInfo forKey:@"SubmissionInfo"];
    }
    
    //Getting ChannelInfo Key
    NSDictionary *ChannelInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"ChannelInfo"];
    if (ChannelInfo) {
        [PRXMLData setObject:ChannelInfo forKey:@"ChannelInfo"];
    }
    
    //Gettig AgentInfo Key
    NSDictionary *AgentInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"AgentInfo"];
    if (AgentInfo) {
        [PRXMLData setObject:AgentInfo forKey:@"AgentInfo"];
    }
    
    //Getting AssuredInfo Key
    NSDictionary *AssuredInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"AssuredInfo"];
    if (AssuredInfo) {
        [PRXMLData setObject:AssuredInfo forKey:@"AssuredInfo"];
    }
    
    //Getting eCFFInfo Key
    NSDictionary *eCFFInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFInfo"];
    if (eCFFInfo) {
        [PRXMLData setObject:eCFFInfo forKey:@"eCFFInfo"];
    }
    
    //Getting eCFFPersonalInfo Key
    NSDictionary *eCFFPersonalInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFPersonalInfo"];
    if (eCFFPersonalInfo) {
        [PRXMLData setObject:eCFFPersonalInfo forKey:@"eCFFPersonalInfo"];
    }
    
    //Getting eCFFPartnerInfo Key
    NSDictionary *eCFFPartnerInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFPartnerInfo"];
    if (eCFFPartnerInfo) {
        [PRXMLData setObject:eCFFPartnerInfo forKey:@"eCFFPartnerInfo"];
    }
    
    //Getting eCFFChildInfo Key
    NSDictionary *eCFFChildInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFChildInfo"];
    if (eCFFChildInfo) {
        [PRXMLData setObject:eCFFChildInfo forKey:@"eCFFChildInfo"];
    }
    
    //Getting eCFFProtectionInfo Key
    NSDictionary *eCFFProtectionInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFProtectionInfo"];
    if (eCFFProtectionInfo) {
        [PRXMLData setObject:eCFFProtectionInfo forKey:@"eCFFProtectionInfo"];
    }
    
    //Getting eCFFProtectionDetails Key
    NSDictionary *eCFFProtectionDetails = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFProtectionDetails"];
    if (eCFFProtectionDetails) {
        [PRXMLData setObject:eCFFProtectionDetails forKey:@"eCFFProtectionDetails"];
    }
    
    //Getting eCFFRetirementInfo Key
    NSDictionary *eCFFRetirementInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFRetirementInfo"];
    if (eCFFRetirementInfo) {
        [PRXMLData setObject:eCFFRetirementInfo forKey:@"eCFFRetirementInfo"];
    }
    
    //Getting eCFFRetirementDetails Key
    NSDictionary *eCFFRetirementDetails = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFRetirementDetails"];
    if (eCFFRetirementDetails) {
        [PRXMLData setObject:eCFFRetirementDetails forKey:@"eCFFRetirementDetails"];
    }
    
    //Getting eCFFEducationInfo Key
    NSDictionary *eCFFEducationInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFEducationInfo"];
    if (eCFFEducationInfo) {
        [PRXMLData setObject:eCFFEducationInfo forKey:@"eCFFEducationInfo"];
    }
    
    //Getting eCFFEducationDetails Key
    NSDictionary *eCFFEducationDetails = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFEducationDetails"];
    if (eCFFEducationDetails) {
        [PRXMLData setObject:eCFFEducationDetails forKey:@"eCFFEducationDetails"];
    }
    
    //Getting eCFFSavingInfo Key
    NSDictionary *eCFFSavingInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFSavingInfo"];
    if (eCFFSavingInfo) {
        [PRXMLData setObject:eCFFSavingInfo forKey:@"eCFFSavingInfo"];
    }
        
    //Getting eCFFSavingsDetails Key
    NSDictionary *eCFFSavingsDetails = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFSavingsDetails"];
    if (eCFFSavingsDetails) {
        [PRXMLData setObject:eCFFSavingsDetails forKey:@"eCFFSavingsDetails"];
    }
    
    //Getting eCFFRecordOfAdviceP1 Key
    NSDictionary *eCFFRecordOfAdviceP1 = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFRecordOfAdviceP1"];
    if (eCFFRecordOfAdviceP1) {
        [PRXMLData setObject:eCFFRecordOfAdviceP1 forKey:@"eCFFRecordOfAdviceP1"];
    }
    
    //Getting eCFFRecoredOfAdviceP2 Key
    NSDictionary *eCFFRecoredOfAdviceP2 = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFRecoredOfAdviceP2"];
    
    if (eCFFRecoredOfAdviceP2) {
        [PRXMLData setObject:eCFFRecoredOfAdviceP2 forKey:@"eCFFRecoredOfAdviceP2"];
    }
    
    //Getting eCFFConfirmationAdviceGivenTo Key
    NSDictionary *eCFFConfirmationAdviceGivenTo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFConfirmationAdviceGivenTo"];
    if (eCFFConfirmationAdviceGivenTo) {
        [PRXMLData setObject:eCFFConfirmationAdviceGivenTo forKey:@"eCFFConfirmationAdviceGivenTo"];
    }
    
    //Getting eCFFRecommendedProducts Key
    NSDictionary *eCFFRecommendedProducts = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"eCFFRecommendedProducts"];
    if (eCFFRecommendedProducts) {
        [PRXMLData setObject:eCFFRecommendedProducts forKey:@"eCFFRecommendedProducts"];
    }
    
    //Getting proposalCreditCardInfo Key
    NSDictionary *proposalCreditCardInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalCreditCardInfo"];
    if (proposalCreditCardInfo) {
        [PRXMLData setObject:proposalCreditCardInfo forKey:@"proposalCreditCardInfo"];
    }
    NSDictionary *proposalFTCreditCardInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalFTCreditCardInfo"];
    if (proposalFTCreditCardInfo) {
        [PRXMLData setObject:proposalFTCreditCardInfo forKey:@"proposalFTCreditCardInfo"];
    }
    
    NSDictionary *DCCreditCardInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"DCCreditCardInfo"];
    if (DCCreditCardInfo) {
        [PRXMLData setObject:DCCreditCardInfo forKey:@"DCCreditCardInfo"];
    }
    
    NSDictionary *FATCAInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"FATCAInfo"];
    if (FATCAInfo) {
        [PRXMLData setObject:FATCAInfo forKey:@"FATCAInfo"];
    }
    
    //getting proposalPaymentInfo key
    NSDictionary *proposalPaymentInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalPaymentInfo"];
    if (proposalPaymentInfo) {
        [PRXMLData setObject:proposalPaymentInfo forKey:@"proposalPaymentInfo"];
    }
    
    //Getting proposalQuestionairies key
    NSDictionary *proposalQuestionairies = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalQuestionairies"];
    if (proposalQuestionairies) {
        [PRXMLData setObject:proposalQuestionairies forKey:@"proposalQuestionairies"];
    }
    
    //Getting policyExistingLifePolicies Key
    NSDictionary *policyExistingLifePolicies = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"policyExistingLifePolicies"];
    if (policyExistingLifePolicies) {
        [PRXMLData setObject:policyExistingLifePolicies forKey:@"policyExistingLifePolicies"];
    }
    
    //getting propoalAddQuesInfo key
    NSDictionary *propoalAddQuesInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"propoalAddQuesInfo"];
    if (propoalAddQuesInfo) {
        [PRXMLData setObject:propoalAddQuesInfo forKey:@"propoalAddQuesInfo"];
    }
    
    //Getting proposalAddQuesDetails key
    NSDictionary *proposalAddQuesDetails = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalAddQuesDetails"];
    if (proposalAddQuesDetails) {
        [PRXMLData setObject:proposalAddQuesDetails forKey:@"proposalAddQuesDetails"];
    }    
    
    //Getting proposalDividenInfo key
    NSDictionary *proposalDividenInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalDividenInfo"];
    if (proposalDividenInfo) {
        [PRXMLData setObject:proposalDividenInfo forKey:@"proposalDividenInfo"];
    }
    
    NSDictionary *proposalFundInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalFundInfo"];
    if (proposalDividenInfo) {
        [PRXMLData setObject:proposalFundInfo forKey:@"proposalFundInfo"];
    }    
    
    //getting proposalNomineeInfo key
    NSDictionary *proposalNomineeInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalNomineeInfo"];
    if (proposalNomineeInfo) {
        [PRXMLData setObject:proposalNomineeInfo forKey:@"proposalNomineeInfo"];
    }
    
    //Getting proposalTrusteeInfo key
    NSDictionary *proposalTrusteeInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalTrusteeInfo"];
    if (proposalTrusteeInfo) {
        [PRXMLData setObject:proposalTrusteeInfo forKey:@"proposalTrusteeInfo"];
    }    
    
    //Getting proposalCODetails key
    NSDictionary *proposalCODetails = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"proposalCODetails"];
    if (proposalCODetails) {
        [PRXMLData setObject:proposalCODetails forKey:@"proposalCODetails"];
    }
    
    //getting iMobileExtraInfo
    NSDictionary *iMobileExtraInfo = [[obj.eAppData objectForKey:@"EAPPDataSet"] objectForKey:@"iMobileExtraInfo"];
    if (iMobileExtraInfo) {
        [PRXMLData setObject:iMobileExtraInfo forKey:@"iMobileExtraInfo"];
    }
    
    return PRXMLData;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (appobject.ViewDeleteSubmissionBool==YES) {
        (appobject.ViewDeleteSubmissionBool = NO);
        return 6;
    } else  {
        return 7;//[self.players count];
    }
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *eAppCellIdentifier = @"ProposalFormCell";
    static NSString *PolicyOwnerCellIdentifier = @"SupplementaryFormCell";
    static NSString *SICellIdentifier = @"SIFormCell";
    static NSString *CFFCellIdentifier = @"CFFFormCell";
    static NSString *COACellIdentifier = @"COAFormCell";
    static NSString *EAuthCellIdentifier = @"EAuthFormCell";
    static NSString *GenFormsCellIdentifier = @"GenerateFormsCell";
    
    UITableViewCell *cell;
    
    //initialize Form path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *FormsPath =  [documentsDirectory stringByAppendingPathComponent:@"Forms"];
    
    NSString *otherIDType_check = @"CR";
    NSString *ptypeCode_check = @"PO";
    NSString *comcase = @"No";
    
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *results_check_comcase = [database executeQuery:@"SELECT * from eProposal_LA_Details WHERE eProposalNo = ? AND PTypeCode =? AND LAOtherIDType = ?", [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"], ptypeCode_check, otherIDType_check];
    
    while ([results_check_comcase next]) {
        comcase = @"Yes";
    }
    
    if (indexPath.row == 0){
        eappCell = [tableView dequeueReusableCellWithIdentifier:eAppCellIdentifier];
        
        //check if Form exists.
        if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_PR.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
            
            UIImage *doneImage = [UIImage imageNamed: @"iconComplete.png"];
            [eappCell.statusLabel1 setImage:doneImage];
            eappCell.tag = 1;
        }
        
        return eappCell;
    }
    else if (indexPath.row == 1){
        poCell = [tableView dequeueReusableCellWithIdentifier:PolicyOwnerCellIdentifier];
        
        //check if Form exists.
        if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SP_1.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
            
            UIImage *doneImage = [UIImage imageNamed: @"iconComplete.png"];
            [poCell.statusImage1 setImage:doneImage];
            poCell.tag = 1;
        }
        
        return poCell;
    }
    else if (indexPath.row == 2){
        siCell = [tableView dequeueReusableCellWithIdentifier:SICellIdentifier];
        
        //check if Form exists.
        if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SI.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
            
            UIImage *doneImage = [UIImage imageNamed: @"iconComplete.png"];
            [siCell.statusImage1 setImage:doneImage];
            siCell.tag = 1;
        }
        
        siCell.tag = 1;
        
        return siCell;
    }
    else if (indexPath.row == 3){
        cffCell = [tableView dequeueReusableCellWithIdentifier:CFFCellIdentifier];
        if([comcase isEqualToString:@"No"]){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_FF.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
                
                UIImage *doneImage = [UIImage imageNamed: @"iconComplete.png"];
                [cffCell.statusLabel1 setImage:doneImage];
                cffCell.tag = 1;
            }
        }
        else if([comcase isEqualToString:@"Yes"]){
            UIImage *doneImage = [UIImage imageNamed: @"iconNotComplete.png"];
            [cffCell.statusLabel1 setImage:doneImage];
            cffCell.tag = 1;
        }
        return cffCell;
        
    }
    else if (indexPath.row == 4){
        coaCell = [tableView dequeueReusableCellWithIdentifier:COACellIdentifier];
        
        //check if Form exists.
        if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_CA.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
            
            UIImage *doneImage = [UIImage imageNamed: @"iconComplete.png"];
            [coaCell.statusLabel1 setImage:doneImage];
            coaCell.tag = 1;
        }
        
        return coaCell;
        
    }
    else if (indexPath.row == 5){
        eauthCell = [tableView dequeueReusableCellWithIdentifier:EAuthCellIdentifier];
        
        //check if Form exists.
        if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_AU.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
            
            UIImage *doneImage = [UIImage imageNamed: @"iconComplete.png"];
            [eauthCell.statusLabel1 setImage:doneImage];
            eauthCell.tag = 1;
        }
        
        
        return eauthCell;
        
    }
    else if (indexPath.row == 6)
    {
        genformsCell = [tableView dequeueReusableCellWithIdentifier:GenFormsCellIdentifier];
        
        if (appobject.ViewFromPendingBool==YES) {
            
            genformsCell.hidden =YES;
            genformsCell.userInteractionEnabled =NO;
            appobject.ViewFromPendingBool=NO;
            appobject.ViewFromSubmissionBool=NO;
            
            
            
        }
        if (appobject.ViewFromSubmissionBool==YES)
        {
            genformsCell.hidden =YES;
            genformsCell.userInteractionEnabled =NO;
            appobject.ViewFromPendingBool=NO;
            appobject.ViewFromSubmissionBool=NO;
        }
		
		NSString *isPOSign;
		NSString *DatePOSign;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"hladb.sqlite"];
		
		FMDatabase *db = [FMDatabase databaseWithPath:path];
		if (![db open]) {
			NSLog(@"Could not open db.");
			db = [FMDatabase databaseWithPath:path];
			
			[db open];
		}
		
		NSString *displayThis = nil;
		displayThis = [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"];
		if (displayThis ==nil) {
			displayThis = @"";
		}
		
		FMResultSet *result_eSign = [db executeQuery:@"SELECT * from eProposal_Signature WHERE eProposalNo = ? ",displayThis];
		
		while ([result_eSign next])
		{
			isPOSign = [result_eSign stringForColumn:@"isPOSign"];
			DatePOSign = [result_eSign stringForColumn:@"DatePOSign"];			
			
			if  ((NSNull *) isPOSign == [NSNull null]||[isPOSign isEqualToString:@""]||isPOSign ==Nil)
			{
				isPOSign =@"";
			}			
		}
		
		if ([isPOSign isEqualToString:@"YES"])
		{
			genformsCell.hidden =YES;
            genformsCell.userInteractionEnabled =NO;
		}
		else
		{			
			[buttonGenerate setHidden:NO];
			
			
		}
        
        return genformsCell;        
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSString *proposalform12 =   [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"];
    NSArray *array=[[NSUserDefaults standardUserDefaults] objectForKey:@"compareString"];
	
    if(indexPath.row != 6)
    {
        //initialize Form path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *FormsPath =  [documentsDirectory stringByAppendingPathComponent:@"Forms"];
        
        NSString *otherIDType_check = @"CR";
        NSString *ptypeCode_check = @"PO";
        NSString *comcase = @"No";
        
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:path];
        [database open];
        
        FMResultSet *results_check_comcase = [database executeQuery:@"SELECT * from eProposal_LA_Details WHERE eProposalNo = ? AND PTypeCode =? AND LAOtherIDType = ?", [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"], ptypeCode_check, otherIDType_check];
        
        while ([results_check_comcase next]) {
            comcase = @"Yes";
        }
        if(indexPath.row == 0){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_PR.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
                
                [self showFormDetails:indexPath];
            }
        }
        else if(indexPath.row == 1){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SP_1.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
                
                [self showFormDetails:indexPath];
            }
        }
        else if(indexPath.row == 2){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SI.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
                indexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                [self forSIdetails];
                [self showFormDetails:indexPath];
            }
        }
        else if((indexPath.row == 3) && [comcase isEqualToString:@"No"]){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_FF.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){                
                indexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                [self showFormDetails:indexPath];
            }
        }
        else if(indexPath.row == 4){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_CA.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
                indexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                [self showFormDetails:indexPath];
            }
        }
        else if(indexPath.row == 5)	{            
            if ([array containsObject:proposalform12]) {                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);                
                NSString *documentsDirectory = [paths objectAtIndex:0];                
                NSString *xmlPRPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ProposalXML/%@_PR.xml",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]];                
                NSString *str = [NSString stringWithContentsOfFile:xmlPRPath encoding:NSUTF8StringEncoding error:nil];                
                NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:str];                
                
//                _signController = [[eSignController alloc]init];
//                
//                _signController.delegate=self;
//                _signController.cellRghtbuttonDisabled1 =@"disable";                
//                [_signController eApplicationForProposalNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] fromInfoDic:xmlDoc];                
//                _signController.view.frame = CGRectMake(0, 20, _signController.view.frame.size.width, _signController.view.frame.size.height);
//                
//                [self.navigationController.view addSubview:_signController.view];
                
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *proposalform12 =   [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"];
    NSArray *array=[[NSUserDefaults standardUserDefaults] objectForKey:@"compareString"];
    
    if(indexPath.row != 6)
    {        
        NSString *otherIDType_check = @"CR";
        NSString *ptypeCode_check = @"PO";
        NSString *comcase = @"No";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path1 = [docsPath stringByAppendingPathComponent:@"hladb.sqlite"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:path1];
        [database open];
        
        FMResultSet *results_check_comcase = [database executeQuery:@"SELECT * from eProposal_LA_Details WHERE eProposalNo = ? AND PTypeCode =? AND LAOtherIDType = ?", [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"], ptypeCode_check, otherIDType_check];
        
        while ([results_check_comcase next]) {
            comcase = @"Yes";
        }
        
        //initialize Form path
        NSString *documentsDirectory = [paths objectAtIndex:0];        
        NSString *FormsPath =  [documentsDirectory stringByAppendingPathComponent:@"Forms"];        
        
        if(indexPath.row == 0){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_PR.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){                
                [self showFormDetails:indexPath];
            }
        }
        else if(indexPath.row == 1){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SP_1.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){                
                [self showFormDetails:indexPath];
            }
        }
        else if(indexPath.row == 2){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_SI.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
                indexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                //[self forSIdetails];
                [self showFormDetails:indexPath];
            }
        }
        else if((indexPath.row == 3) && [comcase isEqualToString:@"No"]){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_FF.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){                
                indexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                [self showFormDetails:indexPath];
            }
        }
        else if(indexPath.row == 4){
            //check if Form exists.
            if([[NSFileManager defaultManager] fileExistsAtPath:[FormsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_CA.pdf",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]]]){
                indexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
                [self showFormDetails:indexPath];
            }
        }        
        else if(indexPath.row == 5) {            
            if ([array containsObject:proposalform12]) {                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);                
                NSString *documentsDirectory = [paths objectAtIndex:0];                
                NSString *xmlPRPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ProposalXML/%@_PR.xml",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]];                
                NSString *str = [NSString stringWithContentsOfFile:xmlPRPath encoding:NSUTF8StringEncoding error:nil];
                
                NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:str];                
                
//                _signController = [[eSignController alloc]init];
//                
//                _signController.delegate=self;
//                _signController.cellRghtbuttonDisabled1 =@"disable";                
//                [_signController eApplicationForProposalNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] fromInfoDic:xmlDoc];
//                                
//                _signController.view.frame = CGRectMake(0, 20, _signController.view.frame.size.width, _signController.view.frame.size.height);
//                
//                [self.navigationController.view addSubview:_signController.view];
                
            }            
            
        }
    }
    
}

- (UIView *)createUIForPDF
{
    UIView *pdfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    int y = 0;
    
    
    for (int i= 1 ; i<6; i++) {
        [[NSUserDefaults standardUserDefaults]setInteger:i forKey:@"pageNo"];
//        NSMutableData *data;
//        struct SIGNDOC_ByteArray *blob;
//        blob = renderTest(self.view.frame.size.height*2);
//        data = [[NSMutableData alloc] initWithBytesNoCopy:SIGNDOC_ByteArray_data(blob) length:SIGNDOC_ByteArray_count(blob)];
//        UIImage *resultImage = [UIImage imageWithData:data];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"image%i.png",i]];
        
        // Save image.
//        [UIImagePNGRepresentation(resultImage) writeToFile:filePath atomically:YES];
        
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height*2)];
//        [imgView setImage:resultImage];
        [pdfView addSubview:imgView];
        y+= (self.view.frame.size.height*2) + 10;
    }
    pdfView.frame = CGRectMake(0, 0, self.view.frame.size.width, y+50);
    return pdfView;
}

-(void)showEcondfromData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *documentsDirectory = [paths objectAtIndex:0];    
    NSString *xmlPRPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ProposalXML/%@_PR.xml",[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]]];    
    NSString *str = [NSString stringWithContentsOfFile:xmlPRPath encoding:NSUTF8StringEncoding error:nil];    
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:str];    
    
    [self eApplicationForProposalNo:[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"] fromInfoDic:xmlDoc];
    
    
}

#pragma mark - Local Method
-(NSString *)eApplicationForProposalNo:(NSString *)proposalNo fromInfoDic:(NSDictionary *)infoDic
{
    if (infoDic) {        
        ESignGenerator*  _eApplicationGenerator = [[ESignGenerator alloc]init];
        NSString *outPutFile=[_eApplicationGenerator eApplicationForProposalNo:proposalNo fromInfoDic:infoDic];
        
        SetPDFPath(outPutFile);
        PDFViewController*_pdfViewController = [[PDFViewController alloc] initWithPath:outPutFile];
        _pdfViewController.title = proposalNo;
        
        ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
        
        _navC = [[UINavigationController alloc]initWithRootViewController:_pdfViewController];
        _navC.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
        _navC.view.frame = self.view.frame;
        _navC.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        _navC.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
        
        _pdfViewController.view.frame=_navC.view.frame;
        _navC.navigationBar.translucent = NO;
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"e-Application Report" style:UIBarButtonItemStylePlain target:self action:@selector(cancelIt)];
        
        [_pdfViewController.navigationItem setLeftBarButtonItems:@[cancelBarButtonItem]];
        
        cancelBarButtonItem.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
        
        [self.navigationController pushViewController:_pdfViewController animated:YES];
        
    }
    return nil;
}

-(void)cancelIt{
    [self.navigationController popViewControllerAnimated:YES];
    _navC=nil;
}

-(void)showFormDetails:(NSIndexPath *) indexPath
{
    UIStoryboard *newStoryboard = [UIStoryboard storyboardWithName:@"NewStoryboard" bundle:Nil];
    FormViewController *form = [newStoryboard instantiateViewControllerWithIdentifier:@"forms"];
    NSString *title;
    if (indexPath.row == 0) {
        title =  @"Proposal Form";
    }
    else if (indexPath.row == 1) {
        title =  @"Sales Illustration";
    }
    else if (indexPath.row == 2) {
        title =  @"Customer Fact Find";
    }
    else if (indexPath.row == 3) {
        title =  @"Confirmation Of Advice Form Given To";
    }
    
    
    if  ((NSNull *) [dataItems objectAtIndex:indexPath.row] == [NSNull null])
        form.fileName  = @"";
    else
        form.fileName = [dataItems objectAtIndex:indexPath.row];
    
    if  ((NSNull *) title == [NSNull null])
        title = @"";
    else
        form.fileTitle = title;
    
    
    if(![form.fileName isEqualToString:@"" ] && ![form.fileTitle isEqualToString:@""] )        
        [self.navigationController pushViewController:form animated:YES];
        
}


- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}



-(void)forSIdetails{
    CashPromiseViewController *CPReportPage = [[CashPromiseViewController alloc] init ];
    
    
    CPReportPage.SINo =[[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"SINumber"];
    
    CPReportPage.PDSorSI = @"SI";
    CPReportPage.isNotSummary = TRUE;
    CPReportPage.pPlanCode = [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"SIPlanName"];//HLACP
    
    CPReportPage.lang =@"English";
    
    [CPReportPage deleteTemp];
    [CPReportPage calculateForReport];
    
    [self presentViewController:CPReportPage animated:NO completion:Nil];
        
    [CPReportPage generateJSON_HLCP:NO];    
    [CPReportPage copyReportFolderToDoc:@"SI"];    
    [CPReportPage dismissViewControllerAnimated:NO completion:Nil];
    
    NSString *path;
	NSString *tempFileName = [NSString stringWithFormat:@"SI/eng_%@_Page1", [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"SIPlanName"]];
	path = [[NSBundle mainBundle] pathForResource:tempFileName ofType:@"html"];
	
    
    NSURL *pathURL = [NSURL fileURLWithPath:path];    
    NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);    
    NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];    
    NSData* data = [NSData dataWithContentsOfURL:pathURL];    
    [data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];    
    NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];    
    if([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {        
        NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];        
        NSString *SIPDFName = [NSString stringWithFormat:@"Forms/%@_SI.pdf", [[obj.eAppData objectForKey:@"EAPP"] objectForKey:@"eProposalNo"]];
        
        self.PDFCreator = [NDHTMLtoPDF exportPDFWithURL:targetURL
                                             pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
                                               delegate:self
                                               pageSize:kPaperSizeA4
                                                margins:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        
        
    }
    NSLog(@"Generate Forms : Sales Illustration - generated!");
    
}

- (NSDictionary *) populateProposalFormData {
    return NULL;
}

- (NSDictionary *) populateSuppFormData {
    return NULL;
}

- (NSDictionary *) populateSIFormData {
    return NULL;
}

- (NSDictionary *) populateFFFormData {
    return NULL;
}

- (NSDictionary *) populateCAFormData {
    return NULL;
}

- (NSDictionary *) populateApplicationAuthData {
    return NULL;
}

- (void)viewDidUnload {
    [self setTextLabel:nil];
    [super viewDidUnload];
}
@end
