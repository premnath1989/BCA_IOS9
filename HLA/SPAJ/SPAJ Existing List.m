//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Existing List.h"
#import "Query SPAJ Header.h"
#import "SPAJ Existing List Cell.h"
#import "String.h"
#import "Alert.h"
#import "ModelSPAJTransaction.h"
#import "SPAJFilesViewController.h"
#import "FormTenagaPenjualViewController.h"
#import "Formatter.h"


// DECLARATION

@interface SPAJExistingList ()<SPAJFilesDelegate>



@end


// IMPLEMENTATION


@implementation SPAJExistingList{
    ModelSPAJTransaction* modelSPAJTransaction;
    SPAJFilesViewController* spajFilesViewController;
    FormTenagaPenjualViewController* formTenagaPenjualViewController;
    Formatter* formatter;
    
    NSMutableArray* arraySPAJTransaction;
    int indexSelected;
    
    NSString* sortedBy;
    NSString* sortMethod;
    NSString* SPAJStatus;
    
    NSMutableArray *ItemToBeDeleted;
    NSMutableArray *indexPaths;
    
    int RecDelete;
}

    // SYNTHESIZE

    @synthesize querySPAJHeader = _querySPAJHeader;
    @synthesize functionUserInterface = _functionUserInterface;
    @synthesize arrayQueryExisting = _arrayQueryExisting;
    @synthesize arrayTextField = _arrayTextField;
    @synthesize functionAlert = _functionAlert;
    @synthesize intQueryID = _intQueryID;
    @synthesize stringQueryName = _stringQueryName;

    @synthesize buttonSortSPAJNumber,buttonSortFullName,buttonSortSIVersion,buttonSortLastModified,buttonSortTimeRemaining;

    @synthesize buttonEdit,buttonReset,buttonDelete,buttonSearch;


    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        SPAJStatus = @"'Not Submitted'";
        
        // INITIALIZATION
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        formatter = [[Formatter alloc]init];
        _querySPAJHeader = [[QuerySPAJHeader alloc]init];
        _functionUserInterface = [[UserInterface alloc] init];
        _functionAlert = [[Alert alloc]init];
        
        RecDelete = 0;
        ItemToBeDeleted = [[NSMutableArray alloc] init];
        
        // LAYOUT SETTING
        
        _stackViewNote.alignment = UIStackViewAlignmentTop;
        
        _arrayTextField = [[NSMutableArray alloc] init];
        [_arrayTextField addObject:_textFieldName];
        [_arrayTextField addObject:_textFieldSPAJNumber];
        [_arrayTextField addObject:_textFieldSocialNumber];
        
        [_tableView.delegate self];
        [_tableView.dataSource self];
        
        
        // DEFAULT QUERY
        
        [self generateQuery];
        
        
        // LOCALIZATION
        
        _labelPageTitle.text = NSLocalizedString(@"TITLE_SPAJEXISTINGLIST", nil);
        
        _labelNoteHeader.text = NSLocalizedString(@"NOTE_SPAJHEADER", nil);
        _labelNoteDetail.text = NSLocalizedString(@"NOTE_SPAJDETAIL", nil);
        _labelFieldName.text = NSLocalizedString(@"FIELD_NAME", nil);
        _labelFieldSPAJNumber.text = NSLocalizedString(@"FIELD_SPAJNUMBER", nil);
        _labelFieldSocialNumber.text = NSLocalizedString(@"FIELD_SOCIALNUMBER", nil);
        
        _labelTablePolicyHolder.text = NSLocalizedString(@"TABLE_HEADER_POLICYHOLDER", nil);
        _labelTableSPAJNumber.text = NSLocalizedString(@"TABLE_HEADER_SPAJNUMBER", nil);
        _labelTableLastUpdateOn.text = NSLocalizedString(@"TABLE_HEADER_LASTUPDATEDON", nil);
        _labelTableSIVersion.text = NSLocalizedString(@"TABLE_HEADER_ILLUSTRATIONVERSION", nil);
        _labelTableTimeRemaining.text = NSLocalizedString(@"TABLE_HEADER_TIMEREMAINING", nil);
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

    - (void)generateQuery
    {
        NSString* stringName = [_functionUserInterface generateQueryParameter:_textFieldName.text];
        NSString* stringSocialNumber = [_functionUserInterface generateQueryParameter:_textFieldSocialNumber.text];
        NSString* stringSPAJNumber = [_functionUserInterface generateQueryParameter:_textFieldSPAJNumber.text];
        
        _arrayQueryExisting = [_querySPAJHeader selectForExistingList:stringName stringSocialNumber:stringSocialNumber stringSPAJNumber:stringSPAJNumber];
        
        [self.tableView reloadData];
    }


    // ACTION

    - (IBAction)actionSearch:(id)sender
    {
        //[self generateQuery];
        NSDictionary *dictSearch = [[NSDictionary alloc]initWithObjectsAndKeys:_textFieldName.text,@"Name",_textFieldSPAJNumber.text,@"SPAJNumber",_textFieldSocialNumber.text,@"IDNo",SPAJStatus,@"SPAJStatus", nil];
        arraySPAJTransaction = [[NSMutableArray alloc]initWithArray:[modelSPAJTransaction searchReadySPAJ:dictSearch]];
        [_tableView reloadData];
    };

    - (IBAction)actionEdit:(id)sender
    {
        
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
        else if (sender==buttonSortLastModified){
            sortedBy=@"datetime(spajtrans.SPAJDateModified)";
        }
        else if (sender==buttonSortSIVersion){
            sortedBy=@"sim.SI_Version";
        }
        else if (sender==buttonSortTimeRemaining){
            sortedBy=@"spajtrans.SPAJDateExpired";
        }
        
        
        if ([sortMethod isEqualToString:@"ASC"]){
            sortMethod=@"DESC";
        }
        else{
            sortMethod=@"ASC";
        }
        [self loadSPAJTransaction];
    }

    - (IBAction)actionAgentForm:(UIButton *)sender{
        indexSelected = sender.tag;
        formTenagaPenjualViewController = [[FormTenagaPenjualViewController alloc]initWithNibName:@"FormTenagaPenjualViewController" bundle:nil];
        //[spajFilesViewController setDelegateSPAJFiles:self];
        [formTenagaPenjualViewController setDictTransaction:[arraySPAJTransaction objectAtIndex:sender.tag]];
        formTenagaPenjualViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:formTenagaPenjualViewController animated:YES completion:nil];
    }

    - (IBAction)actionPaymentReceiptCapture:(UIButton *)sender{
        indexSelected = sender.tag;
        UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:source])
        {
            imagePickerController= [[CameraViewController alloc] init];
            imagePickerController.sourceType = source;
            
            CGRect rect = imagePickerController.view.frame;
            imagePickerRect = rect;
            CGSize frameSize = CGSizeMake(800,562.5);
            
            CGRect frameRect = CGRectMake((rect.size.width-frameSize.width)/2, (rect.size.height-frameSize.height)/2, frameSize.width, frameSize.height);
            
            UIView *view = [[UIView alloc]initWithFrame:frameRect];
            [view setBackgroundColor:[UIColor clearColor]];
            
            view.layer.borderWidth = 5.0;
            view.layer.borderColor = [UIColor redColor].CGColor;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, -80, 300, 200)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"Please snap within the red frame";
            [view addSubview:lbl];
            
            imagePickerController.cameraOverlayView = view;
            
            imagePickerController.delegate = self;
            imagePickerController.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Your device has no camera!!" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }

    - (IBAction)actionShowFilesList:(UIButton *)sender{
        spajFilesViewController = [[SPAJFilesViewController alloc]initWithNibName:@"SPAJFilesViewController" bundle:nil];
        [spajFilesViewController setDelegateSPAJFiles:self];
        [spajFilesViewController setDictTransaction:[arraySPAJTransaction objectAtIndex:sender.tag]];
        [spajFilesViewController setBoolHealthQuestionairre:NO];
        spajFilesViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        //spajPDFWebView.preferredContentSize = CGSizeMake(950, 768);
        [self presentViewController:spajFilesViewController animated:YES completion:nil];
        //spajPDFWebView.view.superview.frame = CGRectMake(0, 0, 950, 768);
        //pajPDFWebView.view.superview.center = self.view.center;
    }

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
        SPAJExistingListCell *cellSPAJExisting = (SPAJExistingListCell *)[tableView dequeueReusableCellWithIdentifier:@"SPAJExistingListCell"];
        
        if (cellSPAJExisting == nil)
        {
            NSArray *arrayNIB = [[NSBundle mainBundle] loadNibNamed:@"SPAJ Existing List Cell" owner:self options:nil];
            cellSPAJExisting = [arrayNIB objectAtIndex:0];
        }
        else
        {
            
        }
        
        /*NSManagedObject* queryExisting = [_arrayQueryExisting objectAtIndex:[indexPath row]];
        
        NSString* stringUpdatedOnDate = [_functionUserInterface generateDate:[queryExisting valueForKey:COLUMN_SPAJHEADER_UPDATEDON]];
        NSString* stringUpdatedOnTime = [_functionUserInterface generateTime:[queryExisting valueForKey:COLUMN_SPAJHEADER_UPDATEDON] ];
        NSString* stringTimeRemaining = [_functionUserInterface generateTimeRemaining:[queryExisting valueForKey:COLUMN_SPAJHEADER_CREATEDON]];
        
        [cellSPAJExisting.labelName setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_NAME]];
        [cellSPAJExisting.labelSocialNumber setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_SOCIALNUMBER]];
        [cellSPAJExisting.labelSPAJNumber setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_SPAJNUMBER]];
        [cellSPAJExisting.labelUpdatedOnDate setText: stringUpdatedOnDate];
        [cellSPAJExisting.labelUpdatedOnTime setText: stringUpdatedOnTime];
        [cellSPAJExisting.labelSalesIllustration setText: [queryExisting valueForKey:COLUMN_SPAJHEADER_ILLUSTRATIONID]];
        [cellSPAJExisting.labelTimeRemaining setText: stringTimeRemaining];
        [cellSPAJExisting.buttonView  setTitle:NSLocalizedString(@"BUTTON_VIEW", nil) forState:UIControlStateNormal];*/
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
            [cellSPAJExisting.labelName setText:[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"ProspectName"]];
            [cellSPAJExisting.labelSocialNumber setText:prospectID];
            [cellSPAJExisting.labelSPAJNumber setText: [[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJNumber"]];
            [cellSPAJExisting.labelUpdatedOnDate setText:[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJDateModified"]];
            [cellSPAJExisting.labelUpdatedOnTime setText:[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SPAJDateModified"]];
            [cellSPAJExisting.labelSalesIllustration setText:[[arraySPAJTransaction objectAtIndex:indexPath.row] valueForKey:@"SI_Version"]];
            [cellSPAJExisting.labelTimeRemaining setText:[formatter calculateTimeRemaining:[[arraySPAJTransaction objectAtIndex:indexPath.row]valueForKey:@"SPAJDateExpired"]]];
            [cellSPAJExisting.buttonView  setTitle:NSLocalizedString(@"BUTTON_VIEW", nil) forState:UIControlStateNormal];
            
            [cellSPAJExisting.buttonView addTarget:self
                       action:@selector(actionShowFilesList:) forControlEvents:UIControlEventTouchUpInside];
            
            [cellSPAJExisting.buttonPaymentReceipt addTarget:self
                                            action:@selector(actionPaymentReceiptCapture:) forControlEvents:UIControlEventTouchUpInside];
            
            [cellSPAJExisting.buttonAgentForm addTarget:self
                                                      action:@selector(actionAgentForm:) forControlEvents:UIControlEventTouchUpInside];
            
            [cellSPAJExisting.buttonView setTag:indexPath.row];
            [cellSPAJExisting.buttonPaymentReceipt setTag:indexPath.row];
            [cellSPAJExisting.buttonAgentForm setTag:indexPath.row];
        }
        return cellSPAJExisting;
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
            SPAJExistingListCell *cellSPAJExisting = [tableView cellForRowAtIndexPath:indexPath];
            
            _intQueryID = [cellSPAJExisting intID];
            _stringQueryName = [cellSPAJExisting.labelName text];
        }
    }

    #pragma mark crop function
    - (UIImage *)crop:(UIImage *)image {
        
        CGRect originalrect = imagePickerRect;
        CGSize frameSize = CGSizeMake(800,562.50);
        
        float CalX=(originalrect.size.width-frameSize.width)/2;
        float CalY=(originalrect.size.height-frameSize.height)/2;
        
        CGRect frameRect = CGRectMake(CalX-55, CalY-55, frameSize.width, frameSize.height);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([self imageWithImage:image scaledToSize:CGSizeMake(512,360)].CGImage, frameRect);
        UIImage *result = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
        UIImage *lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(result, 0.7)];
        CGImageRelease(imageRef);
        return lowResImage;
    }

    -(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
    {
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
        
    }

    #pragma mark delegate image picker
    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [self crop:originalimage];
        [self copyIDImagesToSPAJFolder:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }

    #pragma mark copy images to spaj folder
    -(void)copyIDImagesToSPAJFolder:(UIImage *)imageCaptured{
        NSError *error =  nil;
        NSDictionary* dictTransaction = [arraySPAJTransaction objectAtIndex:indexSelected];
        
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString* stringEAPPPath = [dictTransaction valueForKey:@"SPAJEappNumber"];
        NSString* stringSPAJPath = [dictTransaction valueForKey:@"SPAJNumber"];
        NSString* filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPPath];
        
        //filename combination is EAPPNumberPartyIDTypeFront
        //filename combination is EAPPNumberPartyIDTypeBack
        NSString* fileName = [NSString stringWithFormat:@"%@_BuktiSetor",stringSPAJPath];
        
        //NSData *imageData = UIImageJPEGRepresentation([self generateWatermarkForImage:imageView.image], 0.8);
        NSData *imageData = UIImageJPEGRepresentation(imageCaptured, 0.8);
        
        NSString* target=[NSString stringWithFormat:@"%@/%@.jpg",filePathApp,fileName];
        [imageData writeToFile:target options:NSDataWritingAtomic error:&error];
    }
    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end