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
#import "Formatter.h"
#import "ModelSPAJTransaction.h"
#import "ModelSPAJSignature.h"
#import "ModelSPAJIDCapture.h"

// DECLARATION

@interface SPAJMain ()<SPAJMainDelegate,SPAJCaptureIdentificationDelegate,SPAJAddSignatureDelegate,SPAJEappListDelegate>

    

@end


// IMPLEMENTATION

@implementation SPAJMain{
    CarouselViewController *viewControllerHome;
    ModelSPAJTransaction* modelSPAJTransaction;
    ModelSPAJSignature* modelSPAJSignature;
    ModelSPAJIDCapture* modelSPAJIDCapture;
    Formatter* formatter;
    
    UIAlertController *alertController;
    SPAJEApplicationList *viewControllerEappListing;
    SPAJExistingList* viewControllerExistingList;
    SPAJSubmittedList* viewControllerSubmittedList;
    
    NSString* stringGlobalEAPPNumber;
    
    BOOL isInEditMode;
}

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        isInEditMode = false;
        
        SPAJAddMenu* viewController = [[SPAJAddMenu alloc] initWithNibName:@"SPAJ Add Menu" bundle:nil];
        viewController.delegateSPAJMain = self;
        
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSPAJIDCapture = [[ModelSPAJIDCapture alloc]init];
        formatter = [[Formatter alloc]init];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
        viewControllerHome = [mainStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
        
        UIStoryboard *spajStoryboard = [UIStoryboard storyboardWithName:@"SPAJEAppListStoryBoard" bundle:Nil];
        
        viewControllerEappListing = [spajStoryboard instantiateViewControllerWithIdentifier:@"EAppListRootVC"];
        
        viewControllerExistingList = [[SPAJExistingList alloc] initWithNibName:@"SPAJ Existing List" bundle:nil];
        
        viewControllerSubmittedList = [[SPAJSubmittedList alloc] initWithNibName:@"SPAJ Submitted List" bundle:nil];
        
        //NSNOTIFICATION CENTER
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"GOTOSPAJ"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"GOTOHOME"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"EditMode"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"ViewMode"
                                                   object:nil];
        
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
        
        //SPAJExistingList* viewController = [[SPAJExistingList alloc] initWithNibName:@"SPAJ Existing List" bundle:nil];
        //SPAJEApplicationList* viewController = [[SPAJEApplicationList alloc] initWithNibName:@"SPAJ E Application List" bundle:nil];
        //UIStoryboard *spajStoryboard = [UIStoryboard storyboardWithName:@"SPAJEAppListStoryBoard" bundle:Nil];
        //SPAJEApplicationList *viewController = [spajStoryboard instantiateViewControllerWithIdentifier:@"EAppListRootVC"];
        //viewController.delegateSPAJEappList = self;
        viewControllerEappListing.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewControllerEappListing];
        [self.viewContent addSubview:viewControllerEappListing.view];
        //[self actionGoToEApplicationList:nil];
    };

    //NOTIFICATION RECEIVE
    - (void)receiveNotification:(NSNotification *)notification
    {
        if ([[notification name] isEqualToString:@"GOTOSPAJ"]) {
            //doSomething here.
            [self actionGoToExistingList:nil];
        }
        else if ([[notification name] isEqualToString:@"GOTOHOME"]) {
            //doSomething here.
            [self actionGoToHome:nil];
        }
        
        else if ([[notification name] isEqualToString:@"EditMode"]) {
            //doSomething here.
            isInEditMode = true;
        }
        
        else if ([[notification name] isEqualToString:@"ViewMode"]) {
            //doSomething here.
            isInEditMode = false;
        }
    }


    // ACTION

    - (IBAction)actionGoToEApplicationList:(id)sender
    {
        @autoreleasepool {
            /*if (isInEditMode){
                NSString* message=@"Anda sedang berada pada menu input Data. Yakin ingin keluar tanpa menyimpan data ?";
                alertController = [UIAlertController alertControllerWithTitle:@"Peringatan" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    viewControllerEappListing.view.frame = self.viewContent.bounds;
                    //viewController.delegateSPAJEappList = self;
                    [self addChildViewController:viewControllerEappListing];
                    [self.viewContent addSubview:viewControllerEappListing.view];
                    
                    isInEditMode = false;
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                
            }
            else{*/
                viewControllerEappListing.view.frame = self.viewContent.bounds;
                //viewController.delegateSPAJEappList = self;
                [self addChildViewController:viewControllerEappListing];
                [self.viewContent addSubview:viewControllerEappListing.view];
                
                //isInEditMode = false;
            //}
        }
    };

    - (IBAction)actionGoToExistingList:(id)sender
    {
        @autoreleasepool {
            if (isInEditMode){
                NSString* message=@"Anda sedang berada pada menu input Data. Yakin ingin keluar tanpa menyimpan data ?";
                alertController = [UIAlertController alertControllerWithTitle:@"Peringatan" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    viewControllerExistingList.view.frame = self.viewContent.bounds;
                    [self addChildViewController:viewControllerExistingList];
                    [self.viewContent addSubview:viewControllerExistingList.view];
                    
                    isInEditMode = false;
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                
            }
            else{
                viewControllerExistingList.view.frame = self.viewContent.bounds;
                [self addChildViewController:viewControllerExistingList];
                [self.viewContent addSubview:viewControllerExistingList.view];
                
                isInEditMode = false;
            }
        }
    };

    - (IBAction)actionGoToSubmittedList:(id)sender
    {
        @autoreleasepool {
            
            if (isInEditMode){
                NSString* message=@"Anda sedang berada pada menu input Data. Yakin ingin keluar tanpa menyimpan data ?";
                alertController = [UIAlertController alertControllerWithTitle:@"Peringatan" message:message preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    viewControllerSubmittedList.view.frame = self.viewContent.bounds;
                    [self addChildViewController:viewControllerSubmittedList];
                    [self.viewContent addSubview:viewControllerSubmittedList.view];
                    
                    isInEditMode = false;
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                
            }
            else{
                viewControllerSubmittedList.view.frame = self.viewContent.bounds;
                [self addChildViewController:viewControllerSubmittedList];
                [self.viewContent addSubview:viewControllerSubmittedList.view];
                
                isInEditMode = false;
            }
        }
    };

    - (IBAction)actionGoToAddMenu:(id)sender
    {
        /*stringGlobalEAPPNumber = [self createSPAJTransactionNumber];
        SPAJAddMenu* viewController = [[SPAJAddMenu alloc] initWithNibName:@"SPAJ Add Menu" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        viewController.delegateSPAJMain = self;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
        [viewController setStringEAPPNumber:stringGlobalEAPPNumber];
        
        dispatch_queue_t serialQueue = dispatch_queue_create("com.blah.queue", DISPATCH_QUEUE_SERIAL);
        
        dispatch_async(serialQueue, ^{
            [self createSPAJTransactionData:stringGlobalEAPPNumber];
        });
        
        dispatch_async(serialQueue, ^{
            [self createSPAJSignatureData:stringGlobalEAPPNumber];
        });
        
        dispatch_async(serialQueue, ^{
            [self createSPAJIDCaptureData:stringGlobalEAPPNumber];
        });*/
        
    };

    - (void)voidGoToAddDetail
    {
        SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [viewController setStringGlobalEAPPNumber:stringGlobalEAPPNumber];
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
       // SPAJAddDetail* viewController = [[SPAJAddDetail alloc] initWithNibName:@"SPAJ Capture Identification" bundle:nil];
        SPAJCaptureIdentification* viewController = [[SPAJCaptureIdentification alloc] initWithNibName:@"SPAJ Capture Identification" bundle:nil];
        viewController.SPAJCaptureIdentificationDelegate = self;
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    }

    //added by faiz
    - (void)voidGoToAddSignature
    {
        SPAJ_Add_Signature* viewController = [[SPAJ_Add_Signature alloc] initWithNibName:@"SPAJ Add Signature" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        viewController.SPAJAddSignatureDelegate = self;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
    }

    - (IBAction)actionGoToHome:(id)sender
    {
        // CarouselViewController* viewController = [[CarouselViewController alloc] initWithNibName:@"SPAJ Add Detail" bundle:nil];
        // [self presentViewController:viewController animated:true completion:nil];
        if (isInEditMode){
            NSString* message=@"Anda sedang berada pada menu input Data. Yakin ingin keluar tanpa menyimpan data ?";
            alertController = [UIAlertController alertControllerWithTitle:@"Peringatan" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES
                                         completion:^{
                                             [self presentViewController:viewControllerHome animated:NO completion:Nil];
                                         }];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self presentViewController:alertController animated:YES completion:nil];
            });

        }
        else{
            [self dismissViewControllerAnimated:YES
                                     completion:^{
                                         [self presentViewController:viewControllerHome animated:NO completion:Nil];
                                     }];
        }
        
    }

#pragma mark create SPAJ Transaction
    // Save New SPAJ to DB
    -(NSString *)createSPAJTransactionNumber
    {
        int randomNumber = [formatter getRandomNumberBetween:1000 MaxValue:9999];
        NSString* EAPPNumber = [NSString stringWithFormat:@"EAPPRN%i",randomNumber];
        return EAPPNumber;
    }

    -(void)createSPAJTransactionData:(NSString *)stringEAPPNo;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        NSString* dateToday=[formatter getDateToday:@"yyyy-MM-dd hh:mm:ss"];
        
        NSString* stringEAPPNumber = stringEAPPNo;//[self createSPAJTransactionNumber];
        
        [dictionarySPAJTransaction setObject:@"1" forKey:@"SPAJID"];
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"" forKey:@"SPAJNumber"];
        [dictionarySPAJTransaction setObject:@"" forKey:@"SPAJSINO"];
        [dictionarySPAJTransaction setObject:dateToday forKey:@"SPAJDateCreated"];
        [dictionarySPAJTransaction setObject:@"" forKey:@"CreatedBy"];
        [dictionarySPAJTransaction setObject:dateToday forKey:@"SPAJDateModified"];
        [dictionarySPAJTransaction setObject:@"" forKey:@"ModifiedBy"];
        [dictionarySPAJTransaction setObject:@"Not Complete" forKey:@"SPAJStatus"];
        
        [modelSPAJTransaction saveSPAJTransaction:dictionarySPAJTransaction];
        
        [self voidCreateSPAJFolderDocument:stringEAPPNumber];
    }

    -(void)createSPAJSignatureData:(NSString *)stringEAPPNo;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        
        NSString* stringEAPPNumber = stringEAPPNo;
        
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty1"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty2"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty3"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJSignatureParty4"];
        
        
        [modelSPAJSignature saveSPAJSignature:dictionarySPAJTransaction];
    }

    -(void)createSPAJIDCaptureData:(NSString *)stringEAPPNo;
    {
        NSMutableDictionary* dictionarySPAJTransaction = [[NSMutableDictionary alloc]init];
        
        NSString* stringEAPPNumber = stringEAPPNo;
        
        [dictionarySPAJTransaction setObject:stringEAPPNumber forKey:@"SPAJEappNumber"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty1"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty2"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty3"];
        [dictionarySPAJTransaction setObject:@"0" forKey:@"SPAJIDCaptureParty4"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty1"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty2"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty3"];
        [dictionarySPAJTransaction setObject:@"null" forKey:@"SPAJIDTypeParty4"];
        
        
        [modelSPAJIDCapture saveSPAJIDCapture:dictionarySPAJTransaction];
    }

    -(void)voidCreateSPAJFolderDocument:(NSString *)stringEAPPNumber
    {
        NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *rootFilePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
        NSString *filePathApp = [rootFilePathApp stringByAppendingPathComponent:stringEAPPNumber];
        
        [formatter createDirectory:rootFilePathApp];
        
        [formatter createDirectory:filePathApp];
    }

    #pragma mark delegate
    -(NSString *)voidGetEAPPNumber{
        return stringGlobalEAPPNumber;
    }

    // DID RECEIVE MEMOY WARNING

    - (void)didReceiveMemoryWarning
    {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end