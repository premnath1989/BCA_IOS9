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
@synthesize delegatePDFFunctions;
/*-(id)init{
    
    [self createDictionaryForRadioButton];
    return nil;
}*/

-(void)createDictionaryForRadioButton{
    dictKeyValueForRadioButton = [[NSMutableDictionary alloc]init];
    [dictKeyValueForRadioButton setObject:@"KTP" forKey:@"KTP"];
    [dictKeyValueForRadioButton setObject:@"PASPOR" forKey:@"Paspor"];
    [dictKeyValueForRadioButton setObject:@"KIMSKITAS" forKey:@"KIMS / KITAS"];
    
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
    [dictKeyValueForRadioButton setObject:@"spouse" forKey:@"Suami / Istri"];
    [dictKeyValueForRadioButton setObject:@"family" forKey:@"Orang Tua/Anak"];
    [dictKeyValueForRadioButton setObject:@"child" forKey:@"Anak"];
    [dictKeyValueForRadioButton setObject:@"parent" forKey:@"Orang Tua"];
    [dictKeyValueForRadioButton setObject:@"sibling" forKey:@"Saudara Kandung"];
    [dictKeyValueForRadioButton setObject:@"sibling" forKey:@"Saudara kandung"];
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
    
    [mutableArrayForKey addObject:@"KTP"]; [mutableArrayForValue addObject:@"KTP"];
    [mutableArrayForKey addObject:@"PASPOR"]; [mutableArrayForValue addObject:@"Paspor"];
    [mutableArrayForKey addObject:@"KIMSKITAS"]; [mutableArrayForValue addObject:@"KIMS / KITAS"];
    
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
    [mutableArrayForKey addObject:@"spouse" ];[mutableArrayForValue addObject:@"Suami / Istri"];
    [mutableArrayForKey addObject:@"family" ];[mutableArrayForValue addObject:@"Orang Tua/Anak"];
    [mutableArrayForKey addObject:@"parent" ];[mutableArrayForValue addObject:@"Orang Tua"];
    [mutableArrayForKey addObject:@"child" ];[mutableArrayForValue addObject:@"Anak"];
    [mutableArrayForKey addObject:@"sibling" ];[mutableArrayForValue addObject:@"Saudara Kandung"];
    [mutableArrayForKey addObject:@"sibling" ];[mutableArrayForValue addObject:@"Saudara kandung"];
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


- (void)createFileDirectory:(NSString *)fileTimeDirectory{
    //create Directory
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileTimeDirectory])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:fileTimeDirectory
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
}

- (NSMutableArray *)createImageSignatureFiles:(NSDictionary *)dictTransaction{
    classImageProcessing = [[ClassImageProcessing alloc]init];
    modelSPAJSignature = [[ModelSPAJSignature alloc]init];
    modelSPAJHtml = [[ModelSPAJHtml alloc]init];
    formatter = [[Formatter alloc]init];
    
    UIImage* emptyImage = [UIImage imageNamed:@"emptyImage"];
    NSData * emptyImageData = UIImagePNGRepresentation(emptyImage);
    NSString *encodedEmptyImageString = [emptyImageData base64EncodedStringWithOptions:0];
    
    NSString* base64StringImageParty1=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty1" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:encodedEmptyImageString;
    NSString* base64StringImageParty2=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty2" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:encodedEmptyImageString;
    NSString* base64StringImageParty3=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty3" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:encodedEmptyImageString;
    NSString* base64StringImageParty4=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty4" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:encodedEmptyImageString;
    NSString* base64StringImageParty5=[modelSPAJSignature selectSPAJSignatureData:@"SPAJSignatureTempImageParty5" SPAJTransactionID:[[dictTransaction valueForKey:@"SPAJTransactionID"] intValue]]?:encodedEmptyImageString;
    
    NSData* imageParty1=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty1 options:0];
    NSData* imageParty2=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty2 options:0];
    NSData* imageParty3=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty3 options:0];
    NSData* imageParty4=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty4 options:0];
    NSData* imageParty5=[[NSData alloc]
                         initWithBase64EncodedString:base64StringImageParty5 options:0];
    
    UIImage *imageSignatureParty1 = [UIImage imageWithData:imageParty1];
    UIImage *imageSignatureParty2 = [UIImage imageWithData:imageParty2];
    UIImage *imageSignatureParty3 = [UIImage imageWithData:imageParty3];
    UIImage *imageSignatureParty4 = [UIImage imageWithData:imageParty4];
    UIImage *imageSignatureParty5 = [UIImage imageWithData:imageParty5];
    
    
    UIColor* fromColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0];
    UIColor* toColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImage* imageConverted1 = [classImageProcessing changeColor:imageSignatureParty1 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted2 = [classImageProcessing changeColor:imageSignatureParty2 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted3 = [classImageProcessing changeColor:imageSignatureParty3 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted4 = [classImageProcessing changeColor:imageSignatureParty4 fromColor:fromColor toColor:toColor];
    UIImage* imageConverted5 = [classImageProcessing changeColor:imageSignatureParty5 fromColor:fromColor toColor:toColor];
    
    NSData *imageConvertedData1 = UIImagePNGRepresentation(imageConverted1);
    NSData *imageConvertedData2 = UIImagePNGRepresentation(imageConverted2);
    NSData *imageConvertedData3 = UIImagePNGRepresentation(imageConverted3);
    NSData *imageConvertedData4 = UIImagePNGRepresentation(imageConverted4);
    NSData *imageConvertedData5 = UIImagePNGRepresentation(imageConverted5);
    
    NSArray* arrayImageSignature = [[NSArray alloc]initWithObjects:imageConvertedData1,imageConvertedData2,imageConvertedData4,imageConvertedData3,imageConvertedData5, nil];
    
    
    NSMutableArray* pathResultSignatureImages = [[NSMutableArray alloc]init];
    //for (int i = 0;i<[arrayImageSignature count];i++){
    int x=0;
    for (int i = 0;i<5;i++){
        @autoreleasepool {
            NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
            NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
            NSString* strTimeStamp = [NSString stringWithFormat:@"%@",timeStampObj];
            NSString *relativeOutputFilePath = [NSString stringWithFormat:@"%@/ImageSignature/SignatureParty%i_%@.png", [formatter generateSPAJFileDirectory:[dictTransaction valueForKey:@"SPAJEappNumber"]],i+1,strTimeStamp];
            
            NSArray* pathComponents = [relativeOutputFilePath pathComponents];
            NSArray* lastFourArray = [pathComponents subarrayWithRange:NSMakeRange([pathComponents count]-4,4)];
            NSString* lastFourPath = [NSString stringWithFormat:@"%@",[NSString pathWithComponents:lastFourArray]];
            
            [pathResultSignatureImages addObject:[NSString stringWithFormat:@"\"../../%@\"",lastFourPath]];
            
            if (i<[arrayImageSignature count]){
                BOOL written = [[arrayImageSignature objectAtIndex:i] writeToFile:relativeOutputFilePath atomically:YES];
                
                if (written){
                    x = x+1;
                    if (x==5){
                        [delegatePDFFunctions allSignatureCreated];
                    }
                }
            }
            
        }
    }
    return pathResultSignatureImages;
}

-(NSMutableArray *)createImageSignatureForEapp:(NSDictionary *)dictTransaction{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePathApp = [docsDir stringByAppendingPathComponent:@"SPAJ"];
    NSString* folderName = [NSString stringWithFormat:@"/%@",[dictTransaction valueForKey:@"SPAJEappNumber"]];
    filePathApp = [filePathApp  stringByAppendingString:folderName];
    [self createFileDirectory:[NSString stringWithFormat:@"%@/ImageSignature",filePathApp]];
    //NSMutableArray* arraySignatureImages=[[NSMutableArray alloc]init];
    NSMutableArray* arraySignatureImages;
    
    arraySignatureImages = [[NSMutableArray alloc]initWithArray:[self createImageSignatureFiles:dictTransaction]];
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //1.create the folder
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //2.create the file
            
        });
    });*/
    return [[NSMutableArray alloc]initWithArray:arraySignatureImages];
}

@end
