//
//  ViewController.m
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Add Detail.h"
#import "String.h"
#import "SPAJ Calon Pemegang Polis.h"
#import "SPAJ Calon Tertanggung.h"
#import "SPAJ Perusahaan.h"
#import "SPAJ Calon Penerima Manfaat.h"
#import "SPAJ Pembayaran Premi.h"
#import "ModelSPAJHtml.h"
#import "SIMenuTableViewCell.h"
#import "Theme.h"
#import "User Interface.h"
#import "Formatter.h"

// DECLARATION

@interface SPAJAddDetail ()<SPAJCalonPemegangPolisDelegate,SPAJCalonTertanggungDelegate,SPAJPerusahaanDelegate,SPAJCalonPenerimaManfaatDelegate,SPAJPembayaranPremiDelegate>



@end


// IMPLEMENTATION

@implementation SPAJAddDetail{
    UIBarButtonItem* rightButton;
    
    SPAJ_Calon_Pemegang_Polis* spajCalonPemegangPolis;
    SPAJ_Calon_Tertanggung* spajCalonTertanggung;
    SPAJ_Perusahaan* spajPerusahaan;
    SPAJ_Calon_Penerima_Manfaat* spajCalonPenerimaManfaat;
    SPAJ_Pembayaran_Premi* spajPembayaranPremi;
    Formatter *formatter;
    UserInterface *objectUserInterface;
    
    ModelSPAJHtml *modelSPAJHtml;

    NSMutableArray *NumberListOfSubMenu;
    NSMutableArray *ListOfSubMenu;
    
    BOOL boolPemegangPolis;
    BOOL boolTertanggung;
    BOOL boolPerusahaan;
    BOOL boolPenerimaManfaat;
    BOOL boolPembayaranPremi;
    BOOL boolKesehatan;
}
@synthesize buttonCaptureBack,buttonCaptureFront;
@synthesize imageViewFront,imageViewBack;
@synthesize stringGlobalEAPPNumber;
@synthesize dictTransaction;


    -(void)viewDidAppear:(BOOL)animated{
        [_tableSection selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self tableView:_tableSection didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        //INITIALIZATION
        objectUserInterface = [[UserInterface alloc] init];
        formatter = [[Formatter alloc]init];
        
        [self setNavigationBar];
        
        spajCalonPemegangPolis = [[SPAJ_Calon_Pemegang_Polis alloc]initWithNibName:@"SPAJ Calon Pemegang Polis" bundle:nil];
        [spajCalonPemegangPolis setDelegate:self];
        
        spajCalonTertanggung = [[SPAJ_Calon_Tertanggung alloc]initWithNibName:@"SPAJ Calon Tertanggung" bundle:nil];
        [spajCalonTertanggung setDelegate:self];
        
        spajPerusahaan = [[SPAJ_Perusahaan alloc]initWithNibName:@"SPAJ Perusahaan" bundle:nil];
        [spajPerusahaan setDelegate:self];
        
        spajCalonPenerimaManfaat = [[SPAJ_Calon_Penerima_Manfaat alloc]initWithNibName:@"SPAJ Calon Penerima Manfaat" bundle:nil];
        [spajCalonPenerimaManfaat setDelegate:self];
        
        spajPembayaranPremi = [[SPAJ_Pembayaran_Premi alloc]initWithNibName:@"SPAJ Pembayaran Premi" bundle:nil];
        [spajPembayaranPremi setDelegate:self];
        
        modelSPAJHtml = [[ModelSPAJHtml alloc]init];
        
        // LOCALIZATION
        
        _labelStep1.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP1", nil);
        _labelHeader1.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER1", nil);
        
        _labelStep2.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP2", nil);
        _labelHeader2.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER2", nil);
        
        _labelStep3.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP3", nil);
        _labelHeader3.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER3", nil);
        
        _labelStep4.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP4", nil);
        _labelHeader4.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER4", nil);
        
        _labelStep5.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP5", nil);
        _labelHeader5.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER5", nil);
        
        _labelStep6.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_STEP6", nil);
        _labelHeader6.text = NSLocalizedString(@"GUIDE_SPAJDETAIL_HEADER6", nil);
        
        //ARRAY INITIALIZATION
        NumberListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4",@"5",@"6", nil];
        ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Calon Pemegang Polis", @"Calon Tertanggung", @"Perusahaan / Berbadan Hukum", @"Calon Penerima Manfaat",@"Pembayaran Premi", @"Kesehatan", nil];
        
        boolPemegangPolis = true;
        boolTertanggung = false;
        boolPerusahaan = false;
        boolPenerimaManfaat = false;
        boolPembayaranPremi = false;
        boolKesehatan = false;
        
        [self voidCreateRightBarButton];
    }

    -(void)setNavigationBar{
        [self.navigationItem setTitle:@"Data Calon Pemegang Polis"];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[formatter navigationBarTitleColor],NSFontAttributeName: [formatter navigationBarTitleFont]}];
    }

    -(void)voidCreateRightBarButton{
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Simpan" style:UIBarButtonItemStylePlain target:self
                                                      action:@selector(actionRightBarButtonPressed:)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

    -(IBAction)actionRightBarButtonPressed:(UIBarButtonItem *)sender{
        if ([[spajCalonPemegangPolis.view.superview.subviews lastObject] isEqual: spajCalonPemegangPolis.view]){
            
        }
        else if ([[spajCalonTertanggung.view.superview.subviews lastObject] isEqual: spajCalonTertanggung.view]){
            
        }
        else if ([[spajPerusahaan.view.superview.subviews lastObject] isEqual: spajPerusahaan.view]){
            
        }
        else if ([[spajCalonPenerimaManfaat.view.superview.subviews lastObject] isEqual: spajCalonPenerimaManfaat.view]){
            
        }
        else if ([[spajPembayaranPremi.view.superview.subviews lastObject] isEqual: spajPembayaranPremi.view]){
            
            //[pernyataanNasabahVC voidDoneCFFData];
        }
    }



    // ACTION

    - (IBAction)actionGoToStep1:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PO"];
        [spajCalonPemegangPolis setHtmlFileName:stringHTMLName];
        [self loadSPAJCalonPemegangPolis];
    };

    - (IBAction)actionGoToStep2:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"TR"];
        [spajCalonTertanggung setHtmlFileName:stringHTMLName];
        [self loadSPAJCalonTertanggung];
    };

    - (IBAction)actionGoToStep3:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PR"];
        [spajPerusahaan setHtmlFileName:stringHTMLName];
        [self loadSPAJPerusahaan];
    };

    - (IBAction)actionGoToStep4:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PM"];
        [spajCalonPenerimaManfaat setHtmlFileName:stringHTMLName];
        [self loadSPAJCalonPenerimaManfaat];
    };

    - (IBAction)actionGoToStep5:(id)sender
    {
        NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PP"];
        [spajPembayaranPremi setHtmlFileName:stringHTMLName];
        [self loadSPAJPembayaranPremi];
    };

    - (IBAction)actionGoToStep6:(id)sender
    {

    };

    - (IBAction)actionGoToStep7:(id)sender
    {
    
    };

    /*-(IBAction)actionSnapFrontID:(UIButton *)sender{
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
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
    }*/

    -(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
    {
        switch (indexPath.row) {
            case 0:
            {
                NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PO"];
                [spajCalonPemegangPolis setHtmlFileName:stringHTMLName];
                [self loadSPAJCalonPemegangPolis];
                [rightButton setAction:@selector(voidDoneSPAJCalonPemegangPolis:)];
                break;
            }
            case 1:
            {
                NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"TR"];
                [spajCalonTertanggung setHtmlFileName:stringHTMLName];
                [self loadSPAJCalonTertanggung];
                [rightButton setAction:@selector(voidDoneSPAJCalonTertanggung:)];
                break;
            }
            case 2:
            {
                NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PR"];
                [spajPerusahaan setHtmlFileName:stringHTMLName];
                [self loadSPAJPerusahaan];
                [rightButton setAction:@selector(voidDoneSPAJPerusahaan:)];
                break;
            }
            case 3:
            {
                NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PM"];
                [spajCalonPenerimaManfaat setHtmlFileName:stringHTMLName];
                [self loadSPAJCalonPenerimaManfaat];
                [rightButton setAction:@selector(voidDoneSPAJPenerimaManfaat:)];
                break;
            }
            case 4:
            {
                NSString *stringHTMLName = [modelSPAJHtml selectHtmlFileName:@"SPAJHtmlName" SPAJSection:@"PP"];
                [spajPembayaranPremi setHtmlFileName:stringHTMLName];
                [self loadSPAJPembayaranPremi];
                [rightButton setAction:@selector(voidDoneSPAJPembayaranPremi:)];
                break;
            }
            default:
                break;
        }
    }

    #pragma mark UIBarButtonItem Action

    -(void)voidDoneSPAJCalonPemegangPolis:(UIBarButtonItem *)sender{
        [spajCalonPemegangPolis voidDoneSPAJCalonPemegangPolis];
    }
    -(void)voidDoneSPAJCalonTertanggung:(UIBarButtonItem *)sender{
        [spajCalonTertanggung voidDoneSPAJCalonTertanggung];
    }
    -(void)voidDoneSPAJPerusahaan:(UIBarButtonItem *)sender{
        [spajPerusahaan voidDoneSPAJPerusahaan];
    }
    -(void)voidDoneSPAJPenerimaManfaat:(UIBarButtonItem *)sender{
        [spajCalonPenerimaManfaat voidDoneSPAJPenerimaManfaat];
    }

    -(void)voidDoneSPAJPembayaranPremi:(UIBarButtonItem *)sender{
        [spajPembayaranPremi voidDoneSPAJPembayaranPremi];
    }

    #pragma mark load view controller
    -(void)loadSPAJCalonPemegangPolis{
        if ([spajCalonPemegangPolis.view isDescendantOfView:_viewContent]){
            [_viewContent bringSubviewToFront:spajCalonPemegangPolis.view];
        }
        else{
            [_viewContent addSubview:spajCalonPemegangPolis.view];
        }
    }
    -(void)loadSPAJCalonTertanggung{
        if ([spajCalonTertanggung.view isDescendantOfView:_viewContent]){
            [_viewContent bringSubviewToFront:spajCalonTertanggung.view];
        }
        else{
            [_viewContent addSubview:spajCalonTertanggung.view];
        }
    }
    -(void)loadSPAJPerusahaan{
        if ([spajPerusahaan.view isDescendantOfView:_viewContent]){
            [_viewContent bringSubviewToFront:spajPerusahaan.view];
        }
        else{
            [_viewContent addSubview:spajPerusahaan.view];
        }
    }
    -(void)loadSPAJCalonPenerimaManfaat{
        if ([spajCalonPenerimaManfaat.view isDescendantOfView:_viewContent]){
            [_viewContent bringSubviewToFront:spajCalonPenerimaManfaat.view];
        }
        else{
            [_viewContent addSubview:spajCalonPenerimaManfaat.view];
        }
    }
    -(void)loadSPAJPembayaranPremi{
        if ([spajPembayaranPremi.view isDescendantOfView:_viewContent]){
            [_viewContent bringSubviewToFront:spajPembayaranPremi.view];
        }
        else{
            [_viewContent addSubview:spajPembayaranPremi.view];
        }
    }

    #pragma mark - table view

    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 1;
    }

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return ListOfSubMenu.count;
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
        //UIColor *selectedColor = [UIColor colorWithRed:0/255.0f green:102.0f/255.0f blue:179.0f/255.0f alpha:1];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SIMenuTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        UIView *bgColorView = [[UIView alloc] init];
        if (indexPath.row<5){
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
        else{
            [cell setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:203.0/255.0 blue:205.0/255.0 alpha:1.0]];
        }
        
        bgColorView.backgroundColor = [objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0];
        [cell setSelectedBackgroundView:bgColorView];
        [cell.labelNumber setText:[NumberListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelDesc setText:[ListOfSubMenu objectAtIndex:indexPath.row]];
        [cell.labelWide setText:@""];
        
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
        
        if (boolPerusahaan){
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
        
        if (boolPenerimaManfaat){
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
        
        if (boolPembayaranPremi){
            if (indexPath.row == 4){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            }
            else{
                
            }
        }
        else{
            if (indexPath.row == 4){
                [cell setUserInteractionEnabled:false];
            }
            else{
                
            }
        }
        
        if (boolKesehatan){
            if (indexPath.row == 5){
                [cell setUserInteractionEnabled:true];
                [cell setBackgroundColor:[objectUserInterface generateUIColor:THEME_COLOR_PRIMARY floatOpacity:1.0]];
            }
            else{
                
            }
        }
        else{
            if (indexPath.row == 5){
                [cell setUserInteractionEnabled:false];
            }
            else{
                
            }
        }
        
        [cell.button1 setEnabled:false];
        [cell.button2 setEnabled:false];
        [cell.button3 setEnabled:false];
        
        return cell;
    }

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        [self showDetailsForIndexPath:indexPath];
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

#pragma mark delegate
    -(NSString *)voidGetEAPPNumber{
        //return stringGlobalEAPPNumber;
        return [dictTransaction valueForKey:@"SPAJEappNumber"];
    }

    -(void)voidSetCalonPemegangPolisBoolValidate:(BOOL)boolValidate{
        boolTertanggung = true;
        [self.navigationItem setTitle:@"Data Calon Tertanggung"];
        NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:1 inSection:0];
        [self showDetailsForIndexPath:indexPathSelect];
        [_tableSection reloadData];
        [_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
    }

    -(void)voidSetCalonTertnggungBoolValidate:(BOOL)boolValidate{
        boolPerusahaan = true;
        [self.navigationItem setTitle:@"Data Perusahaan / Badan Hukum"];
        NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:2 inSection:0];
        [self showDetailsForIndexPath:indexPathSelect];
        [_tableSection reloadData];
        [_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
    }

    -(void)voidSetPerusahaanBoolValidate:(BOOL)boolValidate{
        boolPenerimaManfaat = true;
        [self.navigationItem setTitle:@"Data Calon Penerima Manfaat"];
        NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:3 inSection:0];
        [self showDetailsForIndexPath:indexPathSelect];
        [_tableSection reloadData];
        [_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
    }

    -(void)voidSetPenerimaManfaatBoolValidate:(BOOL)boolValidate{
        boolPembayaranPremi = true;
        [self.navigationItem setTitle:@"Data Pembayaran Premi"];
        NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:4 inSection:0];
        [self showDetailsForIndexPath:indexPathSelect];
        [_tableSection reloadData];
        [_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
    }

    -(void)voidSetPembayaranPremiBoolValidate:(BOOL)boolValidate{
        boolKesehatan = true;
        [self.navigationItem setTitle:@"Data Kesehatan"];
        NSIndexPath* indexPathSelect = [NSIndexPath indexPathForRow:5 inSection:0];
        [self showDetailsForIndexPath:indexPathSelect];
        [_tableSection reloadData];
        [_tableSection selectRowAtIndexPath:indexPathSelect animated:YES scrollPosition:UITableViewScrollPositionTop];
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
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
        /*NSMutableDictionary *dic = [[_snapArr objectAtIndex:selectedRow]mutableCopy];
        if (snapMode== kFrontSnap) {
            [dic setObject:image forKey:@"frontSnap"];
            [_frontImageView setImage:image];
            _CheckView.hidden =YES;
            _CheckView1.hidden =YES;
        }
        else
        {
            [dic setObject:image forKey:@"backSnap"];
            [_backImageView setImage:image];
        }
        
        [_snapArr removeObjectAtIndex:selectedRow];
        [_snapArr insertObject:dic atIndex:selectedRow];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        [_tableView reloadData];*/
        //    [self performSelector:@selector(reloadData) withObject:nil afterDelay:1];
    }

// DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end