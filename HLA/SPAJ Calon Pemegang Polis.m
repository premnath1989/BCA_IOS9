//
//  SPAJ Calon Pemegang Polis.m
//  BLESS
//
//  Created by Basvi on 8/3/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SPAJ Calon Pemegang Polis.h"
@interface SPAJ_Calon_Pemegang_Polis ()

@end

@implementation SPAJ_Calon_Pemegang_Polis{
    UIAlertController *alertController;
    
    NSString *stringSection;
    NSString *htmlSection;
    
    NSArray* newElementArrayName;
    NSArray* originalElementArrayName;
    
    NSArray* newElementArrayTertanggungName;
    NSArray* originalElementArrayTertanggungName;
}
@synthesize htmlFileName;
@synthesize delegate;
@synthesize dictTransaction;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)voidCreateAlertTwoOptionViewAndShow:(NSString *)message tag:(int)alertTag{
    alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)loadFirstHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection{
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    
    stringSection = stringPageSection;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
    /* NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    if ([allAboutPDFGeneration doesString:stringFlagEdited containCharacter:@"true"]){
        NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
        alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            stringSection = stringPageSection;
            [webview loadRequest:urlRequest];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else{
        stringSection = stringPageSection;
        [webview loadRequest:urlRequest];
    }*/
}


-(void)loadSecondHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection{
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    
    stringSection = stringPageSection;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
    /*NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    if ([allAboutPDFGeneration doesString:stringFlagEdited containCharacter:@"true"]){
        NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
        alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            stringSection = stringPageSection;
            [webview loadRequest:urlRequest];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else{
        stringSection = stringPageSection;
        [webview loadRequest:urlRequest];
    }*/
}

-(void)loadThirdHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection{
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    
    stringSection = stringPageSection;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
    /*NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    if ([allAboutPDFGeneration doesString:stringFlagEdited containCharacter:@"true"]){
        NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
        alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            stringSection = stringPageSection;
            [webview loadRequest:urlRequest];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else{
        stringSection = stringPageSection;
        [webview loadRequest:urlRequest];
    }*/
}

-(void)loadFourthHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection{
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    
    stringSection = stringPageSection;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
    /*NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    if ([allAboutPDFGeneration doesString:stringFlagEdited containCharacter:@"true"]){
        NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
        alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            stringSection = stringPageSection;
            [webview loadRequest:urlRequest];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else{
        stringSection = stringPageSection;
        [webview loadRequest:urlRequest];
    }*/
}

-(void)loadFivethHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection{
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    
    stringSection = stringPageSection;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
    /*NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    if ([allAboutPDFGeneration doesString:stringFlagEdited containCharacter:@"true"]){
        NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
        alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            stringSection = stringPageSection;
            [webview loadRequest:urlRequest];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else{
        stringSection = stringPageSection;
        [webview loadRequest:urlRequest];
    }*/
}

-(void)loadSixthHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection{
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    
    stringSection = stringPageSection;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
    /*NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    if ([allAboutPDFGeneration doesString:stringFlagEdited containCharacter:@"true"]){
        NSString* message=@"Telah terjadi perubahan data. Yakin ingin melanjutkan tanpa menyimpan data ?";
        alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            stringSection = stringPageSection;
            [webview loadRequest:urlRequest];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    else{
        stringSection = stringPageSection;
        [webview loadRequest:urlRequest];
    }*/
}

-(void)loadSeventhHTML:(NSString*)stringHTMLName PageSection:(NSString *)stringPageSection{
    NSString* stringFlagEdited = [webview stringByEvaluatingJavaScriptFromString:@"booleanInputChangeState;"];
    
    stringSection = stringPageSection;
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    filePath = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    
    NSString *htmlfilePath = [NSString stringWithFormat:@"SPAJ/%@",stringHTMLName];
    NSString *localURL = [[NSString alloc] initWithString:
                          [docsDir stringByAppendingPathComponent: htmlfilePath]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:localURL]];
    [webview loadRequest:urlRequest];
}

- (void)viewDidLoad {
    modelOccupation = [[ModelOccupation alloc]init];
    modelProspectProfile = [[ModelProspectProfile alloc]init];
    modelSPAJTransaction = [[ModelSPAJTransaction alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    modelSPAJAnswers = [[ModelSPAJAnswers alloc]init];
    modelSIPData = [[ModelSIPOData alloc]init];
    modelIdentificationType = [[ModelIdentificationType alloc]init];
    modelSIPremium = [[Model_SI_Premium alloc]init];
    formatter = [[Formatter alloc]init];
    allAboutPDFGeneration = [[AllAboutPDFGeneration alloc]init];
    
    [self initialArrayPolicyData];
    [self initialArrayTertanggungData];
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //define the webview coordinate
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(5, 0, 745,708)];
    webview.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view.superview bringSubviewToFront:viewActivityIndicator];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialArrayPolicyData{
    newElementArrayName = [[NSArray alloc]initWithObjects:
                           @"TextPolicyHolderFullName",
                           @"DatePolicyHolderBirth",
                           @"RadioButtonPolicyHolderSex",
                           @"TextPolicyHolderHomeAddress1",
                           @"TextPolicyHolderHomeAddress2",
                           @"TextPolicyHolderHomeAddress3",
                           @"TextPolicyHolderHomeCity",
                           @"TextPolicyHolderHomePostalCode",
                           @"TextPolicyHolderOfficeAddress1",
                           @"TextPolicyHolderOfficeAddress2",
                           @"TextPolicyHolderOfficeAddress3",
                           @"TextPolicyHolderOfficeCity",
                           @"TextPolicyHolderOfficePostalCode",
                           @"TextPolicyHolderEmail",
                           @"TextPolicyHolderMainJob",
                           @"RadioButtonPolicyHolderIDType",
                           @"TextPolicyHolderIDNumber",
                           @"RadioButtonPolicyHolderReligion",
                           @"RadioButtonPolicyHolderNationality",
                           @"TextPolicyHolderBirthPlace",
                           @"DatePolicyHolderActive",
                           @"TextPolicyHolderNPWP",
                           @"TextPolicyHolderHomeTelephone",
                           @"TextPolicyHolderHandphone1",
                           @"TextPolicyHolderHandphone2",
                           @"TextPolicyHolderOfficeTelephone",
                           @"TextPolicyHolderAge"
                           , nil];
    
    originalElementArrayName= [[NSArray alloc]initWithObjects:
                               @"ProspectName",
                               @"ProspectDOB",
                               @"ProspectGender",
                               @"ResidenceAddress1",
                               @"ResidenceAddress2",
                               @"ResidenceAddress3",
                               @"ResidenceAddressTown",
                               @"ResidenceAddressPostCode",
                               @"OfficeAddress1",
                               @"OfficeAddress2",
                               @"OfficeAddress3",
                               @"OfficeAddressTown",
                               @"OfficeAddressPostCode",
                               @"ProspectEmail",
                               @"ProspectOccupationCode",
                               @"OtherIDType",
                               @"OtherIDTypeNo",
                               @"Religion",
                               @"Nationality",
                               @"CountryOfBirth",
                               @"IDExpiryDate",
                               @"NPWPNo",
                               @"CONT006",
                               @"CONT008",
                               @"CONT007",
                               @"CONT009",
                               @"Age"
                               , nil];

};

-(void)initialArrayTertanggungData{
    newElementArrayTertanggungName = [[NSArray alloc]initWithObjects:
                           @"TextProspectiveInsuredFullName",
                           @"DateProspectiveInsuredBirth",
                           @"RadioButtonProspectiveInsuredSex",
                           @"TextProspectiveInsuredHomeAddress1",
                           @"TextProspectiveInsuredHomeAddress2",
                           @"TextProspectiveInsuredHomeAddress3",
                           @"TextProspectiveInsuredHomeCity",
                           @"TextProspectiveInsuredHomePostalCode",
                           @"TextProspectiveInsuredOfficeAddress1",
                           @"TextProspectiveInsuredOfficeAddress2",
                           @"TextProspectiveInsuredOfficeAddress3",
                           @"TextProspectiveInsuredOfficeCity",
                           @"TextProspectiveInsuredOfficePostalCode",
                           @"TextProspectiveInsuredEmail",
                           @"TextProspectiveInsuredMainJob",
                           @"RadioButtonProspectiveInsuredIDType",
                           @"TextProspectiveInsuredIDNumber",
                           @"RadioButtonProspectiveInsuredReligion",
                           @"RadioButtonProspectiveInsuredNationality",
                           @"TextProspectiveInsuredBirthPlace",
                           @"DateProspectiveInsuredActive",
                           @"TextProspectiveInsuredNPWP",
                           @"TextProspectiveInsuredHomeTelephone",
                           @"TextProspectiveInsuredHandphone1",
                           @"TextProspectiveInsuredHandphone2",
                           @"TextProspectiveInsuredOfficeTelephone",
                           @"TextProspectiveInsuredAge",
                            nil];
    
    originalElementArrayTertanggungName= [[NSArray alloc]initWithObjects:
                               @"ProspectName",
                               @"ProspectDOB",
                               @"ProspectGender",
                               @"ResidenceAddress1",
                               @"ResidenceAddress2",
                               @"ResidenceAddress3",
                               @"ResidenceAddressTown",
                               @"ResidenceAddressPostCode",
                               @"OfficeAddress1",
                               @"OfficeAddress2",
                               @"OfficeAddress3",
                               @"OfficeAddressTown",
                               @"OfficeAddressPostCode",
                               @"ProspectEmail",
                               @"ProspectOccupationCode",
                               @"OtherIDType",
                               @"OtherIDTypeNo",
                               @"Religion",
                               @"Nationality",
                               @"CountryOfBirth",
                               @"IDExpiryDate",
                               @"NPWPNo",
                               @"CONT006",
                               @"CONT008",
                               @"CONT007",
                               @"CONT009",
                               @"Age",
                                nil];
    
};

- (void)showFormThirdParty:(NSDictionary *)params{
    spajThirdPartyViewController = [[SPAJThirdParty alloc]initWithNibName:@"SPAJThirdParty" bundle:nil];
    //[spajFilesViewController setDelegateSPAJFiles:self];
    [spajThirdPartyViewController setDictTransaction:dictTransaction];
    spajThirdPartyViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:spajThirdPartyViewController animated:YES completion:nil];
}

#pragma mark call save function in HTML
-(void)voidDoneSPAJCalonPemegangPolis{
    //[webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('save').click()"]];
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"savetoDB();"]];
}

- (void)voidReadAreaPotential{
    //[webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById('read').click()"]];
}

- (void)showAlert:(NSDictionary *)params{
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    NSString *title = [modifiedParams valueForKey:@"title"];
    NSString *body = [modifiedParams valueForKey:@"body"];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:body delegate:self cancelButtonTitle:@"OK"otherButtonTitles: nil];
    [alert show];
    
    
}

- (void)savetoDB:(NSDictionary *)params{
    [delegate setRightButtonEnable:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([stringSection isEqualToString:@"PM"]){
            NSString *stringWhere = [NSString stringWithFormat:@"where SPAJHtmlSection='PM' and SPAJTransactionID=%i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
            [modelSPAJAnswers deleteSPAJAnswers:stringWhere];
        }
        
        else if ([stringSection isEqualToString:@"KS_PH"]){
            NSString *stringWhere = [NSString stringWithFormat:@"where SPAJHtmlSection='KS_PH' and SPAJTransactionID=%i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
            [modelSPAJAnswers deleteSPAJAnswers:stringWhere];
        }
        
        else if ([stringSection isEqualToString:@"KS_TR"]){
            NSString *stringWhere = [NSString stringWithFormat:@"where SPAJHtmlSection='KS_TR' and SPAJTransactionID=%i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
            [modelSPAJAnswers deleteSPAJAnswers:stringWhere];
        }
        
        else if ([stringSection isEqualToString:@"KS_IN"]){
            NSString *stringWhere = [NSString stringWithFormat:@"where SPAJHtmlSection='KS_IN' and SPAJTransactionID=%i",[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]];
            [modelSPAJAnswers deleteSPAJAnswers:stringWhere];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            //add another key to db
            NSString*spajTransactionID = [modelSPAJTransaction getSPAJTransactionData:@"SPAJTransactionID" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
            //cffID = [cffHeaderSelectedDictionary valueForKey:@"PotentialDiscussionCFFID"];
            NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
            [modifiedParams setObject:[[modelSPAJHtml selectActiveHtmlForSection:stringSection] valueForKey:@"SPAJHtmlID"] forKey:@"SPAJHtmlID"];
            [modifiedParams setObject:spajTransactionID forKey:@"SPAJTransactionID"];
            //[modifiedParams setObject:cffID forKey:@"SPAJID"];
            //[modifiedParams setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
            
            NSMutableArray* arraySPAJAnswers = [[NSMutableArray alloc]initWithArray:[modifiedParams valueForKey:@"SPAJAnswers"]];
            NSMutableArray* modifiedArrayCFFAnswers = [[NSMutableArray alloc]init];
            if ([arraySPAJAnswers count]>0){
                for (int i = 0;i<[arraySPAJAnswers count];i++){
                    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[arraySPAJAnswers objectAtIndex:i]];
                    [tempDict setObject:[[modelSPAJHtml selectActiveHtmlForSection:stringSection] valueForKey:@"SPAJHtmlID"] forKey:@"SPAJHtmlID"];
                    [tempDict setObject:spajTransactionID forKey:@"SPAJTransactionID"];
                    //[tempDict setObject:cffID forKey:@"SPAJID"];
                    //[tempDict setObject:[prospectProfileID stringValue] forKey:@"CustomerID"];
                    [tempDict setObject:stringSection forKey:@"SPAJHtmlSection"];
                    int indexNo = [modelSPAJAnswers voidGetDuplicateRowID:tempDict];
                    
                    if (indexNo>0){
                        [tempDict setObject:[NSNumber numberWithInt:indexNo] forKey:@"IndexNo"];
                    }
                    [modifiedArrayCFFAnswers addObject:tempDict];
                }
            }
            
            NSMutableDictionary* finalArrayDictionary = [[NSMutableDictionary alloc]init];
            [finalArrayDictionary setObject:modifiedArrayCFFAnswers forKey:@"SPAJAnswers"];
            
            NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
            [finalDictionary setObject:finalArrayDictionary forKey:@"data"];
            
            [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
            [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
            [super savetoDB:finalDictionary];
            [delegate voidSetCalonPemegangPolisBoolValidate:true StringSection:stringSection];
        });
    });
}

- (NSMutableDictionary*)readfromDB:(NSMutableDictionary*) params{
    NSString *SPAJTransactionID = [modelSPAJTransaction getSPAJTransactionData:@"SPAJTransactionID" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    NSMutableDictionary* modifiedParams = [[NSMutableDictionary alloc]initWithDictionary:[params valueForKey:@"data"]];
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithDictionary:[modifiedParams valueForKey:@"SPAJAnswers"]];
    NSString* stringWhere = [NSString stringWithFormat:@"where CustomerID=%@ and SPAJID=%@ and SPAJTransactionID=%@ and SPAJHtmlSection='%@'",@"1",@"1",SPAJTransactionID,stringSection];
    //NSString* stringWhere = [NSString stringWithFormat:@"where CustomerID=%@ and SPAJID=%@ and SPAJTransactionID=%@",@"1",@"1",SPAJTransactionID];
    [tempDict setObject:stringWhere forKey:@"where"];
    
    NSMutableDictionary* answerDictionary = [[NSMutableDictionary alloc]init];
    [answerDictionary setObject:tempDict forKey:@"SPAJAnswers"];
    
    NSMutableDictionary* finalDictionary = [[NSMutableDictionary alloc]init];
    [finalDictionary setObject:answerDictionary forKey:@"data"];
    [finalDictionary setValue:[params valueForKey:@"successCallBack"] forKey:@"successCallBack"];
    [finalDictionary setValue:[params valueForKey:@"errorCallback"] forKey:@"errorCallback"];
    [super readfromDB:finalDictionary];
    [viewActivityIndicator setHidden:YES];
    return finalDictionary;
}

-(NSString *)getPOIndexNumber{
    NSString *SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPData getPO_DataFor:SINO]];
    NSString *stringPOClientID;
    if ([stringSection isEqualToString:@"PO"]){
        stringPOClientID = [dictPOData valueForKey:@"PO_ClientID"];
    }
    else{
        stringPOClientID = [dictPOData valueForKey:@"LA_ClientID"];
    }
    
    return stringPOClientID;
}

-(NSDictionary *)OriginalDictionaryForAutoPopulate{
    NSMutableArray* columnNames = [[NSMutableArray alloc]initWithArray:[modelProspectProfile getColumnNames:@"prospect_profile"]];
    NSMutableArray* columnValue = [[NSMutableArray alloc]initWithArray:[modelProspectProfile getColumnValue:[self getPOIndexNumber] ColumnCount:[columnNames count]]];
    
    //create dictionary
    NSMutableDictionary* dictDetail = [[NSMutableDictionary alloc]init];
    for (int i=0;i<[columnNames count];i++){
        [dictDetail setObject:[columnValue objectAtIndex:i] forKey:[columnNames objectAtIndex:i]];
    }
    return dictDetail;
}

-(NSMutableDictionary *)ModifiedDictionary:(NSDictionary *)originalDictionary OriginalElementName:(NSString *)stringOriginalElementName NewElementName:(NSString *)stringNewElementName{
      NSMutableDictionary *modiFiedDictionary = [[NSMutableDictionary alloc]init];
        NSString* prospectID = [NSString stringWithFormat:@"%@",[originalDictionary valueForKey:@"IndexNo"]];
        if ([stringOriginalElementName isEqualToString:@"ProspectOccupationCode"]){
            NSString* occupationDesc = [modelOccupation getOccupationDesc:[originalDictionary valueForKey:stringOriginalElementName]]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:occupationDesc forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"OtherIDType"]){
            NSString* identityDesc = [modelIdentificationType getOtherTypeDesc:[originalDictionary valueForKey:stringOriginalElementName]]?:@"";
            NSString* stringIdtype = [formatter getIDNameForHtml:identityDesc]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringIdtype forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"CONT006"]){
            NSString* stringTelp = [modelProspectProfile getDataMobileAndPrefix:stringOriginalElementName IndexNo:prospectID]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringTelp forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"CONT008"]){
           NSString* stringTelp = [modelProspectProfile getDataMobileAndPrefix:stringOriginalElementName IndexNo:prospectID ]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringTelp forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"CONT007"]){
            NSString* stringTelp = [modelProspectProfile getDataMobileAndPrefix:stringOriginalElementName IndexNo:prospectID ]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringTelp forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"CONT009"]){
            NSString* stringTelp = [modelProspectProfile getDataMobileAndPrefix:stringOriginalElementName IndexNo:prospectID]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringTelp forKey:@"Value"];
            return modiFiedDictionary;
        }
    
    
        else if ([stringOriginalElementName isEqualToString:@"ProspectGender"]){
            NSString* stringGender = [formatter getGenderNameForHtml:[originalDictionary valueForKey:stringOriginalElementName]]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringGender forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"Age"]){
            int personAge = [formatter calculateAge:[originalDictionary valueForKey:@"ProspectDOB"]];
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:[NSNumber numberWithInt:personAge] forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"Nationality"]){
            NSString* stringNationality = [formatter getNationalityNameForHtml:[originalDictionary valueForKey:stringOriginalElementName]]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringNationality forKey:@"Value"];
            return modiFiedDictionary;
        }
        else if ([stringOriginalElementName isEqualToString:@"Religion"]){
            NSString* stringReligion = [formatter getReligionNameForHtml:[originalDictionary valueForKey:stringOriginalElementName]]?:@"";
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:stringReligion forKey:@"Value"];
            return modiFiedDictionary;
        }
    
        else{
            [modiFiedDictionary setObject:stringNewElementName forKey:@"elementID"];
            [modiFiedDictionary setObject:[originalDictionary valueForKey:stringOriginalElementName] forKey:@"Value"];
            return modiFiedDictionary;
        }
}

-(NSDictionary *)dictForAutoPopulate{
    NSString *SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPData getPO_DataFor:SINO]];
    NSDictionary* dictPremiData=[[NSDictionary alloc]initWithDictionary:[modelSIPremium getPremium_For:SINO]];
    NSMutableArray* arrayValue = [[NSMutableArray alloc] init];
    if ([stringSection isEqualToString:@"PO"]){
        for (int i=0;i<[newElementArrayName count];i++){
            NSLog(@"indexpop %i",i);
            NSMutableDictionary* dictDetail = [[NSMutableDictionary alloc]initWithDictionary:[self ModifiedDictionary:[self OriginalDictionaryForAutoPopulate] OriginalElementName:[originalElementArrayName objectAtIndex:i] NewElementName:[newElementArrayName objectAtIndex:i]]];
            [arrayValue addObject:dictDetail];
        }
        
        NSString* stringRelation = [formatter getRelationNameForHtml:[dictPOData valueForKey:@"RelWithLA"]];
        NSMutableDictionary* dictRelWithLa = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"RadioButtonPolicyHolderRelationAssured",@"elementID",stringRelation,@"Value", nil];
        [arrayValue addObject:dictRelWithLa];
    }
    
    else if ([stringSection isEqualToString:@"TR"]){
        for (int i=0;i<[newElementArrayTertanggungName count];i++){
            NSMutableDictionary* dictDetail = [[NSMutableDictionary alloc]initWithDictionary:[self ModifiedDictionary:[self OriginalDictionaryForAutoPopulate] OriginalElementName:[originalElementArrayTertanggungName objectAtIndex:i] NewElementName:[newElementArrayTertanggungName objectAtIndex:i]]];
            [arrayValue addObject:dictDetail];
        }
        NSString* stringRelation = [formatter getRelationNameForHtml:[dictPOData valueForKey:@"RelWithLA"]];
        NSMutableDictionary* dictRelWithLa = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"RadioButtonProspectiveInsuredRelationAssured",@"elementID",stringRelation,@"Value", nil];
        [arrayValue addObject:dictRelWithLa];
    }
    else if ([stringSection isEqualToString:@"PP"]){
        NSString* stringPaymentFrequency = [formatter getPaymentFrequencyValue:[dictPremiData valueForKey:@"Payment_Frequency"]];
        NSMutableDictionary* dictRelWithLa = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"RadioButtonPremiPaymentFrequency",@"elementID",stringPaymentFrequency,@"Value", nil];
        
        NSMutableDictionary* dictCurrency = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"RadioButtonPremiPaymentKurs",@"elementID",@"idr",@"Value", nil];
        
        [arrayValue addObject:dictRelWithLa];
        [arrayValue addObject:dictCurrency];
        
        
    }
    /*else if (([stringSection isEqualToString:@"KS_PH"])||([stringSection isEqualToString:@"KS_TR"])){
        NSString* stringRelation = [formatter getRelationNameForHtml:[dictPOData valueForKey:@"RelWithLA"]];
        NSMutableDictionary* dictRelWithLa = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"RelationStatus",@"elementID",stringRelation,@"Value", nil];
        [arrayValue addObject:dictRelWithLa];
    }*/
    /*else if ([stringSection isEqualToString:@"PP"]){
        NSString* stringPaymentFrequency = [formatter getRelationNameForHtml:[dictPOData valueForKey:@"RelWithLA"]];
        NSMutableDictionary* dictRelWithLa = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"RadioButtonProspectiveInsuredRelationAssured",@"elementID",stringRelation,@"Value", nil];
        [arrayValue addObject:dictRelWithLa];
    }*/
    
    NSDictionary *readFromDB=[[NSDictionary alloc]initWithObjectsAndKeys:arrayValue,@"autopopulateFromDB", nil];
    NSDictionary *result=[[NSDictionary alloc]initWithObjectsAndKeys:readFromDB,@"result", nil];
    return result;
}

-(NSDictionary *)dictForAutoPopulateTertanggung{
    NSString *SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
    NSDictionary* dictLAData = [[NSDictionary alloc ]initWithDictionary:[modelSIPData getPO_DataFor:SINO]];
    
    NSMutableArray* arrayValue = [[NSMutableArray alloc] init];
    if ([stringSection isEqualToString:@"PO"]){
        for (int i=0;i<[newElementArrayName count];i++){
            NSMutableDictionary* dictDetail = [[NSMutableDictionary alloc]initWithDictionary:[self ModifiedDictionary:[self OriginalDictionaryForAutoPopulate] OriginalElementName:[originalElementArrayName objectAtIndex:i] NewElementName:[newElementArrayName objectAtIndex:i]]];
            [arrayValue addObject:dictDetail];
        }
    }
    else if ([stringSection isEqualToString:@"TR"]){
        for (int i=0;i<[newElementArrayTertanggungName count];i++){
            NSMutableDictionary* dictDetail = [[NSMutableDictionary alloc]initWithDictionary:[self ModifiedDictionary:[self OriginalDictionaryForAutoPopulate] OriginalElementName:[originalElementArrayTertanggungName objectAtIndex:i] NewElementName:[newElementArrayTertanggungName objectAtIndex:i]]];
            [arrayValue addObject:dictDetail];
        }
    }
    
    NSMutableDictionary* dictRelWithLa = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"RadioButtonPolicyHolderRelationAssured",@"elementID",[dictLAData valueForKey:@"RelWithLA"],@"Value", nil];
    
    [arrayValue addObject:dictRelWithLa];
    NSDictionary *readFromDB=[[NSDictionary alloc]initWithObjectsAndKeys:arrayValue,@"autopopulateFromDB", nil];
    NSDictionary *result=[[NSDictionary alloc]initWithObjectsAndKeys:readFromDB,@"result", nil];
    
    return result;
}

/*- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] hasPrefix:@"ios:"]) {
        
        // Call the given selector
        [self performSelector:@selector(showFormThirdParty)];
        // Cancel the location change
        return NO;
    }
    return YES;
    
}*/


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [viewActivityIndicator setHidden:NO];
    htmlSection = [webview stringByEvaluatingJavaScriptFromString:@"stringPageInfixTypeCurrent;"];
    
    if ([htmlSection isEqualToString:@"ProspectiveInsured"]){
        stringSection = @"KS_IN";
    }
    else if ([htmlSection isEqualToString:@"PolicyHolder"]){
        stringSection = @"KS_PH";
    }
    
    NSString *jsonString;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictForAutoPopulate]
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"AutoPopulate('%@');", jsonString]];
        NSLog(@"json string %@",jsonString);
    }
    
    if (([stringSection isEqualToString:@"KS_PH"])||([stringSection isEqualToString:@"KS_TR"])||([stringSection isEqualToString:@"KS_IN"])){
        NSString *SINO = [modelSPAJTransaction getSPAJTransactionData:@"SPAJSINO" StringWhereName:@"SPAJEappNumber" StringWhereValue:[delegate voidGetEAPPNumber]];
        NSDictionary* dictPOData = [[NSDictionary alloc ]initWithDictionary:[modelSIPData getPO_DataFor:SINO]];
        NSString* stringRelation = [formatter getRelationNameForHtml:[dictPOData valueForKey:@"RelWithLA"]];
        [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"CheckRelationshipStatus('%@');",stringRelation]];
    }
    
    [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"readfromDB();"]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
