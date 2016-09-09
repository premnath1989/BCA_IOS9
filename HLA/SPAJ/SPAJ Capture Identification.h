//
//  ViewController.h
//  Bless SPAJ
//
//  Created by Ibrahim on 17/06/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "IDTypeViewController.h"
#import "SIMenuTableViewCell.h"
#import "Theme.h"
#import "User Interface.h"
#import "Alert.h"
#import "ModelSPAJIDCapture.h"
#import "ModelIdentificationType.h"
#import "Formatter.h"
#import "ModelSPAJTransaction.h"
#import "ModelSIPOData.h"
#import "ModelSPAJSignature.h"
#import "SPAJIDCapturedViewController.h"
#import "ModelProspectProfile.h"
#import "ModelSPAJAnswers.h"
// DECLARATION

/*@protocol SPAJMainDelegate

    - (void) voidGoToAddDetail;
    - (void) voidGoToFormGeneration;
    - (void) voidGoToCaptureIdentification;
    - (void) voidGoToAddSignature;

@end*/
@protocol SPAJCaptureIdentificationDelegate
    -(NSString *)voidGetEAPPNumber;
@end

@interface SPAJCaptureIdentification : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,IDTypeDelegate,UIPopoverPresentationControllerDelegate>

    {
        
        CGRect imagePickerRect;
        Alert* alert;
        UserInterface *objectUserInterface;
        ModelProspectProfile *modelProspectProfile;
        ModelSPAJIDCapture *modelSPAJIDCapture;
        ModelSPAJTransaction* modelSPAJTransaction;
        ModelSIPOData* modelSIPOData;
        Formatter* formatter;
        ModelIdentificationType* modelIdentificationType;
        ModelSPAJSignature* modelSPAJSignature;
        ModelSPAJAnswers* modelSPAJAnswers;
        
        CameraViewController *imagePickerController;
        BOOL cameraFront;
        
        IDTypeViewController *IDTypePicker;
        
        //variable for IDType
        NSString* stringIDTypeCode;
        NSString* stringIDTypeIdentifier;
    }

    // PROTOCOL

    @property (nonatomic,strong) id <SPAJCaptureIdentificationDelegate> SPAJCaptureIdentificationDelegate;

    @property (strong, nonatomic) NSDictionary* dictTransaction;

    // VIEW
    @property (nonatomic, weak) IBOutlet UIView* viewCaptureFront;
    @property (nonatomic, weak) IBOutlet UIView* viewCaptureBack;

    @property (nonatomic, weak) IBOutlet UIView* viewContent;

    @property (nonatomic, weak) IBOutlet UIView* viewStep1;
    @property (nonatomic, weak) IBOutlet UIView* viewStep2;
    @property (nonatomic, weak) IBOutlet UIView* viewStep3;
    @property (nonatomic, weak) IBOutlet UIView* viewStep4;

    // IMAGEVIEW
    @property (nonatomic, weak) IBOutlet UIImageView* imageViewFront;
    @property (nonatomic, weak) IBOutlet UIImageView* imageViewBack;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel* labelTitle;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep1;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader1;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep2;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader2;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep3;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader3;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep4;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader4;

    // BUTTON
    @property (nonatomic, weak) IBOutlet UIButton* buttonCaptureFront;
    @property (nonatomic, weak) IBOutlet UIButton* buttonCaptureBack;

    @property (nonatomic, weak) IBOutlet UIButton* buttonIDTypeSelection;
    @property (nonatomic, weak) IBOutlet UIButton* buttonSave;

    @property (nonatomic, weak) IBOutlet UIButton* buttonStep1;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep2;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep3;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep4;

    // UITableView
    @property (nonatomic, weak) IBOutlet UITableView *tablePartiesCaprture;

@end