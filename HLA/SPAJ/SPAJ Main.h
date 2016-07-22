//
//  ViewController.h
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// DECLARATION

@interface SPAJMain : UIViewController

    // VIEW

    @property (nonatomic, weak) IBOutlet UIView *viewContent;

    // BUTTON

    @property (nonatomic, weak) IBOutlet UIButton *buttonHome;
    @property (nonatomic, weak) IBOutlet UIButton *buttonEApplicationList;
    @property (nonatomic, weak) IBOutlet UIButton *buttonExistingList;
    @property (nonatomic, weak) IBOutlet UIButton *buttonSubmittedList;
    @property (nonatomic, weak) IBOutlet UIButton *buttonAdd;

    // FUNCTION

    - (void) voidGoToAddDetail;
    - (void) voidGoToFormGeneration;
    - (void) voidGoToCaptureIdentification;
    - (void) voidGoToAddSignature;

@end