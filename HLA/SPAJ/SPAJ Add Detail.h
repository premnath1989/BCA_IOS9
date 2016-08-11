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

// DECLARATION

@interface SPAJAddDetail : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

    {
        CGRect imagePickerRect;
        CameraViewController *imagePickerController;
        BOOL cameraFront;
        
        //UINAvigation Bar
        //IBOutlet UINavigationBar* barDetail;
    }

    @property (strong, nonatomic) NSDictionary* dictTransaction;

    @property (strong, nonatomic) NSString* stringGlobalEAPPNumber;
    // VIEW

    @property (nonatomic, weak) IBOutlet UIView* viewContent;

    @property (nonatomic, weak) IBOutlet UIView* viewStep1;
    @property (nonatomic, weak) IBOutlet UIView* viewStep2;
    @property (nonatomic, weak) IBOutlet UIView* viewStep3;
    @property (nonatomic, weak) IBOutlet UIView* viewStep4;
    @property (nonatomic, weak) IBOutlet UIView* viewStep5;
    @property (nonatomic, weak) IBOutlet UIView* viewStep6;

    // UITABLEVIEW
    @property (nonatomic, weak) IBOutlet UITableView* tableSection;

    // IMAGEVIEW
    @property (nonatomic, weak) IBOutlet UIImageView* imageViewFront;
    @property (nonatomic, weak) IBOutlet UIImageView* imageViewBack;

    // LABEL

    @property (nonatomic, weak) IBOutlet UILabel* labelStep1;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader1;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep2;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader2;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep3;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader3;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep4;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader4;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep5;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader5;

    @property (nonatomic, weak) IBOutlet UILabel* labelStep6;
    @property (nonatomic, weak) IBOutlet UILabel* labelHeader6;



    // BUTTON
    //@property (nonatomic, strong) IBOutlet UIBarButtonItem* rightButton;

    @property (nonatomic, weak) IBOutlet UIButton* buttonCaptureFront;
    @property (nonatomic, weak) IBOutlet UIButton* buttonCaptureBack;

    @property (nonatomic, weak) IBOutlet UIButton* buttonStep1;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep2;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep3;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep4;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep5;
    @property (nonatomic, weak) IBOutlet UIButton* buttonStep6;

@end