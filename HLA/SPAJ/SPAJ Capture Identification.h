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


// DECLARATION

@protocol SPAJMainDelegate

    - (void) voidGoToAddDetail;
    - (void) voidGoToFormGeneration;
    - (void) voidGoToCaptureIdentification;
    - (void) voidGoToAddSignature;

@end

@interface SPAJCaptureIdentification : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

    // PROTOCOL

    @property (nonatomic,strong) id <SPAJMainDelegate> delegateSPAJMain;

    // VIEW

    @property (nonatomic, weak) IBOutlet UIView* viewContent;

    @property (nonatomic, weak) IBOutlet UIView* viewStep1;
    @property (nonatomic, weak) IBOutlet UIView* viewStep2;
    @property (nonatomic, weak) IBOutlet UIView* viewStep3;
    @property (nonatomic, weak) IBOutlet UIView* viewStep4;

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

    @property (nonatomic, weak) IBOutlet UIButton* buttonStep1;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep2;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep3;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep4;

@end