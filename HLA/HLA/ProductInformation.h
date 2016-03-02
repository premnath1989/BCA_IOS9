//
//  ProductInformation.h
//  BLESS
//
//  Created by Erwin on 01/03/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@interface ProductInformation : UIViewController<ReaderViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnHome;
@property (weak, nonatomic) IBOutlet UIButton *btnPDF;

- (IBAction)goHome:(id)sender;
- (IBAction)seePDF:(id)sender;

@end
