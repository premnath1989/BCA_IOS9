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

@property (nonatomic,weak) id <SPAJAddSignatureDelegate> SPAJAddSignatureDelegate;
@property (weak, nonatomic) NSDictionary* dictTransaction;
@property(weak,nonatomic)UITextField *textFieldLocation;
@property(nonatomic, weak)UIAlertAction* okAction;
@end
