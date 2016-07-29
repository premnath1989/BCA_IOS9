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


// DECLARATION

@interface SPAJCaptureIdentification ()



@end


// IMPLEMENTATION

@implementation SPAJCaptureIdentification
{
    NSMutableArray *mutableArrayNumberListOfSubMenu;
    NSMutableArray *mutableArrayListOfSubMenu;
    NSMutableArray *mutableArrayListOfSubTitleMenu;
    
    BOOL boolPemegangPolis;
    BOOL boolTertanggung;
    BOOL boolOrangTuaWali;
    BOOL boolTenagaPenjual;
}
@synthesize SPAJCaptureIdentificationDelegate;
@synthesize buttonCaptureBack,buttonCaptureFront,buttonIDTypeSelection;
@synthesize imageViewFront,imageViewBack;
@synthesize tablePartiesCaprture;
    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        alert = [[Alert alloc]init];
        objectUserInterface = [[UserInterface alloc] init];
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
        
        boolPemegangPolis = true;
        boolTertanggung = false;
        boolOrangTuaWali = false;
        boolTenagaPenjual = false;
    }

    -(void)voidArrayInitialization{
        /*stringNamaPemegangPolis = @"Nama Pemegang Polis";
        stringNamaTertanggung = @"Nama Tertanggung";
        stringNamaOrangTuaWali = @"Nama Orang Tua Wali";
        stringNamaTenagaPenjual = @"Nama Tenaga Penjual";
        
        stringTableRow1 = [NSString stringWithFormat:@"Calon Pemegang Polis \r%@",stringNamaPemegangPolis];
        stringTableRow2 = [NSString stringWithFormat:@"Calon Tertanggung \r%@",stringNamaTertanggung];
        stringTableRow3 = [NSString stringWithFormat:@"Orang Tua / Wali yang sah \r%@",stringNamaOrangTuaWali];
        stringTableRow4 = [NSString stringWithFormat:@"Tenaga Penjual \r%@",stringNamaTenagaPenjual];*/
        
        mutableArrayNumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", nil];
        mutableArrayListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Calon Pemegang Polis ", @"Calon Tertanggung", @"Orang Tua / Wali yang sah", @"Tenaga Penjual", nil];
        mutableArrayListOfSubTitleMenu = [[NSMutableArray alloc] initWithObjects:@"", @"",@"", @"", nil];
    }

    -(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
    {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                
                break;
            case 2:
                
                break;
            case 3:
                
                break;
            default:
                break;
        }
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

    

    -(IBAction)actionSnapFrontID:(UIButton *)sender{
        cameraFront = true;
        UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:source])
        {
            imagePickerController= [[CameraViewController alloc] init];
            imagePickerController.sourceType = source;
            
            CGRect rect = imagePickerController.view.frame;
            imagePickerRect = rect;
            CGSize frameSize = CGSizeMake(738,562.5);
            
            //CGRect frameRect = CGRectMake((rect.size.width-frameSize.width)/2, (rect.size.height-frameSize.height)/2, frameSize.width, frameSize.height);
            CGRect frameRect = CGRectMake(15, 94, frameSize.width, frameSize.height);
            
            UIView *view = [[UIView alloc]initWithFrame:frameRect];
            [view setBackgroundColor:[UIColor clearColor]];
            
            view.layer.borderWidth = 5.0;
            view.layer.borderColor = [UIColor redColor].CGColor;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, -80, 300, 200)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"Please snap within the red frame";
            [view addSubview:lbl];
            
            //imagePickerController.cameraOverlayView = view;
            
            imagePickerController.delegate = self;
            imagePickerController.modalPresentationStyle = UIModalPresentationPageSheet;
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

    -(IBAction)actionSnapBackID:(UIButton *)sender{
        cameraFront=false;
        UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:source])
        {
            imagePickerController= [[CameraViewController alloc] init];
            imagePickerController.sourceType = source;
            
            CGRect rect = imagePickerController.view.frame;
            imagePickerRect = rect;
            CGSize frameSize = CGSizeMake(738,562.5);
            
            //CGRect frameRect = CGRectMake((rect.size.width-frameSize.width)/2, (rect.size.height-frameSize.height)/2, frameSize.width, frameSize.height);
            CGRect frameRect = CGRectMake(15, 94, frameSize.width, frameSize.height);
            
            UIView *view = [[UIView alloc]initWithFrame:frameRect];
            [view setBackgroundColor:[UIColor clearColor]];
            
            view.layer.borderWidth = 5.0;
            view.layer.borderColor = [UIColor redColor].CGColor;
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, -80, 300, 200)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.text = @"Please snap within the red frame";
            [view addSubview:lbl];
            
            //imagePickerController.cameraOverlayView = view;
            
            imagePickerController.delegate = self;
            imagePickerController.modalPresentationStyle = UIModalPresentationPageSheet;
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

    - (IBAction)actionCompleteSnap:(UIButton *)buttonSavePicture{
        if (CGSizeEqualToSize(imageViewFront.image.size, CGSizeZero))
        {
            UIAlertController *alertEmptyImage = [alert alertInformation:@"Gambar Identitas Kosong" stringMessage:@"Gambar Identitas kosong. Silahkan foto indentitas terlebih dahulu"];
            [self presentViewController:alertEmptyImage animated:YES completion:nil];
        }
        else if ([buttonIDTypeSelection.currentTitle isEqualToString:@"Select Identification Type"])
        {
            UIAlertController *alertEmptyImage = [alert alertInformation:@"Tipe Identitas Kosong" stringMessage:@"Tipe Identitas belum dipilih. Silahkan pilih tipe identitas terlebih dahulu"];
            [self presentViewController:alertEmptyImage animated:YES completion:nil];
        }
        else
        {
            if (boolTenagaPenjual && boolOrangTuaWali && boolPemegangPolis && boolTertanggung){
                boolPemegangPolis = true;
                boolTertanggung = true;
                boolOrangTuaWali =  true;
                boolTenagaPenjual = true;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                [self copyIDImagesToSPAJFolder:imageViewFront Party:@"TenagaPenjual" IDType:stringIDTypeIdentifier Side:@"Front"];
                [self copyIDImagesToSPAJFolder:imageViewBack Party:@"TenagaPenjual" IDType:stringIDTypeIdentifier Side:@"Back"];
            }
            else if (boolOrangTuaWali && boolPemegangPolis && boolTertanggung){
                boolPemegangPolis = true;
                boolTertanggung = true;
                boolOrangTuaWali =  true;
                boolTenagaPenjual = true;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                [self copyIDImagesToSPAJFolder:imageViewFront Party:@"OrangTuaWali" IDType:stringIDTypeIdentifier Side:@"Front"];
                [self copyIDImagesToSPAJFolder:imageViewBack Party:@"OrangTuaWali" IDType:stringIDTypeIdentifier Side:@"Back"];
            }
            else if (boolPemegangPolis && boolTertanggung){
                boolPemegangPolis = true;
                boolTertanggung = true;
                boolOrangTuaWali =  true;
                boolTenagaPenjual = false;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                [self copyIDImagesToSPAJFolder:imageViewFront Party:@"Tertanggung" IDType:stringIDTypeIdentifier Side:@"Front"];
                [self copyIDImagesToSPAJFolder:imageViewBack Party:@"Tertanggung" IDType:stringIDTypeIdentifier Side:@"Back"];
            }
            else if (boolPemegangPolis){
                boolPemegangPolis = true;
                boolTertanggung = true;
                boolOrangTuaWali =  false;
                boolTenagaPenjual = false;
                [self showDetailsForIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [self copyIDImagesToSPAJFolder:imageViewFront Party:@"PemegangPolis" IDType:stringIDTypeIdentifier Side:@"Front"];
                [self copyIDImagesToSPAJFolder:imageViewBack Party:@"PemegangPolis" IDType:stringIDTypeIdentifier Side:@"Back"];
            }
            [imageViewFront setImage:nil];
            [imageViewBack setImage:nil];
            [tablePartiesCaprture reloadData];
        }
        
    }


    #pragma mark crop function
    - (UIImage *)crop:(UIImage *)image {
        
        CGRect originalrect = imagePickerRect;
        CGSize frameSize = CGSizeMake(738,562.50);
        
        //float CalX=(originalrect.size.width-frameSize.width)/2;
        float CalX=15;
        //float CalY=(originalrect.size.height-frameSize.height)/2;
        float CalY=94;
        
        //CGRect frameRect = CGRectMake(CalX-55, CalY-55, frameSize.width, frameSize.height);
        CGRect frameRect = CGRectMake(CalX, CalY-74, frameSize.width, frameSize.height);
        //CGRect frameRect = CGRectMake(15, 94, frameSize.width, frameSize.height);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect([self imageWithImage:image scaledToSize:CGSizeMake(512,360)].CGImage, frameRect);
        UIImage *result = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
        UIImage *lowResImage = [UIImage imageWithData:UIImageJPEGRepresentation(result, 0.7)];
        CGImageRelease(imageRef);
        //return lowResImage;
        return image;
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
        NSString* stringEAPPPath = [SPAJCaptureIdentificationDelegate voidGetEAPPNumber];
        
        NSString* docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString* filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPPath];
        
        //filename combination is EAPPNumberPartyIDTypeFront
        //filename combination is EAPPNumberPartyIDTypeBack
        NSString* fileName = [NSString stringWithFormat:@"%@%@%@%@",stringEAPPPath,stringParty,stringIDType,stringSide];
        
        NSData *imageData = UIImageJPEGRepresentation(imageView.image, 0.8);
        [imageData writeToFile:[NSString stringWithFormat:@"%@/%@.jpg",filePathApp,fileName] options:NSDataWritingAtomic error:&error];
    }

    #pragma mark delegate image picker
    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        UIImage *originalimage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //UIImage *image = [self crop:originalimage];
        if (cameraFront){
            [imageViewFront setImage:originalimage];
        }
        else{
            [imageViewBack setImage:originalimage];
        }
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
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
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        [cell.labelSubtitle setHidden:NO];
        
        [cell.labelNumber setTextColor:[UIColor blackColor]];
        [cell.labelDesc setTextColor:[UIColor blackColor]];
        [cell.labelWide setTextColor:[UIColor blackColor]];
        [cell.labelSubtitle setTextColor:[UIColor blackColor]];
        
        [cell.labelNumber setText:[mutableArrayNumberListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelDesc setText:[mutableArrayListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelWide setText:@""];
        [cell.labelSubtitle setText:[mutableArrayListOfSubTitleMenu objectAtIndex:indexPath.row]];
        
        [cell.button1 setEnabled:false];
        [cell.button2 setEnabled:false];
        [cell.button3 setEnabled:false];
        
        if (boolPemegangPolis){
            if (indexPath.row == 0){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            }
            else{
                
            }
        }
        else{
            if (indexPath.row == 0){
                [cell setUserInteractionEnabled:false];
            }
            else{
                
            }
        }
        
        
        if (boolTertanggung){
            if (indexPath.row == 1){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            }
            else{
                
            }
        }
        else{
            if (indexPath.row == 1){
                [cell setUserInteractionEnabled:false];
            }
            else{
                
            }
        }
        
        if (boolOrangTuaWali){
            if (indexPath.row == 2){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            }
            else{
                
            }
        }
        else{
            if (indexPath.row == 2){
                [cell setUserInteractionEnabled:false];
            }
            else{
                
            }
        }
        
        if (boolTenagaPenjual){
            if (indexPath.row == 3){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            }
            else{
                
            }
        }
        else{
            if (indexPath.row == 3){
                [cell setUserInteractionEnabled:false];
            }
            else{
                
            }
        }
        
        return cell;
    }

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        [self showDetailsForIndexPath:indexPath];
    }


@end