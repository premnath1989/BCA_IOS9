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

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
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

    - (IBAction)takePhoto:(id)sender
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.showsCameraControls = NO;
        [self presentViewController:picker animated:YES completion:^ { [picker takePicture]; }];
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end