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

@implementation SAMNewNasabahViewController {
    BOOL Update_record;
}

@synthesize dashboardVC;
@synthesize txtNip;
@synthesize txtReferralName;
@synthesize txtKcu;
@synthesize txtKanwil;
@synthesize txtBranchCode;
@synthesize txtBranchName;
@synthesize txtProspectFullName;
@synthesize txtProspectId;
@synthesize txtProspectNoHP;
@synthesize txtProspectNoHPPrefix;
@synthesize outletDoB;
@synthesize segNationality;
@synthesize segGender;
@synthesize gender;
@synthesize nationality;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;
@synthesize outletProspectCountryBirthplace;

@synthesize outletReferralSource;

int const CONTINUE_ALERT_TAG = 100;
int const SAVE_SUCCESS_ALERT_TAG = 101;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Selesai" style:UIBarButtonItemStyleBordered target:self action:@selector(saveToDb)];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
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
    [self.view endEditing:YES];
    [self resignFirstResponder];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSString *strDOB = @"";
    NSString *title = @"";
    NSString *strExpiryDate = @"";
    NSString *othertype = @"";
    NSString *marital  = @"";
    NSString *race = @"";
    NSString *Rigdateoutlet = @"";
    NSString *religion = @"";
    NSString *nation  = @"";
    
    NSString *OffCountry = @"";
    NSString *HomeCountry = @"";
    NSString *RegNumber = @"";
    
    NSString *SelectedStateCode = @"";
    NSString *TitleCodeSelected = @"";
    int counter = 0;
    
    /*added by faiz*/
    
    /*end of added by faiz*/
    if ([self ValidateData] == TRUE) {
    
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
            txtProspectFullName.text = [txtProspectFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            if (checked) {
//                HomeCountry = btnHomeCountry.titleLabel.text;
//                SelectedStateCode = txtHomeState.text;
//            } else {
//                HomeCountry = txtHomeCountry.text;
//            }
            
//            RegNumber = txtRigNO.text;
//            Rigdateoutlet = outletRigDate.titleLabel.text;
//            if (checked2) {
//                OffCountry = btnOfficeCountry.titleLabel.text;
//                SelectedOfficeStateCode = txtOfficeState.text;
//            } else {
//                OffCountry = txtOfficeCountry.text;
//            }
            
            if (outletDoB.titleLabel.text.length == 0) {
                strDOB = [outletDoB.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            } else {
                strDOB = outletDoB.titleLabel.text;
            }
            
            if(gender == nil || gender==NULL || segGender.selectedSegmentIndex == -1) {
                gender = @"";
            }
            
            //HomeCountry =  [self getCountryCode:HomeCountry];
            //OffCountry =  [self getCountryCode:OffCountry];
            
            /*modified by faiz*/
            race  = @"OTHERS";//[outletRace.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            
            //ENS: Save othertype with code
            //othertype = IDTypeCodeSelected;
//            othertype = IDTypeIdentifierSelected;
//            if (IDTypeCodeSelected == NULL) {
//                othertype = @"";
//            }
//            
//            NSString *type = [_txtProspectId.text stringByTrimmingCharactersInSet:
//                              [NSCharacterSet whitespaceCharacterSet]];
//            if (type.length != 0) {
//                type = [self getOtherTypeCode:type];
//                othertype = type;
//            }
            
            strDOB = [strDOB stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            
            NSString *insertSQL;
            
            if([othertype isEqualToString:@"- SELECT -"]) {
                othertype = @"";
            }
            
            if([title isEqualToString:@"- SELECT -"]) {
                title = @"";
            }
            
            if([strDOB isEqualToString:@"- SELECT -"] || [strDOB isEqualToString:@"-SELECT-"]) {
                strDOB = @"";
            }
            
            if ([strDOB isEqualToString:@""]
                && [textFields trimWhiteSpaces:outletDoB.titleLabel.text].length != 0
                && ![[textFields trimWhiteSpaces:outletDoB.titleLabel.text] isEqualToString:@"- SELECT -"]
                && ![[textFields trimWhiteSpaces:outletDoB.titleLabel.text] isEqualToString:@"-SELECT-"])
            {
                strDOB = [outletDoB.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            
            if([marital isEqualToString:@"- SELECT -"]) {
                marital = @"";
            }
            
            if([race isEqualToString:@"- SELECT -"]) {
                race = @"";
            }
            
            if([Rigdateoutlet isEqualToString:@"- SELECT -"]) {
                Rigdateoutlet = @"";
            }
            
            if([religion isEqualToString:@"- SELECT -"]) {
                religion = @"";
            }
            
            if([nation isEqualToString:@"- SELECT -"]) {
                nation = @"";
            }
            
            if([HomeCountry isEqualToString:@"(null)"]  || (HomeCountry == NULL)) {
                HomeCountry = @"";
            }
            
            if([SelectedStateCode isEqualToString:@"(null)"]  || (SelectedStateCode == NULL)) {
                SelectedStateCode = @"";
            }
            
            if([TitleCodeSelected isEqualToString:@"(null)"]  || (TitleCodeSelected == NULL)) {
                TitleCodeSelected = @"";
            }
            
            if ([TitleCodeSelected isEqualToString:@""] && ![title isEqualToString:@""]) {
                TitleCodeSelected = [self getTitleCode:title];
            }
            
            NSString *isGrouping = @"N";
            
//            if (segIsGrouping.selectedSegmentIndex == 0) {
//                isGrouping = @"Y";
//                group = [self ProspectGroup_toString];
//            } else {
//                isGrouping = @"N";
//                group = @"";
//            }
            
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [dateFormat dateFromString:strDOB];
            
            // Convert date object to desired output format
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString *newDOB = [dateFormat stringFromDate:date];
            
            NSDateFormatter *expiryDateFormat = [[NSDateFormatter alloc] init];
            [expiryDateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateExpiry = [expiryDateFormat dateFromString:strExpiryDate];
            
            // Convert date object to desired output format
            [expiryDateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString *newExpiryDate = [expiryDateFormat stringFromDate:dateExpiry];
            
            NSLog(@"%@",newDOB);
            
            NSString *genderSeg;
            if(segGender.selectedSegmentIndex == 0){
                genderSeg = @"MALE";
            }else{
                genderSeg = @"FEMALE";
            }
            
            NSString *CountryOfBirth = @"";
            CountryOfBirth = outletProspectCountryBirthplace.titleLabel.text;//btnCoutryOfBirth.titleLabel.text;
            //CountryOfBirth = [self getCountryCode:CountryOfBirth];
            
            
            insertSQL = [NSString stringWithFormat:
                             @"INSERT INTO prospect_profile(\'ProspectName\', \"ProspectDOB\", \"ProspectGender\", \"DateCreated\", \"CreatedBy\", \"DateModified\", \"ModifiedBy\",\"OtherIDType\", \"OtherIDTypeNo\", \"CountryOfBirth\", \"NIP\", \"BranchCode\", \"BranchName\", \"KCU\", \"Kanwil\",\"ReferralSource\", \"ReferralName\", \"QQFlag\") "
                             "VALUES (\"%@\", \"%@\", \"%@\", %@, \"%@\", %@, \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%s\")",
                         txtProspectFullName.text,
                         strDOB,
                         genderSeg,
                         @"datetime(\"now\", \"+7 hour\")",
                         @"1",
                         @"datetime(\"now\", \"+7 hour\")",
                         @"1",
                         @"VID18",  //Hardcode KTP DataIdentifier (found from eProposal_Identification table)
                         txtProspectId.text,
                         CountryOfBirth,
                         txtNip.text,
                         txtBranchCode.text,
                         txtBranchName.text,
                         txtKcu.text,
                         txtKanwil.text,
                         outletReferralSource.titleLabel.text,
                         txtReferralName.text,
                         "false"];
                
            
            
            const char *insert_stmt = [insertSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    [self GetLastID];
                    [self SaveToSAM];
                } else {
                    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting into profile table" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [failAlert show];
                }
                sqlite3_finalize(statement);
            }
            else{
                NSLog(@"query insert %@",insertSQL);
                NSLog(@"could not prepare statement: %s", sqlite3_errmsg(contactDB));
            }
            
            sqlite3_close(contactDB);
            insertSQL = Nil, insert_stmt = Nil;
        }
        
        statement = Nil;
        dbpath = Nil;
    } else {
        NSLog(@"Either validation return false or 'DATE_OK' =  NO");
    }

}

- (void) SaveToSAM {
    //    SAMDBHelper *dbHelper = [[SAMDBHelper alloc] init];
    // [dbHelper InsertSAMData];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"hladb.sqlite"]];
    
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    NSString *lastID;
    
    SAMModel *model = [[SAMModel alloc] init];
    
    NSString *GetLastIdSQL = [NSString stringWithFormat:@"Select indexno  from prospect_profile order by \"indexNo\" desc limit 1"];
    const char *SelectLastId_stmt = [GetLastIdSQL UTF8String];
    if(sqlite3_prepare_v2(contactDB, SelectLastId_stmt, -1, &statement2, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement2) == SQLITE_ROW) {
            lastID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
            sqlite3_finalize(statement2);
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",@"yyyy-MM-dd"]];
    NSString *targetDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString* dateToday = targetDateString;
    
    NSString *insertSAMSQL = [NSString stringWithFormat:@"INSERT INTO SAM_Master(\"SAM_Number\", \"SAM_CustomerID\", \"SAM_Type\", \"SAM_ID_CFF\", \"SAM_ID_ProductRecommendation\", \"SAM_ID_Video\", \"SAM_ID_Illustration\", \"SAM_ID_Application\", \"SAM_DateCreated\", \"SAM_DateModified\", \"SAM_Comments\", \"SAM_Status\", \"SAM_NextMeeting\") VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, lastID, @"Prospect", @"", @"", @"", @"", @"", dateToday, dateToday, @"", @"Follow Up", @""];
    
    const char *insert_stmt = [insertSAMSQL UTF8String];
    if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            model.number = lastID;
            model.customerID = lastID;
            model.customerType = @"Prospect";
            model.dateCreated = dateToday;
            model.dateModified = dateToday;
            model.status = @"Follow Up";
        } else {
            UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Fail in inserting into profile table" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [failAlert show];
        }
        sqlite3_finalize(statement);
    }
    else{
        NSLog(@"query insert %@",insertSAMSQL);
        NSLog(@"could not prepare statement: %s", sqlite3_errmsg(contactDB));
    }
    
    sqlite3_close(contactDB);
}

-(void) GetLastID
{
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *lastID;
    NSString *contactCode;
    
    NSUserDefaults *ClientProfile = [NSUserDefaults standardUserDefaults];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK) {
        NSString *GetLastIdSQL = [NSString stringWithFormat:@"Select indexno  from prospect_profile order by \"indexNo\" desc limit 1"];
        const char *SelectLastId_stmt = [GetLastIdSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, SelectLastId_stmt, -1, &statement2, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement2) == SQLITE_ROW) {
                lastID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                sqlite3_finalize(statement2);
                [ClientProfile setObject:lastID forKey:@"LastID"];
            }
        }
    }
    
    for (int a = 0; a<4; a++) {
        switch (a) {
            case 0:
                contactCode = @"CONT006";
                break;
                
            case 1:
                contactCode = @"CONT008";
                break;
                
            case 2:
                contactCode = @"CONT007";
                break;
                
            case 3:
                contactCode = @"CONT009";
                break;
                
            default:
                break;
        }
        
            if (![contactCode isEqualToString:@""]) {
                NSString *insertContactSQL = @"";
                if (a==0) {
                    insertContactSQL = [NSString stringWithFormat:
                                        @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                        " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, @"", @"N", @""];
                } else if (a==1) {
                    insertContactSQL = [NSString stringWithFormat:
                                        @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                        " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtProspectNoHP.text, @"N", txtProspectNoHPPrefix.text];
                } else if (a==2) {
                    insertContactSQL = [NSString stringWithFormat:
                                        @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                        " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, @"", @"N", @""];
                } else if (a==3) {
                    insertContactSQL = [NSString stringWithFormat:
                                        @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                        " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, @"", @"N", @""];
                }
                
                const char *insert_contactStmt = [insertContactSQL UTF8String];
                if(sqlite3_prepare_v2(contactDB, insert_contactStmt, -1, &statement3, NULL) == SQLITE_OK) {
                    sqlite3_step(statement3);
                    sqlite3_finalize(statement3);
                }
                insert_contactStmt = Nil, insertContactSQL = Nil;
            }
        
    }
    
    UIAlertView *SuccessAlert;
    if(Update_record == YES) {
        if (![[ClientProfile objectForKey:@"TabBar"] isEqualToString:@"YES"]) {
            SuccessAlert = [[UIAlertView alloc] initWithTitle:@" "
                                                      message:@"Perubahan berhasil disimpan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        }
        SuccessAlert.tag = 1;
        [SuccessAlert show];
        [ClientProfile setObject:@"NO" forKey:@"isNew"];
        
    } else {
        if (![[ClientProfile objectForKey:@"TabBar"] isEqualToString:@"YES"]) {
            SuccessAlert = [[UIAlertView alloc] initWithTitle:@" "
                                                      message:@"Data Nasabah telah berhasil disimpan" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        }
        SuccessAlert.tag = SAVE_SUCCESS_ALERT_TAG;
        [SuccessAlert show];
        [ClientProfile setObject:@"NO" forKey:@"isNew"];
    }
    
    statement2 = Nil;
    statement3 = Nil;
    lastID = Nil;
    contactCode = Nil;
    dbpath = Nil;
    
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

- (bool) ValidateData {
    bool returnBool = [self validationDataReferral] && [self validationDataPribadi];
    
    return returnBool;
}

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

-(IBAction)ActionContinue:(id)sender {
    [self saveToDb];
    UIAlertView *continueAlert = [[UIAlertView alloc] initWithTitle:@"Data Nasabah tersimpan" message:@"Apakah Anda ingin melanjutkan proses?" delegate:self cancelButtonTitle:@"Lanjut" otherButtonTitles: @"Jadwalkan Meeting", nil];
    [continueAlert setTag:CONTINUE_ALERT_TAG];
    [continueAlert show];
}

#pragma mark - delegate
-(void) selectedNIP:(NSString *)nipNumber Name:(NSString *)name{
    [txtNip setText:nipNumber];
    [txtReferralName setText:name];
    [_nipInfoPopover dismissPopoverAnimated:YES];
}

-(void) selectedBranch:(NSString *)branchCode BranchName:(NSString *)branchName BranchStatus:(NSString *)branchStatus BranchKanwil:(NSString *)branchKanwil {
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

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [_SIDatePopover dismissPopoverAnimated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIAlertView *continueAlert;
    switch (alertView.tag) {
        case SAVE_SUCCESS_ALERT_TAG:
            continueAlert = [[UIAlertView alloc] initWithTitle:@"Data Nasabah tersimpan" message:@"Apakah Anda ingin melanjutkan proses?" delegate:self cancelButtonTitle:@"Lanjut" otherButtonTitles: @"Jadwalkan Meeting", nil];
            [continueAlert setTag:CONTINUE_ALERT_TAG];
            [continueAlert show];
            break;
        case CONTINUE_ALERT_TAG:
            if(buttonIndex == 0) {
                //Pressed "Lanjutkan"
                [self.navigationController popViewControllerAnimated:YES];
                //            [dashboardVC actionActivityView];
                
            } else {
                //Pressed "Jadwalkan Meeting"
                [self.navigationController popViewControllerAnimated:YES];
                SAMMeetingScheduleViewController *samMeetingScheduleVC = [[SAMMeetingScheduleViewController alloc] initWithNibName:@"SAMMeetingScheduleViewController" bundle:nil];
                [samMeetingScheduleVC setModalPresentationStyle:UIModalPresentationFormSheet];
                samMeetingScheduleVC.preferredContentSize = CGSizeMake(703, 306);
                [self presentViewController:samMeetingScheduleVC animated:YES completion:nil];
            }
            break;
        default:
            break;
    }
}

@end
