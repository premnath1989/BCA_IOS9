//
//  ProspectListingTableViewCell.m
//  MPOS
//
//  Created by Basvi on 2/12/16.
//  Copyright © 2016 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ProspectListingTableViewCell.h"

@implementation ProspectListingTableViewCell
@synthesize labelName =_labelName;
@synthesize labelDOB =_labelDOB;
@synthesize labelPhone1 =_labelPhone1;
@synthesize labelBranchName =_labelBranchName;
@synthesize labelDateCreated =_labelDateCreated;
@synthesize labelDateModified =_labelDateModified;
@synthesize labelTimeRemaining =_labelTimeRemaining;
@synthesize labelidNum =_labelidNum;

- (void)awakeFromNib {
    NSLog(@"test");
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    [viewCell addGestureRecognizer:panGestureRecognizer];
    
}

-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        viewCell.center = CGPointMake(viewCell.center.x+ translation.x, viewCell.center.y );
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:panGestureRecognizer.view];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat frameX = viewCell.frame.origin.x;
        if (frameX > -50){
            [UIView animateWithDuration:0.2 animations:^{
                [viewCell setFrame:CGRectMake(0, viewCell.frame.origin.y, viewCell.frame.size.width, viewCell.frame.size.height)];
            }];
        }
        else{
            [UIView animateWithDuration:0.2 animations:^{
                [viewCell setFrame:CGRectMake(-100, viewCell.frame.origin.y, viewCell.frame.size.width, viewCell.frame.size.height)];
            }];
        }
    }
}

-(void)handleSwipeFromLeft{
    
}

-(void)handleSwipeFromRight{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
