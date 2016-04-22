//
//  IlustrationSignatureViewController.h
//  BLESS
//
//  Created by Basvi on 4/12/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mySmoothLineView.h"

@protocol SignatureDelegate
-(void)capturedSignature:(UIImage *)customerSignature AgentSignature:(UIImage *)agentSignature;
@end

@interface IlustrationSignatureViewController : UIViewController{
    id <SignatureDelegate> _delegate;
    
    IBOutlet mySmoothLineView *viewToSign;
    IBOutlet UILabel *labelSigner;
    
    CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
    CGRect imageFrame;
    BOOL fingerMoved;
}
@property (nonatomic, strong) id <SignatureDelegate> delegate;
@end
