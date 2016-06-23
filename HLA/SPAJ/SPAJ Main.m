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


// DECLARATION

@interface SPAJMain ()

    

@end


// IMPLEMENTATION

@implementation SPAJMain

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // LAYOUT DECLARATION
        
        //self.viewContent =
        
        
        
        /* ProductInformation *view = [[ProductInformation alloc] initWithNibName:@"ProductInformation" bundle:nil];
        view.modalTransitionStyle = UIModalPresentationFullScreen;
        [self presentViewController:view animated:NO completion:nil];\ */
        
        
        // LOCALIZATION
        
        /* for (NSString* family in [UIFont familyNames])
        {
            NSLog(@"%@", family);
            
            for (NSString* name in [UIFont fontNamesForFamilyName: family])
            {
                NSLog(@"  %@", name);
            }
        } */
    }


    // ACTION

    - (IBAction)actionGoToExistingList:(id)sender
    {
        SPAJExistingList* viewController = [[SPAJExistingList alloc] initWithNibName:@"SPAJ Existing List" bundle:nil];
        /* [[viewController.view widthAnchor] constraintEqualToConstant:self.viewContent.frame.size.width].active = true;
        [[viewController.view heightAnchor] constraintEqualToConstant:self.viewContent.frame.size.height].active = true;
        viewController.modalTransitionStyle = UIModalPresentationFullScreen;
        [viewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [viewController.view setAutoresizesSubviews:true]; */
        [self.viewContent addSubview:viewController.view];
    };

    - (IBAction)actionGoToSubmittedList:(id)sender
    {
        SPAJSubmittedList* viewController = [[SPAJSubmittedList alloc] initWithNibName:@"SPAJ Submitted List" bundle:nil];
        [self.viewContent addSubview:viewController.view];
    };

    - (IBAction)actionGoToAddMenu:(id)sender
    {
        SPAJAddMenu* viewController = [[SPAJAddMenu alloc] initWithNibName:@"SPAJ Add Menu" bundle:nil];
        [self.viewContent addSubview:viewController.view];
    };


    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end