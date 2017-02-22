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
#import "BCHTTPTransfer.h"

@interface ProgressBar : UIViewController<ProductInfoItemsDelegate>{
    ProductInfoItems *FTPitems;
    BCHTTPTransfer *HTTPitems;
}

//general properties
@property (nonatomic,strong)UIProgressView *progressView;
@property (nonatomic,retain)NSString *TitleFileName;
@property (nonatomic,retain)NSString *TitleProgressBar;
@property (nonatomic,retain)NSString *TransferFunction;
@property int TransferMode;

//ftp properties
@property (nonatomic,retain)NSString *ftpfiletoUpload;
@property (nonatomic,retain)NSString *ftpfiletoDownload;
@property (nonatomic,retain)NSString *ftpfolderdestination;

//http properties
@property (nonatomic,retain)NSString *HTTPURLFilePath;
@property (nonatomic,retain)NSString *HTTPLocalFilePath;
@property float HTTPFileSize;

@property (nonatomic, assign) id<ProgressBarDelegate>  progressDelegate;
@end
