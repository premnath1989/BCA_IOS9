//
//  SIUnitLinkedFundAllocationViewController.m
//  BLESS
//
//  Created by Basvi on 11/8/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUnitLinkedFundAllocationViewController.h"
#import "ModelSIULFundAllocation.h"
#import "Alert.h"

@interface SIUnitLinkedFundAllocationViewController (){
    ModelSIULFundAllocation* modelSIULFundAllocation;
    Alert* alert;
    NSMutableDictionary* dictPremiData;
}

@end

@implementation SIUnitLinkedFundAllocationViewController
@synthesize delegate;

-(void)viewDidAppear:(BOOL)animated{
    [self loadDataFromList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    modelSIULFundAllocation = [[ModelSIULFundAllocation alloc]init];
    alert = [[Alert alloc]init];
    
    //[textFixedIncome addTarget:self action:@selector(FundAllocationEditingEnd:) forControlEvents:UIControlEventEditingDidEnd];
    //[textEquityIncome addTarget:self action:@selector(FundAllocationEditingEnd:) forControlEvents:UIControlEventEditingDidEnd];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Load from listing added by faiz
-(void)loadDataFromList{
    NSDictionary* dictFundAllocationData=[[NSDictionary alloc]init];
    dictFundAllocationData = [delegate getULFundAllocationDictionary];
    if ([dictFundAllocationData count]!=0){
        if ([[dictFundAllocationData valueForKey:@"USDFixedIncomeFund"] isEqualToString:@""]){
            [textFixedIncome setText:[dictFundAllocationData valueForKey:@"IDRFixedIncomeFund"]];
            [textEquityIncome setText:[dictFundAllocationData valueForKey:@"IDREquityIncomeFund"]];
        }
        else{
            [textFixedIncome setText:[dictFundAllocationData valueForKey:@"USDFixedIncomeFund"]];
            [textEquityIncome setText:[dictFundAllocationData valueForKey:@"USDEquityIncomeFund"]];
        }
        
        [self calculateTotalIncome];
    }
    else{
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if ((textField == textFixedIncome)||(textField == textEquityIncome ))
    {
        //KY - IMPORTANT - PUT THIS LINE TO DETECT THE FIRST CHARACTER PRESSED....
        //This method is being called before the content of textField.text is changed.
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return (([string isEqualToString:filtered])&&(newLength <= 3));
        
    }
    return YES;
}

-(void)FundAllocationEditingEnd:(UITextField *)sender{
    [self calculateTotalIncome];
}

-(void)calculateTotalIncome{
    int fixedIncome = [textFixedIncome.text intValue];
    int equityIncome = [textEquityIncome.text intValue];
    
    int totalIncome = fixedIncome + equityIncome;
    [textTotalIncome setText:[NSString stringWithFormat:@"%i",totalIncome]];
    if (totalIncome!=100){
        NSString *stringAlertMaxFundAllocation = [NSString stringWithFormat:@"Alokasi dana harus sama dengan 100%%"];
        UIAlertController *alertMaxFundAllocation = [alert alertInformation:@"Peringatan" stringMessage:stringAlertMaxFundAllocation];
        [self presentViewController:alertMaxFundAllocation animated:YES completion:nil];
    }
}

#pragma mark dictionary maker
-(void)setULFundAllocationDictionary{
    dictPremiData = [[NSMutableDictionary alloc]initWithDictionary:[delegate getBasicPlanDictionary]];

    NSMutableDictionary* dictFundAllocationData = [[NSMutableDictionary alloc]init];
    [dictFundAllocationData setObject:[delegate getRunnigSINumber] forKey:@"SINO"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaProteksiNusantara"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaEkuitasNusantara"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaObligasiNusantara"];
    [dictFundAllocationData setObject:@"" forKey:@"BNPParibasCashInvestFund"];
    [dictFundAllocationData setObject:@"" forKey:@"DanaProgresifNusantara"];
    
    if ([[dictPremiData valueForKey:@"PaymentCurrency"] isEqualToString:@"USD"]){
        [dictFundAllocationData setObject:@"" forKey:@"IDRFixedIncomeFund"];
        [dictFundAllocationData setObject:@"" forKey:@"IDREquityIncomeFund"];
        [dictFundAllocationData setObject:textFixedIncome.text forKey:@"USDFixedIncomeFund"];
        [dictFundAllocationData setObject:textEquityIncome.text forKey:@"USDEquityIncomeFund"];
    }
    else{
        [dictFundAllocationData setObject:textFixedIncome.text forKey:@"IDRFixedIncomeFund"];
        [dictFundAllocationData setObject:textEquityIncome.text forKey:@"IDREquityIncomeFund"];
        [dictFundAllocationData setObject:@"" forKey:@"USDFixedIncomeFund"];
        [dictFundAllocationData setObject:@"" forKey:@"USDEquityIncomeFund"];
    }
    
    [delegate setULFundAllocationDictionary:dictFundAllocationData];
}

#pragma mark validation
-(BOOL)validateSave{
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    int fixedIncome = [textFixedIncome.text intValue];
    int equityIncome = [textEquityIncome.text intValue];
    
    int totalIncome = fixedIncome + equityIncome;
    [textTotalIncome setText:[NSString stringWithFormat:@"%i",totalIncome]];
    //if (totalIncome>100){
        if (totalIncome!=100){
            NSString *stringAlertMaxFundAllocation = [NSString stringWithFormat:@"Alokasi dana harus sama dengan 100%%"];
            UIAlertController *alertMaxFundAllocation = [alert alertInformation:@"Peringatan" stringMessage:stringAlertMaxFundAllocation];
            [self presentViewController:alertMaxFundAllocation animated:YES completion:nil];
            return false;
        }
    
    //}
    
    return true;
}


#pragma mark saveData
-(IBAction)actionSaveData:(UIBarButtonItem *)sender{
    if ([self validateSave]){
        //set the updated data to parent
        [self setULFundAllocationDictionary];
        
        //get updated data from parent and save it.
        [modelSIULFundAllocation saveULFundAllocationData:[delegate getULFundAllocationDictionary]];
        
        //go to next page
        [delegate showUnitLinkModuleAtIndex:[NSIndexPath indexPathForRow:4 inSection:0]];
    }
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
