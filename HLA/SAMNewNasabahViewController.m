//
//  SAMNewNasabahViewController.m
//  BLESS
//
//  Created by administrator on 3/27/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMNewNasabahViewController.h"
#import "SAMActivityViewController.h"
#import "SAMMeetingScheduleViewController.h"

@interface SAMNewNasabahViewController ()

@end

@implementation SAMNewNasabahViewController

@synthesize dashboardVC;
@synthesize txtNip;
@synthesize txtReferralName;
@synthesize txtKcu;
@synthesize txtKanwil;
@synthesize txtBranchCode;
@synthesize txtBranchName;
@synthesize txtProspectFullName;
@synthesize outletDoB;
@synthesize segNationality;
@synthesize segGender;
@synthesize gender;
@synthesize nationality;
@synthesize SIDate;
@synthesize SIDatePopover;

@synthesize outletReferralSource;

int const CONTINUE_ALERT_TAG = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    dispatch_async (dispatch_get_main_queue(), ^{
        [scrollViewForm setContentSize:CGSizeMake(819, 1901)];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (bool)validationDataReferral{
    bool valid=true;
    NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@"- SELECT -",@"- Select -", nil];
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    
    //validation message data refferal
    NSString *validationNIP=@"NIP harus diisi";
    NSString *validationNamaReferral=@"Nama Referral harus diisi";
    NSString *validationSumberReferral=@"Sumber Referral harus diisi";
    NSString *validationKodeCabang=@"Kode Cabang harus diisi";
    NSString *validationNamaCabang=@"Nama Cabang harus diisi";
    NSString *validationKCU=@"KCU harus diisi";
    //textNIP
    NSString* NIP=txtNip.text;
    //outlet sumber referral
    NSString* refSource=outletReferralSource.titleLabel.text;
    //outletkodecabang
    NSString* branchCode=txtBranchCode.text;
    //outletnamacabang
    NSString* branchName=txtBranchName.text;
    //textKCU
    NSString* KCU=txtKcu.text;
    
    if ([validationSet containsObject:NIP]||NIP==NULL){
        [self createAlertViewAndShow:validationNIP tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:refSource]||refSource==NULL){
        [self createAlertViewAndShow:validationSumberReferral tag:0];
        [outletReferralSource setBackgroundColor:[UIColor redColor]];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:branchCode]||branchCode==NULL){
        [self createAlertViewAndShow:validationKodeCabang tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:branchName]||branchName==NULL){
        [self createAlertViewAndShow:validationNamaCabang tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:KCU]||KCU==NULL){
        [self createAlertViewAndShow:validationKCU tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        [txtKcu becomeFirstResponder];
        return false;
    }
    /*else if ([validationSet containsObject:refName]||refName==NULL){
     [self createAlertViewAndShow:validationNamaReferral tag:0];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     [txtReferralName becomeFirstResponder];
     return false;
     }*/
    return valid;
}

- (bool)validationDataPribadi{
    bool valid=true;
    NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@"- SELECT -",@"- Select -", nil];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    
    //validation message data pribadi
    NSString *validationNamaLengkap=@"Nama lengkap harus diisi";
    NSString *validationJenisKelamin=@"Jenis Kelamin harus diisi";
    NSString *validationTanggalLahir=@"Tanggal lahir harus diisi";
    NSString *validationNoHP=@"No HP harus diisi";
    
    NSString *validationJenisIdentitas=@"Jenis identitas harus diisi";
    NSString *validationNomorIdentitas=@"Nomor identitas harus diisi";
    NSString *validationKebangsaan=@"Kewarganegaraan harus diisi";
    
    //textnamalengkap
    NSString* fullName=txtProspectFullName.text;
    //segmen jenis kelamin
    //segGender.selectedSegmentIndex
    //outletDOB
    NSString* dob=outletDoB.titleLabel.text;

    //outletnationality
    NSString* outletnationality=nationality;
    
    if ([validationSet containsObject:fullName]||fullName==NULL){
        [self createAlertViewAndShow:validationNamaLengkap tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        [txtProspectFullName becomeFirstResponder];
        return false;
    }
    else if (segGender.selectedSegmentIndex==UISegmentedControlNoSegment){
        [self createAlertViewAndShow:validationJenisKelamin tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:dob]||dob==NULL){
        [self createAlertViewAndShow:validationTanggalLahir tag:0];
        [outletDoB setBackgroundColor:[UIColor redColor]];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    /*else if ([validationSet containsObject:otheridtype]||otheridtype==NULL){
     [self createAlertViewAndShow:validationJenisIdentitas tag:0];
     [OtherIDType setBackgroundColor:[UIColor redColor]];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     return false;
     }
     else if ([validationSet containsObject:otheridtext]||otheridtext==NULL){
     [self createAlertViewAndShow:validationNomorIdentitas tag:0];
     [txtOtherIDType becomeFirstResponder];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     return false;
     }
     else if ([validationSet containsObject:outletexpirydate]||outletexpirydate==NULL){
     [self createAlertViewAndShow:validationTanggalKadaluarsaIdentitas tag:0];
     [outletExpiryDate setBackgroundColor:[UIColor redColor]];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     return false;
     }*/
    
    else if ([validationSet containsObject:outletnationality]||outletnationality==NULL){
        [self createAlertViewAndShow:validationKebangsaan tag:0];
        [segNationality setBackgroundColor:[UIColor redColor]];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    return valid;
}

- (void)createAlertViewAndShow:(NSString *)message tag:(int)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                    message:[NSString stringWithFormat:@"%@",message]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    alert.tag = alertTag;
    [alert show];
}

#pragma mark - Action
- (IBAction)actionEmployeeNip:(UIButton *)sender;
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    //if (_branchInfo == nil) {
    _nipInfo = [[NIPInfo alloc] initWithStyle:UITableViewStylePlain];
    _nipInfo.delegate = self;
    //[_branchInfo setData:[NSNumber numberWithInt:sender.tag]];
    [_nipInfo.tableView reloadData];
    _nipInfoPopover = [[UIPopoverController alloc] initWithContentViewController:_nipInfo];
    //}
    [_nipInfoPopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)actionBranchInfo:(UIButton *)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    //if (_branchInfo == nil) {
    _branchInfo = [[BranchInfo alloc] initWithStyle:UITableViewStylePlain];
    _branchInfo.delegate = self;
    [_branchInfo setData:[NSNumber numberWithInt:sender.tag]];
    [_branchInfo.tableView reloadData];
    _branchInfoPopover = [[UIPopoverController alloc] initWithContentViewController:_branchInfo];
    //}
    [_branchInfoPopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)actionReferralSource:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_referralSource == nil) {
        _referralSource = [[ReferralSource alloc] initWithStyle:UITableViewStylePlain];
        _referralSource.delegate = self;
        _referralSourcePopover = [[UIPopoverController alloc] initWithContentViewController:_referralSource];
    }
    [_referralSourcePopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ActionGender:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segGender selectedSegmentIndex]==0) {
        gender = @"MALE";
    } else if([segGender selectedSegmentIndex]==1) {
        gender = @"FEMALE";
    }
}

- (IBAction)ActionNationality:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segNationality selectedSegmentIndex]==0) {
        nationality = @"WNI";
    } else if([segGender selectedSegmentIndex]==1) {
        nationality = @"WNA";
    }
}

- (IBAction)btnDOB:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString;
    if ([outletDoB.titleLabel.text length]>0){
        dateString= outletDoB.titleLabel.text;
    }
    else{
        dateString= [dateFormatter stringFromDate:[NSDate date]];
    }
    
    
    /*outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     
     if([txtDOB.text isEqualToString:@""]) {
     [outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", dateString] forState:UIControlStateNormal];
     txtDOB.text = dateString;
     } else {
     [outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", outletDOB.titleLabel.text] forState:UIControlStateNormal];
     }*/
    
    if (_SIDate == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        self.SIDate = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    _SIDate.ProspectDOB = dateString;
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:NO];
    
    //dateFormatter = Nil;
    //dateString = Nil;
}

-(IBAction)ActionContinue:(id)sender {
    UIAlertView *continueAlert = [[UIAlertView alloc] initWithTitle:@"Data Nasabah tersimpan" message:@"Apakah Anda ingin melanjutkan proses?" delegate:self cancelButtonTitle:@"Lanjut" otherButtonTitles: @"Jadwalkan Meeting", nil];
    [continueAlert setTag:CONTINUE_ALERT_TAG];
    [continueAlert show];
}

#pragma mark - delegate
-(void)selectedNIP:(NSString *)nipNumber Name:(NSString *)name{
    [txtNip setText:nipNumber];
    [txtReferralName setText:name];
    [_nipInfoPopover dismissPopoverAnimated:YES];
}

-(void)selectedBranch:(NSString *)branchCode BranchName:(NSString *)branchName BranchStatus:(NSString *)branchStatus BranchKanwil:(NSString *)branchKanwil {
    txtBranchCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtBranchName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [txtBranchCode setText:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",branchCode]];
    [txtBranchName setText:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",branchName]];
    [txtBranchCode setBackgroundColor:[UIColor clearColor]];
    //[outletBranchName setBackgroundColor:[UIColor clearColor    ]];
    [txtKcu setText:branchStatus];
    [txtKanwil setText:branchKanwil];
    [_branchInfoPopover dismissPopoverAnimated:YES];
}

-(void) selectedReferralSource:(NSString *)referralSource {
    outletReferralSource.titleLabel.text = referralSource;
    if([referralSource isEqualToString:@"- SELECT -"]) {
        outletReferralSource.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        outletReferralSource.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    [outletReferralSource setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",referralSource]forState:UIControlStateNormal];
    [outletReferralSource setBackgroundColor:[UIColor clearColor]];
    [_referralSourcePopover dismissPopoverAnimated:YES];
}

-(void) DateSelected:(NSString *)strDate :(NSString *)dbDate {
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
    
    //KY
    
    if ([d compare:d2] == NSOrderedAscending){
        NSString *validationTanggalLahirFuture=@"Tanggal lahir tidak dapat lebih besar dari tanggal hari ini";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    } else{
        outletDoB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //[outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
        [outletDoB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
        [outletDoB setBackgroundColor:[UIColor clearColor]];
    }
    
    df = Nil, d = Nil, d2 = Nil;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == CONTINUE_ALERT_TAG) {
        if(buttonIndex == 0) {
            //Pressed "Lanjutkan"
            [self.navigationController popViewControllerAnimated:YES];
            [dashboardVC actionActivityView];
            
        } else {
            //Pressed "Jadwalkan Meeting"
            SAMMeetingScheduleViewController *samMeetingScheduleVC = [[SAMMeetingScheduleViewController alloc] initWithNibName:@"SAMMeetingScheduleViewController" bundle:nil];
            [samMeetingScheduleVC setModalPresentationStyle:UIModalPresentationFormSheet];
            samMeetingScheduleVC.preferredContentSize = CGSizeMake(703, 306);
            [self presentViewController:samMeetingScheduleVC animated:YES completion:nil];
        }
    }
}

@end
