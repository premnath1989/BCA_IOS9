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


// DECLARATION

@interface SPAJAddDetail ()



@end


// IMPLEMENTATION

@implementation SPAJAddDetail
@synthesize buttonCaptureBack,buttonCaptureFront;
@synthesize imageViewFront,imageViewBack;

        // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
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
        
        //[self voidSetButtonShapeToCircle];
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

    - (IBAction)actionGoToStep7:(id)sender
    {
    
    };

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