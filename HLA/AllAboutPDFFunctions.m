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
    NSMutableDictionary *dictKeyRevertValueForRadioButton;
    
    NSMutableArray* mutableArrayForKey;
    NSMutableArray* mutableArrayForValue;
    NSMutableArray* arrayDictRadioButton;
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

-(void)createDictionaryRevertForRadioButton{
    dictKeyRevertValueForRadioButton = [[NSMutableDictionary alloc]init];
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"true"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"false"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"stranger"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"lessthan1year"];
    [dictKeyRevertValueForRadioButton setObject:@"2" forKey:@"lessthan5years"];
    [dictKeyRevertValueForRadioButton setObject:@"3" forKey:@"entirelife"];
    
    [dictKeyRevertValueForRadioButton setObject:@"6" forKey:@"other"];
    [dictKeyRevertValueForRadioButton setObject:@"5" forKey:@"agency"];
    [dictKeyRevertValueForRadioButton setObject:@"4" forKey:@"friend"];
    [dictKeyRevertValueForRadioButton setObject:@"3" forKey:@"advertisement"];
    [dictKeyRevertValueForRadioButton setObject:@"2" forKey:@"stranger"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"reference"];
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"family"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"islam"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"katolik"];
    [dictKeyRevertValueForRadioButton setObject:@"2" forKey:@"kristen"];
    [dictKeyRevertValueForRadioButton setObject:@"3" forKey:@"hindu"];
    [dictKeyRevertValueForRadioButton setObject:@"4" forKey:@"budha"];
    [dictKeyRevertValueForRadioButton setObject:@"5" forKey:@"konghuchu"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"single"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"married"];
    [dictKeyRevertValueForRadioButton setObject:@"2" forKey:@"divorced"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"male"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"female"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"true"];
    //[dictKeyRevertValueForRadioButton setObject:@"other" forKey:@"other"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"home"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"office"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"self"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"spouse"];
    [dictKeyRevertValueForRadioButton setObject:@"2" forKey:@"family"];
    [dictKeyRevertValueForRadioButton setObject:@"3" forKey:@"colleague"];
    [dictKeyRevertValueForRadioButton setObject:@"4" forKey:@"other"];
    //[dictKeyRevertValueForRadioButton setObject:@"other" forKey:@"other"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"idr"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"usd"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"pt"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"yayasan"];
    [dictKeyRevertValueForRadioButton setObject:@"2" forKey:@"bumn"];
    
    [dictKeyRevertValueForRadioButton setObject:@"0" forKey:@"100juta"];
    [dictKeyRevertValueForRadioButton setObject:@"1" forKey:@"100juta1miliar"];
    [dictKeyRevertValueForRadioButton setObject:@"2" forKey:@"1miliar10miliar"];
    [dictKeyRevertValueForRadioButton setObject:@"3" forKey:@"10miliar100miliar"];
    [dictKeyRevertValueForRadioButton setObject:@"4" forKey:@"100miliarlebih"];
    
    [dictKeyRevertValueForRadioButton setObject:@"" forKey:@""];
    /*[dictKeyRevertValueForRadioButton setObject:@"" forKey:@""];
     [dictKeyRevertValueForRadioButton setObject:@"" forKey:@""];
     [dictKeyRevertValueForRadioButton setObject:@"" forKey:@""];
     [dictKeyRevertValueForRadioButton setObject:@"" forKey:@""];
     [dictKeyRevertValueForRadioButton setObject:@"" forKey:@""];*/
}


-(void)createArrayRevertForRadioButton{
    
    mutableArrayForKey = [[NSMutableArray alloc]init];
    mutableArrayForValue = [[NSMutableArray alloc]init];
    
    [mutableArrayForKey addObject:@"true" ];[mutableArrayForValue addObject:@"Ya"];
    [mutableArrayForKey addObject:@"false" ];[mutableArrayForValue addObject:@"Tidak"];
    
    [mutableArrayForKey addObject:@"stranger" ];[mutableArrayForValue addObject:@"Tidak Kenal"];
    [mutableArrayForKey addObject:@"lessthan1year" ];[mutableArrayForValue addObject:@"< 1 tahun"];
    [mutableArrayForKey addObject:@"lessthan5years" ];[mutableArrayForValue addObject:@"< 5 tahun"];
    [mutableArrayForKey addObject:@"entirelife" ];[mutableArrayForValue addObject:@"Selama Hidup"];
    
    [mutableArrayForKey addObject:@"other" ];[mutableArrayForValue addObject:@"Lainnya"];
    [mutableArrayForKey addObject:@"agency" ];[mutableArrayForValue addObject:@"Sub Keagenan"];
    [mutableArrayForKey addObject:@"friend" ];[mutableArrayForValue addObject:@"Teman/ Kerabat"];
    [mutableArrayForKey addObject:@"advertisement" ];[mutableArrayForValue addObject:@"Iklan"];
    [mutableArrayForKey addObject:@"stranger" ];[mutableArrayForValue addObject:@"Tidak Sengaja"];
    [mutableArrayForKey addObject:@"reference" ];[mutableArrayForValue addObject:@"Referensi"];
    [mutableArrayForKey addObject:@"family" ];[mutableArrayForValue addObject:@"Keluarga"];
    
    [mutableArrayForKey addObject:@"islam" ];[mutableArrayForValue addObject:@"Islam"];
    [mutableArrayForKey addObject:@"katolik" ];[mutableArrayForValue addObject:@"Kristen Katolik"];
    [mutableArrayForKey addObject:@"kristen" ];[mutableArrayForValue addObject:@"Kristen Protestan"];
    [mutableArrayForKey addObject:@"hindu" ];[mutableArrayForValue addObject:@"Hindu"];
    [mutableArrayForKey addObject:@"budha" ];[mutableArrayForValue addObject:@"Budha"];
    [mutableArrayForKey addObject:@"konghuchu" ];[mutableArrayForValue addObject:@"Kong Hu Cu"];
    
    [mutableArrayForKey addObject:@"single" ];[mutableArrayForValue addObject:@"Belum Menikah"];
    [mutableArrayForKey addObject:@"married" ];[mutableArrayForValue addObject:@"Menikah"];
    [mutableArrayForKey addObject:@"divorced" ];[mutableArrayForValue addObject:@"Janda / Duda"];
    
    [mutableArrayForKey addObject:@"male" ];[mutableArrayForValue addObject:@"Laki - laki"];
    [mutableArrayForKey addObject:@"female" ];[mutableArrayForValue addObject:@"Perempuan"];
    
    [mutableArrayForKey addObject:@"true" ];[mutableArrayForValue addObject:@"WNI"];
    [mutableArrayForKey addObject:@"other" ];[mutableArrayForValue addObject:@"WNA"];
    
    [mutableArrayForKey addObject:@"home" ];[mutableArrayForValue addObject:@"Alamat Tempat Tinggal"];
    [mutableArrayForKey addObject:@"office" ];[mutableArrayForValue addObject:@"Alamat Kantor"];
    
    [mutableArrayForKey addObject:@"self" ];[mutableArrayForValue addObject:@"Diri Sendiri"];
    [mutableArrayForKey addObject:@"spouse" ];[mutableArrayForValue addObject:@"Suami/Istri"];
    [mutableArrayForKey addObject:@"family" ];[mutableArrayForValue addObject:@"Orang Tua/Anak"];
    [mutableArrayForKey addObject:@"colleague" ];[mutableArrayForValue addObject:@"Perusahaan/Karyawan"];
    [mutableArrayForKey addObject:@"other" ];[mutableArrayForValue addObject:@"Lainnya"];
    [mutableArrayForKey addObject:@"other" ];[mutableArrayForValue addObject:@"Lainnya, sebutkan"];
    
    [mutableArrayForKey addObject:@"idr" ];[mutableArrayForValue addObject:@"Rp"];
    [mutableArrayForKey addObject:@"usd" ];[mutableArrayForValue addObject:@"USD"];
    
    [mutableArrayForKey addObject:@"pt" ];[mutableArrayForValue addObject:@"Perseroan Terbatas"];
    [mutableArrayForKey addObject:@"yayasan" ];[mutableArrayForValue addObject:@"Yayasan"];
    [mutableArrayForKey addObject:@"bumn" ];[mutableArrayForValue addObject:@"BUMN"];
    
    [mutableArrayForKey addObject:@"100juta" ];[mutableArrayForValue addObject:@"< 100 Juta"];
    [mutableArrayForKey addObject:@"100juta1miliar" ];[mutableArrayForValue addObject:@"100 Juta - 1 Miliar"];
    [mutableArrayForKey addObject:@"1miliar10miliar" ];[mutableArrayForValue addObject:@"> 1 Miliar - 10 Miliar"];
    [mutableArrayForKey addObject:@"10miliar100miliar" ];[mutableArrayForValue addObject:@"> 10 Miliar - 100 Miliar"];
    [mutableArrayForKey addObject:@"100miliarlebih" ];[mutableArrayForValue addObject:@"> 100 Miliar"];
    
    [mutableArrayForKey addObject:@"" ];[mutableArrayForValue addObject:@""];
    
    [self createArrayDictionaryForRadioButton:mutableArrayForValue ArrayKey:mutableArrayForKey];
}

-(void)createArrayDictionaryForRadioButton:(NSMutableArray *)arrayObject ArrayKey:(NSMutableArray *)arrayKey{
    arrayDictRadioButton = [[NSMutableArray alloc]init];
    for (int i = 0;i<[arrayObject count];i++){
        NSMutableDictionary* tempRevertRadioButtonDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[arrayObject objectAtIndex:i],@"Object",[arrayKey objectAtIndex:i],@"Key", nil];
        [arrayDictRadioButton addObject:tempRevertRadioButtonDict];
    }
    
    NSLog(@"dict %@",arrayDictRadioButton);
}

-(NSArray *)filterArrayByKey:(NSString *)stringKey{
    NSArray *filtered = [arrayDictRadioButton filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Key == %@)", stringKey]];
    return filtered;
}

-(int)getRadioButtonIndexMapped:(NSString *)stringElementName{
    return [[dictKeyRevertValueForRadioButton valueForKey:stringElementName] intValue];
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
    else if ([stringInsurancePurpose isEqualToString:@"Not Checked"]){
        return @"Not Checked";
    }
    else{
        return @"";
    }
}


-(NSMutableDictionary *)dictAnswers:(NSDictionary *)dictTransaction ElementID:(NSString *)elementID Value:(NSString *)value Section:(NSString *)stringSection SPAJHtmlID:(NSString *)stringHtmlID{
    NSMutableDictionary *dictAnswer=[[NSMutableDictionary alloc]init];
    [dictAnswer setObject:stringHtmlID forKey:@"SPAJHtmlID"];
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
