//
//  TextViewSPAJ.h
//  BLESS
//
//  Created by Basvi on 9/23/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewSPAJ : UITextView
@property (strong, nonatomic) NSString* textViewName;

-(void)setTextViewName:(NSString *)stringTextViewName;
-(NSString *)getTextViewName;

@end
