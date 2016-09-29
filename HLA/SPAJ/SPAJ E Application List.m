//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ E Application List.h"
#import "Query SPAJ Header.h"
#import "SPAJ E Application List Cell.h"
#import "String.h"
#import "ModelSPAJTransaction.h"
#import "SIListingPopOver.h"
#import "Formatter.h"
#import "ModelSPAJTransaction.h"
#import "ModelSPAJSignature.h"
#import "ModelSPAJIDCapture.h"
#import "ModelSPAJDetail.h"
#import "ModelSPAJFormGeneration.h"
#import "SPAJ Add Menu.h"
#import "ModelSIPOData.h"
#import "ModelSPAJHtml.h"
// DECLARATION

@interface SPAJEApplicationList ()<SPAJMainDelegate,SIListingDelegate,UIPopoverPresentationControllerDelegate,UITextFieldDelegate>{
    
    UIBarButtonItem* rightButton;
}



@end


// IMPLEMENTATION

@implementation SPAJEApplicationList{
    ModelSPAJTransaction* modelSPAJTransaction;
    ModelSPAJSignature* modelSPAJSignature;
    ModelSPAJIDCapture* modelSPAJIDCapture;
    ModelSPAJFormGeneration* modelSPAJFormGeneration;
    ModelSPAJDetail* modelSPAJDetail;
    ModelSIPOData* modelSIPOData;
    ModelSPAJHtml* modelSPAJHtml;
    SIListingPopOver *siListingPopOver;
    Formatter* formatter;
    
    UIAlertController *alertController;
    NSMutableArray* arraySPAJTransaction;
    
    NSString* sortedBy;
    NSString* sortMethod;
    
    NSMutableArray *ItemToBeDeleted;
    NSMutableArray *indexPaths;
    
    NSString* stringGlobalEAPPNumber;
    int RecDelete;
}

    // SYNTHESIZE

    @synthesize querySPAJHeader = _querySPAJHeader;
    @synthesize functionUserInterface = _functionUserInterface;
    @synthesize arrayQueryEApplication = _arrayQueryEApplication;
    @synthesize arrayTextField = _arrayTextField;
    @synthesize functionAlert = _functionAlert;
    @synthesize intQueryID = _intQueryID;
    @synthesize stringQueryName = _stringQueryName;
    @synthesize buttonSortStatus,buttonSortFullName,buttonSortEappNumber,buttonSortSPAJNumber,buttonSortLastModified;
    @synthesize buttonEdit,buttonReset,buttonDelete,buttonSearch;


    // DID LOAD

    -(void) viewWillAppear:(BOOL)animated{
        [self loadSPAJTransaction];
    }

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        // INITIALIZATION
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSPAJIDCapture = [[ModelSPAJIDCapture alloc]init];
        modelSPAJDetail = [[ModelSPAJDetail alloc]init];
        modelSPAJFormGeneration = [[ModelSPAJFormGeneration alloc]init];
        modelSIPOData  = [[ModelSIPOData alloc]init];
        modelSPAJHtml = [[ModelSPAJHtml alloc]init];
        formatter = [[Formatter alloc]init];
        
        _querySPAJHeader = [[QuerySPAJHeader alloc]init];
        _functionUserInterface = [[UserInterface alloc] init];
        _functionAlert = [[Alert alloc] init];
        
        RecDelete = 0;
        ItemToBeDeleted = [[NSMutableArray alloc] init];
        
        [self setNavigationBar];
        [self voidCreateRightBarButton];
        [self setTextfieldBorder];
        
        // LAYOUT SETTING
        
        _arrayTextField = [[NSMutableArray alloc] init];
        [_arrayTextField addObject:_textFieldName];
        [_arrayTextField addObject:_textFieldEApplicationNumber];
        
        [_tableView.delegate self];
        [_tableView.dataSource self];
        
        
        // DEFAULT QUERY
        
        [self generateQuery];
        
        
        // LOCALIZATION
          
        _labelPageTitle.text = NSLocalizedString(@"TITLE_EAPPLICATIONLIST", nil);
        
        _labelFieldName.text = NSLocalizedString(@"FIELD_NAME", nil);
        _labelFieldEApplicationNumber.text = NSLocalizedString(@"FIELD_EAPPLICATIONNUMBER", nil);
        _labelTablePolicyHolder.text = NSLocalizedString(@"TABLE_HEADER_POLICYHOLDER", nil);
        _labelTableSPAJNumber.text = NSLocalizedString(@"TABLE_HEADER_SPAJNUMBER", nil);
        _labelTableLastUpdateOn.text = NSLocalizedString(@"TABLE_HEADER_LASTUPDATEDON", nil);
        _labelTableEApp.text = NSLocalizedString(@"TABLE_HEADER_EAPPLICATIONNUMBER", nil);
        _labelTableState.text = NSLocalizedString(@"TABLE_HEADER_STATUS", nil);
        
        [buttonSearch setTitle:NSLocalizedString(@"BUTTON_SEARCH", nil) forState:UIControlStateNormal];
        [buttonReset setTitle:NSLocalizedString(@"BUTTON_RESET", nil) forState:UIControlStateNormal];
        [buttonDelete setTitle:NSLocalizedString(@"BUTTON_DELETE", nil) forState:UIControlStateNormal];
        
        _labelFieldName.text = @"Nama :";
        _labelFieldEApplicationNumber.text = @"Nomor Eapp :";
        
        sortedBy=@"datetime(spajtrans.SPAJDateModified)";
        sortMethod=@"DESC";
        
        [self loadSPAJTransaction];
    }

    -(void)setNavigationBar{
        [self.navigationItem setTitle:@"eApplication Listing"];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
    }

    -(void)setTextfieldBorder{
        UIFont *font= [UIFont fontWithName:@"BPreplay" size:16.0f];
        for (UIView *view in [self.view subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)view;
                textField.layer.borderColor=[_functionUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0].CGColor;
                textField.layer.borderWidth=1.0;
                textField.delegate=self;
                [textField setFont:font];
                
                UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
                textField.leftView = paddingView;
                textField.leftViewMode = UITextFieldViewModeAlways;
            }
        }
    }


    -(void)voidCreateRightBarButton{
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self
                                                      action:@selector(actionRightBarButtonPressed:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

    -(IBAction)actionRightBarButtonPressed:(UIBarButtonItem *)sender{
        if (siListingPopOver == nil) {
            siListingPopOver = [[SIListingPopOver alloc] initWithStyle:UITableViewStylePlain];
            siListingPopOver.delegate = self;
            
        }
        siListingPopOver.modalPresentationStyle = UIModalPresentationPopover;
        [siListingPopOver setPreferredContentSize:CGSizeMake(400, 550)];
        
        [self presentViewController:siListingPopOver animated:YES completion:nil];
        
        // configure the Popover presentation controller
        UIPopoverPresentationController *popController = [siListingPopOver popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        [popController setSourceRect:CGRectMake(sender.customView.frame.origin.x, sender.customView.frame.origin.y, 400, 500)];
        popController.barButtonItem = rightButton;
        popController.delegate = self;
    }

    #pragma mark load SPAJTransaction
    -(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
    {
        SPAJAddMenu* viewController = [[SPAJAddMenu alloc] initWithNibName:@"SPAJ Add Menu" bundle:nil];
        [viewController setDelegateSPAJMain:self];
        [viewController setStringEAPPNumber:stringGlobalEAPPNumber];
        [viewController setDictTransaction:[arraySPAJTransaction objectAtIndex:indexPath.row]];
        //cFFQuestionsVC.prospectProfileID = [arrayCFFTransaction[indexPath.row] valueForKey:@"IndexNo"];
        //cFFQuestionsVC.cffTransactionID = [arrayCFFTransaction[indexPath.row] valueForKey:@"CFFTransactionID"];
        //cFFQuestionsVC.cffID = [arrayCFFTransaction[indexPath.row] valueForKey:@"CFFID"];
        //cFFQuestionsVC.cffHeaderSelectedDictionary = [[NSDictionary alloc]initWithDictionary:arrayCFFTransaction[indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    }

    -(void)loadSPAJTransaction{
        arraySPAJTransaction=[[NSMutableArray alloc]initWithArray:[modelSPAJTransaction getAllSPAJ:sortedBy SortMethod:sortMethod]];
        [_tableView reloadData];
    }

    - (IBAction)actionGoToExistingList:(id)sender{
        //[_delegateSPAJEappList actionGoToExistingList:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"GOTOSPAJ" object:self];
    }
    // FUNCTION ON PAGE

    - (void) generateQuery
    {
        NSString* stringName = [_functionUserInterface generateQueryParameter:_textFieldName.text];
        NSString* stringEApplicationNumber = [_functionUserInterface generateQueryParameter:_textFieldEApplicationNumber.text];
        
        _arrayQueryEApplication = [_querySPAJHeader selectForEApplicationList:stringName stringEApplicationNumber:stringEApplicationNumber];
        
        [self.tableView reloadData];
    }

    // ACTION

    - (IBAction)actionSearch:(id)sender
    {
        //[self generateQuery];
        NSDictionary* dictSearch;
        dictSearch = [[NSDictionary alloc]initWithObjectsAndKeys:_textFieldName.text,@"Name",_textFieldEApplicationNumber.text,@"SPAJEappNumber", nil];
        arraySPAJTransaction = [modelSPAJTransaction searchSPAJ:dictSearch];
        [_tableView reloadData];
        
        [self resignFirstResponder];
        [self.view endEditing:YES];
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
    };

    - (IBAction)actionEdit:(id)sender
    {
        
        [self resignFirstResponder];
        if ([_tableView isEditing]) {
            [_tableView setEditing:NO animated:TRUE];
            buttonDelete.hidden = true;
            buttonDelete.enabled = false;
            [buttonEdit setTitle:@"Delete" forState:UIControlStateNormal ];
            
            ItemToBeDeleted = [[NSMutableArray alloc] init];
            indexPaths = [[NSMutableArray alloc] init];
            
            RecDelete = 0;
        }
        else {
            
            [_tableView setEditing:YES animated:TRUE];
            buttonDelete.hidden = FALSE;
            //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            [buttonEdit setTitle:@"Cancel" forState:UIControlStateNormal ];
        }
    }


    - (IBAction)actionDelete:(id)sender
    {
        /*NSString *stringTitle = [ NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ALERT_TITLE_TABLEDELETE", nil), TABLE_NAME_SPAJHEADER];
        NSString *stringMessage = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"ALERT_MESSAGE_TABLEDELETE", nil), _stringQueryName];
        
        UIAlertController* alertController = [_functionAlert alertTableDelete : stringTitle stringMessage : stringMessage];
        
        [self presentViewController:alertController animated:true completion:nil];*/
        [self alertDeleteEapp];
    };

    - (IBAction)actionReset:(id)sender
    {
        [_functionUserInterface resetTextField:_arrayTextField];
        [self resignFirstResponder];
        [self.view endEditing:YES];
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
        
        [self loadSPAJTransaction];
        //[self generateQuery];
    };

    - (IBAction)actionSortBy:(UIButton *)sender
    {
        if (sender==buttonSortFullName){
            sortedBy=@"pp.ProspectName";
        }
        else if (sender==buttonSortEappNumber){
            sortedBy=@"spajtrans.SPAJEappNumber";
        }
        else if (sender==buttonSortLastModified){
            sortedBy=@"datetime(spajtrans.SPAJDateModified)";
        }
        else if (sender==buttonSortStatus){
            sortedBy=@"spajtrans.SPAJDateModified";
        }
        
        
        if ([sortMethod isEqualToString:@"ASC"]){
            sortMethod=@"DESC";
        }
        else{
            sortMethod=@"ASC";
        }
        [self loadSPAJTransaction];
    }

    - (void)alertNewSPAJ:(NSString *)stringSINO
    {
        alertController = [UIAlertController alertControllerWithTitle:@"Konfirmasi" message:@"Yakin Ingin Membuat SPAJ ?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self createSPAJ:stringSINO];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self voidDismissAlertSignature];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });

    };

    - (void)alertDeleteEapp{
        UIAlertController *alertDeleteController = [UIAlertController alertControllerWithTitle:@"Konfirmasi" message:@"Yakin ingin menghapus transaksi ini?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertDeleteController addAction:[UIAlertAction actionWithTitle:@"Ya" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self confirmDeleteTransaction];
            [alertDeleteController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alertDeleteController addAction:[UIAlertAction actionWithTitle:@"Tidak" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertDeleteController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertDeleteController animated:YES completion:nil];
        });
    }


    -(void)createSPAJ:(NSString *)stringSINO{
        stringGlobalEAPPNumber = [self createSPAJTransactionNumber];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // No explicit autorelease pool needed here.
            // The code runs in background, not strangling
            // the main run loop.
            [self createSPAJTransactionData:stringGlobalEAPPNumber SINO:stringSINO];
            dispatch_sync(dispatch_get_main_queue(), ^{
                // This will be called on the main thread, so that
                // you can update the UI, for example.
                [self createSPAJSignatureData:stringGlobalEAPPNumber];
                [self createSPAJIDCaptureData:stringGlobalEAPPNumber];
                [self createSPAJDetail:stringGlobalEAPPNumber];
                [self createSPAJFormGeneration:stringGlobalEAPPNumber];
                [self copySIPDFToSPAJ:stringSINO];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self loadSPAJTransaction];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    });
                });
                
                
            });
        });
        /*dispatch_queue_t serialQueue = dispatch_queue_create("com.blah.queue", DISPATCH_QUEUE_SERIAL);
        
        dispatch_async(serialQueue, ^{
            [self createSPAJTransactionData:stringGlobalEAPPNumber SINO:stringSINO];
         
        });
        
        dispatch_async(serialQueue, ^{
            
        });
        
        dispatch_async(serialQueue, ^{
    
        });
        
        dispatch_async(serialQueue, ^{
            
        });
        
        dispatch_async(serialQueue, ^{
            
        });
        
        dispatch_async(serialQueue, ^{
            
        });
        
        dispatch_async(serialQueue, ^{
           
        });*/
        
        //[self performSelector:@selector(loadSPAJTransaction) withObject:nil afterDelay:1.0];
        //[siListingPopOver dismissViewControllerAnimated:YES completion:nil];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    
    }

    -(void)voidDismissAlertSignature{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }

    -(void)confirmDeleteTransaction
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
            NSString* transactionID = [[arraySPAJTransaction objectAtIndex:value] valueForKey:@"SPAJTransactionID"];
            
            [modelSPAJTransaction deleteSPAJTransaction:@"SPAJTransaction" StringWhereName:@"SPAJTransactionID" StringWhereValue:transactionID];
            [modelSPAJTransaction deleteSPAJTransaction:@"SPAJSignature" StringWhereName:@"SPAJTransactionID" StringWhereValue:transactionID];
            [modelSPAJTransaction deleteSPAJTransaction:@"SPAJIDCapture" StringWhereName:@"SPAJTransactionID" StringWhereValue:transactionID];
            [modelSPAJTransaction deleteSPAJTransaction:@"SPAJFormGeneration" StringWhereName:@"SPAJTransactionID" StringWhereValue:transactionID];
            [modelSPAJTransaction deleteSPAJTransaction:@"SPAJDetail" StringWhereName:@"SPAJTransactionID" StringWhereValue:transactionID];
            [modelSPAJTransaction deleteSPAJTransaction:@"SPAJAnswers" StringWhereName:@"SPAJTransactionID" StringWhereValue:transactionID];
            
            [arraySPAJTransaction removeObjectAtIndex:value];
            //remove array for index value
        }
        [ItemToBeDeleted removeAllObjects];
        [indexPaths removeAllObjects];
        buttonDelete.enabled = FALSE;
        //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        
        [self loadSPAJTransaction];
        
        NSString *msg = @"Transaksi berhasil dihapus";//Client Profile has been successfully deleted.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" " message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [self actionEdit:nil];
        alert = nil;
    }


    // TABLE

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return [arraySPAJTransaction count];
    }

    - (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
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
        SPAJEApplicationListCell *cellSPAJEApplication = (SPAJEApplicationListCell *)[tableView dequeueReusableCellWithIdentifier:@"SPAJEApplicationListCell"];
        
        if (cellSPAJEApplication == nil)
        {
            NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SPAJ E Application List Cell" owner:self options:nil];
            cellSPAJEApplication = [arrayNIB objectAtIndex:0];
        }
        else
        {
            
        }
        if (indexPath.row<[arraySPAJTransaction count]){
            
            NSString *idDesc = @"";
            if ([[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"IdentityDesc"] length]>0){
                idDesc = [NSString stringWithFormat:@"%@ : ",[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"IdentityDesc"] ];
                
            }
            NSString *idNumber = @"";
            if ([[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"OtherIDTypeNo"] length]>0){
                idNumber = [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"OtherIDTypeNo"];
            }
            NSString* prospectID = [NSString stringWithFormat:@"%@%@",idDesc,idNumber];
            
            [cellSPAJEApplication.labelName setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"ProspectName"]];
            [cellSPAJEApplication.labelSocialNumber setText:prospectID];
            [cellSPAJEApplication.labelEApplicationNumber setText:[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJEappNumber"]];
            [cellSPAJEApplication.labelSPAJNumber setText:[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJNumber"]];
            [cellSPAJEApplication.labelUpdatedOnDate setText:[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJDateModified"]];
            //[cellSPAJEApplication.labelUpdatedOnTime setText:];
            [cellSPAJEApplication.labelState setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJCompleteness"]];
        }
        /*NSManagedObject* queryEApplication = [_arrayQueryEApplication objectAtIndex:[indexPath row]];
        
        NSString* stringUpdatedOnDate = [_functionUserInterface generateDate:[queryEApplication valueForKey:COLUMN_SPAJHEADER_UPDATEDON]];
        NSString* stringUpdatedOnTime = [_functionUserInterface generateTime:[queryEApplication valueForKey:COLUMN_SPAJHEADER_UPDATEDON] ];
        
        [cellSPAJEApplication.labelName setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_NAME]];
        [cellSPAJEApplication.labelSocialNumber setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_SOCIALNUMBER]];
        [cellSPAJEApplication.labelEApplicationNumber setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_EAPPLICATIONNUMBER]];
        [cellSPAJEApplication.labelSPAJNumber setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_SPAJNUMBER]];
        [cellSPAJEApplication.labelUpdatedOnDate setText: stringUpdatedOnDate];
        [cellSPAJEApplication.labelUpdatedOnTime setText: stringUpdatedOnTime];
        [cellSPAJEApplication.labelState setText: [queryEApplication valueForKey:COLUMN_SPAJHEADER_STATE]];*/
        return cellSPAJEApplication;
    }

    - (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        RecDelete = RecDelete+1;
        if ([_tableView isEditing] == TRUE ) {
            BOOL gotRowSelected = FALSE;
            
            for (UITableViewCell *zzz in [_tableView visibleCells])
            {
                if (zzz.selected  == TRUE) {
                    gotRowSelected = TRUE;
                    break;
                }
            }
            
            if (!gotRowSelected) {
                ////[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
                buttonDelete.enabled = FALSE;
            }
            else {
                ////[deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                buttonDelete.enabled = TRUE;
            }
            
            NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
            [ItemToBeDeleted addObject:zzz];
            [indexPaths addObject:indexPath];
        }
        else {
            SPAJEApplicationListCell *cellSPAJEApplication = [tableView cellForRowAtIndexPath:indexPath];
            
            //_intQueryID = [cellSPAJEApplication intID];
            //
            _stringQueryName = [cellSPAJEApplication.labelName text];
            [self showDetailsForIndexPath:indexPath];
        }
    }

    #pragma mark create SPAJ Transaction
    // Save New SPAJ to DB
    -(void)copySIPDFToSPAJ:(NSString *)SINO{
        NSDictionary* dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
        NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
        NSString *pdfPathOutput = [NSString stringWithFormat:@"%@/%@_%@.pdf",documentsDirectory,[dictionaryPOData valueForKey:@"ProductName"],[dictionaryPOData valueForKey:@"SINO"]];
        
        NSString* destinationPath = [NSString stringWithFormat:@"%@/SPAJ/%@/%@_%@.pdf",documentsDirectory,stringGlobalEAPPNumber,[dictionaryPOData valueForKey:@"ProductName"],[dictionaryPOData valueForKey:@"SINO"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pdfPathOutput];
        if (fileExists){
            if ([fileManager copyItemAtPath:pdfPathOutput
                                     toPath:destinationPath  error:NULL]) {
                NSLog(@"Copied successfully");
            }
        }
    }

    -(NSString *)createSPAJTransactionNumber
    {
        int randomNumber = [formatter getRandomNumberBetween:1000 MaxValue:9999];
        NSString* EAPPNumber = [NSString stringWithFormat:@"EAPPRN%i",randomNumber];
        return EAPPNumber;
    }

    -(void)createSPAJTransactionData:(NSString *)stringEAPPNo SINO:(NSString *)stringSINO;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* stringEAPPNumber = stringEAPPNo;//[self createSPAJTransactionNumber];
        
        //[dictionarySPAJTransaction setObject:@"1" forKey:@"SPAJID"];
        [dictionarySPAJTransaction setObject:[NSNumber numberWithInt:[modelSPAJHtml selectActiveHtmlSPAJID]] forKey:@"SPAJID"];
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"" forKey:@"SPAJNumber"];
        [dictionarySPAJTransaction setObject:stringSINO forKey:@"SPAJSINO"];
        [dictionarySPAJTransaction setObject:dateToday forKey:@"SPAJDateCreated"];
        [dictionarySPAJTransaction setObject:@"" forKey:@"CreatedBy"];
        [dictionarySPAJTransaction setObject:dateToday forKey:@"SPAJDateModified"];
        [dictionarySPAJTransaction setObject:@"" forKey:@"ModifiedBy"];
        [dictionarySPAJTransaction setObject:@"EAPP" forKey:@"SPAJStatus"];
        [dictionarySPAJTransaction setObject:@"Tidak Lengkap" forKey:@"SPAJCompleteness"];
        
        [modelSPAJTransaction saveSPAJTransaction:dictionarySPAJTransaction];
        
        [self voidCreateSPAJFolderDocument:stringEAPPNumber];
    }

    -(void)createSPAJSignatureData:(NSString *)stringEAPPNo;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        
        NSString* stringEAPPNumber = stringEAPPNo;
        
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty1"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty2"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty3"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty4"];
        
        
        [modelSPAJSignature saveSPAJSignature:dictionarySPAJTransaction];
    }

    -(void)createSPAJIDCaptureData:(NSString *)stringEAPPNo;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        
        NSString* stringEAPPNumber = stringEAPPNo;
        
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty1"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty2"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty3"];
        [dictionarySPAJTransaction setObject:@"1" forKey:@"SPAJIDCaptureParty4"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty5"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty6"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty1"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty2"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty3"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty4"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty5"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty6"];
        
        [modelSPAJIDCapture saveSPAJIDCapture:dictionarySPAJTransaction];
    }

    -(void)createSPAJFormGeneration:(NSString *)stringEAPPNo;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        
        NSString* stringEAPPNumber = stringEAPPNo;
        
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJFormGeneration1"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJFormGeneration2"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJFormGeneration3"];
        
        [modelSPAJFormGeneration saveSPAJFormGeneration:dictionarySPAJTransaction];
    }

    -(void)createSPAJDetail:(NSString *)stringEAPPNo;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        
        NSString* stringEAPPNumber = stringEAPPNo;
        
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJDetail1"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJDetail2"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJDetail3"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJDetail4"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJDetail5"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJDetail6"];
        
        [modelSPAJDetail saveSPAJDetail:dictionarySPAJTransaction];
    }

    -(void)voidCreateSPAJFolderDocument:(NSString *)stringEAPPNumber
    {
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString *filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPNumber];
        
        [formatter createDirectory:rootFilePathApp];
        
        [formatter createDirectory:filePathApp];
    }


    #pragma mark delegate
    -(void)selectedSI:(NSString *)SINO
    {
        /*NSDictionary* dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
        NSString *stringSINO = SINO;
        NSString *stringLAName = [dictionaryPOData valueForKey:@"LA_Name"];
        NSString *stringProduct = [dictionaryPOData valueForKey:@"ProductName"];
        
        NSString* stringLabelDetail = [NSString stringWithFormat:@"Nomor SI : %@    Tertanggung Polis : %@    Produk : %@",stringSINO,stringLAName,stringProduct];
        
        [modelSPAJTransaction updateSPAJTransaction:@"SPAJSINO" StringColumnValue:stringSINO StringWhereName:@"SPAJEappNumber" StringWhereValue:stringEAPPNumber];
        [_labelDetail1 setText:stringLabelDetail];*/
        
        //dispatch_async(serialQueue, ^{
        //    [siListingPopOver dismissViewControllerAnimated:YES completion:nil];
        //});
        
        //[self loadSPAJTransaction];
        [self alertNewSPAJ:SINO];
        [siListingPopOver dismissViewControllerAnimated:YES completion:nil];
        
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end