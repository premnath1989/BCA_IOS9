//
//  ProgressBar.h
//  BLESS
//
//  Created by Erwin Lim  on 3/29/16.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoItems.h"
#import "ProgressBarDelegate.h"

@interface ProgressBar : UIViewController<ProductInfoItemsDelegate>{
    ProductInfoItems *FTPitems;
}

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,retain)NSString *TitleFileName;
@property float TotalFileSize;

@property (nonatomic, assign) id<ProgressBarDelegate>  progressDelegate;
@end