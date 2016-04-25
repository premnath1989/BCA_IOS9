//
//  mySmoothLineView.h
//  MPOS
//
//  Created by Basvi on 4/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mySmoothLineView : UIView

@property (nonatomic)int touchMove;
@property (strong, atomic)UIImage *incrementalImage;
-(void)clearView;

@end
