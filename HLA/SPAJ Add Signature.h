//
//  SPAJ Add Signature.h
//  BLESS
//
//  Created by Basvi on 7/15/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SPAJAddSignatureDelegate
    -(NSString *)voidGetEAPPNumber;
@end

@interface SPAJ_Add_Signature : UIViewController <UITextFieldDelegate>

// PROTOCOL

@property (nonatomic,strong) id <SPAJAddSignatureDelegate> SPAJAddSignatureDelegate;
@property (strong, nonatomic) NSDictionary* dictTransaction;
@property(strong,nonatomic)UITextField *textFieldLocation;
@property(nonatomic, strong)UIAlertAction* okAction;
@end
