//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Submitted List.h"
#import "Query SPAJ Header.h"
#import "SPAJ Submitted List Cell.h"
#import "String.h"
#import "ModelSPAJTransaction.h"
#import "SPAJFilesViewController.h"

// DECLARATION

@interface SPAJSubmittedList ()



@end


// IMPLEMENTATION

@implementation SPAJSubmittedList{
    ModelSPAJTransaction* modelSPAJTransaction;
    SPAJFilesViewController* spajFilesViewController;
    NSMutableArray* arraySPAJTransaction;
    
    NSString* sortedBy;
    NSString* sortMethod;
    NSString* SPAJStatus;
    
    NSMutableArray *ItemToBeDeleted;
    NSMutableArray *indexPaths;
    
    int RecDelete;
}

    // SYNTHESIZE

    @synthesize querySPAJHeader = _querySPAJHeader;
    @synthesize arrayQuerySubmitted = _arrayQuerySubmitted;
    @synthesize functionUserInterface = _functionUserInterface;
    @synthesize arrayTextField = _arrayTextField;
    @synthesize intQueryID = _intQueryID;
    @synthesize stringQueryName = _stringQueryName;
    @synthesize functionAlert = _functionAlert;

    @synthesize buttonSortStatus,buttonSortProduct,buttonSortFullName,buttonSortDateSumbit,buttonSortSPAJNumber;

    @synthesize buttonEdit,buttonReset,buttonDelete,buttonSearch;
    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        SPAJStatus = @"'Submitted'";
        
        // INITIALIZATION
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        _querySPAJHeader = [[QuerySPAJHeader alloc] init];
        _functionUserInterface = [[UserInterface alloc] init];
        _functionAlert = [[Alert alloc] init];
        
        RecDelete = 0;
        ItemToBeDeleted = [[NSMutableArray alloc] init];
        
        // LAYOUT SETTING
        
        _arrayTextField = [[NSMutableArray alloc] init];
        [_arrayTextField addObject:_textFieldName];
        [_arrayTextField addObject:_textFieldSocialNumber];
        [_arrayTextField addObject:_textFieldSPAJNumber];
        
        [_tableView.delegate self];
        [_tableView.dataSource self];
        
        
        // DEFAULT QUERY
        
        [self generateQuery];
        
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_SPAJSUBMITTEDLIST", nil);
        
        _labelFieldName.text = NSLocalizedString(@"FIELD_NAME", nil);
        _labelFieldSPAJNumber.text = NSLocalizedString(@"FIELD_SPAJNUMBER", nil);
        _labelFieldSocialNumber.text = NSLocalizedString(@"FIELD_SOCIALNUMBER", nil);
        
        _labelTablePolicyHolder.text = NSLocalizedString(@"TABLE_HEADER_POLICYHOLDER", nil);
        _labelTableSPAJNumber.text = NSLocalizedString(@"TABLE_HEADER_SPAJNUMBER", nil);
        _labelTableSubmittedDate.text = NSLocalizedString(@"TABLE_HEADER_SUBMITTEDDATE", nil);
        _labelTableProduct.text = NSLocalizedString(@"TABLE_HEADER_PRODUCT", nil);
        _labelTableState.text = NSLocalizedString(@"TABLE_HEADER_STATUS", nil);
        _labelTableView.text = NSLocalizedString(@"TABLE_HEADER_VIEW", nil);
        
        [buttonSearch setTitle:NSLocalizedString(@"BUTTON_SEARCH", nil) forState:UIControlStateNormal];
        [buttonReset setTitle:NSLocalizedString(@"BUTTON_RESET", nil) forState:UIControlStateNormal];
        [buttonDelete setTitle:NSLocalizedString(@"BUTTON_DELETE", nil) forState:UIControlStateNormal];
        [buttonEdit setTitle:NSLocalizedString(@"BUTTON_EDIT", nil) forState:UIControlStateNormal];
        
        sortedBy=@"datetime(spajtrans.SPAJDateModified)";
        sortMethod=@"DESC";
        [self loadSPAJTransaction];
    }

    -(void)loadSPAJTransaction{
        
        arraySPAJTransaction=[[NSMutableArray alloc]initWithArray:[modelSPAJTransaction getAllReadySPAJ:sortedBy SortMethod:sortMethod SPAJStatus:SPAJStatus]];
        [_tableView reloadData];
    }


    // ON PAGE FUNCTION

    - (void) generateQuery
    {
        NSString* stringName = [_functionUserInterface generateQueryParameter:_textFieldName.text];
        NSString* stringSocialNumber = [_functionUserInterface generateQueryParameter:_textFieldSocialNumber.text];
        NSString* stringSPAJNumber = [_functionUserInterface generateQueryParameter:_textFieldSPAJNumber.text];
        
        _arrayQuerySubmitted = [_querySPAJHeader selectForSubmittedList:stringName stringSocialNumber:stringSocialNumber stringSPAJNumber:stringSPAJNumber];
        
        [self.tableView reloadData];
    }


    // ACTION

    - (IBAction)actionSearch:(id)sender
    {
        //[self generateQuery];
        NSDictionary *dictSearch = [[NSDictionary alloc]initWithObjectsAndKeys:_textFieldName.text,@"Name",_textFieldSPAJNumber.text,@"SPAJNumber",_textFieldSocialNumber.text,@"IDNo",SPAJStatus,@"SPAJStatus", nil];
        arraySPAJTransaction = [modelSPAJTransaction searchReadySPAJ:dictSearch];
        [_tableView reloadData];
    };

    - (IBAction)actionReset:(id)sender
    {
        /*[_functionUserInterface resetTextField:_arrayTextField];
        
        [self generateQuery];*/
        [_textFieldName setText:@""];
        [_textFieldSPAJNumber setText:@""];
        [_textFieldSocialNumber setText:@""];
        [self loadSPAJTransaction];
    };

    - (IBAction)actionSortBy:(UIButton *)sender
    {
        if (sender==buttonSortFullName){
            sortedBy=@"pp.ProspectName";
        }
        else if (sender==buttonSortSPAJNumber){
            sortedBy=@"spajtrans.SPAJNumber";
        }
        else if (sender==buttonSortDateSumbit){
            sortedBy=@"datetime(spajtrans.SPAJDateModified)";
        }
        else if (sender==buttonSortProduct){
            sortedBy=@"sipo.ProductName";
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


    - (IBAction)actionShowFilesList:(UIButton *)sender{
        spajFilesViewController = [[SPAJFilesViewController alloc]initWithNibName:@"SPAJFilesViewController" bundle:nil];
        [spajFilesViewController setDictTransaction:[arraySPAJTransaction objectAtIndex:sender.tag]];
        [spajFilesViewController setBoolHealthQuestionairre:NO];
        spajFilesViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:spajFilesViewController animated:YES completion:nil];
        [spajFilesViewController.buttonSubmit setHidden:YES];
    }

    - (IBAction)actionEdit:(id)sender
    {
        [self resignFirstResponder];
        [self resignFirstResponder];
        if ([_tableView isEditing]) {
            [_tableView setEditing:NO animated:TRUE];
            buttonDelete.hidden = true;
            buttonDelete.enabled = false;
            [buttonEdit setTitle:NSLocalizedString(@"BUTTON_EDIT", nil) forState: UIControlStateNormal];
            
            ItemToBeDeleted = [[NSMutableArray alloc] init];
            indexPaths = [[NSMutableArray alloc] init];
            
            RecDelete = 0;
        }
        else {
            
            [_tableView setEditing:YES animated:TRUE];
            buttonDelete.hidden = FALSE;
            //[deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            [buttonEdit setTitle:NSLocalizedString(@"BUTTON_EDIT_CANCEL", nil) forState:UIControlStateNormal];
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

    - (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
    {
        
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        SPAJSubmittedListCell *cellSPAJSubmitted = (SPAJSubmittedListCell *)[tableView dequeueReusableCellWithIdentifier:@"SPAJSubmittedListCell"];
        
        if (cellSPAJSubmitted == nil)
        {
            NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SPAJ Submitted List Cell" owner:self options:nil];
            cellSPAJSubmitted = [arrayNIB objectAtIndex:0];
        }
        else
        {
            
        }
        
        /*NSManagedObject* querySubmitted = [_arrayQuerySubmitted objectAtIndex:[indexPath row]];
        
        NSString* stringUpdatedOnDate = [_functionUserInterface generateDate:[querySubmitted valueForKey:COLUMN_SPAJHEADER_UPDATEDON]];
        NSString* stringUpdatedOnTime = [_functionUserInterface generateTime:[querySubmitted valueForKey:COLUMN_SPAJHEADER_UPDATEDON] ];
        
        [cellSPAJSubmitted.labelName setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_NAME]];
        [cellSPAJSubmitted.labelSocialNumber setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_SOCIALNUMBER]];
        [cellSPAJSubmitted.labelSPAJNumber setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_SPAJNUMBER]];
        [cellSPAJSubmitted.labelUpdatedOnDate setText: stringUpdatedOnDate];
        [cellSPAJSubmitted.labelUpdatedOnTime setText: stringUpdatedOnTime];
        [cellSPAJSubmitted.labelProduct setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_PRODUCTID]];
        [cellSPAJSubmitted.labelState setText: [querySubmitted valueForKey:COLUMN_SPAJHEADER_STATE]];
        [cellSPAJSubmitted.buttonView  setTitle:NSLocalizedString(@"BUTTON_VIEW", nil) forState:UIControlStateNormal];*/
        if (indexPath.row<[arraySPAJTransaction count]){
            /*NSString* stringUpdatedOnDate = [_functionUserInterface generateDate:[querySubmitted valueForKey:COLUMN_SPAJHEADER_UPDATEDON]];
            NSString* stringUpdatedOnTime = [_functionUserInterface generateTime:[querySubmitted valueForKey:COLUMN_SPAJHEADER_UPDATEDON] ];*/
            NSString *idDesc = @"";
            if ([[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"IdentityDesc"] length]>0){
                idDesc = [NSString stringWithFormat:@"%@ : ",[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"IdentityDesc"] ];
                
            }
            NSString *idNumber = @"";
            if ([[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"OtherIDTypeNo"] length]>0){
                idNumber = [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"OtherIDTypeNo"];
            }
            NSString* prospectID = [NSString stringWithFormat:@"%@%@",idDesc,idNumber];
            [cellSPAJSubmitted.labelName setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"ProspectName"]];
            [cellSPAJSubmitted.labelSocialNumber setText: prospectID];
            [cellSPAJSubmitted.labelSPAJNumber setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJNumber"]];
            [cellSPAJSubmitted.labelUpdatedOnDate setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJDateModified"]];
            [cellSPAJSubmitted.labelUpdatedOnTime setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJDateModified"]];
            [cellSPAJSubmitted.labelProduct setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"ProductName"]];
            [cellSPAJSubmitted.labelState setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJStatus"]];
            [cellSPAJSubmitted.buttonView  setTitle:NSLocalizedString(@"BUTTON_VIEW", nil) forState:UIControlStateNormal];
            
            [cellSPAJSubmitted.buttonView addTarget:self
                                            action:@selector(actionShowFilesList:) forControlEvents:UIControlEventTouchUpInside];
            [cellSPAJSubmitted.buttonView setTag:indexPath.row];
        }
        return cellSPAJSubmitted;
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
            SPAJSubmittedListCell *cellSPAJSubmitted = [tableView cellForRowAtIndexPath:indexPath];
            
            _intQueryID = [cellSPAJSubmitted intID];
            _stringQueryName = [cellSPAJSubmitted.labelName text];
        }
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end