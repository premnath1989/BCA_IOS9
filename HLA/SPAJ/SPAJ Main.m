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
    ModelSPAJTransaction* modelSPAJTransaction;
    ModelSPAJSignature* modelSPAJSignature;
    ModelSPAJIDCapture* modelSPAJIDCapture;
    Formatter* formatter;
    
    NSString* stringGlobalEAPPNumber;
}

    // DID LOAD

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        SPAJAddMenu* viewController = [[SPAJAddMenu alloc] initWithNibName:@"SPAJ Add Menu" bundle:nil];
        viewController.delegateSPAJMain = self;
        
        modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
        modelSPAJSignature = [[ModelSPAJSignature alloc]init];
        modelSPAJIDCapture = [[ModelSPAJIDCapture alloc]init];
        formatter = [[Formatter alloc]init];
        
        //NSNOTIFICATION CENTER
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:)
                                                     name:@"GOTOSPAJ"
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
        UIStoryboard *spajStoryboard = [UIStoryboard storyboardWithName:@"SPAJEAppListStoryBoard" bundle:Nil];
        SPAJEApplicationList *viewController = [spajStoryboard instantiateViewControllerWithIdentifier:@"EAppListRootVC"];
        //viewController.delegateSPAJEappList = self;
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
        //[self actionGoToEApplicationList:nil];
    };

    //NOTIFICATION RECEIVE
    - (void)receiveNotification:(NSNotification *)notification
    {
        if ([[notification name] isEqualToString:@"GOTOSPAJ"]) {
            //doSomething here.
            [self actionGoToExistingList:nil];
        }
    }


    // ACTION

    - (IBAction)actionGoToEApplicationList:(id)sender
    {
        /*SPAJEApplicationList* viewController = [[SPAJEApplicationList alloc] initWithNibName:@"SPAJ E Application List" bundle:nil];
        viewController.view.frame = self.viewContent.bounds;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];*/
        UIStoryboard *spajStoryboard = [UIStoryboard storyboardWithName:@"SPAJEAppListStoryBoard" bundle:Nil];
        SPAJEApplicationList *viewController = [spajStoryboard instantiateViewControllerWithIdentifier:@"EAppListRootVC"];
        viewController.view.frame = self.viewContent.bounds;
        //viewController.delegateSPAJEappList = self;
        [self addChildViewController:viewController];
        [self.viewContent addSubview:viewController.view];
        //viewController.modalPresentationStyle = UIModalPresentationFullScreen;*/
        //viewController.IndexTab = 1;
        //[self presentViewController:viewController animated:NO completion:Nil];
        //viewController = Nil;
        //AppDelegate *appdlg = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        //appdlg.eApp=NO;
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
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"CarouselStoryboard" bundle:Nil];
        
        CarouselViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"carouselView"];
        [self presentViewController:viewController animated:NO completion:Nil];
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