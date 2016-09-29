//
//  RadioButtonOutputValue.m
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "AllAboutPDFFunctions.h"

@implementation AllAboutPDFFunctions {
    NSMutableDictionary *dictKeyValueForRadioButton;
}

/*-(id)init{
    
    [self createDictionaryForRadioButton];
    return nil;
}*/

-(void)createDictionaryForRadioButton{
    dictKeyValueForRadioButton = [[NSMutableDictionary alloc]init];
    [dictKeyValueForRadioButton setObject:@"true" forKey:@"Ya"];
    [dictKeyValueForRadioButton setObject:@"false" forKey:@"Tidak"];
    
    [dictKeyValueForRadioButton setObject:@"stranger" forKey:@"Tidak Kenal"];
    [dictKeyValueForRadioButton setObject:@"lessthan1year" forKey:@"< 1 tahun"];
    [dictKeyValueForRadioButton setObject:@"lessthan5years" forKey:@"< 5 tahun"];
    [dictKeyValueForRadioButton setObject:@"entirelife" forKey:@"Selama Hidup"];
    
    [dictKeyValueForRadioButton setObject:@"other" forKey:@"Lainnya"];
    [dictKeyValueForRadioButton setObject:@"agency" forKey:@"Sub Keagenan"];
    [dictKeyValueForRadioButton setObject:@"friend" forKey:@"Teman/ Kerabat"];
    [dictKeyValueForRadioButton setObject:@"advertisement" forKey:@"Iklan"];
    [dictKeyValueForRadioButton setObject:@"stranger" forKey:@"Tidak Sengaja"];
    [dictKeyValueForRadioButton setObject:@"reference" forKey:@"Referensi"];
    [dictKeyValueForRadioButton setObject:@"family" forKey:@"Keluarga"];
    
    [dictKeyValueForRadioButton setObject:@"islam" forKey:@"Islam"];
    [dictKeyValueForRadioButton setObject:@"katolik" forKey:@"Kristen Katolik"];
    [dictKeyValueForRadioButton setObject:@"kristen" forKey:@"Kristen Protestan"];
    [dictKeyValueForRadioButton setObject:@"hindu" forKey:@"Hindu"];
    [dictKeyValueForRadioButton setObject:@"budha" forKey:@"Budha"];
    [dictKeyValueForRadioButton setObject:@"konghuchu" forKey:@"Kong Hu Cu"];
    
    [dictKeyValueForRadioButton setObject:@"single" forKey:@"Belum Menikah"];
    [dictKeyValueForRadioButton setObject:@"married" forKey:@"Menikah"];
    [dictKeyValueForRadioButton setObject:@"divorced" forKey:@"Janda / Duda"];
    
    [dictKeyValueForRadioButton setObject:@"male" forKey:@"Laki - laki"];
    [dictKeyValueForRadioButton setObject:@"female" forKey:@"Perempuan"];
    
    [dictKeyValueForRadioButton setObject:@"true" forKey:@"WNI"];
    [dictKeyValueForRadioButton setObject:@"other" forKey:@"WNA"];
    
    [dictKeyValueForRadioButton setObject:@"home" forKey:@"Alamat Tempat Tinggal"];
    [dictKeyValueForRadioButton setObject:@"office" forKey:@"Alamat Kantor"];
    
    [dictKeyValueForRadioButton setObject:@"self" forKey:@"Diri Sendiri"];
    [dictKeyValueForRadioButton setObject:@"spouse" forKey:@"Suami/Istri"];
    [dictKeyValueForRadioButton setObject:@"family" forKey:@"Orang Tua/Anak"];
    [dictKeyValueForRadioButton setObject:@"colleague" forKey:@"Perusahaan/Karyawan"];
    [dictKeyValueForRadioButton setObject:@"other" forKey:@"Lainnya"];
    [dictKeyValueForRadioButton setObject:@"other" forKey:@"Lainnya, sebutkan"];
    
    [dictKeyValueForRadioButton setObject:@"idr" forKey:@"Rp"];
    [dictKeyValueForRadioButton setObject:@"usd" forKey:@"USD"];
    
    [dictKeyValueForRadioButton setObject:@"pt" forKey:@"Perseroan Terbatas"];
    [dictKeyValueForRadioButton setObject:@"yayasan" forKey:@"Yayasan"];
    [dictKeyValueForRadioButton setObject:@"bumn" forKey:@"BUMN"];
    
    [dictKeyValueForRadioButton setObject:@"100juta" forKey:@"< 100 Juta"];
    [dictKeyValueForRadioButton setObject:@"100juta1miliar" forKey:@"100 Juta - 1 Miliar"];
    [dictKeyValueForRadioButton setObject:@"1miliar10miliar" forKey:@"> 1 Miliar - 10 Miliar"];
    [dictKeyValueForRadioButton setObject:@"10miliar100miliar" forKey:@"> 10 Miliar - 100 Miliar"];
    [dictKeyValueForRadioButton setObject:@"100miliarlebih" forKey:@"> 100 Miliar"];
    
    [dictKeyValueForRadioButton setObject:@"" forKey:@""];
    /*[dictKeyValueForRadioButton setObject:@"" forKey:@""];
    [dictKeyValueForRadioButton setObject:@"" forKey:@""];
    [dictKeyValueForRadioButton setObject:@"" forKey:@""];
    [dictKeyValueForRadioButton setObject:@"" forKey:@""];
    [dictKeyValueForRadioButton setObject:@"" forKey:@""];*/
}

-(NSString *)GetOutputForRadioButton:(NSString *)stringSegmentSelected{
    return [dictKeyValueForRadioButton valueForKey:stringSegmentSelected]?:@"";
}

-(void)showDict{
    NSLog(@"dictKeyValueForRadioButton %@",dictKeyValueForRadioButton);
}
    
-(NSString *)GetOutputForYaTidakRadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Ya"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"Tidak"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForNationailtyRadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"WNI"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"WNA"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForSexRadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Laki - laki"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"Perempuan"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForMaritalStatusRadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Belum Menikah"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"Menikah"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Janda / Duda"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForReligionRadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Islam"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"Kristen Katolik"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Kristen Protestan"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Hindu"]){
        return @"true";
    }
    else if ([stringSegmentSelected isEqualToString:@"Budha"]){
        return @"false";
    }
    else if ([stringSegmentSelected isEqualToString:@"Kong Hu Cu"]){
        return @"false";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForRelationWithPORadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Keluarga"]){
        return @"family";
    }
    else if ([stringSegmentSelected isEqualToString:@"Referensi"]){
        return @"reference";
    }
    else if ([stringSegmentSelected isEqualToString:@"Tidak Sengaja"]){
        return @"stranger";
    }
    else if ([stringSegmentSelected isEqualToString:@"Iklan"]){
        return @"advertisement";
    }
    else if ([stringSegmentSelected isEqualToString:@"Teman/ Kerabat"]){
        return @"friend";
    }
    else if ([stringSegmentSelected isEqualToString:@"Sub Keagenan"]){
        return @"agency";
    }
    else if ([stringSegmentSelected isEqualToString:@"Lainnya"]){
        return @"other";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForDurationKnowPORadioButton:(NSString *)stringSegmentSelected{
    if ([stringSegmentSelected isEqualToString:@"Tidak Kenal"]){
        return @"stranger";
    }
    else if ([stringSegmentSelected isEqualToString:@"< 1 tahun"]){
        return @"lessthan1year";
    }
    else if ([stringSegmentSelected isEqualToString:@"< 5 tahun"]){
        return @"lessthan5years";
    }
    else if ([stringSegmentSelected isEqualToString:@"Selama Hidup"]){
        return @"entirelife";
    }
    else{
        return @"";
    }
}

-(NSString *)GetOutputForInsurancePurposeCheckBox:(NSString *)stringInsurancePurpose{
    if ([stringInsurancePurpose isEqualToString:@"Tabungan"]){
        return @"saving";
    }
    else if ([stringInsurancePurpose isEqualToString:@"Proteksi"]){
        return @"protection";
    }
    else if ([stringInsurancePurpose isEqualToString:@"Investasi"]){
        return @"investment";
    }
    else if ([stringInsurancePurpose isEqualToString:@"Pendidikan"]){
        return @"education";
    }
    else if ([stringInsurancePurpose isEqualToString:@"Lainnya"]){
        return @"other";
    }
    else if ([stringInsurancePurpose isEqualToString:@"Not Selected"]){
        return @"Not Selected";
    }
    else{
        return @"";
    }
}


-(NSMutableDictionary *)dictAnswers:(NSDictionary *)dictTransaction ElementID:(NSString *)elementID Value:(NSString *)value Section:(NSString *)stringSection{
    NSMutableDictionary *dictAnswer=[[NSMutableDictionary alloc]init];
    [dictAnswer setObject:@"0" forKey:@"SPAJHtmlID"];
    [dictAnswer setObject:[dictTransaction valueForKey:@"SPAJTransactionID"] forKey:@"SPAJTransactionID"];
    [dictAnswer setObject:stringSection forKey:@"SPAJHtmlSection"];
    [dictAnswer setObject:@"1" forKey:@"CustomerID"];
    [dictAnswer setObject:@"1" forKey:@"SPAJID"];
    [dictAnswer setObject:value forKey:@"Value"];
    [dictAnswer setObject:elementID forKey:@"elementID"];
    return dictAnswer;
}

-(NSDictionary *)createDictionaryForSave:(NSMutableArray *)arrayAnswers{
    NSDictionary* dictAnswers = [[NSDictionary alloc]initWithObjectsAndKeys:arrayAnswers,@"SPAJAnswers", nil];
    
    NSDictionary* dictSPAJAnswers = [[NSDictionary alloc]initWithObjectsAndKeys:dictAnswers,@"data",@"onError",@"errorCallback",@"onSuccess",@"successCallBack", nil];
    return dictSPAJAnswers;
}

@end
