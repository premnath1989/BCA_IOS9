//
//  CFFValidation.h
//  BLESS
//
//  Created by Basvi on 6/22/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFFValidation : NSObject
@property (strong, nonatomic) NSNumber* prospectProfileID;
@property (strong, nonatomic) NSNumber* cffTransactionID;

-(bool)validateSpouse:(NSDictionary *)dictSpouse;
-(bool)validateChild:(NSDictionary *)dictChild;
-(bool)IdentityValidation:(NSString *)originID CompareWith:(NSString *)idToCompare;
-(bool)validateOtherIDNumber:(UIButton *)buttonOtherIDType TextIDNumber:(UITextField *)textIDNumber IDNasabah:(NSString *)idNasabah IDTypeCodeSelected:(NSString *)idTypeCodeSelected;
-(bool)validateOtherIDNumberForChild:(UIButton *)buttonOtherIDType TextIDNumber:(UITextField *)textIDNumber IDNasabah:(NSString *)idNasabah IDTypeCodeSelected:(NSString *)idTypeCodeSelected;
@end
