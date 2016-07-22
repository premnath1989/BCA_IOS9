//
//  ViewController.m
//  Practice
//
//  Created by Ibrahim on 19/05/2016.
//  Copyright © 2016 Ibrahim. All rights reserved.
//


// IMPORT

#import "SPAJ Main.h"
#import "SPAJ Existing List.h"
#import "SPAJ Submitted List.h"
#import "SPAJ Add Menu.h"
#import "SPAJ Add Detail.h"
#import "SPAJ E Application List.h"
#import "SPAJ Add Signature.h"
#import "SPAJ Form Generation.h"
#import "SPAJ Capture Identification.h"
#import "Insert Initialization.h"
#import "CarouselViewController.h"


// DECLARATION

@interface SPAJMain ()<SPAJMainDelegate>

    

@end


// IMPLEMENTATION

@implementation SPAJMain

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // LAYOUT DECLARATION
        
        InsertInitialization *insertInitialization = [[InsertInitialization alloc]init];
        [insertInitialization initializeSPAJHeader];
        
        
        // LOCALIZATION
        
        /* for (NSString* family in [UIFont familyNames])
        {
            NSLog(@"%@", family);
            
            for (NSString* name in [UIFont fontNamesForFamilyName: family])
            {
                NSLog(@"  %@", name);
            }
        } */
        
        [_buttonHome setTitle:NSLocalizedString(@"BUTTON_HOME", nil) forState:UIControlStateNormal];
        [_buttonEApplicationList setTitle:NSLocalizedString(@"BUTTON_EAPPLICATIONLIST", nil) forState:UIControlStateNormal];
        [_buttonExistingList setTitle:NSLocalizedString(@"BUTTON_EXISTINGLIST", nil) forState:UIControlStateNormal];
        [_buttonSubmittedList setTitle:NSLocalizedString(@"BUTTON_SUBMITTEDLIST", nil) forState:UIControlStateNormal];
        [_buttonAdd setTitle:NSLocalizedString(@"BUTTON_ADD", nil) forState:UIControlStateNormal];
    }


    // VIEW DID APPEAR

    - (void) viewDidAppear:(BOOL)animated
    {
        // DEFAULT CHILD VIEW
        
        SPAJExistingList* viewController = [[SPAJExistingList alloc] initWithNibName:@"SPAJ Existing List" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    };


    // ACTION

    - (IBAction)actionGoToEApplicationList:(id)sender
    {
        SPAJEApplicationList* viewController = [[SPAJEApplicationList alloc] initWithNibName:@"SPAJ E Application List" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    };

    - (IBAction)actionGoToExistingList:(id)sender
    {
        SPAJExistingList* viewController = [[SPAJExistingList alloc] initWithNibName:@"SPAJ Existing List" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    };

    - (IBAction)actionGoToSubmittedList:(id)sender
    {
        SPAJSubmittedList* viewController = [[SPAJSubmittedList alloc] initWithNibName:@"SPAJ Submitted List" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    };

    - (IBAction)actionGoToAddMenu:(id)sender
    {
        SPAJAddMenu* viewController = [[SPAJAddMenu alloc] initWithNibName:@"SPAJ Add Menu" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        viewController.delegateSPAJMain = self;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    };

    - (void)voidGoToAddDetail
    {
        SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    }

    - (void)voidGoToFormGeneration
    {
        SPAJFormGeneration* viewController = [[SPAJFormGeneration alloc] initWithNibName:@"SPAJ Form Generation" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    }

    - (void)voidGoToCaptureIdentification
    {
        SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Capture Identification" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    }

    //added by faiz
    - (void)voidGoToAddSignature
    {
        SPAJ_Add_Signature* viewController = [[SPAJ_Add_Signature alloc] initWithNibName:@"SPAJ Add Signature" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    }

    - (IBAction)actionGoToHome:(id)sender
    {
        // CarouselViewController* viewController = [[CarouselViewController alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
        // [self presentViewController:viewController animated:true completion:nil];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
        
        CarouselViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
        [self presentViewController:viewController animated:NO completion:Nil];
    }


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end