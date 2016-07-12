//
//  CFFValidation.m
//  BLESS
//
//  Created by Basvi on 6/22/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CFFValidation.h"
#import "ModelProspectSpouse.h"
#import "ModelProspectChild.h"
#import "ModelIdentificationType.h"

NSString *validationNamaLengkap=@"Nama lengkap harus diisi";
NSString *validationJenisKelamin=@"Jenis Kelamin harus diisi";
NSString *validationTanggalLahir=@"Tanggal lahir harus diisi";

NSString *validationJenisIdentitas=@"Jenis identitas harus diisi";
NSString *validationNomorIdentitas=@"Nomor identitas harus diisi";
NSString *validationTanggalKadaluarsaIdentitas=@"Tanggal kadaluarsa identitas harus diisi";
NSString *validationMerokok=@"Merokok harus diisi";
NSString *validationKebangsaan=@"Kewarganegaraan harus diisi";
NSString *validationHubungan=@"Hubungan harus diisi";
NSString *validationPekerjaan=@"Pekerjaan harus diisi";
NSString *validationPendapatanTahunan=@"Pendapatan tahunan harus diisi";
NSString *validationSumberPenghasilan=@"Sumber penghasilan harus diisi";
NSString *validationTahunAsuransi=@"Jumlah tahun ditanggung harus diisi";
NSString *validationID=@"Data identitas sudah ada. Silahkan gunakan data indetitas lain";

@implementation CFFValidation{
    ModelProspectSpouse* modelProspectSpouse;
    ModelProspectChild* modelProspectChild;
    ModelIdentificationType* modelIdentificationType;
}
@synthesize prospectProfileID,cffTransactionID;

- (void)createAlertViewAndShow:(NSString *)message tag:(int)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                    message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag = alertTag;
    [alert show];
}

-(bool)validateOtherIDNumber:(UIButton *)buttonOtherIDType TextIDNumber:(UITextField *)textIDNumber IDNasabah:(NSString *)idNasabah IDTypeCodeSelected:(NSString *)idTypeCodeSelected{
    modelIdentificationType = [[ModelIdentificationType alloc]init];
    if (([buttonOtherIDType.currentTitle length]>0)&&(![buttonOtherIDType.currentTitle isEqualToString:@"- SELECT -"])){
        if ([textIDNumber.text length]>0){
            NSString* spouseID = [NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:idTypeCodeSelected],textIDNumber.text];
            if (![self IdentityValidation:idNasabah CompareWith:spouseID]){
                [self createAlertViewAndShow:validationID tag:0];
            }
            return [self IdentityValidation:idNasabah CompareWith:spouseID];
        }
        else{
            return false;
        }
    }
    else if ([textIDNumber.text length]>0){
        if (([buttonOtherIDType.currentTitle length]>0)&&(![buttonOtherIDType.currentTitle isEqualToString:@"- SELECT -"])){
            NSString* spouseID = [NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:idTypeCodeSelected],textIDNumber.text];
            return [self IdentityValidation:idNasabah CompareWith:spouseID];
        }
        else{
            return false;
        }
    }
    return true;
}


-(bool)validateSpouse:(NSDictionary *)dictSpouse{
     NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@"- SELECT -",@"- Select -",@"--Please Select--", nil];
    
     UIButton *outletRelation = (UIButton *)[dictSpouse valueForKey:@"Relation"];
     UIButton *outletDOB = (UIButton *)[dictSpouse valueForKey:@"ProspectSpouseDOB"];
     UIButton *OtherIDType = (UIButton *)[dictSpouse valueForKey:@"OtherIDType"];
     UITextField *txtOtherIDType = (UITextField *)[dictSpouse valueForKey:@"OtherIDTypeNo"];
     UITextField *txtYearsInsured = (UITextField *)[dictSpouse valueForKey:@"YearsInsured"];
     UITextField *txtName = (UITextField *)[dictSpouse valueForKey:@"ProspectSpouseName"];
     UIButton *outletNationality = (UIButton *)[dictSpouse valueForKey:@"Nationality"];
     UIButton *outletOccupation = (UIButton *)[dictSpouse valueForKey:@"ProspectSpouseOccupationCode"];
     UISegmentedControl *segGender = (UISegmentedControl *)[dictSpouse valueForKey:@"ProspectSpouseGender"];
     UISegmentedControl *segSmoker = (UISegmentedControl *)[dictSpouse valueForKey:@"Smoker"];
    
    
     NSString* spouseName = txtName.text;
     NSString* spouseDOB = outletDOB.currentTitle;
     NSString* spouseOtherIDType = OtherIDType.currentTitle;
     NSString* spouseOtherIDNumber = txtOtherIDType.text;
     NSString* spouseNationality = outletNationality.currentTitle;
     NSString* spouseRelation = outletRelation.currentTitle;
     NSString* spouseYearsInsured = txtYearsInsured.text;
     NSString* spouseOccupationCode = outletOccupation.currentTitle;
     
    if ([validationSet containsObject:spouseName]||(spouseName==NULL)){
        [self createAlertViewAndShow:validationNamaLengkap tag:0];
        return false;
    }
    else if ([validationSet containsObject:spouseDOB]||(spouseDOB==NULL)){
        [self createAlertViewAndShow:validationTanggalLahir tag:0];
        return false;
    }
    /*else if ([validationSet containsObject:spouseOtherIDType]||(spouseOtherIDType==NULL)){
        return false;
    }*/
    /*else if ([validationSet containsObject:spouseOtherIDNumber]||(spouseOtherIDNumber==NULL)){
        return false;
    }*/
    else if ([validationSet containsObject:spouseNationality]||(spouseNationality==NULL)){
        [self createAlertViewAndShow:validationKebangsaan tag:0];
        return false;
    }
    else if ([validationSet containsObject:spouseRelation]||(spouseRelation==NULL)){
        [self createAlertViewAndShow:validationHubungan tag:0];
        return false;
    }
    /*else if ([validationSet containsObject:spouseYearsInsured]||(spouseYearsInsured==NULL)){
        return false;
    }*/
    else if ([validationSet containsObject:spouseOccupationCode]||(spouseOccupationCode==NULL)){
        [self createAlertViewAndShow:validationPekerjaan tag:0];
        return false;
    }
    else if (segGender.selectedSegmentIndex==UISegmentedControlNoSegment){
        [self createAlertViewAndShow:validationJenisKelamin tag:0];
        return false;
    }
    /*else if (segSmoker.selectedSegmentIndex==UISegmentedControlNoSegment){
        return false;
    }*/
    return true;
}


#pragma mark spouse or child compare with DataNasabah
-(bool)IdentityValidation:(NSString *)originID CompareWith:(NSString *)idToCompare{
    if ([originID isEqualToString:idToCompare]){
        return false;
    }
    return true;
}

#pragma mark child
-(bool)validateChild:(NSDictionary *)dictChild{
    NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@"- SELECT -",@"- Select -",@"--Please Select--", nil];
    
    UIButton *outletRelation = (UIButton *)[dictChild valueForKey:@"Relation"];
    UIButton *outletDOB = (UIButton *)[dictChild valueForKey:@"ProspectChildDOB"];
    UIButton *OtherIDType = (UIButton *)[dictChild valueForKey:@"OtherIDType"];
    UITextField *txtOtherIDType = (UITextField *)[dictChild valueForKey:@"OtherIDTypeNo"];
    UITextField *txtYearsInsured = (UITextField *)[dictChild valueForKey:@"YearsInsured"];
    UITextField *txtName = (UITextField *)[dictChild valueForKey:@"ProspectChildName"];
    UIButton *outletNationality = (UIButton *)[dictChild valueForKey:@"Nationality"];
    UIButton *outletOccupation = (UIButton *)[dictChild valueForKey:@"ProspectChildOccupationCode"];
    UISegmentedControl *segGender = (UISegmentedControl *)[dictChild valueForKey:@"ProspectChildGender"];
    UISegmentedControl *segSmoker = (UISegmentedControl *)[dictChild valueForKey:@"Smoker"];
    
    
    NSString* spouseName = txtName.text;
    NSString* spouseDOB = outletDOB.currentTitle;
    NSString* spouseOtherIDType = OtherIDType.currentTitle;
    NSString* spouseOtherIDNumber = txtOtherIDType.text;
    NSString* spouseNationality = outletNationality.currentTitle;
    NSString* spouseRelation = outletRelation.currentTitle;
    NSString* spouseYearsInsured = txtYearsInsured.text;
    NSString* spouseOccupationCode = outletOccupation.currentTitle;
    
    if ([validationSet containsObject:spouseName]||(spouseName==NULL)){
        [self createAlertViewAndShow:validationNamaLengkap tag:0];
        return false;
    }
    else if ([validationSet containsObject:spouseDOB]||(spouseDOB==NULL)){
        [self createAlertViewAndShow:validationTanggalLahir tag:0];
        return false;
    }
    /*else if ([validationSet containsObject:spouseOtherIDType]||(spouseOtherIDType==NULL)){
     return false;
     }*/
    /*else if ([validationSet containsObject:spouseOtherIDNumber]||(spouseOtherIDNumber==NULL)){
     return false;
     }*/
    else if ([validationSet containsObject:spouseNationality]||(spouseNationality==NULL)){
        [self createAlertViewAndShow:validationKebangsaan tag:0];
        return false;
    }
    else if ([validationSet containsObject:spouseRelation]||(spouseRelation==NULL)){
        [self createAlertViewAndShow:validationHubungan tag:0];
        return false;
    }
    else if ([validationSet containsObject:spouseYearsInsured]||(spouseYearsInsured==NULL)){
        [self createAlertViewAndShow:validationTahunAsuransi tag:0];
        return false;
    }
    else if ([validationSet containsObject:spouseOccupationCode]||(spouseOccupationCode==NULL)){
        [self createAlertViewAndShow:validationPekerjaan tag:0];
        return false;
    }
    else if (segGender.selectedSegmentIndex==UISegmentedControlNoSegment){
        [self createAlertViewAndShow:validationJenisKelamin tag:0];
        return false;
    }
    /*else if (segSmoker.selectedSegmentIndex==UISegmentedControlNoSegment){
     return false;
     }*/
    return true;
}

-(bool)validateOtherIDNumberForChild:(UIButton *)buttonOtherIDType TextIDNumber:(UITextField *)textIDNumber IDNasabah:(NSString *)idNasabah IDTypeCodeSelected:(NSString *)idTypeCodeSelected{
    modelIdentificationType = [[ModelIdentificationType alloc]init];
    
    //validate with data nasbah
    bool validateWithNasabah = [self detailChildValidate:buttonOtherIDType TextIDNumber:textIDNumber IDNasabah:idNasabah IDTypeCodeSelected:idTypeCodeSelected];
    
    //validate with data spouse
    modelProspectSpouse = [[ModelProspectSpouse alloc]init];
    NSDictionary *dataSpouse = [[NSDictionary alloc]initWithDictionary:[modelProspectSpouse selectProspectSpouse:[prospectProfileID intValue] CFFTransctoinID:[cffTransactionID intValue]]];
    NSString *idSpouse=[NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:[dataSpouse valueForKey:@"OtherIDType"]],[dataSpouse valueForKey:@"OtherIDTypeNo"]];
    bool validateWithspouse = [self detailChildValidate:buttonOtherIDType TextIDNumber:textIDNumber IDNasabah:idSpouse IDTypeCodeSelected:idTypeCodeSelected];
    
    //validate with data dependants
    modelProspectChild = [[ModelProspectChild alloc]init];
    NSArray* arrayChild = [[NSArray alloc]initWithArray:[modelProspectChild selectProspectChild:[prospectProfileID intValue] CFFTransctoinID:[cffTransactionID intValue]]];
    bool validateWithchild;
    NSString* idChild;
    if ([arrayChild count]>0){
        for (int i=0;i<[arrayChild count];i++){
            idChild=[NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:[[arrayChild objectAtIndex:i] valueForKey:@"OtherIDType"]],[[arrayChild objectAtIndex:i] valueForKey:@"OtherIDTypeNo"]];
            validateWithchild = [self detailChildValidate:buttonOtherIDType TextIDNumber:textIDNumber IDNasabah:idChild IDTypeCodeSelected:idTypeCodeSelected];
            if (!validateWithchild){
                break;
            }
        }
    }
    else{
        validateWithchild = true;
    }
    
    if ((!validateWithNasabah) || (!validateWithspouse) || (!validateWithchild)){
        [self createAlertViewAndShow:validationID tag:0];
        return false;
    }
    
    return true;
}

-(bool)detailChildValidate:(UIButton *)buttonOtherIDType TextIDNumber:(UITextField *)textIDNumber IDNasabah:(NSString *)idNasabah IDTypeCodeSelected:(NSString *)idTypeCodeSelected{
    modelIdentificationType = [[ModelIdentificationType alloc]init];
    if (([buttonOtherIDType.currentTitle length]>0)&&(![buttonOtherIDType.currentTitle isEqualToString:@"- SELECT -"])){
        if ([textIDNumber.text length]>0){
            NSString* childID = [NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:idTypeCodeSelected],textIDNumber.text];
            return [self IdentityValidation:idNasabah CompareWith:childID];
        }
        else{
            return false;
        }
    }
    else if ([textIDNumber.text length]>0){
        if (([buttonOtherIDType.currentTitle length]>0)&&(![buttonOtherIDType.currentTitle isEqualToString:@"- SELECT -"])){
            NSString* chidlID = [NSString stringWithFormat:@"%@%@",[modelIdentificationType getOtherTypeDesc:idTypeCodeSelected],textIDNumber.text];
            return [self IdentityValidation:idNasabah CompareWith:chidlID];
        }
        else{
            return false;
        }
    }
    return true;
}

@end
