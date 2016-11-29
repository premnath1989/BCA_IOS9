//
//  SIUnitLinkedBasicPlanViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedBasicPlanViewController.h"
#import "UnitLinkedPopOverViewController.h"
#import "ModelSIULBasicPlan.h"
#import "Formatter.h"
#import "SingleUnitLinkedCalculation.h"

@interface SIUnitLinkedBasicPlanViewController ()<UIPopoverPresentationControllerDelegate,UnitLinkedPopOverDelegate,UITextFieldDelegate>{
    Formatter* formatter;
    UnitLinkedPopOverViewController* unitLinkedPopOverVC;
    SingleUnitLinkedCalculation* singleUnitLinkedCalculation;
    UIPopoverPresentationController *popController;
    
    ModelSIULBasicPlan *modelSIULBasicPlan;
    
    NSString* paymentCurrency;
}

@end

@implementation SIUnitLinkedBasicPlanViewController
@synthesize delegate;

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    formatter = [[Formatter alloc]init];
    singleUnitLinkedCalculation = [[SingleUnitLinkedCalculation alloc]init];
    
    unitLinkedPopOverVC = [[UnitLinkedPopOverViewController alloc]initWithNibName:@"UnitLinkedPopOverViewController" bundle:nil];
    unitLinkedPopOverVC.UnitLinkedPopOverDelegate = self;
    
    modelSIULBasicPlan = [[ModelSIULBasicPlan alloc]init];
    
    [textBasicPremiField setDelegate:self];
    [textSumAssuredField setDelegate:self];
    
    [textBasicPremiField addTarget:self action:@selector(RealTimeFormat:) forControlEvents:UIControlEventEditingChanged];
    [textBasicPremiField addTarget:self action:@selector(BasicPremiEditingEnd:) forControlEvents:UIControlEventEditingDidEnd];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Data Load from listing added by faiz
-(void)loadDataFromList{
    NSDictionary* dictPremiData=[[NSDictionary alloc]init];
    dictPremiData = [delegate getBasicPlanDictionary];
    if ([dictPremiData count]!=0){
        [textBasicPremiField setText:[dictPremiData valueForKey:@"Premium"]];
        [textSumAssuredField setText:[dictPremiData valueForKey:@"SumAssured"]];
        [textExtraPremiPercentField setText:[dictPremiData valueForKey:@"ExtraPremiumPercentage"]];
        [textExtraPremiNumberField setText:[dictPremiData valueForKey:@"ExtraPremiumMil"]];
        [textMasaExtraPremiField setText:[dictPremiData valueForKey:@"ExtraPremiumTerm"]];
        
        [buttonMasaPembayaran setTitle:[dictPremiData valueForKey:@"Payment_Term"] forState:UIControlStateNormal];
        [buttonFrekuensiPembayaran setTitle:[dictPremiData valueForKey:@"Payment_Frequency"] forState:UIControlStateNormal];
        
        paymentCurrency = [dictPremiData valueForKey:@"PaymentCurrency"];
        if ([paymentCurrency isEqualToString:@"IDR"]){
            [segmentCurrency setSelectedSegmentIndex:0];
        }
        else{
            [segmentCurrency setSelectedSegmentIndex:1];
        }
    }
    else{
        [buttonMasaPembayaran setTitle:@"Premi Tunggal" forState:UIControlStateNormal];
        [buttonFrekuensiPembayaran setTitle:@"Pembayaran Sekaligus" forState:UIControlStateNormal];
    }
    //FRekeunsiPembayaranMode
    //BasisSumAssured
    //discountPembelian
    //PembelianKEString
}

-(IBAction)actionTargetAccountValue:(UIButton *)sender{
    NSMutableArray* arrayTableDesc = [[NSMutableArray alloc]initWithObjects:@"Pension Fund",@"Equal To SA", nil];
    NSMutableArray* arrayTableCode = [[NSMutableArray alloc]initWithObjects:@"PF",@"ESA", nil];
    
    NSDictionary* dictTablePopOver = [[NSDictionary alloc]initWithObjectsAndKeys:arrayTableDesc,@"TableDesc",arrayTableCode,@"TableCode", nil];
    [unitLinkedPopOverVC setTablData:dictTablePopOver Title:@"Target Account Value"];
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    unitLinkedPopOverVC.modalPresentationStyle = UIModalPresentationPopover;
    unitLinkedPopOverVC.preferredContentSize = CGSizeMake(350, 300);
    
    popController = [unitLinkedPopOverVC popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.sourceView = sender;
    popController.sourceRect = sender.bounds;
    popController.delegate = self;
    [self presentViewController:unitLinkedPopOverVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark dictionary maker
-(void)setULBasicPlanDictionary{
    NSMutableDictionary* dictULBasicPlanData = [[NSMutableDictionary alloc]init];
    [dictULBasicPlanData setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
    [dictULBasicPlanData setObject:@"" forKey:@"PaymentMode"];
    [dictULBasicPlanData setObject:@"" forKey:@"PreferredPremium"];
    [dictULBasicPlanData setObject:@"" forKey:@"RegularTopUp"];
    [dictULBasicPlanData setObject:textBasicPremiField.text forKey:@"Premium"];
    [dictULBasicPlanData setObject:textSumAssuredField.text forKey:@"SumAssured"];
    [dictULBasicPlanData setObject:@"" forKey:@"PremiumHolidayTerm"];
    [dictULBasicPlanData setObject:@"" forKey:@"TotalUnAppliedPremium"];
    [dictULBasicPlanData setObject:@"" forKey:@"TargetValue"];
    [dictULBasicPlanData setObject:textExtraPremiPercentField.text forKey:@"ExtraPremiumPercentage"];
    [dictULBasicPlanData setObject:textExtraPremiNumberField.text forKey:@"ExtraPremiumMil"];
    [dictULBasicPlanData setObject:textMasaExtraPremiField.text forKey:@"ExtraPremiumTerm"];
    [dictULBasicPlanData setObject:buttonMasaPembayaran.currentTitle forKey:@"Payment_Term"];
    [dictULBasicPlanData setObject:buttonFrekuensiPembayaran.currentTitle forKey:@"Payment_Frequency"];
    [dictULBasicPlanData setObject:[segmentCurrency titleForSegmentAtIndex:segmentCurrency.selectedSegmentIndex] forKey:@"PaymentCurrency"];
    
    [delegate setBasicPlanDictionary:dictULBasicPlanData];
}

-(void)RealTimeFormat:(UITextField *)sender{
    NSNumber *plainNumber = [formatter convertAnyNonDecimalNumberToString:sender.text];
    [sender setText:[formatter numberToCurrencyDecimalFormatted:plainNumber]];
}

-(void)BasicPremiEditingEnd:(UITextField *)sender{
    double basicPremi = [[formatter convertNumberFromStringCurrency:textBasicPremiField.text] doubleValue];
    double sumAssured = [singleUnitLinkedCalculation calculateSumAssured:basicPremi];
    
    [textSumAssuredField setText:[formatter numberToCurrencyDecimalFormatted:[NSNumber numberWithDouble:sumAssured]]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == textBasicPremiField)
    {
        BOOL return13digit = FALSE;
        //KY - IMPORTANT - PUT THIS LINE TO DETECT THE FIRST CHARACTER PRESSED....
        //This method is being called before the content of textField.text is changed.
        NSString * AI = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([AI rangeOfString:@"."].length == 1) {
            NSArray  *comp = [AI componentsSeparatedByString:@"."];
            NSString *get_num = [[comp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""];
            int c = [get_num length];
            return13digit = (c > 15);
            
        } else if([AI rangeOfString:@"."].length == 0) {
            NSArray  *comp = [AI componentsSeparatedByString:@"."];
            NSString *get_num = [[comp objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""];
            int c = [get_num length];
            return13digit = (c  > 15);
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if( return13digit == TRUE) {
            return (([string isEqualToString:filtered])&&(newLength <= 15));
        } else {
            return (([string isEqualToString:filtered])&&(newLength <= 19));
        }
    }
    return YES;
}

#pragma mark saveData
-(IBAction)actionSaveData:(UIBarButtonItem *)sender{
    //set the updated data to parent
    [self setULBasicPlanDictionary];
    
    //get updated data from parent and save it.
    [modelSIULBasicPlan saveULBasicPlanData:[delegate getBasicPlanDictionary]];

    //change to next page
    [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:3 inSection:0]];
}

#pragma mark delegate
/*-(void)TableData:(NSString *)stringDesc TableCode:(NSString *)stringCode{
    [buttonTargetAccountValue setTitle:stringDesc forState:UIControlStateNormal];
    [[popController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
