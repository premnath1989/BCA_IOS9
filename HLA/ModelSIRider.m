//
//  ModelSIRider.m
//  MPOS
//
//  Created by Basvi on 3/23/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ModelSIRider.h"

@implementation ModelSIRider
-(void)saveRider:(NSDictionary *)dataRider{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    BOOL success = [database executeUpdate:@"insert into SI_Temp_Trad_Rider (SINo, RiderCode, RiderName, SumAssured,MasaAsuransi,Unit,ExtraPremiPercent,ExtraPremiMil,MasaExtraPremi,ExtraPremiRp,PremiRp) values (?,?,?,?,?,?,?,?,?,?,?)" ,
                    [dataRider valueForKey:@"SINO"],
                    [dataRider valueForKey:@"RiderCode"],
                    [dataRider valueForKey:@"RiderName"],
                    [dataRider valueForKey:@"SumAssured"],
                    [dataRider valueForKey:@"MasaAsuransi"],
                    [dataRider valueForKey:@"Unit"],
                    [dataRider valueForKey:@"ExtraPremiPerCent"],
                    [dataRider valueForKey:@"ExtraPremiPerMil"],
                    [dataRider valueForKey:@"MasaExtraPremi"],
                    [dataRider valueForKey:@"ExtraPremiRp"],
                    [dataRider valueForKey:@"PremiRp"]];
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(void)updateRider:(NSDictionary *)dataRider{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"update SI_Temp_Trad_Rider set SumAssured=?, MasaAsuransi=?, Unit=?,ExtraPremiPercent=?,ExtraPremiMil=?,MasaExtraPremi=?,ExtraPremiRp=?,PremiRp=? where SINo=? and RiderCode=?" ,
                    [dataRider valueForKey:@"SumAssured"],
                    [dataRider valueForKey:@"MasaAsuransi"],
                    [dataRider valueForKey:@"Unit"],
                    [dataRider valueForKey:@"ExtraPremiPerCent"],
                    [dataRider valueForKey:@"ExtraPremiPerMil"],
                    [dataRider valueForKey:@"MasaExtraPremi"],
                    [dataRider valueForKey:@"ExtraPremiRp"],
                    [dataRider valueForKey:@"PremiRp"],
                    [dataRider valueForKey:@"SINO"],
                    [dataRider valueForKey:@"RiderCode"]];
    NSLog(@"%@",[NSString stringWithFormat:@"update SI_Temp_Trad_Rider set SumAssured=%@, MasaAsuransi=%@, Unit=%@,ExtraPremiPercent=%@,ExtraPremiMil=%@,MasaExtraPremi=%@,ExtraPremiRp=%@,PremiRp=%@ where SINo=%@ and RiderCode=%@" ,
                 [dataRider valueForKey:@"SumAssured"],
                 [dataRider valueForKey:@"MasaAsuransi"],
                 [dataRider valueForKey:@"Unit"],
                 [dataRider valueForKey:@"ExtraPremiPerCent"],
                 [dataRider valueForKey:@"ExtraPremiPerMil"],
                 [dataRider valueForKey:@"MasaExtraPremi"],
                 [dataRider valueForKey:@"ExtraPremiRp"],
                 [dataRider valueForKey:@"PremiRp"],
                 [dataRider valueForKey:@"SINO"],
                 [dataRider valueForKey:@"RiderCode"]]);
    
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}

-(int)getRiderCount:(NSString *)SINo RiderCode:(NSString *)riderCode{
    int count;
    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select count(*) from SI_Temp_Trad_Rider where SINo = \"%@\" and RiderCode=\"%@\"",SINo,riderCode]];
    NSLog(@"query %@",[NSString stringWithFormat:@"select count(*) from SI_Temp_Trad_Rider where SINO = \"%@\" and RiderCode=\"%@\"",SINo,riderCode]);
    while ([s next]) {
        count = [s intForColumn:@"count(*)"];
    }
    
    [results close];
    [database close];
    return count;
}

-(NSDictionary *)getRider:(NSString *)SINo RiderCode:(NSString *)riderCode{
    NSDictionary *dict;
    
    NSString *SINO;
    NSString *RiderCode;
    NSString *RiderName;
    NSString *SumAssured;
    NSString *MasaAsuransi;
    NSString *Unit;
    NSString *ExtraPremiPerCent;
    NSString *ExtraPremiPerMil;
    NSString *MasaExtraPremi;
    NSString *ExtraPremiRp;
    NSString *PremiRp;

    
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    FMResultSet *s = [database executeQuery:[NSString stringWithFormat:@"select * from SI_Temp_Trad_Rider where SINo = \"%@\" and RiderCode=\"%@\"",SINo,riderCode]];
    //NSLog(@"query %@",[NSString stringWithFormat:@"select * from SI_Premium where SINO = \"%@\" and RiderCode=\"%@\"",SINo,riderCode]);
    while ([s next]) {
        SINO = [s stringForColumn:@"SINo"];
        RiderCode = [s stringForColumn:@"RiderCode"];
        RiderName = [s stringForColumn:@"RiderName"];
        SumAssured = [s stringForColumn:@"SumAssured"];
        MasaAsuransi = [s stringForColumn:@"MasaAsuransi"];
        Unit = [s stringForColumn:@"Unit"];
        ExtraPremiPerCent = [s stringForColumn:@"ExtraPremiPercent"];
        ExtraPremiPerMil = [s stringForColumn:@"ExtraPremiMil"];
        MasaExtraPremi = [s stringForColumn:@"MasaExtraPremi"];
        ExtraPremiRp = [s stringForColumn:@"ExtraPremiRp"];
        PremiRp = [s stringForColumn:@"PremiRp"];
    }
    
    dict=[[NSDictionary alloc]initWithObjectsAndKeys:
          SINO,@"SINO",
          RiderCode,@"RiderCode",
          RiderName,@"RiderName",
          SumAssured,@"SumAssured",
          MasaAsuransi,@"MasaAsuransi",
          Unit,@"Unit",
          ExtraPremiPerCent,@"ExtraPremiPercent",
          ExtraPremiPerMil,@"ExtraPremiMil",
          MasaExtraPremi,@"MasaExtraPremi",
          ExtraPremiRp,@"ExtraPremiRp",
          PremiRp,@"PremiRp",
          nil];
    
    [results close];
    [database close];
    return dict;
}

-(void)deleteRiderData:(NSString *)siNo{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [docsDir stringByAppendingPathComponent: @"hladb.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    BOOL success = [database executeUpdate:@"delete from SI_Temp_Trad_Rider where SINo=?",siNo];
    if (!success) {
        NSLog(@"%s: insert error: %@", __FUNCTION__, [database lastErrorMessage]);
        // do whatever you need to upon error
    }
    [results close];
    [database close];
}


@end
