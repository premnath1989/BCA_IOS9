//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Capture Identification.h"
#import "String.h"

NSString* const PemegangPolis = @"PemegangPolis";
NSString* const Tertanggung = @"Tertanggung";
NSString* const OrangTuaWali = @"OrangTuaWali";
NSString* const TenagaPenjual = @"TenagaPenjual";
NSString* const Payment = @"Payment";
NSString* const Other = @"Other";
NSString* const Front = @"Front";
NSString* const Back = @"Back";
// DECLARATION

@interface SPAJCaptureIdentification (){
    SPAJIDCapturedViewController* spajIDCapturedViewController;
}



@end


// IMPLEMENTATION

@implementation SPAJCaptureIdentification
{
    NSDictionary* dictionaryPOData;
    
    NSMutableArray *mutableArrayNumberListOfSubMenu;
    NSMutableArray *mutableArrayListOfSubMenu;
    NSMutableArray *mutableArrayListOfSubTitleMenu;
    
    BOOL boolPemegangPolis;
    BOOL boolTertanggung;
    BOOL boolOrangTuaWali;
    BOOL boolTenagaPenjual;
    BOOL boolPayment;
    BOOL boolOthers;
    
    BOOL boolTenagaPenjualSigned;
    
    int indexSelected;
    NSString* stringSIRelation;
    int LAAge;
    NSMutableArray* arrayIDBackDisabled;
}
@synthesize SPAJCaptureIdentificationDelegate;
@synthesize buttonCaptureBack,buttonCaptureFront,buttonIDTypeSelection,buttonSave;
@synthesize imageViewFront,imageViewBack;
@synthesize tablePartiesCaprture;
@synthesize dictTransaction;
    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        indexSelected=0;
        
        alert = [[Alert alloc]init];
        objectUserInterface = [[UserInterface alloc] init];
        modelProspectProfile = [[ModelProspectProfile alloc]init];
        modelSPAJIDCapture = [[ModelSPAJIDCapture alloc]init];
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        modelSIPOData = [[ModelSIPOData alloc]init];
        modelIdentificationType = [[ModelIdentificationType alloc]init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSPAJAnswers = [[ModelSPAJAnswers alloc]init];
        formatter = [[Formatter alloc]init];
        
        [self setNavigationBar];
        [self voidArrayInitialization];
        // LOCALIZATION
        
        _labelTitle.text = NSLocalizedString(@"GUIDE_CAPTUREID", nil);
        
        _labelStep1.text = NSLocalizedString(@"GUIDE_CAPTUREID_STEP1", nil);
        _labelHeader1.text = NSLocalizedString(@"GUIDE_CAPTUREID_HEADER1", nil);
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_CAPTUREID_STEP2", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_CAPTUREID_HEADER2", nil);
        
        _labelStep3.text = NSLocalizedString(@"GUIDE_CAPTUREID_STEP3", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_CAPTUREID_HEADER3", nil);
        
        _labelStep4.text = NSLocalizedString(@"GUIDE_CAPTUREID_STEP4", nil);
        _labelHeader4.text = NSLocalizedString(@"GUIDE_CAPTUREID_HEADER4", nil);
        
        boolPemegangPolis = false;
        boolTertanggung = false;
        boolOrangTuaWali = false;
        boolTenagaPenjual = false;
        boolPayment = false;
        [self initializeBooleanBasedOnTheRule];
        [self voidCheckBooleanLastState];
        [self voidTableCellLastStateChecker:boolPemegangPolis BOOLTR:boolTertanggung BOOLOW:boolOrangTuaWali BOOLTP:boolTenagaPenjual BOOLPayment:boolPayment BOOLOthers:boolOthers];
    }

    -(void)setNavigationBar{
        [self.navigationItem setTitle:@"Capture Identification Documents"];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
    }

    -(NSString *)getIDTypeForPemegangPolis{
        NSString* stringIDType;
        NSString* stringWhere = [NSString stringWithFormat:@"where elementID ='RadioButtonPolicyHolderIDType' and SPAJTransactionID = %i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                NSString* stringPOIDFromSPAJAnswers =[modelSPAJAnswers selectSPAJAnswersData:@"Value" StringWhere:stringWhere];
        NSString* stringDBID = [formatter getRevertIDNameFromHtml:stringPOIDFromSPAJAnswers];
        stringIDType = stringDBID;
        return stringIDType;
    }

    -(NSString *)getIDTypeDescForPemegangPolis{
        NSString* stringIDType;
        NSString* stringWhere = [NSString stringWithFormat:@"where elementID ='TextPolicyHolderIDTypeOther' and SPAJTransactionID = %i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
        NSString* stringPOIDFromSPAJAnswers =[modelSPAJAnswers selectSPAJAnswersData:@"Value" StringWhere:stringWhere];
        NSString* stringDBID = stringPOIDFromSPAJAnswers;
        stringIDType = stringDBID;
        return stringIDType;
    }

    -(NSString *)getIDTypeForTertanggung{
        NSString* stringIDType;
        NSString* stringWhere = [NSString stringWithFormat:@"where elementID ='RadioButtonProspectiveInsuredIDType' and SPAJTransactionID = %i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
        NSString* stringTRIDFromSPAJAnswers =[modelSPAJAnswers selectSPAJAnswersData:@"Value" StringWhere:stringWhere];
        NSString* stringDBID = [formatter getRevertIDNameFromHtml:stringTRIDFromSPAJAnswers];
        stringIDType = stringDBID;
        return stringIDType;
    }

    -(NSString *)getIDTypeDescForTertanggung{
        NSString* stringIDType;
        NSString* stringWhere = [NSString stringWithFormat:@"where elementID ='TextProspectiveInsuredIDTypeOther' and SPAJTransactionID = %i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
        NSString* stringPOIDFromSPAJAnswers =[modelSPAJAnswers selectSPAJAnswersData:@"Value" StringWhere:stringWhere];
        NSString* stringDBID = stringPOIDFromSPAJAnswers;
        stringIDType = stringDBID;
        return stringIDType;
    }


    -(void)voidArrayInitialization{
        //mutableArrayNumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
        //mutableArrayListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Calon Pemegang Polis ", @"Calon Tertanggung", @"Orang Tua / Wali yang sah", @"Tenaga Penjual", nil];
        //mutableArrayListOfSubTitleMenu = [[NSMutableArray alloc] initWithObjects:@"", @"",@"", @"", nil];
        arrayIDBackDisabled = [[NSMutableArray alloc]initWithObjects:@"PASPOR",@"KITAS",@"KIMS/KITAS",@"Form Tenaga Penjual", nil];
        //mutableArrayNumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3",@"4",@"5",@"6", nil];
        //mutableArrayListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Calon Pemegang Polis ", @"Calon Tertanggung", @"Orang Tua / Wali yang sah",@"Tenaga Penjual",@"Payment",@"Other", nil];
        mutableArrayNumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3",@"4",@"5", nil];
        mutableArrayListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Calon Pemegang Polis ", @"Calon Tertanggung", @"Orang Tua / Wali yang sah",@"Payment",@"Other", nil];
        mutableArrayListOfSubTitleMenu = [[NSMutableArray alloc] initWithObjects:@"", @"",@"",@"",@"",@"", nil];
    }

    -(void)initializeBooleanBasedOnTheRule{
        NSString* stringEAppNumber = [dictTransaction valueForKey:@"SPAJEappNumber"];//[SPAJAddSignatureDelegate voidGetEAPPNumber];
        NSString* SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:stringEAppNumber];
        
        dictionaryPOData = [[NSDictionary alloc]initWithDictionary:[modelSIPOData getPO_DataFor:SINO]];
        stringSIRelation = [dictionaryPOData valueForKey:@"RelWithLA"];
        LAAge = [[dictionaryPOData valueForKey:@"LA_Age"] intValue];
    }

    -(void)voidCheckBooleanLastState {
        boolPemegangPolis = [modelSPAJIDCapture voidCertainIDPartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] IDParty:@"SPAJIDCaptureParty1"];
        boolTertanggung = [modelSPAJIDCapture voidCertainIDPartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] IDParty:@"SPAJIDCaptureParty2"];
        boolOrangTuaWali = [modelSPAJIDCapture voidCertainIDPartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] IDParty:@"SPAJIDCaptureParty3"];
        boolTenagaPenjual = [modelSPAJIDCapture voidCertainIDPartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] IDParty:@"SPAJIDCaptureParty4"];
        boolPayment = [modelSPAJIDCapture voidCertainIDPartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] IDParty:@"SPAJIDCaptureParty5"];
        boolOthers = [modelSPAJIDCapture voidCertainIDPartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] IDParty:@"SPAJIDCaptureParty6"];
        
        boolTenagaPenjualSigned = [modelSPAJSignature voidCertainSignaturePartyCaptured:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue] SignatureParty:@"SPAJSignatureParty4"];
        //[self voidTableCellLastStateChecker:boolPemegangPolis BOOLTR:boolTertanggung BOOLOW:boolOrangTuaWali BOOLTP:boolTenagaPenjual];
    }

    -(void)voidTableCellLastStateChecker:(BOOL)boolPO BOOLTR:(BOOL)boolTR BOOLOW:(BOOL)boolOW BOOLTP:(BOOL)boolTP BOOLPayment:(BOOL)boolPaymentMethod BOOLOthers:(BOOL)boolOthers{
        if (boolPO){
            if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
                if (boolPaymentMethod){
                    [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                }
                else{
                    [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                }
                /*if (boolTP){
                    if (boolPaymentMethod){
                        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                    }
                    else{
                        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    }
                }
                else{
                    [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                }*/
            }
            else{
                if (LAAge<21){
                    if (boolOW){
                        if (boolPaymentMethod){
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        }
                        else{
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        }
                        /*if (boolTP){
                            if (boolPaymentMethod){
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                            }
                            else{
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                            }
                        }
                        else{
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        }*/
                        
                    }
                    else{
                        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    }
                }
                else{
                    if (boolTR){
                        if (boolPaymentMethod){
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        }
                        else{
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        }
                        /*if (boolTP){
                            if (boolPaymentMethod){
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                            }
                            else{
                                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                            }
                        }
                        else{
                            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        }*/
                        
                    }
                    else{
                        [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    }
                }
            }
        }
        else{
            [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        [tablePartiesCaprture selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexSelected inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    }

    -(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
    {
        indexSelected=indexPath.row;
        switch (indexPath.row) {
            case 0:
                //[self actionViewPhoto:nil];
                [self showIDType:indexSelected];
                [buttonIDTypeSelection setEnabled:false];
                break;
            case 1:
                //[self actionViewPhoto:nil];
                [self showIDType:indexSelected];
                [buttonIDTypeSelection setEnabled:false];
                break;
            case 2:
                //[self actionViewPhoto:nil];
                [buttonIDTypeSelection setEnabled:true];
                break;
            /*case 3:
                //[self actionViewPhoto:nil];
                [self showIDType:indexSelected];
                [buttonIDTypeSelection setEnabled:false];
                break;*/
            case 3:
                //[self actionViewPhoto:nil];
                [self showIDType:indexSelected];
                [buttonIDTypeSelection setEnabled:false];
                break;
            case 4:
                //[self actionViewPhoto:nil];
                [self showIDType:indexSelected];
                [buttonIDTypeSelection setEnabled:false];
                break;
            default:
                break;
        }
        [imageViewFront setImage:nil];
        [imageViewBack setImage:nil];
    }



    // ACTION

    - (IBAction)actionGoToStep1:(id)sender
    {
        
    };

    - (IBAction)actionGoToStep2:(id)sender
    {
        
    };

    - (IBAction)actionGoToStep3:(id)sender
    {
        NSLog(@"test");
    };

    - (IBAction)actionGoToStep4:(id)sender
    {

    };

    - (IBAction)actionGoToStep5:(id)sender
    {

    };

    - (IBAction)actionGoToStep6:(id)sender
    {

    };

    - (IBAction)actionShowIdentificationType:(UIButton *)sender
    {
        [self resignFirstResponder];
        [self.view endEditing:YES];
        
        Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
        id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
        [activeInstance performSelector:@selector(dismissKeyboard)];
        
        NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
        [ClientProfile setObject:@"YES" forKey:@"isNew"];
        
        if (IDTypePicker == nil) {
            IDTypePicker = [[IDTypeViewController alloc] initWithStyle:UITableViewStylePlain];
            IDTypePicker.delegate = self;
            IDTypePicker.requestType = @"CO";
            IDTypePicker.modalPresentationStyle = UIModalPresentationPopover;
            IDTypePicker.preferredContentSize = CGSizeMake(300, 220);
        }
        
        UIPopoverPresentationController *popController = [IDTypePicker popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popController.sourceView = sender;
        popController.sourceRect = sender.bounds;
        popController.delegate = self;
        [self presentViewController:IDTypePicker animated:YES completion:nil];
    };

    - (IBAction)takePhoto:(id)sender
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.showsCameraControls = NO;
        [self presentViewController:picker animated:YES completion:^ { [picker takePicture]; }];
    }

    -(void)showIDType:(int)IndexRow{
        if (IndexRow==0)
        {
            stringIDTypeIdentifier = [modelIdentificationType getOtherTypeID:[self getIDTypeForPemegangPolis]];//[modelProspectProfile selectProspectData:@"OtherIDType" ProspectIndex:[[dictionaryPOData valueForKey:@"PO_ClientID"] intValue]] ;
            NSString* identityDesc;
            if ([[self getIDTypeForPemegangPolis] isEqualToString:@"Others"]){
                identityDesc = [self getIDTypeDescForPemegangPolis];
            }
            else{
                identityDesc = [self getIDTypeForPemegangPolis];
            }
            //[modelIdentificationType getOtherTypeDesc:stringIDTypeIdentifier] ;
            [buttonIDTypeSelection setTitle:identityDesc forState:UIControlStateNormal];
        }
        else if (IndexRow==1)
        {
            stringIDTypeIdentifier = [modelIdentificationType getOtherTypeID:[self getIDTypeForTertanggung]];//[modelProspectProfile selectProspectData:@"OtherIDType" ProspectIndex:[[dictionaryPOData valueForKey:@"PO_ClientID"] intValue]] ;
            NSString* identityDesc;
            if ([[self getIDTypeForTertanggung] isEqualToString:@"Others"]){
                identityDesc = [self getIDTypeDescForTertanggung];
            }
            else{
                identityDesc = [self getIDTypeForTertanggung];
            }
            //[modelIdentificationType getOtherTypeDesc:stringIDTypeIdentifier] ;
            [buttonIDTypeSelection setTitle:identityDesc forState:UIControlStateNormal];
        }
        /*else if (IndexRow==3){
            stringIDTypeIdentifier = @"" ;
            NSString* identityDesc = @"Form Tenaga Penjual" ;
            [buttonIDTypeSelection setTitle:identityDesc forState:UIControlStateNormal];
        }*/
        else if (IndexRow==3){
            stringIDTypeIdentifier = @"" ;
            NSString* identityDesc = @"Payment" ;
            [buttonIDTypeSelection setTitle:identityDesc forState:UIControlStateNormal];
        }
        else{
            stringIDTypeIdentifier = @"VID17" ;
            NSString* identityDesc = [modelIdentificationType getOtherTypeDesc:stringIDTypeIdentifier] ;
            [buttonIDTypeSelection setTitle:identityDesc forState:UIControlStateNormal];
        }
    }

    -(IBAction)actionViewPhoto:(UIButton *)sender{
        //[self voidShowFrontPhoto:indexSelected];
        //[self voidShowBackPhoto:indexSelected];
        NSString* identityDesc ;
        identityDesc =[modelIdentificationType getOtherTypeDesc:stringIDTypeIdentifier];
        switch (indexSelected) {
            case 0:
                stringIDTypeIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty1" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                if ([identityDesc isEqualToString:@"Others"]){
                    identityDesc = [self getIDTypeDescForPemegangPolis];
                }
                break;
            case 1:
                stringIDTypeIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty2" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                if ([identityDesc isEqualToString:@"Others"]){
                    identityDesc = [self getIDTypeDescForTertanggung];
                }
                break;
            case 2:
                stringIDTypeIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty3" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                break;
            /*case 3:
                stringIDTypeIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty4" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                break;*/
            case 3:
                stringIDTypeIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty5" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                break;
            case 4:
                stringIDTypeIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty6" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                break;
            default:
                break;
        }
        
        //if ([modelIdentificationType getOtherTypeDesc:stringIDTypeIdentifier].length>0){
            NSString* stringName;
            if (indexSelected == 0){
                stringName = [NSString stringWithFormat:@"%@ (Calon Pemegang Polis)",[dictionaryPOData valueForKey:@"PO_Name"]];
                
            }
            else if (indexSelected == 1){
                stringName = [NSString stringWithFormat:@"%@ (Calon Tertanggung)",[dictionaryPOData valueForKey:@"LA_Name"]];
            }
            
        
        
        
        
            UIImage* imageFrontPhoto = [self getFrontPhoto:indexSelected]?:[UIImage imageNamed:@"xxx.png"];
            UIImage* imageBackPhoto = [self getBackPhoto:indexSelected]?:[UIImage imageNamed:@"xxx.png"];
            
            NSDictionary*dictIDInfo = [[NSDictionary alloc]initWithObjectsAndKeys:
                                       identityDesc?:@"",@"IDType",
                                       stringName?:@"",@"stringName",nil];
            
            spajIDCapturedViewController = [[SPAJIDCapturedViewController alloc]initWithNibName:@"SPAJIDCapturedViewController" bundle:nil];
            [spajIDCapturedViewController setDictTransaction:dictTransaction];
            [spajIDCapturedViewController setDictionaryIDData:dictIDInfo];
            [spajIDCapturedViewController setImageBack:imageBackPhoto];
            [spajIDCapturedViewController setImageFront:imageFrontPhoto];
            //[spajIDCapturedViewController showMultiplePictureForSection:@"Others" StringButtonType:[buttonIDTypeSelection currentTitle]];
            [spajIDCapturedViewController setButtonTitle:[buttonIDTypeSelection currentTitle]];
            [spajIDCapturedViewController setPartyIndex:[NSNumber numberWithInt:indexSelected]];
        
        
            spajIDCapturedViewController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:spajIDCapturedViewController animated:YES completion:nil];
        /*}
        else{
            identityDesc = @"Select Identification Type";
        }*/
        //[buttonIDTypeSelection setTitle:identityDesc forState:UIControlStateNormal];
        
    }

    -(void)voidShowFrontPhoto:(int)indexPositionSelected{
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString* stringEAPPPath = [dictTransaction valueForKey:@"SPAJEappNumber"];
        NSString* filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPPath];
        
        //filename combination is EAPPNumberPartyIDTypeFront
        //filename combination is EAPPNumberPartyIDTypeBack
        NSString* fileName;
        NSString* stringIDIdentifier;
        NSString* imagePath;
        switch (indexPositionSelected) {
            case 0:
            {
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty1" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,PemegangPolis,stringIDIdentifier,Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewFront setImage:imageID];
                break;
                }
            case 1:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty2" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,Tertanggung,stringIDIdentifier,Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewFront setImage:imageID];
                break;
            }
            case 2:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty3" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,OrangTuaWali,stringIDIdentifier,Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewFront setImage:imageID];
                break;
            }
            case 3:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty4" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,Payment,stringIDIdentifier,Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewFront setImage:imageID];
                break;
            }
            default:
                break;
        }
        
    }

    -(void)voidShowBackPhoto:(int)indexPositionSelected{
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString* stringEAPPPath = [dictTransaction valueForKey:@"SPAJEappNumber"];
        NSString* filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPPath];
        
        //filename combination is EAPPNumberPartyIDTypeFront
        //filename combination is EAPPNumberPartyIDTypeBack
        NSString* fileName;
        NSString* stringIDIdentifier;
        NSString* imagePath;
        switch (indexPositionSelected) {
            case 0:
            {
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty1" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,PemegangPolis,stringIDIdentifier,Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewBack setImage:imageID];
                break;
            }
            case 1:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty2" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,Tertanggung,stringIDIdentifier,Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewBack setImage:imageID];
                break;
            }
            case 2:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty3" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,OrangTuaWali,stringIDIdentifier,Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewBack setImage:imageID];
                break;
            }
            case 3:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty4" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@%@%@%@.jpg",stringEAPPPath,Payment,stringIDIdentifier,Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                UIImage *imageID = [UIImage imageWithContentsOfFile:imagePath];
                [imageViewBack setImage:imageID];
                break;
            }
            default:
                break;
        }
    }

    -(UIImage *)getFrontPhoto:(int)indexPositionSelected{
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString* stringEAPPPath = [dictTransaction valueForKey:@"SPAJEappNumber"];
        NSString* filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPPath];
        
        //filename combination is EAPPNumberPartyIDTypeFront
        //filename combination is EAPPNumberPartyIDTypeBack
        NSString* fileName;
        NSString* stringIDIdentifier;
        NSString* imagePath;
        UIImage *imageID;
        switch (indexPositionSelected) {
            case 0:
            {
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty1" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,PemegangPolis,[buttonIDTypeSelection currentTitle]?:@"",Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 1:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty2" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,Tertanggung,[buttonIDTypeSelection currentTitle]?:@"",Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 2:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty3" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,OrangTuaWali,[buttonIDTypeSelection currentTitle]?:@"",Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 3:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty4" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                //NSString *identityDescNew =[modelIdentificationType getOtherTypeDesc:stringIDTypeIdentifier];
                NSString *identityDescNew = @"Form Tenaga Penjual";
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,TenagaPenjual,identityDescNew,Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 4:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty5" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,Payment,[buttonIDTypeSelection currentTitle]?:@"",Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 5:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty6" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,Other,[buttonIDTypeSelection currentTitle]?:@"",Front];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            default:
                break;
        }
        return imageID;
        
    }

    -(UIImage *)getBackPhoto:(int)indexPositionSelected{
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString* stringEAPPPath = [dictTransaction valueForKey:@"SPAJEappNumber"];
        NSString* filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPPath];
        
        //filename combination is EAPPNumberPartyIDTypeFront
        //filename combination is EAPPNumberPartyIDTypeBack
        NSString* fileName;
        NSString* stringIDIdentifier;
        NSString* imagePath;
        UIImage *imageID;
        switch (indexPositionSelected) {
            case 0:
            {
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty1" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,PemegangPolis,[buttonIDTypeSelection currentTitle],Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 1:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty2" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,Tertanggung,[buttonIDTypeSelection currentTitle],Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 2:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty3" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,OrangTuaWali,[buttonIDTypeSelection currentTitle],Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 3:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty4" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                NSString *identityDescNew =[modelIdentificationType getOtherTypeDesc:stringIDTypeIdentifier];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,TenagaPenjual,identityDescNew,Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 4:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty5" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,Payment,[buttonIDTypeSelection currentTitle],Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            case 5:{
                stringIDIdentifier = [modelSPAJIDCapture selectIDType:@"SPAJIDTypeParty6" SPAJSection:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
                fileName = [NSString stringWithFormat:@"/%@_%@_%@_%@.jpg",stringEAPPPath,Other,[buttonIDTypeSelection currentTitle],Back];
                imagePath = [filePathApp stringByAppendingString:fileName];
                imageID = [UIImage imageWithContentsOfFile:imagePath];
                return imageID;
                break;
            }
            default:
                break;
        }
        return imageID;
    }

    -(IBAction)actionSnapFrontID:(UIButton *)sender{
        if ([buttonIDTypeSelection.currentTitle isEqualToString:@"Select Identification Type"])
        {
            UIAlertController *alertEmptyImage = [alert alertInformation:@"Tipe Identitas Kosong" stringMessage:@"Tipe Identitas belum dipilih. Silahkan pilih tipe identitas terlebih dahulu"];
            [self presentViewController:alertEmptyImage animated:YES completion:nil];
        }
        else
        {

            cameraFront = true;
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
    }

    -(IBAction)actionSnapBackID:(UIButton *)sender{
        if ([buttonIDTypeSelection.currentTitle isEqualToString:@"Select Identification Type"])
        {
            UIAlertController *alertEmptyImage = [alert alertInformation:@"Tipe Identitas Kosong" stringMessage:@"Tipe Identitas belum dipilih. Silahkan pilih tipe identitas terlebih dahulu"];
            [self presentViewController:alertEmptyImage animated:YES completion:nil];
        }
        else
        {
            if (![arrayIDBackDisabled containsObject:buttonIDTypeSelection.currentTitle]){
                cameraFront=false;
                UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable:source])
                {
                    imagePickerController= [[CameraViewController alloc] init];
                    imagePickerController.sourceType = source;
                    
                    CGRect rect = imagePickerController.view.frame;
                    imagePickerRect = rect;
                    CGSize frameSize = CGSizeMake(800,562.5);
                    
                    CGRect frameRect = CGRectMake((rect.size.width-frameSize.width)/2, (rect.size.height-frameSize.height)/2, frameSize.width, frameSize.height);
                    //CGRect frameRect = CGRectMake(15, 94, frameSize.width, frameSize.height);
                    
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
        }
    }

    - (IBAction)actionCompleteSnap:(UIButton *)buttonSavePicture{
        if (!boolTenagaPenjualSigned){
            if (CGSizeEqualToSize(imageViewFront.image.size, CGSizeZero))
            {
                UIAlertController *alertEmptyImage = [alert alertInformation:@"Gambar Identitas Kosong" stringMessage:@"Gambar Identitas kosong. Silahkan foto indentitas terlebih dahulu"];
                [self presentViewController:alertEmptyImage animated:YES completion:nil];
            }
            else
            {
                if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
                    if (indexSelected == 4){
                        [self copyIDImagesToSPAJFolder:imageViewFront Party:Other IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                        [self copyIDImagesToSPAJFolder:imageViewBack Party:Other IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty6=1,SPAJIDTypeParty6='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                        
                        [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                        [self voidCheckBooleanLastState];
                    }
                    if (indexSelected == 3){
                        [self copyIDImagesToSPAJFolder:imageViewFront Party:Payment IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                        [self copyIDImagesToSPAJFolder:imageViewBack Party:Payment IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty5=1,SPAJIDTypeParty5='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                        
                        [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                        [self voidCheckBooleanLastState];
                    }

                    /*else if (indexSelected == 3){
                        [self copyIDImagesToSPAJFolder:imageViewFront Party:TenagaPenjual IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                        [self copyIDImagesToSPAJFolder:imageViewBack Party:TenagaPenjual IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty4=1,SPAJIDTypeParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                        
                        [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                        [self voidCheckBooleanLastState];
                    }*/
                    else if (indexSelected == 2){
                        
                    }
                    else if (indexSelected == 1){
                        
                    }
                    else if (indexSelected == 0){
                        [self copyIDImagesToSPAJFolder:imageViewFront Party:PemegangPolis IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                        [self copyIDImagesToSPAJFolder:imageViewBack Party:PemegangPolis IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                        NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty1=1,SPAJIDTypeParty1='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                        
                        [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                        
                        NSString *stringUpdate1 = [NSString stringWithFormat:@" set SPAJIDCaptureParty4=1,SPAJIDTypeParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                        
                        [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate1];
                        [self voidCheckBooleanLastState];
                    }
                }
                else{
                    if (LAAge<21){
                        if (indexSelected == 4){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:Other IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:Other IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty6=1,SPAJIDTypeParty6='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                        if (indexSelected == 3){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:Payment IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:Payment IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty5=1,SPAJIDTypeParty5='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                        /*if (indexSelected == 3){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:TenagaPenjual IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:TenagaPenjual IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty4=1,SPAJIDTypeParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }*/
                        else if (indexSelected == 2){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:OrangTuaWali IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:OrangTuaWali IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty3=1,SPAJIDTypeParty3='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                        else if (indexSelected == 1){
                            //empty
                        }
                        else if (indexSelected == 0){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:PemegangPolis IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:PemegangPolis IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty1=1,SPAJIDTypeParty1='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                    }
                    else{
                        if (indexSelected == 4){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:Other IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:Other IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty6=1,SPAJIDTypeParty6='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                        else if (indexSelected == 3){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:Payment IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:Payment IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty5=1,SPAJIDTypeParty5='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                        /*else if (indexSelected == 3){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:TenagaPenjual IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:TenagaPenjual IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty4=1,SPAJIDTypeParty4='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }*/
                        else if (indexSelected == 2){
                            //empty
                        }
                        else if (indexSelected == 1){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:Tertanggung IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:Tertanggung IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty2=1,SPAJIDTypeParty2='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                        else if (indexSelected == 0){
                            [self copyIDImagesToSPAJFolder:imageViewFront Party:PemegangPolis IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Front];
                            [self copyIDImagesToSPAJFolder:imageViewBack Party:PemegangPolis IDType:[buttonIDTypeSelection currentTitle]?:@"" Side:Back];
                            NSString *stringUpdate = [NSString stringWithFormat:@" set SPAJIDCaptureParty1=1,SPAJIDTypeParty1='%@' where SPAJTransactionID = (select SPAJTransactionID from SPAJTransaction where SPAJEappNumber = '%@')",stringIDTypeIdentifier,[dictTransaction valueForKey:@"SPAJEappNumber"]];
                            
                            [modelSPAJIDCapture updateSPAJIDCapture:stringUpdate];
                            [self voidCheckBooleanLastState];
                        }
                    }
                }
                [modelSPAJTransaction updateSPAJTransaction:@"SPAJDateModified" StringColumnValue:[formatter getDateToday:@"yyyy-MM-dd HH:mm:ss"] StringWhereName:@"SPAJEappNumber" StringWhereValue:[dictTransaction valueForKey:@"SPAJEappNumber"]];
                
                [tablePartiesCaprture reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tablePartiesCaprture selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexSelected inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
                });
                [buttonSavePicture setEnabled:false];
            }
        }
        else{
            UIAlertController *alertLockForm = [alert alertInformation:NSLocalizedString(@"ALERT_TITLE_LOCK", nil) stringMessage:NSLocalizedString(@"ALERT_MESSAGE_LOCK", nil)];
            [self presentViewController:alertLockForm animated:YES completion:nil];
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

    #pragma mark copy images to spaj folder
    -(void)copyIDImagesToSPAJFolder:(UIImageView *)imageView Party:(NSString *)stringParty IDType:(NSString *)stringIDType Side:(NSString *)stringSide{
        NSError *error =  nil;
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString* stringEAPPPath = [dictTransaction valueForKey:@"SPAJEappNumber"];
        NSString* filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPPath];
        
        //filename combination is EAPPNumberPartyIDTypeFront
        //filename combination is EAPPNumberPartyIDTypeBack
        NSString* fileName = [NSString stringWithFormat:@"%@_%@_%@_%@",stringEAPPPath,stringParty,stringIDType,stringSide];
        
        //NSData *imageData = UIImageJPEGRepresentation([self generateWatermarkForImage:imageView.image], 0.8);
        NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.8);
        
        if ((indexSelected==4)||(indexSelected==5)){
            NSString* target=[NSString stringWithFormat:@"%@/%@.jpg",filePathApp,fileName];
            NSString* fname = [target lastPathComponent];
            NSString* fnameNoExt = [fname stringByDeletingPathExtension];
            NSString* extension = [fname pathExtension];
            
            int fileIndex = 1;
            while ([[NSFileManager defaultManager] fileExistsAtPath:target])
            {
                //NSLog(@"FNAME : %@",fname);
                fname = [NSString stringWithFormat:@"%@ (%i).%@", fnameNoExt, fileIndex, extension];
                //NSLog(@"Setting filename to :: %@",fname);
                fileIndex++;
                target = [filePathApp stringByAppendingPathComponent:fname];
            }
                [imageData writeToFile:target options:NSDataWritingAtomic error:&error];
        }
        else{
            NSString* target=[NSString stringWithFormat:@"%@/%@.jpg",filePathApp,fileName];
            [imageData writeToFile:target options:NSDataWritingAtomic error:&error];
        }
    }

    #pragma mark delegate image picker
    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [self crop:originalimage];
        if (cameraFront){
            [imageViewFront setImage:image];
        }
        else{
            [imageViewBack setImage:image];
        }
        [buttonSave setEnabled:true];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }


// DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    #pragma mark delegate IDType
    -(void)IDTypeDescSelected:(NSString *)selectedIDType
    {
        if ([selectedIDType isEqualToString:@"- SELECT -"]){
            [IDTypePicker dismissViewControllerAnimated:YES completion:nil];
            UIAlertController* alertIDType = [UIAlertController alertControllerWithTitle:@"ID Type Wrong" message:@"Select another ID Type" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertIDType addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:alertIDType animated:YES completion:nil];
            });
        }
        else{
            [buttonIDTypeSelection setTitle:selectedIDType forState:UIControlStateNormal];
            [IDTypePicker dismissViewControllerAnimated:YES completion:nil];
        }
    }

    -(void)IDTypeCodeSelected:(NSString *)IDTypeCode
    {
        stringIDTypeCode = IDTypeCode;
    }

    - (void)IDTypeCodeSelectedWithIdentifier:(NSString *) IDTypeCode Identifier:(NSString *)identifier
    {
        stringIDTypeCode = IDTypeCode;
        stringIDTypeIdentifier = identifier;
    }

    -(UIImage *) generateWatermarkForImage:(UIImage *) mainImg{
        UIImage *backgroundImage = mainImg;
        UIImage *watermarkImage = [UIImage imageNamed:@"watermarkID.png"];
        
        //Now re-drawing your  Image using drawInRect method
        UIGraphicsBeginImageContext(backgroundImage.size);
        [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
        // set watermark position/frame a s(xposition,yposition,width,height)
        // [watermarkImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkImage.size.width, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
        [watermarkImage drawInRect:CGRectMake(0, 0, watermarkImage.size.width, watermarkImage.size.height)];
        
        // now merging two images into one
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }

#pragma mark - table view

    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 1;
    }

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return mutableArrayListOfSubMenu.count;
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
        static NSString *CellIdentifier = @"Cell";
        SIMenuTableViewCell *cell = (SIMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SIMenuTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        //[cell setBackgroundColor:[UIColor whiteColor]];
        if (indexPath.row<2){
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
        else{
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
        [cell setSelectedBackgroundView:bgColorView];
        [cell.labelSubtitle setHidden:NO];
        
        [cell.labelNumber setText:[mutableArrayNumberListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelDesc setText:[mutableArrayListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelWide setText:@""];
        [cell.labelSubtitle setText:[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row]];
        
        [cell.button1 setEnabled:false];
        [cell.button2 setEnabled:false];
        [cell.button3 setEnabled:false];
        
        if (boolPemegangPolis){
            if ([stringSIRelation isEqualToString:@"DIRI SENDIRI"]){
                if ((indexPath.row == 0)||(indexPath.row == 3)||(indexPath.row == 4)){
                    [cell setUserInteractionEnabled:true];
                    [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                }
                else{
                    [cell setUserInteractionEnabled:false];
                }
                /*if (boolTenagaPenjual){
                    if ((indexPath.row == 0)||(indexPath.row == 3)||(indexPath.row == 4)||(indexPath.row == 5)){
                        [cell setUserInteractionEnabled:true];
                        [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                    }
                    else{
                        [cell setUserInteractionEnabled:false];
                    }
                }
                else{
                    if ((indexPath.row == 0)||(indexPath.row == 3)){
                        [cell setUserInteractionEnabled:true];
                        [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                    }
                    else{
                        [cell setUserInteractionEnabled:false];
                    }
                }*/
                
            }
            else{
                if (LAAge<21){
                    if (boolOrangTuaWali){
                        if ((indexPath.row == 0)||(indexPath.row == 2)||(indexPath.row == 3)||(indexPath.row == 4)){
                            [cell setUserInteractionEnabled:true];
                            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                        }
                        else{
                            [cell setUserInteractionEnabled:false];
                        }
                        /*if (boolTenagaPenjual){
                            //if ((indexPath.row == 0)||(indexPath.row == 2)||(indexPath.row == 3)||(indexPath.row == 4)||(indexPath.row == 5)){
                            if ((indexPath.row == 0)||(indexPath.row == 2)||(indexPath.row == 3)||(indexPath.row == 4)){
                                [cell setUserInteractionEnabled:true];
                                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                            }
                            else{
                                [cell setUserInteractionEnabled:false];
                            }
                        }
                        else{
                            if ((indexPath.row == 0)||(indexPath.row == 2)||(indexPath.row == 3)){
                                [cell setUserInteractionEnabled:true];
                                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                            }
                            else{
                                [cell setUserInteractionEnabled:false];
                            }
                        }*/
                    }
                    else{
                        if ((indexPath.row == 0)||(indexPath.row == 2)){
                            [cell setUserInteractionEnabled:true];
                            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                        }
                        else{
                            [cell setUserInteractionEnabled:false];
                        }
                    }
                }
                else{
                    if (boolTertanggung){
                        if ((indexPath.row == 0)||(indexPath.row == 1)||(indexPath.row == 3)||(indexPath.row == 4)){
                            [cell setUserInteractionEnabled:true];
                            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                        }
                        else{
                            [cell setUserInteractionEnabled:false];
                        }
                        /*if (boolTenagaPenjual){
                            //if ((indexPath.row == 0)||(indexPath.row == 1)||(indexPath.row == 3)||(indexPath.row == 4)||(indexPath.row == 5)){
                            if ((indexPath.row == 0)||(indexPath.row == 1)||(indexPath.row == 3)||(indexPath.row == 4)){
                                [cell setUserInteractionEnabled:true];
                                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                            }
                            else{
                                [cell setUserInteractionEnabled:false];
                            }
                        }
                        else{
                            if ((indexPath.row == 0)||(indexPath.row == 1)||(indexPath.row == 3)){
                                [cell setUserInteractionEnabled:true];
                                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                            }
                            else{
                                [cell setUserInteractionEnabled:false];
                            }
                        }*/
                    }
                    else{
                        if ((indexPath.row == 0)||(indexPath.row == 1)){
                            [cell setUserInteractionEnabled:true];
                            [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
                        }
                        else{
                            [cell setUserInteractionEnabled:false];
                        }
                    }
                }
            }
        }
        else{
            if (indexPath.row == 0){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_ACTIVE_CELL floatOpacity:1.0]];
            }
            else{
                [cell setUserInteractionEnabled:false];
            }
        }
        return cell;
    }

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        [self showDetailsForIndexPath:indexPath];
    }


@end