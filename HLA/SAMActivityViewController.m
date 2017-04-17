//
//  SAMActivityViewController.m
//  BLESS
//
//  Created by Basvi on 12/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMActivityViewController.h"
#import "SAMMeetingScheduleViewController.h"
#import "SAMMeetingNoteViewController.h"
#import "SAMRecommendationViewController.h"
#import "MainCustomer.h"
#import "MainScreen.h"
#import "ProductInformation.h"
#import "SPAJ Main.h"
#import "CFFListingViewController.h"
#import "SIListing.h"
#import "SPAJ E Application List.h"
#import "ModelCFFTransaction.h"
#import "SAMDBHelper.h"
#import "Formatter.h"

int progress;
SAMDBHelper *dbHelper;
Formatter *formatter;

@interface SAMActivityViewController (){
    SAMMeetingScheduleViewController* samMeetingScheduleVC;
    SAMMeetingNoteViewController* samMeetingNoteVC;
    ModelCFFTransaction *modelCFFTransaction;
}

@end

@implementation SAMActivityViewController {
    NSMutableArray* arrayCFFTransaction;
}

@synthesize _SAMModel;
@synthesize SAMDataRow;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCircleAndBorderView];
    samMeetingScheduleVC = [[SAMMeetingScheduleViewController alloc]initWithNibName:@"SAMMeetingScheduleViewController" bundle:nil];
    samMeetingNoteVC = [[SAMMeetingNoteViewController alloc] initWithNibName:@"SAMMeetingNoteViewController" bundle:nil];
    modelCFFTransaction = [[ModelCFFTransaction alloc] init];
    formatter = [[Formatter alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated {
    dbHelper = [[SAMDBHelper alloc] init];
    NSMutableArray *SAMDatas = [dbHelper readAllSAMData];
    _SAMModel = SAMDatas[SAMDataRow];
    
    [self UpdateProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCircleAndBorderView{
    
    for (UIView *view in viewActivitySteps.subviews){
        if ([view isKindOfClass:[UIView class]]){
            view.layer.cornerRadius = view.bounds.size.width/2;
            for (UIView *viewInner in view.subviews){
                viewInner.layer.cornerRadius = viewInner.bounds.size.width/2;
            }
        }
    }
    
    viewActivityComments.layer.borderWidth = 1.0;
    viewActivityComments.layer.borderColor = [UIColor colorWithRed:137.0/255.0 green:199.0/255.0 blue:101.0/255.0 alpha:1.0].CGColor;
}

- (void) loadSAMData {
    
}

/**
 Called to update progress circle button every time agent go to every module
 */
- (void) UpdateProgress {
    NSDictionary *dictSearch = [[NSDictionary alloc] initWithObjectsAndKeys:_SAMModel.customerID, @"ProspectIndexNo", nil];
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    UIColor *orange = [UIColor colorWithRed:250.0/255.0 green:175.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s;
    // We search for customer's CFF that has been completed.
    s = [database executeQuery:[NSString stringWithFormat:@"select CFFT.* from CFFTransaction CFFT where CFFT.ProspectIndexNo=\"%@\" AND CFFT.CFFStatus=\"Completed\"" ,[dictSearch valueForKey:@"ProspectIndexNo"]]];
    
    while([s next]) { // if found, we update the circle bar to orange to indicate that the process has been completed
        progress = 1; // Update progress, now we can press next button
        [self UpdateProgressButton:0 Color:orange];
    }
    
    if(!([_SAMModel.idRecomendation isEqualToString:@""] || [_SAMModel.idRecomendation isEqualToString:@"(null)"])) {
        progress = 2;
        [self UpdateProgressButton:1 Color:orange];
    }
    
    if(!([_SAMModel.idVideo isEqualToString:@""] || [_SAMModel.idVideo isEqualToString:@"(null)"])) {
        progress = 3;
        [self UpdateProgressButton:2 Color:orange];
    }
    
    if(!([_SAMModel.idIllustration isEqualToString:@""] || [_SAMModel.idIllustration isEqualToString:@"(null)"])) {
        progress = 4;
        [self UpdateProgressButton:3 Color:orange];
    }
    
    //TODO: Add Update progress if Application is completed
    [database close];
}

- (void) UpdateProgressButton: (int)_id Color: (UIColor *)color {
    UIView *view = viewActivitySteps.subviews[_id];
    view.layer.backgroundColor = color.CGColor;
    view.layer.borderColor = color.CGColor;
    for (UIView *viewInner in view.subviews){
        viewInner.layer.borderColor = color.CGColor;
    }
}

# pragma mark - Action

-(IBAction)actionScheduleMeeting:(id)sender{
    [samMeetingScheduleVC setModalPresentationStyle:UIModalPresentationFormSheet];
    samMeetingScheduleVC.preferredContentSize = CGSizeMake(703, 306);
    [self presentViewController:samMeetingScheduleVC animated:YES completion:nil];
}

-(IBAction)actionNewMeetingNote:(id)sender {
    [samMeetingNoteVC setModalPresentationStyle:UIModalPresentationFormSheet];
    samMeetingNoteVC.preferredContentSize = CGSizeMake(703, 456);
    [self presentViewController:samMeetingNoteVC animated:YES completion:nil];
}

-(IBAction)actionCFF:(id)sender {
    CFFListingViewController *cffListingVC = [[CFFListingViewController alloc] initWithNibName:@"CFFListingViewController" bundle:nil];
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDel.isFromSAM = YES;
    appDel.SAMData = _SAMModel;
    cffListingVC.isFromSAM = YES;
    cffListingVC.SAMFilter = _SAMModel.customerName;
    [self.navigationController pushViewController:cffListingVC animated:YES];
    
    //UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"CFFStoryboard" bundle:Nil];
    //MainCustomer *mainCustomer = [cpStoryboard instantiateViewControllerWithIdentifier:@"mainCFF"];
    //mainCustomer.modalPresentationStyle = UIModalPresentationFullScreen;
    //mainCustomer.IndexTab = 1;
    //[self.navigationController pushViewController:mainCustomer animated:YES];
    //mainCustomer = Nil;
    //AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //appdlg.eApp=NO;
}

-(IBAction)actionRecomendation:(id)sender {
    if(progress > 0) {
        SAMRecommendationViewController *view = [[SAMRecommendationViewController alloc] initWithNibName:@"SAMRecommendationViewController" bundle:nil];
        view.modalTransitionStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:view animated:YES];
        _SAMModel.idRecomendation = @"1";
        _SAMModel.dateModified = [formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"];
        [dbHelper UpdateSAMData:_SAMModel];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Harap mengisi CFF terlebih dahulu" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(IBAction)actionVideo:(id)sender {
    if(progress > 1) {
        ProductInformation *view = [[ProductInformation alloc] initWithNibName:@"ProductInformation" bundle:nil];
        view.modalTransitionStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:view animated:YES];
        view.navigationItem.title = @"Informasi Produk";
        _SAMModel.idVideo = @"1";
        _SAMModel.dateModified = [formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"];
        [dbHelper UpdateSAMData:_SAMModel];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Harap membuka Rekomendasi Produk terlebih dahulu" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(IBAction)actionIllustration:(id)sender {
    // Override option, open the Traditional SI
    //TODO: Add check if customer already had illustration
    if (progress > 3) { // Customer already had illustration, cannot make a new one
        UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"HLAWPStoryboard" bundle:Nil];
        AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        SIListing *SIListing = [cpStoryboard instantiateViewControllerWithIdentifier:@"SIListing"];
        SIListing.TradOrEver = @"TRAD";
        [self.navigationController pushViewController:SIListing animated:YES];
    } else if(progress > 2) {
        UIStoryboard *cpStoryboard = [UIStoryboard storyboardWithName:@"HLAWPStoryboard" bundle:Nil];
        AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        SIListing *SIListing = [cpStoryboard instantiateViewControllerWithIdentifier:@"SIListing"];
        SIListing.TradOrEver = @"TRAD";
        [appdlg setIsFromSAM:YES];
        [appdlg setSAMData:_SAMModel];
        [self.navigationController pushViewController:SIListing animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Harap membuka Video terlebih dahulu" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(IBAction)actionSPAJ:(id)sender {
    if(progress > 3) {
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        [delegate setIsFromSAM:YES];
        [delegate setSAMData:_SAMModel];
        SPAJMain* viewController = [[SPAJMain alloc] initWithNibName:@"SPAJ Main" bundle:nil];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Harap membuat Illustrasi terlebih dahulu" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
//
//    UIStoryboard *spajStoryboard = [UIStoryboard storyboardWithName:@"SPAJEAppListStoryBoard" bundle:Nil];
//    SPAJEApplicationList *viewControllerEappListing = [spajStoryboard instantiateViewControllerWithIdentifier:@"EAppListRootVC"];
//    [self addChildViewController:viewControllerEappListing];
//    [self presentViewController:viewControllerEappListing animated:YES completion:nil];
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
