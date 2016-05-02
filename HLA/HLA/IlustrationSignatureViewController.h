//
//  IlustrationSignatureViewController.h
//  BLESS
//
//  Created by Basvi on 4/12/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mySmoothLineView.h"
#import "Formatter.h"

@protocol SignatureDelegate
-(void)capturedSignature:(UIImage *)customerSignature AgentSignature:(UIImage *)agentSignature;
@end

@interface IlustrationSignatureViewController : UIViewController{
    Formatter *formatter;
    id <SignatureDelegate> _delegate;
    
    IBOutlet UIView *viewBorder;
    IBOutlet mySmoothLineView *viewToSign;
    IBOutlet UILabel *labelSigner;
    IBOutlet UILabel *labelAgreement;
    IBOutlet UILabel *labelName;
    
    CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
    CGRect imageFrame;
    BOOL fingerMoved;
}
@property (nonatomic, strong) id <SignatureDelegate> delegate;
@property (nonatomic,retain)NSString *AgentName;
@property (nonatomic,retain)NSString *AgentID;
@property (nonatomic,retain)NSString *POName;
@property (nonatomic,retain)NSString *POKtp;
@end
