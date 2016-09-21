//
//  TextFieldSPAJ.h
//  BLESS
//
//  Created by Basvi on 9/21/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldSPAJ : UITextField
@property (strong, nonatomic) NSString* textFieldName;

-(void)setTextFieldName:(NSString *)stringTextFieldName;
-(NSString *)getTextFieldName;
@end
