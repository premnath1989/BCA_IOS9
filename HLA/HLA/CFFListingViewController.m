//
//  CFFListingViewController.m
//  BLESS
//
//  Created by Basvi on 6/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CFFListingViewController.h"
#import "ListingTbViewController.h"
#import "ModelCFFTransaction.h"
#import "ModelProspectSpouse.h"
#import "ModelProspectChild.h"
#import "ModelCFFAnswers.h"
#import "Formatter.h"
#import "SIDate.h"
#import "ModelCFFHtml.h"
#import "CFFAPIController.h"

@interface CFFListingViewController ()<SIDateDelegate,ListingTbViewControllerDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate>{
    SIDate* datePickerViewController;
    ListingTbViewController *ProspectList;
    ModelCFFTransaction *modelCFFTransaction;
    ModelProspectChild *modelProspectChild;
    ModelProspectSpouse *modelProspectSpouse;
    ModelCFFAnswers *modelCFFAnswers;
    Formatter* formatter;
    ModelCFFHtml* modelCFFHtml;
    CFFAPIController* cffAPIController;
}

@end

@implementation CFFListingViewController{
    UIColor *borderColor;
    
    UIBarButtonItem* rightButton;
    
    NSMutableArray *ItemToBeDeleted;
    NSMutableArray *indexPaths;
    
    IBOutlet UITableView *tableCFFListing;
    UIPopoverController *prospectPopover;
    int clientProfileID;
    NSString* sortedBy;
    NSString* sortMethod;
    NSString *databasePath;
    
    NSMutableArray* arrayCFFTransaction;
    IBOutlet UIButton *outletEditBtn;
    IBOutlet UIButton *outletDeleteBtn;

    IBOutlet UIButton *outletDate;
    IBOutlet UIButton *outletSearch;
    IBOutlet UITextField *textName;
    IBOutlet UITextField *textBranch;
    
    IBOutlet UIButton *btnSortFullName;
    IBOutlet UIButton *btnSortDOB;
    IBOutlet UIButton *btnSortBranchName;
    IBOutlet UIButton *btnSortPhoneNumber;
    IBOutlet UIButton *btnSortDateCreated;
    IBOutlet UIButton *btnSortDateModified;
    IBOutlet UIButton *btnSortStatus;

    UIPopoverController *popoverController;
    int RecDelete;
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadCFFTransaction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:88.0f/255.0f green:89.0f/255.0f blue:92.0f/255.0f alpha:1],NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:17.0f]}];
    borderColor=[[UIColor alloc]initWithRed:0/255.0 green:102.0/255.0 blue:179.0/255.0 alpha:1.0];
    RecDelete = 0;
    [self createBlackStatusBar];
    [self voidCreateRightBarButton];
    [self setButtonImageAndTextAlignment];
    [self setTextfieldBorder];
    
    
    modelCFFTransaction = [[ModelCFFTransaction alloc]init];
    modelCFFAnswers = [[ModelCFFAnswers alloc]init];
    modelProspectSpouse = [[ModelProspectSpouse alloc]init];
    modelProspectChild = [[ModelProspectChild alloc]init];
    modelCFFHtml=[[ModelCFFHtml alloc]init];
    cffAPIController = [[CFFAPIController alloc]init];
    
    formatter = [[Formatter alloc]init];
    
    sortedBy=@"CFFT.CFFDateModified";
    sortMethod=@"DESC";
    
    outletDeleteBtn.hidden = TRUE;
    outletDeleteBtn.enabled = FALSE;
    ItemToBeDeleted = [[NSMutableArray alloc] init];
    
    [self loadCFFTransaction];

    //Penyebab lambat
    /*[self copyHTMLFile:@"PotentialDiscussion"];
    [self copyHTMLFile:@"ProfileRisk"];
    [self copyHTMLFile:@"Proteksi"];
    [self copyHTMLFile:@"Pensiun"];
    [self copyHTMLFile:@"Pendidikan"];
    [self copyHTMLFile:@"Warisan"];
    [self copyHTMLFile:@"Investasi"];
    [self copyHTMLFile:@"CustomerStatement"];
    [self fetchHTMLInfo];*/
    // Do any additional setup after loading the view from its nib.
}

-(void)voidCreateRightBarButton{
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self
                                                  action:@selector(actionRightBarButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(IBAction)actionRightBarButtonPressed:(UIBarButtonItem *)sender{
    if (ProspectList == nil) {
        ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        ProspectList.delegate = self;
        
    }
    ProspectList.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:ProspectList animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [ProspectList popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = rightButton;
    popController.delegate = self;
}

-(void)copyHTMLFile:(NSString *)fileName{
    NSError *error =  nil;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePathApp = [docsDir stringByAppendingPathComponent:@"CFFfolder"];
    [cffAPIController createDirectory:filePathApp];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    [htmlData writeToFile:[NSString stringWithFormat:@"%@/%@.html",filePathApp,fileName] options:NSDataWritingAtomic error:&error];
}

-(void)setButtonImageAndTextAlignment{
    outletDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletDate.imageEdgeInsets = UIEdgeInsetsMake(0., outletDate.frame.size.width - (24 + 10.0), 0., 0.);
    outletDate.titleEdgeInsets = UIEdgeInsetsMake(0, -14.0, 0, 31.7);
    
}

-(void)setTextfieldBorder{
    UIFont *font= [UIFont fontWithName:@"BPreplay" size:16.0f];
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.layer.borderColor=borderColor.CGColor;
            textField.layer.borderWidth=1.0;
            textField.delegate=self;
            [textField setFont:font];
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
        }
    }
}



-(void)createBlackStatusBar{
    CGFloat statusBarHeight = 20.0;
    UIView* colorView = [[UIView alloc]initWithFrame:CGRectMake(0, -statusBarHeight, self.view.bounds.size.width, statusBarHeight)];
    [colorView setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:colorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    CFFQuestionsViewController* cFFQuestionsVC = [[CFFQuestionsViewController alloc]initWithNibName:@"CFFQuestionsViewController" bundle:nil];
    cFFQuestionsVC.prospectProfileID = [arrayCFFTransaction[indexPath.row] valueForKey:@"IndexNo"];
    cFFQuestionsVC.cffTransactionID = [arrayCFFTransaction[indexPath.row] valueForKey:@"CFFTransactionID"];
    cFFQuestionsVC.cffID = [arrayCFFTransaction[indexPath.row] valueForKey:@"CFFID"];
    cFFQuestionsVC.cffHeaderSelectedDictionary = [[NSDictionary alloc]initWithDictionary:arrayCFFTransaction[indexPath.row]];
    [self.navigationController pushViewController:cFFQuestionsVC animated:YES];
}

#pragma mark select prospect from list
- (IBAction)actionEdit:(id)sender
{
    
    [self resignFirstResponder];
    if ([tableCFFListing isEditing]) {
        [tableCFFListing setEditing:NO animated:TRUE];
        outletDeleteBtn.hidden = true;
        outletDeleteBtn.enabled = false;
        [outletEditBtn setTitle:@"Delete" forState:UIControlStateNormal ];
        
        ItemToBeDeleted = [[NSMutableArray alloc] init];
        indexPaths = [[NSMutableArray alloc] init];
        
        RecDelete = 0;
    }
    else {
        
        [tableCFFListing setEditing:YES animated:TRUE];
        outletDeleteBtn.hidden = FALSE;
        //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [outletEditBtn setTitle:@"Cancel" forState:UIControlStateNormal ];
    }
}

- (IBAction)deletePressed:(id)sender
{
     NSString *msg;
     if (RecDelete == 1) {
         msg = @"Apakah anda yakin ingin menghapus CFF ini ?";//Are you sure want to delete these Clients?";
     }
     else {
         msg = @"Apakah anda yakin ingin menghapus CFF ini ?";//Are you sure want to delete these Clients?";
     }
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
     [alert setTag:1001];
     [alert show];
}


- (IBAction)actionSortBy:(UIButton *)sender
{
    if (sender==btnSortFullName){
        sortedBy=@"pp.ProspectName";
    }
    else if (sender==btnSortDOB){
        sortedBy=@"pp.ProspectDOB";
    }
    else if (sender==btnSortBranchName){
        sortedBy=@"pp.BranchName";
    }
    else if (sender==btnSortDateCreated){
        sortedBy=@"CFFT.CFFDateCreated";
    }
    else if (sender==btnSortDateModified){
        sortedBy=@"CFFT.CFFDateModified";
    }
    else if (sender==btnSortStatus){
        sortedBy=@"CFFT.CFFStatus";
    }
    else if (sender==btnSortPhoneNumber){
        sortedBy=@"ContactPhone";
    }
    
    if ([sortMethod isEqualToString:@"ASC"]){
        sortMethod=@"DESC";
    }
    else{
        sortMethod=@"ASC";
    }
    [self loadCFFTransaction];
    
    
}

- (IBAction)actionDate:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString;
    if ([outletDate.titleLabel.text length]>0){
        dateString= outletDate.titleLabel.text;
    }
    else{
        dateString= [dateFormatter stringFromDate:[NSDate date]];
    }
    
    if (datePickerViewController == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        datePickerViewController = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        datePickerViewController.delegate = self;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:datePickerViewController];
    }
    datePickerViewController.ProspectDOB = dateString;
    [popoverController setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [popoverController presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:NO];
}

-(IBAction)actionSearchCFF:(id)sender{
    NSDictionary* dictSearch;
    NSString* dbDate = [formatter convertDateFrom:@"dd/MM/yyyy" TargetDateFormat:@"yyyy-MM-dd" DateValue:outletDate.titleLabel.text];
    if ([outletDate.currentTitle length]>0){
        dictSearch = [[NSDictionary alloc]initWithObjectsAndKeys:textName.text,@"Name",textBranch.text,@"BranchName",outletDate.currentTitle,@"Date", nil];
    }
    else{
        dictSearch = [[NSDictionary alloc]initWithObjectsAndKeys:textName.text,@"Name",textBranch.text,@"BranchName", nil];
    }
    arrayCFFTransaction = [modelCFFTransaction searchCFF:dictSearch];
    [tableCFFListing reloadData];
}

- (IBAction)actionClear:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    [outletDate setTitle:@"" forState:UIControlStateNormal];
    [textName setText:@""];
    [textBranch setText:@""];
    
    [self loadCFFTransaction];
}

- (IBAction)selectProspect:(id)sender
{
    if (ProspectList == nil) {
        ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        ProspectList.delegate = self;
        prospectPopover = [[UIPopoverController alloc] initWithContentViewController:ProspectList];
    }
    
    CGRect rect = [sender frame];
    rect.origin.y = [sender frame].origin.y + 40;
    
    [prospectPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)createAlertTwoOptionViewAndShow:(NSString *)message tag:(int)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Konfirmasi pembuatan CFF"
                                                    message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    alert.tag = alertTag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1) {
        if (buttonIndex==0){
            
        }
        else{
            [self CreateNewCFFTransaction];
            [self loadCFFTransaction];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    
    else if (alertView.tag==1001 && buttonIndex == 0) //delete
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
        int value;
        for(int a=0; a<sorted.count; a++) {
            value = [[sorted objectAtIndex:a] intValue] - a;
            [modelCFFTransaction deleteCFFTransaction:[[[arrayCFFTransaction objectAtIndex:value] valueForKey:@"CFFTransactionID"] intValue]];
            [modelProspectChild deleteProspectChildByCFFTransID:[[[arrayCFFTransaction objectAtIndex:value] valueForKey:@"CFFTransactionID"] intValue]];
            [modelProspectSpouse deleteProspectSpouseByCFFTransID:[[[arrayCFFTransaction objectAtIndex:value] valueForKey:@"CFFTransactionID"] intValue]];
            [modelCFFAnswers deleteCFFAnswerByCFFTransID:[[[arrayCFFTransaction objectAtIndex:value] valueForKey:@"CFFTransactionID"] intValue]];
            //remove array for index value
        }
        [ItemToBeDeleted removeAllObjects];
        [indexPaths removeAllObjects];
        outletDeleteBtn.enabled = FALSE;
        //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        
        [self loadCFFTransaction];
        
        NSString *msg = @"Profil klien berhasil dihapus";//Client Profile has been successfully deleted.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        alert = nil;
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayCFFTransaction count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    ProspectListingTableViewCell *cell1 = (ProspectListingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DataCell"];
    if (cell1 == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProspectListingTableViewCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:0];
    }
    
    if (indexPath.row<[arrayCFFTransaction count]){
        NSString* prefix=[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"Prefix"];
        NSString* mobileNumber=[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"ContactNo"];
        
        NSString *idDesc = @"";
        if ([[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"IdentityDesc"] length]>0){
            idDesc = [NSString stringWithFormat:@"%@ : ",[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"IdentityDesc"] ];
            
        }
        NSString *idNumber = @"";
        if ([[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"OtherIDTypeNo"] length]>0){
            idNumber = [[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"OtherIDTypeNo"];
        }
        NSString* prospectID = [NSString stringWithFormat:@"%@%@",idDesc,idNumber];
        
        [cell1.labelName setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"ProspectName"]];
        [cell1.labelidNum setText:prospectID];
        [cell1.labelDOB setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"ProspectDOB"]];
        [cell1.labelBranchName setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"BranchName"]];
        [cell1.labelPhone1 setText: [NSString stringWithFormat:@"%@ - %@",prefix,mobileNumber]];
        [cell1.labelDateCreated setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"CFFDateCreated"]];
        [cell1.labelDateModified setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"CFFDateModified"]];
        [cell1.labelTimeRemaining setText:[[arrayCFFTransaction objectAtIndex:indexPath.row] valueForKey:@"CFFStatus"]];
    }
    return cell1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecDelete = RecDelete+1;
    if ([tableCFFListing isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [tableCFFListing visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (!gotRowSelected) {
            ////[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDeleteBtn.enabled = FALSE;
        }
        else {
            ////[deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            outletDeleteBtn.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted addObject:zzz];
        [indexPaths addObject:indexPath];
    }
    else {
        [self showDetailsForIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecDelete = RecDelete - 1;
    
    if ([tableCFFListing isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [tableCFFListing visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (RecDelete < 1) {
            ////[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDeleteBtn.enabled = FALSE;
        }
        else {
            ////[deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            outletDeleteBtn.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted removeObject:zzz];
        [indexPaths removeObject:indexPath];
    }
}


#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    //NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == textName)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength <= 40);
    }
    if (textField == textBranch)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength <= 20);
    }
    
    return YES;
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [popoverController dismissPopoverAnimated:YES];
}

-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *d = [NSDate date];
    NSDate* d2 = [df dateFromString:strDate];
    
    NSDateFormatter *dateformatter;
    NSString *dateString;
    NSString *clientDateString;
    
    dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter* clientDateFormmater = [[NSDateFormatter alloc] init];
    [clientDateFormmater setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [dateformatter stringFromDate:[NSDate date]];
    clientDateString = [clientDateFormmater stringFromDate:d2];
    
    if ([d compare:d2] == NSOrderedAscending){
        NSString *validationTanggalLahirFuture=@"Tanggal lahir tidak dapat lebih besar dari tanggal hari ini";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                        message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    }
    else{
        [outletDate setTitle:strDate forState:UIControlStateNormal];
    }
    //DBDateFrom = strDate;
    //DBDateFrom2 = [self convertToDateFormat:strDate];
}


-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode andSmoker:(NSString *)aaSmoker andMaritalStatus:(NSString *)aaMaritalStatus;
{
    clientProfileID = [aaIndex intValue];
    [self createAlertTwoOptionViewAndShow:@"Yakin ingin membuat CFF dengan data nasabah ini ?" tag:1];
    [prospectPopover dismissPopoverAnimated:YES];
    
}

#pragma mark save to CFFTransaction
-(void)CreateNewCFFTransaction{
    NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd"];
    NSDictionary* dictActiveHtml = [[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtml]];
    NSDictionary* dictCustomerStatementCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"CS"]];
    NSDictionary* dictCustomerNeedsCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"CN"]];
    NSDictionary* dictCustomerRiskCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"CR"]];
    NSDictionary* dictPotentialDiscussionCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"PD"]];
    NSDictionary* dictProteksiCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"PRT"]];
    NSDictionary* dictPensiunCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"PSN"]];
    NSDictionary* dictPendidikanCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"PND"]];
    NSDictionary* dictWarisanCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"WRS"]];
    NSDictionary* dictInvestasiCFFID=[[NSDictionary alloc]initWithDictionary:[modelCFFHtml selectActiveHtmlForSection:@"INV"]];
    
    NSDictionary* dictCFFTransaction = [[NSDictionary alloc]initWithObjectsAndKeys:[dictActiveHtml valueForKey:@"CFFID"],@"CFFID",[NSNumber numberWithInteger:clientProfileID],@"ProspectIndexNo",dateToday,@"CFFDateCreated",@"",@"CreatedBy",dateToday,@"CFFDateModified",@"",@"ModifiedBy",@"Not Complete",@"CFFStatus",[NSString stringWithFormat:@"%@",[dictCustomerStatementCFFID valueForKey:@"CFFID"]],@"CustomerStatementCFFID",[NSString stringWithFormat:@"%@",[dictCustomerNeedsCFFID valueForKey:@"CFFID"]],@"CustomerNeedsCFFID",[NSString stringWithFormat:@"%@",[dictCustomerRiskCFFID valueForKey:@"CFFID"]],@"CustomerRiskCFFID",[NSString stringWithFormat:@"%@",[dictPotentialDiscussionCFFID valueForKey:@"CFFID"]],@"PotentialDiscussionCFFID",[NSString stringWithFormat:@"%@",[dictProteksiCFFID valueForKey:@"CFFID"]],@"ProteksiCFFID",[NSString stringWithFormat:@"%@",[dictPensiunCFFID valueForKey:@"CFFID"]],@"PensiunCFFID",[NSString stringWithFormat:@"%@",[dictPendidikanCFFID valueForKey:@"CFFID"]],@"PendidikanCFFID",[NSString stringWithFormat:@"%@",[dictWarisanCFFID valueForKey:@"CFFID"]],@"WarisanCFFID",[NSString stringWithFormat:@"%@",[dictInvestasiCFFID valueForKey:@"CFFID"]],@"InvestasiCFFID", nil];
    [modelCFFTransaction saveCFFTransaction:dictCFFTransaction];
}

#pragma mark load CFFTransaction
-(void)loadCFFTransaction{
    arrayCFFTransaction=[[NSMutableArray alloc]initWithArray:[modelCFFTransaction getAllCFF:sortedBy SortMethod:sortMethod]];
    [tableCFFListing reloadData];
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
