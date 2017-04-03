//
//  SAMNewNasabahViewController.m
//  BLESS
//
//  Created by administrator on 3/27/17.
//  Copyright © 2017 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SAMNewNasabahViewController.h"
#import "SAMActivityViewController.h"
#import "SAMMeetingScheduleViewController.h"
#import "textFields.h"

@interface SAMNewNasabahViewController ()

@end

@implementation SAMNewNasabahViewController

@synthesize dashboardVC;
@synthesize txtNip;
@synthesize txtReferralName;
@synthesize txtKcu;
@synthesize txtKanwil;
@synthesize txtBranchCode;
@synthesize txtBranchName;
@synthesize txtProspectFullName;
@synthesize outletDoB;
@synthesize segNationality;
@synthesize segGender;
@synthesize gender;
@synthesize nationality;
@synthesize SIDate;
@synthesize SIDatePopover;
@synthesize outletProspectCountryBirthplace;

@synthesize outletReferralSource;

int const CONTINUE_ALERT_TAG = 100;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    dispatch_async (dispatch_get_main_queue(), ^{
        [scrollViewForm setContentSize:CGSizeMake(819, 1901)];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Database

-(void) saveToDb {
//    [self.view endEditing:YES];
//    [self resignFirstResponder];
//    
//    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
//    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
//    [activeInstance performSelector:@selector(dismissKeyboard)];
//    
//    NSString *strDOB = @"";
//    NSString *title = @"";
//    NSString *strExpiryDate = @"";
//    NSString *othertype = @"";
//    NSString *marital  = @"";
//    NSString *race = @"";
//    NSString *Rigdateoutlet = @"";
//    NSString *religion = @"";
//    NSString *nation  = @"";
//    
//    NSString *OffCountry = @"";
//    NSString *HomeCountry = @"";
//    NSString *RegNumber = @"";
//    
//    NSString *SelectedStateCode = @"";
//    NSString *TitleCodeSelected = @"";
//    int counter = 0;
//    
//    /*added by faiz*/
//    
//    /*end of added by faiz*/
//    if ([self Validation] == TRUE && DATE_OK == YES && [self OtherIDValidation] == TRUE) {
//        
//        sqlite3_stmt *statement;
//        const char *dbpath = [databasePath UTF8String];
//        
//        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
//            txtProspectFullName.text = [txtProspectFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
////            if (checked) {
////                HomeCountry = btnHomeCountry.titleLabel.text;
////                SelectedStateCode = txtHomeState.text;
////            } else {
////                HomeCountry = txtHomeCountry.text;
////            }
//            
////            RegNumber = txtRigNO.text;
////            Rigdateoutlet = outletRigDate.titleLabel.text;
////            if (checked2) {
////                OffCountry = btnOfficeCountry.titleLabel.text;
////                SelectedOfficeStateCode = txtOfficeState.text;
////            } else {
////                OffCountry = txtOfficeCountry.text;
////            }
//            
//            if (outletDoB.titleLabel.text.length == 0) {
//                strDOB = [outletDoB.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//            } else {
//                strDOB = outletDoB.titleLabel.text;
//            }
//            
//            if(gender == nil || gender==NULL || segGender.selectedSegmentIndex == -1) {
//                gender = @"";
//            }
//            
//            //HomeCountry =  [self getCountryCode:HomeCountry];
//            //OffCountry =  [self getCountryCode:OffCountry];
//            
//            /*modified by faiz*/
//            race  = @"OTHERS";//[outletRace.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            
//            
//            //ENS: Save othertype with code
//            //othertype = IDTypeCodeSelected;
////            othertype = IDTypeIdentifierSelected;
////            if (IDTypeCodeSelected == NULL) {
////                othertype = @"";
////            }
////            
////            NSString *type = [_txtProspectId.text stringByTrimmingCharactersInSet:
////                              [NSCharacterSet whitespaceCharacterSet]];
////            if (type.length != 0) {
////                type = [self getOtherTypeCode:type];
////                othertype = type;
////            }
//            
//            strDOB = [strDOB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            
//            
//            NSString *insertSQL;
//            
//            if([othertype isEqualToString:@"- SELECT -"]) {
//                othertype = @"";
//            }
//            
//            if([title isEqualToString:@"- SELECT -"]) {
//                title = @"";
//            }
//            
//            if([strDOB isEqualToString:@"- SELECT -"] || [strDOB isEqualToString:@"-SELECT-"]) {
//                strDOB = @"";
//            }
//            
//            if ([strDOB isEqualToString:@""]
//                && [textFields trimWhiteSpaces:outletDoB.titleLabel.text].length != 0
//                && ![[textFields trimWhiteSpaces:outletDoB.titleLabel.text] isEqualToString:@"- SELECT -"]
//                && ![[textFields trimWhiteSpaces:outletDoB.titleLabel.text] isEqualToString:@"-SELECT-"])
//            {
//                strDOB = [outletDoB.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            }
//            
//            if([marital isEqualToString:@"- SELECT -"]) {
//                marital = @"";
//            }
//            
//            if([race isEqualToString:@"- SELECT -"]) {
//                race = @"";
//            }
//            
//            if([Rigdateoutlet isEqualToString:@"- SELECT -"]) {
//                Rigdateoutlet = @"";
//            }
//            
//            if([religion isEqualToString:@"- SELECT -"]) {
//                religion = @"";
//            }
//            
//            if([nation isEqualToString:@"- SELECT -"]) {
//                nation = @"";
//            }
//            
//            if([HomeCountry isEqualToString:@"(null)"]  || (HomeCountry == NULL)) {
//                HomeCountry = @"";
//            }
//            
//            if([SelectedStateCode isEqualToString:@"(null)"]  || (SelectedStateCode == NULL)) {
//                SelectedStateCode = @"";
//            }
//            
//            if([TitleCodeSelected isEqualToString:@"(null)"]  || (TitleCodeSelected == NULL)) {
//                TitleCodeSelected = @"";
//            }
//            
//            if ([TitleCodeSelected isEqualToString:@""] && ![title isEqualToString:@""]) {
//                TitleCodeSelected = [self getTitleCode:title];
//            }
//            
//            NSString *isGrouping = @"N";
//            
////            if (segIsGrouping.selectedSegmentIndex == 0) {
////                isGrouping = @"Y";
////                group = [self ProspectGroup_toString];
////            } else {
////                isGrouping = @"N";
////                group = @"";
////            }
//            
//            // Convert string to date object
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//            [dateFormat setDateFormat:@"yyyy-MM-dd"];
//            NSDate *date = [dateFormat dateFromString:strDOB];
//            
//            // Convert date object to desired output format
//            [dateFormat setDateFormat:@"dd/MM/yyyy"];
//            NSString *newDOB = [dateFormat stringFromDate:date];
//            
//            NSDateFormatter *expiryDateFormat = [[NSDateFormatter alloc] init];
//            [expiryDateFormat setDateFormat:@"yyyy-MM-dd"];
//            NSDate *dateExpiry = [expiryDateFormat dateFromString:strExpiryDate];
//            
//            // Convert date object to desired output format
//            [expiryDateFormat setDateFormat:@"dd/MM/yyyy"];
//            NSString *newExpiryDate = [expiryDateFormat stringFromDate:dateExpiry];
//            
//            NSLog(@"%@",newDOB);
//            
//            NSString *genderSeg;
//            if(segGender.selectedSegmentIndex == 0){
//                genderSeg = @"MALE";
//            }else{
//                genderSeg = @"FEMALE";
//            }
//            
//            NSString *CountryOfBirth = @"";
//            CountryOfBirth = outletProspectCountryBirthplace.titleLabel.text;//btnCoutryOfBirth.titleLabel.text;
//            //CountryOfBirth = [self getCountryCode:CountryOfBirth];
//            
//            if(Update_record == YES) {
//                //GET PP  CHANGES COUNTER
//                
//                FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
//                [db open];
//                FMResultSet *result = [db executeQuery:@"SELECT ProspectProfileChangesCounter from prospect_profile WHERE indexNo = ?", pp.ProspectID];
//                while ([result next]) {
//                    counter =  [result intForColumn:@"ProspectProfileChangesCounter"];
//                }
//                [result close];
//                
//                counter = counter+1;
//                
//                NSString *str_counter = [NSString stringWithFormat:@"%i",counter];
//                NSString *prosID = prospectprofile.ProspectID;
//                
//                if (prospectprofile.ProspectID == Nil) {
//                    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
//                    prospectprofile.ProspectID = [ClientProfile objectForKey:@"LastID"];
//                    prosID = [ClientProfile objectForKey:@"LastID"];
//                }
//                
//                if ([db close]) {
//                    [db open];
//                }
//                
//                
//                insertSQL = [NSString stringWithFormat:
//                             @"UPDATE prospect_profile set \"ProspectName\"=\'%@\', \"ProspectDOB\"=\"%@\",\"GST_registered\"=\"%@\",\"GST_registrationNo\"=\"%@\",\"GST_registrationDate\"=\"%@\",\"GST_exempted\"=\"%@\", \"ProspectGender\"=\"%@\", \"ResidenceAddress1\"=\"%@\", \"ResidenceAddress2\"=\"%@\", \"ResidenceAddress3\"=\"%@\", \"ResidenceAddressTown\"=\"%@\", \"ResidenceAddressState\"=\"%@\", \"ResidenceAddressPostCode\"=\"%@\", \"ResidenceAddressCountry\"=\"%@\", \"OfficeAddress1\"=\"%@\", \"OfficeAddress2\"=\"%@\", \"OfficeAddress3\"=\"%@\", \"OfficeAddressTown\"=\"%@\",\"OfficeAddressState\"=\"%@\", \"OfficeAddressPostCode\"=\"%@\", \"OfficeAddressCountry\"=\"%@\", \"ProspectEmail\"= \"%@\", \"ProspectOccupationCode\"=\"%@\", \"ExactDuties\"=\"%@\", \"ProspectRemark\"=\"%@\", \"DateModified\"=%@,\"ModifiedBy\"=\"%@\", \"ProspectGroup\"=\"%@\", \"ProspectTitle\"=\"%@\", \"IDTypeNo\"=\"%@\", \"OtherIDType\"=\"%@\", \"OtherIDTypeNo\"=\"%@\", \"Smoker\"=\"%@\", \"AnnualIncome\"=\"%@\", \"BussinessType\"=\"%@\", \"Race\"=\"%@\", \"MaritalStatus\"=\"%@\", \"Nationality\"=\"%@\", \"Religion\"=\"%@\",\"ProspectProfileChangesCounter\"=\"%@\", \"Prospect_IsGrouping\"=\"%@\", \"CountryOfBirth\"=\"%@\" where IndexNo = \"%@\" " ,
//                             txtFullName.text, strDOB, GSTRigperson, txtRigNO.text, Rigdateoutlet,GSTRigExempted,gender, txtHomeAddr1.text, txtHomeAddr2.text, txtHomeAddr3.text, txtHomeTown.text, SelectedStateCode, txtHomePostCode.text, HomeCountry, txtOfficeAddr1.text, txtOfficeAddr2.text, txtOfficeAddr3.text, txtOfficeTown.text, SelectedOfficeStateCode, txtOfficePostcode.text, OffCountry, txtEmail.text, OccupCodeSelected, txtExactDuties.text, txtRemark.text, @"datetime(\"now\", \"+8 hour\")", @"1", group, TitleCodeSelected, txtIDType.text, othertype, txtOtherIDType.text, ClientSmoker, txtAnnIncome.text, txtBussinessType.text, race, marital, nation, religion, str_counter,isGrouping, CountryOfBirth, prosID];
//                
//            } else {
//                
//                insertSQL = [NSString stringWithFormat:
//                             @"INSERT INTO prospect_profile(\'ProspectName\', \"ProspectDOB\", \"GST_registered\", \"GST_registrationNo\", \"GST_registrationDate\", \"GST_exempted\",\"ProspectGender\", \"ResidenceAddress1\", \"ResidenceAddress2\", \"ResidenceAddress3\", \"ResidenceAddressTown\", \"ResidenceAddressState\",\"ResidenceAddressPostCode\", \"ResidenceAddressCountry\", \"ResidenceDistrict\", \"ResidenceVillage\", \"ResidenceProvince\", \"OfficeAddress1\", \"OfficeAddress2\", \"OfficeAddress3\",\"OfficeAddressTown\", \"OfficeAddressState\", \"OfficeAddressPostCode\", \"OfficeAddressCountry\", \"OfficeDistrict\", \"OfficeVillage\", \"OfficeProvince\", \"ProspectEmail\",\"ProspectOccupationCode\", \"ExactDuties\", \"ProspectRemark\", \"ClientSegmentation\", \"DateCreated\", \"CreatedBy\", \"DateModified\",\"ModifiedBy\", \"ProspectGroup\", \"ProspectTitle\", \"IDTypeNo\", \"OtherIDType\", \"OtherIDTypeNo\", \"Smoker\", \"AnnualIncome\", \"SourceIncome\", \"BussinessType\", \"Race\", \"MaritalStatus\", \"Religion\", \"Nationality\", \"QQFlag\",\"ProspectProfileChangesCounter\",\"prospect_IsGrouping\", \"CountryOfBirth\", \"NIP\", \"BranchCode\", \"BranchName\", \"KCU\", \"Kanwil\",\"ReferralSource\", \"ReferralName\", \"IDExpiryDate\", \"NPWPNo\") "
//                             "VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", %@, \"%@\", %@, \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%s\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", txtFullName.text, strDOB, GSTRigperson, txtRigNO.text, Rigdateoutlet,GSTRigExempted,genderSeg, txtHomeAddr1.text, txtHomeAddr2.text, txtHomeAddr3.text,txtHomeTown.text/*_outletKota.titleLabel.text*/, SelectedStateCode, txtHomePostCode.text, HomeCountry,txtHomeDistrict.text,txtHomeVillage.text, txtHomeProvince.text/*_outletProvinsi.titleLabel.text*/, txtOfficeAddr1.text, txtOfficeAddr2.text, txtOfficeAddr3.text, txtOfficeTown.text/*_outletKotaOffice.titleLabel.text*/, SelectedOfficeStateCode, txtOfficePostcode.text, OffCountry, txtOfficeDistrict.text,@"", @""/*_outletProvinsiOffice.titleLabel.text*/, @"", OccupCodeSelected, txtExactDuties.text, txtRemark.text, _outletVIPClass.titleLabel.text,
//                             @"datetime(\"now\", \"+7 hour\")", @"1", @"datetime(\"now\", \"+7 hour\")", @"1", group, TitleCodeSelected , txtIDType.text, othertype, txtOtherIDType.text, ClientSmoker, txtAnnIncome.text, _outletSourceIncome.titleLabel.text, txtBussinessType.text,race,marital,religion,nation,"false",@"1", isGrouping, CountryOfBirth, txtNip.text, outletBranchCode.titleLabel.text, outletBranchName.titleLabel.text, txtKcu.text, txtKanwil.text, outletReferralSource.titleLabel.text, txtReferralName.text, strExpiryDate, txtNPWPNo.text];
//                
//            }
//            
//            const char *insert_stmt = [insertSQL UTF8String];
//            if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
//                if (sqlite3_step(statement) == SQLITE_DONE) {
//                    [self GetLastID];
//                } else {
//                    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting into profile table" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                    [failAlert show];
//                }
//                sqlite3_finalize(statement);
//            }
//            else{
//                NSLog(@"query insert %@",insertSQL);
//                NSLog(@"could not prepare statement: %s", sqlite3_errmsg(contactDB));
//            }
//            
//            sqlite3_close(contactDB);
//            insertSQL = Nil, insert_stmt = Nil;
//        }
//        
//        statement = Nil;
//        dbpath = Nil;
//    } else {
//        NSLog(@"Either validation return false or 'DATE_OK' =  NO");
//    }
//    
//    PostcodeContinue = TRUE;
//    
//    //******** START ****************  UPDATE CLIENT OF LA1, LA2, PO IN EAPP   *********************************
//    
//    
//    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
//    [db open];
//    
//    FMResultSet *result = [db executeQuery:@"SELECT COUNT(*) as COUNT FROM eProposal_LA_Details WHERE ProspectProfileID = ? AND POFlag = 'N'", prospectprofile.ProspectID];
//    NSString *str_counter;
//    NSString *contact1;
//    NSString *contact2;
//    NSString *contact3;
//    NSString *contact4;
//    while ([result next]) {
//        int count = [result intForColumn:@"COUNT"];
//        if(count > 0) {
//            str_counter = [NSString stringWithFormat:@"%i",counter];
//            /*edit by faiz*/
//            contact1 =  [NSString stringWithFormat:@"%@",txtContact1.text];//[NSString stringWithFormat:@"%@%@",txtPrefix1.text, txtContact1.text];
//            contact2 =  [NSString stringWithFormat:@"%@",txtContact2.text];//[NSString stringWithFormat:@"%@%@",txtPrefix2.text, txtContact2.text];
//            contact3 =  [NSString stringWithFormat:@"%@",txtContact3.text];//[NSString stringWithFormat:@"%@%@",txtPrefix3.text, txtContact3.text];
//            contact4 =  [NSString stringWithFormat:@"%@",txtContact4.text];//[NSString stringWithFormat:@"%@%@",txtPrefix4.text, txtContact4.text];
//            /*end of edit by faiz*/
//            
//            [db executeUpdate:@"Update eProposal_LA_Details SET \"LATitle\" = \"%@\", \"LAName\" = \"%@\", \"LASex\" = \"%@\", \"LADOB\" = \"%@\", \"LANewICNO\" = \"%@\", \"LAOtherIDType\" = \"%@\", \"LAOtherID\" = \"%@\", \"LAMaritalStatus\" = \"%@\", \"LARace\" = \"%@\", \"LAReligion\" = \"%@\", \"LANationality\" = \"%@\", \"LAOccupationCode\" = \"%@\", \"LAExactDuties\" = \"%@\", \"LATypeOfBusiness\" = \"%@\", \"ResidenceAddress1\" = \"%@\", \"ResidenceAddress2\" = \"%@\", \"ResidenceAddress3\" = \"%@\", \"ResidenceTown\" = \"%@\", \"ResidenceState\" = \"%@\", \"ResidencePostcode\" = \"%@\", \"ResidenceCountry\" = \"%@\", \"OfficeAddress1\" = \"%@\", \"OfficeAddress2\" = \"%@\", \"OfficeAddress3\" = \"%@\", \"OfficeTown\" = \"%@\", \"OfficeState\" = \"%@\", \"OfficePostcode\" = \"%@\", \"OfficeCountry\" = \"%@\", \"ResidencePhoneNo\" = \"%@\", \"OfficePhoneNo\" = \"%@\", \"FaxPhoneNo\" = \"%@\", \"MobilePhoneNo\" = \"%@\", \"EmailAddress\" = \"%@\", \"LASmoker\" = \"%@\", \"ProspectProfileChangesCounter\" = \"%@\" WHERE  ProspectProfileID = \"%@\";",
//             
//             TitleCodeSelected,
//             txtFullName.text,
//             gender,
//             strDOB,
//             txtIDType.text,
//             othertype,
//             txtOtherIDType.text,
//             
//             marital,
//             race,
//             religion,
//             nation,
//             OccupCodeSelected,
//             txtExactDuties.text,
//             txtBussinessType.text,
//             
//             txtHomeAddr1.text,
//             txtHomeAddr2.text,
//             txtHomeAddr3.text,
//             
//             txtHomeTown.text,
//             SelectedStateCode,
//             txtHomePostCode.text,
//             HomeCountry,
//             
//             txtOfficeAddr1.text,
//             txtOfficeAddr2.text,
//             txtOfficeAddr3.text,
//             txtOfficeTown.text,
//             SelectedOfficeStateCode,
//             txtOfficePostcode.text,
//             OffCountry,
//             
//             contact1,
//             contact2,
//             contact3,
//             contact4,
//             txtEmail.text,
//             ClientSmoker,
//             str_counter,
//             prospectprofile.ProspectID];
//            
//        }
//    }
//    
//    [db close];
    
    //********* END ***************  UPDATE CLIENT OF LA1, LA2, PO IN EAPP   *********************************
    
}

-(NSString*) getTitleCode : (NSString*)Title
{
    NSString *Code;
    Title = [Title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    [db open];
    
    FMResultSet *result = [db executeQuery:@"SELECT TitleCode FROM eProposal_Title WHERE TitleDesc = ?", Title];
    
    NSInteger *count = 0;
    while ([result next]) {
        count = count + 1;
        Code =[result objectForColumnName:@"TitleCode"];
    }
    
    [result close];
    [db close];
    
    if (count == 0) {
        if (Title.length > 0) {
            if ([Title isEqualToString:@"- SELECT -"] || [Title isEqualToString:@"- Select -"]) {
                Code = @"";
            } else {
                Code = Title;
            }
        }
    }
    return Code;
}

#pragma mark Validation

- (bool)validationDataReferral{
    bool valid=true;
    NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@"- SELECT -",@"- Select -", nil];
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    
    //validation message data refferal
    NSString *validationNIP=@"NIP harus diisi";
    NSString *validationNamaReferral=@"Nama Referral harus diisi";
    NSString *validationSumberReferral=@"Sumber Referral harus diisi";
    NSString *validationKodeCabang=@"Kode Cabang harus diisi";
    NSString *validationNamaCabang=@"Nama Cabang harus diisi";
    NSString *validationKCU=@"KCU harus diisi";
    //textNIP
    NSString* NIP=txtNip.text;
    //outlet sumber referral
    NSString* refSource=outletReferralSource.titleLabel.text;
    //outletkodecabang
    NSString* branchCode=txtBranchCode.text;
    //outletnamacabang
    NSString* branchName=txtBranchName.text;
    //textKCU
    NSString* KCU=txtKcu.text;
    
    if ([validationSet containsObject:NIP]||NIP==NULL){
        [self createAlertViewAndShow:validationNIP tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:refSource]||refSource==NULL){
        [self createAlertViewAndShow:validationSumberReferral tag:0];
        [outletReferralSource setBackgroundColor:[UIColor redColor]];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:branchCode]||branchCode==NULL){
        [self createAlertViewAndShow:validationKodeCabang tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:branchName]||branchName==NULL){
        [self createAlertViewAndShow:validationNamaCabang tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:KCU]||KCU==NULL){
        [self createAlertViewAndShow:validationKCU tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        [txtKcu becomeFirstResponder];
        return false;
    }
    /*else if ([validationSet containsObject:refName]||refName==NULL){
     [self createAlertViewAndShow:validationNamaReferral tag:0];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     [txtReferralName becomeFirstResponder];
     return false;
     }*/
    return valid;
}

- (bool)validationDataPribadi{
    bool valid=true;
    NSArray* validationSet=[[NSArray alloc]initWithObjects:@"",@"- SELECT -",@"- Select -", nil];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    
    //validation message data pribadi
    NSString *validationNamaLengkap=@"Nama lengkap harus diisi";
    NSString *validationJenisKelamin=@"Jenis Kelamin harus diisi";
    NSString *validationTanggalLahir=@"Tanggal lahir harus diisi";
    NSString *validationNoHP=@"No HP harus diisi";
    
    NSString *validationJenisIdentitas=@"Jenis identitas harus diisi";
    NSString *validationNomorIdentitas=@"Nomor identitas harus diisi";
    NSString *validationKebangsaan=@"Kewarganegaraan harus diisi";
    
    //textnamalengkap
    NSString* fullName=txtProspectFullName.text;
    //segmen jenis kelamin
    //segGender.selectedSegmentIndex
    //outletDOB
    NSString* dob=outletDoB.titleLabel.text;

    //outletnationality
    NSString* outletnationality=nationality;
    
    if ([validationSet containsObject:fullName]||fullName==NULL){
        [self createAlertViewAndShow:validationNamaLengkap tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        [txtProspectFullName becomeFirstResponder];
        return false;
    }
    else if (segGender.selectedSegmentIndex==UISegmentedControlNoSegment){
        [self createAlertViewAndShow:validationJenisKelamin tag:0];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    else if ([validationSet containsObject:dob]||dob==NULL){
        [self createAlertViewAndShow:validationTanggalLahir tag:0];
        [outletDoB setBackgroundColor:[UIColor redColor]];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    /*else if ([validationSet containsObject:otheridtype]||otheridtype==NULL){
     [self createAlertViewAndShow:validationJenisIdentitas tag:0];
     [OtherIDType setBackgroundColor:[UIColor redColor]];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     return false;
     }
     else if ([validationSet containsObject:otheridtext]||otheridtext==NULL){
     [self createAlertViewAndShow:validationNomorIdentitas tag:0];
     [txtOtherIDType becomeFirstResponder];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     return false;
     }
     else if ([validationSet containsObject:outletexpirydate]||outletexpirydate==NULL){
     [self createAlertViewAndShow:validationTanggalKadaluarsaIdentitas tag:0];
     [outletExpiryDate setBackgroundColor:[UIColor redColor]];
     [ClientProfile setObject:@"NO" forKey:@"TabBar"];
     return false;
     }*/
    
    else if ([validationSet containsObject:outletnationality]||outletnationality==NULL){
        [self createAlertViewAndShow:validationKebangsaan tag:0];
        [segNationality setBackgroundColor:[UIColor redColor]];
        [ClientProfile setObject:@"NO" forKey:@"TabBar"];
        return false;
    }
    return valid;
}

- (void)createAlertViewAndShow:(NSString *)message tag:(int)alertTag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                    message:[NSString stringWithFormat:@"%@",message]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    alert.tag = alertTag;
    [alert show];
}

#pragma mark - Action
- (IBAction)actionEmployeeNip:(UIButton *)sender;
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    //if (_branchInfo == nil) {
    _nipInfo = [[NIPInfo alloc] initWithStyle:UITableViewStylePlain];
    _nipInfo.delegate = self;
    //[_branchInfo setData:[NSNumber numberWithInt:sender.tag]];
    [_nipInfo.tableView reloadData];
    _nipInfoPopover = [[UIPopoverController alloc] initWithContentViewController:_nipInfo];
    //}
    [_nipInfoPopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)actionBranchInfo:(UIButton *)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    //if (_branchInfo == nil) {
    _branchInfo = [[BranchInfo alloc] initWithStyle:UITableViewStylePlain];
    _branchInfo.delegate = self;
    [_branchInfo setData:[NSNumber numberWithInt:sender.tag]];
    [_branchInfo.tableView reloadData];
    _branchInfoPopover = [[UIPopoverController alloc] initWithContentViewController:_branchInfo];
    //}
    [_branchInfoPopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)actionReferralSource:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_referralSource == nil) {
        _referralSource = [[ReferralSource alloc] initWithStyle:UITableViewStylePlain];
        _referralSource.delegate = self;
        _referralSourcePopover = [[UIPopoverController alloc] initWithContentViewController:_referralSource];
    }
    [_referralSourcePopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ActionGender:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segGender selectedSegmentIndex]==0) {
        gender = @"MALE";
    } else if([segGender selectedSegmentIndex]==1) {
        gender = @"FEMALE";
    }
}

- (IBAction)ActionNationality:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segNationality selectedSegmentIndex]==0) {
        nationality = @"WNI";
    } else if([segGender selectedSegmentIndex]==1) {
        nationality = @"WNA";
    }
}

- (IBAction)btnDOB:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString;
    if ([outletDoB.titleLabel.text length]>0){
        dateString= outletDoB.titleLabel.text;
    }
    else{
        dateString= [dateFormatter stringFromDate:[NSDate date]];
    }
    
    
    /*outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     
     if([txtDOB.text isEqualToString:@""]) {
     [outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", dateString] forState:UIControlStateNormal];
     txtDOB.text = dateString;
     } else {
     [outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", outletDOB.titleLabel.text] forState:UIControlStateNormal];
     }*/
    
    if (_SIDate == Nil) {
        UIStoryboard *clientProfileStoryBoard = [UIStoryboard storyboardWithName:@"ClientProfileStoryboard" bundle:nil];
        self.SIDate = [clientProfileStoryBoard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    _SIDate.ProspectDOB = dateString;
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:NO];
    
    //dateFormatter = Nil;
    //dateString = Nil;
}

- (IBAction)actionCountryOfBirth:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    [ClientProfile setObject:@"YES" forKey:@"isNew"];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    _Country2List = [[Country2 alloc] initWithStyle:UITableViewStylePlain];
    _Country2List.delegate = self;
    _country2Popover = [[UIPopoverController alloc] initWithContentViewController:_Country2List];
    
    [_country2Popover presentPopoverFromRect:[sender bounds]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(IBAction)ActionContinue:(id)sender {
    UIAlertView *continueAlert = [[UIAlertView alloc] initWithTitle:@"Data Nasabah tersimpan" message:@"Apakah Anda ingin melanjutkan proses?" delegate:self cancelButtonTitle:@"Lanjut" otherButtonTitles: @"Jadwalkan Meeting", nil];
    [continueAlert setTag:CONTINUE_ALERT_TAG];
    [continueAlert show];
}

#pragma mark - delegate
-(void)selectedNIP:(NSString *)nipNumber Name:(NSString *)name{
    [txtNip setText:nipNumber];
    [txtReferralName setText:name];
    [_nipInfoPopover dismissPopoverAnimated:YES];
}

-(void)selectedBranch:(NSString *)branchCode BranchName:(NSString *)branchName BranchStatus:(NSString *)branchStatus BranchKanwil:(NSString *)branchKanwil {
    txtBranchCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtBranchName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [txtBranchCode setText:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",branchCode]];
    [txtBranchName setText:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",branchName]];
    [txtBranchCode setBackgroundColor:[UIColor clearColor]];
    //[outletBranchName setBackgroundColor:[UIColor clearColor    ]];
    [txtKcu setText:branchStatus];
    [txtKanwil setText:branchKanwil];
    [_branchInfoPopover dismissPopoverAnimated:YES];
}

-(void) selectedReferralSource:(NSString *)referralSource {
    outletReferralSource.titleLabel.text = referralSource;
    if([referralSource isEqualToString:@"- SELECT -"]) {
        outletReferralSource.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    } else {
        outletReferralSource.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    [outletReferralSource setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@",referralSource]forState:UIControlStateNormal];
    [outletReferralSource setBackgroundColor:[UIColor clearColor]];
    [_referralSourcePopover dismissPopoverAnimated:YES];
}

-(void) DateSelected:(NSString *)strDate :(NSString *)dbDate {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    NSDate *d = [NSDate date];
    NSDate* d2 = [df dateFromString:strDate];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    NSString        *clientDateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateFormatter* clientDateFormmater = [[NSDateFormatter alloc] init];
    [clientDateFormmater setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    clientDateString = [clientDateFormmater stringFromDate:d2];
    
    //KY
    
    if ([d compare:d2] == NSOrderedAscending){
        NSString *validationTanggalLahirFuture=@"Tanggal lahir tidak dapat lebih besar dari tanggal hari ini";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" "
                                                            message:validationTanggalLahirFuture delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
    } else{
        outletDoB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //[outletDOB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
        [outletDoB setTitle:[[NSString stringWithFormat:@""] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
        [outletDoB setBackgroundColor:[UIColor clearColor]];
    }
    
    df = Nil, d = Nil, d2 = Nil;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == CONTINUE_ALERT_TAG) {
        if(buttonIndex == 0) {
            //Pressed "Lanjutkan"
            [self.navigationController popViewControllerAnimated:YES];
            [dashboardVC actionActivityView];
            
        } else {
            //Pressed "Jadwalkan Meeting"
            SAMMeetingScheduleViewController *samMeetingScheduleVC = [[SAMMeetingScheduleViewController alloc] initWithNibName:@"SAMMeetingScheduleViewController" bundle:nil];
            [samMeetingScheduleVC setModalPresentationStyle:UIModalPresentationFormSheet];
            samMeetingScheduleVC.preferredContentSize = CGSizeMake(703, 306);
            [self presentViewController:samMeetingScheduleVC animated:YES completion:nil];
        }
    }
}

@end
